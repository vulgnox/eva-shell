#!/bin/bash
# ============================================================
# EVA-SHELL — magi-ring.sh
# MAGI Ring SVG — hexagonal visualization with live system data
# Generates SVG to cache, outputs file path (used by magi-tui.sh)
# ============================================================

CACHE_DIR="$HOME/.cache/eva-shell"
mkdir -p "$CACHE_DIR"

# Double-buffer filenames so eww detects the path change and reloads
SLOT=$(($(date +%s) % 2))
OUTFILE="$CACHE_DIR/magi-ring-${SLOT}.svg"

# --- Gather live data ---
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2+$4)}')
RAM_TOTAL=$(free | awk '/^Mem:/{print $2}')
RAM_USED=$(free | awk '/^Mem:/{print $3}')
RAM_PCT=$(awk "BEGIN{printf \"%d\",($RAM_USED/$RAM_TOTAL)*100}")
TEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null \
       | awk '{printf "%.0f",$1/1000}')
TEMP="${TEMP:-0}"

# Uptime for TIME SINCE RAISED
UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)
UP_H=$((UPTIME_SEC / 3600))
UP_M=$(( (UPTIME_SEC % 3600) / 60 ))
UP_S=$((UPTIME_SEC % 60))
UPTIME_FMT=$(printf "%02d:%02d:%02d" "$UP_H" "$UP_M" "$UP_S")

# Consensus (3/3 = all healthy)
CON=3
[ "$CPU" -ge 80 ]            && CON=$((CON-1))
[ "$RAM_PCT" -ge 80 ]        && CON=$((CON-1))
[ "${TEMP%.*}" -ge 75 ] 2>/dev/null && CON=$((CON-1))

# Status-reactive blip colors
blip() {
    local v="${1:-0}" w="${2:-70}" c="${3:-90}"
    if   [ "$v" -ge "$c" ] 2>/dev/null; then echo "#f02020"
    elif [ "$v" -ge "$w" ] 2>/dev/null; then echo "#f4b000"
    else echo "#50ff10"; fi
}
B_CPU=$(blip "$CPU" 70 90)
B_RAM=$(blip "$RAM_PCT" 70 90)
B_TMP=$(blip "${TEMP%.*}" 65 80)

# ---- Generate SVG ----
cat > "$OUTFILE" << SVGEOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 300" width="600" height="300">
  <rect width="600" height="300" fill="#000000"/>

  <!-- Outer elliptical ring -->
  <ellipse cx="300" cy="150" rx="265" ry="125"
           fill="none" stroke="#1a3a10" stroke-width="1" stroke-dasharray="4,4"/>

  <!-- Dashed connector lines -->
  <line x1="195" y1="90" x2="405" y2="90"
        stroke="#f4b000" stroke-width="1" stroke-dasharray="4,3"/>
  <line x1="155" y1="120" x2="278" y2="138"
        stroke="#5090c8" stroke-width="1" stroke-dasharray="4,3"/>
  <line x1="445" y1="120" x2="322" y2="138"
        stroke="#ec7420" stroke-width="1" stroke-dasharray="4,3"/>
  <line x1="300" y1="200" x2="300" y2="162"
        stroke="#60f0a0" stroke-width="1" stroke-dasharray="4,3"/>

  <!-- Center Diamond — MAGI 01 -->
  <polygon points="300,115 325,140 300,165 275,140"
           fill="#050500" stroke="#ec7420" stroke-width="2"/>
  <text x="300" y="138" text-anchor="middle"
        font-family="monospace" font-size="10" fill="#ec7420"
        font-weight="bold">MAGI</text>
  <text x="300" y="152" text-anchor="middle"
        font-family="monospace" font-size="8" fill="#ec7420">01</text>

  <!-- MELCHIOR — top-left hexagon (blue) -->
  <polygon points="150,55 195,72 195,108 150,125 105,108 105,72"
           fill="none" stroke="#5090c8" stroke-width="2"/>
  <text x="150" y="80" text-anchor="middle"
        font-family="monospace" font-size="7" fill="#5090c8"
        font-weight="bold">MELCHIOR</text>
  <text x="150" y="92" text-anchor="middle"
        font-family="monospace" font-size="5" fill="#484848">CEREBRUM // CPU</text>
  <text x="150" y="112" text-anchor="middle"
        font-family="monospace" font-size="13" fill="#5090c8"
        font-weight="bold">${CPU}%</text>

  <!-- BALTHASAR — top-right hexagon (orange) -->
  <polygon points="450,55 495,72 495,108 450,125 405,108 405,72"
           fill="none" stroke="#ec7420" stroke-width="2"/>
  <text x="450" y="80" text-anchor="middle"
        font-family="monospace" font-size="7" fill="#ec7420"
        font-weight="bold">BALTHASAR</text>
  <text x="450" y="92" text-anchor="middle"
        font-family="monospace" font-size="5" fill="#484848">CALLOSUM // RAM</text>
  <text x="450" y="112" text-anchor="middle"
        font-family="monospace" font-size="13" fill="#ec7420"
        font-weight="bold">${RAM_PCT}%</text>

  <!-- CASPAR — bottom-center hexagon (teal) -->
  <polygon points="300,200 345,217 345,253 300,270 255,253 255,217"
           fill="none" stroke="#60f0a0" stroke-width="2"/>
  <text x="300" y="228" text-anchor="middle"
        font-family="monospace" font-size="7" fill="#60f0a0"
        font-weight="bold">CASPAR</text>
  <text x="300" y="240" text-anchor="middle"
        font-family="monospace" font-size="5" fill="#484848">MEDULLA // TEMP</text>
  <text x="300" y="260" text-anchor="middle"
        font-family="monospace" font-size="13" fill="#60f0a0"
        font-weight="bold">${TEMP}C</text>

  <!-- 6 Blips on outer ring -->
  <circle cx="300" cy="25"  r="4" fill="${B_CPU}"/>
  <circle cx="540" cy="80"  r="4" fill="#ec7420"/>
  <circle cx="540" cy="220" r="4" fill="#5090c8"/>
  <circle cx="300" cy="275" r="4" fill="${B_TMP}"/>
  <circle cx="60"  cy="220" r="4" fill="#60f0a0"/>
  <circle cx="60"  cy="80"  r="4" fill="${B_RAM}"/>

  <!-- TIME SINCE RAISED box -->
  <rect x="462" y="238" width="130" height="44"
        fill="#000000" stroke="#ec7420" stroke-width="1"/>
  <text x="527" y="254" text-anchor="middle"
        font-family="monospace" font-size="6" fill="#ec7420"
        letter-spacing="1">TIME SINCE RAISED</text>
  <text x="527" y="273" text-anchor="middle"
        font-family="monospace" font-size="14" fill="#50ff10"
        font-weight="bold">${UPTIME_FMT}</text>

  <!-- Consensus label -->
  <text x="300" y="182" text-anchor="middle"
        font-family="monospace" font-size="7" fill="#409820">${CON}/3 CONSENSUS</text>
</svg>
SVGEOF

echo "$OUTFILE"
