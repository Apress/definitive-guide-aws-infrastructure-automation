provider "aws" {}

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

variable "connect_port" {
  type = "map"
  default = {
    windows = "3389"
    linux = "22"
  }
}

variable "os_type" {
  type = "string"
  description = "windows|linux"
  default = "linux"
}

variable "windows_ami" {
  type = "string"
  description = "Windows AMI"
  default = ""
}

variable "linux_ami" {
  type = "string"
  description = "Linux AMI"
  default = ""
}

resource "aws_security_group" "public_os_access" {
  name        = "public_os_access"
  description = "Enable public access via OS-specific port"

  ingress {
    from_port   = "${lookup(var.connect_port, var.os_type)}"
    to_port     = "${lookup(var.connect_port, var.os_type)}"
    protocol    = "tcp"
    cidr_blocks = ["${var.public_location}"]
  }
}

resource "aws_instance" "public_instance" {
  instance_type = "${var.instance_type}"
  ami = "${var.os_type == "windows" ? var.windows_ami : var.linux_ami}"
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