#!/bin/bash

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    PLATFORM="linux_amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    PLATFORM="linux_arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Get latest release info from GitHub API
API_URL="https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest"
ASSET_URL=$(curl -s $API_URL | \
    grep "browser_download_url" | \
    grep "$PLATFORM" | \
    grep -Eo 'https://[^\"]+')

if [[ -z "$ASSET_URL" ]]; then
    echo "Could not find a download URL for $PLATFORM"
    exit 1
fi

echo "Downloading Terragrunt from: $ASSET_URL"
curl -L -o terragrunt "$ASSET_URL"
chmod +x terragrunt
sudo mv terragrunt /usr/local/bin/

echo "Terragrunt installed successfully."