#!/bin/bash
# Sign WayneWolf Android APK
# Signs and aligns the APK for distribution

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

VERSION="1.0.0"
KEYSTORE="waynewolf-release.keystore"
KEY_ALIAS="waynewolf"

echo -e "${GREEN}WayneWolf APK Signer${NC}"
echo "===================="
echo ""

# Check if unsigned APK exists
UNSIGNED_APK="dist/android/waynewolf-${VERSION}-release-unsigned.apk"
if [ ! -f "$UNSIGNED_APK" ]; then
    echo -e "${RED}Error: Unsigned APK not found at $UNSIGNED_APK${NC}"
    echo "Build the APK first with: ./packaging/android/build-apk.sh"
    exit 1
fi

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
    echo "IMPORTANT: Save the keystore password securely!"
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

# Align the APK
echo -e "${YELLOW}Aligning APK...${NC}"
ALIGNED_APK="dist/android/waynewolf-${VERSION}-release-aligned.apk"
"$BUILD_TOOLS_PATH/zipalign" -v -p 4 "$UNSIGNED_APK" "$ALIGNED_APK"

# Sign the APK
echo -e "${YELLOW}Signing APK...${NC}"
SIGNED_APK="dist/android/waynewolf-${VERSION}-release-signed.apk"
"$BUILD_TOOLS_PATH/apksigner" sign \
    --ks "$KEYSTORE" \
    --ks-key-alias "$KEY_ALIAS" \
    --out "$SIGNED_APK" \
    "$ALIGNED_APK"

# Verify signature
echo -e "${YELLOW}Verifying signature...${NC}"
"$BUILD_TOOLS_PATH/apksigner" verify "$SIGNED_APK"

# Clean up intermediate file
rm "$ALIGNED_APK"

# Create checksum
echo -e "${YELLOW}Creating checksum...${NC}"
cd dist/android
sha256sum "waynewolf-${VERSION}-release-signed.apk" > "waynewolf-${VERSION}-release-signed.apk.sha256"
cd ../..

echo ""
echo -e "${GREEN}APK signed successfully!${NC}"
echo ""
echo "Signed APK: $SIGNED_APK"
echo "Checksum:   dist/android/waynewolf-${VERSION}-release-signed.apk.sha256"
echo ""
echo "APK size: $(du -h "$SIGNED_APK" | cut -f1)"
echo ""
echo "Install on device:"
echo "  adb install $SIGNED_APK"
echo ""
echo "Upload to GitHub releases:"
echo "  gh release upload v${VERSION} $SIGNED_APK dist/android/*.sha256"
echo ""
