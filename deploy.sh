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
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'
DIM='\033[2m'

# Box drawing characters
BOX_TL='╔'
BOX_TR='╗'
BOX_BL='╚'
BOX_BR='╝'
BOX_H='═'
BOX_V='║'

# Status symbols
PENDING='○'
RUNNING='◉'
SUCCESS='✓'
ERROR='✗'
WARNING='⚠'

# Progress tracking
declare -a STEPS=(
  "Security checks"
  "Git validation"
  "Staging changes"
  "Creating commit"
  "Pushing to GitHub"
  "Deployment triggered"
)
declare -a STEP_STATUS=()

# Initialize all steps as pending
for i in "${!STEPS[@]}"; do
  STEP_STATUS[$i]="pending"
done

# Function to draw the progress box
draw_progress_box() {
  local width=50
  local title=" Deployment Progress "
  
  # Clear previous box and move cursor
  echo -e "\033[2J\033[H"
  
  # Top border
  echo -e "${CYAN}${BOX_TL}$(printf '%*s' $width '' | tr ' ' "$BOX_H")${BOX_TR}${NC}"
  
  # Title
  local padding=$(( (width - ${#title}) / 2 ))
  echo -e "${CYAN}${BOX_V}${BOLD}$(printf '%*s' $padding '')${title}$(printf '%*s' $((width - padding - ${#title})) '')${NC}${CYAN}${BOX_V}${NC}"
  
  # Separator
  echo -e "${CYAN}${BOX_V}$(printf '%*s' $width '' | tr ' ' '─')${BOX_V}${NC}"
  
  # Steps
  for i in "${!STEPS[@]}"; do
    local step="${STEPS[$i]}"
    local status="${STEP_STATUS[$i]}"
    local symbol=""
    local color=""
    
    case $status in
      "pending")
        symbol="${DIM}${PENDING}${NC}"
        color="${DIM}"
        ;;
      "running")
        symbol="${YELLOW}${RUNNING}${NC}"
        color="${YELLOW}"
        ;;
      "success")
        symbol="${GREEN}${SUCCESS}${NC}"
        color="${GREEN}"
        ;;
      "error")
        symbol="${RED}${ERROR}${NC}"
        color="${RED}"
        ;;
    esac
    
    echo -e "${CYAN}${BOX_V}${NC} ${symbol} ${color}${step}${NC}$(printf '%*s' $((width - ${#step} - 4)) '')${CYAN}${BOX_V}${NC}"
  done
  
  # Bottom section
  echo -e "${CYAN}${BOX_V}$(printf '%*s' $width '' | tr ' ' '─')${BOX_V}${NC}"
  
  # Status message
  if [ -n "$1" ]; then
    local msg="$1"
    local msg_len=${#msg}
    if [ $msg_len -gt $((width - 2)) ]; then
      msg="${msg:0:$((width - 5))}..."
    fi
    echo -e "${CYAN}${BOX_V}${NC} ${DIM}${msg}${NC}$(printf '%*s' $((width - msg_len - 2)) '')${CYAN}${BOX_V}${NC}"
  else
    echo -e "${CYAN}${BOX_V}$(printf '%*s' $width '')${BOX_V}${NC}"
  fi
  
  # Bottom border
  echo -e "${CYAN}${BOX_BL}$(printf '%*s' $width '' | tr ' ' "$BOX_H")${BOX_BR}${NC}"
  echo ""
}

# Function to update step status
update_step() {
  local step_index=$1
  local status=$2
  local message=$3
  
  STEP_STATUS[$step_index]=$status
  draw_progress_box "$message"
  
  if [ "$status" == "running" ]; then
    sleep 0.3  # Brief pause for visual effect
  fi
}

# Function to show final success message
show_success() {
  clear
  local width=50
  
  echo ""
  echo -e "${GREEN}${BOX_TL}$(printf '%*s' $width '' | tr ' ' "$BOX_H")${BOX_TR}${NC}"
  echo -e "${GREEN}${BOX_V}${BOLD}$(printf '%*s' 12 '')✓ COMMITS PUBLISHED$(printf '%*s' 18 '')${NC}${GREEN}${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_V}$(printf '%*s' $width '' | tr ' ' '─')${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_V}${NC}  ${BOLD}Deployment Status:${NC} ${GREEN}Success${NC}$(printf '%*s' 21 '')${GREEN}${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_V}${NC}  ${BOLD}GitHub Actions:${NC} ${CYAN}Building...${NC}$(printf '%*s' 20 '')${GREEN}${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_V}$(printf '%*s' $width '')${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_V}${NC}  ${DIM}Your changes are being deployed${NC}$(printf '%*s' 11 '')${GREEN}${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_V}${NC}  ${DIM}Site will be live in 1-2 minutes${NC}$(printf '%*s' 9 '')${GREEN}${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_V}$(printf '%*s' $width '' | tr ' ' '─')${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_V}${NC}  ${CYAN}→${NC} Actions: github.com/rensschuil02/cyber-portfolio/actions  ${GREEN}${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_V}${NC}  ${CYAN}→${NC} Live Site: rensschuil02.github.io/cyber-portfolio     ${GREEN}${BOX_V}${NC}"
  echo -e "${GREEN}${BOX_BL}$(printf '%*s' $width '' | tr ' ' "$BOX_H")${BOX_BR}${NC}"
  echo ""
}

# Function to show error
show_error() {
  local error_msg="$1"
  clear
  local width=50
  
  echo ""
  echo -e "${RED}${BOX_TL}$(printf '%*s' $width '' | tr ' ' "$BOX_H")${BOX_TR}${NC}"
  echo -e "${RED}${BOX_V}${BOLD}$(printf '%*s' 16 '')✗ DEPLOYMENT FAILED$(printf '%*s' 15 '')${NC}${RED}${BOX_V}${NC}"
  echo -e "${RED}${BOX_V}$(printf '%*s' $width '' | tr ' ' '─')${BOX_V}${NC}"
  echo -e "${RED}${BOX_V}${NC}  ${error_msg}$(printf '%*s' $((width - ${#error_msg} - 2)) '')${RED}${BOX_V}${NC}"
  echo -e "${RED}${BOX_BL}$(printf '%*s' $width '' | tr ' ' "$BOX_H")${BOX_BR}${NC}"
  echo ""
}

# =============================================================================
# Main Deployment Flow
# =============================================================================

# Initial display
draw_progress_box "Initializing deployment..."
sleep 0.5

# Step 1: Security Checks
update_step 0 "running" "Checking for sensitive files..."

SENSITIVE_FILES=(".env" ".env.local" ".env.production" "*.key" "*.pem" "*.p12" "secrets.json")
FOUND_SENSITIVE=false

for pattern in "${SENSITIVE_FILES[@]}"; do
  if ls $pattern 2>/dev/null | grep -q .; then
    FOUND_SENSITIVE=true
    break
  fi
done

if [ "$FOUND_SENSITIVE" = true ]; then
  update_step 0 "error" "Sensitive files detected!"
  sleep 1
  show_error "Sensitive files found. Check .gitignore"
  exit 1
fi

if [ ! -f .gitignore ]; then
  update_step 0 "error" ".gitignore not found!"
  sleep 1
  show_error ".gitignore file is missing"
  exit 1
fi

update_step 0 "success" "Security checks passed"
sleep 0.5

# Step 2: Git Validation
update_step 1 "running" "Validating git repository..."

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  update_step 1 "error" "Not a git repository!"
  sleep 1
  show_error "Not a git repository. Run 'git init' first"
  exit 1
fi

update_step 1 "success" "Git repository validated"
sleep 0.5

# Step 3: Staging Changes
update_step 2 "running" "Staging all changes..."
git add . 2>/dev/null || {
  update_step 2 "error" "Failed to stage changes"
  sleep 1
  show_error "Could not stage changes"
  exit 1
}
update_step 2 "success" "Changes staged successfully"
sleep 0.5

# Step 4: Creating Commit
update_step 3 "running" "Enter commit message:"
draw_progress_box "Waiting for commit message..."
echo -e "${YELLOW}→${NC} Commit message (or press Enter for auto): "
read -r commit_msg

if [ -z "$commit_msg" ]; then
  commit_msg="Update portfolio: $(date +'%Y-%m-%d %H:%M:%S')"
fi

update_step 3 "running" "Creating commit: $commit_msg"
if git commit -m "$commit_msg" > /dev/null 2>&1; then
  update_step 3 "success" "Commit created successfully"
else
  update_step 3 "error" "Commit failed"
  sleep 1
  show_error "Failed to create commit"
  exit 1
fi
sleep 0.5

# Step 5: Pushing to GitHub
update_step 4 "running" "Pushing to remote repository..."
if git push origin main 2>&1 | grep -q "Everything up-to-date\|Total"; then
  update_step 4 "success" "Pushed to GitHub successfully"
else
  update_step 4 "error" "Push failed"
  sleep 1
  show_error "Failed to push to GitHub"
  exit 1
fi
sleep 0.5

# Step 6: Deployment Triggered
update_step 5 "running" "Triggering GitHub Actions..."
sleep 1
update_step 5 "success" "GitHub Actions triggered"
sleep 0.5

# Show final success
show_success