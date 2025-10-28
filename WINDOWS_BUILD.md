# Building WayneWolf for Windows

WayneWolf can be built for Windows in two ways:

## Method 1: Quick Build (Recommended) ⚡

Downloads pre-built LibreWolf and applies WayneWolf branding.

**Time:** ~5 minutes
**Size:** ~85MB ZIP file

### On Windows:

```powershell
cd packaging\windows
.\build-windows.ps1
```

Output: `dist/windows/waynewolf-141.0-1-windows-x86_64.zip`

### Using GitHub Actions (Automatic):

Push to GitHub and the workflow builds automatically:

```bash
git add .
git commit -m "Trigger Windows build"
git push
```

Download artifacts from: `Actions → build-windows → Artifacts`

## Method 2: Build from Source (Advanced) 🔧

Compiles Firefox/LibreWolf from source.

**Time:** 4-6 hours (first build)
**Requirements:**
- Visual Studio 2022 Build Tools
- MozillaBuild
- 40GB disk space
- 16GB RAM recommended

See: `packaging/windows/README.md` for details

## What's Included

The Windows build includes:

- ✓ WayneWolf branded executable (`waynewolf.exe`)
- ✓ All LibreWolf privacy enhancements
- ✓ Portable ZIP (no installer needed)
- ✓ Profile system (dev, browse, ghost)
- ✓ Auto-extension installation
- ✓ Complete Windows integration

## Installation

### Portable (No Admin Required)

```powershell
# Extract anywhere
Expand-Archive waynewolf-141.0-1-windows-x86_64.zip -DestinationPath C:\WayneWolf

# Run
C:\WayneWolf\waynewolf.exe
```

### Create Desktop Shortcut

```powershell
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\WayneWolf.lnk")
$Shortcut.TargetPath = "C:\WayneWolf\waynewolf.exe"
$Shortcut.Save()
```

## Distribution

### GitHub Releases

Automatic builds on every tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Downloads appear at: `Releases → v1.0.0`

### Manual Distribution

1. Build: `.\build-windows.ps1`
2. Verify: Test `waynewolf.exe` launches
3. Upload: `dist/windows/waynewolf-*.zip` + `.sha256`

## File Structure

```
dist/windows/
├── waynewolf-141.0-1-windows-x86_64.zip         # Portable package (85MB)
└── waynewolf-141.0-1-windows-x86_64.zip.sha256  # Checksum

Extracted:
WayneWolf/
├── waynewolf.exe          # Main executable
├── application.ini        # App configuration
├── browser/               # Browser resources
├── defaults/              # Default settings
└── [other Firefox files]
```

## Profiles

Works same as Linux:

```powershell
# Development profile
waynewolf.exe -P dev

# Anonymous browsing
waynewolf.exe -P ghost

# Work/browsing
waynewolf.exe -P browse
```

## Troubleshooting

### "Windows protected your PC"

This appears because the exe isn't signed. Click "More info" → "Run anyway"

To avoid this, code sign the executable (requires certificate).

### Missing DLL errors

Re-extract the ZIP completely. Don't move individual files.

### Won't start

1. Check Windows Defender didn't quarantine it
2. Run from Command Prompt to see errors:
   ```cmd
   cd C:\WayneWolf
   waynewolf.exe
   ```

### Profile issues

Delete and recreate:
```powershell
Remove-Item -Recurse $env:APPDATA\WayneWolf
```

## Development

### Build Script Location
```
packaging/windows/build-windows.ps1
```

### Modify Branding

Edit `build-windows.ps1`:
- Line 45: Executable name
- Line 52-56: application.ini settings
- Line 59-64: local-settings.js preferences

### Custom Icon

Replace `waynewolf.ico` in project root, then rebuild.

## GitHub Actions Workflow

See: `.github/workflows/build-windows.yml`

Triggers on:
- Push to main/develop
- Pull requests
- Manual: Actions → build-windows → Run workflow

Build time: ~5 minutes

## Comparison

| Method | Time | Size | Effort |
|--------|------|------|--------|
| Quick (rebrand) | 5 min | 85 MB | Easy |
| From source | 4-6 hrs | 90 MB | Hard |

**Recommended:** Use quick build unless you need custom Firefox patches.

## Next Steps

1. **Build locally:** Run `build-windows.ps1` on Windows
2. **Or use CI:** Push to GitHub, download from Actions
3. **Test:** Extract and run `waynewolf.exe`
4. **Distribute:** Upload ZIP + SHA256 to releases

## Resources

- Windows build script: `packaging/windows/build-windows.ps1`
- Full documentation: `packaging/windows/README.md`
- GitHub workflow: `.github/workflows/build-windows.yml`
- LibreWolf source: https://gitlab.com/librewolf-community/browser/windows

---

**Windows builds ready. Let the hunt begin.** 🐺
