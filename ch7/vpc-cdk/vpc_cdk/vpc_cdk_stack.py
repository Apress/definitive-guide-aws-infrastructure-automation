from aws_cdk import (
    core,
    aws_ec2 as ec2,
    aws_iam as iam,
    aws_logs as logs
)
import boto3
import sys


class VpcCdkStack(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)
        self.max_azs = 3

        vpc = ec2.Vpc(self,
            f"{id}-{kwargs['env']['deploy_env']}-vpc",
            cidr=kwargs['env']['cidr'],
            default_instance_tenancy=ec2.DefaultInstanceTenancy.DEFAULT,
            enable_dns_hostnames=kwargs['env']['aws_dns'],
            enable_dns_support=kwargs['env']['aws_dns'],
            max_azs=self.max_azs,
            nat_gateways=self.max_azs if kwargs['env']['ha'] else 1,
            subnet_configuration=[
                ec2.SubnetConfiguration(
                    name='public',
                    subnet_type=ec2.SubnetType.PUBLIC,
                    cidr_mask=20
                ),
                ec2.SubnetConfiguration(
                    name='app',
                    subnet_type=ec2.SubnetType.PRIVATE,
                    cidr_mask=20
                ),
                ec2.SubnetConfiguration(
                    name='data',
                    subnet_type=ec2.SubnetType.PRIVATE,
                    cidr_mask=20
                )
            ]
        )

        flowlog_log_group = logs.LogGroup(self,
            f"{id}-{kwargs['env']['deploy_env']}-flowlog-log-group",
            log_group_name=f"/flowlogs/{kwargs['env']['deploy_env']}",
            retention=logs.RetentionDays.ONE_MONTH
        )

        iam_policy = iam.PolicyDocument(
            assign_sids=True,
            statements=[
                iam.PolicyStatement(
                    actions=[
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:DescribeLogGroups",
                        "logs:DescribeLogStreams"
                    ],
                    effect=iam.Effect.ALLOW,
                    resources=[
                        flowlog_log_group.log_group_arn
                    ]
                )
            ]
        )

        iam_role = iam.Role(self,
            f"{id}-{kwargs['env']['deploy_env']}-flowlog-role",
            assumed_by=iam.ServicePrincipal('vpc-flow-logs.amazonaws.com'),
            inline_policies={
                f"{id}-{kwargs['env']['deploy_env']}-flowlogs": iam_policy
            }
        )

        flowlog = ec2.CfnFlowLog(self,
            f"{id}-{kwargs['env']['deploy_env']}-flowlog",
            deliver_logs_permission_arn=iam_role.role_arn,
            log_destination_type='cloud-watch-logs',
            log_group_name=f"/flowlogs/{kwargs['env']['deploy_env']}",
            traffic_type='ALL',
            resource_type='VPC',
            resource_id=vpc.vpc_id
        )