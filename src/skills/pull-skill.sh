#!/usr/bin/env bash
# Pull an Anthropic skill from github.com/anthropics/skills into local skills dir

set -euo pipefail

REPO="anthropics/skills"
BRANCH="main"
SKILLS_DIR="/Users/chris/eng/2026/skills"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"

usage() {
    echo "Usage: $(basename "$0") <skill-name> [--claude] [--both] [--list]"
    echo ""
    echo "Pull a skill from github.com/$REPO"
    echo ""
    echo "Destinations (default: $SKILLS_DIR):"
    echo "  --claude  Install to ~/.claude/skills instead"
    echo "  --both    Install to both"
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") pdf"
    echo "  $(basename "$0") pdf --claude"
    echo "  $(basename "$0") pdf --both"
    echo "  $(basename "$0") --list"
}

list_skills() {
    echo "📋 Available skills from $REPO:"
    echo ""

    local names
    names=$(curl -sf "https://api.github.com/repos/$REPO/contents/skills" \
        -H "Accept: application/vnd.github+json" \
        | grep '"name"' | sed 's/.*"name": *"\(.*\)".*/\1/') || {
        echo "❌ Failed to fetch skill list (check internet connection)"
        return 1
    }

    echo "$names" | sort | while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        printf "  %s\n" "$name"
    done
}

install_to() {
    local src="$1" skill_name="$2" dest_dir="$3"
    local target="$dest_dir/$skill_name"

    if [[ -d "$target" ]]; then
        echo -n "⚠️  $target already exists. Overwrite? (y/N): "
        read -r response
        [[ ! "$response" =~ ^[Yy]$ ]] && { echo "Skipped $target"; return 0; }
        rm -rf "$target"
    fi

    mkdir -p "$dest_dir"
    cp -R "$src" "$target"
    echo "✅ $target"
}

pull_skill() {
    local skill_name="$1" dest="$2"

    echo "⬇️  Pulling '$skill_name'..."

    local tmp
    tmp=$(mktemp -d)
    trap "rm -rf '$tmp'" EXIT

    if ! curl -sL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | \
        tar xz -C "$tmp" "skills-$BRANCH/skills/$skill_name" 2>/dev/null; then
        echo "❌ Skill '$skill_name' not found in $REPO"
        echo "💡 Run with --list to see available skills"
        return 1
    fi

    local src="$tmp/skills-$BRANCH/skills/$skill_name"

    if [[ "$dest" == "both" ]]; then
        install_to "$src" "$skill_name" "$SKILLS_DIR"
        install_to "$src" "$skill_name" "$CLAUDE_SKILLS_DIR"
    elif [[ "$dest" == "claude" ]]; then
        install_to "$src" "$skill_name" "$CLAUDE_SKILLS_DIR"
    else
        install_to "$src" "$skill_name" "$SKILLS_DIR"
    fi
}

# --- arg parsing ---

skill_name=""
dest="default"

for arg in "$@"; do
    case "$arg" in
        ""|-h|--help) usage; exit 0 ;;
        --list|-l)    list_skills; exit 0 ;;
        --claude)     dest="claude" ;;
        --both)       dest="both" ;;
        *)            skill_name="$arg" ;;
    esac
done

if [[ -z "$skill_name" ]]; then
    usage
    exit 1
fi

pull_skill "$skill_name" "$dest"
