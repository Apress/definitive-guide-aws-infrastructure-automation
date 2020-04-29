#!/bin/bash

region="${1}"
attribute="${2}"
value="${3}"

while read instance
do
    echo "==== Stopping ${instance} ===="
    aws --region "${region}" ec2 stop-instances \
        --instance-ids "${instance}" >/dev/null
    sleep 90
    echo "==== Changing ${attribute} on ${instance} ===="
    aws --region "${region}" ec2 modify-instance-attribute \
                --attribute "${attribute}" \
                --value "${value}" \
                --instance-id  "${instance}" >/dev/null
    if [[ "$?" == "0" ]]
    then
        echo "==== ${instance} updated successfully ===="
    fi
    echo "==== Starting ${instance} ===="
    aws --region "${region}" ec2 start-instances \
        --instance-ids "${instance}" >/dev/null
done < .ec2_instance_ids.out