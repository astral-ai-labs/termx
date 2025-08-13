# TermX - Shell Helper System

A self-documenting, zero-maintenance shell helper framework for zsh.

## Setup

```bash
# Clone to your engineering directory
git clone https://github.com/astral-ai-labs/termx.git ~/eng/termx

# In ~/.zshrc, add this single line:
source ~/eng/termx/framework.zsh

# Reload shell
source ~/.zshrc
```

## Usage

```bash
?                    # Show all available commands
? aws                # Filter commands (e.g., aws-related)
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
helper "name" "emoji" "description (with usage example)" << 'EOF'
    # your code here
EOF

# Example:
helper "aws-login" "🔑" "Login to AWS SSO (e.g. aws-login dev)" << 'EOF'
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
helper "greet" "👋" "Greet someone (e.g. greet Alice)" << 'EOF'
    echo "Hello, ${1:-World}!"
EOF
OUTER_EOF

# Check if it was successfully created
?
# Should be listed in the aliases or helpers
```

## Files

- `framework.zsh` - Core system (don't edit)
- `helpers.zsh` - Your commands (edit this)