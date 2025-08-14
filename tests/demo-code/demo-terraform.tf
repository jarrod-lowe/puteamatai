# demo-terraform.tf - Demonstrates Terraform formatting and linting compliance

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "demo"
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
  default     = "puteamatai"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "demo_example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name        = "DemoInstance"
    Environment = var.environment
    Project     = var.project
    Owner       = "demo"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "puteamatai-demo-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = "demo"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

output "demo_output" {
  value       = aws_instance.demo_example.id
  description = "ID of the demo EC2 instance"
}