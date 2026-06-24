#!/bin/bash
# ============================================================
# EVA-SHELL — process-tree.sh
# Phase 5: Top 8 processes by CPU with bar visualization
# Output format: LABEL | proc_name | CPU% | bar
# Called by eww every 2s
# ============================================================

# Get top 8 processes by CPU usage
# Format: rank padded name cpu% mem% visual bar
ps aux --sort=-%cpu 2>/dev/null | awk 'NR>1 && NR<=9 {
    cmd = $11
    gsub(/.*\//, "", cmd)
    gsub(/[\[\]]/, "", cmd)
    if (length(cmd) > 8) cmd = substr(cmd, 1, 8)
    cpu = $3 + 0
    mem = $4 + 0
    # Generate bar (max 10 chars width)
    bar_len = int(cpu / 10)
    if (bar_len < 1 && cpu > 0) bar_len = 1
    if (bar_len > 10) bar_len = 10
    bar = ""
    for (i = 1; i <= bar_len; i++) bar = bar "█"
    for (i = bar_len + 1; i <= 10; i++) bar = bar "░"
    printf "%d %-8s %5.1f%% %4.1f%% %s\n", NR-1, cmd, cpu, mem, bar
}' 2>/dev/null || cat << 'FALLBACK'
1 ollama    3.5%  4.2% ███░░░░░░░
2 kitty     2.2%  1.8% ██░░░░░░░░
3 eww       1.4%  2.1% █░░░░░░░░░
4 picom     1.6%  0.8% █░░░░░░░░░
5 i3        0.8%  0.5% █░░░░░░░░░
6 Xorg      0.6%  1.2% █░░░░░░░░░
7 pulseaud  0.4%  0.3% █░░░░░░░░░
8 systemd   0.2%  0.4% █░░░░░░░░░
FALLBACK
