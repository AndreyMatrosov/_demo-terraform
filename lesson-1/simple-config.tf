provider "aws" {

}


resource "aws_instance" "my_Ubuntu" {
  count         = 1
  ami           = "ami-00399ec92321828f5"
  instance_type = "t2.micro"

  tags = {
    Name    = "Ubuntu"
    Owner   = "Core"
    Project = "Terraform"
  }
}

resource "aws_instance" "my_aws" {
  count         = 1
  ami           = "ami-0443305dabd4be2bc"
  instance_type = "t2.micro"

  tags = {
    Name    = "AWS"
    Owner   = "Core"
    Project = "Terraform"
  }
}
