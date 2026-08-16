locals {
    env = {
        dev =  {
            instance_count = 1 
            instance_s3_count = 1
            dynamodb_table_count = 1
            ec2_instance_type = "t2.micro"

        }
        stg-test = {
            instance_count = 2
            instance_s3_count = 2 
            dynamodb_table_count = 1
            ec2_instance_type = "t2.small"
        }
        prod = {
            instance_count = 3
            instance_s3_count = 2
            dynamodb_table_count = 2
            ec2_instance_type = "t2.medium"
        }
    }
    current = lookup(local.env ,terraform.workspace, local.env.dev)
}

module "ec2_dev_infra" {
    source = "/home/dell/terraform-practice/dev-test-prod-multienv/modules/ec2"
    ec2_environment = terraform.workspace # if workspace is dev then ec2_environment will be dev, 
                                          # if workspace is test then ec2_environment will be test and 
                                          # if workspace is prod then ec2_environment will be prod

    ec2_instance_count = local.current.instance_count  
    ec2_instance_type = local.current.ec2_instance_type

}
module "ec2_s3_infra" {
    source = "/home/dell/terraform-practice/dev-test-prod-multienv/modules/s3"
    ec2_s3_environment = terraform.workspace  
    ec2_s3_count = local.current.instance_s3_count  

}
module "ec2_dynamodb_infra" {
    source = "/home/dell/terraform-practice/dev-test-prod-multienv/modules/dynamodb"
    ec2_dynamodb_environment = terraform.workspace 
    ec2_dynamodb_count = local.current.dynamodb_table_count

}
