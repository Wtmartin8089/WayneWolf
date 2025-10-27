# WayneWolf Build Guide

Complete guide to building your personal super-browser.

## Prerequisites

### Required Packages

On Arch Linux:
```bash
sudo pacman -S --needed rust cbindgen pigz python3 wget gpg \
    base-devel clang nodejs mercurial
```

On Debian/Ubuntu:
```bash
sudo apt-get install -y mercurial python3 python3-dev python3-pip \
    curl wget dpkg-sig libssl-dev zstd libxml2-dev rust-all cbindgen pigz
```

On Fedora:
```bash
sudo dnf install -y python3 curl wget zstd python3-devel \
    python3-pip mercurial openssl-devel libxml2-devel rust cargo cbindgen pigz
```

### Disk Space

You need approximately:
- **30GB** for Firefox source code
- **10GB** for build artifacts
- **5GB** for final package

**Total: ~45GB free space required**

## Build Process

### 1. Navigate to WayneWolf Source

```bash
cd ~/WayneWolf/WayneWolf
```

### 2. Fetch Firefox Source

```bash
make fetch
```

This downloads Firefox 141.0 source code and verifies GPG signature.

### 3. Extract and Apply WayneWolf Patches

```bash
make dir
```

This creates the `librewolf-141.0-1` directory with all WayneWolf customizations applied.

### 4. Bootstrap Build Environment

**Only needed once:**

```bash
make bootstrap
```

This installs Mozilla build dependencies.

### 5. Setup WASI (Linux only)

```bash
make setup-wasi
```

Required for WebAssembly sandbox support.

### 6. Build WayneWolf

```bash
make build
```

**This takes 45-90 minutes depending on your CPU.**

On Ryzen 7 5825U: ~60 minutes

### 7. Package the Binary

```bash
make package
```

Creates a tarball: `librewolf-141.0-1.en-US.linux-x86_64.tar.xz`

### 8. Test Run

```bash
make run
```

Launches WayneWolf directly from build directory.

## Quick Build (All Steps)

```bash
cd ~/WayneWolf/WayneWolf
make fetch
make dir
make bootstrap
make setup-wasi
make build
make package
```

## Installing WayneWolf

### Option 1: Extract Tarball

```bash
tar xf librewolf-141.0-1.en-US.*.tar.xz -C ~/.local/
ln -sf ~/.local/librewolf/librewolf ~/.local/bin/waynewolf
```

### Option 2: System-wide Install

```bash
sudo tar xf librewolf-141.0-1.en-US.*.tar.xz -C /opt/
sudo ln -sf /opt/librewolf/librewolf /usr/local/bin/waynewolf
```

### Option 3: Use Launcher Script

```bash
# Set binary location in launcher
export WAYNEWOLF_BIN=~/.local/librewolf/librewolf

# Or edit launch-waynewolf.sh and set:
# WAYNEWOLF_BIN="$HOME/.local/librewolf/librewolf"

./launch-waynewolf.sh
```

## Post-Install

### 1. Setup Profiles

```bash
./launch-waynewolf.sh
```

This initializes the profile system at `~/.waynewolf/profiles/`

### 2. Install Extensions (Optional)

**For Legacy Extensions:**
- Browse to `about:config`
- Already configured: `xpinstall.signatures.required = false`
- Install any unsigned `.xpi` files

**Recommended Extensions:**
- **uBlock Origin** - Ad blocking
- **Surfingkeys** - Vim-mode keyboard navigation
- **CanvasBlocker** - Additional fingerprint protection
- **User-Agent Switcher** - Spoof browser identity

### 3. Configure Tor Proxy (Ghost Mode)

Edit `~/.waynewolf/profiles/ghost/user.js`:

```javascript
user_pref("network.proxy.type", 1);
user_pref("network.proxy.socks", "127.0.0.1");
user_pref("network.proxy.socks_port", 9050);
user_pref("network.proxy.socks_remote_dns", true);
```

Then start Tor:
```bash
sudo systemctl start tor
```

## Customization

### Custom userChrome.css

Profile-specific CSS:
```bash
mkdir -p ~/.waynewolf/profiles/{dev,browse,ghost}/chrome/
cp WayneWolf/chrome/userChrome.css ~/.waynewolf/profiles/browse/chrome/
```

Edit to taste.

### Custom Preferences

Edit profile configs:
- `~/.waynewolf/profiles/dev/user.js`
- `~/.waynewolf/profiles/browse/user.js`
- `~/.waynewolf/profiles/ghost/user.js`

## Troubleshooting

### Build fails with "rust not found"

```bash
rustc --version
cargo --version
```

If missing, install Rust and restart terminal.

### Build fails with memory errors

Reduce parallel jobs:
```bash
export MOZ_MAKE_FLAGS="-j4"
make build
```

### GPU acceleration not working

Check:
```bash
# In WayneWolf, go to about:support
# Look for "WebRender" and "Compositing"
```

Should show "WebRender" enabled.

### Profiles not loading

```bash
# Reinitialize
rm -rf ~/.waynewolf/profiles
./launch-waynewolf.sh
```

## Updates

To update WayneWolf when new Firefox releases:

```bash
cd ~/WayneWolf/WayneWolf
make check          # Check for updates
# Edit 'version' file if needed
make clean
make fetch
make dir
make build
make package
```

## Performance Tuning

### For faster builds:

```bash
# Use all CPU cores
export MOZ_MAKE_FLAGS="-j$(nproc)"

# Or specific number
export MOZ_MAKE_FLAGS="-j8"
```

### For lower memory usage:

```bash
export MOZ_MAKE_FLAGS="-j2"
```

## Next Steps

Once built:
1. Test all three profiles (dev, browse, ghost)
2. Install your favorite extensions
3. Configure Tor for ghost mode
4. Bookmark this guide
5. Share WayneWolf with fellow wolves

---

**The wolf is ready. Now hunt.**
