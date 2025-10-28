#!/bin/bash
# Sign All WayneWolf Android APKs
# Signs and aligns all architecture-specific APKs for distribution

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

VERSION="1.0.0"
KEYSTORE="waynewolf-release.keystore"
KEY_ALIAS="waynewolf"

echo -e "${GREEN}WayneWolf APK Signer (Multi-Architecture)${NC}"
echo "=========================================="
echo ""

# Check if unsigned APKs exist
APK_DIR="dist/android"
if [ ! -d "$APK_DIR" ]; then
    echo -e "${RED}Error: APK directory not found at $APK_DIR${NC}"
    exit 1
fi

UNSIGNED_APKS=$(find "$APK_DIR" -name "*-unsigned.apk" 2>/dev/null)
if [ -z "$UNSIGNED_APKS" ]; then
    echo -e "${RED}Error: No unsigned APKs found in $APK_DIR${NC}"
    echo "Build the APKs first with: ./packaging/android/build-apk.sh"
    exit 1
fi

echo "Found $(echo "$UNSIGNED_APKS" | wc -l) unsigned APKs:"
echo "$UNSIGNED_APKS"
echo ""

# Check Android build tools
if [ -z "$ANDROID_HOME" ]; then
    echo -e "${RED}Error: ANDROID_HOME not set${NC}"
    exit 1
fi

BUILD_TOOLS="$ANDROID_HOME/build-tools"
if [ ! -d "$BUILD_TOOLS" ]; then
    echo -e "${RED}Error: Android build-tools not found${NC}"
    exit 1
fi

# Find latest build tools version
BUILD_TOOLS_VERSION=$(ls "$BUILD_TOOLS" | sort -V | tail -n1)
BUILD_TOOLS_PATH="$BUILD_TOOLS/$BUILD_TOOLS_VERSION"

echo "Using build-tools: $BUILD_TOOLS_VERSION"
echo ""

# Check if keystore exists
if [ ! -f "$KEYSTORE" ]; then
    echo -e "${YELLOW}Keystore not found. Creating new keystore...${NC}"
    echo ""
    echo "You will be prompted for keystore information."
    echo -e "${RED}IMPORTANT: Save the keystore password securely!${NC}"
    echo ""

    keytool -genkey -v -keystore "$KEYSTORE" \
        -alias "$KEY_ALIAS" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000

    echo ""
    echo -e "${GREEN}Keystore created: $KEYSTORE${NC}"
    echo -e "${RED}IMPORTANT: Back up this keystore file! You cannot update your app without it.${NC}"
    echo ""
fi

# Sign each APK
SIGNED_COUNT=0
for UNSIGNED_APK in $UNSIGNED_APKS; do
    # Extract architecture from filename
    BASENAME=$(basename "$UNSIGNED_APK")
    ARCH=$(echo "$BASENAME" | sed 's/app-\(.*\)-release-unsigned\.apk/\1/')

    echo -e "${YELLOW}Processing $ARCH APK...${NC}"

    # Define output paths
    ALIGNED_APK="${UNSIGNED_APK/-unsigned/-aligned}"
    SIGNED_APK="${UNSIGNED_APK/-unsigned/-signed}"

    # Align the APK
    echo "  Aligning..."
    "$BUILD_TOOLS_PATH/zipalign" -v -p 4 "$UNSIGNED_APK" "$ALIGNED_APK" > /dev/null 2>&1

    # Sign the APK
    echo "  Signing..."
    "$BUILD_TOOLS_PATH/apksigner" sign \
        --ks "$KEYSTORE" \
        --ks-key-alias "$KEY_ALIAS" \
        --out "$SIGNED_APK" \
        "$ALIGNED_APK"

    # Verify signature
    echo "  Verifying..."
    "$BUILD_TOOLS_PATH/apksigner" verify "$SIGNED_APK" > /dev/null 2>&1

    # Clean up intermediate file
    rm "$ALIGNED_APK"

    # Create checksum
    echo "  Creating checksum..."
    cd "$APK_DIR"
    sha256sum "$(basename "$SIGNED_APK")" > "$(basename "$SIGNED_APK").sha256"
    cd - > /dev/null

    echo -e "${GREEN}  ✓ $ARCH signed successfully!${NC}"
    echo ""

    SIGNED_COUNT=$((SIGNED_COUNT + 1))
done

echo ""
echo -e "${GREEN}All APKs signed successfully!${NC}"
echo "================================"
echo ""
echo "Signed APKs ($SIGNED_COUNT):"
find "$APK_DIR" -name "*-signed.apk" -exec du -h {} \; | sed 's/^/  /'
echo ""
echo "Install on device (example for arm64):"
echo "  adb install $APK_DIR/app-arm64-v8a-release-signed.apk"
echo ""
echo "Upload to GitHub releases:"
echo "  gh release upload v${VERSION}-android \\"
echo "    $APK_DIR/*-signed.apk \\"
echo "    $APK_DIR/*-signed.apk.sha256"
echo ""
echo -e "${YELLOW}REMINDER: Backup your keystore!${NC}"
echo "  cp $KEYSTORE ~/.ssh/"
echo ""
