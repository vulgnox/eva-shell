#!/bin/bash
# ============================================================
# EVA-SHELL — launch-eww.sh
# Start eww daemon + open all windows
# ============================================================
eww kill 2>/dev/null || true
sleep 0.5
eww daemon
sleep 1
eww open magi-main
eww open circuit-overlay
echo "eww launched"
