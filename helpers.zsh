#!/usr/bin/env zsh

# ~/eng/termx/helpers.zsh
# 
# ALL HELPERS AND ALIASES
# ========================
# Add your helpers and aliases here using:
#   simple_alias "name" "emoji" "description" "command"
#   helper "name" "emoji" "description" << 'EOF' ... EOF

# ============================================================================
# SIMPLE ALIASES (one-liners)
# ============================================================================

simple_alias "cpath" "📍" "Copy current directory path" "pwd | pbcopy && echo '📍 Path copied: '\$(pwd)"
simple_alias "home" "🏠" "Go to home directory" "cd ~"
simple_alias "python" "🐍" "Use Python 3" "python3"
simple_alias "pip" "📦" "Use pip3" "pip3"
simple_alias "cls" "🧹" "Clear screen" "clear"

simple_alias "c-cfg" "🤖" "Open global Claude config" "(cd ~/.claude && cursor .)"
simple_alias "c" "🤖" "Open Claude Code (skip permissions)" "claude --dangerously-skip-permissions"
simple_alias "edit-helpers" "📝" "Open helpers.zsh for editing" "cursor /Users/chris/eng/termx/helpers.zsh"
simple_alias "edit-zshrc" "⚙️" "Open .zshrc for editing" "cursor ~/.zshrc"
simple_alias "popiterm" "📺" "Open iTerm at current directory" "open -a iTerm \"$PWD\""
# ============================================================================
# AWS HELPERS
# ============================================================================

helper "aws-login" "🔑" "Login to AWS SSO (e.g. aws-login dev-profile)" << 'EOF'
    if [ -z "$1" ]; then
        echo "Usage: aws-login <profile>"
        echo "Example: aws-login sesha-dev"
        aws-profiles
        return 1
    fi
    echo "Attempting AWS SSO login with profile: $1 ..."
    aws sso login --profile "$1" && export AWS_PROFILE="$1"
    echo "AWS_PROFILE set to $1"
EOF

helper "aws-profiles" "📋" "List all AWS profiles" << 'EOF'
    echo "Available AWS CLI profiles:"
    aws configure list-profiles
EOF

helper "aws-current" "👤" "Show current AWS profile" << 'EOF'
    if [ -z "$AWS_PROFILE" ]; then
        echo "No AWS_PROFILE is currently set"
        echo "Hint: Use 'aws-login <profile>' to activate one"
    else
        echo "Current AWS_PROFILE: $AWS_PROFILE"
    fi
EOF

helper "aws-clear" "🗑️" "Clear AWS profile" << 'EOF'
    unset AWS_PROFILE
    echo "AWS_PROFILE cleared"
EOF

# ============================================================================
# VERCEL HELPERS
# ============================================================================

helper "vv-teams" "📋" "List all Vercel teams" << 'EOF'
    echo "Available Vercel teams:"
    vercel teams ls
EOF

helper "vv-personal" "👤" "Switch to personal Vercel account" << 'EOF'
    echo "Switching to personal Vercel account..."
    vercel switch chrismaresca-projects && echo "✅ Switched to personal account (chrismaresca-projects)"
EOF

helper "vv-astral" "🚀" "Switch to Astral team" << 'EOF'
    echo "Switching to Astral team..."
    vercel switch astral-cebbbadc && echo "✅ Switched to Astral team (astral-cebbbadc)"
EOF

helper "vv-current" "👁️" "Show current Vercel team/context" << 'EOF'
    echo "Current Vercel context:"
    vercel whoami
EOF

# ============================================================================
# COPY HELPERS
# ============================================================================

helper "copy-files" "📋" "Copy coding files to clipboard (e.g. copy-files -max 5)" << 'EOF'
    local MAX_FILES=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -max) MAX_FILES="$2"; shift 2 ;;
            -h) echo "Usage: copy-files [-max N]"; return 0 ;;
            *) echo "Unknown option: $1"; return 1 ;;
        esac
    done

    # Define extensions
    local EXTS=("*.py" "*.js" "*.ts" "*.tsx" "*.jsx" "*.go" "*.rs" "*.sh" "*.zsh")
    
    # Find files
    local files=()
    for ext in $EXTS; do
        for file in ${~ext}(N); do
            [[ -f "$file" ]] && files+=("$file")
        done
    done
    
    files=(${(o)files})  # Sort
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "❌ No coding files found"
        return 1
    fi
    
    # Apply max limit
    [[ -n "$MAX_FILES" ]] && files=(${files[1,$MAX_FILES]})
    
    echo "📋 Copying ${#files[@]} files..."
    
    # Build content
    local content=""
    for file in $files; do
        echo "  • $file"
        content+="=== FILE: $file ===\n"
        content+="$(cat "$file")\n"
        content+="=== END: $file ===\n\n"
    done
    
    echo -e "$content" | pbcopy
    echo "✅ Copied to clipboard!"
EOF

# ============================================================================
# AI HELPERS
# ============================================================================

