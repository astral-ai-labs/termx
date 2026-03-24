#!/usr/bin/env bash
# Pull an Anthropic skill directly into nanobot's workspace

set -euo pipefail

REPO="anthropics/skills"
BRANCH="main"
NANOBOT_SKILLS="$HOME/.nanobot/workspace/skills"

skill_name="${1:-}"

if [[ -z "$skill_name" ]]; then
    printf "🧠 Skill name: "
    read -r skill_name
fi

if [[ -z "$skill_name" ]]; then
    echo "❌ No skill name provided"
    echo "💡 Run 'anthropic-list-skills' to see available skills"
    exit 1
fi

target_dir="$NANOBOT_SKILLS/$skill_name"

if [[ -d "$target_dir" ]]; then
    echo -n "⚠️  $target_dir already exists. Overwrite? (y/N): "
    read -r response
    [[ ! "$response" =~ ^[Yy]$ ]] && { echo "Aborted."; exit 0; }
    rm -rf "$target_dir"
fi

echo "⬇️  Pulling skill '$skill_name' from $REPO..."

mkdir -p "$NANOBOT_SKILLS"

tmp=$(mktemp -d)
trap "rm -rf '$tmp'" EXIT

if ! curl -sL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | \
    tar xz -C "$tmp" "skills-$BRANCH/skills/$skill_name" 2>/dev/null; then
    echo "❌ Skill '$skill_name' not found in $REPO"
    echo "💡 Run 'anthropic-list-skills' to see available skills"
    exit 1
fi

mv "$tmp/skills-$BRANCH/skills/$skill_name" "$target_dir"

echo "✅ Equipped '$skill_name' → $target_dir"
echo ""
ls "$target_dir"
