# WayneWolf Distribution Guide

This guide covers how to distribute WayneWolf to users on all platforms.

## Table of Contents

1. [Desktop Distribution](#desktop-distribution)
2. [Mobile Distribution (Android)](#mobile-distribution-android)
3. [GitHub Releases](#github-releases)
4. [Package Managers](#package-managers)
5. [Web Presence](#web-presence)
6. [Automated Builds](#automated-builds)

---

## Desktop Distribution

### 1. Pre-Built Binaries (GitHub Releases)

**Recommended for most users**

Upload pre-built releases to GitHub:

```bash
# After building
cd ~/WayneWolf
tar czf waynewolf-${VERSION}-linux-x86_64.tar.gz \
    librewolf-*.tar.xz \
    launch-waynewolf.sh \
    install-extensions.sh \
    extensions.conf \
    user.js \
    profile-templates/ \
    README.md \
    LICENSE

# Create SHA256 checksum
sha256sum waynewolf-${VERSION}-linux-x86_64.tar.gz > SHA256SUMS
```

**Installation for end users:**
```bash
# Download from GitHub releases
wget https://github.com/YOUR_USERNAME/WayneWolf/releases/download/v1.0.0/waynewolf-1.0.0-linux-x86_64.tar.gz

# Verify checksum
sha256sum -c SHA256SUMS

# Extract and install
tar xzf waynewolf-1.0.0-linux-x86_64.tar.gz
cd waynewolf-1.0.0
./install.sh
```

### 2. AppImage (Universal Linux Package)

**Best for universal compatibility**

Create an AppImage that runs on any Linux distro:

```bash
# Install appimagetool
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

# Create AppDir structure (see packaging/appimage/build.sh)
./packaging/appimage/build.sh
```

Users can then download and run:
```bash
chmod +x WayneWolf-1.0.0-x86_64.AppImage
./WayneWolf-1.0.0-x86_64.AppImage
```

### 3. Flatpak (Sandboxed Distribution)

**Best for security-conscious users**

Flatpak provides sandboxing and universal distribution through Flathub.

See `packaging/flatpak/org.waynewolf.WayneWolf.yml` for manifest.

**Users install via:**
```bash
flatpak install flathub org.waynewolf.WayneWolf
flatpak run org.waynewolf.WayneWolf
```

### 4. Arch User Repository (AUR)

**For Arch Linux users**

Create a PKGBUILD for the AUR:

See `packaging/arch/PKGBUILD`

**Users install via:**
```bash
yay -S waynewolf
# or
paru -S waynewolf
```

### 5. Distribution-Specific Packages

**Debian/Ubuntu (.deb):**
```bash
# See packaging/debian/
./packaging/debian/build-deb.sh
```

**Fedora/RHEL (.rpm):**
```bash
# See packaging/fedora/
./packaging/fedora/build-rpm.sh
```

---

## Mobile Distribution (Android)

### Firefox for Android Fork

WayneWolf can be built for Android using Mozilla's Fenix (Firefox for Android) as a base.

#### Prerequisites

```bash
# Install Android SDK and NDK
sudo apt install android-sdk android-ndk

# Install Java
sudo apt install openjdk-17-jdk

# Set environment variables
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK_HOME="$HOME/Android/Sdk/ndk/25.1.8937393"
```

#### Build Process

```bash
# Clone Fenix repository
git clone https://github.com/mozilla-mobile/fenix.git waynewolf-android
cd waynewolf-android

# Apply WayneWolf customizations
cp ../mobile/android-config/* ./

# Build
./gradlew assembleRelease

# Output: app/build/outputs/apk/release/app-release.apk
```

#### Distribution Methods

**1. GitHub Releases**
- Upload APK to GitHub releases
- Users download and install manually
- Requires "Install from unknown sources" enabled

**2. F-Droid**
- Open-source app store
- Submit to F-Droid repository
- Users: https://f-droid.org

**3. Google Play Store**
- Requires developer account ($25 one-time)
- Must comply with Google policies
- Automatic updates for users

**4. Self-Hosted APK**
- Host on your website
- Users download via browser
- Provide installation instructions

#### Key Android Features to Implement

```kotlin
// mobile/android/waynewolf-config.yaml
app_name: "WayneWolf"
package_id: "org.waynewolf.browser"

features:
  - privacy_hardening
  - profile_templates
  - extension_support
  - fingerprint_resistance

default_profile: "work"
```

### iOS Support

**Unfortunately, iOS is extremely restricted:**

- Apple requires all browsers to use WebKit
- No true browser forks allowed on App Store
- Would need to be a WebKit wrapper, not Firefox-based

**Alternative:** Create a companion app that:
- Configures Safari privacy settings
- Manages bookmarks/profiles
- Provides privacy recommendations

---

## GitHub Releases

### Automated Release Workflow

Create `.github/workflows/release.yml`:

```yaml
name: Build and Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build-linux:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y rust-all cbindgen pigz

      - name: Build WayneWolf
        run: |
          cd WayneWolf
          make fetch
          make dir
          make bootstrap
          make setup-wasi
          make build
          make package

      - name: Create release archive
        run: ./packaging/create-release.sh

      - name: Upload to GitHub Releases
        uses: softprops/action-gh-release@v1
        with:
          files: |
            dist/waynewolf-*.tar.gz
            dist/waynewolf-*.AppImage
            dist/SHA256SUMS
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up JDK
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Build Android APK
        run: |
          cd mobile/android
          ./gradlew assembleRelease

      - name: Sign APK
        run: ./packaging/android/sign-apk.sh

      - name: Upload APK
        uses: softprops/action-gh-release@v1
        with:
          files: mobile/android/app/build/outputs/apk/release/waynewolf-*.apk
```

### Release Checklist

When creating a new release:

1. Update version numbers in:
   - `WayneWolf/version`
   - `README.md`
   - `packaging/*/version files`

2. Create changelog:
   ```bash
   git log --oneline v1.0.0..HEAD > CHANGELOG.md
   ```

3. Tag release:
   ```bash
   git tag -a v1.1.0 -m "Release v1.1.0"
   git push origin v1.1.0
   ```

4. GitHub Actions automatically builds and uploads releases

---

## Package Managers

### AUR Package

Create `packaging/arch/PKGBUILD`:

```bash
# Maintainer: Your Name <your@email.com>
pkgname=waynewolf
pkgver=1.0.0
pkgrel=1
pkgdesc="Privacy-focused browser with profile templates and extension management"
arch=('x86_64')
url="https://github.com/YOUR_USERNAME/waynewolf"
license=('MPL2')
depends=('gtk3' 'dbus-glib' 'ffmpeg')
makedepends=('rust' 'cbindgen' 'pigz')
source=("$pkgname-$pkgver.tar.gz::$url/archive/v$pkgver.tar.gz")
sha256sums=('SKIP')

build() {
    cd "$srcdir/$pkgname-$pkgver/WayneWolf"
    make fetch
    make dir
    make bootstrap
    make setup-wasi
    make build
    make package
}

package() {
    cd "$srcdir/$pkgname-$pkgver"

    # Install browser
    install -dm755 "$pkgdir/usr/lib/$pkgname"
    tar -xf WayneWolf/librewolf-*.tar.xz -C "$pkgdir/usr/lib/" --strip-components=1
    mv "$pkgdir/usr/lib/librewolf" "$pkgdir/usr/lib/$pkgname"

    # Install launcher and scripts
    install -Dm755 launch-waynewolf.sh "$pkgdir/usr/bin/$pkgname"
    install -Dm755 install-extensions.sh "$pkgdir/usr/share/$pkgname/install-extensions.sh"

    # Install configs
    install -Dm644 user.js "$pkgdir/usr/share/$pkgname/user.js"
    install -Dm644 extensions.conf "$pkgdir/usr/share/$pkgname/extensions.conf"

    # Install profile templates
    install -dm755 "$pkgdir/usr/share/$pkgname/profile-templates"
    cp -r profile-templates/* "$pkgdir/usr/share/$pkgname/profile-templates/"

    # Install desktop file
    install -Dm644 waynewolf.desktop "$pkgdir/usr/share/applications/waynewolf.desktop"

    # Install icon
    install -Dm644 waynewolf.svg "$pkgdir/usr/share/icons/hicolor/scalable/apps/waynewolf.svg"
}
```

**Upload to AUR:**
```bash
git clone ssh://aur@aur.archlinux.org/waynewolf.git aur-waynewolf
cd aur-waynewolf
cp ../packaging/arch/PKGBUILD .
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "Initial commit: waynewolf v1.0.0"
git push
```

### Flatpak Manifest

Create `packaging/flatpak/org.waynewolf.WayneWolf.yml`:

```yaml
app-id: org.waynewolf.WayneWolf
runtime: org.freedesktop.Platform
runtime-version: '23.08'
sdk: org.freedesktop.Sdk
command: waynewolf

finish-args:
  - --socket=x11
  - --share=network
  - --device=dri
  - --socket=pulseaudio
  - --filesystem=xdg-download

modules:
  - name: waynewolf
    buildsystem: simple
    build-commands:
      - make -C WayneWolf fetch
      - make -C WayneWolf build
      - make -C WayneWolf package
      - ./install.sh --prefix=/app
    sources:
      - type: archive
        url: https://github.com/YOUR_USERNAME/waynewolf/archive/v1.0.0.tar.gz
        sha256: YOUR_SHA256_HERE
```

---

## Web Presence

### 1. Official Website

Create a simple landing page:

**Domain:** `waynewolf.org` or similar

**Content:**
- Hero section with tagline
- Feature highlights
- Download buttons (Linux, Android, Source)
- Documentation links
- Screenshots/demos

**Tech stack:**
- Static site (Hugo, Jekyll, or plain HTML)
- Host on GitHub Pages (free)
- Custom domain via DNS

### 2. Documentation Site

Options:
- **GitHub Wiki** (easiest)
- **GitHub Pages + MkDocs** (better)
- **ReadTheDocs** (professional)

```bash
# Using MkDocs
pip install mkdocs mkdocs-material

# Create docs structure
mkdocs new .
# Edit mkdocs.yml and docs/

# Build and deploy
mkdocs gh-deploy
```

### 3. Social Presence

- **GitHub:** Main repository with releases
- **Reddit:** r/privacy, r/opensource
- **Mastodon/Fediverse:** Privacy-focused instance
- **Matrix/Discord:** Community chat

---

## Automated Builds

### Continuous Integration

**.github/workflows/build.yml:**

```yaml
name: Build WayneWolf

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y rust-all cbindgen pigz

    - name: Build
      run: |
        cd WayneWolf
        make fetch
        make dir
        make bootstrap
        make build

    - name: Test
      run: |
        ./test/run-tests.sh

    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: waynewolf-build
        path: WayneWolf/librewolf-*.tar.xz
```

---

## Quick Distribution Roadmap

### Phase 1: Core Distribution (Week 1-2)
1. ✅ Set up GitHub repository
2. Create GitHub Releases with pre-built Linux binaries
3. Write installation documentation
4. Create AUR package

### Phase 2: Packaging (Week 3-4)
1. Create AppImage
2. Create Flatpak package
3. Submit to Flathub
4. Create .deb and .rpm packages

### Phase 3: Mobile (Month 2)
1. Set up Android build environment
2. Create Android APK
3. Submit to F-Droid
4. Consider Google Play submission

### Phase 4: Web Presence (Month 2-3)
1. Create official website
2. Set up documentation site
3. Create video demos/tutorials
4. Announce on privacy/Linux communities

---

## Metrics & Success

Track adoption via:
- GitHub stars/forks
- Download counts (GitHub Releases)
- Package manager installs
- Website analytics
- Community engagement

---

## Legal Considerations

1. **License:** Ensure MPL 2.0 compliance (inherited from Firefox/LibreWolf)
2. **Trademark:** Don't use Firefox/Mozilla trademarks
3. **Privacy Policy:** If collecting any analytics
4. **Play Store:** Requires privacy policy and compliance

---

## Support Channels

Provide multiple support options:
- GitHub Issues (bugs)
- GitHub Discussions (questions)
- Matrix/Discord (real-time chat)
- Email (security issues)

---

## Next Steps

1. **Immediate:**
   ```bash
   # Create distribution scripts
   ./create-distribution-scripts.sh
   ```

2. **Set up GitHub:**
   - Create repository
   - Add release workflow
   - Upload first release

3. **Mobile build:**
   - Set up Android environment
   - Create first APK build

Want me to create any of these packaging scripts or set up the GitHub workflows?
