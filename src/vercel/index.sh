module "▲" "Vercel"

helper "vv-teams" "📋" "List all Vercel teams" << 'EOF'
    echo "Available Vercel teams:"
    vercel teams ls
EOF

helper "vv-personal" "👤" "Switch to personal Vercel account" << 'EOF'
    echo "Switching to personal Vercel account..."
    vercel switch chrismaresca-projects && echo "✅ Switched to personal account (chrismaresca-projects)"
EOF

helper "vv-astral" "🚀" "Switch to Astral team" << 'EOF'
    echo "Switching to Astral team..."
    vercel switch astral-cebbbadc && echo "✅ Switched to Astral team (astral-cebbbadc)"
EOF

helper "vv-current" "👁️" "Show current Vercel team/context" << 'EOF'
    echo "Current Vercel context:"
    vercel whoami
EOF
