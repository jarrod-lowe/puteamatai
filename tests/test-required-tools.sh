#!/bin/bash

# test-required-tools.sh
# Simple test that fails if required development tools are missing
# Part of T01.2a - Define Tooling Environment Checks

set -e

echo "🧪 Testing required development tools are available..."

FAILURES=0

# Test each required tool
test_tool() {
    local tool="$1"
    echo -n "Testing $tool is available... "
    
    if command -v "$tool" &> /dev/null; then
        echo "✓"
    else
        echo "✗ MISSING"
        ((FAILURES++))
    fi
}

# Required tools for PūteaMātai development
test_tool "docker"
test_tool "make" 
test_tool "git"
test_tool "gh"
test_tool "go"
test_tool "node"
test_tool "npm"
test_tool "terraform"

if [[ $FAILURES -gt 0 ]]; then
    echo "❌ $FAILURES required tools are missing!"
    exit 1
else
    echo "✅ All required tools are available!"
    exit 0
fi