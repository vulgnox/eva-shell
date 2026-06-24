#!/bin/bash
# ============================================================
# EVA-SHELL — melchior.sh
# MELCHIOR CEREBRUM — Local LLM analyst via Ollama
# Queries llama3.2:1b with system state, returns NERV-style analysis
# Called by magi-tui.sh every 30s
# ============================================================

MODEL="llama3.2:1b"
FALLBACK_MODEL="gemma2:2b"

# Gather system state
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2+$4)}')
RAM_PCT=$(free | awk '/^Mem:/{printf "%d", $3/$2*100}')
TEMP=$(sensors 2>/dev/null | grep -oP 'Package id 0:.*?\+\K[0-9.]+' | head -1 \
       || cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf "%.0f",$1/1000}')
TEMP="${TEMP:-N/A}"
DISK=$(df / | awk 'NR==2{print int($5)}')
TOP_PROC=$(ps aux --sort=-%cpu | awk 'NR==2{print $11}' | xargs basename 2>/dev/null)
LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')

# Check ollama is running
if ! pgrep -x ollama > /dev/null 2>&1; then
    ollama serve > /dev/null 2>&1 &
    sleep 2
fi

# NERV/MAGI themed prompt
PROMPT="You are MELCHIOR, the CEREBRUM processing unit of NERV's MAGI-01 supercomputer \
system in Tokyo-3 GEO-FRONT. You report system analysis to NERV Command. \
Start response with threat level in brackets: [BLUE] nominal, [YELLOW] caution, \
[ORANGE] elevated, [RED] critical. Use NERV terminology (AT-Field harmonics, \
sync rates, pattern analysis, LCL pressure, MAGI consensus). Be clinical, terse, \
ominous. One short sentence only, max 80 characters. No markdown. No formatting. Stay in character. \
Current readings — CPU:${CPU}% RAM:${RAM_PCT}% TEMP:${TEMP}C DISK:${DISK}% LOAD:${LOAD} PROC:${TOP_PROC}"

# Query ollama
RESPONSE=$(ollama run "$MODEL" "$PROMPT" 2>/dev/null \
           || ollama run "$FALLBACK_MODEL" "$PROMPT" 2>/dev/null)

if [ -z "$RESPONSE" ]; then
    # Themed fallback without LLM
    if   [ "$CPU" -ge 80 ]; then
        echo "[ORANGE] Anomalous load pattern in CEREBRUM — CPU harmonics at ${CPU}%. AT-Field diagnostic recommended."
    elif [ "$RAM_PCT" -ge 80 ]; then
        echo "[YELLOW] Memory pressure across MAGI bus — ${RAM_PCT}% capacity. Pattern Blue watch initiated."
    elif [ "${TEMP%.*}" -ge 75 ] 2>/dev/null; then
        echo "[YELLOW] Thermal drift in CASPAR MEDULLA — ${TEMP}°C. LCL coolant flow adjustment advised."
    elif [ "$CPU" -ge 50 ] || [ "$RAM_PCT" -ge 50 ]; then
        echo "[BLUE] MAGI sync rate nominal. Minor harmonics from ${TOP_PROC:-system}. All units in consensus."
    else
        echo "[BLUE] All MAGI units in consensus. System harmonics stable. No pattern detected in Tokyo-3 perimeter."
    fi
else
    echo "$RESPONSE" | tr -d '\n' | head -c 100
fi
