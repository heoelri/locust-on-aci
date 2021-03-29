locals {
  default_tags = {
    Toolkit     = "Terraform"
    Environment = var.environment
    Prefix      = var.prefix
  }

}