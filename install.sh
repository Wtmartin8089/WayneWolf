#!/bin/bash
# WayneWolf Installation Script
# Installs WayneWolf browser to user's local directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default installation directory
INSTALL_DIR="$HOME/.local"
BIN_DIR="$HOME/.local/bin"
SHARE_DIR="$HOME/.local/share"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --prefix=*)
            INSTALL_DIR="${1#*=}"
            BIN_DIR="$INSTALL_DIR/bin"
            SHARE_DIR="$INSTALL_DIR/share"
            shift
            ;;
        --prefix)
            INSTALL_DIR="$2"
            BIN_DIR="$INSTALL_DIR/bin"
            SHARE_DIR="$INSTALL_DIR/share"
            shift 2
            ;;
        -h|--help)
            echo "WayneWolf Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --prefix=DIR    Install to DIR (default: $HOME/.local)"
            echo "  -h, --help      Show this help message"
            echo ""
            echo "This will install:"
            echo "  - Browser binary to $INSTALL_DIR/librewolf"
            echo "  - Launcher script to $BIN_DIR/waynewolf"
            echo "  - Supporting files to $SHARE_DIR/waynewolf"
            echo "  - Desktop file to $SHARE_DIR/applications"
            echo "  - Icon to $SHARE_DIR/icons"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo -e "${GREEN}WayneWolf Installation Script${NC}"
echo "=============================="
echo ""
echo "Installation directory: $INSTALL_DIR"
echo ""

# Check if LibreWolf tarball exists
if [ ! -f librewolf-*.tar.xz ]; then
    echo -e "${RED}Error: librewolf-*.tar.xz not found!${NC}"
    echo "Please build WayneWolf first:"
    echo "  cd WayneWolf"
    echo "  make build"
    echo "  make package"
    exit 1
fi

# Create directories
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$SHARE_DIR/waynewolf"
mkdir -p "$SHARE_DIR/applications"
mkdir -p "$SHARE_DIR/icons/hicolor/scalable/apps"
mkdir -p "$SHARE_DIR/icons/hicolor/48x48/apps"
mkdir -p "$SHARE_DIR/icons/hicolor/128x128/apps"
mkdir -p "$SHARE_DIR/icons/hicolor/256x256/apps"

# Extract browser
echo -e "${YELLOW}Installing browser...${NC}"
tar xf librewolf-*.tar.xz -C "$INSTALL_DIR/"

# Install launcher script
echo -e "${YELLOW}Installing launcher script...${NC}"
cat > "$BIN_DIR/waynewolf" << 'LAUNCHER_EOF'
#!/bin/bash
# WayneWolf Launcher
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
BROWSER_DIR="$HOME/.local/librewolf"
SHARE_DIR="$HOME/.local/share/waynewolf"

# If installed system-wide, adjust paths
if [ ! -d "$BROWSER_DIR" ]; then
    if [ -d "/usr/lib/waynewolf" ]; then
        BROWSER_DIR="/usr/lib/waynewolf"
        SHARE_DIR="/usr/share/waynewolf"
    fi
fi

# Set up environment
export MOZ_ENABLE_WAYLAND=1
export MOZ_REQUIRE_SIGNING=0

# Run the actual launcher script
if [ -f "$SHARE_DIR/launch-waynewolf.sh" ]; then
    exec "$SHARE_DIR/launch-waynewolf.sh" "$@"
else
    # Fallback to direct execution
    exec "$BROWSER_DIR/librewolf" "$@"
fi
LAUNCHER_EOF
chmod +x "$BIN_DIR/waynewolf"

# Install supporting files
echo -e "${YELLOW}Installing supporting files...${NC}"
cp launch-waynewolf.sh "$SHARE_DIR/waynewolf/"
chmod +x "$SHARE_DIR/waynewolf/launch-waynewolf.sh"
cp install-extensions.sh "$SHARE_DIR/waynewolf/"
chmod +x "$SHARE_DIR/waynewolf/install-extensions.sh"
cp extensions.conf "$SHARE_DIR/waynewolf/"
cp user.js "$SHARE_DIR/waynewolf/"

# Install profile templates
echo -e "${YELLOW}Installing profile templates...${NC}"
cp -r profile-templates "$SHARE_DIR/waynewolf/"

# Install desktop file
echo -e "${YELLOW}Installing desktop integration...${NC}"
if [ -f waynewolf.desktop ]; then
    # Update paths in desktop file
    sed "s|Exec=.*|Exec=$BIN_DIR/waynewolf %u|g" waynewolf.desktop > "$SHARE_DIR/applications/waynewolf.desktop"
fi

# Install icons
if [ -f waynewolf.svg ]; then
    cp waynewolf.svg "$SHARE_DIR/icons/hicolor/scalable/apps/"
fi
if [ -f waynewolf-48.png ]; then
    cp waynewolf-48.png "$SHARE_DIR/icons/hicolor/48x48/apps/waynewolf.png"
fi
if [ -f waynewolf-128.png ]; then
    cp waynewolf-128.png "$SHARE_DIR/icons/hicolor/128x128/apps/waynewolf.png"
fi
if [ -f waynewolf-256.png ]; then
    cp waynewolf-256.png "$SHARE_DIR/icons/hicolor/256x256/apps/waynewolf.png"
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    echo -e "${YELLOW}Updating desktop database...${NC}"
    update-desktop-database "$SHARE_DIR/applications" 2>/dev/null || true
fi

# Update icon cache
if command -v gtk-update-icon-cache &> /dev/null; then
    echo -e "${YELLOW}Updating icon cache...${NC}"
    gtk-update-icon-cache "$SHARE_DIR/icons/hicolor" 2>/dev/null || true
fi

# Print completion message
echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "WayneWolf has been installed to: $INSTALL_DIR"
echo ""
echo "To launch WayneWolf:"
echo "  waynewolf                # Launch with default profile"
echo "  waynewolf dev            # Development profile"
echo "  waynewolf browse         # Work/browsing profile"
echo "  waynewolf ghost          # Anonymous profile"
echo ""
echo "To create a new profile:"
echo "  waynewolf --create myprofile work"
echo ""
echo "For more information, see:"
echo "  waynewolf --help"
echo ""

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}Warning: $BIN_DIR is not in your PATH${NC}"
    echo "Add this to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

echo -e "${GREEN}Happy browsing with WayneWolf!${NC}"
