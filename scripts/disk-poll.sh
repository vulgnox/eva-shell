#!/bin/bash
# ============================================================
# EVA-SHELL — disk-poll.sh
# Right panel: Disk usage + I/O stats
# Called by eww every 5s
# ============================================================

# Root filesystem usage
ROOT_PCT=$(df / 2>/dev/null | awk 'NR==2{print int($5)}')
ROOT_USED=$(df -h / 2>/dev/null | awk 'NR==2{print $3}')
ROOT_TOTAL=$(df -h / 2>/dev/null | awk 'NR==2{print $2}')
ROOT_PCT="${ROOT_PCT:-0}"
ROOT_USED="${ROOT_USED:-0G}"
ROOT_TOTAL="${ROOT_TOTAL:-0G}"

# Home partition (if separate, otherwise same as root)
HOME_PCT=$(df /home 2>/dev/null | awk 'NR==2{print int($5)}')
HOME_PCT="${HOME_PCT:-$ROOT_PCT}"

# I/O stats from /proc/diskstats (sectors read/written)
DISK_DEV=$(lsblk -ndo NAME 2>/dev/null | head -1)
DISK_DEV="${DISK_DEV:-sda}"
if [ -f "/sys/block/$DISK_DEV/stat" ]; then
    read -r _ _ SECTORS_R _ _ _ SECTORS_W _ < "/sys/block/$DISK_DEV/stat" 2>/dev/null
    # Convert sectors (512B each) to human-readable
    READ_MB=$(( (SECTORS_R * 512) / 1048576 ))
    WRITE_MB=$(( (SECTORS_W * 512) / 1048576 ))
else
    READ_MB=0
    WRITE_MB=0
fi

printf '{"root_pct":%d,"root_used":"%s","root_total":"%s","home_pct":%d,"read_mb":%d,"write_mb":%d,"device":"%s"}\n' \
    "$ROOT_PCT" "$ROOT_USED" "$ROOT_TOTAL" "$HOME_PCT" "$READ_MB" "$WRITE_MB" "$DISK_DEV"
