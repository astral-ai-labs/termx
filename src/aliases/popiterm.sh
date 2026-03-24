#!/usr/bin/env bash
set -euo pipefail

osascript <<APPLESCRIPT
tell application "iTerm2"
    activate
    set w to (create window with default profile)
    tell current session of w
        write text "cd $(printf '%q' "$PWD")"
    end tell
end tell
APPLESCRIPT
