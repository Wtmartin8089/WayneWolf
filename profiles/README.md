# WayneWolf Profile System

WayneWolf uses isolated profiles for different operational modes.

## Profiles

### 1. **dev** - Development Profile
- Full developer tools enabled
- Console logging active
- Extensions for debugging
- Normal privacy settings
- **Use for**: Coding, testing, local development

### 2. **browse** - Daily Browsing Profile
- Moderate privacy settings
- Extension compatibility
- Form autofill enabled
- Bookmarks and history
- **Use for**: General web browsing, research, productivity

### 3. **ghost** - Maximum Stealth Profile
- Nuclear privacy settings
- All telemetry disabled
- WebRTC blocked
- Tor-ready SOCKS proxy support
- No history, no cache persistence
- **Use for**: Anonymous operations, sensitive research, untraceable browsing

## Profile Isolation

Each profile has:
- Separate cookie jars
- Isolated local storage
- Independent extension sets
- Unique cache directories
- No cross-profile leakage

## Usage

```bash
# Launch specific profile
./waynewolf --profile dev
./waynewolf --profile browse
./waynewolf --profile ghost

# Or use the launcher
./launch-waynewolf.sh
```

## Profile Locations

Profiles are stored in:
```
~/.waynewolf/profiles/
├── dev/
├── browse/
└── ghost/
```

Each contains:
- `prefs.js` - Firefox preferences
- `chrome/` - Custom CSS
- `extensions/` - Profile-specific addons
