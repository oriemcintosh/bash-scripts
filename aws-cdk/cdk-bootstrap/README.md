# CDK Bootstrap Script

This script helps you bootstrap the AWS Cloud Development Kit (CDK) environment for your AWS account and region using your chosen AWS CLI profile.

## Usage

1. Make sure you have the AWS CLI and AWS CDK installed.
2. Run the script:

   ```sh
   ./cdk-bootstrap.sh
   ```
   
3. Follow the prompts:
  - Enter your AWS profile name (or press Enter to use the default profile).
  - The script will automatically detect your AWS Account ID and Region.
  - It will then run the cdk bootstrap command for you.

### What It Does
- Prompts for your AWS CLI profile.
- Retrieves your AWS Account ID and Region.
- Runs `cdk bootstrap` for the specified account and region.

### Requirements
- AWS CLI configured with at least one profile, or default configuration.
- AWS CDK installed ((p)npm install -g aws-cdk).
- Appropriate permissions to run cdk bootstrap.

### Troubleshooting
- Ensure your AWS credentials are valid and the selected profile has sufficient permissions.
- Make sure your AWS region is configured for the selected profile (aws configure --profile <profile-name>).
