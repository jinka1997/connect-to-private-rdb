variable "myProject" {}

# 全体共通項目
locals {
  environment        = "develop"
  app_name           = "hoge"
  subnet_cidr_block  = "192.168.128.0/20"
  bastion_target_tag = "iap-tcp"
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
}