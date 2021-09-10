# Data source
provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "vpc_id" {
  tags = {
    Name = "shareVPC"
  }
}

output "vpc_id" {
  value = data.aws_vpc.vpc_id.id
}

resource "aws_subnet" "subnet-demo-1" {
  vpc_id            = data.aws_vpc.vpc_id.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "172.31.48.0/20"
  tags = {
    Name = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
  }
}

output "data_aws_aviability_zone" {
  value = data.aws_availability_zones.working.names
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.id
}

output "data_aws_region_description" {
  value = data.aws_region.current.name
}
