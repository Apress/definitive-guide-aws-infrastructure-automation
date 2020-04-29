#!/bin/bash

region="${1}"
attribute="${2}"
value="${3}"
instance_id="${4}"

aws --region "${region}" ec2 stop-instances \
    --instance-ids "${instance_id}"
sleep 30
aws --region "${region}" ec2 modify-instance-attribute \
    --attribute "${attribute}" \
    --value "${value}" \
    --instance-id  "${instance_id}"
sleep 30
aws --region "${region}" ec2 start-instances \
    --instance-ids "${instance_id}"