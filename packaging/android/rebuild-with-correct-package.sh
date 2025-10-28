#!/bin/bash
# WayneWolf Android APK Builder - FIXED VERSION
# Properly changes package name to org.waynewolf.browser

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

VERSION="1.0.0"
APP_NAME="WayneWolf"
OLD_PACKAGE="org.mozilla.firefox"
NEW_PACKAGE="org.waynewolf.browser"

echo -e "${GREEN}WayneWolf Android APK Builder (Fixed)${NC}"
echo "=========================================="
echo "Version: $VERSION"
echo "Package: $NEW_PACKAGE"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if [ -z "$ANDROID_HOME" ]; then
    echo -e "${RED}Error: ANDROID_HOME not set${NC}"
    exit 1
fi

if ! command -v java &> /dev/null; then
    echo -e "${RED}Error: Java not found${NC}"
    exit 1
fi

echo "Android SDK: $ANDROID_HOME"
echo "Java version: $(java -version 2>&1 | head -n1)"
echo ""

# Clean up previous build
echo -e "${YELLOW}Cleaning up previous build...${NC}"
rm -rf fenix
rm -rf dist/android/*-unsigned.apk

# Clone Fenix
echo -e "${YELLOW}Cloning Fenix repository...${NC}"
git clone --depth 1 https://github.com/mozilla-mobile/fenix.git
cd fenix

# Apply WayneWolf customizations
echo -e "${YELLOW}Applying WayneWolf customizations...${NC}"

# 1. Update gradle.properties
cat >> gradle.properties << EOF

# WayneWolf Customizations
android.useAndroidX=true
android.enableJetifier=true
org.gradle.jvmargs=-Xmx4g -XX:+HeapDumpOnOutOfMemoryError
EOF

# 2. Modify build.gradle to change applicationId properly
echo -e "${YELLOW}Modifying package name in build.gradle...${NC}"

# Find and replace applicationId for release variant
sed -i "s/applicationId = \"$OLD_PACKAGE\"/applicationId = \"$NEW_PACKAGE\"/" app/build.gradle
sed -i "s/applicationId \"$OLD_PACKAGE\"/applicationId \"$NEW_PACKAGE\"/" app/build.gradle
sed -i "s/'$OLD_PACKAGE'/'$NEW_PACKAGE'/g" app/build.gradle

# 3. Update AndroidManifest.xml
echo -e "${YELLOW}Updating AndroidManifest.xml...${NC}"
find app/src -name "AndroidManifest.xml" -exec sed -i "s/package=\"$OLD_PACKAGE\"/package=\"$NEW_PACKAGE\"/g" {} \;

# 4. Update strings.xml app name
echo -e "${YELLOW}Updating app name...${NC}"
find app/src/main/res -name "strings.xml" -exec sed -i "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">$APP_NAME<\/string>/" {} \;

# 5. Remove shared user ID (causes conflicts)
sed -i "s/sharedUserId.*//g" app/build.gradle

echo -e "${GREEN}✓ Package name changed to: $NEW_PACKAGE${NC}"
echo ""

# Clean build
echo -e "${YELLOW}Cleaning previous builds...${NC}"
./gradlew clean

# Build release APK
echo -e "${YELLOW}Building release APK...${NC}"
echo "This may take 20-30 minutes..."
./gradlew assembleRelease

# Find built APKs
echo -e "${YELLOW}Locating built APKs...${NC}"
APK_DIR="app/build/outputs/apk/release"

if [ ! -d "$APK_DIR" ]; then
    echo -e "${RED}Error: APK output directory not found${NC}"
    exit 1
fi

# Copy to dist
cd ..
mkdir -p dist/android
cp fenix/$APK_DIR/*.apk dist/android/

# Rename to waynewolf-*
cd dist/android
for apk in app-*.apk; do
    newname=$(echo "$apk" | sed "s/app-/waynewolf-/")
    mv "$apk" "$newname"
done

echo ""
echo -e "${GREEN}APKs built successfully!${NC}"
echo ""
echo "Built APKs:"
ls -lh waynewolf-*-unsigned.apk | sed 's/^/  /'
echo ""
echo -e "${YELLOW}Next: Sign the APKs${NC}"
echo "  ./packaging/android/sign-all-apks.sh"
echo ""
