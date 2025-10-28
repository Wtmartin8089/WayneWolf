# WayneWolf Browser - Complete Testing Guide

**Version:** 141.0
**Date:** 2025-10-27
**Status:** Ready for Testing

---

## 🎉 SUCCESS! Android Package Name Fixed

**Package Name:** `org.waynewolf.browser` ✅
**Previous Issue:** Package was `org.mozilla` - SOLVED!
**Solution:** Implemented Mull Browser's proven package name change strategy

---

## Quick Start - Test Android Now

### 1. Sign the APKs (Required)

```bash
cd /home/waynemartin1980/WayneWolf
./packaging/android/sign-all-apks.sh
```

You'll be prompted for the keystore password. This will sign all 4 APKs.

### 2. Verify Package Name (Optional but Recommended)

```bash
~/Android/Sdk/build-tools/30.0.3/aapt dump badging \
  dist/android/waynewolf-arm64-v8a-release-signed.apk | grep package:
```

Expected output:
```
package: name='org.waynewolf.browser' versionCode='2016122699'
```

### 3. Transfer to Your Phone

```bash
# Option 1: USB (if phone is connected)
adb push dist/android/waynewolf-arm64-v8a-release-signed.apk /sdcard/Download/

# Option 2: Check sizes and transfer manually
ls -lh dist/android/waynewolf-*-signed.apk
```

**Which APK to use?**
- **arm64-v8a** - Modern phones (Snapdragon 8 Gen 3, etc.) - **USE THIS ONE**
- **armeabi-v7a** - Older ARM phones (pre-2018)
- **x86_64** - Intel/AMD tablets
- **x86** - Older Intel tablets

### 4. Install on Phone

1. **Enable Unknown Sources:**
   - Settings → Security → Unknown Sources (enable)
   - Or: Settings → Apps → Special Access → Install unknown apps

2. **Install:**
   - Open File Manager
   - Navigate to Downloads folder
   - Tap the `waynewolf-arm64-v8a-release-signed.apk` file
   - Grant permission when prompted
   - Tap "Install"

3. **Expected Result:**
   - ✅ Installation should complete successfully
   - ✅ No conflict with Firefox (different package name!)
   - ✅ WayneWolf appears in app drawer

### 5. Test Installation

**Test 1: Install with Firefox Present**
```
Status: [ ] Passed  [ ] Failed
Notes: Can both apps be installed simultaneously?
```

**Test 2: Launch WayneWolf**
```
Status: [ ] Passed  [ ] Failed
Notes: Does the app launch without crashing?
```

**Test 3: Basic Functionality**
```
Status: [ ] Passed  [ ] Failed
Notes: Can you browse to https://example.com?
```

**Test 4: Check Package Name**
```bash
# From computer (if phone connected via USB)
adb shell pm list packages | grep waynewolf
# Expected: package:org.waynewolf.browser
```

---

## Desktop Linux Testing

### Arch Linux (AUR) - Already Live! ✅

```bash
# Install from AUR
yay -S waynewolf
# or
paru -S waynewolf

# Run
waynewolf

# Uninstall (if needed)
yay -R waynewolf
```

**Test Cases:**
- [ ] Installation completes without errors
- [ ] Browser launches successfully
- [ ] Can browse websites
- [ ] Desktop icon appears
- [ ] Profile templates work (check ~/.waynewolf/profiles/)

---

### Flatpak (Universal Linux) - 🔧 Ready

```bash
# Build locally
cd /home/waynemartin1980/WayneWolf/packaging/flatpak
flatpak-builder --user --install --force-clean build com.waynewolf.Browser.yml

# Run
flatpak run com.waynewolf.Browser

# Uninstall
flatpak uninstall com.waynewolf.Browser
```

**Prerequisites:**
```bash
# Arch
sudo pacman -S flatpak flatpak-builder

# Debian/Ubuntu
sudo apt install flatpak flatpak-builder

# Fedora
sudo dnf install flatpak flatpak-builder
```

