# generate and save passwords

provider "aws" {
  region = "us-east-2"
}

# variable with validation

variable "user" {
  default = "admin"
  validation {
    condition     = substr(var.region, 0, 3) == "adm"
    error_message = "user is not admin"
  }
}
# create password

resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$&"
  keepers = {
    keeper1 = var.user # if this value will change password woulld be change too
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "master password for mysql"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

# use password

data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

output "rds_password" {
  sensitive = true
  value     = data.aws_ssm_parameter.my_rds_password.value
}

# db create

resource "aws_db_instance" "default" {
  identifier           = "db"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = var.user
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}
