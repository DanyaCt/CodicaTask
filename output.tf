output "my_ec2_instance_ip" {
    value = aws_instance.my_ec2_instance.id
}

output "my_db_endpoint" {
    value = aws_db_instance.my_db_instance.endpoint
}