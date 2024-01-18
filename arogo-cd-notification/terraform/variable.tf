variable "i_provider" {
  access_key = "AKIAWLOI4CKNKLZGBEQS",
  secret_key = "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"
}
variable "i_vpc" {}
variable "i_security_group_my_ip" {}
variable "i_destination_cidr_block" {
  default = "0.0.0.0/0"
}
variable "i_name_app" {
  default = "kwida"
}
variable "i_ec2" {}
