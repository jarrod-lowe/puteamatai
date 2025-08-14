#!/bin/bash

# validate-typescript-compilation.sh
# Script to validate TypeScript to JavaScript compilation process
# Part of T01.9a - Tests of typescript -> javascript compilation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILURES=0

echo "🔄 Validating TypeScript to JavaScript Compilation Process..."

# Function to check if TypeScript tooling is available
check_typescript_tool() {
    local tool="$1"
    local description="$2"
    
    echo -n "Checking ${description}... "
    
    if command -v "$tool" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Available${NC}"
    elif npm list -g "$tool" >/dev/null 2>&1 || npm list "$tool" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Available via npm${NC}"
    else
        echo -e "${RED}✗ Missing${NC}"
        ((FAILURES++))
    fi
}

# Function to check TypeScript configuration
check_typescript_config() {
    local config_file="$1"
    local description="$2"
    local required="$3"
    
    echo -n "Checking ${description}... "
    
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

# Function to test TypeScript compilation
test_typescript_compilation() {
    local ts_file="$1"
    local expected_js_file="$2"
    local description="$3"
    
    echo -n "Testing ${description}... "
    
    if [[ ! -f "$ts_file" ]]; then
        echo -e "${YELLOW}⚠ TypeScript source missing${NC}"
        return
    fi
    
    # Try to compile TypeScript file
    if npx tsc "$ts_file" --outDir dist/ --target es2020 --module commonjs 2>/dev/null; then
        if [[ -f "$expected_js_file" ]]; then
            echo -e "${GREEN}✓ Compilation successful${NC}"
        else
            echo -e "${RED}✗ Compilation ran but no output file${NC}"
            ((FAILURES++))
        fi
    else
        echo -e "${RED}✗ Compilation failed${NC}"
        ((FAILURES++))
    fi
}

# Function to test JavaScript execution after compilation
test_compiled_javascript() {
    local js_file="$1"
    local description="$2"
    
    echo -n "Testing ${description}... "
    
    if [[ ! -f "$js_file" ]]; then
        echo -e "${YELLOW}⚠ Compiled JavaScript missing${NC}"
        return
    fi
    
    # Try to execute compiled JavaScript
    if node "$js_file" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Execution successful${NC}"
    else
        echo -e "${RED}✗ Runtime error${NC}"
        ((FAILURES++))
    fi
}

echo ""
echo "🛠️ TypeScript Tooling Check:"

check_typescript_tool "tsc" "TypeScript compiler"
check_typescript_tool "ts-node" "TypeScript runtime"

echo ""
echo "📋 TypeScript Configuration:"

check_typescript_config "tsconfig.json" "TypeScript configuration" "true"
check_typescript_config "package.json" "Package.json with TypeScript scripts" "true"

echo ""
echo "🔧 TypeScript to JavaScript Compilation Tests:"

# Create test directory for compilation outputs
mkdir -p dist/

# Test compilation of demo TypeScript files
test_typescript_compilation "tests/typescript-samples/demo.ts" "dist/demo.js" "demo TypeScript file compilation"
test_typescript_compilation "tests/typescript-samples/types.ts" "dist/types.js" "TypeScript with types compilation"
test_typescript_compilation "tests/typescript-samples/modules.ts" "dist/modules.js" "TypeScript modules compilation"

echo ""
echo "🚀 Compiled JavaScript Execution Tests:"

# Test that compiled JavaScript actually runs
test_compiled_javascript "dist/demo.js" "compiled demo.js execution"
test_compiled_javascript "dist/types.js" "compiled types.js execution"
test_compiled_javascript "dist/modules.js" "compiled modules.js execution"

echo ""
echo "📦 Package.json Script Integration:"

# Check if build scripts are defined
echo -n "Checking npm build script... "
if npm run build --silent >/dev/null 2>&1; then
    echo -e "${GREEN}✓ npm run build works${NC}"
else
    echo -e "${RED}✗ npm run build missing or broken${NC}"
    ((FAILURES++))
fi

echo -n "Checking npm type checking script... "
if npm run type-check --silent >/dev/null 2>&1; then
    echo -e "${GREEN}✓ npm run type-check works${NC}"
else
    echo -e "${RED}✗ npm run type-check missing or broken${NC}"
    ((FAILURES++))
fi

echo ""
echo "📊 TypeScript Compilation Validation Summary:"
echo "============================================="

if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}✅ Perfect! TypeScript compilation process is working correctly.${NC}"
    echo "TypeScript compiles to JavaScript and executes successfully!"
    exit 0
else
    echo -e "${RED}❌ TypeScript compilation setup incomplete.${NC}"
    echo -e "Missing components: ${FAILURES}"
    echo ""
    echo "Run T01.9b to implement TypeScript compilation infrastructure."
    exit 1
fi