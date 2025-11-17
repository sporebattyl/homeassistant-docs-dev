#!/bin/bash
# Home Assistant Restart Script (HAOS-compatible)
# Restarts HA via supervisor API

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

echo "🔄 Restarting Home Assistant..."
echo "   Server: $HA_BASE"
echo ""

# Trigger restart via API
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    -H "Authorization: Bearer $HA_TOKEN" \
    -H "Content-Type: application/json" \
    "$HA_BASE/api/services/homeassistant/restart" 2>&1)

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

# Accept 200 (success) or 504 (timeout during restart - expected)
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "504" ]; then
    echo "✅ Restart initiated successfully"
    echo ""
    echo "⏳ Waiting for Home Assistant to restart..."

    # Wait 30 seconds initially (give HA time to shut down)
    sleep 30

    # Poll API for up to 12 attempts (1 minute total)
    for i in {1..12}; do
        echo "   Attempt $i/12: Checking if HA is ready..."

        CHECK_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
            -H "Authorization: Bearer $HA_TOKEN" \
            "$HA_BASE/api/" 2>&1)

        if [ "$CHECK_CODE" = "200" ]; then
            echo ""
            echo "✅ Home Assistant is back online!"
            echo ""
            echo "   Verify functionality:"
            echo "   • Browser: $HA_BASE"
            echo "   • Dashboard: Check all cards load properly"
            echo "   • Check logs for startup errors"
            exit 0
        fi

        # Wait 5 seconds before next attempt
        sleep 5
    done

    # If we get here, HA didn't come back up
    echo ""
    echo "❌ Timeout: Home Assistant did not come back online after 90 seconds"
    echo "   Check server status manually"
    exit 1
else
    echo "❌ Restart failed (HTTP $HTTP_CODE)"
    echo ""
    echo "Response:"
    echo "$RESPONSE" | head -n-1
    exit 1
fi
