#!/bin/bash
# ============================================================
# EVA-SHELL — magi-stats.sh
# Phase 6: MAGI Diagnostics — Data Provider
# Called by eww polling to get live system stats
# Output: JSON consumed by eww widgets
# ============================================================

# CPU usage (average across all cores)
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')

# RAM usage percent
RAM_TOTAL=$(free | awk '/^Mem:/{print $2}')
RAM_USED=$(free  | awk '/^Mem:/{print $3}')
RAM_PCT=$(awk "BEGIN {printf \"%d\", ($RAM_USED/$RAM_TOTAL)*100}")

# CPU temperature
TEMP=$(sensors 2>/dev/null \
    | grep -oP 'Package id 0:.*?\+\K[0-9.]+' \
    | head -1)
# Fallback if sensors not available
TEMP="${TEMP:-$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf "%.0f", $1/1000}')}"
TEMP="${TEMP:-N/A}"

# Disk usage (root partition)
DISK=$(df / | awk 'NR==2{print int($5)}')

# Network interface
NET_IFACE=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}' || echo "lo")
NET_RX=$(cat /proc/net/dev 2>/dev/null \
    | awk -v iface="$NET_IFACE" '$1 ~ iface":" {print int($2/1024)}' \
    || echo "0")
NET_TX=$(cat /proc/net/dev 2>/dev/null \
    | awk -v iface="$NET_IFACE" '$1 ~ iface":" {print int($10/1024)}' \
    || echo "0")

# Uptime
UPTIME=$(uptime -p | sed 's/up //')

# Status colors based on thresholds
cpu_color() {
    if   [ "$CPU" -ge 90 ]; then echo "#ff4500"
    elif [ "$CPU" -ge 70 ]; then echo "#ffaa00"
    else echo "#00ccff"
    fi
}

ram_color() {
    if   [ "$RAM_PCT" -ge 85 ]; then echo "#ff4500"
    elif [ "$RAM_PCT" -ge 65 ]; then echo "#ffaa00"
    else echo "#ff6600"
    fi
}

temp_color() {
    local t="${TEMP%.*}"
    if   [ "$t" -ge 80 ] 2>/dev/null; then echo "#ff4500"
    elif [ "$t" -ge 65 ] 2>/dev/null; then echo "#ffaa00"
    else echo "#00ff88"
    fi
}

# Output JSON for eww
cat << EOF
{
  "melchior": {
    "label": "MELCHIOR",
    "metric": "CPU",
    "value": $CPU,
    "unit": "%",
    "color": "$(cpu_color)"
  },
  "balthasar": {
    "label": "BALTHASAR",
    "metric": "RAM",
    "value": $RAM_PCT,
    "unit": "%",
    "color": "$(ram_color)"
  },
  "caspar": {
    "label": "CASPAR",
    "metric": "TEMP",
    "value": "$TEMP",
    "unit": "°C",
    "color": "$(temp_color)"
  },
  "net": {
    "iface": "$NET_IFACE",
    "rx_kb": $NET_RX,
    "tx_kb": $NET_TX
  },
  "disk_pct": $DISK,
  "uptime": "$UPTIME"
}
EOF
