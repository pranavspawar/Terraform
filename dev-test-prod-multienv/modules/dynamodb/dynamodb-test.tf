resource "aws_dynamodb_table" "my_dynamodb_table" {
  count          = var.ec2_dynamodb_count
  name           = "${var.ec2_dynamodb_environment}-${var.dynamodb_table_name} -{count.index + 1}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  

  attribute {
    name = "LockID"
    type = "S"
  }
}