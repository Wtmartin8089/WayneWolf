# WayneWolf Customizations Summary

This document lists all customizations made to create WayneWolf from LibreWolf base.

## Files Modified

### 1. `WayneWolf/chrome/userChrome.css`
**Purpose:** Minimalist stealth UI

**Changes:**
- Hidden tabs toolbar, title bar, menu bar
- Dark semi-transparent navbar (95% opacity)
- Crimson accent colors (#ff0000)
- Green monospace URL bar (#00ff00)
- Context menu dark theme
- All animations disabled
- Status bar removed
- Compact tab styling

**Effect:** Pure focus, zero distractions, terminal-like aesthetic

---

### 2. `WayneWolf/settings/librewolf.cfg`
**Purpose:** Nuclear privacy + DNS hardening + performance

**Changes Added:**

#### Fingerprint Resistance
- `privacy.resistFingerprinting.block_mozAddonManager = true`
- `privacy.spoof_english = 2`
- Media device enumeration disabled
- WebRTC completely blocked

#### DNS-over-HTTPS
- NextDNS as default provider
- TRR mode 3 (strict, no fallback)
- Bootstrap address configured
- ECS disabled
- DNS prefetch disabled

#### Proxy Support
- SOCKS5 proxy support enabled
- Remote DNS through proxy
- Ready for Tor integration

#### Tracking Protection
- Social tracking blocked
- Cryptomining blocked
- Fingerprinting blocked
- First-party isolation enabled

#### Privacy Enhancements
- Referer control (XOrigin policy 2)
- Telemetry completely disabled
- Pocket disabled
- Firefox Accounts disabled
- Safe Browsing (Google) disabled
- Third-party cookies blocked

#### Performance
- GPU acceleration forced
- WebRender enabled
- Hardware video decoding
- 1GB disk cache / 512MB RAM cache
- HTTP/3 enabled
- Accessibility services disabled
- Search suggestions disabled
- Animations disabled
- Session save interval increased

**Effect:** Maximum privacy + maximum speed

---

## Files Created

### 3. Profile System

#### `profiles/README.md`
Documentation for three-profile system

#### `profiles/dev/user.js`
- Developer tools enabled
- WebGL enabled for dev work
- Moderate privacy (RFP off)
- Form autofill
- History enabled

#### `profiles/browse/user.js`
- Balanced privacy
- WebGL enabled for web apps
- Search suggestions enabled
- Bookmarks & history
- Cloudflare DoH (faster)

#### `profiles/ghost/user.js`
- Nuclear privacy (all RFP features)
- No history, no persistent cache
- WebRTC blocked
- Tor-ready SOCKS proxy (commented)
- No cookies persistence
- Strict TRR mode
- Block all third-party cookies
- No Mozilla services

---

### 4. `launch-waynewolf.sh`
**Purpose:** Profile launcher with menu

**Features:**
- Interactive profile selector
- Initializes profiles on first run
- Color-coded ASCII banner
- Direct profile launch via args
- Automatic private window in ghost mode
- Profile validation

**Usage:**
```bash
./launch-waynewolf.sh          # Interactive menu
./launch-waynewolf.sh dev      # Direct launch
./launch-waynewolf.sh ghost    # Ghost mode
```

---

### 5. `BUILD_GUIDE.md`
**Purpose:** Complete build documentation

**Contents:**
- Prerequisites for Arch/Debian/Fedora
- Disk space requirements
- Step-by-step build process
- Installation options
- Post-install configuration
- Tor integration guide
- Extension recommendations
- Troubleshooting section
- Performance tuning
- Update process

---

### 6. `README.md`
**Purpose:** Project overview and quick start

**Contents:**
- Feature showcase
- Philosophy explanation
- Quick start guide
- Desktop integration
- Customization guides
- Architecture diagram
- Comparison table
- ASCII banner

---

### 7. `waynewolf.desktop`
**Purpose:** Desktop environment integration

**Features:**
- Appears in application menu
- Right-click actions for each profile
- MIME type associations
- Icon integration

---

## Configuration Philosophy

### Three-Tier Privacy Model

**Level 1: dev**
- Usability > Privacy
- For local development
- Tools enabled, tracking minimal

**Level 2: browse**
- Privacy ≈ Usability
- For daily browsing
- Balanced approach

**Level 3: ghost**
- Privacy >> Usability
- For anonymous operations
- Leave no trace

### Performance Strategy

- **Disable** all animations
- **Enable** GPU acceleration
- **Maximize** cache sizes
- **Minimize** background processes
- **Remove** telemetry overhead

### Privacy Strategy

- **Block** fingerprinting vectors
- **Isolate** cookies and storage
- **Enforce** DNS-over-HTTPS
- **Disable** WebRTC
- **Prevent** IP leaks

---

## What's Ready Out of the Box

✅ Unsigned extension support (already in mozconfig)
✅ Minimalist UI (userChrome.css)
✅ Nuclear privacy (librewolf.cfg)
✅ DNS-over-HTTPS hardening
✅ SOCKS proxy support
✅ Performance optimizations
✅ Three-profile system
✅ Interactive launcher
✅ Desktop integration
✅ Complete documentation

---

## What You Need to Do

1. **Install dependencies:**
   ```bash
   sudo pacman -S --needed rust cbindgen pigz
   ```

2. **Build WayneWolf:**
   ```bash
   cd ~/WayneWolf/WayneWolf
   make fetch && make dir && make bootstrap
   make setup-wasi && make build && make package
   ```

3. **Install binary:**
   ```bash
   tar xf librewolf-141.0-1.en-US.*.tar.xz -C ~/.local/
   ln -sf ~/.local/librewolf/librewolf ~/.local/bin/waynewolf
   ```

4. **Launch:**
   ```bash
   cd ~/WayneWolf
   ./launch-waynewolf.sh
   ```

5. **(Optional) Desktop integration:**
   ```bash
   cp waynewolf.desktop ~/.local/share/applications/
   update-desktop-database ~/.local/share/applications/
   ```

---

## Comparison: Before vs After

| Feature | LibreWolf Base | WayneWolf |
|---------|---------------|-----------|
| UI | Standard Firefox | Minimalist, hidden chrome |
| Profiles | Manual | Three-mode system |
| Launcher | Direct binary | Interactive menu |
| DoH | Basic | NextDNS strict mode |
| Proxy | Manual config | Tor-ready SOCKS5 |
| Cache | Conservative | Aggressive (1GB+) |
| GPU | Default | Forced acceleration |
| Animations | Some | Zero |
| Desktop Entry | Yes | Yes + profile actions |
| Documentation | README | 4 guides |

---

## Files Changed Summary

```
WayneWolf/
├── WayneWolf/
│   ├── chrome/userChrome.css       [MODIFIED] - Stealth UI
│   └── settings/librewolf.cfg      [MODIFIED] - Privacy+Performance
├── profiles/                        [CREATED]  - Three-tier system
│   ├── dev/user.js                 [CREATED]
│   ├── browse/user.js              [CREATED]
│   ├── ghost/user.js               [CREATED]
│   └── README.md                   [CREATED]
├── launch-waynewolf.sh              [CREATED]  - Profile launcher
├── BUILD_GUIDE.md                   [CREATED]  - Build docs
├── README.md                        [CREATED]  - Project overview
├── waynewolf.desktop                [CREATED]  - Desktop entry
└── CUSTOMIZATIONS.md                [THIS FILE]
```

---

## Next Steps After Build

1. **Test all profiles:**
   - `./launch-waynewolf.sh dev`
   - `./launch-waynewolf.sh browse`
   - `./launch-waynewolf.sh ghost`

2. **Install extensions:**
   - uBlock Origin
   - Surfingkeys (vim mode)
   - CanvasBlocker
   - User-Agent Switcher

3. **Configure Tor (ghost mode):**
   - Install Tor: `sudo pacman -S tor`
   - Edit `~/.waynewolf/profiles/ghost/user.js`
   - Uncomment proxy settings
   - Start Tor: `sudo systemctl start tor`

4. **Test fingerprinting:**
   - Visit: https://browserleaks.com
   - Visit: https://coveryourtracks.eff.org
   - Visit: https://amiunique.org

5. **Customize to taste:**
   - Edit userChrome.css colors
   - Adjust cache sizes
   - Add bookmarks
   - Configure search engines

---

**You now have a fully weaponized browser. The wolf is ready.**
