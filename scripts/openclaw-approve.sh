#!/usr/bin/env bash
# openclaw-approve: Utility to auto-approve all pending device requests
echo "🔎 Checking for pending device requests..."
# Using full path to openclaw ensure it works regardless of shell
OPENCLAW="/home/node/.npm-global/bin/openclaw"
# Try multiple common keys for the request ID
IDS=$($OPENCLAW devices list --json | jq -r '.pending[] | .requestId // .id // .request' 2>/dev/null | grep -v "null")

if [ -z "$IDS" ]; then
  echo "✅ No pending requests found."
  exit 0
fi

for ID in $IDS; do
  echo "🚀 Approving request: $ID"
  $OPENCLAW devices approve "$ID"
done
