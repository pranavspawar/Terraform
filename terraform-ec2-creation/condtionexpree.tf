# This is used for condition expression in Terraform 

variable "environment"{
    description = "The environment for development region"
    type = string
    default = "dev"
}

locals { 
    instance_type = var.environment == "prod" ? "t3.medium" : "t2.micro"
}
