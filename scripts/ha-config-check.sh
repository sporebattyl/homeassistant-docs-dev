#!/bin/bash
# Home Assistant Configuration Check Script
# Validates HA configuration via REST API

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(dirname "$SCRIPT_DIR")"

# Load secrets
if [ -f "$REPO/state/secrets.env" ]; then
    source "$REPO/state/secrets.env"
else
    echo "❌ ERROR: secrets.env not found"
    exit 1
fi

# Validate token
if [ -z "$HA_TOKEN" ]; then
    echo "❌ ERROR: HA_TOKEN not set in secrets.env"
    exit 1
fi

HA_BASE="${HA_BASE:-http://192.168.88.125:8123}"

curl -X POST \
  -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  "$HA_BASE/api/config/core/check_config" \
  2>/dev/null | jq .
