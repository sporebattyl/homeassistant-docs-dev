#!/bin/bash
# Manual sync FROM local workspace TO live server
# Use this when you want to deploy local changes WITHOUT committing
# (For testing or emergency fixes)

REPO="/home/drewcifer/homeassistant-config"
LIVE="/home/drewcifer/mnt/homeassistant-config"

echo "🚀 Manually syncing FROM local workspace TO live server..."
echo ""
echo "This will overwrite files on the LIVE Home Assistant server!"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

# Deploy to live server
rsync -av --exclude='.git' --exclude='.storage' --exclude='*.log' \
    --exclude='home-assistant.log' \
    "$REPO/packages/" "$LIVE/packages/"

rsync -av --exclude='.git' \
    "$REPO/ui-lovelace-climate-control-center-v2.yaml" \
    "$LIVE/"

rsync -av --exclude='.git' \
    "$REPO/emergency_scripts_redesigned.yaml" \
    "$LIVE/"

rsync -av --exclude='.git' \
    "$REPO/consolidation_phases_2025_10_17/" \
    "$LIVE/consolidation_phases_2025_10_17/"

echo ""
echo "✅ Manual sync TO live server complete"
echo "💡 Note: Changes deployed but NOT committed to git"
echo "   Use 'git commit' to save these changes to version control"
