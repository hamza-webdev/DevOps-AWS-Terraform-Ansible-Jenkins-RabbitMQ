variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "ami" {
  type    = string
  default = "ami-09e513e9eacab10c1"
}

variable "public_key" {
  description = "ssh public key"
}
