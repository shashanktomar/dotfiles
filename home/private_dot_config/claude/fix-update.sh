#!/usr/bin/env bash
# Fix Claude Code update issues by removing orphaned temp directories

set -e

echo "🔍 Checking for orphaned Claude temp directories..."

# Find all node installations managed by mise
NODE_MODULES_PATHS=$(find ~/.local/share/mise/installs/node/*/lib/node_modules/@anthropic-ai/ -maxdepth 0 2>/dev/null || true)

if [ -z "$NODE_MODULES_PATHS" ]; then
    echo "❌ No Claude installation found via mise"
    exit 1
fi

FOUND_ORPHANS=false

for path in $NODE_MODULES_PATHS; do
    # Check for orphaned temp directories
    ORPHANS=$(find "$path" -maxdepth 1 -name ".claude-code-*" -type d 2>/dev/null || true)

    if [ -n "$ORPHANS" ]; then
        FOUND_ORPHANS=true
        echo "🗑️  Found orphaned directories in $path:"
        echo "$ORPHANS" | while read -r orphan; do
            echo "   - $(basename "$orphan")"
            rm -rf "$orphan"
            echo "   ✓ Removed"
        done
    fi
done

if [ "$FOUND_ORPHANS" = false ]; then
    echo "✅ No orphaned directories found"
else
    echo ""
    echo "✅ Cleanup complete! You can now retry the update:"
    echo "   npm update -g @anthropic-ai/claude-code"
fi
