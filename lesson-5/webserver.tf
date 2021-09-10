# Terraform WebServer
#
# Dynamic code blocks

resource "aws_security_group" "webserver" {
  name        = "webserver security group"
  description = "dynamic security group"

  dynamic "ingress" {
    for_each = ["80", "443", "8080"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1" #any protocol
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = ""
    }
  ]

  tags = {
    Name = "WebServer"
  }
}
