# bad-terraform.tf - Intentionally bad Terraform code to test formatting and linting

# Poor formatting and style violations
resource "aws_instance" "bad_example" {
ami           = "ami-12345678"  # Hardcoded AMI ID
instance_type = "t2.micro"
  
  tags    ={
name="BadInstance"  # Missing spaces, poor formatting
  environment =    "dev"     # Inconsistent spacing
}

# Missing provider configuration

# Unused variable
variable "unused_var" {
  description = "This variable is never used"
  type        = string
  default     = "unused"
}

# Bad resource naming and missing required arguments
resource "aws_s3_bucket"  "bad_bucket" {
bucket= "my-bad-bucket-name-123"  # Hardcoded bucket name
}

# Inefficient data source usage
data "aws_availability_zones" "all" {}

# Bad output formatting
output"bad_output"{
value=aws_instance.bad_example.id  # Missing spaces
description="This output has poor formatting"
}

# Deprecated argument usage (terraform fmt won't catch but tflint should)
resource "aws_s3_bucket" "another_bad_bucket" {
  bucket = "another-bad-bucket"
  acl    = "private"  # Deprecated way to set ACL
}

# Missing required tags
resource "aws_instance" "untagged_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  # Missing tags - violates tagging policy
}