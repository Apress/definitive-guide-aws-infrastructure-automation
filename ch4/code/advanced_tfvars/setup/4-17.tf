# All Terraform code needs a provider to work
provider "aws" {}

# This provides an analogue to the ${AWS::...} pseudo-variables
# in CloudFormation.
data "aws_region" "current" {}

# These correspond to 3-1 Parameters
variable "key_name" {
  type = "string"
  description = "Name of an existing EC2 KeyPair to enable access to the instance"
  default = ""
}

variable "deploy_env" {
  type = "string"
  description = ""
}

variable "operating_system" {
  type = "string"
  description = "Chosen operating system"
  default = "AmazonLinux2"
}

variable "instance_type" {
  type = "string"
  description = "EC2 instance type"
  default = "t2.small"
}

variable "public_location" {
  type = "string"
  description = "The IP address range that can be used to connect to the EC2 instances"
  default = "0.0.0.0/0"
}

# These correspond to 3-1 Mappings
variable "connect_port_by_os" {
  type = "map"
  description = "Port mappings for operating systems"
  default = {
    Windows2016Base = "3389"
    AmazonLinux2 = "22"
  }
}

variable "ami_by_region_os" {
  type = "map"
  description = "AMI ID by region and OS"
  default = {
    qa = {
      us-east-1 = {
        Windows2016Base = "ami-06bee8e1000e44ca4"
        AmazonLinux2 = "ami-0c6b1d09930fac512"
      }
      us-west-2 = {
        Windows2016Base = "ami-07f35a597a32e470d"
        AmazonLinux2 = "ami-0cb72367e98845d43"
      }
    }
    stg = {
      us-east-1 = {
        Windows2016Base = "ami-06bee8e1000e44ca4"
        AmazonLinux2 = "ami-0c6b1d09930fac512"
      }
      us-west-2 = {
        Windows2016Base = "ami-07f35a597a32e470d"
        AmazonLinux2 = "ami-0cb72367e98845d43"
      }   
    }
    prod = {
      us-east-1 = {
        Windows2016Base = "ami-06bee8e1000e44ca4"
        AmazonLinux2 = "ami-0c6b1d09930fac512"
      }
      us-west-2 = {
        Windows2016Base = "ami-07f35a597a32e470d"
        AmazonLinux2 = "ami-0cb72367e98845d43"
      }
    }
  }
} 

resource "aws_security_group" "public_os_access" {
  name        = "public_os_access"
  description = "Enable public access via OS-specific port"

  ingress {
    from_port   = "${lookup(var.connect_port_by_os, var.operating_system)}"
    to_port     = "${lookup(var.connect_port_by_os, var.operating_system)}"
    protocol    = "tcp"
    cidr_blocks = ["${var.public_location}"]
  }
}

resource "aws_instance" "public_instance" {
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  ami = "${var.ami_by_region_os[var.deploy_env][data.aws_region.current.name][var.operating_system]}"
  vpc_security_group_ids = ["${aws_security_group.public_os_access.id}"]
}

output "instance_id" {
  value = "${aws_instance.public_instance.id}"
}

output "az" {
  value = "${aws_instance.public_instance.availability_zone}"
}

output "public_dns" {
  value = "${aws_instance.public_instance.public_dns}"
}

output "public_ip" {
  value = "${aws_instance.public_instance.public_ip}"
}