helper "ai-setup" "🤖" "Copy ai_stuff directory to current location" << 'EOF'
    local source="/Users/chris/eng/astral-os/ai_stuff"
    local target="ai_stuff"
    
    echo "🤖 Setting up AI directory..."
    
    if [[ ! -d "$source" ]]; then
        echo "❌ Source not found: $source"
        return 1
    fi
    
    if [[ -e "$target" ]]; then
        echo -n "⚠️  $target exists. Overwrite? (y/N): "
        read -r response
        [[ ! "$response" =~ ^[Yy]$ ]] && return 0
    fi
    
    cp -r "$source" "." && echo "✅ AI setup complete!" || echo "❌ Copy failed"
EOF

helper "cursor-rules-setup" "📐" "Copy ai_stuff directory to .cursor/rules for Cursor IDE rules (flattened)" << 'EOF'
    local source="/Users/chris/eng/astral-os/ai_stuff"
    local target_dir=".cursor/rules"
    
    echo "📐 Setting up Cursor rules directory..."
    
    if [[ ! -d "$source" ]]; then
        echo "❌ Source not found: $source"
        return 1
    fi
    
    # Create .cursor/rules directory if it doesn't exist
    if [[ ! -d "$target_dir" ]]; then
        echo "📁 Creating $target_dir directory..."
        mkdir -p "$target_dir"
    fi
    
    # Check if target directory has contents
    if [[ -n "$(ls -A "$target_dir" 2>/dev/null)" ]]; then
        echo -n "⚠️  $target_dir has existing contents. Overwrite? (y/N): "
        read -r response
        [[ ! "$response" =~ ^[Yy]$ ]] && return 0
        rm -rf "$target_dir"/*
    fi
    
    echo "📋 Copying and flattening ai_stuff contents to $target_dir..."
    
    # Copy directories that should remain as-is
    for preserve_dir in "to-do" "docs" "examples"; do
        if [[ -d "$source/$preserve_dir" ]]; then
            echo "📁 Preserving $preserve_dir directory structure..."
            cp -r "$source/$preserve_dir" "$target_dir/"
        fi
    done
    
    # Flatten all other files to root level (ignoring lightweight directory)
    echo "📄 Flattening other files to root level..."
    find "$source" -type f -not -path "$source/to-do/*" -not -path "$source/docs/*" -not -path "$source/examples/*" -not -path "$source/lightweight/*" | while read -r file; do
        filename=$(basename "$file")
        cp "$file" "$target_dir/$filename"
    done
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Cursor rules setup complete (flattened structure)!"
        echo "💡 Files are now available in $target_dir for Cursor IDE"
        echo "📁 Preserved directories: to-do, docs, examples"
    else
        echo "❌ Copy failed - check permissions and try again"
        return 1
    fi
EOF

# ============================================================================
# YOUTUBE ANALYZER HELPERS
# ============================================================================

simple_alias "yt-agent" "📺" "Run YouTube video analyzer in interactive mode" "uv run /Users/chris/eng/youtube-agent/main.py"

# ============================================================================
# ASTRAL OS HELPERS
# ============================================================================

helper "init-astral-ui" "🚀" "Initialize Astral UI directory structure for Next.js + shadcn projects" << 'EOF'
    echo "🚀 Initializing Astral UI directory structure..."
    
    # 1️⃣ Verify this is a Next.js project
    if [[ ! -f "package.json" ]] || ! grep -q '"next"' package.json; then
        echo "❌ This is not a Next.js project (no Next.js found in package.json)"
        echo "💡 Run this command from the root of a Next.js project"
        return 1
    fi
    
    # 2️⃣ Verify shadcn/ui is installed (components.json exists)
    if [[ ! -f "components.json" ]]; then
        echo "❌ shadcn/ui not found (components.json missing)"
        echo "💡 Install shadcn/ui first: pnpm dlx shadcn@latest init"
        return 1
    fi
    
    echo "✅ Next.js project detected"
    echo "✅ shadcn/ui detected"
    echo ""
    
    # 3️⃣ Create directory structure within src/core/ui
    echo "📁 Creating Astral UI directory structure..."
    
    local base_dir="src"
    if [[ ! -d "$base_dir" ]]; then
        echo "❌ src directory not found"
        return 1
    fi
    
    # Create core/ui directory and subdirectories
    mkdir -p "$base_dir/core/ui/components"
    mkdir -p "$base_dir/core/ui/common"
    mkdir -p "$base_dir/core/ui/hooks"
    mkdir -p "$base_dir/core/ui/lib"
    mkdir -p "$base_dir/core/ui/primitives"
    mkdir -p "$base_dir/core/ui/motion-primitives"
    
    echo "  ✅ Created $base_dir/core/ui/components"
    echo "  ✅ Created $base_dir/core/ui/common"
    echo "  ✅ Created $base_dir/core/ui/hooks"
    echo "  ✅ Created $base_dir/core/ui/lib"
    echo "  ✅ Created $base_dir/core/ui/primitives"
    echo "  ✅ Created $base_dir/core/ui/motion-primitives"
    
    # 4️⃣ Move existing src/lib to src/core/ui/lib if it exists
    if [[ -d "$base_dir/lib" ]]; then
        echo "📦 Moving existing $base_dir/lib to $base_dir/core/ui/lib..."
        # Move contents, not the directory itself
        if [[ -n "$(ls -A "$base_dir/lib" 2>/dev/null)" ]]; then
            cp -r "$base_dir/lib"/* "$base_dir/core/ui/lib/" 2>/dev/null || true
            rm -rf "$base_dir/lib"
            echo "  ✅ Moved $base_dir/lib contents to $base_dir/core/ui/lib"
        else
            rm -rf "$base_dir/lib"
            echo "  ✅ Removed empty $base_dir/lib directory"
        fi
    fi
    
    # 5️⃣ Update components.json aliases
    echo "⚙️  Updating components.json aliases..."
    
    # Create a temporary file with updated components.json
    local temp_file=$(mktemp)
    
    # Update aliases using jq
    jq '.aliases = {
        "lib": "@/core/ui/lib",
        "utils": "@/core/ui/lib/utils",
        "ui": "@/core/ui/primitives",
        "hooks": "@/core/ui/hooks",
        "components": "@/core/ui/components"
    }' components.json > "$temp_file" && mv "$temp_file" components.json
    echo "  ✅ Updated components.json aliases"
    
    rm -f "$temp_file"
    
    echo ""
    echo "🎉 Astral UI initialization complete!"
    echo ""
    echo "📁 Directory structure created:"
    echo "  src/core/ui/components/"
    echo "  src/core/ui/common/"
    echo "  src/core/ui/hooks/"
    echo "  src/core/ui/lib/"
    echo "  src/core/ui/primitives/"
    echo "  src/core/ui/motion-primitives/"
    echo ""
    echo "⚙️  components.json updated with new aliases"
    echo "💡 You may need to restart your TypeScript server"
EOF

# ============================================================================
# GIT HELPERS
# ============================================================================

simple_alias "git-st" "📊" "Git status" "git status"
simple_alias "git-co" "🔀" "Git checkout (e.g. git-co main)" "git checkout"
simple_alias "git-pull" "⬇️" "Git pull with rebase" "git pull --rebase"
simple_alias "git-push" "⬆️" "Git push to current branch" "git push"
simple_alias "git-pushf" "⬆️" "Git push force with lease (safer force push)" "git push --force-with-lease"

helper "git-cm" "💬" "Git commit with message (e.g. git-cm 'fix bug')" << 'EOF'
    if [[ -z "$1" ]]; then
        echo "Usage: git-cm 'commit message'"
        return 1
    fi
    git commit -m "$*"
EOF

helper "git-acp" "🚀" "Git add all, commit, push (e.g. git-acp 'my message')" << 'EOF'
    if [[ -z "$1" ]]; then
        echo "Usage: git-acp 'commit message'"
        return 1
    fi
    git add -A && git commit -m "$*" && git push
EOF

helper "git-new" "🌱" "Create and checkout new branch (e.g. git-new feature/thing)" << 'EOF'
    if [[ -z "$1" ]]; then
        echo "Usage: git-new <branch-name>"
        return 1
    fi
    git checkout -b "$1"
EOF

helper "git-del" "🗑️" "Delete branch locally and remotely (e.g. git-del feature/old)" << 'EOF'
    if [[ -z "$1" ]]; then
        echo "Usage: git-del <branch-name>"
        return 1
    fi
    local branch="$1"
    echo "⚠️  This will delete '$branch' locally and remotely"
    echo -n "Continue? (y/N): "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git branch -d "$branch" 2>/dev/null || git branch -D "$branch"
        git push origin --delete "$branch" 2>/dev/null
        echo "✅ Branch '$branch' deleted"
    fi
EOF

helper "git-undo" "↩️" "Undo last commit (keeps changes staged)" << 'EOF'
    echo "↩️  Undoing last commit (changes will remain staged)..."
    git reset --soft HEAD~1
    echo "✅ Last commit undone. Changes are staged."
EOF

helper "git-amend" "✏️" "Amend last commit with staged changes (no message edit)" << 'EOF'
    git commit --amend --no-edit
    echo "✅ Amended last commit"
EOF

helper "git-log" "📜" "Pretty git log (last 10 commits)" << 'EOF'
    git log --oneline --graph --decorate -10
EOF

helper "git-branches" "🌿" "List branches sorted by last commit" << 'EOF'
    git branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:green)%(committerdate:relative)%(color:reset)'
EOF

helper "git-stash" "📦" "Stash changes with optional message" << 'EOF'
    if [[ -z "$1" ]]; then
        git stash push
    else
        git stash push -m "$*"
    fi
    echo "✅ Changes stashed"
EOF

helper "git-pop" "📤" "Pop latest stash" << 'EOF'
    git stash pop
EOF

# ============================================================================
# ADD YOUR OWN HELPERS BELOW
# ============================================================================

# Example:
# helper "my-helper" "🔧" "Does something cool" << 'EOF'
#     echo "Hello world!"
# EOF

