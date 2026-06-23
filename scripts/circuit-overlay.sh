#!/bin/bash
# ============================================================
# EVA-SHELL — circuit-overlay.sh
# Animated SVG circuit border overlay via eww window
# Renders flowing circuit traces around screen edges
# ============================================================

# This generates an SVG that eww renders as a full-screen
# borderless transparent overlay window
# The SVG uses SMIL animations for the flowing trace effect

cat << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg"
     viewBox="0 0 1920 1080"
     style="position:fixed;top:0;left:0;width:100%;height:100%;pointer-events:none;">

  <defs>
    <!-- Flowing orange trace gradient -->
    <linearGradient id="trace-h" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%"   stop-color="#000000" stop-opacity="0"/>
      <stop offset="30%"  stop-color="#ec7420" stop-opacity="0.2"/>
      <stop offset="50%"  stop-color="#ff8c00" stop-opacity="0.8"/>
      <stop offset="70%"  stop-color="#ec7420" stop-opacity="0.2"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="trace-h-teal" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%"   stop-color="#000000" stop-opacity="0"/>
      <stop offset="40%"  stop-color="#60f0a0" stop-opacity="0.3"/>
      <stop offset="50%"  stop-color="#3cffd0" stop-opacity="0.9"/>
      <stop offset="60%"  stop-color="#60f0a0" stop-opacity="0.3"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="trace-v" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%"   stop-color="#000000" stop-opacity="0"/>
      <stop offset="30%"  stop-color="#ec7420" stop-opacity="0.2"/>
      <stop offset="50%"  stop-color="#ff8c00" stop-opacity="0.8"/>
      <stop offset="70%"  stop-color="#ec7420" stop-opacity="0.2"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="trace-v-blue" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%"   stop-color="#000000" stop-opacity="0"/>
      <stop offset="40%"  stop-color="#5090c8" stop-opacity="0.3"/>
      <stop offset="50%"  stop-color="#40c8e8" stop-opacity="0.9"/>
      <stop offset="60%"  stop-color="#5090c8" stop-opacity="0.3"/>
      <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
    </linearGradient>

    <!-- Glow filter -->
    <filter id="glow">
      <feGaussianBlur stdDeviation="2" result="blur"/>
      <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
    </filter>
    <filter id="glow-strong">
      <feGaussianBlur stdDeviation="4" result="blur"/>
      <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
    </filter>
  </defs>

  <!-- ======================================================
       STATIC CIRCUIT SKELETON — the permanent dim traces
       ====================================================== -->

  <!-- Top edge skeleton -->
  <line x1="0" y1="24" x2="1920" y2="24" stroke="#1a0d00" stroke-width="1"/>
  <!-- Bottom edge skeleton -->
  <line x1="0" y1="900" x2="1920" y2="900" stroke="#1a0d00" stroke-width="1"/>
  <!-- Left panel edge -->
  <line x1="280" y1="24" x2="280" y2="900" stroke="#0f0800" stroke-width="1"/>
  <!-- Right panel edge -->
  <line x1="1640" y1="24" x2="1640" y2="900" stroke="#0f0800" stroke-width="1"/>

  <!-- Corner bracket - top left -->
  <path d="M0,44 L0,24 L20,24" fill="none" stroke="#ec7420" stroke-width="1" opacity="0.6"/>
  <path d="M0,24 L8,24 M0,24 L0,32" fill="none" stroke="#ec7420" stroke-width="1.5"/>
  <!-- Corner bracket - top right -->
  <path d="M1920,44 L1920,24 L1900,24" fill="none" stroke="#ec7420" stroke-width="1" opacity="0.6"/>
  <path d="M1920,24 L1912,24 M1920,24 L1920,32" fill="none" stroke="#ec7420" stroke-width="1.5"/>
  <!-- Corner bracket - bottom left -->
  <path d="M0,880 L0,900 L20,900" fill="none" stroke="#ec7420" stroke-width="1" opacity="0.6"/>
  <!-- Corner bracket - bottom right -->
  <path d="M1920,880 L1920,900 L1900,900" fill="none" stroke="#ec7420" stroke-width="1" opacity="0.6"/>

  <!-- Panel junction nodes (where panels meet main area) -->
  <rect x="276" y="20" width="8" height="8" fill="none" stroke="#ec7420" stroke-width="0.8" opacity="0.5"/>
  <rect x="1636" y="20" width="8" height="8" fill="none" stroke="#ec7420" stroke-width="0.8" opacity="0.5"/>
  <rect x="276" y="896" width="8" height="8" fill="none" stroke="#60f0a0" stroke-width="0.8" opacity="0.5"/>
  <rect x="1636" y="896" width="8" height="8" fill="none" stroke="#60f0a0" stroke-width="0.8" opacity="0.5"/>

  <!-- Small circuit nodes along top -->
  <circle cx="480"  cy="24" r="2" fill="#1a0d00" stroke="#ec7420" stroke-width="0.5" opacity="0.4"/>
  <circle cx="960"  cy="24" r="2" fill="#1a0d00" stroke="#ec7420" stroke-width="0.5" opacity="0.4"/>
  <circle cx="1440" cy="24" r="2" fill="#1a0d00" stroke="#ec7420" stroke-width="0.5" opacity="0.4"/>

  <!-- Diagonal accent cuts on panel edges -->
  <path d="M268,24 L280,36" fill="none" stroke="#ec7420" stroke-width="0.7" opacity="0.3"/>
  <path d="M1640,24 L1652,36" fill="none" stroke="#ec7420" stroke-width="0.7" opacity="0.3"/>
  <path d="M268,900 L280,888" fill="none" stroke="#60f0a0" stroke-width="0.7" opacity="0.3"/>
  <path d="M1640,900 L1652,888" fill="none" stroke="#60f0a0" stroke-width="0.7" opacity="0.3"/>

  <!-- ======================================================
       ANIMATED TRACES — flowing pulses along edges
       ====================================================== -->

  <!-- TOP EDGE: orange pulse L→R -->
  <rect x="-300" y="22" width="300" height="2" fill="url(#trace-h)" filter="url(#glow)">
    <animateTransform attributeName="transform" type="translate"
      from="-300,0" to="2220,0" dur="4s" repeatCount="indefinite"/>
  </rect>

  <!-- TOP EDGE: teal pulse L→R (offset) -->
  <rect x="-300" y="22" width="200" height="2" fill="url(#trace-h-teal)" filter="url(#glow)">
    <animateTransform attributeName="transform" type="translate"
      from="-300,0" to="2220,0" dur="4s" begin="1.5s" repeatCount="indefinite"/>
  </rect>

  <!-- BOTTOM EDGE: orange pulse R→L -->
  <rect x="1920" y="899" width="300" height="2" fill="url(#trace-h)" filter="url(#glow)">
    <animateTransform attributeName="transform" type="translate"
      from="0,0" to="-2220,0" dur="5s" repeatCount="indefinite"/>
  </rect>

  <!-- BOTTOM EDGE: teal pulse R→L (offset) -->
  <rect x="1920" y="899" width="200" height="2" fill="url(#trace-h-teal)" filter="url(#glow)">
    <animateTransform attributeName="transform" type="translate"
      from="0,0" to="-2220,0" dur="5s" begin="2s" repeatCount="indefinite"/>
  </rect>

  <!-- LEFT PANEL EDGE: vertical orange pulse down -->
  <rect x="278" y="-200" width="2" height="200" fill="url(#trace-v)" filter="url(#glow)">
    <animateTransform attributeName="transform" type="translate"
      from="0,-200" to="0,1280" dur="3.5s" repeatCount="indefinite"/>
  </rect>

  <!-- LEFT PANEL EDGE: blue pulse up -->
  <rect x="278" y="1080" width="2" height="200" fill="url(#trace-v-blue)" filter="url(#glow)">
    <animateTransform attributeName="transform" type="translate"
      from="0,0" to="0,-1480" dur="4.5s" begin="1s" repeatCount="indefinite"/>
  </rect>

  <!-- RIGHT PANEL EDGE: vertical teal pulse down -->
  <rect x="1638" y="-200" width="2" height="200" fill="url(#trace-v)" filter="url(#glow)">
    <animateTransform attributeName="transform" type="translate"
      from="0,-200" to="0,1280" dur="3s" begin="0.8s" repeatCount="indefinite"/>
  </rect>

  <!-- RIGHT PANEL EDGE: blue pulse up -->
  <rect x="1638" y="1080" width="2" height="150" fill="url(#trace-v-blue)" filter="url(#glow)">
    <animateTransform attributeName="transform" type="translate"
      from="0,0" to="0,-1480" dur="5s" begin="2.5s" repeatCount="indefinite"/>
  </rect>

  <!-- BOTTOM FLANK TOP EDGE: separator pulse -->
  <rect x="-200" y="898" width="200" height="2" fill="url(#trace-h-teal)" filter="url(#glow)" opacity="0.5">
    <animateTransform attributeName="transform" type="translate"
      from="-200,0" to="2120,0" dur="6s" begin="0.5s" repeatCount="indefinite"/>
  </rect>

  <!-- ======================================================
       JUNCTION NODE PULSES
       ====================================================== -->

  <!-- Top-left junction pulse -->
  <circle cx="280" cy="24" r="3" fill="#ec7420" opacity="0">
    <animate attributeName="opacity" values="0;1;0" dur="4s" begin="0s" repeatCount="indefinite"/>
    <animate attributeName="r"       values="3;6;3" dur="4s" begin="0s" repeatCount="indefinite"/>
  </circle>

  <!-- Top-right junction pulse -->
  <circle cx="1640" cy="24" r="3" fill="#ec7420" opacity="0">
    <animate attributeName="opacity" values="0;1;0" dur="4s" begin="2s" repeatCount="indefinite"/>
    <animate attributeName="r"       values="3;6;3" dur="4s" begin="2s" repeatCount="indefinite"/>
  </circle>

  <!-- Bottom-left junction pulse -->
  <circle cx="280" cy="900" r="3" fill="#60f0a0" opacity="0">
    <animate attributeName="opacity" values="0;0.8;0" dur="5s" begin="1s" repeatCount="indefinite"/>
    <animate attributeName="r"       values="3;5;3"   dur="5s" begin="1s" repeatCount="indefinite"/>
  </circle>

  <!-- Bottom-right junction pulse -->
  <circle cx="1640" cy="900" r="3" fill="#60f0a0" opacity="0">
    <animate attributeName="opacity" values="0;0.8;0" dur="5s" begin="3s" repeatCount="indefinite"/>
    <animate attributeName="r"       values="3;5;3"   dur="5s" begin="3s" repeatCount="indefinite"/>
  </circle>

  <!-- Center-top blip -->
  <circle cx="960" cy="24" r="2" fill="#5090c8" opacity="0">
    <animate attributeName="opacity" values="0;1;0" dur="3s" begin="0.5s" repeatCount="indefinite"/>
  </circle>

</svg>
SVGEOF
