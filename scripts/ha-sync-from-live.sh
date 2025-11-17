#!/bin/bash
# Manual sync FROM live server TO local workspace
# Use this when you've edited files directly on the live HA server
# and want to pull those changes to your local git workspace

LIVE="/home/drewcifer/mnt/homeassistant-config"
REPO="/home/drewcifer/homeassistant-config"

echo "🔄 Manually syncing FROM live server TO local workspace..."
echo ""
echo "This will overwrite local uncommitted changes!"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

# Sync specific directories from live server
rsync -av --exclude='.git' --exclude='.storage' --exclude='*.log' \
    --exclude='home-assistant.log' --exclude='.HA_VERSION' \
    "$LIVE/packages/" "$REPO/packages/"

rsync -av --exclude='.git' \
    "$LIVE/ui-lovelace-climate-control-center-v2.yaml" \
    "$REPO/"

rsync -av --exclude='.git' \
    "$LIVE/emergency_scripts_redesigned.yaml" \
    "$REPO/"

rsync -av --exclude='.git' \
    "$LIVE/consolidation_phases_2025_10_17/" \
    "$REPO/consolidation_phases_2025_10_17/"

echo ""
echo "✅ Manual sync FROM live server complete"
echo "💡 Next steps:"
echo "   1. Review changes: git status"
echo "   2. Stage changes: git add -A"
echo "   3. Commit: git commit -m 'Pulled live server edits'"
