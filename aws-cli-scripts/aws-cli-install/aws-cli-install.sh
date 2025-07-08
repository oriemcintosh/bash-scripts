#!/bin/bash

# This script installs the AWS CLI version 2 on a Linux system.

# Download to temporary folder
echo "Downloading AWS CLI version 2..."
if ! command -v unzip &> /dev/null; then
    echo "unzip command not found. Installing unzip..."
    sudo apt-get update && sudo apt-get install -y unzip
fi
mkdir -p /tmp/aws-cli
cd /tmp/aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Clean up
echo "Cleaning up temporary files..."
rm -rf /tmp/aws-cli