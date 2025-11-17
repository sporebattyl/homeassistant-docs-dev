#!/bin/bash
# Copy Claude's last response to clipboard
# Usage: bash /home/drewcifer/homeassistant-config/.claude/commands/copy-last-response.sh

LATEST_CONV=$(ls -t ~/.claude/projects/-home-drewcifer-homeassistant-config/*.jsonl | head -1)

if [ -z "$LATEST_CONV" ]; then
    echo "❌ No conversation files found"
    exit 1
fi

echo "📄 Reading from: $(basename "$LATEST_CONV")"

# Extract last assistant message and copy to clipboard
jq -rs '.[-1] | if (.message.content | type) == "array" then [.message.content[] | select(.type=="text") | .text] | join("\n") else .message.content end' "$LATEST_CONV" | xclip -selection clipboard

if [ $? -eq 0 ]; then
    echo "✅ Handoff prompt copied to clipboard!"
    echo "📋 You can now paste it anywhere with Ctrl+V"
else
    echo "❌ Failed to copy to clipboard"
    exit 1
fi
