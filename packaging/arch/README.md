# WayneWolf AUR Package

This directory contains PKGBUILD files for distributing WayneWolf via the Arch User Repository (AUR).

## Packages

### waynewolf
Full source build package. Builds WayneWolf from source on the user's machine.

**File:** `PKGBUILD`

**Advantages:**
- Always builds with latest optimizations for user's system
- No trust needed in pre-built binaries
- Follows Arch philosophy of building from source

**Disadvantages:**
- Long build time (~60-90 minutes)
- Requires significant disk space during build

### waynewolf-bin
Binary package. Downloads pre-built release from GitHub.

**File:** `PKGBUILD-bin`

**Advantages:**
- Fast installation (just downloads and extracts)
- No build dependencies needed
- Smaller disk space footprint

**Disadvantages:**
- Requires trust in pre-built binaries
- May not be optimized for specific CPU

## Publishing to AUR

### Initial Setup

1. **Create AUR account:**
   - Visit https://aur.archlinux.org/register
   - Set up SSH keys

2. **Add SSH key to AUR:**
   ```bash
   cat ~/.ssh/id_rsa.pub
   # Copy and paste to: https://aur.archlinux.org/account/
   ```

### Publishing waynewolf (source package)

```bash
# Clone AUR repository
git clone ssh://aur@aur.archlinux.org/waynewolf.git aur-waynewolf
cd aur-waynewolf

# Copy PKGBUILD
cp ../PKGBUILD .

# Generate .SRCINFO
makepkg --printsrcinfo > .SRCINFO

# Commit and push
git add PKGBUILD .SRCINFO
git commit -m "Initial commit: waynewolf v141.0"
git push
```

### Publishing waynewolf-bin (binary package)

```bash
# Clone AUR repository
git clone ssh://aur@aur.archlinux.org/waynewolf-bin.git aur-waynewolf-bin
cd aur-waynewolf-bin

# Copy PKGBUILD-bin as PKGBUILD
cp ../PKGBUILD-bin PKGBUILD

# Update SHA256 checksum
# First, download the release and get its checksum
wget https://github.com/WTmartin8089/waynewolf/releases/download/v141.0/waynewolf-141.0-linux-x86_64.tar.gz
sha256sum waynewolf-141.0-linux-x86_64.tar.gz

# Update the sha256sums line in PKGBUILD with the actual checksum

# Generate .SRCINFO
makepkg --printsrcinfo > .SRCINFO

# Commit and push
git add PKGBUILD .SRCINFO
git commit -m "Initial commit: waynewolf-bin v141.0"
git push
```

## Updating Packages

When releasing a new version:

1. **Update PKGBUILD:**
   ```bash
   # Update pkgver and pkgrel
   pkgver=141.1
   pkgrel=1
   ```

2. **Update checksums for -bin package:**
   ```bash
   # Download new release
   wget https://github.com/WTmartin8089/waynewolf/releases/download/v141.1/waynewolf-141.1-linux-x86_64.tar.gz

   # Get checksum
   sha256sum waynewolf-141.1-linux-x86_64.tar.gz

   # Update sha256sums in PKGBUILD
   ```

3. **Test locally:**
   ```bash
   makepkg -si
   ```

4. **Update AUR:**
   ```bash
   makepkg --printsrcinfo > .SRCINFO
   git add PKGBUILD .SRCINFO
   git commit -m "Update to v141.1"
   git push
   ```

## Testing Packages

Before publishing to AUR, test thoroughly:

```bash
# Test source package
cd packaging/arch
makepkg -si

# Test binary package
cd packaging/arch
mv PKGBUILD-bin PKGBUILD
makepkg -si
```

## Package Guidelines

Follow AUR guidelines:
- https://wiki.archlinux.org/title/AUR_submission_guidelines
- https://wiki.archlinux.org/title/PKGBUILD
- https://wiki.archlinux.org/title/Arch_package_guidelines

## Support

For package-related issues:
- Comment on AUR package page
- Open issue on GitHub repository
