# Install WayneWolf for Android

## Installation Options

### Option 1: Direct Download from GitHub (Recommended)

1. **Enable Unknown Sources**
   - Go to Settings → Security
   - Enable "Unknown sources" or "Install unknown apps"

2. **Download APK**
   - Visit: https://github.com/WTmartin8089/waynewolf/releases
   - Download: `waynewolf-1.0.0-release-signed.apk`

3. **Verify Checksum** (Optional but recommended)
   ```bash
   # Download SHA256 checksum file
   # Compare with:
   sha256sum waynewolf-1.0.0-release-signed.apk
   ```

4. **Install**
   - Tap the downloaded APK file
   - Follow the prompts to install

### Option 2: Install via ADB (For Developers)

```bash
# Enable USB debugging on your device
# Connect device to computer

# Verify connection
adb devices

# Install APK
adb install waynewolf-1.0.0-release-signed.apk

# Launch app
adb shell am start -n org.waynewolf.browser/.MainActivity
```

### Option 3: F-Droid (Coming Soon)

WayneWolf will be available on F-Droid after the review process completes.

F-Droid is an open-source app store focused on privacy and security.

- **F-Droid Website:** https://f-droid.org
- **Install F-Droid:** https://f-droid.org/en/
- **Search for:** WayneWolf

### Option 4: Google Play Store (Future)

May be available on Google Play Store in the future.

## System Requirements

- **Android Version:** 5.0 (Lollipop) or higher
- **Architecture:** ARM, ARM64, x86, or x86_64
- **Storage:** ~100 MB free space
- **RAM:** 1 GB minimum, 2 GB recommended

## Supported Architectures

WayneWolf provides optimized builds for all Android architectures:

- **arm64-v8a** - Modern 64-bit ARM devices (most common)
- **armeabi-v7a** - Older 32-bit ARM devices
- **x86** - 32-bit Intel/AMD devices (rare)
- **x86_64** - 64-bit Intel/AMD devices (some tablets)

The APK will automatically install the correct version for your device.

## First Launch

After installation:

1. **Grant Permissions**
   - Storage (for downloads)
   - Notifications (optional)

2. **Choose Your Profile**
   - **Dev Profile** - For web development
   - **Work Profile** - For professional browsing
   - **Ghost Profile** - Maximum privacy/anonymity

3. **Configure Privacy Settings**
   - Enhanced Tracking Protection is enabled by default
   - Customize in Settings → Privacy & Security

## Features

### Privacy-First Browsing
- **No Telemetry** - All Mozilla tracking disabled
- **Enhanced Tracking Protection** - Blocks ads, trackers, and fingerprinting
- **WebRTC Disabled** - Prevents IP leaks
- **HTTPS-Only Mode** - Forces encrypted connections

### Profile System
- **Multiple Profiles** - Separate browsing contexts
- **Profile Templates** - Pre-configured for different use cases
- **Easy Switching** - Quick profile switcher in menu

### Extension Support
- Compatible with Firefox for Android extensions
- Install from Mozilla Add-ons
- Popular privacy extensions work out of the box

### Modern UI
- **Dark Theme** - Minimalist dark interface
- **Tab Management** - Organize and group tabs
- **Sync Support** - Self-hosted sync (coming soon)

## Troubleshooting

### App Won't Install

**Error: "App not installed"**
- Enable "Unknown sources" in Settings
- Check you have enough storage space
- Try rebooting your device

**Error: "Parse error"**
- Download the APK again (may be corrupted)
- Verify the SHA256 checksum
- Ensure your Android version is 5.0+

### App Crashes on Launch

1. Clear app data:
   - Settings → Apps → WayneWolf → Storage → Clear Data

2. Reinstall the app:
   ```bash
   adb uninstall org.waynewolf.browser
   adb install waynewolf-1.0.0-release-signed.apk
   ```

3. Check logs:
   ```bash
   adb logcat | grep -i waynewolf
   ```

### Extensions Not Working

- Ensure extension is compatible with Firefox for Android
- Try restarting the browser
- Check extension settings in Add-ons manager

## Updating

### Manual Updates

1. Download new APK from GitHub releases
2. Install over existing version (data will be preserved)

### Future Auto-Updates

- F-Droid: Automatic updates via F-Droid app
- Play Store: Automatic updates via Play Store (if published)

## Uninstalling

### Via Android Settings
1. Settings → Apps → WayneWolf
2. Tap "Uninstall"

### Via ADB
```bash
adb uninstall org.waynewolf.browser
```

## Privacy & Security

### Data Collection

WayneWolf collects **ZERO** data:
- No telemetry
- No crash reports (unless you enable)
- No usage statistics
- No analytics

### Permissions

WayneWolf requests minimal permissions:
- **Internet** - Required for browsing
- **Storage** - For downloads and bookmarks
- **Notifications** - For download notifications (optional)

### Secure Browsing

- All connections default to HTTPS
- Enhanced Tracking Protection enabled
- Fingerprinting resistance enabled
- Third-party cookies blocked

## Getting Help

- **Issues:** https://github.com/WTmartin8089/waynewolf/issues
- **Documentation:** https://github.com/WTmartin8089/waynewolf
- **Build Guide:** See `ANDROID_BUILD_QUICKSTART.md`

## Contributing

WayneWolf is open source! Contributions welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

WayneWolf for Android is based on Mozilla Firefox (Fenix) and inherits the Mozilla Public License 2.0.

See: https://www.mozilla.org/en-US/MPL/2.0/

---

**Enjoy private, secure browsing with WayneWolf!**
