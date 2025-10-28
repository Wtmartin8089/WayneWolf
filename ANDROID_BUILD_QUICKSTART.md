# WayneWolf Android - Quick Start Guide

## Overview

Building WayneWolf for Android requires setting up the Android development environment and building from Mozilla's Fenix (Firefox for Android) codebase.

## Time & Resources Required

- **Setup Time:** 30-45 minutes (first time)
- **Build Time:** 30-60 minutes
- **Disk Space:** 10-15 GB
- **RAM:** 8GB minimum, 16GB recommended

## Prerequisites

### 1. Install Java 17

```bash
sudo pacman -S jdk17-openjdk
sudo archlinux-java set java-17-openjdk
java -version  # Should show version 17
```

### 2. Install Android SDK Command-line Tools

```bash
# Create Android SDK directory
mkdir -p ~/Android/Sdk/cmdline-tools

# Download Android command-line tools
cd ~/Downloads
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

# Extract
unzip commandlinetools-linux-*_latest.zip -d ~/Android/Sdk/cmdline-tools
mv ~/Android/Sdk/cmdline-tools/cmdline-tools ~/Android/Sdk/cmdline-tools/latest

# Set environment variables
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

# Accept licenses
yes | sdkmanager --licenses

# Install required SDK components
sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;33.0.0"
sdkmanager --install "ndk;25.1.8937393"
```

### 3. Install Rust Targets for Android

```bash
rustup target add armv7-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android
```

### 4. Install Additional Dependencies

```bash
sudo pacman -S git curl python3 nodejs npm
```

## Building WayneWolf for Android

### Option 1: Using Our Build Script (Recommended)

```bash
cd ~/WayneWolf

# Build APK
./packaging/android/build-apk.sh

# This will:
# 1. Clone Fenix repository
# 2. Apply WayneWolf customizations
# 3. Build release APK
# 4. Output to: dist/android/waynewolf-1.0.0-release-unsigned.apk
```

### Option 2: Manual Build

```bash
# Clone Fenix
git clone --depth 1 https://github.com/mozilla-mobile/fenix.git waynewolf-android
cd waynewolf-android

# Customize app name and package ID
sed -i 's/applicationId "org.mozilla.fenix"/applicationId "org.waynewolf.browser"/' app/build.gradle
sed -i 's/<string name="app_name">.*<\/string>/<string name="app_name">WayneWolf<\/string>/' app/src/main/res/values/strings.xml

# Build
./gradlew clean
./gradlew assembleRelease

# Output: app/build/outputs/apk/release/app-release-unsigned.apk
```

## Signing the APK

### Generate Keystore (First Time Only)

```bash
cd ~/WayneWolf

# Generate release keystore
keytool -genkey -v -keystore waynewolf-release.keystore \
    -alias waynewolf \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000

# IMPORTANT: Save the password securely!
# You'll need this keystore for every app update
```

### Sign APK

```bash
./packaging/android/sign-apk.sh

# This will:
# 1. Align the APK
# 2. Sign with your keystore
# 3. Verify signature
# 4. Output: dist/android/waynewolf-1.0.0-release-signed.apk
```

## Testing

### Install on Device

```bash
# Enable USB debugging on your Android device
# Settings → About Phone → Tap "Build Number" 7 times
# Settings → Developer Options → Enable USB Debugging

# Connect device and verify
adb devices

# Install
adb install dist/android/waynewolf-1.0.0-release-signed.apk

# Launch
adb shell am start -n org.waynewolf.browser/.MainActivity
```

### Test in Emulator

```bash
# Create emulator
avdmanager create avd -n waynewolf-test -k "system-images;android-33;google_apis;x86_64"

# Start emulator
emulator -avd waynewolf-test &

# Install and test
adb install dist/android/waynewolf-1.0.0-release-signed.apk
```

## Distribution

### GitHub Releases

```bash
# Upload to GitHub releases
gh release upload v1.0.0-android \
    dist/android/waynewolf-1.0.0-release-signed.apk \
    dist/android/waynewolf-1.0.0-release-signed.apk.sha256
```

Users can download and install:
1. Enable "Unknown sources" in Android settings
2. Download APK from GitHub
3. Install directly

### F-Droid Submission

See: https://f-droid.org/docs/Submitting_to_F-Droid/

Requirements:
- Open source code
- No proprietary dependencies
- Reproducible builds

### Google Play Store

Requirements:
- Google Play Developer account ($25 one-time)
- Privacy policy URL
- App content rating
- Store listing with screenshots

## Features to Implement

### Phase 1 (Basic)
- [x] Build script
- [x] Signing script
- [x] Custom branding
- [ ] Profile system UI
- [ ] Extension support

### Phase 2 (Advanced)
- [ ] Sync with desktop profiles
- [ ] QR code profile sharing
- [ ] Tor integration
- [ ] Enhanced privacy settings UI

## Troubleshooting

### Build Fails: "NDK not found"

```bash
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/25.1.8937393
```

### Gradle Sync Issues

```bash
cd waynewolf-android
./gradlew clean
rm -rf .gradle
./gradlew build --refresh-dependencies
```

### APK Too Large

Enable R8 shrinking in `app/build.gradle`:

```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt')
        }
    }
}
```

### Out of Memory During Build

Increase heap size in `gradle.properties`:

```properties
org.gradle.jvmargs=-Xmx6g -XX:MaxPermSize=2048m
```

## Estimated Timeline

| Task | Time |
|------|------|
| Install prerequisites | 15-30 min |
| First build | 30-60 min |
| Signing setup | 5 min |
| Testing | 10-20 min |
| **Total (first time)** | **1-2 hours** |

Subsequent builds: 20-30 minutes

## Quick Command Reference

```bash
# Full build and sign process
cd ~/WayneWolf
./packaging/android/build-apk.sh
./packaging/android/sign-apk.sh

# Install on device
adb install -r dist/android/waynewolf-*-release-signed.apk

# View logs
adb logcat | grep -i waynewolf

# Uninstall
adb uninstall org.waynewolf.browser
```

## Next Steps

1. **Setup prerequisites** (if not done)
2. **Run build script:** `./packaging/android/build-apk.sh`
3. **Sign APK:** `./packaging/android/sign-apk.sh`
4. **Test on device**
5. **Upload to GitHub releases**

## Resources

- **Fenix Repository:** https://github.com/mozilla-mobile/fenix
- **Android Developer Docs:** https://developer.android.com
- **F-Droid Docs:** https://f-droid.org/docs/
- **Full Android Build Guide:** `packaging/android/README.md`

---

**Ready to build? Let's start with the prerequisites!**
