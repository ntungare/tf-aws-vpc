# AWS VPC Infrastructure

Personal VPC infrastructure managed with Terraform. This repository uses Terraform modules to provision production-ready AWS Virtual Private Clouds with public and private subnets across all available Availability Zones.

## Overview

This is my personal infrastructure-as-code repository for managing AWS VPCs. The configuration uses Terraform modules to automatically detect available Availability Zones in a region and create both public and private subnets in each AZ.

## Features

- **Multi-AZ Architecture**: Automatically creates subnets across 3 of the available AZs for high availability
- **Public Subnets**: Subnets with internet access via Internet Gateway for public-facing resources
- **Private Subnets**: Isolated subnets for internal resources with optional NAT Gateway access
- **Database Subnets**: Dedicated subnets for database resources
- **Dual-Stack Networking**: IPv6 support enabled by default
- **Automatic AZ Detection**: Dynamically detects and uses 3 of the available AZs in the selected region
- **Customizable CIDR Blocks**: Flexible IP addressing configuration
- **Tagged Resources**: Proper tagging for resource management and cost tracking

## Prerequisites

- Terraform >= 1.0
- An AWS account with necessary permissions to create VPC resources

## Architecture

```
VPC
├── Public Subnets (one per AZ)
│   ├── Internet Gateway
│   └── Route Table (routes to IGW)
├── Private Subnets (one per AZ)
│   └── Route Table (optional NAT Gateway)
└── Database Subnets (one per AZ)
    └── Route Table
```

## Usage

### Quick Start

1. Initialize Terraform:

   ```bash
   terraform init
   ```

2. Review the planned changes:

   ```bash
   terraform plan
   ```

3. Apply the configuration:

   ```bash
   terraform apply
   ```

## Configuration Variables

| Variable             | Description                                 | Type   | Default        | Required |
| -------------------- | ------------------------------------------- | ------ | -------------- | -------- |
| vpc_cidr             | CIDR block for the VPC                      | string | "10.0.0.0/16"  | no       |
| environment          | Environment name (e.g., dev, staging, prod) | string | "dev"          | no       |
| project_name         | Project name for resource tagging           | string | "demo-project" | no       |
| enable_nat_gateway   | Enable NAT Gateway for private subnets      | bool   | true           | no       |
| single_nat_gateway   | Use a single NAT Gateway for all AZs        | bool   | false          | no       |
| enable_dns_hostnames | Enable DNS hostnames in the VPC             | bool   | true           | no       |
| enable_dns_support   | Enable DNS support in the VPC               | bool   | true           | no       |

## Outputs

After applying the configuration, the following outputs will be available:

| Output              | Description                     |
| ------------------- | ------------------------------- |
| vpc_id              | The ID of the VPC               |
| vpc_cidr_block      | The CIDR block of the VPC       |
| public_subnet_ids   | List of IDs of public subnets   |
| private_subnet_ids  | List of IDs of private subnets  |
| availability_zones  | List of availability zones used |
| internet_gateway_id | The ID of the Internet Gateway  |
| nat_gateway_ids     | List of NAT Gateway IDs         |

## What Gets Created

This configuration creates the following AWS resources:

- 1 VPC
- 1 Internet Gateway
- N Public Subnets (where 3 of the available AZs)
- N Private Subnets (where 3 of the available AZs)
- N Database Subnets (where 3 of the available AZs)
- Public Route Table with IGW route
- Private Route Table(s) with optional NAT Gateway routes
- Database Route Table(s)
- NAT Gateway(s) with Elastic IP(s) (if enabled)

## Cost Considerations

- **NAT Gateways**: Each NAT Gateway incurs hourly charges plus data processing fees
- **Elastic IPs**: Associated with NAT Gateways
- **Data Transfer**: Cross-AZ data transfer charges may apply

For cost optimization in non-production environments, consider using single_nat_gateway = true.

## Security

- Private subnets have no direct internet access (unless NAT Gateway is enabled)
- Public subnets are associated with an Internet Gateway
- Network ACLs and Security Groups should be configured based on your specific requirements

## Maintenance

This is personal infrastructure. Updates to the VPC configuration should be tested in a development environment before applying to production.
