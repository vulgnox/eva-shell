#!/bin/bash
# ============================================================
# EVA-SHELL — boot-sequence.sh
# Phase 4: Immersive Boot Engine
# Runs once on i3 session start — 3-5 second NERV init
# ============================================================

# Only run on first login (not on i3 reload)
BOOT_FLAG="/tmp/.eva-shell-booted"
if [ -f "$BOOT_FLAG" ]; then
    exit 0
fi
touch "$BOOT_FLAG"

# Load theme colors
COLORS="$HOME/.config/eva-shell/themes/$(cat $HOME/.config/eva-shell/.active-theme 2>/dev/null || echo eva-01)/colors.conf"
[ -f "$COLORS" ] && source "$COLORS"

# ============================================================
# ANSI color helpers (for the boot terminal)
# ============================================================
C_GREEN='\033[38;2;0;255;65m'
C_PURPLE='\033[38;2;107;33;168m'
C_ORANGE='\033[38;2;255;69;0m'
C_CYAN='\033[38;2;0;212;255m'
C_DIM='\033[38;2;74;122;74m'
C_WHITE='\033[38;2;224;255;224m'
C_RESET='\033[0m'
C_BOLD='\033[1m'

# Clear screen
clear

# Play NERV alert sound (non-blocking)
SOUND_FILE="$HOME/.config/eva-shell/themes/eva-01/sounds/nerv-alert.wav"
if [ -f "$SOUND_FILE" ]; then
    paplay "$SOUND_FILE" &
fi

# ============================================================
# BOOT SEQUENCE — cascade text
# ============================================================

sleep 0.2

echo ""
echo ""
echo -e "${C_GREEN}${C_BOLD}"
echo "  ███╗   ██╗███████╗██████╗ ██╗   ██╗"
echo "  ████╗  ██║██╔════╝██╔══██╗██║   ██║"
echo "  ██╔██╗ ██║█████╗  ██████╔╝██║   ██║"
echo "  ██║╚██╗██║██╔══╝  ██╔══██╗╚██╗ ██╔╝"
echo "  ██║ ╚████║███████╗██║  ██║ ╚████╔╝ "
echo "  ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝  ╚═══╝  "
echo -e "${C_RESET}"

echo -e "${C_DIM}  GEHIRN ADVANCED TACTICAL RESEARCH DIVISION${C_RESET}"
echo -e "${C_DIM}  SPECIAL AGENCY — SECTION 1 CLEARANCE${C_RESET}"
echo ""

sleep 0.3

# System checks — cascading
checks=(
    "${C_GREEN}  [INIT]${C_RESET}    MAGI SYSTEM STARTUP SEQUENCE INITIATED"
    "${C_GREEN}  [INIT]${C_RESET}    LOADING KERNEL MODULES........... ${C_GREEN}OK${C_RESET}"
    "${C_CYAN}  [MAGI]${C_RESET}    MELCHIOR-1 ONLINE ............... ${C_GREEN}NOMINAL${C_RESET}"
    "${C_CYAN}  [MAGI]${C_RESET}    BALTHASAR-2 ONLINE .............. ${C_GREEN}NOMINAL${C_RESET}"
    "${C_CYAN}  [MAGI]${C_RESET}    CASPAR-3 ONLINE ................. ${C_GREEN}NOMINAL${C_RESET}"
    "${C_GREEN}  [SYS]${C_RESET}     CONSENSUS REACHED: 3/3 .......... ${C_GREEN}CONFIRMED${C_RESET}"
    "${C_PURPLE}  [NET]${C_RESET}     NETWORK INTERFACE DETECTED ...... ${C_GREEN}ACTIVE${C_RESET}"
    "${C_PURPLE}  [NET]${C_RESET}     ENCRYPTION LAYER ................ ${C_GREEN}ENABLED${C_RESET}"
    "${C_ORANGE}  [SEC]${C_RESET}     PATTERN ANALYSIS ................ ${C_GREEN}STANDBY${C_RESET}"
    "${C_ORANGE}  [SEC]${C_RESET}     ANGEL DETECTION GRID ............ ${C_GREEN}ARMED${C_RESET}"
    "${C_GREEN}  [ENV]${C_RESET}     DISPLAY SERVER .................. ${C_GREEN}X11 ACTIVE${C_RESET}"
    "${C_GREEN}  [ENV]${C_RESET}     COMPOSITOR ...................... ${C_GREEN}PICOM INIT${C_RESET}"
    "${C_GREEN}  [ENV]${C_RESET}     WINDOW MANAGER .................. ${C_GREEN}i3 LOADED${C_RESET}"
    "${C_GREEN}  [EVA]${C_RESET}     UNIT-01 INTERFACE ............... ${C_GREEN}SYNCHRONIZED${C_RESET}"
)

for line in "${checks[@]}"; do
    echo -e "$line"
    sleep 0.12
done

echo ""
sleep 0.3

# Core sync meter
echo -e "${C_WHITE}  CORE SYNC RATIO:${C_RESET}"
echo -n "  ["

# Animate the sync bar
for i in $(seq 1 40); do
    echo -ne "${C_GREEN}█${C_RESET}"
    sleep 0.04
done

echo "] ${C_GREEN}${C_BOLD}99.6%${C_RESET}"
echo ""
sleep 0.3

echo -e "${C_GREEN}${C_BOLD}  ▶ TACTICAL INTERFACE ONLINE — INITIALIZING HUD...${C_RESET}"
echo ""
sleep 0.5

# Fade out effect — clear line by line
for i in $(seq 1 5); do
    echo ""
    sleep 0.08
done

sleep 0.3
clear
