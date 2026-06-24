#!/bin/bash
# ============================================================
# EVA-SHELL — ascii-poll.sh
# Phase 6: Right Flank — ASCII art for eww poll
# Outputs EVA UNIT-01 art (5 lines centered) + sync percentage
# Cycles through 4 frames based on seconds
# Called by eww every 3s
# ============================================================

# Determine frame by current second (cycles every 12s = 4 frames * 3s)
SECOND=$(date +%s)
FRAME=$(( (SECOND / 3) % 4 ))

# CPU-based sync ratio
SYNC=$(top -bn1 2>/dev/null | awk '/Cpu\(s\)/{printf "%.1f", 100-$8}')
SYNC="${SYNC:-99.6}"

case $FRAME in
    0)
        cat << EOF
   _________
  / ________ \\
 | | U-01  | |
 | | NERV  | |
  \\_________/
   SYNC: ${SYNC}%
EOF
        ;;
    1)
        cat << EOF
   ╔═══════╗
   ║  ◈◈◈  ║
   ║ UNIT  ║
   ║  -01  ║
   ╚═══════╝
   SYNC: ${SYNC}%
EOF
        ;;
    2)
        cat << EOF
    /\\    /\\
   /  \\  /  \\
  / ◈  \\/  ◈ \\
  \\   MAGI   /
   \\________/
   SYNC: ${SYNC}%
EOF
        ;;
    3)
        cat << EOF
   [=========]
   | ◈ EVA ◈ |
   | UNIT-01 |
   | ACTIVE  |
   [=========]
   SYNC: ${SYNC}%
EOF
        ;;
esac
