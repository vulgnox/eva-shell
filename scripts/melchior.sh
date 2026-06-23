#!/bin/bash
# ============================================================
# EVA-SHELL — melchior.sh
# MELCHIOR CEREBRUM — Local LLM analyst via Ollama
# Queries llama3.2:1b with system state, returns short analysis
# Called by eww every 30s
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
    # Try to start it
    ollama serve > /dev/null 2>&1 &
    sleep 2
fi

# Build prompt — short, clinical, MAGI style
PROMPT="You are MELCHIOR, the analytical core of the MAGI supercomputer. \
Analyze this system state and respond in exactly 1-2 sentences, clinical and direct. \
No markdown, no formatting. State only what matters. \
CPU:${CPU}% RAM:${RAM_PCT}% TEMP:${TEMP}C DISK:${DISK}% TOP_PROC:${TOP_PROC} LOAD:${LOAD}"

# Query ollama
RESPONSE=$(ollama run "$MODEL" "$PROMPT" 2>/dev/null \
           || ollama run "$FALLBACK_MODEL" "$PROMPT" 2>/dev/null)

if [ -z "$RESPONSE" ]; then
    # Fallback: generate from data without LLM
    if   [ "$CPU" -ge 80 ]; then
        echo "CPU critical at ${CPU}%. ${TOP_PROC} primary load. Recommend investigation."
    elif [ "$RAM_PCT" -ge 80 ]; then
        echo "Memory pressure at ${RAM_PCT}%. ${TOP_PROC} consuming most resources."
    elif [ "${TEMP%.*}" -ge 75 ] 2>/dev/null; then
        echo "Thermal warning: ${TEMP}°C. CPU load ${CPU}%. Monitor cooling."
    else
        echo "Systems nominal. CPU:${CPU}% RAM:${RAM_PCT}% TEMP:${TEMP}°C. No anomalies detected."
    fi
else
    # Trim to 120 chars max for display
    echo "$RESPONSE" | head -c 120
fi
