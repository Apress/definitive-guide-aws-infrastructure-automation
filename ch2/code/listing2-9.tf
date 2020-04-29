resource "aws_instance" "w1_instance" {
  instance_type               = "t2.nano"
  vpc_security_group_ids      = ["${aws_security_group.w1_security_group.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("../../shared/user-data.txt")}"

  tags {
    Name = "w1-myinstance"
  }

  ami               = "ami-cb2305a1"
  availability_zone = "us-east-1c"

  # This is fake VPC subnet ID, please put real one to make this config work
  subnet_id = "subnet-1111111"
}
