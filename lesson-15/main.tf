# local execution

provider "aws" {
  region = "us-east-2"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo terraform: $(date) > file.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command     = "print('Hello World')"
    interpreter = ["python3", "-c"]
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 >> names.txt"
    environment = {
      NAME1 = "1"
      NAME2 = "2"
    }
  }
}

resource "aws_instance" "amazon_linux" {
  ami           = "ami-0443305dabd4be2bc"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo msg"
  }
}
