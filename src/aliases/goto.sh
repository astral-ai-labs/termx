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
