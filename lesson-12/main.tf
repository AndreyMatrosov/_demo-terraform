# variables

provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc_id" {
  tags = var.vpc
}

data "aws_availability_zones" "aws_az" {
  # state = "available"
}

resource "aws_security_group" "aws_sg" {
  name = "dynamic_aws_sg"

  tags = var.tags

  dynamic "ingress" {
    for_each = var.port
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.32.0/20"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = var.most_recent
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  tags                   = merge(var.tags, { Name = "${var.tags["Environment"]} Webserver" })
}


resource "aws_eip" "aws_eip" {
  instance = aws_instance.webserver.id
  tags     = var.tags
}
