#!/usr/bin/env python3

import os, sys
from aws_cdk import core
from vpc_cdk.vpc_cdk_stack import VpcCdkStack
from vpc_cdk.helpers import Inputs

app = core.App()
i = Inputs()

account = os.environ['CDK_DEFAULT_ACCOUNT']
region = os.environ['CDK_DEFAULT_REGION']
deploy_env = i.get_ck(app, 'DeployEnv')
base_cidr = i.get_ck(app, 'BaseCidr')[region][deploy_env]
aws_dns = i.get_ck(app, 'AwsDns')
high_availability = i.get_ck(app, 'HighAvailability')[deploy_env]


VpcCdkStack(app, "vpc-cdk",
    env={
        'cidr': base_cidr, 
        'account': account,
        'region': region,
        'deploy_env': deploy_env,
        'aws_dns': aws_dns,
        'ha': high_availability,
    }
)

app.synth()
