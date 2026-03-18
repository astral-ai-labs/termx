#!/usr/bin/env bash
# Copy coding files in current directory to clipboard

set -euo pipefail

MAX_FILES=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -max) MAX_FILES="$2"; shift 2 ;;
        -h|--help) echo "Usage: copy-files [-max N]"; exit 0 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

EXTS=("py" "js" "ts" "tsx" "jsx" "go" "rs" "sh" "zsh")

files=()
for ext in "${EXTS[@]}"; do
    while IFS= read -r -d '' f; do
        files+=("$f")
    done < <(find . -maxdepth 1 -name "*.$ext" -type f -print0 2>/dev/null)
done

IFS=$'\n' files=($(sort <<< "${files[*]}")); unset IFS

if [[ ${#files[@]} -eq 0 ]]; then
    echo "❌ No coding files found"
    exit 1
fi

if [[ -n "$MAX_FILES" ]]; then
    files=("${files[@]:0:$MAX_FILES}")
fi

echo "📋 Copying ${#files[@]} files..."

content=""
for file in "${files[@]}"; do
    echo "  • $file"
    content+="=== FILE: $file ===
$(cat "$file")
=== END: $file ===

"
done

echo "$content" | pbcopy
echo "✅ Copied to clipboard!"
