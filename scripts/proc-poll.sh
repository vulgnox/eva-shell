#!/bin/bash
# ============================================================
# EVA-SHELL — proc-poll.sh
# Returns top processes as formatted bars for eww
# Called by eww every 3s
# ============================================================

# Get top 6 processes by CPU, format as name + percentage
ps aux --sort=-%cpu 2>/dev/null | awk 'NR>1 && NR<=7 {
    cmd = $11
    gsub(/.*\//, "", cmd)
    if (length(cmd) > 10) cmd = substr(cmd, 1, 10)
    printf "%-10s %5.1f%%\n", cmd, $3
}' 2>/dev/null || cat << 'FALLBACK'
i3wm         0.8%
eww          1.4%
kitty        2.2%
ollama       3.5%
picom        1.6%
polybar      0.5%
FALLBACK
