output "instance_web" {
  value = aws_instance.web.public_ip
}

output "instance_db" {
  value = aws_instance.db.public_ip
}