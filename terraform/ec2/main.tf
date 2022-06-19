resource "aws_instance" "ubuntu-myinstance" {
  ami             = var.ami
  instance_type   = "t2.micro"
  key_name        = "my_terraform_key"
  security_groups = ["${aws_security_group.UbuntuSG.name}"]

  tags = {
    Name = "Ubuntu-EC2"
  }
}
