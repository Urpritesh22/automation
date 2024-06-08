resource "aws_s3_bucket" "my_bucket" {
  bucket = "mydev-tf-state-bucket-project-terraform-pritesh-1234" # Replace with your bucket name
  acl    = var.acl

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
