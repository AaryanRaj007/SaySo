const fs = require('fs');
const path = require('path');

const targetDirs = ['src', 'src-tauri', 'public', 'scripts'];
const rootFiles = ['README.md', 'AGENTS.md', 'CLAUDE.md', 'CONTRIBUTING.md', 'CONTRIBUTING_TRANSLATIONS.md', 'BUILD.md', 'CRUSH.md', 'index.html', 'package.json'];

function replaceInFile(filePath) {
  if (!fs.existsSync(filePath)) return;
  let content = fs.readFileSync(filePath, 'utf8');
  let original = content;

  // Bundle ID & URL replacements
  content = content.replace(/com\.pais\.handy/g, 'com.altn.sayso');
  content = content.replace(/https?:\/\/handy\.computer[^\s"']*/g, '');
  content = content.replace(/https?:\/\/discord\.com\/invite\/[^\s"']*/g, '');
  content = content.replace(/https?:\/\/(www\.)?(paypal\.me|buymeacoffee\.com|ko-fi\.com)\/cjpais[^\s"']*/g, '');

  // Case-sensitive brand replacements
  content = content.replace(/\bHANDY\b/g, 'SAYSO');
  content = content.replace(/\bHandy\b/g, 'SaySo');
  content = content.replace(/\bhandy\b/g, 'sayso');

  if (content !== original) {
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Updated: ${filePath}`);
  }
}

function processDirectory(dirPath) {
  if (!fs.existsSync(dirPath)) return;
  const entries = fs.readdirSync(dirPath, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(dirPath, entry.name);
    if (entry.isDirectory()) {
      if (entry.name === 'node_modules' || entry.name === 'target' || entry.name === '.git' || entry.name === 'brand-raw' || entry.name === 'fonts') continue;
      processDirectory(fullPath);
    } else if (entry.isFile()) {
      const ext = path.extname(entry.name).toLowerCase();
      if (['.ts', '.tsx', '.js', '.jsx', '.json', '.rs', '.html', '.md', '.css', '.toml'].includes(ext)) {
        replaceInFile(fullPath);
      }
    }
  }
}

console.log('Starting SaySo rebrand string replacement pass...');
for (const file of rootFiles) {
  replaceInFile(path.join(__dirname, '..', file));
}
for (const dir of targetDirs) {
  processDirectory(path.join(__dirname, '..', dir));
}
console.log('Rebrand string replacement completed successfully!');
