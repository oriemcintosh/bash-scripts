# Get VPC ID and assign it to VPC_ID variable
export VPC_ID=$(aws ec2 describe-vpcs | jq -r .Vpcs[].VpcId)

# Get Subnet ID and assign it to SUBNET_ID variable
export SUBNET_ID=$(aws ec2 describe-subnets | jq -r '.Subnets[] | select(.AvailabilityZoneId == "use1-az4") | .SubnetId')