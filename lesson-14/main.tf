# local variables

provider "aws" {
  region = var.region
}

locals {
  full-project_name = "${var.environment}-${var.project_name}" # local variable
}

resource "aws_eip" "eip" {
  tags = {
    Name    = "Static_IP"
    Owner   = var.owner
    Project = local.full-project_name
  }
}