**Test Cases:**
- [ ] Build completes without errors
- [ ] Browser launches in sandboxed environment
- [ ] File downloads work
- [ ] Webcam/microphone permissions work (if granted)
- [ ] Can access Downloads folder

---

### Debian/Ubuntu (.deb) - 🔧 Ready

```bash
# Build the package
cd /tmp
tar xf ~/WayneWolf/librewolf-141.0-1.source.tar.gz
cp -r ~/WayneWolf/packaging/debian librewolf-141.0/
cd librewolf-141.0
dpkg-buildpackage -us -uc -b

# Install (will be in parent directory)
cd ..
sudo dpkg -i waynewolf_141.0-1_amd64.deb
sudo apt-get install -f  # Fix any dependency issues

# Run
waynewolf

# Uninstall
sudo apt remove waynewolf
```

**Prerequisites:**
```bash
sudo apt-get install devscripts debhelper cbindgen cargo rustc \
    python3 nodejs yasm clang llvm libx11-dev libgtk-3-dev \
    libdbus-glib-1-dev libpulse-dev zip unzip nasm
```

**Test Cases:**
- [ ] Build completes (~30-60 minutes)
- [ ] Package installs without dependency errors
- [ ] Browser launches
- [ ] Desktop integration works
- [ ] Uninstall removes all files

**Tested On:**
- [ ] Ubuntu 22.04 LTS
- [ ] Ubuntu 24.04 LTS
- [ ] Debian 12 (Bookworm)
- [ ] Linux Mint 21
- [ ] Pop!_OS 22.04

---

### Fedora/RHEL (.rpm) - 🔧 Ready

```bash
# Set up build environment
rpmdev-setuptree

# Copy files
cp ~/WayneWolf/packaging/rpm/waynewolf.spec ~/rpmbuild/SPECS/
wget -P ~/rpmbuild/SOURCES/ \
    https://github.com/WTmartin8089/waynewolf/releases/download/v141.0/librewolf-141.0-1.source.tar.gz

# Build
cd ~/rpmbuild/SPECS
rpmbuild -ba waynewolf.spec

# Install
sudo dnf install ~/rpmbuild/RPMS/x86_64/waynewolf-141.0-1.x86_64.rpm

# Run
waynewolf

# Uninstall
sudo dnf remove waynewolf
```

**Prerequisites:**
```bash
sudo dnf install rpm-build rpmdevtools rust cargo cbindgen python3 \
    nodejs yasm nasm clang llvm gcc-c++ gtk3-devel libXt-devel \
    dbus-glib-devel pulseaudio-libs-devel alsa-lib-devel zip unzip
```

**Test Cases:**
- [ ] Build completes (~30-60 minutes)
- [ ] Package installs without dependency errors
- [ ] Browser launches
- [ ] SELinux doesn't block execution
- [ ] Uninstall removes all files

**Tested On:**
- [ ] Fedora 40
- [ ] Fedora 41
- [ ] RHEL 9
- [ ] AlmaLinux 9
- [ ] Rocky Linux 9

---

## Testing Checklist

### Critical Tests (Must Pass)

#### Android
- [ ] Package name is `org.waynewolf.browser`
- [ ] Installs without errors
- [ ] No conflict with Firefox
- [ ] App launches successfully
- [ ] Can browse websites
- [ ] Settings accessible
- [ ] Downloads work

#### Desktop (All Platforms)
- [ ] Installs without errors
- [ ] Browser launches
- [ ] Can browse HTTPS sites
- [ ] Extensions can be installed
- [ ] Downloads work
- [ ] Profile templates accessible

### Feature Tests (Should Pass)

#### Privacy Features
- [ ] Tracking protection enabled by default
- [ ] HTTPS-only mode works
- [ ] No telemetry sent (check network traffic)
- [ ] Cookies cleared on close
- [ ] Fingerprint protection active

#### Profile System
- [ ] Dev profile exists (~/.waynewolf/profiles/dev/)
- [ ] Browse profile exists
- [ ] Ghost profile exists
- [ ] Can switch between profiles
- [ ] Each profile has separate settings

