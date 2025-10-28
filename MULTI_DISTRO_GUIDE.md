# WayneWolf Multi-Distribution Guide

WayneWolf Browser is now available for multiple Linux distributions and Android. This guide covers installation and packaging for all supported platforms.

## Table of Contents

- [Arch Linux (AUR)](#arch-linux-aur)
- [Flatpak (Universal)](#flatpak-universal)
- [Debian/Ubuntu (.deb)](#debianubuntu-deb)
- [Fedora/RHEL (.rpm)](#fedorarhel-rpm)
- [Android (.apk)](#android-apk)

---

## Arch Linux (AUR)

### Installation

```bash
# Using yay
yay -S waynewolf

# Using paru
paru -S waynewolf

# Manual installation
git clone https://aur.archlinux.org/waynewolf.git
cd waynewolf
makepkg -si
```

### Building from Source

The AUR package automatically fetches and builds from the official GitHub release:

```bash
# PKGBUILD location
packaging/arch/PKGBUILD

# Update and push to AUR
cd /path/to/aur-repo
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "Update to v141.0"
git push
```

**Status:** ✅ Production Ready

---

## Flatpak (Universal)

Flatpak provides a universal package that works across all Linux distributions.

### Installation

```bash
# Add Flathub repository (if not already added)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install WayneWolf (once published to Flathub)
flatpak install flathub com.waynewolf.Browser

# Run WayneWolf
flatpak run com.waynewolf.Browser
```

### Building the Flatpak

```bash
# Install flatpak-builder
sudo pacman -S flatpak-builder  # Arch
sudo apt install flatpak-builder  # Debian/Ubuntu
sudo dnf install flatpak-builder  # Fedora

# Build from manifest
cd packaging/flatpak
flatpak-builder --user --install --force-clean build com.waynewolf.Browser.yml

# Test run
flatpak run com.waynewolf.Browser

# Create .flatpak bundle for distribution
flatpak build-bundle ~/.local/share/flatpak/repo waynewolf.flatpak com.waynewolf.Browser
```

### Publishing to Flathub

1. Fork the Flathub repository: https://github.com/flathub/flathub
2. Submit a pull request with `packaging/flatpak/com.waynewolf.Browser.yml`
3. Wait for review and approval

**Manifest Location:** `packaging/flatpak/com.waynewolf.Browser.yml`

**Status:** 🔧 Ready for Testing

---

## Debian/Ubuntu (.deb)

### Installation

```bash
# Download .deb package from GitHub releases
wget https://github.com/WTmartin8089/waynewolf/releases/download/v141.0/waynewolf_141.0-1_amd64.deb

# Install
sudo dpkg -i waynewolf_141.0-1_amd64.deb

# Fix dependencies if needed
sudo apt-get install -f
```

### Building the .deb Package

```bash
# Install build dependencies
sudo apt-get install devscripts debhelper cbindgen cargo rustc python3 \
    nodejs yasm clang llvm libx11-dev libgtk-3-dev libdbus-glib-1-dev \
    libpulse-dev zip unzip nasm

# Prepare source directory
mkdir -p /tmp/waynewolf-build
cd /tmp/waynewolf-build
tar xf librewolf-141.0-1.source.tar.gz
cp -r /path/to/WayneWolf/packaging/debian librewolf-141.0/

# Build package
cd librewolf-141.0
dpkg-buildpackage -us -uc -b

# Result: waynewolf_141.0-1_amd64.deb in parent directory
```

### Package Files

- `packaging/debian/control` - Package metadata and dependencies
- `packaging/debian/changelog` - Version history
- `packaging/debian/rules` - Build rules
- `packaging/debian/copyright` - License information
- `packaging/debian/compat` - Debhelper compatibility version

**Status:** 🔧 Ready for Testing

---

## Fedora/RHEL (.rpm)

### Installation

```bash
# Download .rpm package from GitHub releases
wget https://github.com/WTmartin8089/waynewolf/releases/download/v141.0/waynewolf-141.0-1.x86_64.rpm

# Install on Fedora
sudo dnf install waynewolf-141.0-1.x86_64.rpm

# Install on RHEL/CentOS
sudo yum install waynewolf-141.0-1.x86_64.rpm
```

### Building the .rpm Package

```bash
# Install build dependencies
sudo dnf install rpm-build rpmdevtools rust cargo cbindgen python3 \
    nodejs yasm nasm clang llvm gcc-c++ gtk3-devel libXt-devel \
    dbus-glib-devel pulseaudio-libs-devel alsa-lib-devel zip unzip

# Set up RPM build environment
rpmdev-setuptree

# Copy spec file and source
cp packaging/rpm/waynewolf.spec ~/rpmbuild/SPECS/
wget -P ~/rpmbuild/SOURCES/ \
    https://github.com/WTmartin8089/waynewolf/releases/download/v141.0/librewolf-141.0-1.source.tar.gz

# Build RPM
cd ~/rpmbuild/SPECS
rpmbuild -ba waynewolf.spec

# Result: ~/rpmbuild/RPMS/x86_64/waynewolf-141.0-1.x86_64.rpm
```

**Spec File Location:** `packaging/rpm/waynewolf.spec`

**Status:** 🔧 Ready for Testing

---

## Android (.apk)

### Installation

#### Prerequisites
- Android 5.0 (Lollipop) or higher
- Enable "Unknown sources" in Settings → Security

#### Install Steps

1. Download the appropriate APK for your device architecture:
   - `waynewolf-arm64-v8a-release-signed.apk` (Most modern phones - Snapdragon, Exynos, etc.)
   - `waynewolf-armeabi-v7a-release-signed.apk` (Older ARM devices)
   - `waynewolf-x86-release-signed.apk` (Intel/AMD x86 tablets)
   - `waynewolf-x86_64-release-signed.apk` (Intel/AMD x86_64 devices)

2. Open the APK file on your device
3. Grant installation permission when prompted
4. Launch WayneWolf from your app drawer

**Not sure which APK to download?** Most modern phones (2018+) use arm64-v8a.

### Building Android APKs

#### Prerequisites

```bash
# Set Android SDK path
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Install Java 17
sudo pacman -S jdk17-openjdk  # Arch
sudo apt install openjdk-17-jdk  # Debian/Ubuntu
sudo dnf install java-17-openjdk-devel  # Fedora

# Install Rust Android targets
rustup target add aarch64-linux-android
rustup target add armv7-linux-androideabi
rustup target add i686-linux-android
rustup target add x86_64-linux-android
```

#### Build Process

```bash
cd /path/to/WayneWolf

# Build all APKs (takes 20-30 minutes)
./packaging/android/build-waynewolf-apk.sh

# Sign APKs
./packaging/android/sign-all-apks.sh

# APKs location: dist/android/waynewolf-*-release-signed.apk
```

#### What Makes This Build Different

WayneWolf Android uses a **proven package name change strategy** based on Mull Browser:

```bash
# Package changes applied:
# 1. Base applicationId: org.mozilla → org.waynewolf
# 2. Suffix: .firefox → .browser
# 3. Final package: org.waynewolf.browser
# 4. sharedUserId: Updated to match new package
```

This ensures WayneWolf can be installed alongside Firefox without conflicts.

**Build Script:** `packaging/android/build-waynewolf-apk.sh`

**Status:** 🔄 Building Now (Package name fix implemented)

---

## Distribution Comparison

| Platform | Install Command | Package Format | Status |
|----------|----------------|----------------|--------|
| **Arch Linux** | `yay -S waynewolf` | `.pkg.tar.zst` | ✅ Production |
| **Universal** | `flatpak install com.waynewolf.Browser` | `.flatpak` | 🔧 Ready |
| **Debian/Ubuntu** | `sudo dpkg -i waynewolf.deb` | `.deb` | 🔧 Ready |
| **Fedora/RHEL** | `sudo dnf install waynewolf.rpm` | `.rpm` | 🔧 Ready |
| **Android** | Install APK manually | `.apk` | 🔄 Building |

---

## Publishing Checklist

### For Each Release

- [ ] Update version numbers in all packaging files
- [ ] Create GitHub release with source tarball
- [ ] Calculate and update SHA256 checksums
- [ ] Build and test each package format
- [ ] Upload packages to GitHub releases
- [ ] Update AUR package
- [ ] Submit to Flathub (Flatpak)
- [ ] Announce on project website/social media

### Package-Specific Tasks

#### AUR (Arch Linux)
- [ ] Update PKGBUILD with new version and checksum
- [ ] Generate new .SRCINFO
- [ ] Push to AUR repository

#### Flatpak
- [ ] Update manifest with new version and checksum
- [ ] Test build locally
- [ ] Submit PR to Flathub

#### Debian
- [ ] Update changelog with new version
- [ ] Build .deb package
- [ ] Test installation on Ubuntu/Debian
- [ ] Upload to GitHub releases

#### RPM
- [ ] Update spec file with new version
- [ ] Build .rpm package
- [ ] Test installation on Fedora/RHEL
- [ ] Upload to GitHub releases

#### Android
- [ ] Build all 4 architecture variants
- [ ] Sign all APKs
- [ ] Verify package name is correct
- [ ] Test installation on physical devices
- [ ] Upload to GitHub releases

---

## Support & Issues

- **GitHub Issues:** https://github.com/WTmartin8089/waynewolf/issues
- **AUR Comments:** https://aur.archlinux.org/packages/waynewolf

---

## License

WayneWolf is released under the Mozilla Public License 2.0 (MPL-2.0).

Built with Claude Code.
