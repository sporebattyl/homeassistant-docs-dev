#!/bin/bash
# Sync changes from homeassistant-docs-dev to main config repo
# Run this after making changes in Claude Code Web

set -e

DOCS_DEV_DIR="/home/drewcifer/homeassistant-docs-dev"
CONFIG_DIR="/home/drewcifer/homeassistant-config"

echo "=== Syncing from homeassistant-docs-dev ==="

# Check if docs-dev repo exists
if [ ! -d "$DOCS_DEV_DIR" ]; then
    echo "❌ Error: $DOCS_DEV_DIR not found"
    echo "Please clone the repo first:"
    echo "  cd /home/drewcifer"
    echo "  git clone https://github.com/sporebattyl/homeassistant-docs-dev.git"
    exit 1
fi

# Pull latest changes from GitHub
echo "📥 Pulling latest changes from GitHub..."
cd "$DOCS_DEV_DIR"
git pull origin main

# Sync specific directories and files
echo "🔄 Syncing files..."

# Sync .claude/
rsync -av --delete "$DOCS_DEV_DIR/.claude/" "$CONFIG_DIR/.claude/"

# Sync docs/
rsync -av --delete "$DOCS_DEV_DIR/docs/" "$CONFIG_DIR/docs/"

# Sync scripts/ (careful not to overwrite local-specific scripts)
rsync -av "$DOCS_DEV_DIR/scripts/" "$CONFIG_DIR/scripts/"

# Sync key documentation files
rsync -av "$DOCS_DEV_DIR/DOCUMENTATION_HIERARCHY.md" "$CONFIG_DIR/"
rsync -av "$DOCS_DEV_DIR/MASTER_DOCUMENTATION_INDEX.md" "$CONFIG_DIR/"
rsync -av "$DOCS_DEV_DIR/AGENTS.md" "$CONFIG_DIR/"
rsync -av "$DOCS_DEV_DIR/README_SECRETS.md" "$CONFIG_DIR/"

# Note: packages-examples/ are just examples, don't overwrite live packages/

echo "✅ Sync complete!"
echo ""
echo "📋 Summary:"
echo "  - Synced .claude/"
echo "  - Synced docs/"
echo "  - Synced scripts/"
echo "  - Synced documentation files"
echo ""
echo "Next steps:"
echo "  1. Review changes: git status"
echo "  2. Test changes: ha-validate (if YAML was modified)"
echo "  3. Commit: git add . && git commit -m 'Sync from docs-dev'"