#### UI/UX
- [ ] Dark theme applied by default
- [ ] Minimalist UI visible
- [ ] Icons display correctly
- [ ] Desktop entry works
- [ ] Application menu works

---

## Known Issues

### Android
- ✅ **SOLVED:** Package name was `org.mozilla` - now `org.waynewolf.browser`
- ⚠️ App label still says "Firefox" (cosmetic, doesn't affect functionality)
- ⚠️ Version name shows as blank (cosmetic)

### Desktop
- None currently identified

---

## Reporting Issues

If you encounter problems during testing:

1. **Package Name Issues (Android):**
   ```bash
   # Check actual package name
   ~/Android/Sdk/build-tools/30.0.3/aapt dump badging <apk-file> | grep package:

   # Check if already installed
   adb shell pm list packages | grep -E "waynewolf|mozilla"
   ```

2. **Build Failures:**
   - Save complete build log
   - Note your OS and version
   - Check dependency versions (Rust, Java, etc.)

3. **Runtime Crashes:**
   ```bash
   # Android logs
   adb logcat | grep -E "WayneWolf|waynewolf|AndroidRuntime"

   # Desktop logs
   waynewolf 2>&1 | tee ~/waynewolf-debug.log
   ```

4. **Report At:**
   - GitHub Issues: https://github.com/WTmartin8089/waynewolf/issues
   - Include: OS, version, error messages, logs

---

## Success Criteria

### Android Release Ready When:
- ✅ Package name is `org.waynewolf.browser`
- ✅ All 4 APKs signed
- [ ] Installs on modern phones (arm64-v8a)
- [ ] Installs alongside Firefox without conflict
- [ ] Basic browsing works
- [ ] No crashes on launch

### Desktop Release Ready When:
- ✅ AUR package works
- [ ] Flatpak builds successfully
- [ ] At least one .deb distribution tested
- [ ] At least one .rpm distribution tested
- [ ] All packages install without errors
- [ ] Browser launches on all platforms

---

## Next Steps After Testing

1. **If Android Tests Pass:**
   - Upload signed APKs to GitHub Releases
   - Update README with installation instructions
   - Consider F-Droid submission

2. **If Desktop Tests Pass:**
   - Submit Flatpak to Flathub
   - Upload .deb and .rpm to GitHub Releases
   - Update multi-distro documentation

3. **If Issues Found:**
   - Document all issues
   - Prioritize critical bugs
   - Create fix plan
   - Retest after fixes

---

## File Locations

### Android APKs
- **Unsigned:** `/home/waynemartin1980/WayneWolf/dist/android/waynewolf-*-unsigned.apk`
- **Signed:** `/home/waynemartin1980/WayneWolf/dist/android/waynewolf-*-signed.apk`

### Desktop Packages
- **AUR:** Published at https://aur.archlinux.org/packages/waynewolf
- **Flatpak Manifest:** `/home/waynemartin1980/WayneWolf/packaging/flatpak/com.waynewolf.Browser.yml`
- **Debian Files:** `/home/waynemartin1980/WayneWolf/packaging/debian/*`
- **RPM Spec:** `/home/waynemartin1980/WayneWolf/packaging/rpm/waynewolf.spec`

### Build Scripts
- **Android Build:** `/home/waynemartin1980/WayneWolf/packaging/android/build-waynewolf-apk.sh`
- **Android Sign:** `/home/waynemartin1980/WayneWolf/packaging/android/sign-all-apks.sh`

---

## Quick Command Reference

```bash
# Android: Sign APKs
./packaging/android/sign-all-apks.sh

# Android: Transfer to phone
adb push dist/android/waynewolf-arm64-v8a-release-signed.apk /sdcard/Download/

# Android: Check if installed
adb shell pm list packages | grep waynewolf

# Arch: Install
yay -S waynewolf

# Flatpak: Build and install
cd packaging/flatpak && flatpak-builder --user --install build com.waynewolf.Browser.yml

# Desktop: Run
waynewolf

# Check version
waynewolf --version

# Desktop: Uninstall (Arch)
yay -R waynewolf
```

---

**Built with Claude Code** 🤖

Last Updated: 2025-10-27
