config {
  # Enable all rules by default
  disabled_by_default = false
  
  # Format output
  format = "default"
  
  # Plugin directory
  plugin_dir = "~/.tflint.d/plugins"
  
  # Force plugin downloads
  force = false
}

# AWS plugin configuration
plugin "aws" {
  enabled = true
  version = "0.24.1"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Core Terraform rules
rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

rule "terraform_standard_module_structure" {
  enabled = true
}

# AWS-specific rules
rule "aws_instance_invalid_type" {
  enabled = true
}

rule "aws_instance_previous_type" {
  enabled = true
}

rule "aws_s3_bucket_invalid_acl" {
  enabled = true
}

rule "aws_s3_bucket_invalid_storage_class" {
  enabled = true
}

rule "aws_route_invalid_route_table" {
  enabled = true
}

rule "aws_alb_invalid_subnet" {
  enabled = true
}

rule "aws_elasticache_cluster_invalid_type" {
  enabled = true
}

rule "aws_db_instance_invalid_type" {
  enabled = true
}

# Security and best practice rules
rule "aws_instance_invalid_ami" {
  enabled = true
}

rule "aws_s3_bucket_name" {
  enabled = true
}

rule "aws_resource_missing_tags" {
  enabled = true
  tags = [
    "Environment",
    "Project", 
    "Owner"
  ]
}

# Disable overly strict rules for bootstrap phase
rule "aws_instance_invalid_key_name" {
  enabled = false # We may not have key pairs set up yet
}

rule "aws_security_group_invalid_protocol" {
  enabled = false # May need flexible protocols during development
}