# Terraform WebServer
#
# Dynamic code blocks

resource "aws_eip" "static_ip" {
  instance = aws_instance.webserver.id
}

resource "aws_instance" "webserver" {
  ami                    = "ami-0443305dabd4be2bc" # Amazon linux_profile
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id] #attach sg to instance
  user_data = templatefile("user_data_dynamic.sh.tpl", {
    f_name = "Core",
    l_name = "Core",
    names  = ["John", "Jack", "Jane", "Smith"]
  })

  tags = {
    Name = "WebServer"
  }

  lifecycle {
    # prevent_destroy = true
    # ignore_changes = ["ami", "user_data"]
    create_before_destroy = true
  }
}

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
