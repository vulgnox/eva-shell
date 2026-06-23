#!/bin/bash
# ============================================================
# EVA-SHELL — log-poll.sh
# Returns last 12 lines of system journal, color-coded labels
# Called by eww every 2s
# ============================================================

# Get recent journal lines, format with EVA-style labels
journalctl --no-pager -n 12 --output=cat 2>/dev/null | while IFS= read -r line; do
    case "$line" in
        *error*|*ERROR*|*fail*|*FAIL*)
            echo "[ERR] ${line:0:40}" ;;
        *warn*|*WARN*|*WARNING*)
            echo "[WRN] ${line:0:40}" ;;
        *kernel*|*KRN*)
            echo "[KRN] ${line:0:40}" ;;
        *network*|*wlo*|*eth*|*NET*)
            echo "[NET] ${line:0:40}" ;;
        *)
            echo "[OK ] ${line:0:40}" ;;
    esac
done 2>/dev/null || cat << 'FALLBACK'
[OK ] MAGI 3/3 CONSENSUS
[NET] wlo1 DHCP acquired
[OK ] picom compositor ACTIVE
[WRN] thermal monitoring
[OK ] eww magi-panel ONLINE
[KRN] i915 GPU nominal
[OK ] i3 ws1 focus
[NET] rx:-- tx:--
[OK ] UNIT-01 STANDBY
[OK ] ollama:melchior READY
[LOG] uptime --
FALLBACK
