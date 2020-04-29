#!/usr/bin/env python3

import os
from aws_cdk import core
from cdk_app.cdk_app_stack import CdkAppStack
from cdk_app.helpers import Inputs

app = core.App()
i = Inputs()

account = os.environ['CDK_DEFAULT_ACCOUNT']
region = os.environ['CDK_DEFAULT_REGION']
deploy_env = i.get(app, 'DeployEnv')
vpc = i.get(app, 'Vpc')[deploy_env]
cidr = i.get(app, 'PublicCidr')
os = i.get(app, 'OperatingSystem')
port = i.get(app, 'ConnectPortByOs')[os]
ami = i.get(app, 'AmiByOs')
inst_type = i.get(app, 'InstanceType')

app_stack = CdkAppStack(app, "cdk-app",
        env={
            'account': account, 
            'region': region,
            'DeployEnv': deploy_env,
            'vpc': vpc,
            'cidr': cidr,
            'port': port,
            'os': os,
            'ami': ami[region][os],
            'inst_type': inst_type
        }
    )

app.synth()
