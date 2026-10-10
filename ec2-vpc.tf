# ec2 crete without using default vpc
resource "aws_key_pair" "demo-keypair" {
  key_name   = "demo-keypair"
  public_key = file("${path.module}/deployer-key.pub")
}

data "aws_ami" "my_ec2_ami"{
    most_recent =true
    owners=["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

# Create VPC here we are not using default VPC

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_internet_gateway" "my-demo-igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
      name = "My_demo-igw"
    }
}
resource "aws_subnet" "my_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24" 
     tags = {
        name = "My_demo_subnet"
     }
}
resource "aws_route_table" "My_demo_route_table" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-demo-igw.id
    }
    tags = {
        Name = "My_demo_route_table"
    }           
}

# in below code we are associating route table with subnet like we have created route table and 
# subnet in above code so we are associating route table with subnet
resource "aws_route_table_association" "my_route_table_association" {
    subnet_id      = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.My_demo_route_table.id
}

resource "aws_security_group" "my_demo_security_group" {
    name = "My_demo_security_group"
    description = "This is my demo security group"
    vpc_id = aws_vpc.my_vpc.id  

    tags = {
      name = "my-demo-security-group"
    }  
}
resource "aws_vpc_security_group_ingress_rule" "my-vpc-demo-security-ingress" {
  security_group_id = aws_security_group.my_demo_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "TCP"
  to_port           = 22
} 
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_demo_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "TCP"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_demo_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

}

resource "aws_instance" "my_ec2_instance" {
  ami           = data.aws_ami.my_ec2_ami.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.demo-keypair.key_name
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_demo_security_group.id]

  tags = {
    Name = "My_demo_ec2_instance"
  }
  
}
