locals {
  aws = defaults(var.aws, {
    region = "eu-west-3"  
  })
}
