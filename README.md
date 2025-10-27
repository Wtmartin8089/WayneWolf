# WayneWolf

**Your personal super-browser. Minimalist. Stealthy. Untraceable. Fast.**

![Version](https://img.shields.io/badge/version-141.0--1-red)
![Based on](https://img.shields.io/badge/based%20on-LibreWolf-blue)
![Privacy](https://img.shields.io/badge/privacy-nuclear-green)

---

## What is WayneWolf?

WayneWolf is a custom-built browser fork based on LibreWolf/Firefox, designed for:

- **Minimalist UI** - No distractions. Just you and the web.
- **Maximum Privacy** - Fingerprint resistance, WebRTC blocking, DNS-over-HTTPS
- **Legacy Compatibility** - Unsigned extensions work out of the box
- **Performance** - GPU acceleration, aggressive caching, zero animations
- **Profile Isolation** - Three modes: dev, browse, ghost

## Features

### 🎨 Minimalist Interface
- Hidden tabs, title bar, menu bar, bookmarks
- Dark, semi-transparent navbar
- Crimson accent colors
- Monospace URL bar
- Zero animations for speed

### 🔒 Nuclear Privacy
- Fingerprint resistance (RFP enabled)
- WebGL disabled by default
- WebRTC blocked (no IP leaks)
- DNS-over-HTTPS enforced
- No telemetry, no pocket, no Mozilla services
- Cookie isolation
- HTTPS-only mode

### ⚡ Performance
- GPU acceleration (WebRender)
- 1GB disk cache / 512MB RAM cache
- HTTP/3 and QUIC enabled
- Accessibility services disabled
- Smooth scrolling disabled
- Animations stripped

### 🔧 Legacy Add-on Support
- Unsigned extensions allowed
- `MOZ_REQUIRE_SIGNING` disabled
- Sideloading enabled
- Install any XPI without restrictions

### 🐺 Profile System

WayneWolf features an advanced profile template system with auto-configured privacy settings and extensions:

**1. Development** (dev) - Web development
- Developer tools enhanced
- All web APIs enabled
- CORS relaxed for localhost
- WebGL and media APIs enabled
- Large console history
- No fingerprinting resistance (test real behavior)

**2. Work** (browse) - Daily browsing
- Balanced privacy and convenience
- Session restore enabled
- Form autofill for productivity
- Search suggestions
- Container tabs support
- Keeps browsing history

**3. Anonymous** (ghost) - Maximum stealth
- Private browsing always enabled
- All data cleared on shutdown
- Maximum fingerprinting resistance
- WebGL disabled completely
- No disk cache (RAM only)
- Block all cookies by default
- Tor-ready SOCKS proxy

**Auto-Installed Extensions:**
- **All profiles:** uBlock Origin, LibRedirect, ClearURLs
- **Work/Development:** Multi-Account Containers
- **Anonymous:** CanvasBlocker, NoScript

## Quick Start

### 1. Install Dependencies

```bash
sudo pacman -S --needed rust cbindgen pigz
```

See [BUILD_GUIDE.md](BUILD_GUIDE.md) for other distros.

### 2. Build WayneWolf

```bash
cd ~/WayneWolf/WayneWolf
make fetch
make dir
make bootstrap
make setup-wasi
make build
make package
```

**Build time:** ~60 minutes on Ryzen 7

### 3. Install

```bash
tar xf librewolf-141.0-1.en-US.*.tar.xz -C ~/.local/
ln -sf ~/.local/librewolf/librewolf ~/.local/bin/waynewolf
```

### 4. Launch

```bash
./launch-waynewolf.sh
```

Or directly:
```bash
./launch-waynewolf.sh dev     # Development mode
./launch-waynewolf.sh browse  # Daily browsing
./launch-waynewolf.sh ghost   # Stealth mode
```

## Profile Management

WayneWolf includes a powerful profile management system with templates and auto-extension installation:

### Create Custom Profiles

```bash
# Create a new profile with a template
./launch-waynewolf.sh --create mywork work
./launch-waynewolf.sh --create research anonymous
./launch-waynewolf.sh --create testing development

# Available templates: work, anonymous, development
```

### List Profiles

```bash
./launch-waynewolf.sh --list
```

### Reset Profile

```bash
# Reset profile configuration and reinstall extensions
./launch-waynewolf.sh --reset browse
```

### Install Extensions to Existing Profile

```bash
./launch-waynewolf.sh --install-ext mywork
```

### Manual Extension Management

```bash
# Install extensions to a specific profile
./install-extensions.sh ~/.waynewolf/profiles/myprofile work

# Extensions are automatically downloaded and cached
# See extensions.conf for available extensions
```

## Desktop Integration

Install desktop entry:
```bash
cp waynewolf.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications/
```

Now WayneWolf appears in your application menu with profile options.

## Customization

### Privacy Settings

WayneWolf uses a layered configuration system:

1. **Base Configuration** (`user.js`)
   - Core privacy hardening settings
   - DNS-over-HTTPS configuration
   - Tracking protection
   - Applies to all profiles

2. **Profile Templates** (`profile-templates/`)
   - `anonymous.js` - Maximum privacy settings
   - `work.js` - Balanced privacy/convenience
   - `development.js` - Developer-friendly settings
   - Layered on top of base configuration

3. **Per-Profile Customization**
   - Edit: `~/.waynewolf/profiles/{profile}/user.js`
   - Changes persist across resets unless profile is recreated

### Modify UI

Edit: `WayneWolf/chrome/userChrome.css`

Then rebuild or copy to:
```bash
~/.waynewolf/profiles/{profile}/chrome/userChrome.css
```

### Add Custom Extensions

Edit `extensions.conf` to add your own extensions:
```conf
# Format: extension_id|download_url|profiles
my-extension@example.com|https://example.com/extension.xpi|all
```

Then reinstall extensions:
```bash
./launch-waynewolf.sh --install-ext myprofile
```

### Tor Integration (Ghost Mode)

1. Install Tor:
```bash
sudo pacman -S tor
sudo systemctl start tor
```

2. Edit `~/.waynewolf/profiles/ghost/user.js`:
```javascript
user_pref("network.proxy.type", 1);
user_pref("network.proxy.socks", "127.0.0.1");
user_pref("network.proxy.socks_port", 9050);
user_pref("network.proxy.socks_remote_dns", true);
```

3. Launch ghost mode:
```bash
./launch-waynewolf.sh ghost
```

## Pre-Installed Extensions

WayneWolf automatically installs privacy-focused extensions based on your profile type:

### All Profiles
- **uBlock Origin** - Industry-leading ad and tracker blocker
- **LibRedirect** - Redirect to privacy-friendly alternatives (YouTube → Invidious, etc.)
- **ClearURLs** - Remove tracking parameters from URLs

### Work & Development Profiles
- **Multi-Account Containers** - Isolate browsing contexts (work, personal, shopping)

### Anonymous Profile
- **CanvasBlocker** - Prevent canvas fingerprinting attacks
- **NoScript** - Advanced script blocking for maximum security

### Additional Recommended Extensions
- **Surfingkeys** - Vim-style keyboard navigation
- **User-Agent Switcher** - Spoof browser identity
- **Bypass Paywalls Clean** - Access paywalled content

All extensions work with WayneWolf's unsigned extension support!

## Architecture

```
WayneWolf/
├── WayneWolf/              # Build source
│   ├── chrome/             # UI customizations
│   ├── settings/           # Privacy configs
│   ├── patches/            # LibreWolf patches
│   └── Makefile            # Build system
├── profile-templates/      # Profile configuration templates
│   ├── anonymous.js        # Maximum privacy settings
│   ├── work.js             # Balanced settings
│   ├── development.js      # Developer settings
│   └── README.md           # Template documentation
├── user.js                 # Base privacy configuration
├── extensions.conf         # Extension auto-install configuration
├── install-extensions.sh   # Extension installer script
├── launch-waynewolf.sh     # Main launcher script
├── BUILD_GUIDE.md          # Detailed build docs
└── README.md               # This file

Runtime:
~/.waynewolf/
└── profiles/               # User profiles
    ├── dev/                # Development profile
    ├── browse/             # Work profile
    ├── ghost/              # Anonymous profile
    └── {custom}/           # Custom user profiles
```

## Documentation

- [BUILD_GUIDE.md](BUILD_GUIDE.md) - Complete build instructions
- [profile-templates/README.md](profile-templates/README.md) - Profile template system documentation
- [WayneWolf/README.md](WayneWolf/README.md) - LibreWolf upstream docs

## Comparison

| Feature | WayneWolf | LibreWolf | Firefox | Chrome |
|---------|-----------|-----------|---------|--------|
| Minimalist UI | ✅ | ❌ | ❌ | ❌ |
| Unsigned Extensions | ✅ | ❌ | ❌ | ❌ |
| Profile Templates | ✅ | ❌ | ❌ | ❌ |
| Auto Extension Install | ✅ | ❌ | ❌ | ❌ |
| Privacy Hardening (user.js) | ✅ | ✅ | ❌ | ❌ |
| Nuclear Privacy | ✅ | ✅ | ❌ | ❌ |
| GPU Accel | ✅ | ✅ | ✅ | ✅ |
| Telemetry | ❌ | ❌ | ✅ | ✅ |
| Open Source | ✅ | ✅ | ✅ | ❌ |

## Philosophy

> **No browser has it all out of the box. So we built one.**

WayneWolf is for developers, researchers, privacy advocates, and anyone who refuses to compromise between features, privacy, and performance.

- **Stealth** - You control your fingerprint
- **Speed** - No bloat, no animations, pure performance
- **Sovereignty** - Your browser, your rules, your code

## Updates

To update to newer Firefox releases:

```bash
cd ~/WayneWolf/WayneWolf
make check      # Check for updates
# Edit version file if needed
make clean
make fetch
make dir
make build
make package
```

## Contributing

This is your browser. Fork it. Modify it. Share it.

Report issues or improvements:
- Fork this repo
- Make changes
- Test thoroughly
- Share your improvements

## License

Based on LibreWolf, which is based on Firefox (MPL 2.0).

Your fork, your rules. Use it however you want.

## Support

- Read [BUILD_GUIDE.md](BUILD_GUIDE.md) for build help
- Check [profiles/README.md](profiles/README.md) for profile questions
- For LibreWolf-specific issues: https://librewolf.net

---

**The wolf is ready. Now hunt.**

```
╦ ╦┌─┐┬ ┬┌┐┌┌─┐╦ ╦┌─┐┬  ┌─┐
║║║├─┤└┬┘│││├┤ ║║║│ ││  ├┤
╚╩╝┴ ┴ ┴ ┘└┘└─┘╚╩╝└─┘┴─┘└
```
