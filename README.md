# EVA-SHELL

```
███████╗██╗   ██╗ █████╗       ███████╗██╗  ██╗███████╗██╗     ██╗
██╔════╝██║   ██║██╔══██╗      ██╔════╝██║  ██║██╔════╝██║     ██║
█████╗  ██║   ██║███████║█████╗███████╗███████║█████╗  ██║     ██║
██╔══╝  ╚██╗ ██╔╝██╔══██║╚════╝╚════██║██╔══██║██╔══╝  ██║     ██║
███████╗ ╚████╔╝ ██║  ██║      ███████║██║  ██║███████╗███████╗███████╗
╚══════╝  ╚═══╝  ╚═╝  ╚═╝      ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝

  N.E.R.V. MAGI SUPERCOMPUTER — OPERATING SYSTEM INTERFACE
  "The interaction between complementary opposites generates all phenomena."
```

---

## WHAT IS EVA-SHELL?

A **full i3wm desktop environment** built around the NERV/Evangelion aesthetic. Not a wallpaper rice — a complete, functional desktop replacement with:

- **Three-column HUD layout** with persistent telemetry panels (left, center, right)
- **MAGI supercomputer visualization** — three hexagon units (MELCHIOR, BALTHASAR, CASPAR) with live system metrics
- **Real-time data streams** — logs, process trees, network stats, system analysis
- **Workspace switcher + LLM analysis** — MELCHIOR (Ollama llama3.2) provides tactical system assessments
- **Bottom panel** — file directory, keyboard sensor, system status, hotkeys
- **Theme engine** — single `themes/eva-01/colors.conf` controls entire visual identity

Built on **Ubuntu 24.04 LTS** with **i3-gaps**, **eww** (widget toolkit), **picom** (compositor), **kitty** (terminal), **Ollama** (local LLM).

### Visual Target

