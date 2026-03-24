module "🔀" "Git"

_pick_branch() {
    local branch="$1"
    [[ -n "$branch" ]] && echo "$branch" && return

    local branches=("${(@f)$(git branch --format='%(refname:short)' 2>/dev/null)}")
    [[ ${#branches[@]} -eq 0 ]] && echo "❌ No branches found" >&2 && return 1

    echo "Branches:" >&2
    for i in {1..${#branches[@]}}; do
        printf "  %d) %s\n" "$i" "${branches[$i]}" >&2
    done
    printf "Pick [1-%d]: " "${#branches[@]}" >&2
    read -r choice

    [[ "$choice" -ge 1 && "$choice" -le ${#branches[@]} ]] 2>/dev/null || return 1
    echo "${branches[$choice]}"
}

helper "create-branch" "🌿" "Create and switch to a new branch" << 'EOF'
    local name="$1"
    if [[ -z "$name" ]]; then
        printf "🌿 Branch name: "
        read name
    fi
    [[ -z "$name" ]] && echo "❌ No name provided" && return 1
    git switch -c "$name"
EOF

helper "switch-branch" "🔀" "Switch branch (or pick interactively)" << 'EOF'
    local branch=$(_pick_branch "$1") || return 1
    git switch "$branch"
EOF

helper "merge" "🔀" "Merge branch into current (or pick interactively)" << 'EOF'
    local branch=$(_pick_branch "$1") || return 1
    git merge "$branch"
EOF

helper "delete-branch" "🗑️" "Delete branch (or pick interactively)" << 'EOF'
    local branch=$(_pick_branch "$1") || return 1
    echo "🗑️  Delete '$branch'?"
    printf "  [y/N]: "
    read -r confirm
    [[ "$confirm" == [yY] ]] || return 0
    git branch -d "$branch" || git branch -D "$branch"
EOF
