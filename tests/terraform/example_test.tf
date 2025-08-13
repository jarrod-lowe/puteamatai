# T01.3a - Terraform dummy tests that FAIL to define test structure (Red phase)
# T01.3b will implement the actual Terraform modules to make these pass (Green phase)

# Test that will FAIL - expects a DynamoDB table that doesn't exist yet
resource "terraform_data" "test_dynamodb_table" {
  provisioner "local-exec" {
    command = <<-EOT
      # This will fail until actual DynamoDB table is implemented in T02b
      echo "Testing DynamoDB table exists..."
      aws dynamodb describe-table --table-name puteamatai-main || exit 1
    EOT
  }
}

# Test that will FAIL - expects S3 bucket that doesn't exist yet  
resource "terraform_data" "test_s3_bucket" {
  provisioner "local-exec" {
    command = <<-EOT
      # This will fail until actual S3 bucket is implemented in T03b
      echo "Testing S3 bucket exists..."
      aws s3 ls puteamatai-uploads || exit 1
    EOT
  }
}

# Test that will FAIL - expects API Gateway that doesn't exist yet
resource "terraform_data" "test_api_gateway" {
  provisioner "local-exec" {
    command = <<-EOT
      # This will fail until actual API Gateway is implemented in T03b
      echo "Testing API Gateway exists..."
      aws apigateway get-rest-apis --query 'items[?name==`puteamatai-api`]' || exit 1
    EOT
  }
}