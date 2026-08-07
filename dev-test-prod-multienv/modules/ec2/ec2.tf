  resource "aws_key_pair" "my_ec2_keypair" {
    key_name = "${var.ec2_environment}-my-keypair"  #for dev environment key name will be dev-my-keypair, 
     public_key = file("~/.ssh/id_ed25519.pub")     #for test environment key name will be test-my-keypair and 
                                                    #for prod environment key name will be prod-my-keypair  
 }

#Data block for AWS AMI to find the latest image for AWS 

data "aws_ami" "my_ec2_ami"{
    most_recent =true
    owners=[099720109477]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

}
# VPC,subnet creatation refer from https://medium.com/aws-infrastructure/create-aws-vpc-infrastructure-with-terraform-308afed9fe31

resource "aws_vpc" "my_ec2_vpc" {

}
# Creating a security group for the EC2 instance

resource "aws_security_group" "ec2_security_sg"{
    name = "${var.ec2_environment}-ec2-terraform-security-group"  #for dev environment security group name will be dev-ec2-terraform-security-group, 
                                                                  #for test environment security group name will be test-ec2-terraform-security-group and 
                                                                  #for prod environment security group name will be prod-ec2-terraform-security-group
    description = "Allow TLS inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.my_ec2_vpc.id  

    tags = {
        Name = "${var.ec2_environment}-ec2-terraform-security-group"
    }
}

# Adding inbound rule to the security group to allow SSH access

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ec2_security_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "TCP"
  to_port           = 22
}

# Adding inbound rule to the security group to allow HTTP access
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ec2_security_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "TCP"
  to_port           = 80
}

# Adding egress rule to the security group to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_security_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

data "aws_ec2_instance_type" "my_ec2_instance_type"{
    instance_type = var.ec2_instance_type     #variable define in variable.tf file
}

# Creating an EC2 instance using the AMI and security group created above (writing instance to the VPC and subnet created above)

resource "aws_instance" "my_ec2_instance" {
    count = var.ec2_instance_count 
    ami = data.aws_ami.my_ec2_ami.id
    instance_type = data.aws_ec2_instance_type.my_ec2_instance_type.instance_type
    # or instance_type = var.ec2_instance_type 

    key_name = aws_key_pair.my_ec2_keypair.key_name 
    vpc_security_group_ids = [aws_security_group.ec2_security_sg.id]


    # adding storage block in EC2 
    root_block_device {
        volume_size = var.ec2_volume_size      #variable define in variable.tf file 
        volume_type = "gp3"
    
    }

    tags = {
        Environment = "${var.ec2_environment}-${var.ec2_instance_name}-${count.index + 1}" #variable define in variable.tf file
    }

}   
/*
resource "aws_ec2_instance_state" "my_ec2_instance_state" {
    instance_id = aws_instance.my_ec2_instance.id
    state = var.ec2_instance_state          #variable define in variable.tf file
}
*/
