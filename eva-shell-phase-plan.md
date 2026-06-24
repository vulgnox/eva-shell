# EVA-SHELL — PHASE EXECUTION PLAN

**Reference Target:** `nerv_magi_v3_exact_colors.html`  
**Current Status:** Phase 3 complete (layout skeleton + theme engine working)  
**Current Commit:** `e8bf923` (SCSS GTK3 rewrite)  
**Next Focus:** Phase 4–10 (visual completeness + companion scripts)

---

## CURRENT STATE (WORKING)

✅ Three-column HUD layout (left/center/right) with correct geometry  
✅ Bottom 4-cell panel (HOME_DIR, KEYBOARD_SENSOR, MAGI_SYS_STATUS, HOTKEYS)  
✅ MAGI units (MELCHIOR, BALTHASAR, CASPAR) with colored bars  
✅ Consensus dots + system status display  
✅ Network intercept bars (RX/TX)  
✅ System logs and process tree (basic)  
✅ ASCII art rendering  
✅ GTK3-compatible SCSS (all properties flat, no nesting)  
✅ Color palette matches HTML reference exactly

---

## PHASE 4: TOP BAR IMPLEMENTATION

**Goal:** Add persistent header bar with NERV/MAGI info.

### Tasks
1. Create `eww/magi-topbar.yxi` window definition
   - Fixed height: 16px
   - Borders: `#ec7420` (orange) 1px bottom
   - Three text sections: left (NERV info), center (DANANG TYPE-B), right (timestamp)
   - Use `monitoring_text` from melchior.sh for live updates

2. Update `config/eww/eww.yxi` to register `magi-topbar` window
   - Geometry: x=0, y=0, width=100%, height=16px
   - `anchor="top"` (sticky to top)
   - `stacking="above"` (above everything except center canvas)

3. Add CSS classes to eww.scss
   - `.topbar` — flex container, space-between layout
   - `.tb.or`, `.tb.gr`, `.tb.dim` — color variants

4. Update i3 config to exclude topbar from tiling
   - Mark as `[class="eww" title="magi-topbar"] floating enable`

### Acceptance Criteria
- [ ] Top bar visible at 16px height with orange bottom border
- [ ] Three text sections rendered with correct colors
- [ ] Updates in real-time (timestamp refreshes every 1s)
- [ ] No overlap with center canvas
- [ ] Survives i3 reload without flickering

---

## PHASE 5: LEFT FLANK REFINEMENT

**Goal:** Enhanced system log stream + process tree with proper formatting.

### Tasks
1. Create `scripts/log-stream.sh`
   - Tail `journalctl` with 20-line rolling buffer
   - Color code by level: `[OK]` green, `[WRN]` yellow, `[ERR]` red, `[NET]` teal, `[KRN]` blue
   - Parse boot time, module loads, network events, thermal warnings
   - Output format: `[TAG] message` (fixed-width labels)

2. Create `scripts/process-tree.sh`
   - Use `ps` or `top` to get top 8 processes by CPU
   - Format: `LABEL | proc_name | CPU% | MEM%` with bar visualization
   - Update every 2 seconds

3. Create `eww/magi-left.yxi` with dual-scroll layout
   - Top 60%: log stream (scrollable)
   - Bottom 40%: process tree (scrollable)
   - Section headers: `SYS_LOG_STREAM` (green) + `PROC_TREE` (orange)

4. Update eww.scss
   - `.log-container`, `.log-text` — font-size 6px, line-height 1.55
   - `.proc-row`, `.proc-bar-bg`, `.proc-bar-fill` — bar styling (3px height)

### Acceptance Criteria
- [ ] Log stream updates in real-time (no lag)
- [ ] Process tree refreshes every 2s
- [ ] All color codes match HTML reference
- [ ] Scrollable within 280px width (left flank)
- [ ] No overlap with center or right panels

---

## PHASE 6: RIGHT FLANK ENHANCEMENTS

**Goal:** ASCII art loop + NET_INTERCEPT + MAGI_DIAG + SYS_CONTROLS refined.

