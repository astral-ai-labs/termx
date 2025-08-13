# TermX - Shell Helper System

A self-documenting, zero-maintenance shell helper framework for zsh.

## Setup

```bash
# In ~/.zshrc, add this single line:
source ~/eng/termx/framework.zsh
```

## Usage

```bash
?                    # Show all available commands
? aws                # Filter commands (e.g., aws-related)
?? copy-files        # Show detailed help for any command
edit-helpers         # Add new commands
refresh              # Reload after changes
```

## Adding Commands

Edit `helpers.zsh` using `edit-helpers`, then add:

### Simple Alias (one-liner)

```bash
simple_alias "name" "emoji" "description" "command"

# Example:
simple_alias "cpath" "📍" "Copy current directory path" "pwd | pbcopy"
```

### Helper Function (multi-line)

```bash
helper "name" "emoji" "description" << 'EOF'
    # your code here
EOF

# Example:
helper "aws-login" "🔑" "Login to AWS SSO" << 'EOF'
    aws sso login --profile "$1" && export AWS_PROFILE="$1"
    echo "AWS_PROFILE set to $1"
EOF
```

## For LLMs

To add a new command programmatically:

```bash
# Add a simple alias
echo 'simple_alias "test" "🧪" "Test command" "echo test"' >> ~/eng/termx/helpers.zsh

# Add a helper function
cat >> ~/eng/termx/helpers.zsh << 'OUTER_EOF'
helper "greet" "👋" "Greet someone" << 'EOF'
    echo "Hello, ${1:-World}!"
EOF
OUTER_EOF

# Reload
source ~/.zshrc
```

## Files

- `framework.zsh` - Core system (don't edit)
- `helpers.zsh` - Your commands (edit this)
