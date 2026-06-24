#!/bin/bash
# ============================================================
# EVA-SHELL — log-stream.sh
# Phase 5: Left Flank — Enhanced System Log Stream
# Terminal version with ANSI color coding by level
# 20-line rolling buffer, parses boot time, modules, net, thermal
# ============================================================

# EVA-SHELL exact palette (ANSI 24-bit)
C_GREEN='\033[38;2;80;255;16m'
C_GREEN_DIM='\033[38;2;64;152;32m'
C_ORANGE='\033[38;2;236;116;32m'
C_YELLOW='\033[38;2;244;176;0m'
C_TEAL='\033[38;2;96;240;160m'
C_BLUE='\033[38;2;80;144;200m'
C_RED='\033[38;2;240;32;32m'
C_DIM='\033[38;2;72;72;72m'
C_RESET='\033[0m'
C_BOLD='\033[1m'

# Header
clear
echo -e "${C_GREEN}${C_BOLD}┌─────────────────────────────────────┐${C_RESET}"
echo -e "${C_GREEN}${C_BOLD}│  SYS_LOG_STREAM  //  NERV MAGI      │${C_RESET}"
echo -e "${C_GREEN}${C_BOLD}└─────────────────────────────────────┘${C_RESET}"
echo ""

# Boot time reference
BOOT_TIME=$(who -b 2>/dev/null | awk '{print $3, $4}')
if [ -n "$BOOT_TIME" ]; then
    echo -e "${C_DIM}[SYS] Boot: ${BOOT_TIME}${C_RESET}"
fi
echo ""

# Live journal stream — 20 initial lines + follow
journalctl -f -n 20 --no-pager --output=cat 2>/dev/null \
| while IFS= read -r line; do
    # Truncate for display
    msg="${line:0:60}"

    # Color classify by level/content
    case "$line" in
        *[Ee]rror*|*ERROR*|*[Ff]ail*|*FAIL*|*[Cc]ritical*|*CRIT*|*[Ee]merg*|*[Aa]lert*)
            echo -e "${C_ORANGE}${C_BOLD}[ERR]${C_RESET} ${C_ORANGE}${msg}${C_RESET}" ;;
        *[Ww]arn*|*WARN*|*WARNING*)
            echo -e "${C_YELLOW}[WRN]${C_RESET} ${C_YELLOW}${msg}${C_RESET}" ;;
        *[Kk]ernel*|*KRN*|*i915*|*drm*|*[Uu]sb*|*[Mm]odule*|*[Ll]oaded*)
            echo -e "${C_BLUE}[KRN]${C_RESET} ${C_DIM}${msg}${C_RESET}" ;;
        *[Nn]etwork*|*wlo*|*eth*|*NET*|*[Dd]hcp*|*[Ww]ifi*|*[Ww]lan*|*[Dd]ns*)
            echo -e "${C_TEAL}[NET]${C_RESET} ${C_DIM}${msg}${C_RESET}" ;;
        *[Tt]herm*|*[Tt]emp*|*[Hh]eat*|*[Cc]ooling*)
            echo -e "${C_YELLOW}[TMP]${C_RESET} ${C_YELLOW}${msg}${C_RESET}" ;;
        *[Ss]tarted*|*[Aa]ctivat*|*[Oo]nline*|*[Rr]eady*|*[Ss]uccess*|*[Bb]oot*)
            echo -e "${C_GREEN}[OK ]${C_RESET} ${C_GREEN_DIM}${msg}${C_RESET}" ;;
        *)
            echo -e "${C_DIM}[LOG] ${msg}${C_RESET}" ;;
    esac
done
