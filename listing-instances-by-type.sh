#!/bin/bash

# Set the AWS region
REGION="us-east-2"

# Use the AWS CLI to describe EC2 instances in the specified region
INSTANCE_INFO=$(aws ec2 describe-instances --region $REGION --query 'Reservations[*].Instances[*].[InstanceType,InstanceId]' --output text)

# Create an associative array to store instance types and their counts
declare -A INSTANCE_TYPE_COUNTS

# Loop through the instance information and populate the array
while read -r INSTANCE_TYPE INSTANCE_ID; do
    if [[ -n "$INSTANCE_TYPE" ]]; then
        ((INSTANCE_TYPE_COUNTS[$INSTANCE_TYPE]++))
    fi
done <<< "$INSTANCE_INFO"

# Print the instance types and their counts
echo "Instance Types in $REGION:"
for INSTANCE_TYPE in "${!INSTANCE_TYPE_COUNTS[@]}"; do
    echo "$INSTANCE_TYPE: ${INSTANCE_TYPE_COUNTS[$INSTANCE_TYPE]}"
done
