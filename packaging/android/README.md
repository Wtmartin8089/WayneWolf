# WayneWolf for Android

This directory contains configuration for building WayneWolf for Android.

## Overview

WayneWolf for Android is based on Mozilla's Fenix (Firefox for Android). It brings the same privacy-focused features and profile system to mobile devices.

## Prerequisites

### System Requirements

- **Operating System:** Linux (Ubuntu 20.04+ recommended) or macOS
- **RAM:** 16GB minimum, 32GB recommended
- **Disk Space:** 40GB free space
- **Java:** OpenJDK 17
- **Android SDK & NDK**
- **Git**
- **Rust**

### Installation

#### Ubuntu/Debian

```bash
# Install Java
sudo apt install openjdk-17-jdk

# Install Android SDK command-line tools
# Download from: https://developer.android.com/studio#command-tools
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
mkdir -p ~/Android/Sdk/cmdline-tools
unzip commandlinetools-linux-*_latest.zip -d ~/Android/Sdk/cmdline-tools
mv ~/Android/Sdk/cmdline-tools/cmdline-tools ~/Android/Sdk/cmdline-tools/latest

# Set environment variables
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

# Install SDK components
sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;33.0.0"
sdkmanager --install "ndk;25.1.8937393"

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add armv7-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android

# Install other dependencies
sudo apt install git curl python3 python3-pip nodejs npm
```

## Building WayneWolf for Android

### Method 1: Using Fenix Base (Recommended)

```bash
# Clone Fenix repository
git clone https://github.com/mozilla-mobile/fenix.git waynewolf-android
cd waynewolf-android

# Apply WayneWolf customizations
cp ../packaging/android/gradle.properties ./
cp ../packaging/android/build-config.yml ./
cp -r ../packaging/android/branding ./app/src/main/res/

# Customize the app
./gradlew clean

# Build release APK
./gradlew assembleRelease

# Output will be at:
# app/build/outputs/apk/release/app-release-unsigned.apk
```

### Method 2: Using GeckoView

For more control, build using GeckoView directly:

```bash
# Clone mozilla-mobile GeckoView example
git clone https://github.com/mozilla-mobile/android-components.git
cd android-components

# Apply WayneWolf patches
# (See advanced-build.md for details)
```

## Customization Files

### build-config.yml

Customize app name, package ID, and features:

```yaml
applicationId: org.waynewolf.browser
versionCode: 1
versionName: "1.0.0"

app:
  name: WayneWolf
  theme: dark

features:
  - profiles
  - privacy_hardening
  - extension_support
```

### Branding

Replace icons and assets:

```
packaging/android/branding/
├── mipmap-hdpi/
│   └── ic_launcher.png (72x72)
├── mipmap-mdpi/
│   └── ic_launcher.png (48x48)
├── mipmap-xhdpi/
│   └── ic_launcher.png (96x96)
├── mipmap-xxhdpi/
│   └── ic_launcher.png (144x144)
└── mipmap-xxxhdpi/
    └── ic_launcher.png (192x192)
```

### Privacy Settings

Configure default privacy settings in:
`packaging/android/privacy-settings.json`

## Signing the APK

### Generate a Keystore

```bash
keytool -genkey -v -keystore waynewolf-release.keystore \
    -alias waynewolf -keyalg RSA -keysize 2048 -validity 10000

# Save the keystore password securely!
```

### Sign the APK

```bash
# Install zipalign (part of Android build tools)
cd ~/Android/Sdk/build-tools/33.0.0

# Align the APK
./zipalign -v -p 4 app-release-unsigned.apk app-release-aligned.apk

# Sign with apksigner
./apksigner sign --ks waynewolf-release.keystore \
    --out app-release-signed.apk app-release-aligned.apk

# Verify signature
./apksigner verify app-release-signed.apk
```

## Distribution

### GitHub Releases

Upload the signed APK to GitHub releases:

```bash
gh release create v1.0.0 \
    app-release-signed.apk \
    --title "WayneWolf for Android v1.0.0" \
    --notes "Initial Android release"
```

### F-Droid

Submit to F-Droid for open-source distribution:

1. Fork F-Droid data repository
2. Create metadata file: `metadata/org.waynewolf.browser.yml`
3. Submit pull request

See: https://f-droid.org/docs/Submitting_to_F-Droid/

### Google Play Store

Requirements:
- Google Play Developer account ($25 one-time fee)
- Privacy policy URL
- App content rating
- Store listing (screenshots, description)

Steps:
1. Create app in Play Console
2. Fill in store listing
3. Upload signed APK
4. Submit for review

See: https://play.google.com/console/

### Self-Hosted Distribution

Host on your own server:

```bash
# Upload APK to your website
scp app-release-signed.apk user@yourserver.com:/var/www/downloads/

# Create download page with instructions
```

## Testing

### Install on Device

```bash
# Enable USB debugging on Android device
adb devices

# Install APK
adb install app-release-signed.apk

# Launch app
adb shell am start -n org.waynewolf.browser/.MainActivity
```

### Emulator Testing

```bash
# Create emulator
avdmanager create avd -n test -k "system-images;android-33;google_apis;x86_64"

# Start emulator
emulator -avd test

# Install and test
adb install app-release-signed.apk
```

## Profile System on Android

WayneWolf for Android includes the profile system:

### Implementation

```kotlin
// profiles/ProfileManager.kt
class ProfileManager {
    enum class ProfileType {
        DEVELOPMENT,
        WORK,
        ANONYMOUS
    }

    fun switchProfile(type: ProfileType) {
        // Apply profile-specific settings
    }
}
```

### UI Integration

Add profile switcher to menu:
- Settings → Profiles → [Dev | Work | Ghost]

## Features

### Android-Specific Features

- **Profile Templates:** Same dev, work, anonymous profiles as desktop
- **Extension Support:** Support for Firefox Android extensions
- **Privacy Hardening:** WebRTC blocking, fingerprinting resistance
- **Tor Integration:** Optional SOCKS proxy support
- **Dark Theme:** Minimalist dark UI
- **Offline Mode:** Cache for offline browsing

### Planned Features

- Sync with desktop profiles (via self-hosted server)
- QR code profile sharing
- Secure bookmarks encryption
- Advanced tracking protection

## Troubleshooting

### Build Fails with "NDK not found"

```bash
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/25.1.8937393
```

### Gradle Sync Issues

```bash
./gradlew clean
rm -rf .gradle
./gradlew build
```

### APK Too Large

Enable ProGuard/R8 shrinking in `build.gradle`:

```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

## Resources

- **Fenix Repository:** https://github.com/mozilla-mobile/fenix
- **GeckoView Docs:** https://mozilla.github.io/geckoview/
- **Android Developer Guide:** https://developer.android.com/guide
- **F-Droid Documentation:** https://f-droid.org/docs/

## Contributing

To contribute to WayneWolf for Android:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple devices/emulators
5. Submit a pull request

## License

WayneWolf for Android inherits the Mozilla Public License 2.0 from Firefox/Fenix.

See: https://www.mozilla.org/en-US/MPL/2.0/
