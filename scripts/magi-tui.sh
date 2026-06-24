#!/bin/bash
# ============================================================
# EVA-SHELL — magi-tui.sh
# MAGI SUPERCOMPUTER TUI — runs inside a kitty terminal
# Displays MAGI hexagonal ring SVG (via kitty icat) + stats
# Falls back to text-only mode if image tools unavailable
# Tiles with the working terminal in i3 center workspace
# ============================================================

tput civis
trap 'tput cnorm; kitty +kitten icat --clear 2>/dev/null; exit' INT TERM EXIT

CACHE_DIR="$HOME/.cache/eva-shell"
mkdir -p "$CACHE_DIR"
PNG_FILE="$CACHE_DIR/magi-ring.png"
SCRIPT_DIR="$HOME/.config/eva-shell/scripts"

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

# Detect rendering capabilities
USE_IMAGE=false
SVG_CONVERTER=""
if command -v rsvg-convert &>/dev/null; then
    SVG_CONVERTER="rsvg-convert"
elif command -v convert &>/dev/null; then
    SVG_CONVERTER="convert"
fi
if [ -n "$SVG_CONVERTER" ] && [ "$TERM" = "xterm-kitty" ]; then
    USE_IMAGE=true
fi

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

clear

while true; do
    printf '\033[H'

    # --- Gather system data ---
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2+$4)}')
    MEM_USED=$(free -m | awk '/Mem:/{print $3}')
    MEM_TOTAL=$(free -m | awk '/Mem:/{print $2}')
    MEM_PCT=$(( MEM_USED * 100 / MEM_TOTAL ))
    TEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null \
           | awk '{printf "%.0f",$1/1000}')
    [ -z "$TEMP" ] && TEMP=$(sensors 2>/dev/null \
           | grep -oP '\+\K[0-9]+(?=\.[0-9]+°C)' | head -1)
    [ -z "$TEMP" ] && TEMP="--"
    UPTIME=$(uptime -p | sed 's/up //')
    TIME=$(date '+%H:%M:%S')
    DATE=$(date '+%Y.%m.%d')
    COLS=$(tput cols)

    # --- SVG Image mode ---
    if $USE_IMAGE; then
        SVG_PATH=$("$SCRIPT_DIR/magi-ring.sh" 2>/dev/null)

        if [ -f "$SVG_PATH" ]; then
            if [ "$SVG_CONVERTER" = "rsvg-convert" ]; then
                rsvg-convert -w 600 -h 300 "$SVG_PATH" -o "$PNG_FILE" 2>/dev/null
            else
                convert -background black "$SVG_PATH" "$PNG_FILE" 2>/dev/null
            fi
            kitty +kitten icat --clear 2>/dev/null
            kitty +kitten icat --transfer-mode file "$PNG_FILE" 2>/dev/null
        fi

        # Compact status line below image
        printf "\033[K\n"
        printf "  ${GD}${DATE}${RS}  ${DM}//${RS}  ${GR}${BD}${TIME}${RS}"
        printf "  ${DM}//${RS}  ${DM}TOKYO-3 // GEO-FRONT${RS}"
        printf "  ${DM}//${RS}  ${OR}${BD}UPTIME: ${GR}${UPTIME}${RS}\033[K\n"

    # --- Text-only fallback ---
    else
        GAP=$(( COLS - 56 ))
        [ $GAP -lt 0 ] && GAP=0

        # Header boxes
        printf "${OR}${BD}"
        printf "  ┌─────────────────┐%*s┌──────────────────┐\033[K\n" $GAP ""
        printf "  │ DANANG TYPE-B   │%*s│ TIME TO COLLAPSE │\033[K\n" $GAP ""
        printf "  │ ${YL}NO. 666${OR}         │%*s│ ${GR}%-16s${OR} │\033[K\n" $GAP "" "$UPTIME"
        printf "  └─────────────────┘%*s└──────────────────┘${RS}\033[K\n" $GAP ""

        # Title
        CENTER_PAD=$(( (COLS - 30) / 2 ))
        [ $CENTER_PAD -lt 0 ] && CENTER_PAD=0
        printf "\033[K\n"
        printf "%*s${OR}${BD}MAGI -- 01${RS}\033[K\n" $CENTER_PAD ""
        printf "%*s${GD}on MAGI-01 ORIGINAL${RS}\033[K\n" $(( CENTER_PAD - 4 )) ""

        # Consensus
        printf "%*s${GR}● ${GD}MEL  ${GR}● ${GD}BAL  ${GR}● ${GD}CAS  ${GR}3/3 CONSENSUS${RS}\033[K\n" $(( CENTER_PAD - 8 )) ""
        printf "\033[K\n"

        # MAGI Units
        printf "  ${BL}${BD}MELCHIOR${RS} ${DM}CEREBRUM//LLM${RS}"
        printf "%*s" $(( COLS / 3 - 26 )) ""
        printf "${OR}${BD}BALTHASAR${RS} ${DM}CALLOSUM//MEM${RS}"
        printf "%*s" $(( COLS / 3 - 26 )) ""
        printf "${TL}${BD}CASPAR${RS} ${DM}MEDULLA//ENV${RS}\033[K\n"

        # Bars
        BAR_W=$(( COLS / 3 - 12 ))
        [ $BAR_W -gt 30 ] && BAR_W=30
        [ $BAR_W -lt 5 ] && BAR_W=5
        printf "  "
        draw_bar $CPU 100 $BAR_W "\033[38;5;74m"
        printf " ${BL}%3d%%${RS}" $CPU
        printf "   "
        draw_bar $MEM_PCT 100 $BAR_W "\033[38;5;208m"
        printf " ${OR}%3d%%${RS}" $MEM_PCT
        printf "   "
        TEMP_VAL=${TEMP%.*}
        [ "$TEMP_VAL" = "--" ] && TEMP_VAL=0
        draw_bar $TEMP_VAL 100 $BAR_W "\033[38;5;85m"
        printf " ${TL}%s°C${RS}\033[K\n" "$TEMP"
        printf "\033[K\n"

        # Clock
        printf "  ${GD}${DATE}${RS}  ${DM}//${RS}  ${GR}${BD}${TIME}${RS}  ${DM}//${RS}  ${DM}TOKYO-3 // GEO-FRONT${RS}\033[K\n"

        # Diamond
        printf "\033[K\n"
        printf "%*s${OR}◆ MAGI 01 ◆${RS}\033[K\n" $(( (COLS - 11) / 2 )) ""
    fi

    # --- LLM status (shared between modes) ---
    if [ -z "$MEL_OUT" ] || [ $(( SECONDS % 30 )) -eq 0 ]; then
        MEL_OUT=$("$SCRIPT_DIR/melchior.sh" 2>/dev/null | head -1)
        [ -z "$MEL_OUT" ] && MEL_OUT="Systems nominal. No anomalies detected."
    fi
    printf "\033[K\n"
    printf "  ${BL}MELCHIOR // LLM ANALYSIS:${RS}\033[K\n"
    printf "  ${TL}%-$((COLS - 4))s${RS}\033[K\n" "$MEL_OUT"

    printf '\033[J'
    sleep 2
done
