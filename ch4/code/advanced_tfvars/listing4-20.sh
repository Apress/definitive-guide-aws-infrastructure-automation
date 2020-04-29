#!/bin/bash

type terraform >/dev/null 2>&1 || { echo >&2 "terraform is required, but not installed.  Aborting."; exit 1; }

if [[ -z "${DEPLOY_ENV}" ]]; then
	echo "Please set the \$DEPLOY_ENV variable prior to running this script."
	exit 1
fi

if [[ -z "${DEPLOY_REGION}" ]]; then
	echo "Please set the \$DEPLOY_REGION variable prior to running this script."
	exit 1
fi

echo -e "Preparing ${DEPLOY_ENV} deployment in region ${DEPLOY_REGION}.\n"

###
# Add custom pre-deployment logic here -- e.g. create a ticket in a release
#   tracking system, send a message to a release channel via Slack, etc.
#

terraform init
terraform plan -var-file="${DEPLOY_ENV}/${DEPLOY_REGION}.tfvars" -detailed-exitcode
PLAN_STATUS=$?

# PLAN_STATUS will be 0 if this is a new deployment, 2 if we are updating
# an existing deployment where changes will be made.
# PLAN_STATUS will be 1 in case of a failure of the plan command.
if [[ "${PLAN_STATUS}" -ne "1" ]]; then
	echo "Plan succeeded.  Proceeding to apply."
else
	echo "Plan failed.  Aborting."
	exit 1
fi

terraform apply -var-file="${DEPLOY_ENV}/${DEPLOY_REGION}.tfvars" -auto-approve
