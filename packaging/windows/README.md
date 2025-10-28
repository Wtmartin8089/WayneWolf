# WayneWolf Windows Build

This directory contains scripts to build WayneWolf for Windows.

## Quick Build (Recommended)

This method downloads pre-built LibreWolf binaries and applies WayneWolf branding.

### Prerequisites

- Windows 10/11
- PowerShell 5.1 or later
- Internet connection

### Build Steps

```powershell
# Run the build script
.\build-windows.ps1

# Or specify a version
.\build-windows.ps1 -Version "141.0-1"
```

The script will:
1. Download LibreWolf Windows portable
2. Apply WayneWolf branding
3. Create `waynewolf-VERSION-windows-x86_64.zip` in `dist/windows/`

### Build from Source (Advanced)

For building from Firefox/LibreWolf source on Windows:

**Prerequisites:**
- Visual Studio 2022 Build Tools
- MozillaBuild
- ~40GB disk space
- 4-6 hours build time

**Steps:**

1. Install MozillaBuild:
   ```
   https://ftp.mozilla.org/pub/mozilla/libraries/win32/MozillaBuildSetup-Latest.exe
   ```

2. Install VS Build Tools:
   ```
   https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
   ```

3. Run build:
   ```powershell
   .\build-from-source.ps1
   ```

## Distribution

### Portable ZIP
The default output is a portable ZIP that can be extracted anywhere:

```
waynewolf-141.0-1-windows-x86_64.zip
```

### Creating Installer (Optional)

To create an installer using NSIS:

1. Install NSIS: https://nsis.sourceforge.io/Download
2. Run:
   ```powershell
   .\create-installer.ps1
   ```

This creates `WayneWolf-Setup.exe`

## Testing

Extract and run:
```powershell
# Extract
Expand-Archive waynewolf-*-windows-x86_64.zip -DestinationPath C:\WayneWolf

# Run
C:\WayneWolf\waynewolf.exe
```

## CI/CD Build

GitHub Actions automatically builds Windows packages on every commit:

See `.github/workflows/build-windows.yml`

## Troubleshooting

### "waynewolf.exe is not recognized"
- Make sure you extracted the ZIP completely
- Check Windows Defender didn't quarantine the executable

### Build fails
- Ensure you have internet connection for downloading LibreWolf
- Check disk space (need ~2GB free)
- Try running PowerShell as Administrator

### Missing DLLs
The portable build includes all necessary DLLs. If you see missing DLL errors:
- Re-extract the ZIP
- Don't move individual files, move the entire folder

## File Structure

```
dist/windows/
├── waynewolf-141.0-1-windows-x86_64.zip     # Portable package
├── waynewolf-141.0-1-windows-x86_64.zip.sha256   # Checksum
└── WayneWolf-Setup.exe                       # Installer (optional)
```

## Customization

Edit `build-windows.ps1` to customize:
- Application name
- Version string
- Branding files
- Default settings

## Notes

- Windows builds are 64-bit only (x86_64)
- Based on LibreWolf which is based on Firefox ESR
- Includes all WayneWolf privacy enhancements
- Profile system works same as Linux version

## Build Time

- Quick build (rebrand): ~5 minutes
- From source: ~4-6 hours (first build)
- Subsequent builds: ~30-60 minutes

## Size

- Downloaded LibreWolf: ~90MB
- Final ZIP: ~85MB
- Extracted: ~250MB
