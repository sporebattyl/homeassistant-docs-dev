#!/bin/bash
# Home Assistant All Logs (via HAOS Supervisor API)
# Shows logs from all available sources

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

# Default to last 20 lines per source
LINES="${1:-20}"

echo "================================================"
echo "  Home Assistant All Logs"
echo "================================================"
echo ""

# 1. Core logs
echo "=== 1. Home Assistant Core (last $LINES lines) ==="
curl -s -H "Authorization: Bearer $HA_TOKEN" \
    "$HA_BASE/api/hassio/core/logs" | tail -n "$LINES"
echo ""

# 2. Supervisor logs
echo "=== 2. Supervisor (last $LINES lines) ==="
curl -s -H "Authorization: Bearer $HA_TOKEN" \
    "$HA_BASE/api/hassio/supervisor/logs" | tail -n "$LINES"
echo ""

# 3. Host logs
echo "=== 3. Host System (last $LINES lines) ==="
curl -s -H "Authorization: Bearer $HA_TOKEN" \
    "$HA_BASE/api/hassio/host/logs" | tail -n "$LINES"
echo ""

# 4. DNS logs
echo "=== 4. DNS (last $LINES lines) ==="
curl -s -H "Authorization: Bearer $HA_TOKEN" \
    "$HA_BASE/api/hassio/dns/logs" | tail -n "$LINES"
echo ""

# 5. Audio logs
echo "=== 5. Audio (last $LINES lines) ==="
curl -s -H "Authorization: Bearer $HA_TOKEN" \
    "$HA_BASE/api/hassio/audio/logs" | tail -n "$LINES"
echo ""

echo "================================================"
echo "💡 For specific log source:"
echo "   bash scripts/ha-logs.sh [lines]           # Core only"
echo "   bash scripts/ha-logs-supervisor.sh [lines] # Supervisor only"
