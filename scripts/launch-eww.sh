#!/bin/bash
# ============================================================
# EVA-SHELL — launch-eww.sh
# Starts eww daemon and opens all 4 HUD panel windows
# Called by i3 on startup (exec_always)
# ============================================================

# Kill existing eww instance
eww kill 2>/dev/null || true
sleep 0.5

# Start daemon (uses config from ~/.config/eva-shell/config/eww/)
eww daemon --config ~/.config/eva-shell/config/eww/ 2>/dev/null &
sleep 1

# Open all HUD panels
eww open left-panel   --config ~/.config/eva-shell/config/eww/
eww open magi-center  --config ~/.config/eva-shell/config/eww/
eww open right-panel  --config ~/.config/eva-shell/config/eww/
eww open bottom-panel --config ~/.config/eva-shell/config/eww/

echo "[EVA] eww HUD panels launched"
