# WayneWolf Quick Start

## Launch WayneWolf

```bash
cd ~/WayneWolf
./launch-waynewolf.sh
```

Choose profile:
- **1** = dev (development mode)
- **2** = browse (daily use)
- **3** = ghost (maximum stealth)

Or launch directly:
```bash
./launch-waynewolf.sh dev
./launch-waynewolf.sh browse
./launch-waynewolf.sh ghost
```

## Test Your Privacy

In ghost mode, visit:
- https://browserleaks.com
- https://coveryourtracks.eff.org

You should see:
- ✅ WebRTC blocked (no IP leak)
- ✅ Canvas fingerprinting blocked
- ✅ WebGL disabled
- ✅ Timezone: UTC

## Install Extensions

WayneWolf supports unsigned extensions. Install:
1. uBlock Origin
2. Surfingkeys (vim mode)
3. CanvasBlocker
4. User-Agent Switcher

## Enable Tor (Ghost Mode)

```bash
sudo pacman -S tor
sudo systemctl start tor

nano ~/.waynewolf/profiles/ghost/user.js
# Uncomment the SOCKS proxy lines

./launch-waynewolf.sh ghost
```

## Desktop Integration

```bash
cd ~/WayneWolf
cp waynewolf.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications/
```

Now WayneWolf appears in your application menu.

## Customization

### Change UI colors
Edit: `WayneWolf/chrome/userChrome.css`

### Adjust privacy
Edit: `WayneWolf/settings/librewolf.cfg`

### Profile settings
Edit: `~/.waynewolf/profiles/{dev,browse,ghost}/user.js`

## Build Info

- Version: 141.0-1
- Build time: 33 minutes
- Package: 80 MB
- Platform: Arch Linux x86_64

---

**The wolf is ready. Now hunt.** 🐺
