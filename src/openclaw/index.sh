module "🦞" "OpenClaw"

helper "walt" "🦞" "Open OpenClaw TUI (walt add <skill> installs a skill)" << 'EOF'
    if [[ "$1" == "add" ]]; then
        if [[ -z "$2" ]]; then
            echo "Usage: walt add <skill>"
            return 1
        fi

        openclaw skills install "$2"
        return
    fi

    openclaw tui
EOF
