#!/bin/bash
# Sign a single WayneWolf APK
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

KEYSTORE="$HOME/.android/waynewolf.keystore"
UNSIGNED_APK="dist/android/waynewolf-arm64-v8a-release-unsigned.apk"
ALIGNED_APK="dist/android/waynewolf-arm64-v8a-release-aligned.apk"
SIGNED_APK="dist/android/waynewolf-arm64-v8a-release-SIGNED.apk"

# Find latest build-tools
BUILD_TOOLS_VERSION=$(ls -1 "$ANDROID_HOME/build-tools" | sort -V | tail -1)
BUILD_TOOLS_PATH="$ANDROID_HOME/build-tools/$BUILD_TOOLS_VERSION"

echo -e "${GREEN}WayneWolf APK Signer (Single APK)${NC}"
echo "========================================"
echo ""

if [ ! -f "$UNSIGNED_APK" ]; then
    echo -e "${RED}Error: Unsigned APK not found at $UNSIGNED_APK${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1: Aligning APK...${NC}"
"$BUILD_TOOLS_PATH/zipalign" -v -p 4 "$UNSIGNED_APK" "$ALIGNED_APK"

echo ""
echo -e "${YELLOW}Step 2: Signing APK...${NC}"
echo "You will be prompted for your keystore password"
echo ""

"$BUILD_TOOLS_PATH/apksigner" sign \
    --ks "$KEYSTORE" \
    --out "$SIGNED_APK" \
    "$ALIGNED_APK"

echo ""
echo -e "${YELLOW}Step 3: Verifying signature...${NC}"
"$BUILD_TOOLS_PATH/apksigner" verify "$SIGNED_APK"

echo ""
echo -e "${GREEN}✓ APK signed successfully!${NC}"
echo ""
echo "Signed APK: $SIGNED_APK"
echo "Size: $(du -h "$SIGNED_APK" | cut -f1)"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Transfer to phone:"
echo "   adb push \"$SIGNED_APK\" /sdcard/Download/"
echo ""
echo "2. Or copy to USB drive/cloud and download on phone"
echo ""
echo "3. Install from phone's Download folder"
echo ""
