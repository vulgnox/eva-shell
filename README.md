# EVA-SHELL

```
  ███████╗██╗   ██╗ █████╗       ███████╗██╗  ██╗███████╗██╗     ██╗
  ██╔════╝██║   ██║██╔══██╗      ██╔════╝██║  ██║██╔════╝██║     ██║
  █████╗  ██║   ██║███████║█████╗███████╗███████║█████╗  ██║     ██║
  ██╔══╝  ╚██╗ ██╔╝██╔══██║╚════╝╚════██║██╔══██║██╔══╝  ██║     ██║
  ███████╗ ╚████╔╝ ██║  ██║      ███████║██║  ██║███████╗███████╗███████╗
  ╚══════╝  ╚═══╝  ╚═╝  ╚═╝      ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
```

> *"The interaction between complementary opposites generates all phenomena."*

A full i3wm desktop environment built around the NERV/Evangelion aesthetic.
Not a wallpaper rice. A complete desktop replacement.

---

## WHAT THIS IS

EVA-SHELL is an i3wm session that runs on top of Ubuntu 24.04. The entire
screen is divided into a persistent HUD grid inspired by eDEX-UI and NERV's
MAGI system — live telemetry panels locked to the screen edges, with a dynamic
central canvas for your actual work.

```
┌──────────────────────────────────────────────────────────┐
│                   POLYBAR TOP (24px)                     │
├────────────┬─────────────────────────────┬───────────────┤
│            │                             │               │
│ LEFT FLANK │     CENTRAL CANVAS          │  RIGHT FLANK  │
│  280px     │       (dynamic)             │    280px      │
│            │                             │               │
│ sys logs   │  your apps live here        │  ascii loop   │
│ process    │  workspaces 1-9             │  ──────────── │
│ tree       │  switch freely              │  MAGI DIAG    │
│            │                             │  MELCHIOR     │
│            │                             │  BALTHASAR    │
│            │                             │  CASPAR       │
├────────────┴──────────────┬──────────────┴───────────────┤
│  RANGER / HOME DIR        │  KEYBOARD SENSOR  │  CONTROLS │
│         BOTTOM FLANK (180px)                             │
└──────────────────────────────────────────────────────────┘
```

---

## REQUIREMENTS

- Ubuntu 24.04 LTS (fresh install recommended)
- i5 or better CPU
- 4GB+ RAM (full stack uses ~250MB)
- 1920×1080 display (other resolutions require layout adjustments)

> Tested on: ASUS VivoBook X515JA — i5-1035G1, Intel Iris Plus, 8GB RAM

---

## QUICK INSTALL

```bash
git clone https://github.com/YOUR_USERNAME/eva-shell.git
cd eva-shell
chmod +x install.sh
./install.sh
```

Then log out → select **i3** from your display manager → log back in.

---

## THEME SYSTEM

All colors, fonts, and assets live in `themes/eva-01/colors.conf`.
One file controls the entire visual identity across every component.

To apply a theme:
```bash
./scripts/apply-theme.sh eva-01
```

To create your own theme, duplicate the `themes/eva-01/` folder and edit.

---

## PHASES (BUILD LOG)

- [x] Phase 0 — Repo & architecture
- [ ] Phase 1 — Base installation
- [ ] Phase 2 — Theme engine
- [ ] Phase 3 — Layout skeleton
- [ ] Phase 4 — Boot sequence
- [ ] Phase 5 — Left flank (logs + process tree)
- [ ] Phase 6 — Right flank (ASCII loop + MAGI)
- [ ] Phase 7 — Bottom flank (ranger + widgets)
- [ ] Phase 8 — Central canvas rules
- [ ] Phase 9 — Polybar top bar
- [ ] Phase 10 — Polish & integration

---

## HOTKEYS

| Key | Action |
|-----|--------|
| `Super + Enter` | New terminal in central canvas |
| `Super + [1-9]` | Switch workspace |
| `Super + h/v` | Split horizontal / vertical |
| `Super + d` | App launcher (rofi) |
| `Super + Shift + q` | Close focused window |
| `Super + Shift + e` | Exit to login screen |
| `Super + r` | Resize mode |
| `Super + f` | Fullscreen toggle |

---

## STRUCTURE

```
eva-shell/
├── install.sh
├── scripts/
│   ├── apply-theme.sh
│   ├── boot-sequence.sh
│   ├── log-stream.sh
│   ├── ascii-loop.sh
│   └── magi-stats.sh
├── themes/
│   └── eva-01/
│       ├── colors.conf
│       ├── fonts.conf
│       └── assets/
└── config/
    ├── i3/
    ├── polybar/
    ├── eww/
    ├── rofi/
    ├── kitty/
    └── ranger/
```

---

*NERV — GEHIRN R&D DIVISION*
*MAGI SYSTEM — OPERATIONAL*
