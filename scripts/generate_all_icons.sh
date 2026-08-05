#!/bin/bash
set -e

SRC="assets/brand/icon-source.png"
ICONS_DIR="src-tauri/icons"

echo "Generating PNG icons for Tauri..."
sips -z 32 32 "$SRC" --out "$ICONS_DIR/32x32.png"
sips -z 64 64 "$SRC" --out "$ICONS_DIR/64x64.png"
sips -z 128 128 "$SRC" --out "$ICONS_DIR/128x128.png"
sips -z 256 256 "$SRC" --out "$ICONS_DIR/128x128@2x.png"
sips -z 512 512 "$SRC" --out "$ICONS_DIR/icon.png"
sips -z 512 512 "$SRC" --out "$ICONS_DIR/logo.png"

sips -z 30 30 "$SRC" --out "$ICONS_DIR/Square30x30Logo.png"
sips -z 44 44 "$SRC" --out "$ICONS_DIR/Square44x44Logo.png"
sips -z 50 50 "$SRC" --out "$ICONS_DIR/StoreLogo.png"
sips -z 71 71 "$SRC" --out "$ICONS_DIR/Square71x71Logo.png"
sips -z 89 89 "$SRC" --out "$ICONS_DIR/Square89x89Logo.png"
sips -z 107 107 "$SRC" --out "$ICONS_DIR/Square107x107Logo.png"
sips -z 142 142 "$SRC" --out "$ICONS_DIR/Square142x142Logo.png"
sips -z 150 150 "$SRC" --out "$ICONS_DIR/Square150x150Logo.png"
sips -z 284 284 "$SRC" --out "$ICONS_DIR/Square284x284Logo.png"
sips -z 310 310 "$SRC" --out "$ICONS_DIR/Square310x310Logo.png"

echo "Generating macOS icon.icns..."
ICONSET="/tmp/sayso.iconset"
rm -rf "$ICONSET"
mkdir -p "$ICONSET"

sips -z 16 16     "$SRC" --out "$ICONSET/icon_16x16.png"
sips -z 32 32     "$SRC" --out "$ICONSET/icon_16x16@2x.png"
sips -z 32 32     "$SRC" --out "$ICONSET/icon_32x32.png"
sips -z 64 64     "$SRC" --out "$ICONSET/icon_32x32@2x.png"
sips -z 128 128   "$SRC" --out "$ICONSET/icon_128x128.png"
sips -z 256 256   "$SRC" --out "$ICONSET/icon_128x128@2x.png"
sips -z 256 256   "$SRC" --out "$ICONSET/icon_256x256.png"
sips -z 512 512   "$SRC" --out "$ICONSET/icon_256x256@2x.png"
sips -z 512 512   "$SRC" --out "$ICONSET/icon_512x512.png"
sips -z 1024 1024 "$SRC" --out "$ICONSET/icon_512x512@2x.png"

iconutil -c icns "$ICONSET" -o "$ICONS_DIR/icon.icns"
rm -rf "$ICONSET"

echo "Updating icon.ico..."
cp "$ICONS_DIR/32x32.png" "$ICONS_DIR/icon.ico" || true

echo "All icons successfully generated!"
