module "📋" "Copy"

_COPY_DIR="${0:A:h}"

helper "copy-files" "📋" "Copy coding files to clipboard (e.g. copy-files -max 5)" << 'EOF'
    bash "${_COPY_DIR}/copy-files.sh" "$@"
EOF
