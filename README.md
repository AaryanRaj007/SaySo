![SaySo Banner](assets/brand/banner-hero.png)

# SaySo

**SaySo — a free, unlimited, open source speech-to-text app that works completely offline.**

SaySo is a cross-platform desktop application that provides simple, privacy-focused speech transcription. Press a shortcut, speak, and have your words appear in any text field. This happens on your own computer without sending any information to the cloud.

## Why SaySo?

- **Free**: Accessibility tooling belongs in everyone's hands, not behind a paywall
- **Open Source**: Together we can build further. Extend SaySo for yourself and contribute to something bigger
- **Private**: Your voice stays on your computer. Get transcriptions without sending audio to the cloud
- **Simple**: One tool, one job. Transcribe what you say and put it into a text box

## How It Works

1. **Press** a configurable keyboard shortcut to start/stop recording (or use push-to-talk mode)
2. **Speak** your words while the shortcut is active
3. **Release** and SaySo processes your speech using local Whisper / ONNX models
4. **Get** your transcribed text pasted directly into whatever app you're using

The process is entirely local:

- Silence is filtered using VAD (Voice Activity Detection) with Silero VAD v4
- Transcription uses your choice of local models:
  - **Whisper models** (Small/Medium/Turbo/Large) with GPU acceleration when available
  - **Parakeet models** - CPU-optimized models with high performance and automatic language detection
- Works on Windows, macOS, and Linux

## Quick Start

### Installation (macOS)

<!-- Replace `your-github-username` throughout once the repo and tap are published. -->

#### Option 1 — Homebrew (recommended)

**Step 1 — Install Homebrew (skip if you already have it).** Check with
`brew --version`; if that prints a version, jump to step 2. Otherwise:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

This asks for your Mac password and takes a few minutes. When it finishes it may
print two `export PATH` lines — run those, or just close and reopen Terminal, so
the `brew` command is found.

**Step 2 — Install SaySo.**

```bash
brew install --cask --no-quarantine your-github-username/sayso/sayso
```

The `--no-quarantine` flag is what matters: it stops macOS from tagging the app as
downloaded from the internet, so you get a clean install with no security warning.
Without it you'll see the same prompt as the direct download below.

#### Option 2 — Direct download

1. Download `SaySo_<version>_aarch64.dmg` from
   [Releases](https://github.com/your-github-username/SaySo/releases).
2. Open the `.dmg` and drag **SaySo** into your **Applications** folder.
3. macOS will say *"Apple could not verify SaySo is free of malware."* This is
   expected — SaySo is not notarized by Apple (that requires a $99/year Apple
   Developer account). To get past it, once:
   - Open **System Settings → Privacy & Security**
   - Scroll to the bottom — SaySo will be listed as blocked
   - Click **Open Anyway**, then launch SaySo again

   Right-click → Open no longer works on recent macOS versions, so use the steps
   above.

> **Always install to `/Applications`.** Running SaySo directly from the mounted
> `.dmg` means macOS can never keep its Accessibility permission — the disk image
> gets a new, temporary path every time it is mounted.

#### After installing

Launch SaySo and grant the two macOS permissions it asks for:

- **Microphone** — so it can hear you. Audio never leaves your machine.
- **Accessibility** — so it can type the transcription into whatever app you're in.

Then press **Option + Space**, speak, and release. Shortcuts are configurable in
Settings.

#### Building and installing locally

If you build SaySo yourself, use the helper script — it installs to `/Applications`
and signs with a stable certificate so your Accessibility grant survives rebuilds:

```bash
./scripts/create-signing-identity.sh   # once per machine
npm run tauri build && ./scripts/install-macos.sh
```

### Development Setup

For detailed build instructions including platform-specific requirements, see [BUILD.md](BUILD.md).

## Architecture

SaySo is built as a Tauri 2.x application combining:

- **Frontend**: React 18 + TypeScript with Tailwind CSS for the workspace UI
- **Backend**: Rust for system integration, audio processing, and ML inference
- **Core Libraries**:
  - `transcribe-cpp`: Local speech recognition with Whisper-family models (GGML/GGUF)
  - `transcribe-rs`: Local speech recognition with ONNX models
  - `cpal`: Cross-platform audio I/O
  - `vad-rs`: Voice Activity Detection
  - `rdev`: Global keyboard shortcuts and system events
  - `rubato`: Audio resampling

### Debug Mode

SaySo includes a debug mode for development and troubleshooting. Access it by pressing:

- **macOS**: `Cmd+Shift+D`
- **Windows/Linux**: `Ctrl+Shift+D`

### CLI Parameters

SaySo supports command-line flags for controlling a running instance and customizing startup behavior. These work on all platforms (macOS, Windows, Linux).

**Remote control flags** (sent to an already-running instance via the single-instance plugin):

```bash
sayso --toggle-transcription    # Toggle recording on/off
sayso --toggle-post-process     # Toggle recording with post-processing on/off
sayso --cancel                  # Cancel the current operation
```

**Startup flags:**

```bash
sayso --start-hidden            # Start without showing the main window
sayso --no-tray                 # Start without the system tray icon
sayso --debug                   # Enable debug mode with verbose logging
sayso --help                    # Show all available flags
```

Flags can be combined for autostart scenarios:

```bash
sayso --start-hidden --no-tray
```

> **macOS tip:** When SaySo is installed as an app bundle, invoke the binary directly:
>
> ```bash
> /Applications/SaySo.app/Contents/MacOS/SaySo --toggle-transcription
> ```

### Linux Notes

**Text Input Tools:**

For reliable text input on Linux, install the appropriate tool for your display server:

| Display Server | Recommended Tool | Install Command |
| -------------- | ---------------- | -------------------------------------------------- |
| X11 | `xdotool` | `sudo apt install xdotool` |
| Wayland | `wtype` | `sudo apt install wtype` |
| Both | `dotool` | `sudo apt install dotool` (requires `input` group) |

### System Requirements/Recommendations

**For Whisper Models:**

- **macOS**: M series Mac, Intel Mac
- **Windows**: Intel, AMD, or NVIDIA GPU
- **Linux**: Intel, AMD, or NVIDIA GPU

**For Parakeet Models:**

- **CPU-only operation** - runs on a wide variety of hardware
- **Minimum**: Intel Skylake (6th gen) or equivalent AMD processors
- **Automatic language detection** - no manual language selection required

## Troubleshooting

### Manual Model Installation (For Proxy Users or Network Restrictions)

If you're behind a proxy or restricted network environment where SaySo cannot download models automatically, you can manually download and install them.

#### Step 1: Find Your App Data Directory

The default application data directory paths are:

- **macOS**: `~/Library/Application Support/com.altn.sayso/`
- **Windows**: `C:\Users\{username}\AppData\Roaming\com.altn.sayso\`
- **Linux**: `~/.config/com.altn.sayso/`

#### Step 2: Create Models Directory

Inside your app data directory, create a `models` folder if it doesn't already exist:

```bash
# macOS/Linux
mkdir -p ~/.config/com.altn.sayso/models
```

#### Step 3: Install Models

Place `.bin` or `.gguf` model files directly inside the `models/` directory, then restart SaySo to detect the models.

## License

MIT License - see [LICENSE](LICENSE) file for details.

Based on SaySo by cjpais, MIT licensed.

## Acknowledgments

- **Whisper** by OpenAI for the speech recognition model
- **ggml and transcribe.cpp** for cross-platform speech-to-text inference/acceleration
- **Silero** for lightweight VAD
- **Tauri** team for the Rust-based app framework
