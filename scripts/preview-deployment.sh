#!/bin/bash
# Preview what would be deployed to live server
# Usage: bash scripts/preview-deployment.sh

REPO="/home/drewcifer/homeassistant-config"
LIVE="/home/drewcifer/mnt/homeassistant-config"

echo "📋 Preview: What would deploy to live server"
echo "=============================================="
echo ""

# Show current git status
echo "🔍 Git Status:"
git status --short
echo ""

# Show staged changes
STAGED_COUNT=$(git diff --cached --name-only | wc -l)
UNSTAGED_COUNT=$(git diff --name-only | wc -l)

if [ "$STAGED_COUNT" -gt 0 ]; then
    echo "📦 Staged changes (would deploy on commit):"
    git diff --cached --stat
    echo ""
fi

if [ "$UNSTAGED_COUNT" -gt 0 ]; then
    echo "⚠️  Unstaged changes (would NOT deploy):"
    git diff --stat
    echo ""
fi

# Show what rsync would deploy (operational files only)
echo "🚀 Rsync Preview (operational files only):"
echo ""

rsync -avn --delete --inplace \
    --exclude='.git/' \
    --exclude='.gitignore' \
    --exclude='.last-deployment' \
    --exclude='.claude/' \
    --exclude='docs/' \
    --exclude='archive/' \
    --exclude='archived_data/' \
    --exclude='archived_projects/' \
    --exclude='temp/' \
    --exclude='zigbee2mqtt/' \
    --exclude='*.md' \
    --exclude='*.log' \
    --exclude='*.db' \
    --exclude='*.db-shm' \
    --exclude='*.db-wal' \
    --exclude='.storage/' \
    --exclude='home-assistant.log' \
    --exclude='home-assistant_*.log' \
    --exclude='*.backup' \
    --exclude='*.bak' \
    --exclude='__pycache__/' \
    --exclude='*.pyc' \
    "$REPO/" "$LIVE/" 2>/dev/null | grep -v "/$" | head -50

echo ""
echo "📊 Summary:"
echo "   • Staged files: $STAGED_COUNT"
echo "   • Unstaged files: $UNSTAGED_COUNT"
echo ""

if [ "$STAGED_COUNT" -eq 0 ]; then
    echo "ℹ️  No staged changes - nothing would deploy"
    echo "   Run: git add <files> to stage changes"
else
    echo "✅ Ready to commit and deploy"
    echo "   Run: git commit -m \"your message\""
fi
