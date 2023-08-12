#!/bin/zsh

# Script to configure temporary AWS CLI credentials within environment variables within shell session.

# Prompt the user to enter their AWS access key ID
echo "Enter your AWS access key ID:"
read AWS_ACCESS_KEY_ID

# Prompt the user to enter their AWS secret access key
echo "Enter your AWS secret access key:"
read AWS_SECRET_ACCESS_KEY

# Prompt the user to enter their AWS session token
echo "Enter your AWS session token (optional):"
read AWS_SESSION_TOKEN

# Prompt the user to enter their AWS default region
echo "Enter your AWS default region:"
read AWS_DEFAULT_REGION

# Set the AWS access key ID, secret access key, session token and default region
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
