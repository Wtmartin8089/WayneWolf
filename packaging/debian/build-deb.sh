#!/bin/bash
# WayneWolf Debian Package Builder
# Creates .deb packages for Debian/Ubuntu

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get version
if [ -f WayneWolf/version ]; then
    VERSION=$(cat WayneWolf/version | head -n1 | sed 's/-/_/g')
else
    VERSION="141.0_1"
fi

echo -e "${GREEN}WayneWolf Debian Package Builder${NC}"
echo "================================"
echo "Version: $VERSION"
echo ""

# Check if browser tarball exists
if [ ! -f librewolf-*.tar.xz ]; then
    echo -e "${RED}Error: librewolf-*.tar.xz not found!${NC}"
    echo "Please build WayneWolf first"
    exit 1
fi

# Create build directory
BUILDDIR="waynewolf-${VERSION}"
rm -rf "$BUILDDIR"
mkdir -p "$BUILDDIR"

# Create directory structure
echo -e "${YELLOW}Creating package structure...${NC}"
mkdir -p "$BUILDDIR/usr/lib/waynewolf"
mkdir -p "$BUILDDIR/usr/bin"
mkdir -p "$BUILDDIR/usr/share/waynewolf"
mkdir -p "$BUILDDIR/usr/share/applications"
mkdir -p "$BUILDDIR/usr/share/icons/hicolor/scalable/apps"
mkdir -p "$BUILDDIR/usr/share/icons/hicolor/48x48/apps"
mkdir -p "$BUILDDIR/usr/share/icons/hicolor/128x128/apps"
mkdir -p "$BUILDDIR/usr/share/icons/hicolor/256x256/apps"
mkdir -p "$BUILDDIR/usr/share/doc/waynewolf"
mkdir -p "$BUILDDIR/DEBIAN"

# Extract browser
echo -e "${YELLOW}Installing browser files...${NC}"
tar xf librewolf-*.tar.xz -C "$BUILDDIR/usr/lib/" --strip-components=1
if [ -d "$BUILDDIR/usr/lib/librewolf" ]; then
    mv "$BUILDDIR/usr/lib/librewolf" "$BUILDDIR/usr/lib/waynewolf"
fi

# Create launcher wrapper
cat > "$BUILDDIR/usr/bin/waynewolf" << 'EOF'
#!/bin/bash
# WayneWolf system launcher wrapper
export MOZ_ENABLE_WAYLAND=1
export MOZ_REQUIRE_SIGNING=0

BROWSER_DIR="/usr/lib/waynewolf"
SHARE_DIR="/usr/share/waynewolf"

# Run the launcher script
if [ -f "$SHARE_DIR/launch-waynewolf.sh" ]; then
    exec bash "$SHARE_DIR/launch-waynewolf.sh" "$@"
else
    exec "$BROWSER_DIR/librewolf" "$@"
fi
EOF
chmod +x "$BUILDDIR/usr/bin/waynewolf"

# Copy supporting files
echo -e "${YELLOW}Installing supporting files...${NC}"
cp launch-waynewolf.sh "$BUILDDIR/usr/share/waynewolf/"
cp install-extensions.sh "$BUILDDIR/usr/share/waynewolf/"
cp extensions.conf "$BUILDDIR/usr/share/waynewolf/"
cp user.js "$BUILDDIR/usr/share/waynewolf/"
cp -r profile-templates "$BUILDDIR/usr/share/waynewolf/"

# Copy desktop file
cp waynewolf.desktop "$BUILDDIR/usr/share/applications/"

# Copy icons
cp waynewolf.svg "$BUILDDIR/usr/share/icons/hicolor/scalable/apps/"
if [ -f waynewolf-48.png ]; then
    cp waynewolf-48.png "$BUILDDIR/usr/share/icons/hicolor/48x48/apps/waynewolf.png"
fi
if [ -f waynewolf-128.png ]; then
    cp waynewolf-128.png "$BUILDDIR/usr/share/icons/hicolor/128x128/apps/waynewolf.png"
fi
if [ -f waynewolf-256.png ]; then
    cp waynewolf-256.png "$BUILDDIR/usr/share/icons/hicolor/256x256/apps/waynewolf.png"
fi

# Copy documentation
cp README.md "$BUILDDIR/usr/share/doc/waynewolf/"

