#!/usr/bin/env python

from troposphere import Base64, FindInMap, GetAtt
from troposphere import Parameter, Output, Ref, Template
import troposphere.ec2 as ec2

template = Template()

# non-working code w/o the Refs being defined

ec2_instance = template.add_resource(ec2.Instance(
    "Ec2Instance",
    ImageId=FindInMap("AWSRegionArch2AMI", Ref("AWS::Region"), FindInMap(
        "AWSRegionArch2AMI",
        Ref("InstanceType"),
        "Arch"
    )),
    InstanceType=Ref(InstanceType),
    KeyName=Ref(KeyName),
    SecurityGroups=[Ref(InstanceSecurityGroup)]
))

print(template.to_yaml())
