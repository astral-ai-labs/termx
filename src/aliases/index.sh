module "🔧" "Utilities"

simple_alias "home" "🏠" "Go to home directory" "cd ~"
simple_alias "python" "🐍" "Use Python 3" "python3"
simple_alias "cpath" "📍" "Copy current directory path" "pwd | pbcopy && echo '📍 Path copied: '\$(pwd)"
simple_alias "cls" "🧹" "Clear screen" "clear"
simple_alias "edit-zsh" "⚙️" "Open .zshrc for editing" "cursor ~/.zshrc"
simple_alias "popiterm" "📺" "Open iTerm at current directory" "open -a iTerm \"$PWD\""
simple_alias "open-termx" "📂" "Open termx repo in Cursor" "cursor ~/eng/2026/core/termx"
