variable "ec2_volume_size" {
    description = "Mention the size of ec2 volume"
    type = number
    default = 10
}

variable "ec2_instance_name"{
    description = "Mention the name of ec2 instance"
    type = string 
    default = "my-ec2-instance"
} 
/*
variable "ec2_instance_state"{
    description = "Mention the state of ec2 instance"
    type = string 
    default = "running"
}
*/
variable "ec2_instance_type"{
    description = "Mention the type of ec2 instance"
    type = string 
    default = "t2.micro"

}

variable "ec2_environment"{
    description = "Mention the environment of ec2 instance"
    type = string 
 #   default = "dev"
}

variable "ec2_instance_count"{
    description = "Mention the count of ec2 instances"
    type = number 
  #  default = 2
}