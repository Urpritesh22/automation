terraform {
  backend "s3" {
    bucket = "mydev-tf-state-bucket-project-terraform-pritesh-1234"
    key = "main"
    region = "ap-south-1"
    dynamodb_table = "my-dynamodb-table1"
  }
}
