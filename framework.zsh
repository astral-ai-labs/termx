#!/usr/bin/env zsh

# ~/eng/2026/core/termx/framework.zsh
#
# HELPER SYSTEM FRAMEWORK
# =======================
# Core system only. Add commands in src/<module>/index.sh

TERMX_DIR="${0:A:h}"

# ============================================================================
# REGISTRIES
# ============================================================================

typeset -gA HELPERS_REGISTRY    # name -> emoji|desc
typeset -gA ALIASES_REGISTRY    # name -> emoji|desc|cmd
typeset -gA MODULES_REGISTRY    # module_name -> emoji
typeset -gA CMD_MODULE          # cmd_name -> module_name

_CURRENT_MODULE_NAME=""
_CURRENT_MODULE_EMOJI=""

# ============================================================================
# REGISTRATION FUNCTIONS
# ============================================================================

module() {
    _CURRENT_MODULE_EMOJI="$1"
    _CURRENT_MODULE_NAME="$2"
    MODULES_REGISTRY[$_CURRENT_MODULE_NAME]="$_CURRENT_MODULE_EMOJI"
}

helper() {
    local name="$1" emoji="$2" desc="$3"
    local body=$(cat)

    HELPERS_REGISTRY[$name]="$emoji|$desc"
    CMD_MODULE[$name]="$_CURRENT_MODULE_NAME"

    eval "function ${(q)name}() {
        $body
    }"
}

simple_alias() {
    local name="$1" emoji="$2" desc="$3" cmd="$4"

    ALIASES_REGISTRY[$name]="$emoji|$desc|$cmd"
    CMD_MODULE[$name]="$_CURRENT_MODULE_NAME"
    alias "$name"="$cmd"
}

# ============================================================================
# MODULE LOADER
# ============================================================================

_load_modules() {
    for mod in "$TERMX_DIR"/src/*/index.sh(N); do
        source "$mod"
    done
}

# ============================================================================
# CORE COMMANDS
# ============================================================================

module "⚙️" "System"

helper "help" "🛠️" "Show all available aliases and helpers" << 'HELPEOF'
    refresh > /dev/null

    echo "🛠️  All Available Commands:"
    echo "==========================="
    echo ""

    local filter="${(L)1}"

    _print_entry() {
        printf "  %-20s %s %s\n" "$1" "$2" "$3"
    }

    _matches() {
        [[ -z "$filter" ]] || [[ "${(L)1}" == *"$filter"* ]] || [[ "${(L)2}" == *"$filter"* ]]
    }

    # Collect commands grouped by module
    local -A module_cmds

    for name in ${(ko)ALIASES_REGISTRY}; do
        local info="${ALIASES_REGISTRY[$name]}"
        local emoji="${info%%|*}"
        local rest="${info#*|}"
        local desc="${rest%%|*}"
        local mod="${CMD_MODULE[$name]}"

        _matches "$name" "$desc" || _matches "$mod" "" || continue
        module_cmds[$mod]+="${name}|${emoji}|${desc}"$'\n'
    done

    for name in ${(ko)HELPERS_REGISTRY}; do
        local info="${HELPERS_REGISTRY[$name]}"
        local emoji="${info%%|*}"
        local desc="${info#*|}"
        local mod="${CMD_MODULE[$name]}"

        _matches "$name" "$desc" || _matches "$mod" "" || continue
        module_cmds[$mod]+="${name}|${emoji}|${desc}"$'\n'
    done

    # Display each module that has matching commands
    for mod_name in ${(ko)MODULES_REGISTRY}; do
        local entries="${module_cmds[$mod_name]}"
        [[ -z "$entries" ]] && continue

        local mod_emoji="${MODULES_REGISTRY[$mod_name]}"
        echo "${mod_emoji} ${mod_name}:"

        echo "$entries" | while IFS='|' read -r cmd_name cmd_emoji cmd_desc; do
            [[ -z "$cmd_name" ]] && continue
            _print_entry "$cmd_name" "$cmd_emoji" "$cmd_desc"
        done
        echo ""
    done

    echo "💡 Tips:"
    echo "  • Type 'help <keyword>' to filter commands"
    echo "  • Type 'refresh' to reload after editing"
HELPEOF

helper "refresh" "🔄" "Reload shell configuration" << 'EOF'
    unset HELPERS_REGISTRY ALIASES_REGISTRY MODULES_REGISTRY CMD_MODULE
    typeset -gA HELPERS_REGISTRY ALIASES_REGISTRY MODULES_REGISTRY CMD_MODULE

    _CURRENT_MODULE_NAME=""
    _CURRENT_MODULE_EMOJI=""

    module "⚙️" "System"
    source "$TERMX_DIR/framework.zsh"

    echo "🔄 Shell configuration reloaded"
EOF

# Quick access aliases
alias h="help"
alias "?"="help"

# ============================================================================
# BOOT
# ============================================================================

_load_modules

if [[ -z "$HELPERS_LOADED" ]]; then
    export HELPERS_LOADED=1
    echo "💡 Type 'help' (or '?') to see all aliases and helpers"
fi
