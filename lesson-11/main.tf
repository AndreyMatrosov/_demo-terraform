#---------------------
# Webserver apache
# green-blue deployment
#---------------------

# provider

provider "aws" {
  region = "us-east-2"
}

#---------------------

data "aws_availability_zones" "aws_az" {}

#---------------------
# latest ami version

data "aws_ami" "the_latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#---------------------
# secutity group

resource "aws_security_group" "webserver" {
  name = "dynamic_security_group"

  tags = {
    Name  = "dynamic sg"
    Owner = "andrei matrosau"
  }

  dynamic "ingress" {
    for_each = ["80", "443", "8080"]
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

#---------------------
# launch configuration

resource "aws_launch_configuration" "web" {
  #name            = "high_aviable_web_server"
  name_prefix     = "high_aviable_web_server-"
  image_id        = data.aws_ami.the_latest_amazon_linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.webserver.id]
  user_data       = templatefile("script.sh.tpl", {})

  lifecycle {
    create_before_destroy = true
  }
}

#---------------------
# autoscaling

resource "aws_autoscaling_group" "web_autoscaling" {
  name                      = "web_autoscaling_group-${aws_launch_configuration.web.name}"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB" # Readiness probe
  desired_capacity          = 2
  load_balancers            = [aws_elb.web.name]
  launch_configuration      = aws_launch_configuration.web.name
  vpc_zone_identifier       = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

  dynamic "tag" {
    for_each = {
      Name   = "webServer-in-ASG"
      Owner  = "andreimatrosau"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = "5m"
  }
}

#---------------------
# load balancer

resource "aws_elb" "web" {
  name               = "webserver-demo"
  availability_zones = [data.aws_availability_zones.aws_az.names[0], data.aws_availability_zones.aws_az.names[1]]
  security_groups    = [aws_security_group.webserver.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "webserver-elb"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.aws_az.names[0]

  tags = {
    Name = "Default subnet for ${data.aws_availability_zones.aws_az.names[0]}"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.aws_az.names[1]

  tags = {
    Name = "Default subnet for ${data.aws_availability_zones.aws_az.names[1]}"
  }
}

#---------------------
# get dns name
output "web_lb_url" {
  value = aws_elb.web.dns_name
}
