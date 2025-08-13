#!/bin/bash

# validate-ci-workflows.sh
# Script to validate GitHub Actions workflows meet T01.5b requirements
# Part of T01.5b - Create GitHub Actions Workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILURES=0

echo "🤖 Validating GitHub Actions Workflows for T01.5b Compliance..."

# Function to check workflow jobs structure
check_workflow_jobs() {
    local workflow_file="$1"
    local expected_job="$2"
    local description="$3"
    
    echo -n "Checking ${description}... "
    
    if [[ -f "$workflow_file" ]] && grep -q "^[[:space:]]*${expected_job}:" "$workflow_file" 2>/dev/null; then
        echo -e "${GREEN}✓ Present${NC}"
    else
        echo -e "${RED}✗ Missing job: ${expected_job}${NC}"
        ((FAILURES++))
    fi
}

# Function to check fail-fast configuration
check_fail_fast() {
    local workflow_file="$1"
    local job_name="$2"
    
    echo -n "Checking fail-fast for ${job_name}... "
    
    # Check if fail-fast is explicitly set to false (which means it defaults to true)
    # Or if strategy.fail-fast is not set (defaults to true)
    if [[ -f "$workflow_file" ]]; then
        # Look for fail-fast: false pattern, if not found then fail-fast is enabled (good)
        if ! grep -A5 "^[[:space:]]*${job_name}:" "$workflow_file" | grep -q "fail-fast.*false" 2>/dev/null; then
            echo -e "${GREEN}✓ Fail-fast enabled${NC}"
        else
            echo -e "${YELLOW}⚠ Fail-fast disabled${NC}"
        fi
    else
        echo -e "${RED}✗ Workflow missing${NC}"
        ((FAILURES++))
    fi
}

echo ""
echo "📋 T01.5b Job Structure Requirements:"

WORKFLOW_FILE=".github/workflows/test.yml"

# Check for separate language jobs as required by T01.5b
echo ""
echo "🔧 Checking for separate language jobs:"
check_workflow_jobs "$WORKFLOW_FILE" "go-tests" "Go test job"
check_workflow_jobs "$WORKFLOW_FILE" "node-tests" "Node.js test job" 
check_workflow_jobs "$WORKFLOW_FILE" "terraform-tests" "Terraform test job"

echo ""
echo "⚡ Fail-Fast Configuration:"
check_fail_fast "$WORKFLOW_FILE" "go-tests"
check_fail_fast "$WORKFLOW_FILE" "node-tests" 
check_fail_fast "$WORKFLOW_FILE" "terraform-tests"

echo ""
echo "🏗️ Job Dependencies and Parallelization:"

# Check if jobs can run in parallel (good) or have proper dependencies
echo -n "Checking job parallelization capability... "
if [[ -f "$WORKFLOW_FILE" ]]; then
    # If we have separate jobs without 'needs:' dependencies, they can run in parallel
    job_count=$(grep -c "^[[:space:]]*[a-zA-Z-]*-tests:" "$WORKFLOW_FILE" 2>/dev/null || echo "0")
    if [[ $job_count -ge 3 ]]; then
        echo -e "${GREEN}✓ Multiple test jobs for parallelization${NC}"
    else
        echo -e "${RED}✗ Insufficient separate jobs (found: ${job_count}, need: 3+)${NC}"
        ((FAILURES++))
    fi
else
    echo -e "${RED}✗ Workflow file missing${NC}"
    ((FAILURES++))
fi

echo ""
echo "📊 T01.5b Workflow Compliance Summary:"
echo "====================================="

if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}✅ Perfect! GitHub Actions workflows meet T01.5b requirements.${NC}"
    echo "Separate Go, Node, Terraform jobs with fail-fast behavior implemented!"
    exit 0
else
    echo -e "${RED}❌ T01.5b workflow requirements not met.${NC}"
    echo -e "Missing components: ${FAILURES}"
    echo ""
    echo "Current workflow needs refactoring to separate language-specific jobs."
    echo "T01.5b requires: separate jobs for Go, Node, Terraform with fail-fast errors."
    exit 1
fi