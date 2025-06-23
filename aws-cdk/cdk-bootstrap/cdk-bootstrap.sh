#!/bin/bash

# Shell Script to gather AWS Account Number and Region to be used for CDK Bootstrap

# Prompt user for AWS Profile
echo "Please enter your AWS profile name (or press Enter to use the default profile):"
read AWS_PROFILE
if [ -z "$AWS_PROFILE" ]; then
    export AWS_PROFILE=default
else
    export AWS_PROFILE=$AWS_PROFILE
fi

# Gather AWS Account Number based on the provided profile
echo "Using AWS Profile: $AWS_PROFILE"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --profile $AWS_PROFILE --query Account --output text)
if [ $? -ne 0 ]; then
    echo "Error: Unable to retrieve AWS Account ID. Please check your AWS credentials and profile."
    exit 1
fi
export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID
echo "AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"

# Set AWS Region based on the provided profile default
if [ -z "$AWS_REGION" ]; then
    AWS_REGION=$(aws configure get region --profile $AWS_PROFILE)
    if [ -z "$AWS_REGION" ]; then
        echo "Error: AWS Region is not configured for the profile $AWS_PROFILE. Please set it using 'aws configure'."
        exit 1
    fi
else
    AWS_REGION=$(aws configure get region)
fi
export AWS_REGION=$(aws configure get region)
echo "AWS_REGION: $AWS_REGION"

# Complete CDK Bootstrap
echo "Bootstrapping CDK with AWS Account ID: $AWS_ACCOUNT_ID and Region: $AWS_REGION"
cdk bootstrap aws://$AWS_ACCOUNT_ID/$AWS_REGION --profile $AWS_PROFILE
if [ $? -ne 0 ]; then
    echo "Error: CDK Bootstrap failed. Please check your AWS credentials and permissions."
    exit 1
fi
echo "CDK Bootstrap completed successfully."
