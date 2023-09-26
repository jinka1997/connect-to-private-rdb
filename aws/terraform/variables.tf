# 全体共通項目
locals {
  environment           = "develop"
  app_name              = "hoge"
  vpc_cidr_block        = "10.4.0.0/16"
  public_1a_cidr_block  = "10.4.0.0/20"
  public_1c_cidr_block  = "10.4.16.0/20"
  private_1a_cidr_block = "10.4.128.0/20"
  private_1c_cidr_block = "10.4.144.0/20"
}

variable "proxy_ip_address" {}
data "aws_caller_identity" "self" {}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
}