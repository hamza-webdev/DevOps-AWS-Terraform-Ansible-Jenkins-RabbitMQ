variable "name" {
  description = "Name the instance on deploy"
}

variable "group" {
  description = "the group tag for ansible to identify RMQ"
}

variable "profile" {
  description = "profile we will use for deploy"
}

variable "ami" {
  type    = string
  default = "ami-09e513e9eacab10c1"
}
