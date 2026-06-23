#!/bin/bash
# ============================================================
# EVA-SHELL — boot-sequence.sh
# NERV MAGI boot — exact show colors
# ============================================================
BOOT_FLAG="/tmp/.eva-shell-booted"
[ -f "$BOOT_FLAG" ] && exit 0
touch "$BOOT_FLAG"

OR='\033[38;2;236;116;32m'   # orange #ec7420
GR='\033[38;2;80;255;16m'    # green  #50ff10
GD='\033[38;2;64;152;32m'    # green-dim #409820
TL='\033[38;2;96;240;160m'   # teal  #60f0a0
BL='\033[38;2;80;144;200m'   # blue  #5090c8
YL='\033[38;2;244;176;0m'    # yellow #f4b000
RD='\033[38;2;240;32;32m'    # red   #f02020
DM='\033[38;2;72;72;72m'     # dim   #484848
RS='\033[0m'
BD='\033[1m'

clear
SOUND="$HOME/.config/eva-shell/themes/eva-01/sounds/nerv-alert.wav"
[ -f "$SOUND" ] && paplay "$SOUND" &

echo ""
echo -e "${OR}${BD}"
cat << 'ART'
  ███╗   ███╗ █████╗  ██████╗ ██╗      ██████╗  ██╗
  ████╗ ████║██╔══██╗██╔════╝ ██║     ██╔═══██╗███║
  ██╔████╔██║███████║██║  ███╗██║     ██║   ██║╚██║
  ██║╚██╔╝██║██╔══██║██║   ██║██║     ██║   ██║ ██║
  ██║ ╚═╝ ██║██║  ██║╚██████╔╝██║     ╚██████╔╝ ██║
  ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝      ╚═════╝  ╚═╝
ART
echo -e "${RS}"
echo -e "${DM}  GEHIRN SPECIAL AGENCY — NERV TACTICAL DIVISION${RS}"
echo -e "${DM}  MAGI SUPERCOMPUTER SYSTEM — INITIALIZATION${RS}"
echo ""
sleep 0.3

checks=(
  "${GR}  [INIT]${RS}  MAGI-01 STARTUP SEQUENCE INITIATED"
  "${GD}  [SYS ]${RS}  LOADING KERNEL MODULES ............. ${GR}OK${RS}"
  "${BL}  [MEL ]${RS}  MELCHIOR-1  (CEREBRUM) ONLINE ...... ${GR}NOMINAL${RS}"
  "${OR}  [BAL ]${RS}  BALTHASAR-2 (CALLOSUM) ONLINE ...... ${GR}NOMINAL${RS}"
  "${TL}  [CAS ]${RS}  CASPAR-3    (MEDULLA)  ONLINE ...... ${GR}NOMINAL${RS}"
  "${GR}  [MAGI]${RS}  CONSENSUS REACHED: 3/3 ............. ${GR}CONFIRMED${RS}"
  "${OR}  [SEC ]${RS}  PATTERN ANALYSIS ................... ${YL}STANDBY${RS}"
  "${OR}  [SEC ]${RS}  DANANG TYPE-B DEFENSE .............. ${GR}ARMED${RS}"
  "${TL}  [NET ]${RS}  NETWORK INTERFACE wlo1 ............. ${GR}ACTIVE${RS}"
  "${GD}  [ENV ]${RS}  DISPLAY SERVER X11 ................. ${GR}ACTIVE${RS}"
  "${GD}  [ENV ]${RS}  COMPOSITOR picom ................... ${GR}INIT${RS}"
  "${GD}  [ENV ]${RS}  WINDOW MANAGER i3wm ................ ${GR}LOADED${RS}"
  "${BL}  [LLM ]${RS}  MELCHIOR CEREBRUM OLLAMA ........... ${GR}ONLINE${RS}"
  "${GR}  [EVA ]${RS}  TACTICAL INTERFACE ................. ${GR}SYNCHRONIZED${RS}"
)

for line in "${checks[@]}"; do
    echo -e "$line"; sleep 0.1
done

echo ""
sleep 0.2
echo -e "${OR}  CORE SYNC RATIO:${RS}"
echo -n "  ["
for i in $(seq 1 40); do
    printf "${OR}█${RS}"; sleep 0.035
done
echo "] ${GR}${BD}99.6%${RS}"
echo ""
sleep 0.3
echo -e "${OR}${BD}  ▶ MAGI SYSTEM ONLINE — PROTECT NO.666 ACTIVE${RS}"
echo ""
sleep 0.6
clear
