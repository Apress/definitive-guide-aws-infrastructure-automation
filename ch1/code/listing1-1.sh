#!/bin/bash

region="${1}"

aws --region "${region}" ec2 run-instances \
    --image-id ami-0de53d8956e8dcf80 --count 2 \
    --instance-type t2.nano --key-name book \
    --security-group-ids sg-6e7fdd29 \
    --subnet-id subnet-661ca758


