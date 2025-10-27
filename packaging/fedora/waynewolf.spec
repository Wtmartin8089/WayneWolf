Name:           waynewolf
Version:        141.0
Release:        1%{?dist}
Summary:        Privacy-focused browser with profile templates

License:        MPL-2.0
URL:            https://github.com/WTmartin8089/waynewolf
Source0:        %{url}/archive/v%{version}/%{name}-%{version}.tar.gz

BuildRequires:  rust >= 1.70
BuildRequires:  cargo
BuildRequires:  cbindgen
BuildRequires:  pigz
BuildRequires:  python3
BuildRequires:  nodejs
BuildRequires:  npm
BuildRequires:  clang
BuildRequires:  llvm
BuildRequires:  gtk3-devel
BuildRequires:  dbus-glib-devel
BuildRequires:  pulseaudio-libs-devel
BuildRequires:  desktop-file-utils

Requires:       gtk3
Requires:       dbus-glib
Requires:       ffmpeg
Requires:       nss
Requires:       pulseaudio-libs

Recommends:     tor

%description
WayneWolf is a custom-built browser fork based on LibreWolf/Firefox,
designed for minimalism, maximum privacy, and performance.

Features:
- Minimalist UI - No distractions
- Maximum Privacy - Fingerprint resistance, WebRTC blocking
- Legacy Compatibility - Unsigned extensions work
- Performance - GPU acceleration, aggressive caching
- Profile Isolation - Three modes: dev, browse, ghost

WayneWolf features an advanced profile template system with
auto-configured privacy settings and extensions.

%prep
%autosetup

%build
cd WayneWolf
make fetch
make dir
make bootstrap
make setup-wasi
make build
make package

%install
# Create directories
install -dm755 %{buildroot}%{_libdir}/%{name}
install -dm755 %{buildroot}%{_bindir}
install -dm755 %{buildroot}%{_datadir}/%{name}
install -dm755 %{buildroot}%{_datadir}/applications
install -dm755 %{buildroot}%{_datadir}/icons/hicolor/scalable/apps
install -dm755 %{buildroot}%{_datadir}/icons/hicolor/48x48/apps
install -dm755 %{buildroot}%{_datadir}/icons/hicolor/128x128/apps
install -dm755 %{buildroot}%{_datadir}/icons/hicolor/256x256/apps

# Extract and install browser
tar xf WayneWolf/librewolf-*.tar.xz -C %{buildroot}%{_libdir}/ --strip-components=1
if [ -d "%{buildroot}%{_libdir}/librewolf" ]; then
    mv %{buildroot}%{_libdir}/librewolf %{buildroot}%{_libdir}/%{name}
fi

# Install launcher wrapper
cat > %{buildroot}%{_bindir}/%{name} << 'EOF'
#!/bin/bash
# WayneWolf system launcher wrapper
export MOZ_ENABLE_WAYLAND=1
export MOZ_REQUIRE_SIGNING=0

BROWSER_DIR="%{_libdir}/%{name}"
SHARE_DIR="%{_datadir}/%{name}"

# Run the launcher script
if [ -f "$SHARE_DIR/launch-waynewolf.sh" ]; then
    exec bash "$SHARE_DIR/launch-waynewolf.sh" "$@"
else
    exec "$BROWSER_DIR/librewolf" "$@"
fi
EOF
chmod +x %{buildroot}%{_bindir}/%{name}

# Install supporting files
install -Dm755 launch-waynewolf.sh %{buildroot}%{_datadir}/%{name}/
install -Dm755 install-extensions.sh %{buildroot}%{_datadir}/%{name}/
install -Dm644 user.js %{buildroot}%{_datadir}/%{name}/
install -Dm644 extensions.conf %{buildroot}%{_datadir}/%{name}/

# Install profile templates
cp -r profile-templates %{buildroot}%{_datadir}/%{name}/

# Install desktop file
desktop-file-install --dir=%{buildroot}%{_datadir}/applications waynewolf.desktop

# Install icons
install -Dm644 waynewolf.svg %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/waynewolf.svg
install -Dm644 waynewolf-48.png %{buildroot}%{_datadir}/icons/hicolor/48x48/apps/waynewolf.png || true
install -Dm644 waynewolf-128.png %{buildroot}%{_datadir}/icons/hicolor/128x128/apps/waynewolf.png || true
install -Dm644 waynewolf-256.png %{buildroot}%{_datadir}/icons/hicolor/256x256/apps/waynewolf.png || true

%files
%license LICENSE
%doc README.md
%{_bindir}/%{name}
%{_libdir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/waynewolf.desktop
%{_datadir}/icons/hicolor/*/apps/waynewolf.*

%post
/usr/bin/update-desktop-database &> /dev/null || :
/bin/touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :

%postun
/usr/bin/update-desktop-database &> /dev/null || :
if [ $1 -eq 0 ] ; then
    /bin/touch --no-create %{_datadir}/icons/hicolor &>/dev/null
    /usr/bin/gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
fi

%posttrans
/usr/bin/gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :

%changelog
* Sat Oct 26 2024 Wayne Martin <your@email.com> - 141.0-1
- Initial release
- Based on LibreWolf 141.0
- Profile template system
- Minimalist UI
- Privacy-focused configuration
