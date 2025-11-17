#!/usr/bin/env bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from .env file in the script's directory
if [ -f "$SCRIPT_DIR/.env" ]; then
  eval export $(cat "$SCRIPT_DIR/.env")
else
  echo "❌ .env file not found in $SCRIPT_DIR"
  exit 1
fi

CLICKUP_API_TOKEN="${CLICKUP_API_TOKEN:?Missing CLICKUP_API_TOKEN environment variable}"

# -Get the current branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Extract ClickUp task ID (supports letters and numbers)
FULL_TASK_ID=$(echo "$BRANCH" | grep -oE '[Cc][Uu]-[A-Za-z0-9]+' | head -n 1)

if [ -z "$FULL_TASK_ID" ]; then
  echo -e "❌ \033[1;31mNo ClickUp task ID found in branch:\033[0m $BRANCH"
  exit 1
fi

# Normalize to uppercase for display
DISPLAY_TASK_ID=$(echo "$FULL_TASK_ID" | tr '[:lower:]' '[:upper:]')

# Remove "CU-" before calling the API
API_TASK_ID=${FULL_TASK_ID#CU-}
API_TASK_ID=${API_TASK_ID#cu-}  # just in case lowercase

# Fetch task info from ClickUp API
RESPONSE=$(curl -s -H "Authorization: $CLICKUP_API_TOKEN" \
  "https://api.clickup.com/api/v2/task/$API_TASK_ID")

# Extract info
TITLE=$(echo "$RESPONSE" | jq -r '.name // empty')
STATUS=$(echo "$RESPONSE" | jq -r '.status.status // empty')
ASSIGNEES=$(echo "$RESPONSE" | jq -r '[.assignees[].username] | join(", ") // empty')

# Display with colors
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
BOLD='\033[1m'
RESET='\033[0m'

echo -e "${BOLD}🪶 ClickUp Task:${RESET} ${CYAN}$DISPLAY_TASK_ID${RESET}"
echo -e "${BOLD}📋 Title:${RESET} ${GREEN}$TITLE${RESET}"
if [ -n "$STATUS" ]; then
  echo -e "${BOLD}📊 Status:${RESET} ${YELLOW}$STATUS${RESET}"
fi
if [ -n "$ASSIGNEES" ]; then
  echo -e "${BOLD}👤 Assignees:${RESET} $ASSIGNEES"
fi
echo -e "${BOLD}🔗 Link:${RESET} https://app.clickup.com/t/$API_TASK_ID"
