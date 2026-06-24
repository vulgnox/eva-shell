#!/bin/bash
# ============================================================
# EVA-SHELL — magi-diag.sh
# Phase 6: Right Flank — MAGI diagnostic metrics
# MELCHIOR: CPU usage (via /proc/stat)
# BALTHASAR: RAM usage (via /proc/meminfo)
# CASPAR: Temperature (via /sys/class/thermal)
# Outputs: JSON for eww consumption
# Called by eww every 2s
# ============================================================

# --- MELCHIOR: CPU usage from /proc/stat ---
read_cpu() {
    awk '/^cpu /{print $2+$3+$4+$5+$6+$7+$8, $5}' /proc/stat
}

CPU_SAMPLE1=$(read_cpu)
sleep 0.5
CPU_SAMPLE2=$(read_cpu)

TOTAL1=$(echo "$CPU_SAMPLE1" | awk '{print $1}')
IDLE1=$(echo "$CPU_SAMPLE1" | awk '{print $2}')
TOTAL2=$(echo "$CPU_SAMPLE2" | awk '{print $1}')
IDLE2=$(echo "$CPU_SAMPLE2" | awk '{print $2}')

TOTAL_DIFF=$((TOTAL2 - TOTAL1))
IDLE_DIFF=$((IDLE2 - IDLE1))

if [ $TOTAL_DIFF -gt 0 ]; then
    MEL_CPU=$(( (TOTAL_DIFF - IDLE_DIFF) * 100 / TOTAL_DIFF ))
else
    MEL_CPU=0
fi

# --- BALTHASAR: RAM usage from /proc/meminfo ---
MEM_TOTAL=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)
MEM_AVAIL=$(awk '/^MemAvailable:/{print $2}' /proc/meminfo)
if [ -n "$MEM_TOTAL" ] && [ "$MEM_TOTAL" -gt 0 ]; then
    MEM_USED=$((MEM_TOTAL - MEM_AVAIL))
    BAL_RAM=$((MEM_USED * 100 / MEM_TOTAL))
else
    BAL_RAM=0
fi

# --- CASPAR: Temperature from /sys/class/thermal ---
TEMP_RAW=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
if [ -n "$TEMP_RAW" ]; then
    CAS_TEMP=$((TEMP_RAW / 1000))
else
    CAS_TEMP=$(sensors 2>/dev/null | grep -oP 'Package id 0:.*?\+\K[0-9]+' | head -1)
    CAS_TEMP="${CAS_TEMP:-0}"
fi

# --- Color logic ---
mel_color() { [ "$MEL_CPU" -ge 90 ] && echo "#f02020" || { [ "$MEL_CPU" -ge 70 ] && echo "#f4b000" || echo "#5090c8"; }; }
bal_color() { [ "$BAL_RAM" -ge 85 ] && echo "#f02020" || { [ "$BAL_RAM" -ge 65 ] && echo "#f4b000" || echo "#ec7420"; }; }
cas_color() { [ "$CAS_TEMP" -ge 80 ] && echo "#f02020" || { [ "$CAS_TEMP" -ge 65 ] && echo "#f4b000" || echo "#60f0a0"; }; }

# --- Output JSON ---
printf '{"mel_cpu":%d,"bal_ram":%d,"cas_temp":%d,"mel_color":"%s","bal_color":"%s","cas_color":"%s"}\n' \
    "$MEL_CPU" "$BAL_RAM" "$CAS_TEMP" "$(mel_color)" "$(bal_color)" "$(cas_color)"
