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

echo "Creating managment stack in management account \"${MGMT_ACCT}\""
aws cloudformation create-stack \
    --template-url "${ADMIN_STACK_URL}" \
    --stack-name "${ADMIN_STACK_NAME}" \
    --region "${DEFAULT_REGION}" \
    --profile "${MGMT_PROFILE}" \
    --capabilities CAPABILITY_NAMED_IAM

i=0
for acct in "${TGT_ACCTS[@]}"
do
    echo "Creating target stack in target account \"${acct}\""
    aws cloudformation create-stack \
        --template-url "${TGT_STACK_URL}" \
        --stack-name "${TGT_STACK_NAME}" \
        --region ${DEFAULT_REGION} \
        --capabilities CAPABILITY_NAMED_IAM \
        --profile "${TGT_PROFILES[i]}" \
        --parameters ParameterKey=AdministratorAccountId,ParameterValue=${MGMT_ACCT}
    i=$((i + 1))
done