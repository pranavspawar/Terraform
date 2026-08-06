
variable "ec2_environment"{
    description = "Mention the environment of ec2 instance"
    type = string 
    default = "dev"
}

variable "ec2_instance_count"{
    description = "Mention the count of ec2 instances"
    type = number 
  #  default = 2
}