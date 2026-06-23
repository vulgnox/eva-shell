#!/bin/bash
# ============================================================
# EVA-SHELL — launch-eww.sh
# Starts eww daemon and opens all 4 HUD panel windows
# Called by i3 on startup (exec_always)
# ============================================================

# Ensure ~/.local/bin is in PATH (eww lives there)
export PATH="$HOME/.local/bin:$PATH"

# Force dark GTK theme so eww panels get black backgrounds
export GTK_THEME="Adwaita:dark"
export GTK2_RC_FILES="/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc"

EWW_BIN="$(command -v eww 2>/dev/null || echo "$HOME/.local/bin/eww")"
EWW_CONFIG="$HOME/.config/eva-shell/config/eww"

# Bail if eww not found
if [ ! -x "$EWW_BIN" ]; then
    echo "[EVA] ERROR: eww binary not found" >&2
    exit 1
fi

# Kill existing eww instance
"$EWW_BIN" kill 2>/dev/null || true
sleep 0.5

# Start daemon
"$EWW_BIN" daemon --config "$EWW_CONFIG" 2>/dev/null &
sleep 1.5

# Open all HUD panels
"$EWW_BIN" open left-panel   --config "$EWW_CONFIG" 2>&1
"$EWW_BIN" open magi-center  --config "$EWW_CONFIG" 2>&1
"$EWW_BIN" open right-panel  --config "$EWW_CONFIG" 2>&1
"$EWW_BIN" open bottom-panel --config "$EWW_CONFIG" 2>&1

echo "[EVA] eww HUD panels launched"
