variable "s3_bucket" {
    description = "Mention the name of s3 bucket"
    type = string 
    default = "devloper_bucket"
}
variable "ec2_s3_environment"{
    description = "Mention the environment of s3 bucket"
    type = string 
#   default = "dev"
}
variable "ec2_s3_count"{
    description = "Mention the count of s3 buckets"
    type = number 
  #  default = 2
}