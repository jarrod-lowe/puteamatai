#!/bin/bash

# setup-dev-environment.sh  
# Script to install missing development tools
# Part of T01.2b - Create Makefile and Tooling Scripts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🛠️  PūteaMātai Development Environment Setup${NC}"
echo ""

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    OS="windows"
fi

echo "Detected OS: $OS"
echo ""

# Function to check if a tool is installed
tool_installed() {
    command -v "$1" &> /dev/null
}

# Function to install a tool
install_tool() {
    local tool="$1"
    local install_cmd="$2"
    
    if tool_installed "$tool"; then
        echo -e "${GREEN}✓ $tool already installed${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}⚡ Installing $tool...${NC}"
    if eval "$install_cmd"; then
        echo -e "${GREEN}✅ $tool installed successfully${NC}"
    else
        echo -e "${RED}❌ Failed to install $tool${NC}"
        echo "Please install $tool manually"
        return 1
    fi
}

echo "🔍 Checking and installing development tools..."
echo ""

# Docker - Required for containerized development
if ! tool_installed "docker"; then
    echo -e "${YELLOW}🐳 Docker not found${NC}"
    case $OS in
        "macos")
            echo "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
            echo "Or use Homebrew: brew install --cask docker"
            ;;
        "linux")
            echo "Installing Docker via package manager..."
            install_tool "docker" "curl -fsSL https://get.docker.com | sh"
            ;;
        "windows")
            echo "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
            ;;
    esac
else
    echo -e "${GREEN}✓ Docker already installed${NC}"
fi

# Go - Required for backend Lambda functions  
if ! tool_installed "go"; then
    echo -e "${YELLOW}🔧 Go not found${NC}"
    case $OS in
        "macos")
            install_tool "go" "brew install go"
            ;;
        "linux")
            echo "Please install Go from: https://golang.org/dl/"
            echo "Or use your package manager (apt install golang-go, yum install golang, etc.)"
            ;;
        "windows")
            echo "Please install Go from: https://golang.org/dl/"
            ;;
    esac
else
    echo -e "${GREEN}✓ Go already installed${NC}"
fi

# Node.js - Required for frontend TypeScript
if ! tool_installed "node"; then
    echo -e "${YELLOW}📦 Node.js not found${NC}"
    case $OS in
        "macos")
            install_tool "node" "brew install node"
            ;;
        "linux")
            echo "Installing Node.js via NodeSource repository..."
            install_tool "node" "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs"
            ;;
        "windows")
            echo "Please install Node.js from: https://nodejs.org/"
            ;;
    esac
else
    echo -e "${GREEN}✓ Node.js already installed${NC}"
fi

# Terraform - Required for infrastructure as code
if ! tool_installed "terraform"; then
    echo -e "${YELLOW}🏗️  Terraform not found${NC}"
    case $OS in
        "macos")
            install_tool "terraform" "brew install terraform"
            ;;
        "linux")
            echo "Installing Terraform..."
            install_tool "terraform" 'wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list && sudo apt update && sudo apt install terraform'
            ;;
        "windows")
            echo "Please install Terraform from: https://www.terraform.io/downloads.html"
            ;;
    esac
else
    echo -e "${GREEN}✓ Terraform already installed${NC}"
fi

# GitHub CLI - Required for repository management (should already be available if repo was cloned)
if ! tool_installed "gh"; then
    echo -e "${YELLOW}🐱 GitHub CLI not found${NC}"
    case $OS in
        "macos")
            install_tool "gh" "brew install gh"
            ;;
        "linux")
            install_tool "gh" "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && sudo apt update && sudo apt install gh"
            ;;
        "windows")
            echo "Please install GitHub CLI from: https://cli.github.com/"
            ;;
    esac
else
    echo -e "${GREEN}✓ GitHub CLI already installed${NC}"
fi

echo ""
echo "🎯 Setup complete! Running environment check..."
echo ""

# Run the environment check to see final status
if ./tests/test-required-tools.sh; then
    echo ""
    echo -e "${GREEN}✅ Perfect! All required tools are now installed.${NC}"
    echo "You're ready to develop PūteaMātai! 🎉"
    echo ""
    echo "Next steps:"
    echo "  make dev     # Start development environment"
    echo "  make test    # Run all tests"
    echo "  make help    # See all available commands"
else
    echo ""
    echo -e "${YELLOW}⚠️  Some tools may still need manual installation.${NC}"
    echo "Please check the output above and install any remaining tools manually."
    echo ""
    echo "Run 'make env-check' to see current status."
fi