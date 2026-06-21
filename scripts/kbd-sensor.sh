#!/bin/bash
# ============================================================
# EVA-SHELL — kbd-sensor.sh
# Phase 7: Bottom Flank — Keyboard Sensor Matrix
# Visual-only keypress display — cosmetic, not a keylogger
# Uses xinput to track keypresses and display in matrix
# ============================================================

C_GREEN='\033[38;2;0;255;65m'
C_DIM='\033[38;2;74;122;74m'
C_ORANGE='\033[38;2;255;69;0m'
C_CYAN='\033[38;2;0;212;255m'
C_RESET='\033[0m'
C_BOLD='\033[1m'

# Key display buffer (last 20 keys)
declare -a KEY_BUFFER
MAX_KEYS=20

# Matrix display — 5x4 grid of recent key indicators
MATRIX_W=10
MATRIX_H=4

header() {
    echo -e "${C_GREEN}${C_BOLD}╔══════════════════════════╗${C_RESET}"
    echo -e "${C_GREEN}${C_BOLD}║   KEYBOARD_SENSOR_MTX    ║${C_RESET}"
    echo -e "${C_GREEN}${C_BOLD}╚══════════════════════════╝${C_RESET}"
}

draw_matrix() {
    local buf_len=${#KEY_BUFFER[@]}
    local idx=0

    for ((row=0; row<MATRIX_H; row++)); do
        echo -n "  "
        for ((col=0; col<MATRIX_W; col++)); do
            local pos=$((row * MATRIX_W + col))
            if [ $pos -lt $buf_len ]; then
                local key="${KEY_BUFFER[$pos]}"
                # Recent keys brighter
                if [ $pos -ge $((buf_len - 3)) ]; then
                    printf "${C_GREEN}[%-2s]${C_RESET}" "$key"
                else
                    printf "${C_DIM}[%-2s]${C_RESET}" "$key"
                fi
            else
                printf "${C_DIM}[  ]${C_RESET}"
            fi
        done
        echo ""
    done
}

last_key_display() {
    local last="${KEY_BUFFER[$((${#KEY_BUFFER[@]} - 1))]}"
    echo ""
    echo -e "  ${C_DIM}LAST INPUT:${C_RESET} ${C_ORANGE}${C_BOLD}[ ${last:-...} ]${C_RESET}"
    echo -e "  ${C_DIM}COUNT: ${#KEY_BUFFER[@]}/${MAX_KEYS}${C_RESET}"
}

# ============================================================
# Try to use xinput for real keypress detection
# Falls back to animated simulation if not available
# ============================================================

if command -v xinput &>/dev/null && xinput list --name-only 2>/dev/null | grep -qi "keyboard"; then
    # Real keypress tracking via xinput
    KBD_ID=$(xinput list --id-only "$(xinput list --name-only | grep -i keyboard | head -1)" 2>/dev/null)

    if [ -n "$KBD_ID" ]; then
        clear
        header
        echo ""

        xinput test "$KBD_ID" 2>/dev/null | while read -r event; do
            # Parse key press events only (not releases)
            if echo "$event" | grep -q "key press"; then
                KEY=$(echo "$event" | grep -oP 'key press\s+\K\d+' | head -1)

                # Map keycode to label (simplified common keys)
                case "$KEY" in
                    65)  LABEL="SPC" ;;
                    36)  LABEL="RET" ;;
                    22)  LABEL="BSP" ;;
                    23)  LABEL="TAB" ;;
                    9)   LABEL="ESC" ;;
                    [0-9]|[1-9][0-9]) LABEL="K$KEY" ;;
                    *)   LABEL="K$KEY" ;;
                esac

                # Add to buffer, cap at MAX_KEYS
                KEY_BUFFER+=("$LABEL")
                if [ ${#KEY_BUFFER[@]} -gt $MAX_KEYS ]; then
                    KEY_BUFFER=("${KEY_BUFFER[@]:1}")
                fi

                # Redraw
                tput cup 4 0
                draw_matrix
                last_key_display
                echo ""
                echo -e "  ${C_DIM}$(date '+%H:%M:%S') // SENSOR ACTIVE${C_RESET}"
            fi
        done
    fi
else
    # ============================================================
    # Fallback: animated simulation (cosmetic only)
    # ============================================================
    FAKE_KEYS=("SPC" "RET" "BSP" "TAB" "CTL" "ALT" "SFT" "K1" "K2" "K3"
               "K4"  "K5"  "K6"  "K7"  "K8"  "K9"  "K0"  "F1" "F2" "ESC")

    while true; do
        clear
        header
        echo ""

        # Add a random fake key to buffer
        RAND_KEY="${FAKE_KEYS[$((RANDOM % ${#FAKE_KEYS[@]}))]}"
        KEY_BUFFER+=("$RAND_KEY")
        if [ ${#KEY_BUFFER[@]} -gt $MAX_KEYS ]; then
            KEY_BUFFER=("${KEY_BUFFER[@]:1}")
        fi

        draw_matrix
        last_key_display
        echo ""
        echo -e "  ${C_DIM}$(date '+%H:%M:%S') // SIMULATION MODE${C_RESET}"

        sleep 0.4
    done
fi
