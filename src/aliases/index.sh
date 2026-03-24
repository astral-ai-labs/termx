module "🔧" "Utilities"

simple_alias "home" "🏠" "Go to home directory" "cd ~"
simple_alias "python" "🐍" "Use Python 3" "python3"
simple_alias "cpath" "📍" "Copy current directory path" "pwd | pbcopy && echo '📍 Path copied: '\$(pwd)"
simple_alias "cls" "🧹" "Clear screen" "clear"
simple_alias "edit-zsh" "⚙️" "Open .zshrc for editing" "cursor ~/.zshrc"
simple_alias "popiterm" "📺" "Open a new iTerm window at current directory" "bash ${0:A:h}/popiterm.sh"
simple_alias "open-termx" "📂" "Open termx repo in Cursor" "cursor ~/eng/2026/core/termx"
simple_alias "finder" "📂" "Open current directory in Finder" "open ."

helper "paste" "📋" "Paste clipboard contents to a file" << 'EOF'
    local filename="$1"
    if [[ -z "$filename" ]]; then
        printf "📋 Filename: "
        read filename
    fi
    [[ -z "$filename" ]] && echo "❌ No filename provided" && return 1
    [[ "$filename" != *.* ]] && filename="${filename}.md"
    pbpaste > "$filename"
    echo "📋 Pasted to $filename"
EOF

source "${0:A:h}/goto.sh"
