# Getting Started with WayneWolf Distribution

This guide will help you start distributing WayneWolf to users on all platforms.

## Quick Start Checklist

### Phase 1: Initial Setup (30 minutes)

- [ ] Create GitHub repository
- [ ] Push WayneWolf code to GitHub
- [ ] Set up repository description and README
- [ ] Add topics: `browser`, `privacy`, `firefox`, `librewolf`

### Phase 2: First Release (1-2 hours)

1. **Build WayneWolf:**
   ```bash
   cd ~/WayneWolf/WayneWolf
   make fetch
   make dir
   make bootstrap
   make setup-wasi
   make build
   make package
   ```

2. **Create release package:**
   ```bash
   cd ~/WayneWolf
   ./packaging/scripts/create-release.sh
   ```

3. **Create GitHub release:**
   ```bash
   git tag -a v141.0 -m "Release v141.0"
   git push origin v141.0

   # Upload release files
   gh release create v141.0 \
     dist/waynewolf-*-linux-x86_64.tar.gz \
     dist/SHA256SUMS \
     --title "WayneWolf v141.0" \
     --notes "Initial release of WayneWolf"
   ```

### Phase 3: Package Managers (Week 1-2)

#### Arch User Repository (Easiest)

```bash
# Set up AUR SSH key
cat ~/.ssh/id_rsa.pub
# Add to: https://aur.archlinux.org/account/

# Publish binary package (fastest for users)
git clone ssh://aur@aur.archlinux.org/waynewolf-bin.git
cd waynewolf-bin
cp ../packaging/arch/PKGBUILD-bin PKGBUILD

# Update SHA256 checksum in PKGBUILD
# Get it from: dist/SHA256SUMS

makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "Initial commit: waynewolf-bin v141.0"
git push
```

#### AppImage (Universal Linux)

```bash
./packaging/appimage/build.sh

# Upload to GitHub release
gh release upload v141.0 dist/WayneWolf-*.AppImage*
```

### Phase 4: Advanced Packaging (Week 2-4)

#### Flatpak (Flathub)

See: `packaging/flatpak/README.md`

Requirements:
- Flathub account
- Valid AppData file
- Build testing

#### Debian Package

```bash
./packaging/debian/build-deb.sh

# Distribute via:
# - GitHub releases
# - Personal PPA
# - Direct download
```

#### Fedora RPM

```bash
./packaging/fedora/build-rpm.sh

# Distribute via:
# - GitHub releases
# - COPR repository
# - Direct download
```

### Phase 5: Mobile (Month 2)

#### Android Build

See: `packaging/android/README.md`

```bash
# Build APK
./packaging/android/build-apk.sh

# Sign APK
./packaging/android/sign-apk.sh

# Upload to GitHub
gh release upload v1.0.0-android \
  dist/android/waynewolf-*-release-signed.apk \
  dist/android/*.sha256
```

## Distribution Platforms

### Linux Desktop

| Platform | Users | Setup Time | Maintenance | Auto-Updates |
|----------|-------|------------|-------------|--------------|
| GitHub Releases | All Linux | 30 min | Low | Manual |
| AUR (Arch) | Arch users | 1 hour | Low | Yes (AUR helper) |
| AppImage | All Linux | 1 hour | Low | Manual |
| Flatpak/Flathub | All Linux | 2-4 hours | Medium | Yes |
| Debian/Ubuntu PPA | Debian/Ubuntu | 2-3 hours | Medium | Yes |
| Fedora COPR | Fedora/RHEL | 2-3 hours | Medium | Yes |

### Mobile

| Platform | Users | Setup Time | Maintenance | Cost |
|----------|-------|------------|-------------|------|
| GitHub Direct | Tech-savvy | 1 hour | Low | Free |
| F-Droid | Privacy users | 4-8 hours | Medium | Free |
| Google Play | All Android | 8-16 hours | High | $25 once |

## Automation

### GitHub Actions (Already Set Up!)

Your GitHub repository now has automated workflows:

- **Build on Push:** Tests every commit
- **Release on Tag:** Automatically builds and publishes releases

To trigger a release:
```bash
git tag -a v141.1 -m "Release v141.1"
git push origin v141.1
```

GitHub Actions will:
1. Build WayneWolf
2. Create release packages
3. Upload to GitHub Releases
4. Build AppImage (if enabled)

### Update Process

When LibreWolf/Firefox releases a new version:

```bash
cd ~/WayneWolf/WayneWolf

# Update version
echo "141.1-1" > version

# Build
make clean
make fetch
make build
make package

# Create release
cd ..
./packaging/scripts/create-release.sh

# Tag and push
git add .
git commit -m "Update to LibreWolf 141.1"
git tag -a v141.1 -m "Release v141.1"
git push origin main
git push origin v141.1
```

## Marketing & Reach

### 1. Social Media

Announce on:
- Reddit: r/privacy, r/linux, r/opensource, r/browsers
- Hacker News
- Mastodon/Fediverse
- Twitter/X
- Linux forums

### 2. Website (Optional)

Create a simple landing page:
- Domain: waynewolf.org (or similar)
- Host on GitHub Pages (free)
- Include download links, features, documentation

### 3. Documentation

Ensure good documentation:
- [x] README.md - Overview and features
- [x] BUILD_GUIDE.md - Build instructions
- [x] INSTALLATION_TEST.md - Testing guide
- [x] DISTRIBUTION.md - Distribution details
- [ ] CHANGELOG.md - Version history
- [ ] FAQ.md - Common questions

## Support Channels

Set up support:
1. **GitHub Issues** - Bug reports
2. **GitHub Discussions** - Questions and community
3. **Matrix/Discord** - Real-time chat (optional)
4. **Email** - Security reports

## Metrics

Track your success:
- GitHub stars and forks
- Release download counts
- AUR package votes
- Flathub installs (if published)

GitHub provides download statistics:
```bash
gh release view v141.0 --json assets
```

## Next Steps

### Immediate (This Week)

1. [x] Create packaging infrastructure ✓
2. [ ] Set up GitHub repository
3. [ ] Create first release
4. [ ] Publish to AUR

### Short Term (This Month)

1. [ ] Build and publish AppImage
2. [ ] Create project website
3. [ ] Announce on Reddit/social media
4. [ ] Write blog post about WayneWolf

### Long Term (2-3 Months)

1. [ ] Submit to Flathub
2. [ ] Build Android version
3. [ ] Submit to F-Droid
4. [ ] Create video demo
5. [ ] Build community

## Getting Help

- **Packaging Issues:** Check individual README files in `packaging/`
- **Build Problems:** See `BUILD_GUIDE.md`
- **GitHub Actions:** Check workflow files in `.github/workflows/`
- **Distribution Questions:** See `DISTRIBUTION.md`

## Success Stories

Once published, users will be able to install WayneWolf via:

```bash
# Arch Linux
yay -S waynewolf-bin

# AppImage
wget https://github.com/WTmartin8089/waynewolf/releases/latest/download/WayneWolf-x86_64.AppImage
chmod +x WayneWolf-x86_64.AppImage
./WayneWolf-x86_64.AppImage

# Flatpak (when published)
flatpak install flathub org.waynewolf.WayneWolf

# Manual install
wget https://github.com/WTmartin8089/waynewolf/releases/latest/download/waynewolf-linux-x86_64.tar.gz
tar xzf waynewolf-linux-x86_64.tar.gz
cd waynewolf-*
./install.sh
```

---

**You've got all the tools. Time to share WayneWolf with the world!**

The wolf is ready. Now hunt.
