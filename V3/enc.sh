#!/bin/bash
# (c) J~Net 2025
# Hybrid RSA + AES Encryption Utility v3 (Filename-Preserving, Single File Mode)
# (Ubuntu/RPi ARM64)
set -e

generate_keys(){
  echo "Generating 4096-bit RSA keypair..."
  [ -f private_key.pem ] && read -p "private_key.pem exists. Overwrite? [y/N]: " ans && [[ $ans != [yY] ]] && return
  openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:4096
  openssl rsa -in private_key.pem -pubout -out public_key.pem
  echo "Keypair generated: public_key.pem & private_key.pem"
}

encrypt_file(){
  if [ ! -f private_key.pem ];then echo "Error: private_key.pem not found!";return;fi
  if [ ! -f public_key.pem ];then echo "Error: public_key.pem not found!";return;fi

  read -p "Enter file to encrypt [default: plaintext.txt]: " plaintext
  plaintext=${plaintext:-plaintext.txt}
  [ ! -f "$plaintext" ] && { echo "File '$plaintext' not found!"; return; }

  filename=$(basename "$plaintext")
  echo "Encrypting: $filename"

  echo "Generating random AES key..."
  openssl rand -out aes_key.bin 32

  echo "Encrypting AES key with RSA..."
  openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in aes_key.bin -out rsa_encrypted.bin

  echo "Encrypting file with AES..."
  openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -in "$plaintext" -out encrypted_aes.bin -pass file:./aes_key.bin

  echo "Combining files into single package..."
  {
    printf "%s\n" "$filename"
    base64 rsa_encrypted.bin
    echo "---RSA_END---"
    base64 encrypted_aes.bin
    echo "---AES_END---"
  } > combined_encrypted.bin

  rm -f aes_key.bin rsa_encrypted.bin encrypted_aes.bin
  echo "Encryption complete!"
  echo "Output file: combined_encrypted.bin"
}

decrypt_file(){
  if [ ! -f private_key.pem ];then echo "Error: private_key.pem not found!";return;fi

  read -p "Enter combined encrypted file [default: combined_encrypted.bin]: " combo
  combo=${combo:-combined_encrypted.bin}
  [ ! -f "$combo" ] && { echo "File '$combo' not found!"; return; }

  echo "Extracting components..."
  filename=$(head -n 1 "$combo")
  tmpdir=$(mktemp -d)
  sed -n '/^---RSA_END---/q;p' "$combo" | tail -n +2 | base64 -d > "$tmpdir/rsa_encrypted.bin"
  sed -n '/^---RSA_END---/,$p' "$combo" | sed -n '/^---AES_END---/q;p' | tail -n +2 | base64 -d > "$tmpdir/encrypted_aes.bin"

  echo "Decrypting AES key..."
  openssl pkeyutl -decrypt -inkey private_key.pem -in "$tmpdir/rsa_encrypted.bin" -out "$tmpdir/decrypted_key.bin" || { echo "Error: Failed to decrypt AES key."; rm -rf "$tmpdir"; return; }

  echo "Decrypting file..."
  output_file="$filename"
  [ -f "$output_file" ] && read -p "$output_file exists. Overwrite? [y/N]: " ans && [[ $ans != [yY] ]] && { rm -rf "$tmpdir"; return; }

  openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -in "$tmpdir/encrypted_aes.bin" -out "$output_file" -pass file:"$tmpdir/decrypted_key.bin" || { echo "Error: Failed to decrypt file."; rm -rf "$tmpdir"; return; }

  rm -rf "$tmpdir"
  echo "Decryption complete!"
  echo "Restored original file: $output_file"
}

while true;do
  echo ""
  echo "=============================="
  echo "   J~Net Encryption Utility v3"
  echo "=============================="
  echo "1) Generate new RSA keypair"
  echo "2) Encrypt a file (combined mode)"
  echo "3) Decrypt combined file"
  echo "4) Exit"
  echo "------------------------------"
  read -p "Select option [1-4]: " choice
  case $choice in
    1) generate_keys ;;
    2) encrypt_file ;;
    3) decrypt_file ;;
    4) echo "Exiting..."; break ;;
    *) echo "Invalid option!" ;;
  esac
done

