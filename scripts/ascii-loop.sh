#!/bin/bash
# ============================================================
# EVA-SHELL — ascii-loop.sh
# Phase 6: Right Flank — ASCII Animation Loop
# Cycles through EVA-01 ASCII frames endlessly
# ============================================================

C_GREEN='\033[38;2;0;255;65m'
C_PURPLE='\033[38;2;107;33;168m'
C_DIM='\033[38;2;74;122;74m'
C_CYAN='\033[38;2;0;212;255m'
C_ORANGE='\033[38;2;255;69;0m'
C_RESET='\033[0m'
C_BOLD='\033[1m'

ASSET_DIR="$HOME/.config/eva-shell/themes/$(cat $HOME/.config/eva-shell/.active-theme 2>/dev/null || echo eva-01)/assets"

# ============================================================
# FRAME DEFINITIONS — EVA-01 geometric / unit ASCII art
# ============================================================

frame_eva_head() {
echo -e "${C_GREEN}"
cat << 'EOF'
         ___________
        /  _________\\
       /  / _______ \\
      /  / /  ___  \ \\
     |  | | /   \ | ||
     |  | ||  ◈  || ||
     |  | | \___/ | ||
      \  \ \_______/ /
       \  \__________/
        \   __________
         \ /  E V A  /
          \__________/
EOF
echo -e "${C_RESET}"
}

frame_geometric_1() {
echo -e "${C_GREEN}"
cat << 'EOF'
    ╔═══════════════╗
    ║  ◈  NERV  ◈  ║
    ╠═══════════════╣
    ║   /\  /\  /\ ║
    ║  /  \/  \/  \║
    ║ /   /\   /\  ║
    ║/   /  \ /  \ ║
    ║   / ◈  X  ◈ \║
    ║  /    / \    \║
    ║ /    /   \    ║
    ╠═══════════════╣
    ║  UNIT-01 SYS  ║
    ╚═══════════════╝
EOF
echo -e "${C_RESET}"
}

frame_geometric_2() {
echo -e "${C_PURPLE}"
cat << 'EOF'
        ___
       /   \
      / ◈   \
     /________\
    /\        /\
   /  \ SYNC /  \
  /    \    /    \
 / ◈    \  /    ◈ \
/________\/________\
\        /\        /
 \  ◈   /  \  ◈  /
  \    /    \    /
   \  / MAGI \  /
    \/________\/
EOF
echo -e "${C_RESET}"
}

frame_cross() {
echo -e "${C_ORANGE}"
cat << 'EOF'
    ┌─────┐
    │  ╔══╧══╗  │
    │  ║ ╔═╗ ║  │
 ╔══╧══╣ ║ ║ ╠══╧══╗
 ║ ╔═╗ ║ ║ ║ ║ ╔═╗ ║
 ║ ║ ║ ╚═╬═╬═╝ ║ ║ ║
 ║ ╚═╝   ║ ║   ╚═╝ ║
 ╚════════╩═╩════════╝
    │  ║ ╚═╝ ║  │
    │  ╚══╤══╝  │
    └─────┘
  ✟ CROSS OF NERV ✟
EOF
echo -e "${C_RESET}"
}

frame_sphere() {
echo -e "${C_CYAN}"
cat << 'EOF'
       .  *  .  *  .
     *  .  *  .  *  .
   .  _____________  .
  * /  .  *  .  *  \ *
 . / *  .  *  .  *  \ .
  | .  ◈  CORE  ◈  . |
 .| *  .  *  .  *   *|.
  | .  *  .  *  .  . |
  *\ .  *  .  *  .  /*
   .\ *  .  *  .  * /.
     \_____________/
   *  .  *  .  *  .  *
     .  *  .  *  .
    SYNC RATIO: 99.6%
EOF
echo -e "${C_RESET}"
}

frame_data_rain() {
    local chars="01ネルヴNERVマギMAGI同期シンクGEHIRN░▒▓█"
    local width=18
    local height=14
    echo -e "${C_GREEN}"
    for ((i=0; i<height; i++)); do
        line=""
        for ((j=0; j<width; j++)); do
            idx=$((RANDOM % ${#chars}))
            line+="${chars:$idx:1} "
        done
        echo "  $line"
    done
    echo -e "${C_RESET}"
    echo -e "${C_DIM}  [PATTERN ANALYSIS ACTIVE]${C_RESET}"
}

frame_status() {
    local sync=$(shuf -i 88-100 -n 1)
    local temp=$(sensors 2>/dev/null | grep -oP 'Package id 0:.*?\+\K[0-9.]+' | head -1 || echo "N/A")
    echo -e "${C_GREEN}"
    cat << EOF
  ┌───────────────────┐
  │  EVA-01  STATUS   │
  ├───────────────────┤
  │ PILOT: AUTHORIZED │
  │ SYNC : ${sync}%         │
  │ TEMP : ${temp}°C      │
  ├───────────────────┤
  │ ██████████ 100%   │
  │ A.T. FIELD: ARMED │
  └───────────────────┘
EOF
    echo -e "${C_RESET}"
}

# ============================================================
# MAIN LOOP — cycles through frames
# ============================================================
FRAME=0
FRAMES=(frame_eva_head frame_geometric_1 frame_geometric_2 frame_cross frame_sphere frame_data_rain frame_status)
FRAME_COUNT=${#FRAMES[@]}
DELAY=2.5

while true; do
    clear

    # Header
    echo -e "${C_DIM}  ╔══════════════════════╗${C_RESET}"
    echo -e "${C_DIM}  ║  ASCII_RENDER_LOOP   ║${C_RESET}"
    echo -e "${C_DIM}  ╚══════════════════════╝${C_RESET}"
    echo ""

    # Call current frame function
    ${FRAMES[$FRAME]}

    echo ""
    echo -e "${C_DIM}  $(date '+%Y.%m.%d // %H:%M:%S')${C_RESET}"
    echo -e "${C_DIM}  FRAME: $((FRAME + 1))/${FRAME_COUNT}${C_RESET}"

    # Advance frame
    FRAME=$(( (FRAME + 1) % FRAME_COUNT ))

    sleep "$DELAY"
done
