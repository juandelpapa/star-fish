# Use the latest packer built AMI
data "aws_ami" "marine" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["marine-ami"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "vpc" {
    id = var.vpc
}

data "aws_subnet" "public" {
    id = var.public
}

data "aws_subnet" "private" {
    id = var.private
}
