import random, sys
from aws_cdk import (
    aws_ec2 as ec2,
    core
)
import boto3

class CdkAppStack(core.Stack):
    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        ec2b = boto3.client('ec2', region_name=kwargs['env']['region'])
        vpc_response = ec2b.describe_vpcs(
            Filters=[
                {
                    'Name': 'tag:Name',
                    'Values': [kwargs['env']['vpc']]
                }
            ]
        )
        azs_response = ec2b.describe_availability_zones(
            Filters=[
                {
                    'Name': 'region-name',
                    'Values': [kwargs['env']['region']]
                }
            ]
        )
        vpc_id = vpc_response['Vpcs'][0]['VpcId']
        vpc = ec2.Vpc.from_vpc_attributes(self, f'{id}-vpc', 
            availability_zones=[x['ZoneName'] for x in azs_response['AvailabilityZones']],
            vpc_id=vpc_id)
        subnets = []
        subnets_response = ec2b.describe_subnets(
            Filters=[
                {
                    'Name': 'tag:Tier',
                    'Values': ['public']
                },
                {
                    'Name': 'vpc-id',
                    'Values': [vpc_id]
                }
            ]
        )
        for s in subnets_response['Subnets']:
            subnets.append(s['SubnetId'])

        self.subnet_id = subnets[random.randint(0, len(subnets)-1)]

        sg = ec2.SecurityGroup(self, f'{id}-sg', vpc=vpc)
        sg.add_ingress_rule(
            ec2.Peer.ipv4(kwargs['env']['cidr']),
            ec2.Port.tcp(kwargs['env']['port'])
        )

        inst = ec2.CfnInstance(self, f'{id}-inst',
            image_id=kwargs['env']['ami'],
            instance_type=kwargs['env']['inst_type'],
            security_group_ids=[sg.security_group_id],
            subnet_id=self.subnet_id
        )

