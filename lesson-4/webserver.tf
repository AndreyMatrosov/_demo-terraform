# Terraform WebServer
#
# Build WebServer during Bootstrap

provider "aws" {

}

resource "aws_instance" "webservre" {
  ami                    = "ami-0443305dabd4be2bc" # Amazon linux_profile
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id] #attach sg to instance
  user_data = templatefile("user_data_dynamic.sh.tpl", {
    f_name = "Core",
    l_name = "Core",
    names  = ["John", "Jack"]
  })

  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "webserver" {
  name        = "webserver security group"
  description = "default security group"

  ingress = [
    {
      description      = "port 80"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },

    {
      description      = "port 443"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }

  ]

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
