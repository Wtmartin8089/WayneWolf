#!/bin/bash
# WayneWolf AppImage Builder
# Creates a portable AppImage that runs on any Linux distribution

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get version
if [ -f WayneWolf/version ]; then
    VERSION=$(cat WayneWolf/version | head -n1)
else
    VERSION="141.0"
fi

echo -e "${GREEN}WayneWolf AppImage Builder${NC}"
echo "=========================="
echo "Version: $VERSION"
echo ""

# Check if browser tarball exists
if [ ! -f librewolf-*.tar.xz ]; then
    echo -e "${RED}Error: librewolf-*.tar.xz not found!${NC}"
    echo "Please build WayneWolf first or extract from release package"
    exit 1
fi

# Create AppDir structure
echo -e "${YELLOW}Creating AppDir structure...${NC}"
APPDIR="WayneWolf.AppDir"
rm -rf "$APPDIR"
mkdir -p "$APPDIR"

# Extract browser to AppDir
echo -e "${YELLOW}Extracting browser...${NC}"
tar xf librewolf-*.tar.xz -C "$APPDIR/" --strip-components=1

# Rename librewolf to waynewolf in AppDir
if [ -d "$APPDIR/librewolf" ]; then
    mv "$APPDIR/librewolf" "$APPDIR/waynewolf"
fi

# Create usr structure
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/icons/hicolor/scalable/apps"
mkdir -p "$APPDIR/usr/share/icons/hicolor/256x256/apps"
mkdir -p "$APPDIR/usr/share/waynewolf"

# Copy supporting files
echo -e "${YELLOW}Copying supporting files...${NC}"
cp launch-waynewolf.sh "$APPDIR/usr/share/waynewolf/"
cp install-extensions.sh "$APPDIR/usr/share/waynewolf/"
cp extensions.conf "$APPDIR/usr/share/waynewolf/"
cp user.js "$APPDIR/usr/share/waynewolf/"
cp -r profile-templates "$APPDIR/usr/share/waynewolf/"

# Copy icons
if [ -f waynewolf.svg ]; then
    cp waynewolf.svg "$APPDIR/usr/share/icons/hicolor/scalable/apps/"
    cp waynewolf.svg "$APPDIR/waynewolf.svg"
fi
if [ -f waynewolf-256.png ]; then
    cp waynewolf-256.png "$APPDIR/usr/share/icons/hicolor/256x256/apps/waynewolf.png"
    cp waynewolf-256.png "$APPDIR/waynewolf.png"
fi

# Create AppRun script
echo -e "${YELLOW}Creating AppRun script...${NC}"
cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/bash
# WayneWolf AppImage runner

# Get AppImage directory
APPDIR="$(dirname "$(readlink -f "$0")")"

# Set environment variables
export MOZ_ENABLE_WAYLAND=1
export MOZ_REQUIRE_SIGNING=0
export LD_LIBRARY_PATH="$APPDIR/usr/lib:$LD_LIBRARY_PATH"
export PATH="$APPDIR/usr/bin:$PATH"

# Set profile directory
export WAYNEWOLF_PROFILE_DIR="${WAYNEWOLF_PROFILE_DIR:-$HOME/.waynewolf}"
export WAYNEWOLF_SHARE_DIR="$APPDIR/usr/share/waynewolf"

# Check if running launcher script or direct browser
if [ "$1" = "dev" ] || [ "$1" = "browse" ] || [ "$1" = "ghost" ] || \
   [ "$1" = "--create" ] || [ "$1" = "--list" ] || [ "$1" = "--reset" ]; then
    # Use launcher script for profile management
    exec bash "$APPDIR/usr/share/waynewolf/launch-waynewolf.sh" "$@"
else
    # Direct browser launch
    exec "$APPDIR/librewolf" "$@"
fi
EOF
chmod +x "$APPDIR/AppRun"

# Create desktop file for AppImage
cat > "$APPDIR/waynewolf.desktop" << EOF
[Desktop Entry]
Type=Application
Name=WayneWolf
GenericName=Web Browser
Comment=Privacy-focused browser with profile templates
Exec=waynewolf %u
Icon=waynewolf
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Actions=Development;Browse;Ghost;

[Desktop Action Development]
Name=Development Mode
Exec=waynewolf dev

[Desktop Action Browse]
Name=Work/Browse Mode
Exec=waynewolf browse

[Desktop Action Ghost]
Name=Anonymous Mode
Exec=waynewolf ghost
EOF

# Symlink desktop file to expected location
ln -sf ../waynewolf.desktop "$APPDIR/usr/share/applications/waynewolf.desktop"

# Create .DirIcon
if [ -f waynewolf-256.png ]; then
    cp waynewolf-256.png "$APPDIR/.DirIcon"
fi

# Check for appimagetool
if ! command -v appimagetool &> /dev/null; then
    echo -e "${YELLOW}Downloading appimagetool...${NC}"
    wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
    chmod +x appimagetool
    APPIMAGETOOL="./appimagetool"
else
    APPIMAGETOOL="appimagetool"
fi

# Build AppImage
echo -e "${YELLOW}Building AppImage...${NC}"
ARCH=x86_64 $APPIMAGETOOL "$APPDIR" "WayneWolf-${VERSION}-x86_64.AppImage"

# Move to dist directory
mkdir -p dist
mv "WayneWolf-${VERSION}-x86_64.AppImage" dist/

# Create checksum
echo -e "${YELLOW}Creating checksum...${NC}"
cd dist
sha256sum "WayneWolf-${VERSION}-x86_64.AppImage" > "WayneWolf-${VERSION}-x86_64.AppImage.sha256"
cd ..

# Clean up
rm -rf "$APPDIR"
if [ -f "./appimagetool" ]; then
    rm ./appimagetool
fi

echo ""
echo -e "${GREEN}AppImage created successfully!${NC}"
echo ""
echo "AppImage: dist/WayneWolf-${VERSION}-x86_64.AppImage"
echo "Checksum: dist/WayneWolf-${VERSION}-x86_64.AppImage.sha256"
echo ""
echo "To run:"
echo "  chmod +x dist/WayneWolf-${VERSION}-x86_64.AppImage"
echo "  ./dist/WayneWolf-${VERSION}-x86_64.AppImage"
echo ""
