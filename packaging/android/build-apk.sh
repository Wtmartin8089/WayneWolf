#!/bin/bash
# WayneWolf Android APK Builder
# Builds WayneWolf for Android based on Fenix

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

VERSION="1.0.0"
APP_NAME="WayneWolf"
PACKAGE_ID="org.waynewolf.browser"

echo -e "${GREEN}WayneWolf Android APK Builder${NC}"
echo "=============================="
echo "Version: $VERSION"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if [ -z "$ANDROID_HOME" ]; then
    echo -e "${RED}Error: ANDROID_HOME not set${NC}"
    echo "Set with: export ANDROID_HOME=\$HOME/Android/Sdk"
    exit 1
fi

if ! command -v java &> /dev/null; then
    echo -e "${RED}Error: Java not found${NC}"
    echo "Install with: sudo apt install openjdk-17-jdk"
    exit 1
fi

echo "Android SDK: $ANDROID_HOME"
echo "Java version: $(java -version 2>&1 | head -n1)"
echo ""

# Clone Fenix if needed
if [ ! -d "fenix" ]; then
    echo -e "${YELLOW}Cloning Fenix repository...${NC}"
    git clone --depth 1 https://github.com/mozilla-mobile/fenix.git
fi

cd fenix

# Apply WayneWolf customizations
echo -e "${YELLOW}Applying WayneWolf customizations...${NC}"

# Customize gradle.properties
cat >> gradle.properties << EOF

# WayneWolf Customizations
android.useAndroidX=true
android.enableJetifier=true
org.gradle.jvmargs=-Xmx4g -XX:+HeapDumpOnOutOfMemoryError
EOF

# Customize app name and package
if [ -f "app/build.gradle" ]; then
    # Update applicationId
    sed -i "s/applicationId \"org.mozilla.fenix\"/applicationId \"$PACKAGE_ID\"/" app/build.gradle

    # Update app name in strings.xml
    if [ -f "app/src/main/res/values/strings.xml" ]; then
        sed -i "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">$APP_NAME<\/string>/" app/src/main/res/values/strings.xml
    fi
fi

# Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
./gradlew clean

# Build release APK
echo -e "${YELLOW}Building release APK...${NC}"
echo "This may take 30-60 minutes..."
./gradlew assembleRelease

# Find the built APK
APK_PATH=$(find app/build/outputs/apk/release -name "*.apk" | head -n1)

if [ -z "$APK_PATH" ]; then
    echo -e "${RED}Error: APK not found after build${NC}"
    exit 1
fi

# Copy to dist directory
cd ..
mkdir -p dist/android
cp "$APK_PATH" "dist/android/waynewolf-${VERSION}-release-unsigned.apk"

echo ""
echo -e "${GREEN}APK built successfully!${NC}"
echo ""
echo "Unsigned APK: dist/android/waynewolf-${VERSION}-release-unsigned.apk"
echo ""
echo "Next steps:"
echo "1. Sign the APK with your keystore:"
echo "   ./packaging/android/sign-apk.sh"
echo ""
echo "2. Install on device:"
echo "   adb install dist/android/waynewolf-${VERSION}-release-signed.apk"
echo ""
