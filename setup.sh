#!/bin/bash
# (c) J~Net 2025
# Guaranteed working setup for OpenSSL 3.x + liboqs + oqs-provider (Kyber KEM)

set -e
sudo chmod +x *.sh
# --- Dependencies ---
sudo apt update -y
sudo apt install -y openssl git build-essential cmake pkg-config perl wget tar zlib1g-dev libgmp-dev

echo "Now run ./enc.sh"

bash ./enc.sh
