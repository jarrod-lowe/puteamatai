#!/bin/bash

# setup-repo-protections.sh
# Script to apply GitHub repository protection rules
# Part of T01.1a - Define Repo Rules and Protections
# This script will be used by T01.1b to actually apply the protections

set -e

REPO_OWNER="${GITHUB_REPOSITORY_OWNER:-$(gh repo view --json owner --jq .owner.login)}"
REPO_NAME="${GITHUB_REPOSITORY_NAME:-$(gh repo view --json name --jq .name)}"
MAIN_BRANCH="${MAIN_BRANCH:-main}"

echo "🔧 Setting up repository protections for ${REPO_OWNER}/${REPO_NAME}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: Not authenticated with GitHub CLI${NC}"
    exit 1
fi

echo "📋 Applying branch protection rules for ${MAIN_BRANCH}..."

# Apply branch protection rules using raw JSON
gh api --method PUT \
    repos/${REPO_OWNER}/${REPO_NAME}/branches/${MAIN_BRANCH}/protection \
    --input - << 'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": []
  },
  "enforce_admins": true,
  "required_pull_request_reviews": null,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF

echo -e "${GREEN}✅ Branch protection rules applied${NC}"

echo "🔐 Configuring repository security settings..."

# Enable vulnerability alerts
gh api --method PUT repos/${REPO_OWNER}/${REPO_NAME}/vulnerability-alerts \
    || echo -e "${YELLOW}⚠ Vulnerability alerts may already be enabled${NC}"

# Enable automated security fixes (Dependabot)
gh api --method PUT repos/${REPO_OWNER}/${REPO_NAME}/automated-security-fixes \
    || echo -e "${YELLOW}⚠ Automated security fixes may already be enabled${NC}"

echo -e "${GREEN}✅ Security settings configured${NC}"

echo "🏷️ Setting repository metadata..."

# Set repository description and ensure public visibility
gh repo edit --description "PūteaMātai - Personal finance tracking and analysis webapp with predictive analytics" \
             --visibility public --accept-visibility-change-consequences

# Add topics
gh repo edit --add-topic "finance" \
             --add-topic "aws" \
             --add-topic "serverless" \
             --add-topic "golang" \
             --add-topic "typescript" \
             --add-topic "dynamodb" \
             --add-topic "terraform"

echo -e "${GREEN}✅ Repository metadata configured${NC}"

echo "📝 Repository protection setup complete!"
echo ""
echo "Next steps:"
echo "1. Create CODEOWNERS file (if not exists)"
echo "2. Set up CI/CD workflows to add required status checks"
echo "3. Run validation script: ./tests/validate-repo-protections.sh"