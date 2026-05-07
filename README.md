# Balena-teamshub

A minimal balena setup for an **Intel NUC** that behaves like a Microsoft Teams Room-style kiosk:

- boots directly into Teams on a connected TV/display
- supports user sign-in with keyboard and mouse
- uses attached camera + microphone + speakers for meetings
- keeps browser session data persisted between restarts

## What's included

- `docker-compose.yml` for balena deployment
- `teams-room/` service that runs Chromium in kiosk mode against `https://teams.microsoft.com/v2/`

## Hardware requirements

- Intel NUC running balenaOS (Intel NUC device type)
- HDMI-connected TV/monitor
- USB keyboard and mouse
- USB camera and microphone/speaker device (or integrated AV hardware)

## Deploy

1. Create a balena application targeting your Intel NUC device type.
2. Add this repository to balena Cloud.
3. Flash balenaOS to your NUC and register the device to your app.
4. Deploy.

After boot, the device launches Teams in kiosk mode. Use keyboard/mouse to sign in and join meetings.

## Optional configuration

Set these environment variables in balena Cloud if needed:

- `TEAMS_URL` (default: `https://teams.microsoft.com/v2/`)
- `TZ` (default: `UTC`)
- `XORG_STARTUP_DELAY` (default: `3`)

## Security note

The service runs with `privileged: true` so Chromium/Xorg can access GPU, audio, camera, and USB input devices on the host.
