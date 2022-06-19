resource "aws_security_group" "UbuntuSG" {
  name        = "UbuntuSG"
  description = "Security group for Ubuntu"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "UbuntuKPTerraform" {
  key_name   = "my_terraform_key"
  public_key = var.public_key
  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ~/dev/aws/automate-ec2-ansible-aws/terraform/my_terraform_key.pem"
  }
}
