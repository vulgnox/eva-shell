#!/bin/bash
# ============================================================
# EVA-SHELL — magi-tui.sh
# MAGI SUPERCOMPUTER TUI — runs inside a kitty terminal
# Displays MAGI system ring, consensus, and stats
# Tiles with the working terminal in i3 center workspace
# ============================================================

# Colors
OR='\033[38;5;208m'   # orange #ec7420
GR='\033[38;5;82m'    # green #50ff10
GD='\033[38;5;70m'    # green dim #409820
BL='\033[38;5;74m'    # blue #5090c8
TL='\033[38;5;85m'    # teal #60f0a0
YL='\033[38;5;220m'   # yellow #f4b000
RD='\033[38;5;196m'   # red #f02020
DM='\033[38;5;240m'   # dim #484848
RS='\033[0m'          # reset
BD='\033[1m'          # bold

draw_bar() {
    local val=$1 max=$2 width=$3 color=$4
    local filled=$(( val * width / max ))
    local empty=$(( width - filled ))
    printf "${color}"
    for ((i=0; i<filled; i++)); do printf "█"; done
    printf "${DM}"
    for ((i=0; i<empty; i++)); do printf "░"; done
    printf "${RS}"
}

while true; do
    clear

    # Get system data
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')
    MEM_USED=$(free -m | awk '/Mem:/{print $3}')
    MEM_TOTAL=$(free -m | awk '/Mem:/{print $2}')
    MEM_PCT=$(( MEM_USED * 100 / MEM_TOTAL ))
    TEMP=$(sensors 2>/dev/null | grep -oP '\+\K[0-9]+(?=\.[0-9]+°C)' | head -1)
    [ -z "$TEMP" ] && TEMP="--"
    UPTIME=$(uptime -p | sed 's/up //')
    TIME=$(date '+%H:%M:%S')
    DATE=$(date '+%Y.%m.%d')

    # Width of terminal
    COLS=$(tput cols)

    # Header
    printf "${OR}${BD}"
    printf "  ┌─────────────────┐"
    printf "%*s" $(( COLS - 56 )) ""
    printf "┌──────────────────┐\n"
    printf "  │ DANANG TYPE-B   │"
    printf "%*s" $(( COLS - 56 )) ""
    printf "│ TIME TO COLLAPSE │\n"
    printf "  │ ${YL}NO. 666${OR}         │"
    printf "%*s" $(( COLS - 56 )) ""
    printf "│ ${GR}${UPTIME}${OR}  │\n"
    printf "  └─────────────────┘"
    printf "%*s" $(( COLS - 56 )) ""
    printf "└──────────────────┘${RS}\n"

    # Title
    printf "\n"
    CENTER_PAD=$(( (COLS - 30) / 2 ))
    printf "%*s${OR}${BD}MAGI -- 01${RS}\n" $CENTER_PAD ""
    printf "%*s${GD}on MAGI-01 ORIGINAL${RS}\n" $(( CENTER_PAD - 4 )) ""

    # Consensus
    printf "%*s${GR}● ${GD}MEL  ${GR}● ${GD}BAL  ${GR}● ${GD}CAS  ${GR}3/3 CONSENSUS${RS}\n" $(( CENTER_PAD - 8 )) ""

    printf "\n"

    # MAGI Units
    printf "  ${BL}${BD}MELCHIOR${RS}${DM} CEREBRUM // LLM${RS}"
    printf "%*s" $(( COLS / 3 - 28 )) ""
    printf "${OR}${BD}BALTHASAR${RS}${DM} CALLOSUM // MEM${RS}"
    printf "%*s" $(( COLS / 3 - 28 )) ""
    printf "${TL}${BD}CASPAR${RS}${DM} MEDULLA // ENV${RS}\n"

    # Bars
    BAR_W=$(( COLS / 3 - 12 ))
    [ $BAR_W -gt 30 ] && BAR_W=30

    printf "  "
    draw_bar $CPU 100 $BAR_W "\033[38;5;74m"
    printf " ${BL}${CPU}%%${RS}"
    printf "%*s" $(( COLS / 3 - BAR_W - 8 )) ""
    draw_bar $MEM_PCT 100 $BAR_W "\033[38;5;208m"
    printf " ${OR}${MEM_PCT}%%${RS}"
    printf "%*s" $(( COLS / 3 - BAR_W - 8 )) ""
    TEMP_VAL=${TEMP%.*}
    [ "$TEMP_VAL" = "--" ] && TEMP_VAL=0
    draw_bar $TEMP_VAL 100 $BAR_W "\033[38;5;85m"
    printf " ${TL}${TEMP}C${RS}\n"

    printf "\n"

    # Clock strip
    printf "  ${GD}${DATE}${RS}"
    printf "  ${DM}//${RS}"
    printf "  ${GR}${BD}${TIME}${RS}"
    printf "  ${DM}//${RS}"
    printf "  ${DM}TOKYO-3 // GEO-FRONT${RS}\n"

    # Diamond
    printf "\n"
    printf "%*s${OR}◆ MAGI 01 ◆${RS}\n" $(( (COLS - 11) / 2 )) ""

    # LLM status
    printf "\n"
    MEL_OUT=$(~/.config/eva-shell/scripts/melchior.sh 2>/dev/null | head -1)
    [ -z "$MEL_OUT" ] && MEL_OUT="Systems nominal. No anomalies detected."
    printf "  ${BL}MELCHIOR // LLM ANALYSIS:${RS}\n"
    printf "  ${TL}${MEL_OUT}${RS}\n"

    sleep 2
done
