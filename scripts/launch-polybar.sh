#!/bin/bash
# ============================================================
# EVA-SHELL — launch-polybar.sh
# Kills existing polybar instances and relaunches
# Called by i3 exec_always
# ============================================================

# Kill existing
pkill -x polybar 2>/dev/null || true
sleep 0.3

# Wait for i3 to be ready
while ! pgrep -x i3 > /dev/null; do sleep 0.1; done

# Launch top bar
polybar eva-top --config="$HOME/.config/eva-shell/config/polybar/config.ini" &

echo "Polybar launched"
