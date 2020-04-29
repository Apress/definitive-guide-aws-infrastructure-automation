variable "ami_by_region_os" {
  type        = "map"
  description = "AMI ID by region and OS"

  default = {
    us-east-1 = {
      Windows2016Base = "ami-06bee8e1000e44ca4"
      AmazonLinux2    = "ami-0c6b1d09930fac512"
    }

    us-east-2 = {
      Windows2016Base = "ami-..."
      AmazonLinux2    = "ami-..."
    }

    us-west-2 = {
      Windows2016Base = "ami-07f35a597a32e470d"
      AmazonLinux2    = "ami-0cb72367e98845d43"
    }

    eu-west-1 = {
      Windows2016Base = "ami-..."
      AmazonLinux2    = "ami-..."
    }

    ap-southeast-1 = {
      Windows2016Base = "ami-..."
      AmazonLinux2    = "ami-..."
    }
  }
}
