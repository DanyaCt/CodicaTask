output "my_ec2_instance_public_ip" {
    value = aws_instance.my_ec2_instance.public_ip
}

output "my_db_endpoint" {
    value = aws_db_instance.my_db_instance.endpoint
}

output "my_lb_dns_name" {
    value = aws_lb.my_lb.dns_name
}