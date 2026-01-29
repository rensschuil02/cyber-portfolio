#!/bin/bash

# =============================================================================
# Cybersecurity Portfolio - Secure Deployment Script
# =============================================================================
# This script safely commits and pushes changes to GitHub
# Author: Rens Schuil
# Repository: https://github.com/rensschuil02/cyber-portfolio
# =============================================================================

set -e  # Exit on any error

# Colors for terminal output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${CYAN}→${NC} $1"; }

# Header
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}   Cybersecurity Portfolio Deployment${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# =============================================================================
# Security Checks
# =============================================================================

print_info "Running security checks..."

# Check for sensitive files
SENSITIVE_FILES=(".env" ".env.local" ".env.production" "*.key" "*.pem" "*.p12" "secrets.json")
FOUND_SENSITIVE=false

for pattern in "${SENSITIVE_FILES[@]}"; do
    if ls $pattern 2>/dev/null | grep -q .; then
        print_warning "Sensitive file detected: $pattern"
        FOUND_SENSITIVE=true
    fi
done

if [ "$FOUND_SENSITIVE" = true ]; then
    print_warning "Ensure sensitive files are in .gitignore"
    echo -n "Continue anyway? (y/N): "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_error "Deployment cancelled"
        exit 1
    fi
fi

# Check if .gitignore exists
if [ ! -f .gitignore ]; then
    print_warning ".gitignore file not found!"
fi

print_success "Security checks passed"
echo ""

# =============================================================================
# Git Status Check
# =============================================================================

print_info "Checking repository status..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not a git repository. Run 'git init' first."
    exit 1
fi

# Check for uncommitted changes
if git diff-index --quiet HEAD -- 2>/dev/null; then
    print_warning "No changes to commit"
    echo -n "Push anyway? (y/N): "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Deployment cancelled"
        exit 0
    fi
else
    print_success "Changes detected"
fi

echo ""

# =============================================================================
# Git Operations
# =============================================================================

# Show what will be committed
print_info "Files to be committed:"
git status --short
echo ""

# Get commit message
print_info "Enter commit message (or press Enter for auto-generated):"
read -r commit_msg

# Generate default message if empty
if [ -z "$commit_msg" ]; then
    commit_msg="Update portfolio: $(date +'%Y-%m-%d %H:%M:%S')"
    print_info "Using auto-generated message: $commit_msg"
fi

# Stage all changes
print_info "Staging changes..."
git add .

# Commit
print_info "Creating commit..."
if git commit -m "$commit_msg"; then
    print_success "Commit created successfully"
else
    print_error "Commit failed"
    exit 1
fi

echo ""

# Push to remote
print_info "Pushing to GitHub..."
if git push origin main; then
    print_success "Successfully pushed to GitHub!"
else
    print_error "Push failed. Check your credentials and network connection."
    print_warning "You may need to run: git push -u origin main"
    exit 1
fi

echo ""

# =============================================================================
# Deployment Status
# =============================================================================

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}   Deployment Complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
print_success "Code pushed to GitHub"
print_info "GitHub Actions will now build and deploy your site"
print_info "View deployment: https://github.com/rensschuil02/cyber-portfolio/actions"
print_info "Live site: https://rensschuil02.github.io/cyber-portfolio"
echo ""
print_info "Deployment typically takes 1-2 minutes"
echo ""