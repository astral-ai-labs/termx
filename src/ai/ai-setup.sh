#!/usr/bin/env bash
# Copy ai_stuff directory to current location

set -euo pipefail

SOURCE="/Users/chris/eng/astral-os/ai_stuff"
TARGET="ai_stuff"

echo "🤖 Setting up AI directory..."

if [[ ! -d "$SOURCE" ]]; then
    echo "❌ Source not found: $SOURCE"
    exit 1
fi

if [[ -e "$TARGET" ]]; then
    echo -n "⚠️  $TARGET exists. Overwrite? (y/N): "
    read -r response
    [[ ! "$response" =~ ^[Yy]$ ]] && exit 0
fi

cp -r "$SOURCE" "." && echo "✅ AI setup complete!" || { echo "❌ Copy failed"; exit 1; }
