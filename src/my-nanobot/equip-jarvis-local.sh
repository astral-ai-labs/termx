#!/usr/bin/env bash
# Copy a local skill into nanobot's workspace (no symlinks — works inside Docker)

set -euo pipefail

SKILLS_SOURCE="/Users/chris/eng/2026/skills"
NANOBOT_SKILLS="$HOME/.nanobot/workspace/skills"

copy_skill() {
    local name="$1"
    local source_dir="$SKILLS_SOURCE/$name"
    local target_dir="$NANOBOT_SKILLS/$name"

    if [[ ! -d "$source_dir" ]]; then
        echo "⚠️  Skill not found: $source_dir (skipping)"
        return 1
    fi

    [[ -d "$target_dir" || -L "$target_dir" ]] && rm -rf "$target_dir"
    cp -R "$source_dir" "$target_dir"
    echo "✅ $name"
}

skill_name="${1:-}"

if [[ -z "$skill_name" ]]; then
    printf "🧠 Skill name (or 'all'): "
    read -r skill_name
fi

if [[ -z "$skill_name" ]]; then
    echo "❌ No skill name provided"
    exit 1
fi

mkdir -p "$NANOBOT_SKILLS"

if [[ "$skill_name" == "all" ]]; then
    echo "📦 Copying all skills from $SKILLS_SOURCE..."
    count=0
    for dir in "$SKILLS_SOURCE"/*/; do
        [[ ! -d "$dir" ]] && continue
        copy_skill "$(basename "$dir")" && count=$((count + 1))
    done
    echo "Done — $count skill(s) equipped"
else
    copy_skill "$skill_name"
fi
