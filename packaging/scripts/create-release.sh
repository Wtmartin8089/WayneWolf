#!/bin/bash
# WayneWolf Release Packaging Script
# Creates distributable release archives

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get version from WayneWolf build
if [ -f WayneWolf/version ]; then
    VERSION=$(cat WayneWolf/version | head -n1)
else
    echo -e "${RED}Error: WayneWolf/version file not found${NC}"
    exit 1
fi

# Create dist directory
DIST_DIR="dist"
mkdir -p "$DIST_DIR"

echo -e "${GREEN}WayneWolf Release Packager${NC}"
echo "=========================="
echo "Version: $VERSION"
echo ""

# Check if browser tarball exists
if [ ! -f librewolf-*.tar.xz ]; then
    echo -e "${RED}Error: librewolf-*.tar.xz not found!${NC}"
    echo "Please build WayneWolf first:"
    echo "  cd WayneWolf"
    echo "  make build"
    echo "  make package"
    exit 1
fi

# Create release archive
echo -e "${YELLOW}Creating release archive...${NC}"
RELEASE_NAME="waynewolf-${VERSION}-linux-x86_64"
RELEASE_DIR="$DIST_DIR/$RELEASE_NAME"

# Create temporary directory for release
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# Copy files
echo -e "${YELLOW}Copying files...${NC}"
cp librewolf-*.tar.xz "$RELEASE_DIR/"
cp launch-waynewolf.sh "$RELEASE_DIR/"
cp install-extensions.sh "$RELEASE_DIR/"
cp extensions.conf "$RELEASE_DIR/"
cp user.js "$RELEASE_DIR/"
cp install.sh "$RELEASE_DIR/"
cp -r profile-templates "$RELEASE_DIR/"
cp README.md "$RELEASE_DIR/"
cp BUILD_GUIDE.md "$RELEASE_DIR/" || true
cp QUICK_START.md "$RELEASE_DIR/" || true

# Copy desktop integration files
if [ -f waynewolf.desktop ]; then
    cp waynewolf.desktop "$RELEASE_DIR/"
fi
if [ -f waynewolf.svg ]; then
    cp waynewolf.svg "$RELEASE_DIR/"
fi
if [ -f waynewolf-48.png ]; then
    cp waynewolf-48.png "$RELEASE_DIR/"
fi
if [ -f waynewolf-128.png ]; then
    cp waynewolf-128.png "$RELEASE_DIR/"
fi
if [ -f waynewolf-256.png ]; then
    cp waynewolf-256.png "$RELEASE_DIR/"
fi

# Create LICENSE file if it doesn't exist
if [ ! -f LICENSE ]; then
    echo -e "${YELLOW}Creating LICENSE file...${NC}"
    cat > "$RELEASE_DIR/LICENSE" << 'EOF'
WayneWolf is based on LibreWolf, which is based on Mozilla Firefox.
All components are licensed under the Mozilla Public License 2.0 (MPL 2.0).

See: https://www.mozilla.org/en-US/MPL/2.0/
EOF
else
    cp LICENSE "$RELEASE_DIR/"
fi

# Create installation instructions
cat > "$RELEASE_DIR/INSTALL.txt" << 'EOF'
WayneWolf Installation Instructions
====================================

Quick Install:
--------------
./install.sh

This will install WayneWolf to ~/.local/

Custom Installation:
-------------------
./install.sh --prefix=/your/custom/path

Manual Installation:
-------------------
1. Extract browser:
   tar xf librewolf-*.tar.xz -C ~/.local/

2. Create symlink:
   ln -s ~/.local/librewolf/librewolf ~/.local/bin/waynewolf

3. Copy supporting files:
   mkdir -p ~/.local/share/waynewolf
   cp -r profile-templates ~/.local/share/waynewolf/
   cp user.js ~/.local/share/waynewolf/
   cp extensions.conf ~/.local/share/waynewolf/
   cp launch-waynewolf.sh ~/.local/share/waynewolf/
   cp install-extensions.sh ~/.local/share/waynewolf/

4. Install desktop file (optional):
   cp waynewolf.desktop ~/.local/share/applications/
   update-desktop-database ~/.local/share/applications/

First Launch:
------------
waynewolf                # Launch with default profile
waynewolf dev            # Development profile
waynewolf browse         # Work/browsing profile
waynewolf ghost          # Anonymous profile

For more information, see README.md

EOF

# Create tarball
echo -e "${YELLOW}Creating tarball...${NC}"
cd "$DIST_DIR"
tar czf "${RELEASE_NAME}.tar.gz" "$RELEASE_NAME"
cd ..

# Create checksum
echo -e "${YELLOW}Creating checksum...${NC}"
cd "$DIST_DIR"
sha256sum "${RELEASE_NAME}.tar.gz" > SHA256SUMS
cd ..

# Clean up temporary directory
rm -rf "$RELEASE_DIR"

# Print results
echo ""
echo -e "${GREEN}Release package created successfully!${NC}"
echo ""
echo "Release archive: $DIST_DIR/${RELEASE_NAME}.tar.gz"
echo "SHA256 checksum: $DIST_DIR/SHA256SUMS"
echo ""
echo "Checksum:"
cat "$DIST_DIR/SHA256SUMS"
echo ""
echo "Upload these files to GitHub Releases:"
echo "  gh release create v${VERSION} \\"
echo "    $DIST_DIR/${RELEASE_NAME}.tar.gz \\"
echo "    $DIST_DIR/SHA256SUMS"
echo ""
