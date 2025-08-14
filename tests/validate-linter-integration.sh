#!/bin/bash

# validate-linter-integration.sh
# Script to validate linter integration with make and CI pipeline
# Part of T01.6b - Add Linter Configs and Integrate with CI

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILURES=0

echo "🔧 Validating Linter Integration for T01.6b..."

# Function to check if make target works
check_make_target() {
    local target="$1"
    local description="$2"
    
    echo -n "Checking ${description}... "
    
    # Check if make target exists and can be executed
    if make -n "$target" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Target exists${NC}"
    else
        echo -e "${RED}✗ Make target missing or broken${NC}"
        ((FAILURES++))
    fi
}

# Function to check if make target actually runs linters
test_make_linter_execution() {
    local target="$1"
    local linter_name="$2"
    
    echo -n "Testing ${linter_name} execution via make ${target}... "
    
    # Run make target and check output mentions the linter
    if make "$target" 2>&1 | grep -i "$linter_name" >/dev/null; then
        echo -e "${GREEN}✓ Linter executed${NC}"
    else
        echo -e "${RED}✗ Linter not executed${NC}"
        ((FAILURES++))
    fi
}

# Function to check CI workflow integration
check_ci_integration() {
    local workflow_file=".github/workflows/test.yml"
    local linter_step="$1"
    local description="$2"
    
    echo -n "Checking ${description} in CI workflow... "
    
    if [[ -f "$workflow_file" ]] && grep -q "$linter_step" "$workflow_file" 2>/dev/null; then
        echo -e "${GREEN}✓ Integrated${NC}"
    else
        echo -e "${RED}✗ Missing from CI${NC}"
        ((FAILURES++))
    fi
}

echo ""
echo "📋 Make Target Integration:"

# Check make lint target
check_make_target "lint" "make lint target"
check_make_target "lint-go" "make lint-go target"
check_make_target "lint-js" "make lint-js target"
check_make_target "lint-tf" "make lint-tf target"

echo ""
echo "🔧 Linter Execution Testing:"

# Test that make targets actually run the linters
# Note: These may fail due to code issues, but should attempt to run
echo "Testing linter execution (expect some failures on bad code):"
test_make_linter_execution "lint-go" "golangci-lint"
test_make_linter_execution "lint-js" "eslint"
test_make_linter_execution "lint-tf" "terraform fmt"

echo ""
echo "🚀 CI Pipeline Integration:"

# Check if linting is integrated into GitHub Actions
check_ci_integration "make lint" "General linting step"
check_ci_integration "lint" "Linting job or step"

echo ""
echo "📦 Linter Dependencies:"

# Check if linter tools are available or installable
echo -n "Checking ESLint availability... "
if command -v npx >/dev/null && npx eslint --version >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Available${NC}"
elif [[ -f "package.json" ]] && grep -q "eslint" package.json; then
    echo -e "${GREEN}✓ In package.json${NC}"
else
    echo -e "${RED}✗ Not available${NC}"
    ((FAILURES++))
fi

echo -n "Checking GolangCI-Lint availability... "
if command -v golangci-lint >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Available${NC}"
else
    echo -e "${YELLOW}⚠ Not installed (will be installed in CI)${NC}"
fi

echo -n "Checking TFLint availability... "
if command -v tflint >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Available${NC}"
else
    echo -e "${YELLOW}⚠ Not installed (will be installed in CI)${NC}"
fi

echo ""
echo "📊 Linter Integration Summary:"
echo "============================="

if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}✅ Perfect! Linters are fully integrated with make and CI.${NC}"
    echo "ESLint, GolangCI-Lint, and Terraform linting work via make targets and CI!"
    exit 0
else
    echo -e "${RED}❌ Linter integration incomplete.${NC}"
    echo -e "Missing integration components: ${FAILURES}"
    echo ""
    echo "Implement make lint targets and add linting steps to CI workflow."
    exit 1
fi