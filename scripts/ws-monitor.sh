#!/bin/bash
# ============================================================
# EVA-SHELL — ws-monitor.sh
# Workspace + window list for center panel (eww defpoll)
# ============================================================

WS=$(i3-msg -t get_workspaces 2>/dev/null \
     | jq -r '.[] | select(.focused) | .name' 2>/dev/null)
WS="${WS:-1}"

WINDOWS=$(i3-msg -t get_tree 2>/dev/null | jq -r '
  [recurse(.nodes[]?, .floating_nodes[]?) |
   select(.type == "workspace" and .name == "'"$WS"'") |
   recurse(.nodes[]?, .floating_nodes[]?) |
   select(.window != null and .name != null) |
   .name] | .[:8] | .[]
' 2>/dev/null)

echo "WS:${WS} ACTIVE"
if [ -n "$WINDOWS" ]; then
    echo "$WINDOWS"
else
    echo "(no windows)"
fi