### Tasks
1. Update `scripts/ascii-loop.sh`
   - EVA UNIT-01 ASCII art (5 lines, centered)
   - Percentage display below (from `cpu-freq-scaling`)
   - Cycle through 3–4 frames if animation desired
   - Update every 3s

2. Create `scripts/net-stats.sh`
   - Parse `ss -s` or `ifstat` for RX/TX on `wlo1`
   - Output: `RX:XXX TX:XXX` (human-readable: 1.2M, 340K, etc.)
   - Calculate percentage bars (0–100% scale)
   - Update every 1s

3. Create `scripts/magi-diag.sh`
   - MELCHIOR: CPU usage (via `/proc/stat`)
   - BALTHASAR: RAM usage (via `/proc/meminfo`)
   - CASPAR: Temperature (via `/sys/class/thermal/thermal_zone0/temp`)
   - Output: `MEL_CPU:72 BAL_RAM:45 CAS_TEMP:62`
   - Update every 1s

4. Create `eww/magi-right.yxi`
   - 5 sections: ASCII_RENDER, NET_INTERCEPT, MAGI_DIAG, SYS_CONTROLS, padding
   - Section headers: all `.slbl` styled
   - Use simple progress bars (CSS `::after` or simple rect divs)

5. Update eww.scss
   - `.net-label`, `.net-val` — 9px font
   - `.diag-item`, `.diag-label`, `.diag-bar` — border-left colored per unit
   - `.ctrl-row`, `.ctrl-dot`, `.ctrl-val` — control status dots + labels

### Acceptance Criteria
- [ ] ASCII art displays centered, cycles smoothly
- [ ] NET_INTERCEPT bars update every 1s, match HTML layout
- [ ] MAGI_DIAG shows CPU/RAM/Temp with correct colors + percentages
- [ ] SYS_CONTROLS (Wi-Fi/Bluetooth/Audio/Battery) display with status dots
- [ ] All within 280px right flank width
- [ ] No lag or flickering

---

## PHASE 7: CENTER CANVAS — MAGI RING SVG

**Goal:** Implement the centerpiece MAGI visualization — three hexagon + ring diagram.

