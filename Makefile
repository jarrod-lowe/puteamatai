# Makefile for PūteaMātai
# Part of T01.2b - Create Makefile and Tooling Scripts

.PHONY: help env-check env-setup test lint fmt dev build clean

# Default target - show help
help:
	@echo "🏗️  PūteaMātai Development Commands"
	@echo ""
	@echo "Environment:"
	@echo "  env-check    Check if all required development tools are installed"
	@echo "  env-setup    Install missing development tools (where possible)"
	@echo ""
	@echo "Development:"
	@echo "  test         Run all tests"
	@echo "  lint         Run linters for all languages"
	@echo "  fmt          Format code in all languages"
	@echo "  dev          Start development environment"
	@echo "  build        Build all components"
	@echo "  clean        Clean build artifacts"
	@echo ""
	@echo "Infrastructure:"
	@echo "  tf-plan      Plan Terraform changes"
	@echo "  tf-apply     Apply Terraform changes"
	@echo ""
	@echo "Repository:"
	@echo "  repo-check   Validate repository protections"
	@echo "  repo-setup   Apply repository protections"

# Environment checking and setup
env-check:
	@echo "🔍 Checking development environment..."
	@./tests/test-required-tools.sh

env-setup:
	@echo "🛠️  Setting up development environment..."
	@echo "This will attempt to install missing tools where possible."
	@echo ""
	@./scripts/setup-dev-environment.sh

# Testing
test: env-check
	@echo "🧪 Running all tests..."
	@echo "Repository protection tests:"
	@./tests/validate-repo-protections.sh
	@echo ""
	@echo "Development environment tests:"
	@./tests/test-required-tools.sh
	@echo ""
	@echo "✅ All tests completed"

# Code quality
lint:
	@echo "🔍 Running linters..."
	@echo "Go linting: (when Go code exists)"
	@# go vet ./...
	@# golangci-lint run
	@echo "TypeScript linting: (when TS code exists)"
	@# npm run lint
	@echo "Terraform linting: (when TF code exists)"  
	@# terraform fmt -check
	@echo "Markdown linting: (when docs exist)"
	@# markdownlint docs/
	@echo "ℹ️  Linting will be implemented as code is added"

fmt:
	@echo "🎨 Formatting code..."
	@echo "Go formatting: (when Go code exists)"
	@# go fmt ./...
	@echo "TypeScript formatting: (when TS code exists)"
	@# npm run fmt
	@echo "Terraform formatting: (when TF code exists)"
	@# terraform fmt
	@echo "ℹ️  Formatting will be implemented as code is added"

# Development environment
dev: env-check
	@echo "🚀 Starting development environment..."
	@echo "This will start Docker containers for local development"
	@echo "ℹ️  Docker setup will be implemented in T01.4b"
	@# docker-compose up -d

# Build
build: env-check
	@echo "🏗️  Building all components..."
	@echo "Backend build: (when Go code exists)"
	@# go build ./...
	@echo "Frontend build: (when TS code exists)"
	@# npm run build
	@echo "ℹ️  Build targets will be implemented as code is added"

# Clean
clean:
	@echo "🧹 Cleaning build artifacts..."
	@echo "Go clean: (when Go code exists)"
	@# go clean ./...
	@echo "Node clean: (when Node code exists)"
	@# rm -rf node_modules dist
	@echo "Docker clean: (when Docker setup exists)"
	@# docker-compose down -v
	@echo "ℹ️  Clean targets will be implemented as code is added"

# Infrastructure
tf-plan:
	@echo "📋 Planning Terraform changes..."
	@echo "ℹ️  Terraform targets will be implemented in T02b"
	@# cd terraform && terraform plan

tf-apply:
	@echo "🚀 Applying Terraform changes..."
	@echo "ℹ️  Terraform targets will be implemented in T02b"
	@# cd terraform && terraform apply

# Repository management
repo-check:
	@echo "🔍 Validating repository protections..."
	@./tests/validate-repo-protections.sh

repo-setup:
	@echo "🔧 Setting up repository protections..."
	@./scripts/setup-repo-protections.sh