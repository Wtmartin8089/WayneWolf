# WayneWolf Packaging

This directory contains packaging configurations for distributing WayneWolf across all platforms.

## Directory Structure

```
packaging/
├── arch/           # Arch Linux (AUR) packages
│   ├── PKGBUILD            # Source package
│   ├── PKGBUILD-bin        # Binary package
│   └── README.md
├── appimage/       # Universal Linux AppImage
│   ├── build.sh
│   └── README.md (coming soon)
├── flatpak/        # Flatpak/Flathub package
│   ├── org.waynewolf.WayneWolf.yml
│   ├── org.waynewolf.WayneWolf.appdata.xml
│   └── README.md
├── debian/         # Debian/Ubuntu .deb packages
│   ├── build-deb.sh
│   └── README.md (coming soon)
├── fedora/         # Fedora/RHEL .rpm packages
│   ├── waynewolf.spec
│   ├── build-rpm.sh
│   └── README.md (coming soon)
├── android/        # Android APK build
│   ├── build-apk.sh
│   ├── sign-apk.sh
│   └── README.md
└── scripts/        # Shared packaging scripts
    └── create-release.sh
```

## Quick Start

### 1. Create a GitHub Release Package

```bash
# After building WayneWolf
./packaging/scripts/create-release.sh
```

Output: `dist/waynewolf-VERSION-linux-x86_64.tar.gz`

### 2. Build Platform-Specific Packages

```bash
# AppImage (universal Linux)
./packaging/appimage/build.sh

# Debian package
./packaging/debian/build-deb.sh

# Fedora RPM
./packaging/fedora/build-rpm.sh

# Android APK
./packaging/android/build-apk.sh
./packaging/android/sign-apk.sh
```

### 3. Publish to Package Managers

See individual README files in each platform directory.

## Supported Platforms

### Linux Desktop

| Format | File | Installation | Auto-Updates |
|--------|------|--------------|--------------|
| **Tarball** | `.tar.gz` | Manual extract | No |
| **AUR** | PKGBUILD | `yay -S waynewolf-bin` | Yes |
| **AppImage** | `.AppImage` | Direct run | No |
| **Flatpak** | Flathub | `flatpak install` | Yes |
| **Debian** | `.deb` | `dpkg -i` or `apt` | Via PPA |
| **Fedora** | `.rpm` | `dnf install` | Via COPR |

### Mobile

| Platform | File | Distribution | Cost |
|----------|------|--------------|------|
| **Android** | `.apk` | F-Droid, GitHub, Play Store | Free/\$25 |
| **iOS** | N/A | Not feasible (WebKit only) | - |

## Build Requirements

### All Platforms
- Built WayneWolf tarball (`librewolf-*.tar.xz`)
- Supporting files (scripts, configs, icons)

### Platform-Specific

**Arch (AUR):**
- AUR account with SSH key
- `makepkg` tool

**AppImage:**
- `appimagetool` (auto-downloaded)

**Flatpak:**
- `flatpak-builder`
- Flatpak SDK and runtimes

**Debian:**
- `dpkg-deb` tool (usually pre-installed)

**Fedora:**
- `rpmbuild`, `rpmdevtools`

**Android:**
- Android SDK & NDK
- Java 17
- Gradle

## Packaging Workflow

### For Each Release

1. **Update version numbers:**
   - `WayneWolf/version`
   - Package manifests (PKGBUILD, .spec, etc.)

2. **Build WayneWolf:**
   ```bash
   cd WayneWolf
   make clean
   make fetch
   make build
   make package
   cd ..
   ```

3. **Create release package:**
   ```bash
   ./packaging/scripts/create-release.sh
   ```

4. **Build platform packages:**
   ```bash
   # Choose which platforms to build
   ./packaging/appimage/build.sh
   ./packaging/debian/build-deb.sh
   ./packaging/fedora/build-rpm.sh
   ```

5. **Test installations:**
   - Test each package format
   - Verify profiles work
   - Check extensions install correctly

6. **Upload to GitHub:**
   ```bash
   gh release create v141.0 \
     dist/waynewolf-*.tar.gz \
     dist/WayneWolf-*.AppImage* \
     dist/waynewolf_*.deb \
     dist/waynewolf-*.rpm \
     dist/SHA256SUMS
   ```

7. **Update package managers:**
   - Update AUR with new version
   - Submit Flatpak update
   - Announce release

## Automated Builds

GitHub Actions workflows (in `.github/workflows/`) automatically:

- **On every push:** Build and test WayneWolf
- **On tag push:** Create release packages and upload to GitHub Releases

To trigger an automated release:
```bash
git tag -a v141.0 -m "Release v141.0"
git push origin v141.0
```

## Distribution Checklist

When releasing a new version:

- [ ] Update version in `WayneWolf/version`
- [ ] Update CHANGELOG.md
- [ ] Build WayneWolf
- [ ] Create release package
- [ ] Build platform packages
- [ ] Test all packages
- [ ] Create git tag
- [ ] Push tag (triggers GitHub Actions)
- [ ] Update AUR packages
- [ ] Update Flatpak manifest (if published)
- [ ] Announce release

## Package Maintenance

### AUR Updates

```bash
cd aur-waynewolf-bin

# Update PKGBUILD
vim PKGBUILD  # Change pkgver and sha256sums

# Regenerate .SRCINFO
makepkg --printsrcinfo > .SRCINFO

# Commit and push
git add PKGBUILD .SRCINFO
git commit -m "Update to v141.1"
git push
```

### Flatpak Updates

```bash
# In Flathub fork
vim org.waynewolf.WayneWolf.yml  # Update version and commit SHA

git commit -m "Update to v141.1"
git push

# Create PR to Flathub
```

## Signing Keys

### Android APK Signing

Generate keystore:
```bash
keytool -genkey -v -keystore waynewolf-release.keystore \
    -alias waynewolf -keyalg RSA -keysize 2048 -validity 10000
```

**IMPORTANT:** Backup the keystore! You cannot update the app without it.

### RPM Signing (Optional)

Generate GPG key:
```bash
gpg --full-generate-key

# Export public key
gpg --export -a "Your Name" > RPM-GPG-KEY-waynewolf
```

## Troubleshooting

### Build Fails

Check individual package README files for platform-specific issues.

### Package Too Large

- Enable compression in package scripts
- Remove debug symbols
- Check for duplicated files

### Missing Dependencies

Each package manifest lists required dependencies. Ensure they're correctly specified.

## Resources

- **AUR Guidelines:** https://wiki.archlinux.org/title/AUR_submission_guidelines
- **Flatpak Docs:** https://docs.flatpak.org/
- **Debian Policy:** https://www.debian.org/doc/debian-policy/
- **Fedora Packaging:** https://docs.fedoraproject.org/en-US/packaging-guidelines/
- **Android Distribution:** https://developer.android.com/studio/publish

## Contributing

To improve packaging:

1. Test packages on different distributions
2. Report issues specific to each package format
3. Suggest improvements to build scripts
4. Help maintain package repositories

## Support

For packaging-specific questions:
- Check individual platform README files
- Open issue on GitHub
- Ask in GitHub Discussions

---

Happy packaging! Let's get WayneWolf to everyone. 🐺
