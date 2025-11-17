#!/usr/bin/env bash

# Requires: jq
# Usage: ./clickup-subtasks.sh CU-869aupbu6
# Or:     ./clickup-subtasks.sh 869aupbu6

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

if [ -z "$1" ]; then
  echo "❌ Please provide a ClickUp parent task ID (with or without CU- prefix)."
  exit 1
fi

INPUT_ID="$1"

# Strip CU- prefix if present (case-insensitive)
PARENT_ID="${INPUT_ID#CU-}"
PARENT_ID="${PARENT_ID#cu-}"

# Fetch parent task data
RESPONSE=$(curl -s -H "Authorization: $CLICKUP_API_TOKEN" \
  "https://api.clickup.com/api/v2/task/$PARENT_ID?include_subtasks=true")

SUBTASKS=$(echo "$RESPONSE" | jq '.subtasks')

if [ "$SUBTASKS" = "null" ]; then
  echo "❌ No subtasks found or invalid task ID."
  exit 1
fi

echo "$SUBTASKS" | jq -c '.[]' | while read -r sub; do
  RAW_ID=$(echo "$sub" | jq -r '.id')
  NAME=$(echo "$sub" | jq -r '.name')
  STATUS=$(echo "$sub" | jq -r '.status.status')

  # Checkbox: [x] if done, else [ ]
  if [[ "$STATUS" =~ ^(complete|signed off|qa|ready to release|released)$ ]]; then
    CHECKED="[x]"
  else
    CHECKED="[ ]"
  fi

  DISPLAY_ID="CU-$RAW_ID"

  LINK="https://app.clickup.com/t/$RAW_ID"

  echo "- $CHECKED [$DISPLAY_ID $NAME]($LINK)"
done
