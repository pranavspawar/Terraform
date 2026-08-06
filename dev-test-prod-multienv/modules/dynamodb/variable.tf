variable "dynamodb_table_name"{
    description = "Mention your dynamodb table name"
    default = "my_dynamodb_table"
    type = string
  
}
variable "ec2_dynamodb_environment"{
    description = "Mention the environment of dynamodb table"
    type = string 
#    default = "dev"
}
variable "ec2_dynamodb_count"{
    description = "Mention the count of dynamodb tables"
    type = number 
  #  default = 2
}