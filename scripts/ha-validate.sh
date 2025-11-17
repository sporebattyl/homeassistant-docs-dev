#!/bin/bash
# Home Assistant Full Validation Script
# Runs yamllint + HA config check

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

cd "$CONFIG_DIR" || exit 1

# Load secrets
if [ -f "$CONFIG_DIR/state/secrets.env" ]; then
    source "$CONFIG_DIR/state/secrets.env"
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

echo "======================================"
echo "  Home Assistant Validation"
echo "======================================"
echo ""

# Step 1: YAML Linting
echo "=== Step 1: YAML Linting ==="
yamllint packages/*.yaml configuration.yaml
LINT_EXIT=$?

echo ""

# Step 2: HA Configuration Check
echo "=== Step 2: HA Configuration Check ==="
RESULT=$(curl -X POST \
  -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  "$HA_BASE/api/config/core/check_config" \
  2>/dev/null)

echo "$RESULT" | jq .
CHECK_EXIT=$?

# Parse the result
VALID=$(echo "$RESULT" | jq -r '.result')

echo ""
echo "======================================"

if [ "$LINT_EXIT" -ne 0 ]; then
  echo "❌ YAML linting found issues"
  exit 1
elif [ "$CHECK_EXIT" -ne 0 ] || [ "$VALID" != "valid" ]; then
  echo "❌ HA configuration check failed"
  exit 1
else
  echo "✅ All validation passed!"
  exit 0
fi
