#!/bin/bash
# YAML Linting Script for Home Assistant
# Runs yamllint on all HA configuration files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

cd "$CONFIG_DIR" || exit 1

echo "======================================"
echo "  YAML Linting - All Files"
echo "======================================"
echo ""

# Check if yamllint is installed
if ! command -v yamllint &> /dev/null; then
    echo "❌ yamllint not found"
    echo "   Install: pip install yamllint"
    exit 1
fi

# Lint all YAML files
yamllint packages/*.yaml \
    customization/*.yaml \
    automations/*.yaml \
    scripts/*.yaml \
    configuration.yaml \
    2>&1

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All YAML files passed linting"
else
    echo "❌ YAML linting found issues (see above)"
fi

exit $EXIT_CODE
