#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "-d" ]]; then
    docker run -d --name jarvis-gateway \
        -v ~/.nanobot:/root/.nanobot \
        -p 18790:18790 \
        --restart unless-stopped \
        nanobot gateway
    echo "✅ Jarvis gateway running on :18790 (container: jarvis-gateway)"
else
    docker run -it --rm \
        -v ~/.nanobot:/root/.nanobot \
        -p 18790:18790 \
        nanobot gateway
fi
