#!/usr/bin/env bash
# Pull an Anthropic skill from github.com/anthropics/skills into local skills dir

set -euo pipefail

REPO="anthropics/skills"
BRANCH="main"
SKILLS_DIR="/Users/chris/eng/2026/skills"

usage() {
    echo "Usage: $(basename "$0") <skill-name> [--list]"
    echo ""
    echo "Pull a skill from github.com/$REPO into $SKILLS_DIR/<skill-name>"
    echo ""
    echo "Options:"
    echo "  --list    List all available skills"
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") pdf"
    echo "  $(basename "$0") claude-api"
    echo "  $(basename "$0") --list"
}

list_skills() {
    echo "📋 Available skills from $REPO:"
    echo ""
    gh api "repos/$REPO/contents/skills" --jq '.[].name' 2>/dev/null || {
        echo "❌ Failed to fetch skill list (is 'gh' installed and authenticated?)"
        return 1
    }
}

pull_skill() {
    local skill_name="$1"
    local target_dir="$SKILLS_DIR/$skill_name"

    if [[ -d "$target_dir" ]]; then
        echo -n "⚠️  $target_dir already exists. Overwrite? (y/N): "
        read -r response
        [[ ! "$response" =~ ^[Yy]$ ]] && { echo "Aborted."; return 0; }
        rm -rf "$target_dir"
    fi

    echo "⬇️  Pulling skill '$skill_name'..."

    mkdir -p "$SKILLS_DIR"

    local tmp
    tmp=$(mktemp -d)
    trap "rm -rf '$tmp'" EXIT

    if ! curl -sL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | \
        tar xz -C "$tmp" "skills-$BRANCH/skills/$skill_name" 2>/dev/null; then
        echo "❌ Skill '$skill_name' not found in $REPO"
        echo "💡 Run with --list to see available skills"
        return 1
    fi

    mv "$tmp/skills-$BRANCH/skills/$skill_name" "$target_dir"

    echo "✅ Pulled '$skill_name' → $target_dir"
    echo ""
    ls "$target_dir"
}

case "${1:-}" in
    ""|-h|--help)
        usage
        ;;
    --list|-l)
        list_skills
        ;;
    *)
        pull_skill "$1"
        ;;
esac
