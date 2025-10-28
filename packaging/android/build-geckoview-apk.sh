#!/bin/bash
# WayneWolf GeckoView-based Android Build Script
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

VERSION="1.0.0"
APP_NAME="WayneWolf"
PACKAGE_NAME="org.waynewolf.browser"

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}WayneWolf GeckoView APK Builder${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Version: $VERSION"
echo "Package: $PACKAGE_NAME"
echo "Using GeckoView from Mozilla Maven"
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

# Navigate to project
cd /home/waynemartin1980/WayneWolf/packaging/android/waynewolf-app

# Download gradle wrapper if needed
if [ ! -f gradle/wrapper/gradle-wrapper.jar ]; then
    echo -e "${YELLOW}Downloading Gradle wrapper...${NC}"
    mkdir -p gradle/wrapper
    wget -q -O gradle/wrapper/gradle-wrapper.jar \
        https://raw.githubusercontent.com/gradle/gradle/master/gradle/wrapper/gradle-wrapper.jar
    echo "✓ Gradle wrapper downloaded"
    echo ""
fi

# Make gradlew executable
if [ ! -f gradlew ]; then
    echo -e "${YELLOW}Creating gradlew script...${NC}"
    cat > gradlew << 'GRADLEW_EOF'
#!/bin/sh
APP_HOME=$(cd "$(dirname "$0")" && pwd)
exec java -jar "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" "$@"
GRADLEW_EOF
    chmod +x gradlew
    echo "✓ gradlew created"
    echo ""
fi

# Clean build
echo -e "${YELLOW}Cleaning previous builds...${NC}"
./gradlew clean
echo ""

# Build release APK
echo -e "${YELLOW}Building release APK...${NC}"
echo "This will take 5-10 minutes (first build may take longer)..."
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
cp packaging/android/waynewolf-app/$APK_DIR/*.apk dist/android/ 2>/dev/null || true

# Rename
cd dist/android
for apk in app-release-unsigned.apk; do
    if [ -f "$apk" ]; then
        newname="waynewolf-geckoview-${VERSION}-release-unsigned.apk"
        mv "$apk" "$newname"
        echo "  ✓ $newname"
    fi
done

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Build Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Built APK:"
ls -lh waynewolf-geckoview-*-unsigned.apk 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
echo ""
echo -e "${YELLOW}Next step: Sign the APK${NC}"
echo "  cd /home/waynemartin1980/WayneWolf"
echo "  ./packaging/android/sign-all-apks.sh"
echo ""
