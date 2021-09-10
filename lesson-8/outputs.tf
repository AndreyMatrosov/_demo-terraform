output "instance_id" {
  value = aws_security_group.webserver.id
}

output "elastic_ip" {
  value = aws_eip.static_ip.public_ip
}

output "arn" {
  value       = aws_instance.webserver.arn
  description = "demo description" #do not print in output
}
