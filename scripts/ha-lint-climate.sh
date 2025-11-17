#!/bin/bash
# YAML Linting Script for Climate Packages Only
# Focused linting for climate control files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

cd "$CONFIG_DIR" || exit 1

echo "======================================"
echo "  YAML Linting - Climate Packages"
echo "======================================"
echo ""

# Check if yamllint is installed
if ! command -v yamllint &> /dev/null; then
    echo "❌ yamllint not found"
    echo "   Install: pip install yamllint"
    exit 1
fi

# Lint only climate-related packages
# Build list of files that actually exist
CLIMATE_FILES=""
for file in packages/climate*.yaml packages/emergency_scripts_redesigned.yaml; do
    if [ -f "$file" ]; then
        CLIMATE_FILES="$CLIMATE_FILES $file"
    fi
done

if [ -z "$CLIMATE_FILES" ]; then
    echo "❌ No climate package files found"
    exit 1
fi

yamllint $CLIMATE_FILES 2>&1

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Climate packages passed linting"
else
    echo "❌ Climate package linting found issues (see above)"
fi

exit $EXIT_CODE
