terraform {
  backend "s3" {
    bucket = "mydev-tf-state-bucket-project-terraform-pritesh-12"
    key = "main"
    region = "us-east-1"
    dynamodb_table = "my-dynamodb-table1"
  }
}
