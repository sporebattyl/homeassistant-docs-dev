#!/bin/bash
# Home Assistant Core Logs (via HAOS Supervisor API)
# Shows the most recent HA core logs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(dirname "$SCRIPT_DIR")"

# Load secrets
if [ -f "$REPO/state/secrets.env" ]; then
    source "$REPO/state/secrets.env"
else
    echo "❌ ERROR: secrets.env not found"
    exit 1
fi

if [ -z "$HA_TOKEN" ]; then
    echo "❌ ERROR: HA_TOKEN not set in secrets.env"
    exit 1
fi

HA_BASE="${HA_BASE:-http://192.168.88.125:8123}"

# Default to last 50 lines, or use argument
LINES="${1:-50}"

echo "📋 Home Assistant Core Logs (last $LINES lines)"
echo "================================================"
echo ""

curl -s -H "Authorization: Bearer $HA_TOKEN" \
    "$HA_BASE/api/hassio/core/logs" | tail -n "$LINES"
