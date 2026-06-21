#!/bin/bash
# ============================================================
# EVA-SHELL — log-stream.sh
# Phase 5: Left Flank — System Log Stream
# Pipes journalctl output with EVA color coding
# ============================================================

# ANSI colors
C_GREEN='\033[38;2;0;255;65m'
C_ORANGE='\033[38;2;255;69;0m'
C_YELLOW='\033[38;2;255;170;0m'
C_CYAN='\033[38;2;0;212;255m'
C_DIM='\033[38;2;74;122;74m'
C_WHITE='\033[38;2;224;255;224m'
C_PURPLE='\033[38;2;107;33;168m'
C_RESET='\033[0m'
C_BOLD='\033[1m'

# Header
clear
echo -e "${C_GREEN}${C_BOLD}┌─────────────────────────────────────┐${C_RESET}"
echo -e "${C_GREEN}${C_BOLD}│  SYSTEM_LOG_STREAM  //  MAGI FEED   │${C_RESET}"
echo -e "${C_GREEN}${C_BOLD}└─────────────────────────────────────┘${C_RESET}"
echo ""

# Live journal stream with color coding
journalctl -f -n 50 --no-pager --output=short \
| while IFS= read -r line; do

    # Timestamp prefix
    TIMESTAMP=$(echo "$line" | grep -oP '^\S+ \S+ \S+' | head -1)

    # Color based on severity keywords
    if echo "$line" | grep -qiE "error|fail|critical|emerg|alert|crit"; then
        echo -e "${C_ORANGE}${C_BOLD}[ERR] ${C_RESET}${C_ORANGE}$line${C_RESET}"

    elif echo "$line" | grep -qiE "warn|warning"; then
        echo -e "${C_YELLOW}[WRN] ${C_RESET}${C_YELLOW}$line${C_RESET}"

    elif echo "$line" | grep -qiE "started|starting|activated|success|online"; then
        echo -e "${C_GREEN}[OK ] ${C_RESET}${C_DIM}$line${C_RESET}"

    elif echo "$line" | grep -qiE "network|wifi|wlan|eth|connection"; then
        echo -e "${C_CYAN}[NET] ${C_RESET}${C_DIM}$line${C_RESET}"

    elif echo "$line" | grep -qiE "kernel|kernal"; then
        echo -e "${C_PURPLE}[KRN] ${C_RESET}${C_DIM}$line${C_RESET}"

    else
        echo -e "${C_DIM}[LOG] $line${C_RESET}"
    fi

done
