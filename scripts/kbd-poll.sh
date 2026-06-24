#!/bin/bash
# ============================================================
# EVA-SHELL — kbd-poll.sh
# Keyboard sensor display — shows key activity
# Called by eww every 1s
# ============================================================

# Try to read from /dev/input or use xinput
# Fallback to simulated display if no access

# Count keypresses from /proc/interrupts (keyboard IRQ)
KB_COUNT=$(cat /proc/interrupts 2>/dev/null | grep -i keyboard | awk '{sum+=$2} END{printf "%d", sum}')
KB_COUNT="${KB_COUNT:-0}"

# Simulated key grid state (random active keys for visual effect)
SEED=$(($(date +%s) % 9))
KEYS=("SPC" "RET" "BSP" "CTL" "ALT" "SFT" "TAB" "ESC" "F1")

# Generate display
LINE1=""
for i in $(seq 0 8); do
    if [ $((($SEED + $i) % 3)) -eq 0 ]; then
        LINE1="${LINE1}[${KEYS[$i]}] "
    else
        LINE1="${LINE1} ${KEYS[$i]}  "
    fi
done

echo "$LINE1"
echo "LAST:[RET] COUNT:${KB_COUNT} RATE:--/s"
