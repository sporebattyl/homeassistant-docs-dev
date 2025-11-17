#!/bin/bash
# Sync changes from main config repo to homeassistant-docs-dev
# Run this to push local documentation changes to the dev repo

set -e

DOCS_DEV_DIR="/home/drewcifer/homeassistant-docs-dev"
CONFIG_DIR="/home/drewcifer/homeassistant-config"

echo "=== Syncing to homeassistant-docs-dev ==="

# Check if docs-dev repo exists
if [ ! -d "$DOCS_DEV_DIR" ]; then
    echo "❌ Error: $DOCS_DEV_DIR not found"
    echo "Please clone the repo first:"
    echo "  cd /home/drewcifer"
    echo "  git clone https://github.com/sporebattyl/homeassistant-docs-dev.git"
    exit 1
fi

# Sync specific directories and files
echo "🔄 Syncing files..."

# Sync .claude/
rsync -av --delete "$CONFIG_DIR/.claude/" "$DOCS_DEV_DIR/.claude/"

# Sync docs/
rsync -av --delete "$CONFIG_DIR/docs/" "$DOCS_DEV_DIR/docs/"

# Sync scripts/
rsync -av "$CONFIG_DIR/scripts/" "$DOCS_DEV_DIR/scripts/"

# Sync key documentation files
rsync -av "$CONFIG_DIR/DOCUMENTATION_HIERARCHY.md" "$DOCS_DEV_DIR/"
rsync -av "$CONFIG_DIR/MASTER_DOCUMENTATION_INDEX.md" "$DOCS_DEV_DIR/"
rsync -av "$CONFIG_DIR/AGENTS.md" "$DOCS_DEV_DIR/"
rsync -av "$CONFIG_DIR/README_SECRETS.md" "$DOCS_DEV_DIR/"

# Update example packages (optional - only if they've changed)
echo ""
read -p "Update example packages? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rsync -av "$CONFIG_DIR/packages/climate_fresh_start.yaml" "$DOCS_DEV_DIR/packages-examples/"
    rsync -av "$CONFIG_DIR/packages/climate_dashboard_enhancements.yaml" "$DOCS_DEV_DIR/packages-examples/"
    rsync -av "$CONFIG_DIR/packages/climate_energy_management.yaml" "$DOCS_DEV_DIR/packages-examples/"
    echo "  ✅ Updated example packages"
fi

echo ""
echo "✅ Sync complete!"
echo ""
echo "📋 Summary:"
echo "  - Synced .claude/"
echo "  - Synced docs/"
echo "  - Synced scripts/"
echo "  - Synced documentation files"
echo ""
echo "Next steps:"
echo "  cd $DOCS_DEV_DIR"
echo "  git status"
echo "  git add ."
echo "  git commit -m 'Sync from main config repo'"
echo "  git push origin main"
