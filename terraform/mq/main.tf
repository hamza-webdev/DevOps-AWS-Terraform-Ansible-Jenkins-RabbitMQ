provider "aws" {
  region  = "eu-west-3"
  profile = var.profile
}

resource "aws_instance" "rmq" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  key_name               = "awskey"
  vpc_security_group_ids = ["sg-01242a085c0771812"]

  tags = {
    Name  = var.name
    group = var.group
  }
}
