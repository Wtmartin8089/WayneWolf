%global debug_package %{nil}

Name:           waynewolf
Version:        141.0
Release:        1%{?dist}
Summary:        Privacy-focused web browser based on LibreWolf

License:        MPLv2.0
URL:            https://github.com/WTmartin8089/waynewolf
Source0:        https://github.com/WTmartin8089/waynewolf/releases/download/v%{version}/librewolf-%{version}-1.source.tar.gz

BuildRequires:  rust >= 1.70
BuildRequires:  cargo
BuildRequires:  cbindgen
BuildRequires:  python3
BuildRequires:  nodejs
BuildRequires:  yasm
BuildRequires:  nasm
BuildRequires:  clang
BuildRequires:  llvm
BuildRequires:  gcc-c++
BuildRequires:  gtk3-devel
BuildRequires:  libXt-devel
BuildRequires:  dbus-glib-devel
BuildRequires:  pulseaudio-libs-devel
BuildRequires:  alsa-lib-devel
BuildRequires:  zip
BuildRequires:  unzip

Requires:       gtk3
Requires:       dbus-glib
Requires:       libXt
Requires:       pulseaudio-libs

%description
WayneWolf is a privacy-focused web browser fork of LibreWolf with:
* Minimalist dark theme UI
* Profile template system (dev, browse, ghost)
* Auto-extension installation
* Nuclear privacy settings by default
* No telemetry or tracking

Built on Mozilla Firefox technology with LibreWolf privacy enhancements.

%prep
%setup -q -n librewolf-%{version}

%build
# Bootstrap build environment
./mach bootstrap --application-choice=browser --no-interactive

# Build
./mach build

%install
# Install to buildroot
DESTDIR=%{buildroot} ./mach install

# Create directory structure
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_datadir}/icons/hicolor/48x48/apps
mkdir -p %{buildroot}%{_datadir}/icons/hicolor/128x128/apps
mkdir -p %{buildroot}%{_datadir}/icons/hicolor/256x256/apps

# Install launcher
install -Dm755 %{_sourcedir}/../../launch-waynewolf.sh %{buildroot}%{_bindir}/waynewolf

# Install desktop file
cat > %{buildroot}%{_datadir}/applications/waynewolf.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Name=WayneWolf
GenericName=Web Browser
Comment=Privacy-focused web browser
Exec=waynewolf %u
Icon=waynewolf
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
StartupWMClass=waynewolf
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Exec=waynewolf --new-window %u

[Desktop Action new-private-window]
Name=New Private Window
Exec=waynewolf --private-window %u
EOF

# Install icons
install -Dm644 %{_sourcedir}/../../waynewolf-48.png %{buildroot}%{_datadir}/icons/hicolor/48x48/apps/waynewolf.png
install -Dm644 %{_sourcedir}/../../waynewolf-128.png %{buildroot}%{_datadir}/icons/hicolor/128x128/apps/waynewolf.png
install -Dm644 %{_sourcedir}/../../waynewolf-256.png %{buildroot}%{_datadir}/icons/hicolor/256x256/apps/waynewolf.png

%files
%license LICENSE
%doc README.md
%{_bindir}/waynewolf
%{_datadir}/applications/waynewolf.desktop
%{_datadir}/icons/hicolor/*/apps/waynewolf.png

%post
update-desktop-database &> /dev/null || :
touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :

%postun
update-desktop-database &> /dev/null || :
if [ $1 -eq 0 ] ; then
    touch --no-create %{_datadir}/icons/hicolor &>/dev/null
    gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
fi

%posttrans
gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :

%changelog
* Sun Oct 27 2025 Wayne Martin <ghwinslow1700@hotmail.com> - 141.0-1
- Initial release of WayneWolf browser
- Based on LibreWolf 141.0 / Firefox 141.0
- Privacy-focused configuration by default
- Minimalist dark theme UI
- Profile template system (dev, browse, ghost)
- Auto-extension installation capability
- No telemetry or tracking
- Generated with Claude Code
