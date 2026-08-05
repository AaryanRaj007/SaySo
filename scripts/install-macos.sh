#!/usr/bin/env bash
#
# Install the built SaySo.app into /Applications with a stable code signature.
#
# Why this exists:
#   macOS records Accessibility (and Input Monitoring) grants against an app's
#   code signature and path. Two things break that for a locally built app:
#
#     1. Running SaySo.app straight out of the .dmg. The mount point
#        (/Volumes/dmg.XXXXXX) is different on every mount, and the volume is
#        read-only, so the grant can never stick.
#     2. Ad-hoc signing ("signingIdentity": "-"). The designated requirement is
#        the cdhash, which changes on every rebuild, so an existing grant goes
#        stale. System Settings keeps showing the toggle ON while
#        AXIsProcessTrusted() returns false.
#
#   Signing with the "SaySo Local Dev" certificate pins the designated
#   requirement to the certificate leaf instead of the cdhash, so the grant
#   survives rebuilds. Installing to /Applications gives it a stable path.
#
# Usage:
#   ./scripts/install-macos.sh          # install + sign + launch
#   ./scripts/install-macos.sh --reset  # also clear the TCC grant first
#
set -euo pipefail

IDENTITY="SaySo Local Dev"
BUNDLE_ID="com.altn.sayso"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/src-tauri/target/release/bundle/macos/SaySo.app"
DEST="/Applications/SaySo.app"

if [[ ! -d "$SRC" ]]; then
  echo "error: $SRC not found. Run 'npm run tauri build' first." >&2
  exit 1
fi

if ! security find-identity -v -p codesigning | grep -q "$IDENTITY"; then
  echo "error: code signing identity '$IDENTITY' not found in your keychain." >&2
  echo "       Re-create it with ./scripts/create-signing-identity.sh" >&2
  exit 1
fi

echo "==> Quitting any running SaySo"
pkill -f "SaySo.app/Contents/MacOS/sayso" 2>/dev/null || true
sleep 1

# A SaySo.app running off a mounted .dmg can never hold a permission grant.
while read -r vol; do
  [[ -z "$vol" ]] && continue
  if [[ -d "$vol/SaySo.app" ]]; then
    echo "==> Ejecting stale SaySo disk image at $vol"
    hdiutil detach "$vol" -force >/dev/null 2>&1 || true
  fi
done < <(ls -d /Volumes/dmg.* 2>/dev/null || true)

echo "==> Installing to $DEST"
rm -rf "$DEST"
ditto "$SRC" "$DEST"
xattr -cr "$DEST"

echo "==> Signing with '$IDENTITY'"
codesign --force --options runtime \
  --entitlements "$REPO_ROOT/src-tauri/Entitlements.plist" \
  -s "$IDENTITY" --timestamp=none "$DEST"
codesign --verify --strict "$DEST"
codesign -d -r- "$DEST" 2>&1 | grep designated

if [[ "${1:-}" == "--reset" ]]; then
  echo "==> Resetting permission grants for $BUNDLE_ID"
  tccutil reset Accessibility "$BUNDLE_ID" || true
  tccutil reset ListenEvent "$BUNDLE_ID" || true
  tccutil reset Microphone "$BUNDLE_ID" || true
fi

echo "==> Launching"
open -a "$DEST"
echo "Done. SaySo is installed at $DEST"
