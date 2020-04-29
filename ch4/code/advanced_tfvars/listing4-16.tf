variable "ami_by_region_os" {
  type        = "map"
  description = "AMI ID by region and OS"

  default = {
    qa = {
      us-east-1 = {
        Windows2016Base = "ami-..."
        AmazonLinux2    = "ami-..."
      }

      us-west-2 = {
        Windows2016Base = "ami-..."
        AmazonLinux2    = "ami-..."
      }
    }

    stg = {
      us-east-1 = {
        Windows2016Base = "ami-..."
        AmazonLinux2    = "ami-..."
      }

      us-west-2 = {
        Windows2016Base = "ami-..."
        AmazonLinux2    = "ami-..."
      }
    }

    prod = {
      us-east-1 = {
        Windows2016Base = "ami-..."
        AmazonLinux2    = "ami-..."
      }

      us-west-2 = {
        Windows2016Base = "ami-..."
        AmazonLinux2    = "ami-..."
      }
    }
  }
}
