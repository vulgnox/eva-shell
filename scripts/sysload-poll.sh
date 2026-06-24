#!/bin/bash
# ============================================================
# EVA-SHELL — sysload-poll.sh
# Left panel: System load + memory summary
# Called by eww every 3s
# ============================================================

# Load averages
LOAD=$(cat /proc/loadavg 2>/dev/null | awk '{printf "%s %s %s", $1, $2, $3}')
LOAD="${LOAD:-0.00 0.00 0.00}"

# Memory
MEM_TOTAL=$(awk '/^MemTotal:/{print $2}' /proc/meminfo 2>/dev/null)
MEM_AVAIL=$(awk '/^MemAvailable:/{print $2}' /proc/meminfo 2>/dev/null)
if [ -n "$MEM_TOTAL" ] && [ "$MEM_TOTAL" -gt 0 ]; then
    MEM_USED_MB=$(( (MEM_TOTAL - MEM_AVAIL) / 1024 ))
    MEM_TOTAL_MB=$(( MEM_TOTAL / 1024 ))
    MEM_PCT=$(( (MEM_TOTAL - MEM_AVAIL) * 100 / MEM_TOTAL ))
else
    MEM_USED_MB=0
    MEM_TOTAL_MB=0
    MEM_PCT=0
fi

# Swap
SWAP_TOTAL=$(awk '/^SwapTotal:/{print $2}' /proc/meminfo 2>/dev/null)
SWAP_FREE=$(awk '/^SwapFree:/{print $2}' /proc/meminfo 2>/dev/null)
if [ -n "$SWAP_TOTAL" ] && [ "$SWAP_TOTAL" -gt 0 ]; then
    SWAP_PCT=$(( (SWAP_TOTAL - SWAP_FREE) * 100 / SWAP_TOTAL ))
else
    SWAP_PCT=0
fi

# Tasks
TASKS=$(ls /proc/[0-9]* -d 2>/dev/null | wc -l)

# Uptime in seconds
UPTIME_S=$(awk '{printf "%d", $1}' /proc/uptime 2>/dev/null)
HOURS=$(( UPTIME_S / 3600 ))
MINS=$(( (UPTIME_S % 3600) / 60 ))
SECS=$(( UPTIME_S % 60 ))

printf '{"load":"%s","mem_used_mb":%d,"mem_total_mb":%d,"mem_pct":%d,"swap_pct":%d,"tasks":%d,"uptime":"%02d:%02d:%02d"}\n' \
    "$LOAD" "$MEM_USED_MB" "$MEM_TOTAL_MB" "$MEM_PCT" "$SWAP_PCT" "$TASKS" "$HOURS" "$MINS" "$SECS"
