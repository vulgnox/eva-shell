#!/bin/bash
# ============================================================
# EVA-SHELL — net-stats.sh
# Network stats for eww — outputs JSON
# ============================================================

IFACE=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}' || echo "wlo1")

# Read bytes
RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null || echo 0)
TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null || echo 0)
sleep 1
RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null || echo 0)
TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null || echo 0)

RX_BPS=$(( RX2 - RX1 ))
TX_BPS=$(( TX2 - TX1 ))

# Format string
fmt() {
    local b=$1
    if   [ $b -ge 1048576 ]; then printf "%.1fM" $(echo "scale=1;$b/1048576" | bc)
    elif [ $b -ge 1024 ];    then printf "%.0fK" $(echo "scale=0;$b/1024" | bc)
    else printf "${b}B"
    fi
}

RX_STR=$(fmt $RX_BPS)
TX_STR=$(fmt $TX_BPS)
RX_PCT=$(( RX_BPS > 10485760 ? 100 : RX_BPS * 100 / 10485760 ))
TX_PCT=$(( TX_BPS > 10485760 ? 100 : TX_BPS * 100 / 10485760 ))

cat << JSON
{"iface":"$IFACE","rx_str":"${RX_STR}/s","tx_str":"${TX_STR}/s","rx_pct":$RX_PCT,"tx_pct":$TX_PCT}
JSON
