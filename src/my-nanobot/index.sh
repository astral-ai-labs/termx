module "🤖" "Nanobot"

_NANOBOT_DIR="${0:A:h}"

simple_alias "run-jarvis" "🧠" "Run Jarvis agent (isolated in Docker)" "docker run -it -v ~/.nanobot:/root/.nanobot --rm nanobot agent"
simple_alias "run-jarvis-gateway" "🌐" "Run Jarvis gateway on :18790 (-d for detached)" "bash $_NANOBOT_DIR/run-jarvis-gateway.sh"
simple_alias "stop-jarvis-gateway" "🛑" "Stop Jarvis gateway" "docker stop jarvis-gateway && docker rm jarvis-gateway && echo '✅ Jarvis gateway stopped'"
simple_alias "jarvis-gateway-logs" "📜" "Tail Jarvis gateway logs" "docker logs -f jarvis-gateway"
simple_alias "equip-jarvis-local" "🔗" "Copy a local skill into Jarvis (e.g. equip-jarvis-local pdf, or 'all')" "bash $_NANOBOT_DIR/equip-jarvis-local.sh"
simple_alias "equip-jarvis-anthropic" "📥" "Pull an Anthropic skill into Jarvis (e.g. equip-jarvis-anthropic pdf)" "bash $_NANOBOT_DIR/equip-jarvis-anthropic.sh"
simple_alias "jarvis-skills" "📋" "List skills in Jarvis workspace" "ls ~/.nanobot/workspace/skills"
