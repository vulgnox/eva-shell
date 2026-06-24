#!/bin/bash
# ============================================================
# EVA-SHELL — net-stats.sh
# Phase 6: Right Flank — Network RX/TX stats for eww
# Outputs JSON: iface, rx_str, tx_str, rx_pct, tx_pct
# Called by eww every 3s
# ============================================================

# Detect primary interface
IFACE=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}')
if [ -z "$IFACE" ]; then
    IFACE=$(ip link show 2>/dev/null | awk -F: '/state UP/{gsub(/ /,"",$2); print $2; exit}')
fi
IFACE="${IFACE:-lo}"

# Read bytes (two samples 1s apart for rate calculation)
RX_PATH="/sys/class/net/$IFACE/statistics/rx_bytes"
TX_PATH="/sys/class/net/$IFACE/statistics/tx_bytes"

if [ -f "$RX_PATH" ] && [ -f "$TX_PATH" ]; then
    RX1=$(cat "$RX_PATH")
    TX1=$(cat "$TX_PATH")
    sleep 1
    RX2=$(cat "$RX_PATH")
    TX2=$(cat "$TX_PATH")

    RX_BPS=$(( RX2 - RX1 ))
    TX_BPS=$(( TX2 - TX1 ))

    # Clamp negatives (interface reset)
    [ $RX_BPS -lt 0 ] && RX_BPS=0
    [ $TX_BPS -lt 0 ] && TX_BPS=0
else
    RX_BPS=0
    TX_BPS=0
fi

# Format human-readable
fmt() {
    local b=$1
    if [ $b -ge 1048576 ]; then
        printf "%.1fM" "$(echo "scale=1;$b/1048576" | bc 2>/dev/null || echo 0)"
    elif [ $b -ge 1024 ]; then
        printf "%.0fK" "$(echo "scale=0;$b/1024" | bc 2>/dev/null || echo 0)"
    else
        printf "${b}B"
    fi
}

RX_STR=$(fmt $RX_BPS)
TX_STR=$(fmt $TX_BPS)

# Percentage (10MB/s = 100%)
MAX_BPS=10485760
RX_PCT=$(( RX_BPS > MAX_BPS ? 100 : RX_BPS * 100 / MAX_BPS ))
TX_PCT=$(( TX_BPS > MAX_BPS ? 100 : TX_BPS * 100 / MAX_BPS ))

printf '{"iface":"%s","rx_str":"%s/s","tx_str":"%s/s","rx_pct":%d,"tx_pct":%d}\n' \
    "$IFACE" "$RX_STR" "$TX_STR" "$RX_PCT" "$TX_PCT"
