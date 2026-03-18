module "🤖" "AI"

_AI_DIR="${0:A:h}"

helper "ai-setup" "🤖" "Copy ai_stuff directory to current location" << 'EOF'
    bash "${_AI_DIR}/ai-setup.sh"
EOF

helper "cursor-rules-setup" "📐" "Copy ai_stuff to .cursor/rules (flattened)" << 'EOF'
    bash "${_AI_DIR}/cursor-rules-setup.sh"
EOF
