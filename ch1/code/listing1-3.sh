#!/bin/bash

region="${1}"
ami="${2}"
how_many="${3}"
itype="${4}"
key="${5}"
sg_ids="${6}"
subnet="${7}"

aws --region "${region}" ec2 run-instances \
    --image-id "${ami}" --count "${how_many}" \
    --instance-type "${itype}" --key-name "${key}" \
    --security-group-ids "${sg_ids}" \
    --subnet-id "${subnet}" \
    --query 'Instances[*].[InstanceId]' \
    --output text >> .ec2_instance_ids.out

# Remove any empty lines from inventory file
sed -ie '/^$/d' .ec2_instance_ids.out