#!/bin/bash
# ============================================================
# EVA-SHELL — file-poll.sh
# Returns home directory listing for bottom panel
# Called by eww every 10s
# ============================================================

echo "▶ ~/"
ls -1 "$HOME" 2>/dev/null | head -8 | while read -r item; do
    if [ -d "$HOME/$item" ]; then
        echo "  ▶ $item/"
    else
        echo "    $item"
    fi
done
