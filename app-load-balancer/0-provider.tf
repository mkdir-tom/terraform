provider "aws" {
  region     = "ap-southeast-1"
  access_key = var.i_provider.access_key
  secret_key = var.i_provider.secret_key
}