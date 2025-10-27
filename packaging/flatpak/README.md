# WayneWolf Flatpak Package

This directory contains files for building and distributing WayneWolf as a Flatpak package.

## Files

- `org.waynewolf.WayneWolf.yml` - Flatpak manifest
- `org.waynewolf.WayneWolf.appdata.xml` - Application metadata for software centers

## Building Locally

### Prerequisites

```bash
# Install flatpak and flatpak-builder
sudo apt install flatpak flatpak-builder

# Add Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install required runtimes and SDKs
flatpak install flathub org.freedesktop.Platform//23.08
flatpak install flathub org.freedesktop.Sdk//23.08
flatpak install flathub org.freedesktop.Sdk.Extension.rust-stable
flatpak install flathub org.freedesktop.Sdk.Extension.node18
```

### Build

```bash
# From the repository root
flatpak-builder --force-clean build-dir packaging/flatpak/org.waynewolf.WayneWolf.yml
```

### Install Locally

```bash
# Install the built flatpak
flatpak-builder --user --install --force-clean build-dir packaging/flatpak/org.waynewolf.WayneWolf.yml
```

### Run

```bash
flatpak run org.waynewolf.WayneWolf

# With profiles
flatpak run org.waynewolf.WayneWolf dev
flatpak run org.waynewolf.WayneWolf browse
flatpak run org.waynewolf.WayneWolf ghost
```

## Creating a Bundle

For offline distribution:

```bash
# Build and export to a repository
flatpak-builder --repo=repo --force-clean build-dir packaging/flatpak/org.waynewolf.WayneWolf.yml

# Create a single-file bundle
flatpak build-bundle repo waynewolf.flatpak org.waynewolf.WayneWolf

# Users can install the bundle
flatpak install waynewolf.flatpak
```

## Publishing to Flathub

### Prerequisites

1. Fork the Flathub repository: https://github.com/flathub/flathub
2. Create a new repository named `org.waynewolf.WayneWolf`

### Steps

1. **Prepare the manifest:**
   ```bash
   # Copy manifest to Flathub repo
   cp packaging/flatpak/org.waynewolf.WayneWolf.yml /path/to/flathub/org.waynewolf.WayneWolf/
   cp packaging/flatpak/org.waynewolf.WayneWolf.appdata.xml /path/to/flathub/org.waynewolf.WayneWolf/
   ```

2. **Update the manifest:**
   - Replace `WTmartin8089` with your GitHub username
   - Fill in the correct commit SHA
   - Update all `FILL_IN_*` placeholders with actual values

3. **Test the build:**
   ```bash
   flatpak-builder --force-clean test-build org.waynewolf.WayneWolf.yml
   ```

4. **Submit to Flathub:**
   ```bash
   cd /path/to/flathub/org.waynewolf.WayneWolf
   git add .
   git commit -m "Initial submission of WayneWolf"
   git push
   ```

5. **Create Pull Request:**
   - Go to https://github.com/flathub/flathub
   - Create a PR from your repository
   - Wait for review and approval

### Flathub Review Requirements

- Application must be open source
- Must have proper licensing information
- AppData must be valid (check with `appstream-util validate`)
- Build must complete successfully
- No bundled dependencies without good reason

### Validate AppData

```bash
appstream-util validate packaging/flatpak/org.waynewolf.WayneWolf.appdata.xml
```

## Updating the Flatpak

When releasing a new version:

1. Update the manifest:
   - Change the `tag` to the new version
   - Update the `commit` SHA

2. Update appdata.xml:
   - Add a new `<release>` entry with version and date

3. Test locally:
   ```bash
   flatpak-builder --force-clean --repo=repo build-dir org.waynewolf.WayneWolf.yml
   flatpak update org.waynewolf.WayneWolf
   ```

4. Submit update to Flathub:
   ```bash
   git commit -m "Update to version X.Y.Z"
   git push
   ```

## Troubleshooting

### Build fails with missing dependencies

Ensure all SDK extensions are installed:
```bash
flatpak install org.freedesktop.Sdk.Extension.rust-stable
flatpak install org.freedesktop.Sdk.Extension.node18
```

### Permission denied errors

Grant additional permissions:
```bash
flatpak override --user org.waynewolf.WayneWolf --filesystem=home
```

### Profile directory issues

Flatpak isolates the app. Profiles are stored in:
```
~/.var/app/org.waynewolf.WayneWolf/.waynewolf/
```

## Resources

- Flatpak documentation: https://docs.flatpak.org/
- Flathub documentation: https://docs.flathub.org/
- Flatpak Builder: https://docs.flatpak.org/en/latest/flatpak-builder.html
