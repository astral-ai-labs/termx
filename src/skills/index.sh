module "🧠" "Skills"

_SKILLS_DIR="${0:A:h}"

simple_alias "skill-pull" "📥" "Pull an Anthropic skill by name (e.g. skill-pull pdf)" "bash $_SKILLS_DIR/pull-skill.sh"
simple_alias "skill-list" "📋" "List all available Anthropic skills" "bash $_SKILLS_DIR/pull-skill.sh --list"
simple_alias "skill-dir" "📂" "Open local skills directory" "cd ~/eng/2026/skills && ls"