Exact reference: [`nerv_magi_v3_exact_colors.html`](https://github.com/vulgnox/eva-shell/blob/main/nerv_magi_v3_exact_colors.html)

---

## CURRENT STATUS (June 2026)

**Phase:** 3/10 (Layout Skeleton + Theme Engine)  
**Latest Commit:** `e8bf923` — SCSS rewrite for GTK3 compatibility

### ✅ WORKING NOW

- Three-column layout (280px left, dynamic center, 280px right)
- Bottom 4-cell panel (96px height)
- MAGI units rendered with colored progress bars
- System logs + process tree (basic)
- Network intercept bars (RX/TX)
- ASCII art section
- Consensus status indicators
- GTK3-compatible SCSS (all flat CSS, no nesting)
- Color palette matches HTML reference exactly

### 🔄 IN PROGRESS / BLOCKED

- MAGI ring SVG (hexagon diagram centerpiece) — *needs eww SVG rendering*
- Top bar implementation — *pending Phase 4*
- Workspace indicator — *needs i3 event listener*
- MELCHIOR LLM output — *system prompt needs tuning*
- Full companion scripts (log-stream.sh, process-tree.sh, etc.)

### 📋 TODO (Phases 4–10)

See **[PHASE PLAN](eva-shell-phase-plan.md)** for detailed breakdown.

---

## ARCHITECTURE

```
┌─────────────────────────────────────────────────────────────────┐
│  TOP BAR (16px) — NERV info + timestamp (Phase 4)               │
├─────────────────┬───────────────────────┬───────────────────────┤
│   LEFT FLANK    │     CENTER CANVAS     │    RIGHT FLANK        │
│    280px        │    (dynamic width)    │       280px           │
│                 │                       │                       │
│ • SYS_LOG       │  • MAGI RING (SVG)    │  • ASCII_RENDER       │
│   (Phase 5)     │  • Workspace indicator│  • NET_INTERCEPT      │
│ • PROC_TREE     │  • MELCHIOR LLM box   │  • MAGI_DIAG          │
│                 │    (Phase 8)          │  • SYS_CONTROLS       │
│                 │                       │    (Phase 6)          │
├─────────────────┴───────────────────────┴───────────────────────┤
│  BOTTOM PANEL (96px) — 4-cell grid (Phase 9)                    │
│  • HOME_DIRECTORY | KEYBOARD_SENSOR | MAGI_SYS_STATUS | HOTKEYS│
└──────────────────────────────────────────────────────────────────┘
```

### Stack

| Layer | Component | Role |
|-------|-----------|------|
| **Display** | i3-gaps + picom | Window management + compositing |
| **Widgets** | eww (built from source) | Real-time HUD panels |
| **Styling** | SCSS (GTK3 CSS) | Theme engine + layout |
| **Terminal** | kitty | Central canvas + work area |
| **Scripts** | bash (10+ helpers) | Data collection + updates |
| **LLM** | Ollama llama3.2:1b | MELCHIOR system analysis |
| **Data** | /proc, /sys, journalctl | System metrics |

---

## REQUIREMENTS

- **OS:** Ubuntu 24.04 LTS (fresh install recommended)
- **CPU:** i5 or better (tested on i5-1035G1)
- **RAM:** 4GB+ (full stack uses ~250MB)
- **GPU:** Intel iGPU or better (VAAPI acceleration recommended)
- **Display:** 1920×1080 @ 60Hz (other resolutions need layout adjustments)
- **Internet:** Required initially (downloads: i3, eww, picom, kitty, ollama, fonts)

### Build Dependencies (apt)

```bash
apt install -y \
  i3-wm i3-gaps \
  picom \
  kitty \
  rofi \
  ranger \
  rustc cargo \
  libdbusmenu-gtk3-dev libgtk-3-dev libglib2.0-dev \
  fontconfig \
  git curl
```

### Runtime Dependencies

- `ollama` (https://ollama.ai) — download + `ollama pull llama3.2:1b`
- **Fonts:** JetBrains Mono (monospace), Courier New (fallback)
- **Colors:** 256-color terminal minimum

---

## QUICK START

### 1. Clone Repository

```bash
git clone https://github.com/vulgnox/eva-shell.git
cd eva-shell
chmod +x install.sh scripts/*.sh
```

### 2. Install

```bash
./install.sh
```

This will:
- Install system dependencies (apt)
- Build eww from source
- Copy config files to `~/.config/eva-shell/` (symlinked from repo)
- Set up systemd user service for OpenHuman (if installed)
- Create boot script

### 3. Start i3 Session

Log out → select **i3** from GNOME login screen → log back in.

Or manually:

```bash
startx -- i3
```

### 4. Boot Sequence

On login, `~/.eva-shell/scripts/boot-sequence.sh` runs:
1. Start picom compositor
2. Start Ollama (if installed)
3. Launch eww windows (topbar, left, right, bottom, center)
4. Begin live update loops

**Check status:**

```bash
eww windows                    # list all eww windows
tail -f ~/.eva-shell/boot.log  # boot sequence log
journalctl -u eww --user -f    # eww errors
```

---

## HOTKEYS

| Binding | Action |
|---------|--------|
| `Super + Enter` | New terminal in central canvas |
| `Super + [1-9]` | Switch workspace |
| `Super + h` / `Super + v` | Split horizontal / vertical |
| `Super + d` | App launcher (rofi) |
| `Super + f` | Fullscreen toggle |
| `Super + r` | Resize mode |
| `Super + Shift + q` | Close focused window |
| `Super + Shift + e` | Exit i3 to login screen |

---

## THEME SYSTEM

All colors, fonts, and visual constants live in **one file:**

```
themes/eva-01/colors.conf
```

To apply a theme:

```bash
./scripts/apply-theme.sh eva-01
```

To create your own:

```bash
cp -r themes/eva-01 themes/my-theme
# edit themes/my-theme/colors.conf
./scripts/apply-theme.sh my-theme
```

Each theme file contains:

```bash
# Colors
COLOR_BG="#000000"
COLOR_ORANGE="#ec7420"
COLOR_GREEN="#60f0a0"
COLOR_BLUE="#5090c8"
# ... etc

# Fonts
FONT_MONO="JetBrains Mono"
FONT_SIZE_BASE=10
```

Propagates to:
- `config/eww/eww.scss` (variables)
- `config/i3/config` (bar + window colors)
- `config/kitty/kitty.conf` (terminal)
- `config/rofi/config.rasi` (launcher)

---

## PHASES (ROADMAP)

| Phase | Status | Focus | ETA |
|-------|--------|-------|-----|
| 0 | ✅ Done | Repo + architecture | — |
| 1 | ✅ Done | Base installation | — |
| 2 | ✅ Done | Theme engine | — |
| 3 | ✅ Done | Layout skeleton + GTK3 SCSS | — |
| **4** | 🔄 Next | Top bar (NERV header) | P0 |
| **5** | ⏳ Queued | Left flank (logs + procs) | P1 |
| **6** | ⏳ Queued | Right flank (ASCII + net + controls) | P1 |
| **7** | ⏳ Queued | MAGI ring SVG (hexagons + ring) | **P0** |
| **8** | ⏳ Queued | Workspace + MELCHIOR LLM | P1 |
| **9** | ⏳ Queued | Bottom panel (keyboard + status) | P2 |
| **10** | ⏳ Queued | Boot sequence + polish | P3 |

**See [PHASE PLAN](eva-shell-phase-plan.md) for detailed tasks.**

---

## FOLDER STRUCTURE

```
eva-shell/
├── install.sh                 # Main installation script
├── README.md                  # This file
├── eva-shell-phase-plan.md    # Detailed phase breakdown for Devin AI
│
├── config/
│   ├── i3/
│   │   ├── config             # i3 window manager config
│   │   └── i3-rules.conf      # Floating rules, window marks (Phase 10)
│   ├── eww/
│   │   ├── eww.yxi            # eww windows (topbar, left, right, bottom, center)
│   │   └── eww.scss           # All styling (GTK3 CSS)
│   ├── kitty/
│   │   └── kitty.conf         # Terminal colors + fonts
│   ├── rofi/
│   │   └── config.rasi        # App launcher styling
│   └── ranger/
│       └── rc.conf            # File manager config (unused, for reference)
│
├── scripts/
│   ├── boot-sequence.sh       # Runs on i3 start (Phase 10)
│   ├── apply-theme.sh         # Theme switcher
│   ├── log-stream.sh          # System log tail (Phase 5)
│   ├── process-tree.sh        # Top processes (Phase 5)
│   ├── ascii-loop.sh          # EVA ASCII art (Phase 6)
│   ├── net-stats.sh           # RX/TX network stats (Phase 6)
│   ├── magi-diag.sh           # CPU/RAM/Temp metrics (Phase 6)
│   ├── magi-ring.sh           # SVG hexagon diagram (Phase 7)
│   ├── ws-monitor.sh          # i3 workspace listener (Phase 8)
│   ├── melchior.sh            # Ollama LLM analysis (Phase 8)
│   ├── keyboard-sensor.sh     # Keypress listener (Phase 9)
│   ├── home-dir.sh            # Home directory tree (Phase 9)
│   ├── magi-sysstat.sh        # System status grid (Phase 9)
│   └── update-all.sh          # Batch update trigger
│
├── themes/
│   └── eva-01/
│       ├── colors.conf        # Color palette (single source of truth)
│       └── README.md          # Theme documentation
│
└── .continue/
    └── agents/                # Devin AI agent config (optional)
```

---

## DEBUGGING

### Panel Flickering

**Symptom:** eww windows flash or flicker on update.

**Causes:**
- Slow update loop (> 500ms)
- Race condition in i3 rendering
- stacking level conflict (`above` vs `normal`)

**Fixes:**
```bash
# Check eww performance
eww logs

# Increase batch update interval
# Edit scripts/update-all.sh, set INTERVAL=1000 (1s)

# Check i3 stacking
i3-msg 'floating enable; floating disable'
```

### Missing Fonts

**Symptom:** Fallback fonts (boxes or garbled text) instead of JetBrains Mono.

**Fix:**
```bash
apt install fonts-jetbrains-mono
fc-cache -fv
# Reload i3: Super + Shift + r
```

### Ollama Not Running

**Symptom:** MELCHIOR LLM box shows "ERROR" or blank.

**Fix:**
```bash
ollama serve &        # Start in background
ollama pull llama3.2  # Download model (~2GB)
curl http://localhost:11434/api/generate -d '{"model":"llama3.2:1b","prompt":"test"}' # Test

# If systemd, enable auto-start:
systemctl --user enable ollama
systemctl --user start ollama
```

### High CPU / Memory Usage

**Symptom:** eww or update scripts consuming > 20% CPU.

**Diagnosis:**
```bash
top -p $(pgrep eww)           # Check eww
ps aux | grep scripts         # Check scripts
```

**Fixes:**
- Reduce update frequency (increase INTERVAL in boot-sequence.sh)
- Batch updates: combine `magi-diag.sh` + `net-stats.sh` into single script
- Profile with `time` command: `time ./scripts/magi-diag.sh`

---

## CONTRIBUTING

Phases 4–10 are open for execution. See [PHASE PLAN](eva-shell-phase-plan.md).

**Process:**
1. Pick a phase (start with Phase 4)
2. Create feature branch: `git checkout -b phase(N)-description`
3. Execute tasks + test locally
4. Commit per phase: `git commit -m "phase(N): [description]"`
5. Push to GitHub

**Testing checklist before commit:**
- [ ] Visual matches HTML reference
- [ ] No panel overlap or flickering
- [ ] All update loops stable (1hr runtime test)
- [ ] CPU < 20%, Memory < 150MB
- [ ] Handles edge cases (workspace switch, app crash, boot failure)

---

## REFERENCES

- **HTML Visual Reference:** [`nerv_magi_v3_exact_colors.html`](https://github.com/vulgnox/eva-shell/blob/main/nerv_magi_v3_exact_colors.html)
- **i3 Manual:** https://i3wm.org/docs/
- **eww (Elkowars Wacky Widgets):** https://github.com/elkowar/eww
- **picom (Compositor):** https://github.com/yshui/picom
- **Ollama (LLM):** https://ollama.ai
- **Neon Genesis Evangelion:** https://en.wikipedia.org/wiki/Neon_Genesis_Evangelion

---

## LICENSE

This project is inspired by Neon Genesis Evangelion and uses the NERV/MAGI aesthetic for purely personal/non-commercial educational purposes.

Code is open source under MIT License.

---

**Status:** *Actively developed by Devin AI + manual review.*

**Next milestone:** Phase 4 (Top Bar) + Phase 7 (MAGI Ring SVG).

**Questions?** Open an issue or contact [@vulgnox](https://github.com/vulgnox).

---

**NERV — GEHIRN R&D DIVISION**  
**MAGI SYSTEM — OPERATIONAL**  
◈