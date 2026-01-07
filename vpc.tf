locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5.1"

  name = "${var.project_name}-vpc-${var.environment}"
  cidr = var.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 8)]

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_ipv6                                   = true
  public_subnet_assign_ipv6_address_on_creation = true

  public_subnet_ipv6_prefixes   = [0, 1, 2]
  private_subnet_ipv6_prefixes  = [3, 4, 5]
  database_subnet_ipv6_prefixes = [6, 7, 8]

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
