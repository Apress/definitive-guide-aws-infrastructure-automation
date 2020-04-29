#!/bin/bash

region="${1}"

# Create a temp file to use for program logic,
# while program manipulates actual inventory file
cp .ec2_instance_ids.out .ec2_instance_ids.out.tmp

# Read in inventory from temp file, while updating
# inventory per operations in actual inventory file.
# We use the "3" filehandle to allow the "read" command
# to continue to work as-normal from stdin.
while read instance <&3; do
    read -p "Terminate ${instance} [y|n]? " termvar
    if [[ ${termvar} == [yY] ]]; then
        echo "==== Terminating ${instance} ===="
        aws --region "${region}" ec2 terminate-instances \
            --instance-ids "${instance}" >/dev/null
        if [[ "$?" == "0" ]]; then
            echo "==== ${instance} terminated successfully ===="
            sed -ie "/^${instance}/d" .ec2_instance_ids.out
        fi
    else
        echo "==== Keeping ${instance} ===="
    fi
done 3< .ec2_instance_ids.out.tmp

# Cleanup inventory file
sed -ie '/^$/d' .ec2_instance_ids.out

# Remove temp file
rm .ec2_instance_ids.out.tmp
