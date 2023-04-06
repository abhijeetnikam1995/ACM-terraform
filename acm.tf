module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "2.14.0"

  domain_name  = trimsuffix(data.aws_route53_zone.mydomain.name, ".")
  zone_id      = data.aws_route53_zone.mydomain.zone_id 
wait_for_validation = var.wait_for_validation
  subject_alternative_names = [
    "*.abhijeet.ninja"
  ]
  tags = local.common_tags
}

# Output ACM Certificate ARN
output "this_acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.this_acm_certificate_arn
}


data "aws_route53_zone" "mydomain" {
  name         = "abhijeet.ninja"
}
locals {
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners = "abhi"
    environment = "eod"
  }
}

terraform {
  required_version = ">= 1.0" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }        
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


variable "wait_for_validation" {
  description = "Whether to wait for the validation to complete"
  type        = bool
  default     = false
}
