provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main"
  }
}
#creating bucket 
# Define the AWS provider
provider "aws" {
  region = "us-west-2"  # Change this to your desired region
}

# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "mydev-tf-state-bucket-project-terraform-pritesh-1234"  # Change this to your desired bucket name
  acl    = "private"  # Set the Access Control List (ACL) policy to private

  tags = {
    Name        = "bucket-pritesh"
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "example_bucket_versioning" {
  bucket = mydev-tf-state-bucket-project-terraform-pritesh-1234.id

  versioning_configuration {
    status = "Enabled"
  }
}
########

# Create a DynamoDB table
resource "aws_dynamodb_table" "my_dynamodb_table" {
  name           = "my-dynamodb-table1"
  billing_mode   = "PAY_PER_REQUEST"  # Use on-demand billing mode
  hash_key       = "LockID"

  attribute {
    name = "LockID"
  }

  tags = {
    Name        = "my-dynamodb-table1"
    Environment = "Dev"
  }
}
#Create security group with firewall rules
resource "aws_security_group" "jenkins-sg-2022" {
  name        = var.security_group
  description = "security group for Ec2 instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from jenkis server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}

resource "aws_instance" "myFirstInstance" {
  ami           = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.jenkins-sg-2022.id]
  tags= {
    Name = var.tag_name
  }
}

# Create Elastic IP address
resource "aws_eip" "myFirstInstance" {
  vpc      = true
  instance = aws_instance.myFirstInstance.id
tags= {
    Name = "my_elastic_ip"
  }
}