# Create copyright file
cat > "$BUILDDIR/usr/share/doc/waynewolf/copyright" << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: waynewolf
Upstream-Contact: Wayne Martin <your@email.com>
Source: https://github.com/WTmartin8089/waynewolf

Files: *
Copyright: 2024 Wayne Martin
License: MPL-2.0

License: MPL-2.0
 This Source Code Form is subject to the terms of the Mozilla Public
 License, v. 2.0. If a copy of the MPL was not distributed with this
 file, You can obtain one at http://mozilla.org/MPL/2.0/.
 .
 On Debian systems, the complete text of the Mozilla Public License
 can be found in "/usr/share/common-licenses/MPL-2.0".
EOF

# Create changelog
cat > "$BUILDDIR/usr/share/doc/waynewolf/changelog.Debian" << EOF
waynewolf ($VERSION) unstable; urgency=medium

  * Initial release
  * Based on LibreWolf 141.0
  * Profile template system
  * Minimalist UI
  * Privacy-focused configuration

 -- Wayne Martin <your@email.com>  $(date -R)
EOF
gzip -9 "$BUILDDIR/usr/share/doc/waynewolf/changelog.Debian"

# Create control file
echo -e "${YELLOW}Creating control file...${NC}"
cat > "$BUILDDIR/DEBIAN/control" << EOF
Package: waynewolf
Version: $VERSION
Section: web
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libdbus-glib-1-2, ffmpeg, libnss3, libpulse0
Recommends: tor
Suggests: fonts-liberation
Maintainer: Wayne Martin <your@email.com>
Homepage: https://github.com/WTmartin8089/waynewolf
Description: Privacy-focused browser with profile templates
 WayneWolf is a custom-built browser fork based on LibreWolf/Firefox,
 designed for minimalism, maximum privacy, and performance.
 .
 Features:
  * Minimalist UI - No distractions
  * Maximum Privacy - Fingerprint resistance, WebRTC blocking
  * Legacy Compatibility - Unsigned extensions work
  * Performance - GPU acceleration, aggressive caching
  * Profile Isolation - Three modes: dev, browse, ghost
 .
 WayneWolf features an advanced profile template system with
 auto-configured privacy settings and extensions.
EOF

# Create postinst script
cat > "$BUILDDIR/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database /usr/share/applications || true
fi

# Update icon cache
if command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache /usr/share/icons/hicolor || true
fi

exit 0
EOF
chmod +x "$BUILDDIR/DEBIAN/postinst"

# Create postrm script
cat > "$BUILDDIR/DEBIAN/postrm" << 'EOF'
#!/bin/bash
set -e

if [ "$1" = "remove" ] || [ "$1" = "purge" ]; then
    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        update-desktop-database /usr/share/applications || true
    fi

    # Update icon cache
    if command -v gtk-update-icon-cache &> /dev/null; then
        gtk-update-icon-cache /usr/share/icons/hicolor || true
    fi
fi

exit 0
EOF
chmod +x "$BUILDDIR/DEBIAN/postrm"

# Calculate installed size
echo -e "${YELLOW}Calculating package size...${NC}"
INSTALLED_SIZE=$(du -sk "$BUILDDIR" | cut -f1)
echo "Installed-Size: $INSTALLED_SIZE" >> "$BUILDDIR/DEBIAN/control"

# Build the package
echo -e "${YELLOW}Building .deb package...${NC}"
dpkg-deb --build "$BUILDDIR"

# Move to dist directory
mkdir -p dist
mv "${BUILDDIR}.deb" "dist/waynewolf_${VERSION}_amd64.deb"

# Clean up
rm -rf "$BUILDDIR"

echo ""
echo -e "${GREEN}Debian package created successfully!${NC}"
echo ""
echo "Package: dist/waynewolf_${VERSION}_amd64.deb"
echo ""
echo "To install:"
echo "  sudo dpkg -i dist/waynewolf_${VERSION}_amd64.deb"
echo "  sudo apt-get install -f  # Install dependencies if needed"
echo ""
echo "To verify:"
echo "  dpkg -c dist/waynewolf_${VERSION}_amd64.deb  # List contents"
echo "  lintian dist/waynewolf_${VERSION}_amd64.deb  # Check for issues"
echo ""
