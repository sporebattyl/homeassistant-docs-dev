#!/bin/bash
# Home Assistant Error Logs Only
# Filters core logs to show only ERROR and WARNING lines

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

# Default to last 100 lines to search, or use argument
LINES="${1:-100}"

echo "🚨 Home Assistant Errors & Warnings (from last $LINES lines)"
echo "=============================================================="
echo ""

curl -s -H "Authorization: Bearer $HA_TOKEN" \
    "$HA_BASE/api/hassio/core/logs" | \
    tail -n "$LINES" | \
    grep -E "(ERROR|WARNING|CRITICAL)" --color=always

EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo ""
    echo "✅ No errors or warnings found in last $LINES log lines"
fi
