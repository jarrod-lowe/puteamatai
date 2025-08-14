#!/bin/bash

# validate-linter-rules.sh
# Script to validate linter rule configurations and policies are properly defined
# Part of T01.6a - Define Linter Rules

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILURES=0

echo "🔍 Validating Linter Rules and Configuration for T01.6a..."

# Function to check if a linter config file exists
check_linter_config() {
    local config_file="$1"
    local linter_name="$2"
    local required="$3"
    
    echo -n "Checking ${linter_name} configuration (${config_file})... "
    
    if [[ -f "$config_file" ]]; then
        echo -e "${GREEN}✓ Present${NC}"
    else
        if [[ "$required" == "true" ]]; then
            echo -e "${RED}✗ Missing (Required)${NC}"
            ((FAILURES++))
        else
            echo -e "${YELLOW}⚠ Missing (Optional)${NC}"
        fi
    fi
}

# Function to check linter config content
check_linter_content() {
    local config_file="$1"
    local pattern="$2"
    local description="$3"
    
    if [[ -f "$config_file" ]]; then
        echo -n "Checking ${description}... "
        # Use flexible pattern matching for JS/JSON configs
        if grep -q "$pattern" "$config_file" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
        elif [[ "$config_file" == *.js ]] && node -e "const cfg = require('./$config_file'); console.log(JSON.stringify(cfg, null, 2));" 2>/dev/null | grep -q "$pattern" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗ Rule missing${NC}"
            ((FAILURES++))
        fi
    fi
}

# Function to run linter on good code and expect it to pass
test_linter_success() {
    local linter_command="$1"
    local test_file="$2"
    local linter_name="$3"
    
    echo -n "Testing ${linter_name} passes on clean code ${test_file}... "
    
    if [[ -f "$test_file" ]]; then
        # Run linter and expect it to pass (exit code = 0)
        if $linter_command "$test_file" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ Clean code passes${NC}"
        else
            echo -e "${RED}✗ Linter failed on clean code${NC}"
            ((FAILURES++))
        fi
    else
        echo -e "${YELLOW}⚠ Test file missing${NC}"
    fi
}

echo ""
echo "📋 ESLint Configuration:"

check_linter_config ".eslintrc.js" "ESLint" "true"
check_linter_config ".eslintrc.json" "ESLint (alternative)" "false"
check_linter_config "package.json" "ESLint in package.json" "false"

# Check ESLint rules if config exists
if [[ -f ".eslintrc.js" ]] || [[ -f ".eslintrc.json" ]]; then
    echo ""
    echo "🔧 ESLint Rules Validation:"
    
    # Look for common ESLint rules in config files
    for config in ".eslintrc.js" ".eslintrc.json"; do
        if [[ -f "$config" ]]; then
            check_linter_content "$config" "extends" "Base configuration extends"
            check_linter_content "$config" "rules" "Custom rules defined"
            break
        fi
    done
fi

echo ""
echo "📋 Go Linter Configuration:"

check_linter_config ".golangci.yml" "GolangCI-Lint" "true"
check_linter_config ".golangci.yaml" "GolangCI-Lint (alternative)" "false"

# Check GolangCI-Lint rules if config exists
if [[ -f ".golangci.yml" ]] || [[ -f ".golangci.yaml" ]]; then
    echo ""
    echo "🔧 GolangCI-Lint Rules Validation:"
    
    for config in ".golangci.yml" ".golangci.yaml"; do
        if [[ -f "$config" ]]; then
            check_linter_content "$config" "linters:" "Enabled linters list"
            check_linter_content "$config" "linters-settings:" "Linter settings configuration"
            break
        fi
    done
fi

echo ""
echo "📋 Terraform Linter Configuration:"

check_linter_config ".tflint.hcl" "TFLint" "true"

# Check Terraform linter rules
if [[ -f ".tflint.hcl" ]]; then
    echo ""
    echo "🔧 TFLint Rules Validation:"
    check_linter_content ".tflint.hcl" "rule" "TFLint rules defined"
    check_linter_content ".tflint.hcl" "plugin" "TFLint plugins configuration"
fi

echo ""
echo "🧪 Linter Success Test Cases:"

# Test that linters pass on clean, well-formatted code
echo ""
echo "Testing linter success on clean code samples:"

test_linter_success "npx eslint" "tests/demo-code/demo-typescript.ts" "ESLint on TypeScript"
test_linter_success "golangci-lint run" "tests/demo-code/demo-go.go" "GolangCI-Lint"  
test_linter_success "terraform fmt -check" "tests/demo-code/demo-terraform.tf" "Terraform fmt"
test_linter_success "tflint" "tests/demo-code/demo-terraform.tf" "TFLint"

echo ""
echo "📊 Linter Rules Validation Summary:"
echo "=================================="

if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}✅ Perfect! All linter rules are properly defined and working.${NC}"
    echo "ESLint, GolangCI-Lint, and Terraform linting policies are correctly configured!"
    exit 0
else
    echo -e "${RED}❌ Linter rule configuration incomplete.${NC}"
    echo -e "Missing components: ${FAILURES}"
    echo ""
    echo "Run T01.6b to implement missing linter configurations."
    exit 1
fi