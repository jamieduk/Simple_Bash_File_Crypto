# Simple File Encryption / Decryption for Bash  
**By J~Net 2025**  

🔗 https://github.com/jamieduk/Simple_Bash_File_Crypto  

This project provides a suite of **Bash-based hybrid RSA + AES file encryption utilities** designed for **Ubuntu / Raspberry Pi ARM64** systems.  
Each version offers a different mode of operation — from classic dual-file output to modern, filename-preserving combined encryption.

---

## 🧩 Versions Overview

### 🔹 `enc.sh` — Legacy Mode (V1)
- Uses **RSA + AES-256-CBC**
- Compatible with older OpenSSL versions (uses legacy key derivation)
- Outputs two files:
  - `rsa_encrypted.bin`
  - `encrypted_aes.bin`
- Defaults:
  - Input: `plaintext.txt`
  - Output: `decrypted_file`
- Great for backwards compatibility and minimal setups.

---

### 🔹 `enc_v2.sh` — Modern PBKDF2 Mode (V2)
- Updated for **OpenSSL 3.0+**
- Uses modern **PBKDF2 key derivation** (`-pbkdf2 -iter 100000`)
- Replaces deprecated `rsautl` with `pkeyutl`
- Outputs:
  - `rsa_encrypted.bin`
  - `encrypted_aes.bin`
- Stronger security and forward-compatible with OpenSSL updates.

---

### 🔹 `enc_v3.sh` — Combined Single-File Mode (V3)
- Preserves **original filename and extension**
- Combines everything into **one file:**  
  `combined_encrypted.bin`
- Restores automatically to original name on decryption
- Still uses RSA + AES-256-CBC with PBKDF2
- Output structure:
<original_filename>
<base64 of RSA-encrypted key>
---RSA_END---
<base64 of AES-encrypted file>
---AES_END---

yaml
Copy code
- Perfect for sending or storing a single portable encrypted file.

---

## 🛠️ Features

- Generate **4096-bit RSA keypair** (`private_key.pem`, `public_key.pem`)
- AES-256-CBC hybrid encryption with RSA-protected key
- Filename-preserving combined encryption (V3)
- Default files for ease of use (`plaintext.txt`, `encrypted_aes.bin`, etc.)
- Overwrite protection prompts
- Compatible with **Ubuntu 22.04+** and **Raspberry Pi ARM64**
- No external dependencies beyond OpenSSL

---

## 🚀 Installation & Setup

1. Make all scripts executable:
 ```bash
 sudo chmod +x *.sh
Run the setup script to install dependencies:

bash
Copy code
./setup.sh
Installs OpenSSL if missing.

🧭 Usage
Run any version:

bash
Copy code
./enc.sh       # Legacy mode
./enc_v2.sh    # Modern PBKDF2 mode
./enc_v3.sh    # Combined single-file mode
🔹 Main Menu (All Versions)
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
🔸 Option 1 — Generate RSA Keypair
Creates private_key.pem and public_key.pem

4096-bit RSA keys

Asks before overwriting

🔸 Option 2 — Encrypt a File
Prompts for file (default: plaintext.txt)

Generates a random AES key

Encrypts AES key using RSA

Encrypts plaintext using AES-256-CBC

Prompts before overwriting existing output files

🔸 Option 3 — Decrypt a File
Prompts for key and encrypted file
(or combined_encrypted.bin in V3)

Decrypts AES key → decrypts file

Restores filename (V3 only)

🔸 Option 4 — Exit
Exits the utility

💡 Example Workflow
bash
Copy code
# Make scripts executable
sudo chmod +x *.sh

# Install dependencies
./setup.sh

# Run encryption utility
./enc_v3.sh

# Generate keys (option 1)
# Encrypt a file (option 2)
# Decrypt the combined file (option 3)
🧾 Notes
Designed for offline use

Uses only standard Bash + OpenSSL

Tested on Ubuntu 22.04+ and Raspberry Pi 5

All scripts are standalone and reversible

Files created by the program are self-contained
