#!/bin/bash

# --- Cybersecurity Portfolio Auto-Push Script ---

# 1. Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting deployment for rensschuil02...${NC}"

# 2. Basic Security Check: Ensure we aren't pushing .env files
if [ -f .env ]; then
    echo -e "${RED}Warning: .env file detected.${NC} Ensure it is in .gitignore before proceeding."
fi

# 3. Add all changes
git add .

# 4. Prompt for a commit message
echo -e "${GREEN}Enter commit message:${NC}"
read commit_msg

if [ -z "$commit_msg" ]
then
    commit_msg="Update portfolio: $(date +'%Y-%m-%d %H:%M')"
fi

# 5. Commit and Push
git commit -m "$commit_msg"

echo -e "${GREEN}Pushing to GitHub...${NC}"
git push origin main

echo -e "${GREEN}Done! Site is being deployed.${NC}"