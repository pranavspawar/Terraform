resource "aws_s3_bucket" "devloper"{
    count = var.ec2_s3_count  
    bucket = var.s3_bucket

    tags = {
        Name ="${var.ec2_s3_environment}-${var.s3_bucket}-${count.index + 1}"
    }
}
