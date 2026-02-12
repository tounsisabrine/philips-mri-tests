#!/usr/bin/env bash
set -euo pipefail

# Wait for emulator device
adb wait-for-device || true
echo "Waiting for emulator to become online..."
for i in $(seq 1 120); do
  STATE=$(adb get-state 2>/dev/null || true)
  if [ "$STATE" = "device" ]; then
    echo "Device online!"
    break
  fi
  sleep 2
done

echo "Waiting for Android boot..."
for i in $(seq 1 240); do
  BOOT=$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r' || true)
  if [ "$BOOT" = "1" ]; then
    echo "Boot completed!"
    break
  fi
  sleep 2
done

echo "Emulator ready. Running tests..."
# Place additional test invocation here, e.g.:
# robot -d results tests/android
