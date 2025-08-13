#!/bin/bash

# validate-repo-protections.sh
# Script to validate GitHub repository protection rules are properly configured
# Part of T01.1a - Define Repo Rules and Protections

set -e

REPO_OWNER="${GITHUB_REPOSITORY_OWNER:-$(gh repo view --json owner --jq .owner.login)}"
REPO_NAME="${GITHUB_REPOSITORY_NAME:-$(gh repo view --json name --jq .name)}"

echo "🔍 Validating repository protections for ${REPO_OWNER}/${REPO_NAME}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILURES=0

check_protection() {
    local rule_name="$1"
    local check_command="$2"
    local expected="$3"
    
    echo -n "Checking ${rule_name}... "
    
    if eval "$check_command" | grep -q "$expected"; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        echo "  Expected: $expected"
        echo "  Command: $check_command"
        ((FAILURES++))
    fi
}

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: Not authenticated with GitHub CLI${NC}"
    exit 1
fi

echo "📋 Validating branch protection rules..."

# Main branch protection rules
MAIN_BRANCH="main"

# 1. PR reviews disabled for solo development
echo -n "Checking PR reviews disabled... "
PR_REVIEWS=$(gh api repos/${REPO_OWNER}/${REPO_NAME}/branches/${MAIN_BRANCH}/protection --jq '.required_pull_request_reviews // "null"')
if [[ "$PR_REVIEWS" == "null" ]]; then
    echo -e "${GREEN}✓ (Solo development mode)${NC}"
else
    echo -e "${RED}✗ PR reviews should be disabled for solo development${NC}"
    ((FAILURES++))
fi

# 4. Require status checks
check_protection "Status checks required" \
    "gh api repos/${REPO_OWNER}/${REPO_NAME}/branches/${MAIN_BRANCH}/protection --jq .required_status_checks.strict" \
    "true"

# 5. Required status check contexts (will be defined when CI is set up)
echo -n "Checking required CI contexts... "
REQUIRED_CONTEXTS=$(gh api repos/${REPO_OWNER}/${REPO_NAME}/branches/${MAIN_BRANCH}/protection --jq '.required_status_checks.contexts[]?' 2>/dev/null || echo "")
if [[ -n "$REQUIRED_CONTEXTS" ]]; then
    echo -e "${GREEN}✓ Found contexts: $REQUIRED_CONTEXTS${NC}"
else
    echo -e "${YELLOW}⚠ No required contexts set (will be configured with CI)${NC}"
fi

# 6. Restrict pushes (null means no restrictions)
echo -n "Checking restrict pushes... "
RESTRICTIONS=$(gh api repos/${REPO_OWNER}/${REPO_NAME}/branches/${MAIN_BRANCH}/protection --jq '.restrictions // "none"')
if [[ "$RESTRICTIONS" == "none" || "$RESTRICTIONS" == "" ]]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗ Expected no restrictions, got: $RESTRICTIONS${NC}"
    ((FAILURES++))
fi

# 7. Force push protection
check_protection "Block force pushes" \
    "gh api repos/${REPO_OWNER}/${REPO_NAME}/branches/${MAIN_BRANCH}/protection --jq .allow_force_pushes.enabled" \
    "false"

# 8. Delete protection
check_protection "Block branch deletion" \
    "gh api repos/${REPO_OWNER}/${REPO_NAME}/branches/${MAIN_BRANCH}/protection --jq .allow_deletions.enabled" \
    "false"

echo ""
echo "🔐 Validating repository security settings..."

# Repository security settings
# 1. Vulnerability alerts (API returns 204 if enabled, 404 if disabled)
echo -n "Checking vulnerability alerts... "
if gh api repos/${REPO_OWNER}/${REPO_NAME}/vulnerability-alerts &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗ Not enabled${NC}"
    ((FAILURES++))
fi

# 2. Automated security fixes (Dependabot)
check_protection "Automated security fixes" \
    "gh api repos/${REPO_OWNER}/${REPO_NAME}/automated-security-fixes --jq .enabled" \
    "true"

# 3. Public repository (contains no secrets)
check_protection "Repository visibility" \
    "gh api repos/${REPO_OWNER}/${REPO_NAME} --jq .private" \
    "false"

echo ""
echo "📝 Validating required repository files..."

# Required files that should exist
REQUIRED_FILES=("README.md" "LICENSE" ".gitignore" "CLAUDE.md")

for file in "${REQUIRED_FILES[@]}"; do
    echo -n "Checking ${file}... "
    if gh api repos/${REPO_OWNER}/${REPO_NAME}/contents/${file} &> /dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ Missing${NC}"
        ((FAILURES++))
    fi
done

echo ""
echo "🏷️ Validating repository topics and metadata..."

# Check for descriptive topics
TOPICS=$(gh api repos/${REPO_OWNER}/${REPO_NAME}/topics --jq '.names[]?' 2>/dev/null || echo "")
echo -n "Repository topics... "
if [[ -n "$TOPICS" ]]; then
    echo -e "${GREEN}✓ Found: $TOPICS${NC}"
else
    echo -e "${YELLOW}⚠ No topics set${NC}"
fi

# Check description
DESCRIPTION=$(gh api repos/${REPO_OWNER}/${REPO_NAME} --jq .description)
echo -n "Repository description... "
if [[ "$DESCRIPTION" != "null" && -n "$DESCRIPTION" ]]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠ No description set${NC}"
fi

echo ""
echo "📊 Summary:"
if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}✅ All critical repository protections are properly configured!${NC}"
    exit 0
else
    echo -e "${RED}❌ Found ${FAILURES} protection rule violations${NC}"
    echo "Please run the setup script to apply missing protections."
    exit 1
fi