### Tasks
1. Create `scripts/magi-ring.sh`
   - Generate SVG dynamically with live data:
     - MELCHIOR hex (blue #5090c8) — top left
     - BALTHASAR hex (orange #ec7420) — top right
     - CASPAR hex (teal #60f0a0) — bottom center
     - Center diamond (MAGI 01)
     - Dashed connector lines (yellow between MEL-BAL, blue MEL-center, orange BAL-center, teal CAS-center)
     - 6 blips on outer ring (colors: green, orange, blue, yellow, teal, red)
     - "TIME SINCE RAISED" box (bottom right) with live timer
   - Output: raw SVG code
   - Update every 1s

2. Create `eww/magi-center.yxi`
   - Top section: SVG from `magi-ring.sh` (centered, max-height 120px)
   - Bottom section: grid with 2 columns
     - Left: workspace indicator + window list (WS:1 ACTIVE, kitty, btop, etc.)
     - Right: MELCHIOR LLM output box (system analysis text + blinking cursor)

3. Write SVG precisely matching HTML reference
   - All coordinates hardcoded to 300×150 viewBox
   - Colors exact match (no interpolation)
   - Fonts: monospace, 5–9px sizes

4. Update eww.scss
   - `.magi-ring-wrap` — flex center, 100% width, height auto
   - `.llm-box` — border #5090c8, padding 3px
   - `.llm-label`, `.llm-text` — fonts + colors exact
   - `.consensus` — 3 dots with status colors
   - `.wsl` — workspace list items (active = green, inactive = dim)

### Acceptance Criteria
- [ ] SVG renders at correct size (300×150 or scaled to fit center)
- [ ] All 3 hexagons visible with correct colors + labels
- [ ] Center diamond labeled "MAGI 01"
- [ ] Dashed connectors match HTML exactly
- [ ] Blips animate or update color state
- [ ] "TIME SINCE RAISED" timer counts up from boot
- [ ] Workspace grid below SVG shows active workspace
- [ ] MELCHIOR output box with blinking cursor updates every 5s
- [ ] Consensus dots (MEL, BAL, CAS) all green by default

---

## PHASE 8: CENTER CANVAS — WORKSPACE + LLM OUTPUT

**Goal:** Live workspace switching indicator + MELCHIOR system analysis.

### Tasks
1. Create `scripts/ws-monitor.sh`
   - Listen to `i3-msg` events (window focus changes)
   - Output: `WS:N ACTIVE | WINDOW_NAME | WINDOW_CLASS`
   - List all windows on active workspace
   - Update immediately on event (no polling)

2. Update `scripts/melchior.sh`
   - Hook into Ollama llama3.2:1b
   - System prompt: "You are MELCHIOR, the CEREBRUM of NERV's MAGI supercomputer. Analyze the following system metrics and provide a brief, tactical assessment in 1–2 sentences. Be concise and focus on anomalies or risks."
   - Input: CPU%, RAM%, Temp, Disk%, Uptime, Network stats
   - Output: single paragraph of analysis text
   - Include cursor blink animation in eww (via `animation:blink 1s infinite`)
   - Update every 5s

3. Update `eww/magi-center.yxi`
   - Center-bottom grid layout (2 cols)
   - **Left cell:** WS:N indicator
     - Title: `WS:1 — ACTIVE` (or WS:2, WS:3)
     - List of open windows with status dots
     - Dot colors: green if focused, dim otherwise
   - **Right cell:** MELCHIOR analysis
     - Title: `MELCHIOR // LLM ANALYSIS` (blue)
     - Timestamp from melchior.sh execution
     - Analysis text (teal) with blinking cursor at end

### Acceptance Criteria
- [ ] Workspace indicator updates immediately when switching workspaces
- [ ] Window list shows all open windows on active WS
- [ ] MELCHIOR text updates every 5s
- [ ] Cursor blinks in MELCHIOR box (1s cycle)
- [ ] Consensus dots update based on system health (green OK, yellow WARN, red CRIT)
- [ ] Layout matches HTML exactly (2-column grid)

---

## PHASE 9: BOTTOM PANEL REFINEMENT

**Goal:** Complete bottom 4-cell layout with all live data.

### Tasks
1. Update `scripts/home-dir.sh`
   - List home directory with tree format
   - Color by type: dir (teal), file (dim), special (green: `.bashrc`, `.gitconfig`, etc.)
   - Indent with `▶` indicators
   - Limit to 5–7 top-level entries

2. Update `scripts/keyboard-sensor.sh`
   - Hook into `xev` or similar to monitor keypresses
   - Display 9×2 grid of key states
   - Key names: SPC, RET, BSP, CTL, ALT, SFT, TAB, ESC, F1 | K1–K9
   - Border color: green if pressed recently, orange if hotkey, dim otherwise
   - Show LAST key + COUNT + RATE (keys/sec)

3. Update `scripts/magi-sysstat.sh`
   - 6 metric grid:
     - CORE_SYNC (consensus %) — bright green if 100%, yellow if <95%
     - VBAR_SAT (memory saturation %) — blue or yellow
     - THERMAL (temp in °C) — yellow warn or red crit threshold
     - UPTIME (hours:minutes) — green
     - DISK (usage %) — green if <80%, yellow if <95%
     - LLM (LIVE or DOWN) — green if LIVE
   - Update every 2s

4. Create `eww/magi-bottom.yxi`
   - Grid layout (4 cols, equal width)
   - Cell 1: HOME_DIRECTORY section
   - Cell 2: KEYBOARD_SENSOR grid
   - Cell 3: MAGI_SYS_STATUS grid (2×3)
   - Cell 4: HOTKEYS text

5. Update eww.scss
   - `.bottom-cell` — padding 4px 6px, border-right (except last)
   - `.kbd` — grid 9 cols, 8px height
   - `.kk` — key squares (dim border normally, green if on, orange if hotkey)
   - `.sg` — 2-col grid for stats
   - `.ri` — ranger/file items (6px, color by type)

### Acceptance Criteria
- [ ] HOME_DIRECTORY tree displays 5+ items with proper colors
- [ ] KEYBOARD_SENSOR 9×2 grid shows all key states
- [ ] Key presses detected in real-time (no lag)
- [ ] MAGI_SYS_STATUS shows 6 metrics with correct colors
- [ ] Metrics update every 2s
- [ ] HOTKEYS section shows correct key bindings
- [ ] All 4 cells fit within bottom panel height (96px)
- [ ] No text overflow

---

## PHASE 10: INTEGRATION + POLISH

**Goal:** Boot sequence, edge cases, performance tuning.

### Tasks
1. Create `scripts/boot-sequence.sh`
   - Runs on i3 session start
   - Launch sequence:
     1. Start picom compositor
     2. Start Ollama (if not running) for melchior.sh
     3. Launch all eww windows (topbar, left, right, bottom, center)
     4. Verify all windows rendered (poll eww window list)
     5. Wait 2s, then start live update loops
     6. Log to `~/.eva-shell/boot.log`
   - Timeout: 10s max, fail gracefully

2. Create systemd user timer (optional)
   - Auto-restart eva-shell on crash
   - Log to journalctl

3. Update i3 config
   - Exec `~/.eva-shell/scripts/boot-sequence.sh` on startup
   - Verify all window marks/titles
   - Test workspace switching, app launching

4. Create `config/i3/i3-rules.conf`
   - Floating rules for all eww windows
   - No tiling, no focus stealing
   - Set stacking levels (below/above/normal)

5. Performance tuning
   - Profile all update loops (target: <10% CPU each)
   - Batch updates where possible (e.g., all net stats together)
   - Cache eww renders between updates
   - Reduce redraw frequency if needed

6. Documentation
   - Update README with architecture diagram
   - Troubleshooting guide (panel flickering, missing fonts, etc.)
   - Hotkey reference
   - Theme customization guide

### Acceptance Criteria
- [ ] Boot sequence completes in <10s
- [ ] All panels present and visible after boot
- [ ] No panel overlap or flickering
- [ ] All update loops stable (no crashes over 1hr runtime)
- [ ] CPU usage <20% total (all scripts combined)
- [ ] Memory usage <150MB (all eww windows)
- [ ] README complete with architecture + troubleshooting
- [ ] Theme customization documented

---

## DELIVERABLES

By end of Phase 10:

1. **Visual**
   - Screenshot matches `nerv_magi_v3_exact_colors.html` exactly
   - All panels rendered, no overlaps, smooth updates

2. **Code**
   - All 10+ companion scripts complete and tested
   - eww config fully documented (config/eww/eww.yxi + eww.scss)
   - i3 config finalized (config/i3/config)
   - Boot sequence reliable

3. **Documentation**
   - README: architecture, phases, hotkeys, troubleshooting
   - INSTALL.md: step-by-step Ubuntu 24.04 setup
   - THEME.md: how to create custom themes
   - SCRIPTS.md: what each script does, update frequencies

4. **Repository**
   - All changes committed and pushed
   - Main branch stable and documented
   - Tags for each phase milestone

---

## DEVIN AI INSTRUCTIONS

**You are tasked with executing Phases 4–10 systematically.**

1. **Read this entire plan** before starting any code.
2. **One phase per commit.** Each phase is a logical unit.
3. **Test before committing:**
   - Visual checks (screenshot vs HTML reference)
   - Functional checks (update frequency, no crashes, no lag)
   - Edge cases (workspace switching, panel resize, boot failure)
4. **Reference the HTML** (`nerv_magi_v3_exact_colors.html`) for exact styling.
5. **Use the exact color codes** from the HTML (no rounding, no approximations).
6. **Commit messages:** Follow the pattern `phase(4): [description]` or `feat: [description]`.
7. **When stuck,** ask the user for clarification before proceeding.

**Priority order:**
- Phase 4: Top bar (quick win, unblocks other phases)
- Phase 7: MAGI ring SVG (visual centerpiece)
- Phase 5 & 6: Left/right flanks (data streams)
- Phase 8: Workspace + LLM (core interactivity)
- Phase 9: Bottom panel (polish)
- Phase 10: Boot + integration (stability)

Good luck. NERV is counting on you. ◈