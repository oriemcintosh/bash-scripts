#!/bin/zsh

# This script will require your password to elevate priviledge to move the script into a binary location.

# Prompt the user to enter an alias name for the aws cli environment variable script
echo "Enter the alias name you want to use to execute the AWS CLI environment variable configuration."
read USER_ALIAS

# Move script to common binary location within shell PATH
sudo mv awsclienvars.sh /usr/local/bin

# Add alias to shell config file for use
echo "\nalias $USER_ALIAS='. awsclienvvars.sh'" >> ~/.zshrc
