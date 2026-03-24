_goto() {
    local emoji="$1" dir="$2" action="$3"
    if [[ "$action" == "finder" ]]; then
        open "$dir"
        echo "📂 Opened ${dir:t} in Finder"
    else
        cd "$dir"
        echo "$emoji ~/${dir#$HOME/}"
    fi
}

helper "fund" "💰" "Go to fund dir (fund finder → Finder)" << 'EOF'
    _goto "💰" /Users/chris/eng/2026/fund "$1"
EOF

helper "clients" "👥" "Go to clients dir (clients finder → Finder)" << 'EOF'
    _goto "👥" /Users/chris/eng/2026/clients "$1"
EOF

helper "skills" "🧠" "Go to skills dir (skills finder → Finder)" << 'EOF'
    _goto "🧠" /Users/chris/eng/2026/skills "$1"
EOF

helper "playground" "🎮" "Go to playground dir (playground finder → Finder)" << 'EOF'
    _goto "🎮" /Users/chris/eng/2026/playground "$1"
EOF

helper "writing" "📝" "Go to writing dir (writing finder → Finder)" << 'EOF'
    _goto "📝" /Users/chris/eng/2026/playground/writing "$1"
EOF

helper "c-cfg" "⚙️" "Go to Claude config dir (c-cfg finder → Finder)" << 'EOF'
    _goto "⚙️" ~/.claude "$1"
EOF
