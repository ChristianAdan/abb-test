output "instance_public_ip" {
  value = aws_instance.flask_instance.public_ip
}

output "db_address" {
  value = aws_db_instance.postgres.address
}
