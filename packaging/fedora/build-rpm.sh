#!/bin/bash
# WayneWolf RPM Package Builder
# Creates .rpm packages for Fedora/RHEL/CentOS

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get version
if [ -f WayneWolf/version ]; then
    VERSION=$(cat WayneWolf/version | head -n1 | cut -d'-' -f1)
else
    VERSION="141.0"
fi

echo -e "${GREEN}WayneWolf RPM Package Builder${NC}"
echo "=============================="
echo "Version: $VERSION"
echo ""

# Check if rpmbuild is installed
if ! command -v rpmbuild &> /dev/null; then
    echo -e "${RED}Error: rpmbuild not found!${NC}"
    echo "Install with: sudo dnf install rpm-build rpmdevtools"
    exit 1
fi

# Set up RPM build environment
echo -e "${YELLOW}Setting up RPM build environment...${NC}"
rpmdev-setuptree 2>/dev/null || true

RPMBUILD_DIR="$HOME/rpmbuild"

# Copy spec file
cp packaging/fedora/waynewolf.spec "$RPMBUILD_DIR/SPECS/"

# Create source tarball
echo -e "${YELLOW}Creating source tarball...${NC}"
TARBALL_DIR="waynewolf-${VERSION}"
rm -rf "/tmp/$TARBALL_DIR"
mkdir -p "/tmp/$TARBALL_DIR"

# Copy all necessary files
cp -r WayneWolf "/tmp/$TARBALL_DIR/"
cp launch-waynewolf.sh "/tmp/$TARBALL_DIR/"
cp install-extensions.sh "/tmp/$TARBALL_DIR/"
cp extensions.conf "/tmp/$TARBALL_DIR/"
cp user.js "/tmp/$TARBALL_DIR/"
cp -r profile-templates "/tmp/$TARBALL_DIR/"
cp waynewolf.desktop "/tmp/$TARBALL_DIR/"
cp waynewolf.svg "/tmp/$TARBALL_DIR/"
[ -f waynewolf-48.png ] && cp waynewolf-48.png "/tmp/$TARBALL_DIR/"
[ -f waynewolf-128.png ] && cp waynewolf-128.png "/tmp/$TARBALL_DIR/"
[ -f waynewolf-256.png ] && cp waynewolf-256.png "/tmp/$TARBALL_DIR/"
cp README.md "/tmp/$TARBALL_DIR/"

# Create LICENSE if it doesn't exist
if [ ! -f LICENSE ]; then
    cat > "/tmp/$TARBALL_DIR/LICENSE" << 'EOF'
WayneWolf is based on LibreWolf, which is based on Mozilla Firefox.
All components are licensed under the Mozilla Public License 2.0 (MPL 2.0).

See: https://www.mozilla.org/en-US/MPL/2.0/
EOF
else
    cp LICENSE "/tmp/$TARBALL_DIR/"
fi

# Create tarball
cd /tmp
tar czf "$RPMBUILD_DIR/SOURCES/waynewolf-${VERSION}.tar.gz" "$TARBALL_DIR"
cd - > /dev/null

# Clean up
rm -rf "/tmp/$TARBALL_DIR"

# Build RPM
echo -e "${YELLOW}Building RPM package...${NC}"
echo "This may take 60-90 minutes..."
rpmbuild -ba "$RPMBUILD_DIR/SPECS/waynewolf.spec"

# Copy built packages to dist directory
echo -e "${YELLOW}Copying packages to dist/...${NC}"
mkdir -p dist
cp "$RPMBUILD_DIR/RPMS/x86_64/waynewolf-${VERSION}"*.rpm dist/ 2>/dev/null || true
cp "$RPMBUILD_DIR/SRPMS/waynewolf-${VERSION}"*.src.rpm dist/ 2>/dev/null || true

echo ""
echo -e "${GREEN}RPM package created successfully!${NC}"
echo ""
echo "Binary RPM: dist/waynewolf-${VERSION}*.x86_64.rpm"
echo "Source RPM: dist/waynewolf-${VERSION}*.src.rpm"
echo ""
echo "To install:"
echo "  sudo dnf install dist/waynewolf-${VERSION}*.x86_64.rpm"
echo ""
echo "To verify:"
echo "  rpm -qpl dist/waynewolf-${VERSION}*.x86_64.rpm  # List contents"
echo "  rpmlint dist/waynewolf-${VERSION}*.x86_64.rpm   # Check for issues"
echo ""
