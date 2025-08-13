#!/usr/bin/env zsh

# ~/eng/termx/framework.zsh
# 
# HELPER SYSTEM FRAMEWORK
# =======================
# This file contains the core system - DO NOT add helpers here
# Add your helpers in helpers.zsh instead

# Core helper registration system
typeset -A HELPERS_REGISTRY
typeset -A ALIASES_REGISTRY

# Function to register multi-line helpers
helper() {
    local name="$1"
    local emoji="$2"
    local desc="$3"
    local body=$(cat)
    
    # Register the helper
    HELPERS_REGISTRY[$name]="$emoji|$desc"
    
    # Create the function
    eval "function ${(q)name}() {
        $body
    }"
    
    # Auto-create short alias if it ends with ?
    if [[ "$name" == *"?" ]]; then
        # No alias needed, it's already short
        :
    else
        # Create convenience alias without hyphens
        local alias_name="${name//-/_}"
        if [[ "$alias_name" != "$name" ]]; then
            eval "alias $alias_name='$name'"
        fi
    fi
}

# Function to register simple one-line aliases
simple_alias() {
    local name="$1"
    local emoji="$2"
    local desc="$3"
    local cmd="$4"
    
    ALIASES_REGISTRY[$name]="$emoji|$desc|$cmd"
    alias "$name"="$cmd"
}

# ============================================================================
# CORE SYSTEM COMMANDS
# ============================================================================

helper "help" "🛠️" "Show all available aliases and helpers" << 'EOF'
    # Auto-refresh before showing help
    refresh > /dev/null
    
    echo "🛠️  All Available Commands:"
    echo "==========================="
    echo ""
    
    # Parse optional filter
    local filter="$1"
    
    # Show simple aliases first
    if [[ ${#ALIASES_REGISTRY} -gt 0 ]]; then
        echo "📌 Simple Aliases:"
        for name in ${(ko)ALIASES_REGISTRY}; do
            local info="${ALIASES_REGISTRY[$name]}"
            local emoji="${info%%|*}"
            local rest="${info#*|}"
            local desc="${rest%%|*}"
            
            # Apply filter if provided
            if [[ -n "$filter" ]] && [[ ! "$name" =~ "$filter" ]] && [[ ! "$desc" =~ "$filter" ]]; then
                continue
            fi
            
            printf "  %-20s %s %s\n" "$name" "$emoji" "$desc"
        done
        echo ""
    fi
    
    # Show helper functions
    echo "🔧 Helper Functions:"
    for name in ${(ko)HELPERS_REGISTRY}; do
        local info="${HELPERS_REGISTRY[$name]}"
        local emoji="${info%%|*}"
        local desc="${info#*|}"
        
        # Apply filter if provided
        if [[ -n "$filter" ]] && [[ ! "$name" =~ "$filter" ]] && [[ ! "$desc" =~ "$filter" ]]; then
            continue
        fi
        
        printf "  %-20s %s %s\n" "$name" "$emoji" "$desc"
    done
    
    echo ""
    echo "💡 Tips:"
    echo "  • Type 'help aws' to filter AWS commands"
    echo "  • Type 'edit-helpers' to add new commands"
EOF

helper "refresh" "🔄" "Reload shell configuration" << 'EOF'
    # Clear existing registries to avoid duplication
    unset HELPERS_REGISTRY
    unset ALIASES_REGISTRY
    typeset -gA HELPERS_REGISTRY
    typeset -gA ALIASES_REGISTRY
    
    # Reload helpers.zsh (this requires the framework functions to be available)
    source ~/eng/termx/helpers.zsh
    
    echo "🔄 Shell configuration reloaded"
EOF

helper "edit-helpers" "✏️" "Edit helpers file" << 'EOF'
    ${EDITOR:-cursor} ~/eng/termx/helpers.zsh
EOF

helper "edit-framework" "🔧" "Edit framework file (advanced)" << 'EOF'
    echo "⚠️  Warning: Editing the framework can break the helper system"
    echo -n "Continue? (y/N): "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]] && then
        ${EDITOR:-cursor} ~/eng/termx/framework.zsh
    fi
EOF

helper "edit-zsh" "⚙️" "Edit .zshrc file" << 'EOF'
    ${EDITOR:-cursor} ~/.zshrc
EOF

helper "new-helper" "➕" "Show template for adding new helpers" << 'EOF'
    echo 'Edit helpers.zsh and add:'
    echo ''
    echo 'For a simple alias (one-liner):'
    echo '  simple_alias "name" "🔧" "description" "command"'
    echo ''
    echo 'For a helper function:'
    echo '  helper "my-helper" "🔧" "Description here" << '\''EOF'\'''
    echo '      # Your code here'
    echo '      echo "Hello from my-helper!"'
    echo '  EOF'
    echo ''
    echo 'Then run: refresh'
EOF

# Quick access aliases
alias h="help"
alias "?"="help"

# Load the actual helpers
source ~/eng/termx/helpers.zsh

# Show hint on first load
if [[ -z "$HELPERS_LOADED" ]]; then
    export HELPERS_LOADED=1
    echo "💡 Type 'help' (or '?') to see all aliases and helpers"
fi