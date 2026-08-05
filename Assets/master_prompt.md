# SaySo Rebrand — Master Prompt

Paste this whole file as your instruction to the AI coding editor (Antigravity).

---

## Context
This is a clone of the open-source Tauri app "Handy" (cjpais/Handy). Handy is MIT
licensed, but its name, logo, icon, and brand assets are explicitly NOT open source —
forks must rebrand and must not imply affiliation with the original project. This task
rebrands it to **SaySo** (studio: **altn**).

**Scope guardrail: this is a branding-only pass.** Do not change button placement,
component layout, UX flow, navigation structure, or any interaction behavior. Only
touch: names/strings, colors, fonts, icons, and the specific links/copy listed below.
If a change would require moving, resizing, or restructuring a UI element, skip it and
flag it to me instead of doing it.

---

## 1. Asset triage (do this first)
Look inside `assets/brand-raw/` — it contains AI-generated brand images, unsorted,
possibly with duplicates. Inspect each image and classify by content, then move+rename
into the correct location:

- **Square image, solid black background, single yellow "S" letterform with two
  visible symmetric eyes, no wordmark text, no outline stroke** → this is the **main
  app icon**. Save as `assets/brand/icon-source.png`. This is the ONLY icon used
  inside the app itself — convert it to every format/size Tauri requires and replace
  every existing file in `src-tauri/icons/` (check `src-tauri/tauri.conf.json`
  `bundle.icon` array for the exact list of required files, match filenames exactly).
- **Square black silhouette "S" with no color/eyes** → skip, not needed. We are using
  the main color icon everywhere, no separate monochrome/tray icon.
- **Wide landscape image (~1280x640), black background, "SaySo" wordmark + small S
  mascot, black outline/stroke style)** → this is the **GitHub repo social preview
  banner**. Save as `assets/brand/banner-github.png`. Note in README (as a comment or
  a short setup note) that this must be uploaded manually via GitHub repo Settings →
  Social Preview — it cannot be set via code.
- **Wide landscape image with more generous padding/breathing room around the mark**
  → this is the **README/website hero banner**. Save as `assets/brand/banner-hero.png`.
- If duplicates exist in a category, keep the one with both eyes symmetric and fully
  visible (not faded/washed out) and discard the rest.

If any category has zero matching images, don't block — use a plain text "SaySo"
placeholder in that spot and flag it to me at the end.

---

## 2. Full rename: Handy → SaySo
Search and replace across the repo, case-sensitive, preserving casing patterns
(Handy → SaySo, HANDY → SAYSO, handy → sayso):

- `package.json` → `name`, `productName`
- `src-tauri/tauri.conf.json` → `productName`
- `src-tauri/Cargo.toml` → package name
- `index.html` → `<title>`
- Any hardcoded "Handy" strings in `src/` — tray tooltip, settings window title,
  about screen text, tray menu labels. **Change the text only, do not move or
  restyle the elements containing it.**
- `README.md`, `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md` — replace all mentions

---

## 3. Bundle identifier & app data directory
- Change `identifier` in `src-tauri/tauri.conf.json` from `com.pais.handy` to
  `com.altn.sayso`.
- This changes the OS-level app data directory path. Update any hardcoded references
  to `com.pais.handy` in code and in README's troubleshooting/manual-install sections
  to `com.altn.sayso`.

---

## 4. Strip original project's links/references
Remove entirely (no placeholder replacement needed):
- Discord invite badge/link
- `handy.computer` website references
- cjpais's donate links: paypal.me/cjpais, buymeacoffee.com/cjpais, ko-fi.com/cjpais
- `sponsor-images/` folder and its references in README (Wordcab, Epicenter, Bolt AI —
  not our sponsors)
- Any links pointing to cjpais/Handy's GitHub Discussions/Issues as a support channel

---

## 5. New copy (metadata/docs only — NOT in-app UI)
The app's UI has no tagline or marketing copy anywhere — leave every in-app screen
exactly as-is except for the literal "Handy" → "SaySo" name swap from section 2. This
tagline is for project metadata and documentation only:

- `package.json` → `description` field:
  `"SaySo — a free, unlimited, open source speech-to-text app that works completely offline."`
- `README.md` → replace the intro line (currently "A free, open source, and
  extensible speech-to-text application that works completely offline.") with the
  same tagline above.

---

## 6. License handling
- Keep `LICENSE` file exactly as-is (MIT), including the original copyright notice —
  required by MIT even in forks.
- Add one short credit line near the bottom of README (not prominent): "Based on
  Handy by cjpais, MIT licensed."

---

## 7. Fonts
Add **Fredoka** and **Bagel Fat One** as self-hosted web fonts (bundle the font files
locally, do not call Google Fonts CDN at runtime — this is an offline-first app).
- **Bagel Fat One**: logo/wordmark and large headings only.
- **Fredoka**: everything else — settings labels, body copy, buttons.
Register both in the Tailwind font-family config. Do not change which elements use
headings vs body text — just swap the font applied to each existing category.

---

## 8. Colors
Update the color tokens in `tailwind.config.js`/`.ts`:
- Primary accent → yellow (sample the exact hex from `assets/brand/icon-source.png`)
- Background/contrast → black
Apply this through the existing theme token system — do not hardcode hex values in
components. Check for any hardcoded colors in raw CSS files that bypass the Tailwind
config and update those too. **Do not resize, reposition, or restructure any element
while doing this — color values only.**

---

## 9. Icon replacement
Use `assets/brand/icon-source.png` to generate the full icon set Tauri needs and
replace every file in `src-tauri/icons/`.

---

## 10. README structure
Add `assets/brand/banner-hero.png` at the very top of `README.md`, above the title
line.

---

## Constraints (read again before starting)
- **No UX/layout/component changes.** Branding only: text, color, font, icons, links.
- Do not modify Rust backend logic, transcription pipeline, or any functional code.
- Do not remove the MIT `LICENSE` file or its original copyright line.
- After all changes, run the existing dev/build script to confirm the app still
  launches without errors before considering this task complete.
- If anything in this prompt conflicts with keeping the existing UX intact, stop and
  ask rather than guessing.
