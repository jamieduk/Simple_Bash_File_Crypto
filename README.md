# Simple File Encryption / Decryption for Bash  
**By J~Net 2025**  

https://github.com/jamieduk/Simple_Bash_File_Crypto  

This project provides a simple file encryption and decryption utility written in Bash for Ubuntu / Raspberry Pi ARM64 systems. It uses **RSA + AES hybrid encryption** to secure files and is designed to be easy to use with minimal dependencies.

---

## Features

- Generate **4096-bit RSA keypair** (`private_key.pem` & `public_key.pem`)  
- Encrypt files using **AES-256-CBC** with the AES key secured via RSA  
- Decrypt files encrypted by this utility  
- Default files for encryption/decryption for quick usage (`plaintext.txt`, `encrypted_aes.bin`, `rsa_encrypted.bin`)  
- Overwrite protection with prompts for existing files  
- Fully compatible with Ubuntu 22.04+ and Raspberry Pi ARM64  

---

## Installation & Usage

1. Make scripts executable:

```bash
sudo chmod +x *.sh
Run the setup script to install dependencies:

bash
Copy code
./setup.sh
This installs OpenSSL (if not present) and required libraries for RSA + AES operations.

Run the encryption utility:

bash
Copy code
./enc.sh
Usage Instructions
Main Menu
markdown
Copy code
==============================
   J~Net Encryption Utility
==============================
1) Generate new RSA keypair
2) Encrypt a file
3) Decrypt a file
4) Exit
------------------------------
Select option [1-4]:
1) Generate new RSA keypair
Generates private_key.pem and public_key.pem

Warns before overwriting existing keys

2) Encrypt a file
Prompts for plaintext file (default: plaintext.txt)

Generates a random AES key

Encrypts the AES key using RSA (rsa_encrypted.bin)

Encrypts the plaintext using AES (encrypted_aes.bin)

Warns before overwriting existing output files

3) Decrypt a file
Prompts for RSA-encrypted AES key file (default: rsa_encrypted.bin)

Prompts for AES-encrypted file (default: encrypted_aes.bin)

Decrypts the AES key, then decrypts the file

Output: decrypted_plaintext.txt (warns if exists)

4) Exit
Exits the utility

Notes
Designed for offline use on Ubuntu / Raspberry Pi ARM64

Requires openssl installed via setup.sh

Defaults simplify first-time usage; advanced users can specify file names manually

Fully compatible with standard Bash; no Python or external runtime required

Example Workflow
bash
Copy code
# Make scripts executable
sudo chmod +x *.sh

# Install dependencies
./setup.sh

# Run encryption utility
./enc.sh

# Generate keys (option 1)
# Encrypt a file (option 2)
# Decrypt a file (option 3)
License
MIT License - feel free to modify and distribute

Author
J~Net, 2025
https://github.com/jamieduk
