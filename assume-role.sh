#!/bin/bash

ROLE_ARN=$1
SESSION_NAME=${2:-"eks-admin"}

if [ -z "$ROLE_ARN" ]; then
  echo "Usage: $0 <role-arn> [session-name]"
  exit 1
fi

echo "Assuming role: $ROLE_ARN..."

CREDENTIALS=$(aws sts assume-role --role-arn "$ROLE_ARN" --role-session-name "$SESSION_NAME" --output json)

export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | jq -r '.Credentials.SessionToken')

echo "✅ Role assumed and environment variables exported."
