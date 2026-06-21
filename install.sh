#!/bin/bash
# ============================================================
# EVA-SHELL — install.sh
# Phase 1: Base Installation
# Run this on a fresh Ubuntu 24.04 install
# ============================================================

set -e

EVA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/eva-shell"

# --- colors for this script's own output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${CYAN}[EVA]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
die()  { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║   EVA-SHELL INITIALIZATION BEGIN     ║"
echo "  ║   MAGI SYSTEM — STANDBY              ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

# ============================================================
# STEP 1: System update
# ============================================================
log "Updating package index..."
sudo apt update -qq || die "apt update failed"
ok "Package index updated"

# ============================================================
# STEP 2: Core WM + compositor
# ============================================================
log "Installing i3wm + picom..."
sudo apt install -y \
    i3 \
    i3status \
    i3lock \
    picom \
    xorg \
    xinit \
    x11-xserver-utils \
    || die "i3/picom install failed"
ok "i3wm + picom installed"

# ============================================================
# STEP 3: Terminal + file manager
# ============================================================
log "Installing kitty + ranger..."
sudo apt install -y \
    kitty \
    ranger \
    python3-ranger \
    || die "kitty/ranger install failed"
ok "kitty + ranger installed"

# ============================================================
# STEP 4: Polybar
# ============================================================
log "Installing polybar..."
sudo apt install -y polybar || die "polybar install failed"
ok "polybar installed"

# ============================================================
# STEP 5: Rofi
# ============================================================
log "Installing rofi..."
sudo apt install -y rofi || die "rofi install failed"
ok "rofi installed"

# ============================================================
# STEP 6: System monitoring tools
# ============================================================
log "Installing btop, lm-sensors, net-tools..."
sudo apt install -y \
    btop \
    lm-sensors \
    net-tools \
    iproute2 \
    acpi \
    || die "monitoring tools install failed"
ok "Monitoring tools installed"

# ============================================================
# STEP 7: Audio
# ============================================================
log "Installing audio tools..."
sudo apt install -y \
    pulseaudio \
    alsa-utils \
    || die "audio install failed"
ok "Audio tools installed"

# ============================================================
# STEP 8: Font — JetBrains Mono
# ============================================================
log "Installing JetBrains Mono font..."
sudo apt install -y fonts-jetbrains-mono 2>/dev/null || {
    warn "fonts-jetbrains-mono not in apt — downloading manually..."
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    wget -q "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip" \
        -O /tmp/jbmono.zip && \
    unzip -q /tmp/jbmono.zip -d /tmp/jbmono && \
    cp /tmp/jbmono/fonts/ttf/*.ttf "$FONT_DIR/" && \
    fc-cache -f -q && \
    ok "JetBrains Mono installed manually"
}
ok "Font ready"

# ============================================================
# STEP 9: eww (Elkowar's Wacky Widgets)
# ============================================================
log "Installing eww..."
EWW_VERSION="0.6.0"
EWW_BIN="$HOME/.local/bin/eww"
mkdir -p "$HOME/.local/bin"

# Try downloading pre-built binary
EWW_URL="https://github.com/elkowar/eww/releases/download/v${EWW_VERSION}/eww-x86_64-unknown-linux-gnu"
if wget -q --timeout=30 "$EWW_URL" -O "$EWW_BIN" 2>/dev/null; then
    chmod +x "$EWW_BIN"
    ok "eww binary installed at $EWW_BIN"
else
    warn "eww download failed — will need manual install (see README)"
    warn "Run: cargo install eww  OR  download from github.com/elkowar/eww/releases"
fi

# Make sure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    log "Added ~/.local/bin to PATH in .bashrc"
fi

# ============================================================
# STEP 10: Extra terminal utilities used in scripts
# ============================================================
log "Installing helper utilities..."
sudo apt install -y \
    cmatrix \
    figlet \
    toilet \
    brightnessctl \
    jq \
    feh \
    xdotool \
    || die "helper utilities install failed"
ok "Helper utilities installed"

# ============================================================
# STEP 11: lm-sensors setup
# ============================================================
log "Detecting hardware sensors..."
sudo sensors-detect --auto > /dev/null 2>&1 || warn "sensors-detect failed — temps may not work until reboot"
ok "Sensors configured (reboot may be needed)"

# ============================================================
# STEP 12: Deploy config files
# ============================================================
log "Deploying eva-shell configs..."
mkdir -p "$CONFIG_DIR"

# Symlink the whole eva-shell config tree
ln -sfn "$EVA_DIR/themes"  "$CONFIG_DIR/themes"
ln -sfn "$EVA_DIR/scripts" "$CONFIG_DIR/scripts"
ln -sfn "$EVA_DIR/config"  "$CONFIG_DIR/config"

# i3
mkdir -p "$HOME/.config/i3"
ln -sfn "$EVA_DIR/config/i3/config" "$HOME/.config/i3/config"

# kitty
mkdir -p "$HOME/.config/kitty"
ln -sfn "$EVA_DIR/config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# polybar
mkdir -p "$HOME/.config/polybar"
ln -sfn "$EVA_DIR/config/polybar/config.ini" "$HOME/.config/polybar/config.ini"

# rofi
mkdir -p "$HOME/.config/rofi"
ln -sfn "$EVA_DIR/config/rofi/eva.rasi" "$HOME/.config/rofi/config.rasi"

# ranger
mkdir -p "$HOME/.config/ranger"
ln -sfn "$EVA_DIR/config/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
ln -sfn "$EVA_DIR/config/ranger/colorscheme.py" "$HOME/.config/ranger/colorscheme.py"

ok "Config files symlinked"

# ============================================================
# STEP 13: Make all scripts executable
# ============================================================
chmod +x "$EVA_DIR/scripts/"*.sh
ok "Scripts marked executable"

# ============================================================
# STEP 14: Register i3 as a login session
# ============================================================
log "Checking i3 display manager entry..."
if [ -f /usr/share/xsessions/i3.desktop ]; then
    ok "i3 session already registered with display manager"
else
    warn "i3.desktop not found — creating..."
    sudo bash -c 'cat > /usr/share/xsessions/i3-eva.desktop << EOF
[Desktop Entry]
Name=i3 (EVA-SHELL)
Comment=NERV Tactical Interface
Exec=i3
Type=Application
EOF'
    ok "i3 session registered"
fi

# ============================================================
# DONE
# ============================================================
echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║   INSTALLATION COMPLETE              ║"
echo "  ║   MAGI SYNC: NOMINAL                 ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo -e "  Next steps:"
echo -e "  1. Run: ${CYAN}./scripts/apply-theme.sh eva-01${NC}"
echo -e "  2. Log out → select ${CYAN}i3 (EVA-SHELL)${NC} from login screen"
echo -e "  3. Log back in"
echo ""
warn "NOTE: Reboot recommended before first i3 login (sensors + font cache)"
echo ""
