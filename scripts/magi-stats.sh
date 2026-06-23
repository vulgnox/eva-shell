#!/bin/bash
# ============================================================
# EVA-SHELL — magi-stats.sh
# MAGI Diagnostics — JSON for eww
# MELCHIOR=CPU BALTHASAR=RAM CASPAR=TEMP
# ============================================================

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2+$4)}')
RAM_TOTAL=$(free | awk '/^Mem:/{print $2}')
RAM_USED=$(free  | awk '/^Mem:/{print $3}')
RAM_PCT=$(awk "BEGIN{printf \"%d\",($RAM_USED/$RAM_TOTAL)*100}")
TEMP=$(sensors 2>/dev/null | grep -oP 'Package id 0:.*?\+\K[0-9.]+' | head -1 \
       || cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf "%.0f",$1/1000}')
TEMP="${TEMP:-0}"
DISK=$(df / | awk 'NR==2{print int($5)}')
UPTIME=$(uptime -p | sed 's/up //')

cpu_color(){ [ "$CPU" -ge 90 ] && echo "#f02020" || { [ "$CPU" -ge 70 ] && echo "#f4b000" || echo "#5090c8"; }; }
ram_color(){ [ "$RAM_PCT" -ge 85 ] && echo "#f02020" || { [ "$RAM_PCT" -ge 65 ] && echo "#f4b000" || echo "#ec7420"; }; }
temp_color(){ local t="${TEMP%.*}"; [ "${t:-0}" -ge 80 ] && echo "#f02020" || { [ "${t:-0}" -ge 65 ] && echo "#f4b000" || echo "#60f0a0"; }; }

# Consensus: all green = clear, any warn = caution
consensus=3
[ "$CPU" -ge 80 ]     && consensus=$((consensus-1))
[ "$RAM_PCT" -ge 80 ] && consensus=$((consensus-1))
[ "${TEMP%.*}" -ge 75 ] 2>/dev/null && consensus=$((consensus-1))
[ $consensus -eq 3 ] && core_sync="99.6%" || { [ $consensus -eq 2 ] && core_sync="66.6%" || core_sync="33.3%"; }

cat << JSON
{
  "melchior":  {"label":"MELCHIOR","value":$CPU,     "unit":"%",  "color":"$(cpu_color)"},
  "balthasar": {"label":"BALTHASAR","value":$RAM_PCT, "unit":"%",  "color":"$(ram_color)"},
  "caspar":    {"label":"CASPAR",   "value":$TEMP,    "unit":"°C", "color":"$(temp_color)"},
  "disk_pct":  $DISK,
  "uptime":    "$UPTIME",
  "core_sync": "$core_sync",
  "consensus": $consensus
}
JSON
