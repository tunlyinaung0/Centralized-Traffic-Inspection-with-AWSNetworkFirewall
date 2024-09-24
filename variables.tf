variable "vpc_a_cidr" {}
variable "vpc_b_cidr" {}
variable "security_vpc_cidr" {}

variable "az1" {}
variable "az2" {}

variable "private_subnet_a_cidr" {}
variable "private_subnet_b_cidr" {}

variable "security_public_subnet_a" {}
variable "security_public_subnet_b" {}

variable "tgw_subnet_a" {}
variable "tgw_subnet_b" {}

variable "firewall_subnet_a" {}
variable "firewall_subnet_b" {}

variable "ami_id" {}
variable "instance_type" {}