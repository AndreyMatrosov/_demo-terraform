output "instance_id" {
  value = aws_instance.webserver.public_ip
}

output "sg_id" {
  value = aws_security_group.aws_sg.id
}
