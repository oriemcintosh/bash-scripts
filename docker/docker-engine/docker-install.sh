#!/bin/bash

# Script to install Docker CE on Ubuntu / Debian
# This script assumes you have already run docker-pre-install.sh to remove conflicting packages,
# as well as the docker-repo-config.sh script to set up the Docker repository.

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`