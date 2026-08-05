const fs = require('fs');
const path = require('path');

// Create a simple SVG-based "S" icon and convert to PNG using canvas
// Since we can't use canvas directly, we'll create SVG files first

const resourcesDir = path.join(__dirname, '..', 'src-tauri', 'resources');

// SVG template for the "S" tray icon
function createSvgIcon(fillColor, strokeColor, size = 64, bgColor = 'none', badge = false) {
  const badgeSvg = badge ? `
    <circle cx="${size * 0.78}" cy="${size * 0.22}" r="${size * 0.15}" fill="#d97706" stroke="${strokeColor}" stroke-width="1"/>
    <text x="${size * 0.78}" y="${size * 0.27}" text-anchor="middle" font-size="${size * 0.18}" font-weight="bold" fill="white">!</text>
  ` : '';

  return `<?xml version="1.0" encoding="UTF-8"?>
<svg width="${size}" height="${size}" viewBox="0 0 ${size} ${size}" xmlns="http://www.w3.org/2000/svg">
  ${bgColor !== 'none' ? `<rect width="${size}" height="${size}" fill="${bgColor}" rx="${size * 0.15}"/>` : ''}
  <text
    x="${size / 2}"
    y="${size * 0.76}"
    text-anchor="middle"
    font-family="Arial Black, Arial, Helvetica, sans-serif"
    font-weight="900"
    font-size="${size * 0.75}"
    fill="${fillColor}"
    stroke="${strokeColor}"
    stroke-width="${size * 0.03}"
    paint-order="stroke fill"
  >S</text>
  ${badgeSvg}
</svg>`;
}

// Define all icon variants
const icons = {
  'tray_idle.svg': { fill: '#ffffff', stroke: 'none' },           // White S for dark theme
  'tray_idle_dark.svg': { fill: '#000000', stroke: 'none' },      // Black S for light theme
  'tray_recording.svg': { fill: '#ef4444', stroke: 'none' },      // Red S for recording (dark)
  'tray_recording_dark.svg': { fill: '#dc2626', stroke: 'none' }, // Red S for recording (light)
  'tray_transcribing.svg': { fill: '#ffe000', stroke: 'none' },   // Yellow S for transcribing (dark)
  'tray_transcribing_dark.svg': { fill: '#b8a000', stroke: 'none' }, // Dark yellow S for transcribing (light)
  'tray_idle_warning.svg': { fill: '#ffffff', stroke: 'none', badge: true },     // White S + warning badge
  'tray_idle_warning_dark.svg': { fill: '#000000', stroke: 'none', badge: true }, // Black S + warning badge
  'sayso.svg': { fill: '#ffe000', stroke: '#000000' },            // Colored S for Linux
};

for (const [filename, opts] of Object.entries(icons)) {
  const svg = createSvgIcon(opts.fill, opts.stroke, 64, 'none', opts.badge || false);
  const outPath = path.join(resourcesDir, filename);
  fs.writeFileSync(outPath, svg);
  console.log(`Created: ${outPath}`);
}

console.log('\nSVG icons created. Now convert to PNG...');
console.log('Run: for f in src-tauri/resources/tray_*.svg src-tauri/resources/sayso.svg; do');
console.log('  sips -s format png "$f" --out "${f%.svg}.png"');
console.log('done');
