#!/bin/bash

# validate-github-pipelines.sh
# Script to validate GitHub Actions workflow configuration and pipeline setup
# Part of T01.8a - Check GitHub Pipelines Setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILURES=0

echo "🚀 Validating GitHub Actions pipeline setup..."

# Function to check if a file exists locally
check_workflow_file() {
    local file_name="$1"
    local required="${2:-true}"
    local description="${3:-$file_name}"
    
    echo -n "Checking ${description}... "
    
    if [[ -f "$file_name" ]]; then
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

# Function to check workflow content
check_workflow_content() {
    local file_name="$1"
    local pattern="$2" 
    local description="$3"
    
    if [[ -f "$file_name" ]]; then
        echo -n "Checking ${description}... "
        if grep -q "$pattern" "$file_name" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗ Content missing${NC}"
            ((FAILURES++))
        fi
    fi
}

echo ""
echo "📁 GitHub Actions Directory Structure:"

# Check .github directory exists
echo -n "Checking .github/ directory... "
if [[ -d ".github" ]]; then
    echo -e "${GREEN}✓ Present${NC}"
else
    echo -e "${RED}✗ Missing directory${NC}"
    ((FAILURES++))
fi

# Check .github/workflows directory exists  
echo -n "Checking .github/workflows/ directory... "
if [[ -d ".github/workflows" ]]; then
    echo -e "${GREEN}✓ Present${NC}"
else
    echo -e "${RED}✗ Missing workflows directory${NC}"
    ((FAILURES++))
fi

echo ""
echo "🔧 Workflow Configuration Files:"

# Essential workflow files
check_workflow_file ".github/workflows/test.yml" "true" "Test workflow (test.yml)"
check_workflow_file ".github/workflows/ci.yml" "false" "CI workflow (ci.yml)"

echo ""
echo "📋 Workflow Content Validation:"

# Check test workflow content if it exists
TEST_WORKFLOW=".github/workflows/test.yml"
if [[ -f "$TEST_WORKFLOW" ]]; then
    check_workflow_content "$TEST_WORKFLOW" "on:" "Workflow triggers defined"
    check_workflow_content "$TEST_WORKFLOW" "runs-on:" "Runner specification"
    check_workflow_content "$TEST_WORKFLOW" "make test" "Test command execution"
else
    echo "⚠️ Cannot validate workflow content - test.yml missing"
    ((FAILURES++))
fi

echo ""
echo "🏗️ Pipeline Integration Check:"

# Check if workflows are integrated with our test infrastructure
echo -n "Checking integration with make commands... "
if [[ -f "$TEST_WORKFLOW" ]] && grep -q "make" "$TEST_WORKFLOW" 2>/dev/null; then
    echo -e "${GREEN}✓ Integrated with Makefile${NC}"
else
    echo -e "${RED}✗ Not integrated with build system${NC}"
    ((FAILURES++))
fi

echo ""
echo "📊 GitHub Actions Pipeline Validation Summary:"
echo "============================================"

if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}✅ Perfect! GitHub Actions pipelines are properly configured.${NC}"
    echo "CI/CD infrastructure is ready for automated testing!"
    exit 0
else
    echo -e "${RED}❌ Pipeline setup incomplete.${NC}"
    echo -e "Missing pipeline components: ${FAILURES}"
    echo ""
    echo "Run T01.8b to create missing GitHub Actions workflows."
    exit 1
fi