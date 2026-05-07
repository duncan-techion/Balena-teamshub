#!/bin/bash
set -euo pipefail

export DISPLAY=:0
TEAMS_URL="${TEAMS_URL:-https://teams.microsoft.com/v2/}"
PROFILE_DIR="/data/profile"

mkdir -p "$PROFILE_DIR"

# Keep audio available for microphone and speaker access.
pulseaudio --start --exit-idle-time=-1 || true

while true; do
  xinit /usr/bin/openbox-session -- /usr/bin/Xorg "$DISPLAY" vt01 -s 0 -dpms &
  XINIT_PID=$!

  # Allow Xorg to come up before launching Chromium.
  sleep 3

  chromium \
    --kiosk "$TEAMS_URL" \
    --start-maximized \
    --user-data-dir="$PROFILE_DIR" \
    --no-first-run \
    --no-default-browser-check \
    --autoplay-policy=no-user-gesture-required \
    --enable-features=WebRtcPipeWireCapturer \
    --use-gl=egl \
    --disable-session-crashed-bubble \
    --password-store=basic

  kill "$XINIT_PID" >/dev/null 2>&1 || true
  sleep 2
done
