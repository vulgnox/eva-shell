#!/bin/bash
# ============================================================
# EVA-SHELL — log-poll.sh
# Phase 5: Enhanced system journal poller for eww left panel
# Returns last 20 lines color-tagged by level
# Called by eww every 2s
# ============================================================

# Get recent journal lines (20-line rolling buffer)
# Format: [TAG] message (fixed-width 5-char labels)
journalctl --no-pager -n 20 --output=cat 2>/dev/null | while IFS= read -r line; do
    # Truncate to fit 280px panel (~38 chars at 9px font)
    msg="${line:0:34}"
    case "$line" in
        *[Ee]rror*|*ERROR*|*[Ff]ail*|*FAIL*|*[Cc]ritical*|*CRIT*)
            echo "[ERR] $msg" ;;
        *[Ww]arn*|*WARN*|*WARNING*)
            echo "[WRN] $msg" ;;
        *[Kk]ernel*|*KRN*|*i915*|*drm*|*usb*)
            echo "[KRN] $msg" ;;
        *[Nn]etwork*|*wlo*|*eth*|*NET*|*[Dd]hcp*|*[Ww]ifi*|*[Ww]lan*)
            echo "[NET] $msg" ;;
        *[Ss]tarted*|*[Aa]ctivat*|*[Oo]nline*|*[Rr]eady*|*[Ss]uccess*)
            echo "[OK ] $msg" ;;
        *[Tt]herm*|*[Tt]emp*|*[Hh]eat*)
            echo "[WRN] $msg" ;;
        *)
            echo "[LOG] $msg" ;;
    esac
done 2>/dev/null || cat << 'FALLBACK'
[OK ] MAGI 3/3 CONSENSUS ACTIVE
[NET] wlo1 DHCP lease acquired
[OK ] picom compositor ACTIVE
[WRN] thermal zone0 monitoring
[OK ] eww magi-panel ONLINE
[KRN] i915 GPU freq nominal
[OK ] i3 ws:1 focus acquired
[NET] rx:1.2M tx:340K stable
[OK ] UNIT-01 ACTIVATION READY
[OK ] ollama:melchior v3.2 READY
[LOG] session uptime 02:14:38
[OK ] audio pulse sink ACTIVE
[KRN] nvme0 temp 42C nominal
[NET] dns resolver 8.8.8.8 OK
[OK ] systemd --user RUNNING
[LOG] journal rotate 4.2M
[OK ] dbus session broker OK
[WRN] swap usage 12% rising
[OK ] NERV-HQ link ESTABLISHED
[LOG] magi-ring.sh cycle 847
FALLBACK
