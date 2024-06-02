provider "aws" {
  region = var.aws_region
}

# Use existing VPC
data "aws_vpc" "existing" {
  id = "vpc-07ec39ca6a3c2d055"
}

# Retrieve the subnets in the existing VPC
data "aws_subnet_ids" "existing" {
  vpc_id = data.aws_vpc.existing.id
}

# Retrieve details of the first subnet
data "aws_subnet" "first" {
  id = data.aws_subnet_ids.existing.ids[0]
}

# Create security group with firewall rules
resource "aws_security_group" "jenkins-sg-2022" {
  name        = var.security_group
  description = "security group for EC2 instance"
  vpc_id      = data.aws_vpc.existing.id

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

  # outbound from Jenkins server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group
  }
}

resource "aws_instance" "myFirstInstance" {
  ami                      = var.ami_id
  key_name                 = var.key_name
  instance_type            = var.instance_type
  vpc_security_group_ids   = [aws_security_group.jenkins-sg-2022.id]
  subnet_id                = data.aws_subnet.first.id
  tags = {
    Name = var.tag_name
  }
}

# Create Elastic IP address
resource "aws_eip" "myFirstInstance" {
  vpc      = true
  instance = aws_instance.myFirstInstance.id
  tags = {
    Name = "my_elastic_ip"
  }
}

output "subnet_ids" {
  value = data.aws_subnet_ids.existing.ids
}
