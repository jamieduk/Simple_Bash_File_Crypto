#!/bin/bash
# (c) J~Net 2025
# Hybrid RSA + AES Encryption Utility (Ubuntu/RPi ARM64)
set -e

generate_keys(){
  echo "Generating 4096-bit RSA keypair..."
  [ -f private_key.pem ] && read -p "private_key.pem exists. Overwrite? [y/N]: " ans && [[ $ans != [yY] ]] && return
  openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:4096
  openssl rsa -in private_key.pem -pubout -out public_key.pem
  echo "Keypair generated: public_key.pem & private_key.pem"
}

encrypt_file(){
    if [ ! -f private_key.pem ]; then
      echo "Error: private_key.pem not found! Please generate keys first using option 1."
      return
    fi

    if [ ! -f public_key.pem ]; then
      echo "Error: public_key.pem not found! Please generate keys first using option 1."
      return
    fi
    
  read -p "Enter file to encrypt [default: plaintext.txt]: " plaintext
  plaintext=${plaintext:-plaintext.txt}
  [ ! -f "$plaintext" ] && { echo "File '$plaintext' not found!"; return; }

  echo "Generating random AES key..."
  openssl rand -out aes_key.bin 32

  # RSA-encrypted AES key
  [ -f rsa_encrypted.bin ] && read -p "rsa_encrypted.bin exists. Overwrite? [y/N]: " ans && [[ $ans != [yY] ]] && return
  openssl rsautl -encrypt -inkey public_key.pem -pubin -in aes_key.bin -out rsa_encrypted.bin

  # AES-encrypted plaintext
  [ -f encrypted_aes.bin ] && read -p "encrypted_aes.bin exists. Overwrite? [y/N]: " ans && [[ $ans != [yY] ]] && return
  openssl enc -aes-256-cbc -in "$plaintext" -out encrypted_aes.bin -pass file:./aes_key.bin

  rm -f aes_key.bin
  echo "Encryption complete!"
  echo "Output files: rsa_encrypted.bin + encrypted_aes.bin"
}

decrypt_file(){
  if [ ! -f private_key.pem ]; then
    echo "Error: private_key.pem not found! Please generate keys first using option 1."
    return
  fi

  read -p "Enter RSA-encrypted key file [default: rsa_encrypted.bin]: " rsa_file
  rsa_file=${rsa_file:-rsa_encrypted.bin}
  [ ! -f "$rsa_file" ] && { echo "File '$rsa_file' not found!"; return; }

  read -p "Enter AES-encrypted file [default: encrypted_aes.bin]: " aes_file
  aes_file=${aes_file:-encrypted_aes.bin}
  [ ! -f "$aes_file" ] && { echo "File '$aes_file' not found!"; return; }

  echo "Decrypting AES key..."
  openssl rsautl -decrypt -inkey private_key.pem -in "$rsa_file" -out decrypted_key.bin || { echo "Error: Failed to decrypt AES key."; rm -f decrypted_key.bin; return; }

  output_file="decrypted_file"
  [ -f "$output_file" ] && read -p "$output_file exists. Overwrite? [y/N]: " ans && [[ $ans != [yY] ]] && return

  echo "Decrypting file..."
  openssl enc -d -aes-256-cbc -in "$aes_file" -out "$output_file" -pass file:./decrypted_key.bin || { echo "Error: Failed to decrypt file."; rm -f decrypted_key.bin; return; }

  rm -f decrypted_key.bin
  echo "Decryption complete!"
  echo "Decrypted output: $output_file"
}


while true; do
  echo ""
  echo "=============================="
  echo "   J~Net Encryption Utility"
  echo "=============================="
  echo "1) Generate new RSA keypair"
  echo "2) Encrypt a file"
  echo "3) Decrypt a file"
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

