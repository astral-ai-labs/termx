#!/usr/bin/env bash
# Copy ai_stuff to .cursor/rules (flattened structure)

set -euo pipefail

SOURCE="/Users/chris/eng/astral-os/ai_stuff"
TARGET_DIR=".cursor/rules"

echo "📐 Setting up Cursor rules directory..."

if [[ ! -d "$SOURCE" ]]; then
    echo "❌ Source not found: $SOURCE"
    exit 1
fi

mkdir -p "$TARGET_DIR"

if [[ -n "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]]; then
    echo -n "⚠️  $TARGET_DIR has existing contents. Overwrite? (y/N): "
    read -r response
    [[ ! "$response" =~ ^[Yy]$ ]] && exit 0
    rm -rf "${TARGET_DIR:?}"/*
fi

echo "📋 Copying and flattening ai_stuff contents to $TARGET_DIR..."

# Preserve specific directory structures
for preserve_dir in "to-do" "docs" "examples"; do
    if [[ -d "$SOURCE/$preserve_dir" ]]; then
        cp -r "$SOURCE/$preserve_dir" "$TARGET_DIR/"
    fi
done

# Flatten everything else to root level
find "$SOURCE" -type f \
    -not -path "$SOURCE/to-do/*" \
    -not -path "$SOURCE/docs/*" \
    -not -path "$SOURCE/examples/*" \
    -not -path "$SOURCE/lightweight/*" | while read -r file; do
    cp "$file" "$TARGET_DIR/$(basename "$file")"
done

echo "✅ Cursor rules setup complete!"
