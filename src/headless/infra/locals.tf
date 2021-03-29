locals {
  default_tags = {
    Toolkit     = "Terraform"
    Source      = "https://github.com/heoelri/locust-on-aci"
    Environment = var.environment
    Prefix      = var.prefix
  }

}