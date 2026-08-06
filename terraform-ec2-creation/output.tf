output "ec2_instance_public_ip" {
    value = aws_instance.my_ec2_instance.public_ip 
}

output "ec2_instance_dns_name" {
    value = aws_instance.my_ec2_instance.public_dns
    
}