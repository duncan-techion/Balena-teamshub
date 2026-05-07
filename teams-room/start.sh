#!/bin/bash
set -euo pipefail

export DISPLAY=:0
TEAMS_URL="${TEAMS_URL:-https://teams.microsoft.com/v2/}"
PROFILE_DIR="/data/profile"
XORG_STARTUP_DELAY="${XORG_STARTUP_DELAY:-3}"

mkdir -p "$PROFILE_DIR"

# Keep audio available for microphone and speaker access.
pulseaudio --start --exit-idle-time=-1 || true

cleanup() {
  if [[ -n "${CHROMIUM_PID:-}" ]]; then
    kill "$CHROMIUM_PID" >/dev/null 2>&1 || true
    wait "$CHROMIUM_PID" >/dev/null 2>&1 || true
  fi

  if [[ -n "${XINIT_PID:-}" ]]; then
    kill "$XINIT_PID" >/dev/null 2>&1 || true
    wait "$XINIT_PID" >/dev/null 2>&1 || true
  fi
}

trap 'cleanup; exit 0' INT TERM

while true; do
  # -s 0 and -dpms keep the attached display awake for kiosk operation.
  xinit /usr/bin/openbox-session -- /usr/bin/Xorg "$DISPLAY" -vt 7 -s 0 -dpms &
  XINIT_PID=$!

  # Delay is configurable because device startup time can vary.
  sleep "$XORG_STARTUP_DELAY"

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
    --password-store=basic &
  CHROMIUM_PID=$!
  set +e
  wait "$CHROMIUM_PID"
  CHROMIUM_EXIT_CODE=$?
  set -e
  if [[ $CHROMIUM_EXIT_CODE -ne 0 ]]; then
    echo "Chromium exited unexpectedly with status ${CHROMIUM_EXIT_CODE}" >&2
  fi

  cleanup
  unset XINIT_PID CHROMIUM_PID
  sleep 2
done
