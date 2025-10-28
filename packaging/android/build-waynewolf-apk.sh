#!/bin/bash
# WayneWolf Android Build Script
# Based on Mull Browser's successful package name change approach
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

VERSION="141.0"
APP_NAME="WayneWolf"
OLD_PACKAGE_BASE="org.mozilla"
NEW_PACKAGE_BASE="org.waynewolf"
OLD_SUFFIX=".firefox"
NEW_SUFFIX=".browser"
FULL_PACKAGE_NAME="${NEW_PACKAGE_BASE}${NEW_SUFFIX}"

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}WayneWolf Android APK Builder${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Version: $VERSION"
echo "Package: $FULL_PACKAGE_NAME"
echo "Based on Mull Browser's proven approach"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if [ -z "$ANDROID_HOME" ]; then
    echo -e "${RED}Error: ANDROID_HOME not set${NC}"
    echo "Please set ANDROID_HOME to your Android SDK location"
    exit 1
fi

if ! command -v java &> /dev/null; then
    echo -e "${RED}Error: Java not found${NC}"
    exit 1
fi

echo "✓ Android SDK: $ANDROID_HOME"
echo "✓ Java version: $(java -version 2>&1 | head -n1)"
echo ""

# Clean up previous build
echo -e "${YELLOW}Cleaning up previous build...${NC}"
cd /home/waynemartin1980/WayneWolf
rm -rf fenix
rm -f dist/android/waynewolf-*.apk
echo "✓ Cleanup complete"
echo ""

# Clone Fenix
echo -e "${YELLOW}Cloning Fenix repository...${NC}"
git clone --depth 1 https://github.com/mozilla-mobile/fenix.git
cd fenix
echo "✓ Fenix cloned"
echo ""

# Update gradle.properties
echo -e "${YELLOW}Configuring gradle properties...${NC}"
cat >> gradle.properties << 'EOF'

# WayneWolf Customizations
android.useAndroidX=true
android.enableJetifier=true
org.gradle.jvmargs=-Xmx4g -XX:+HeapDumpOnOutOfMemoryError
EOF
echo "✓ gradle.properties updated"
echo ""

# Apply package name changes using Mull's approach
echo -e "${YELLOW}Applying package name changes...${NC}"

# Step 1: Change applicationId and applicationIdSuffix in app/build.gradle
echo "  - Modifying applicationId in app/build.gradle..."
sed -i \
    -e "s|applicationId \"${OLD_PACKAGE_BASE}\"|applicationId \"${NEW_PACKAGE_BASE}\"|g" \
    -e "s|applicationIdSuffix \"${OLD_SUFFIX}\"|applicationIdSuffix \"${NEW_SUFFIX}\"|g" \
    app/build.gradle

# Step 2: Change sharedUserId in app/build.gradle
echo "  - Updating sharedUserId..."
sed -i \
    -e "s|\"sharedUserId\": \"${OLD_PACKAGE_BASE}${OLD_SUFFIX}.sharedID\"|\"sharedUserId\": \"${FULL_PACKAGE_NAME}.sharedID\"|g" \
    app/build.gradle

# Step 3: Update shortcuts.xml if it exists
if [ -f "app/src/release/res/xml/shortcuts.xml" ]; then
    echo "  - Updating shortcuts.xml..."
    sed -i \
        -e "/android:targetPackage/s/${OLD_PACKAGE_BASE}${OLD_SUFFIX}/${FULL_PACKAGE_NAME}/g" \
        app/src/release/res/xml/shortcuts.xml
fi

# Step 4: Update app name in strings.xml
echo "  - Updating app name in strings.xml..."
find app/src/main/res -name "strings.xml" -exec sed -i \
    -e "s|<string name=\"app_name\">Fenix</string>|<string name=\"app_name\">${APP_NAME}</string>|g" \
    -e "s|<string name=\"app_name\">Firefox</string>|<string name=\"app_name\">${APP_NAME}</string>|g" \
    {} \;

echo -e "${GREEN}✓ Package name changes applied successfully${NC}"
echo ""
echo "  Final package: ${FULL_PACKAGE_NAME}"
echo ""

# Verify changes
echo -e "${BLUE}Verifying changes in app/build.gradle...${NC}"
echo "  applicationId lines:"
grep "applicationId" app/build.gradle | head -5 | sed 's/^/    /'
echo ""
echo "  sharedUserId lines:"
grep "sharedUserId" app/build.gradle | head -3 | sed 's/^/    /'
echo ""

# Clean build
echo -e "${YELLOW}Cleaning previous builds...${NC}"
./gradlew clean
echo ""

# Build release APK
echo -e "${YELLOW}Building release APK...${NC}"
echo "This will take 20-30 minutes..."
echo ""
./gradlew assembleRelease

# Find and copy APKs
echo ""
echo -e "${YELLOW}Locating built APKs...${NC}"
APK_DIR="app/build/outputs/apk/release"

if [ ! -d "$APK_DIR" ]; then
    echo -e "${RED}Error: APK output directory not found${NC}"
    exit 1
fi

# Copy to dist
cd /home/waynemartin1980/WayneWolf
mkdir -p dist/android
cp fenix/$APK_DIR/app-*-release-unsigned.apk dist/android/ 2>/dev/null || true

# Rename to waynewolf-*
cd dist/android
for apk in app-*-release-unsigned.apk; do
    if [ -f "$apk" ]; then
        newname=$(echo "$apk" | sed "s/app-/waynewolf-/")
        mv "$apk" "$newname"
        echo "  ✓ $newname"
    fi
done

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Build Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Built APKs:"
ls -lh waynewolf-*-unsigned.apk 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
echo ""
echo -e "${YELLOW}Next step: Sign the APKs${NC}"
echo "  cd /home/waynemartin1980/WayneWolf"
echo "  ./packaging/android/sign-all-apks.sh"
echo ""
