#!/bin/bash
# WayneWolf Android - Clean Rebuild with Correct Package Name
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}WayneWolf Android - Clean Rebuild${NC}"
echo "Package: org.waynewolf.browser"
echo ""

# Clean up
echo -e "${YELLOW}Cleaning up...${NC}"
rm -rf fenix

# Clone fresh
echo -e "${YELLOW}Cloning Fenix...${NC}"
git clone --depth 1 https://github.com/mozilla-mobile/fenix.git
cd fenix

# Update gradle.properties
cat >> gradle.properties << 'EOF'

# WayneWolf Config
android.useAndroidX=true
android.enableJetifier=true
org.gradle.jvmargs=-Xmx4g -XX:+HeapDumpOnOutOfMemoryError
EOF

# Change package name in build.gradle - CAREFUL replacement
echo -e "${YELLOW}Updating build.gradle package names...${NC}"

# Just change the base applicationId in defaultConfig
perl -i -pe 's/applicationId\s*=\s*"org\.mozilla\.fenix"/applicationId = "org.waynewolf.browser"/' app/build.gradle

# Change applicationIdSuffix for release (currently ".firefox" should become "")
perl -i -pe 's/applicationIdSuffix\s+".firefox"/applicationIdSuffix ""/' app/build.gradle

# Update app name
echo -e "${YELLOW}Updating app name...${NC}"
find app/src/main/res/values -name "strings.xml" -exec sed -i 's/<string name="app_name">Fenix<\/string>/<string name="app_name">WayneWolf<\/string>/' {} \;
find app/src/main/res/values -name "strings.xml" -exec sed -i 's/<string name="app_name">Firefox<\/string>/<string name="app_name">WayneWolf<\/string>/' {} \;

echo -e "${GREEN}✓ Configuration updated${NC}"
echo ""

# Build
echo -e "${YELLOW}Building release APK (20-30 minutes)...${NC}"
./gradlew clean
./gradlew assembleRelease

# Package results
cd ..
mkdir -p dist/android
rm -f dist/android/waynewolf-*
cp fenix/app/build/outputs/apk/release/*-release-unsigned.apk dist/android/

# Rename files
cd dist/android
for f in app-*-unsigned.apk; do
    new=$(echo "$f" | sed 's/^app-/waynewolf-/')
    mv "$f" "$new"
done

echo ""
echo -e "${GREEN}✓ Build complete!${NC}"
echo ""
ls -lh waynewolf-*.apk
echo ""
echo "Next: Sign with ./packaging/android/sign-all-apks.sh"
