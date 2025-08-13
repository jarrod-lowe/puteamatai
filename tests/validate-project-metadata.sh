#!/bin/bash

# validate-project-metadata.sh
# Script to validate comprehensive project metadata and essential files
# Part of T01.7a - Define Metadata Validation Rules

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILURES=0

echo "📋 Validating comprehensive project metadata..."

# Function to check if a file exists locally
check_local_file() {
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

# Function to check file content
check_file_content() {
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
echo "📄 Essential Project Files:"

# Core documentation files
check_local_file "README.md" "true" "README documentation"
check_local_file "LICENSE" "true" "License file"
check_local_file "CLAUDE.md" "true" "AI assistant guidance"

echo ""
echo "🛠️ Development Configuration Files:"

# Development environment files
check_local_file ".gitignore" "true" "Git ignore rules"
check_local_file ".editorconfig" "false" "Editor configuration"
check_local_file "Makefile" "true" "Build system"

echo ""
echo "📦 Language-Specific Metadata:"

# Go project metadata
check_local_file "go.mod" "true" "Go module definition"

# Node.js project metadata  
check_local_file "package.json" "true" "Node.js project metadata"
check_local_file "package-lock.json" "true" "Node.js dependency lock"

echo ""
echo "🧪 Testing Infrastructure:"

# Test configuration
check_local_file "tests/test-required-tools.sh" "true" "Development environment tests"
check_local_file "tests/validate-repo-protections.sh" "true" "Repository protection validation"

echo ""
echo "📋 Content Validation:"

# Check critical file contents
check_file_content "package.json" "puteamatai" "Package name in package.json"
check_file_content "go.mod" "github.com/jarrod-lowe/puteamatai" "Go module path"
check_file_content "Makefile" "help:" "Makefile help target"

echo ""
echo "🏗️ Project Structure Validation:"

# Check directory structure
REQUIRED_DIRS=("tests" "scripts" "docs" "design")

for dir in "${REQUIRED_DIRS[@]}"; do
    echo -n "Checking ${dir}/ directory... "
    if [[ -d "$dir" ]]; then
        echo -e "${GREEN}✓ Present${NC}"
    else
        echo -e "${RED}✗ Missing directory${NC}"
        ((FAILURES++))
    fi
done

echo ""
echo "📊 Metadata Validation Summary:"
echo "================================"

if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}✅ Perfect! All required project metadata is present.${NC}"
    echo "Project structure and metadata are ready for development!"
    exit 0
else
    echo -e "${RED}❌ Metadata validation incomplete.${NC}"
    echo -e "Missing required files/content: ${FAILURES}"
    echo ""
    echo "Run T01.7b to create missing project metadata files."
    exit 1
fi