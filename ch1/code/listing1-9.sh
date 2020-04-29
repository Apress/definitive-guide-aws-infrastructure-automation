#!/bin/bash

region="${1}"
name="${2}"
corp="${3}"

BUCKET="${name}.${corp}"

aws --region "${region}" s3api create-bucket \
    --bucket "${BUCKET}" >/dev/null

if [[ "$?" == "0" ]]; then
    echo "==== Bucket ${BUCKET} created successfully ===="
    echo "${BUCKET}" >> .s3_buckets.out

    aws s3 website "s3://${BUCKET}/" \
        --index-document index.html \
        --error-document error.html

    if [[ "$?" == "0" ]]; then
        echo "==== Website hosting successfully set up on bucket ${BUCKET} ===="
    else
        echo "==== Website hosting failed to set up on bucket ${BUCKET} ===="
        exit 1
    fi

    CFDIST=$(aws cloudfront create-distribution \
        --origin-domain-name "${BUCKET}.s3.amazonaws.com" \
        --default-root-object index.html \
        --query "Distribution.[join(',', [Id,DomainName])]" \
        --output text)

    if [[ "$?" == "0" ]]; then
        echo "==== CloudFront distribution created successfully ===="
        echo "${BUCKET},${CFDIST}" >> .cloudfront_distributions.out
    else
        echo "==== CloudFront distribution failed to create ===="
    fi
else
    echo "==== Bucket \"${BUCKET}\" failed to create ===="
fi
