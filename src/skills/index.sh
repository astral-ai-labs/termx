module "🧠" "Skills"

_SKILLS_DIR="${0:A:h}"

simple_alias "anthropic-pull-skill" "📥" "Pull an Anthropic skill by name (e.g. anthropic-pull-skill pdf)" "bash $_SKILLS_DIR/pull-skill.sh"
simple_alias "anthropic-list-skills" "📋" "List all available Anthropic skills" "bash $_SKILLS_DIR/pull-skill.sh --list"
