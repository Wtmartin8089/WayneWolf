#!/bin/bash
# WayneWolf Extension Installer
# Installs privacy-focused extensions to profiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_CONF="$SCRIPT_DIR/extensions.conf"
EXTENSIONS_CACHE="$SCRIPT_DIR/.extensions-cache"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create cache directory
mkdir -p "$EXTENSIONS_CACHE"

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Download extension if not cached
download_extension() {
    local ext_id="$1"
    local url="$2"
    local cache_file="$EXTENSIONS_CACHE/${ext_id}.xpi"

    if [[ -f "$cache_file" ]]; then
        print_info "Using cached: ${ext_id}" >&2
        echo "$cache_file"
        return 0
    fi

    print_info "Downloading: ${ext_id}" >&2
    if curl -s -S -L -o "$cache_file" "$url"; then
        print_success "Downloaded: ${ext_id}" >&2
        echo "$cache_file"
        return 0
    else
        print_error "Failed to download: ${ext_id}" >&2
        return 1
    fi
}

# Install extension to profile
install_to_profile() {
    local profile_path="$1"
    local ext_id="$2"
    local xpi_file="$3"

    if [[ ! -d "$profile_path" ]]; then
        print_error "Profile path does not exist: $profile_path"
        return 1
    fi

    local extensions_dir="$profile_path/extensions"
    mkdir -p "$extensions_dir"

    local dest_file="$extensions_dir/${ext_id}.xpi"

    if cp "$xpi_file" "$dest_file"; then
        print_success "Installed to profile: ${ext_id}"
        return 0
    else
        print_error "Failed to install: ${ext_id}"
        return 1
    fi
}

# Main installation function
install_extensions() {
    local profile_path="$1"
    local profile_type="${2:-all}"

    if [[ ! -f "$EXTENSIONS_CONF" ]]; then
        print_error "Extensions configuration not found: $EXTENSIONS_CONF"
        return 1
    fi

    print_info "Installing extensions for profile type: $profile_type"
    print_info "Target profile: $profile_path"
    echo

    local installed_count=0
    local failed_count=0

    # Use file descriptor 3 to avoid stdin consumption by curl
    while IFS='|' read -r ext_id url profiles <&3 || [[ -n "$ext_id" ]]; do
        # Skip comments and empty lines
        [[ "$ext_id" =~ ^#.*$ ]] && continue
        [[ -z "$ext_id" ]] && continue

        # Check if extension is for this profile type
        if [[ "$profiles" == "all" ]] || [[ "$profiles" =~ (^|,)${profile_type}(,|$) ]]; then
            print_info "Processing: $ext_id"

            # Download extension
            xpi_file=$(download_extension "$ext_id" "$url")
            dl_result=$?

            if [[ $dl_result -eq 0 ]]; then
                # Install to profile
                if install_to_profile "$profile_path" "$ext_id" "$xpi_file"; then
                    installed_count=$((installed_count + 1))
                else
                    failed_count=$((failed_count + 1))
                fi
            else
                failed_count=$((failed_count + 1))
            fi
            echo
        fi
    done 3< "$EXTENSIONS_CONF"

    echo
    print_success "Installation complete!"
    echo "  Installed: $installed_count"
    if [[ $failed_count -gt 0 ]]; then
        echo "  Failed: $failed_count"
    fi
}

# Usage information
usage() {
    cat << EOF
Usage: $0 <profile_path> [profile_type]

Arguments:
  profile_path    Path to the Firefox/LibreWolf profile directory
  profile_type    Type of profile (anonymous, work, development, all)
                  Default: all

Example:
  $0 ~/.waynewolf/profiles/work.default work
  $0 ~/.waynewolf/profiles/anon.default anonymous

EOF
    exit 1
}

# Main execution
if [[ $# -lt 1 ]]; then
    usage
fi

PROFILE_PATH="$1"
PROFILE_TYPE="${2:-all}"

install_extensions "$PROFILE_PATH" "$PROFILE_TYPE"
