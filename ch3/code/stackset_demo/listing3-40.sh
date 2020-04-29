#!/bin/bash

ADMIN_STACK_URL="https://s3.amazonaws.com/cloudformation-stackset-sample-templates-us-east-1/AWSCloudFormationStackSetAdministrationRole.yml"
ADMIN_STACK_NAME="stackset-admin"
TGT_STACK_URL="https://s3.amazonaws.com/cloudformation-stackset-sample-templates-us-east-1/AWSCloudFormationStackSetExecutionRole.yml"
TGT_STACK_NAME="stackset-execution"
MGMT_ACCT="111111111111"
MGMT_PROFILE="infrabook"
TGT_ACCTS=("000000000001" "000000000002") 
TGT_PROFILES=("infrabook-org1" "infrabook-org2")
DEFAULT_REGION="us-west-2"
TPLT="listing4-39"

echo "Creating stack set in management account \"${MGMT_ACCT}\""
aws cloudformation create-stack-set \
    --profile "${MGMT_PROFILE}" \
    --template-body "file://${TPLT}.yml" \
    --stack-set-name "${TPLT}" \
    --region "${DEFAULT_REGION}" \
    --capabilities CAPABILITY_NAMED_IAM

i=0
for acct in "${TGT_ACCTS[@]}"
do
    echo "Deploying to target account \"${acct}\""
    aws cloudformation create-stack-instances \
        --profile "${MGMT_PROFILE}" \
        --stack-set-name "${TPLT}" \
        --accounts "${acct}" \
        --regions "us-east-1" "us-west-2" \
        --region "${DEFAULT_REGION}"
    i=$((i + 1))
    if [[ "${i}" -lt "${#TGT_ACCTS[@]}" ]]; then
        sleep 300
    fi
done