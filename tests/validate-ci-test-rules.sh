#!/bin/bash

# validate-ci-test-rules.sh
# Script to validate CI/CD test enforcement rules and policies are properly defined
# Part of T01.5a - Define CI Test Rules

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILURES=0

echo "🤖 Validating CI Test Rules and Enforcement Policies..."

# Function to check if a file exists and has required content
check_ci_rule_file() {
    local file_name="$1"
    local required="$2"
    local description="$3"
    
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

# Function to check CI rule content
check_ci_rule_content() {
    local file_name="$1"
    local pattern="$2" 
    local description="$3"
    
    if [[ -f "$file_name" ]]; then
        echo -n "Checking ${description}... "
        if grep -q "$pattern" "$file_name" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗ Rule missing${NC}"
            ((FAILURES++))
        fi
    fi
}

echo ""
echo "📋 CI Test Rule Definition Files:"

# Essential CI rule files
check_ci_rule_file "docs/ci-test-rules.md" "true" "CI Test Rules documentation"
check_ci_rule_file "docs/coverage-requirements.md" "false" "Coverage requirements"
check_ci_rule_file ".github/PULL_REQUEST_TEMPLATE.md" "false" "PR template with test checklist"

echo ""
echo "🧪 Test Enforcement Rules Validation:"

# Check if CI rules document exists and has required sections
CI_RULES_DOC="docs/ci-test-rules.md"
if [[ -f "$CI_RULES_DOC" ]]; then
    check_ci_rule_content "$CI_RULES_DOC" "Test Requirements" "Test requirements section defined"
    check_ci_rule_content "$CI_RULES_DOC" "Coverage" "Coverage policies defined" 
    check_ci_rule_content "$CI_RULES_DOC" "Linting" "Linting enforcement rules defined"
    check_ci_rule_content "$CI_RULES_DOC" "Fail Fast" "Fail-fast policies defined"
    check_ci_rule_content "$CI_RULES_DOC" "Language-Specific" "Language-specific rules defined"
else
    echo "⚠️ Cannot validate CI rules content - documentation missing"
    ((FAILURES++))
fi

echo ""
echo "🚀 Pipeline Integration Check:"

# Check if workflows enforce the defined rules
WORKFLOW_FILE=".github/workflows/test.yml"
echo -n "Checking workflow enforces test requirements... "
if [[ -f "$WORKFLOW_FILE" ]] && grep -q "make.*test" "$WORKFLOW_FILE" 2>/dev/null; then
    echo -e "${GREEN}✓ Tests enforced${NC}"
else
    echo -e "${RED}✗ Test enforcement missing${NC}"
    ((FAILURES++))
fi

echo -n "Checking fail-fast configuration... "
if [[ -f "$WORKFLOW_FILE" ]] && (grep -q "fail-fast.*false" "$WORKFLOW_FILE" 2>/dev/null || ! grep -q "fail-fast" "$WORKFLOW_FILE" 2>/dev/null); then
    echo -e "${GREEN}✓ Proper fail-fast policy${NC}"
else
    echo -e "${RED}✗ Fail-fast policy needs review${NC}"
    ((FAILURES++))
fi

echo ""
echo "📊 CI Test Rules Validation Summary:"
echo "===================================="

if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}✅ Perfect! CI test rules are properly defined and enforced.${NC}"
    echo "All coverage, linting, and test enforcement policies are in place!"
    exit 0
else
    echo -e "${RED}❌ CI test rules incomplete.${NC}"
    echo -e "Missing rule definitions: ${FAILURES}"
    echo ""
    echo "Run T01.5b to implement missing CI test rule enforcement."
    exit 1
fi