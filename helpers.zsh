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
simple_alias "cursor" "📝" "Open current directory in Cursor" "cursor ."
simple_alias "claude-config" "🤖" "Open global Claude config" "cursor ~/.claude"

# ============================================================================
# AWS HELPERS
# ============================================================================

helper "aws-login" "🔑" "Login to AWS SSO and set profile" << 'EOF'
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
# COPY HELPERS
# ============================================================================

helper "copy-files" "📋" "Copy coding files to clipboard" << 'EOF'
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

# ============================================================================
# ADD YOUR OWN HELPERS BELOW
# ============================================================================

# Example:
# helper "my-helper" "🔧" "Does something cool" << 'EOF'
#     echo "Hello world!"
# EOF

# simple_alias "myalias" "⚡" "Quick shortcut" "ls -la"