#!/bin/bash

# =====================================================
# WayneWolf Launcher
# The wolf chooses its hunting ground.
# =====================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# WayneWolf directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WAYNEWOLF_ROOT="$HOME/.waynewolf"
PROFILES_DIR="$WAYNEWOLF_ROOT/profiles"
TEMPLATES_DIR="$SCRIPT_DIR/profile-templates"
USER_JS="$SCRIPT_DIR/user.js"
EXTENSION_INSTALLER="$SCRIPT_DIR/install-extensions.sh"

# Binary location (adjust after build)
WAYNEWOLF_BIN="${WAYNEWOLF_BIN:-$HOME/.local/bin/waynewolf}"

# Profile type mapping
declare -A PROFILE_TEMPLATES=(
    ["dev"]="development"
    ["browse"]="work"
    ["ghost"]="anonymous"
    ["development"]="development"
    ["work"]="work"
    ["anonymous"]="anonymous"
)

# Banner
echo -e "${RED}"
cat << "EOF"
╦ ╦┌─┐┬ ┬┌┐┌┌─┐╦ ╦┌─┐┬  ┌─┐
║║║├─┤└┬┘│││├┤ ║║║│ ││  ├┤
╚╩╝┴ ┴ ┴ ┘└┘└─┘╚╩╝└─┘┴─┘└
     Stealth. Speed. Sovereignty.
EOF
echo -e "${NC}"

# Apply user.js template to profile
apply_userjs() {
    local profile_path="$1"
    local template_type="$2"

    echo -e "${BLUE}[*] Applying user.js configuration...${NC}"

    # Start with base user.js
    if [ -f "$USER_JS" ]; then
        cp "$USER_JS" "$profile_path/user.js"
    else
        echo -e "${YELLOW}[!] Base user.js not found, skipping...${NC}"
        return 1
    fi

    # Append template-specific settings
    local template_file="$TEMPLATES_DIR/${template_type}.js"
    if [ -f "$template_file" ]; then
        echo -e "${BLUE}[*] Applying $template_type template...${NC}"
        echo "" >> "$profile_path/user.js"
        echo "// Template: $template_type" >> "$profile_path/user.js"
        cat "$template_file" >> "$profile_path/user.js"
        echo -e "${GREEN}[✓] Configuration applied${NC}"
    else
        echo -e "${YELLOW}[!] Template not found: $template_file${NC}"
    fi
}

# Install extensions for profile
install_extensions() {
    local profile_path="$1"
    local template_type="$2"

    if [ ! -f "$EXTENSION_INSTALLER" ]; then
        echo -e "${YELLOW}[!] Extension installer not found, skipping...${NC}"
        return 1
    fi

    echo -e "${BLUE}[*] Installing extensions for $template_type profile...${NC}"
    "$EXTENSION_INSTALLER" "$profile_path" "$template_type" || true
}

# Create a new profile with template
create_profile() {
    local profile_name="$1"
    local template_type="${2:-work}"

    local profile_path="$PROFILES_DIR/$profile_name"

    if [ -d "$profile_path" ]; then
        echo -e "${YELLOW}[!] Profile '$profile_name' already exists${NC}"
        read -p "Overwrite configuration? [y/N]: " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo -e "${CYAN}[*] Keeping existing profile${NC}"
            return 0
        fi
    fi

    echo -e "${GREEN}[*] Creating profile: $profile_name ($template_type)${NC}"
    mkdir -p "$profile_path"

    # Apply configurations
    apply_userjs "$profile_path" "$template_type"
    install_extensions "$profile_path" "$template_type"

    echo -e "${GREEN}[✓] Profile created: $profile_path${NC}"
}

# Initialize default profiles if not exists
init_profiles() {
    if [ ! -d "$PROFILES_DIR" ]; then
        echo -e "${YELLOW}[*] Initializing WayneWolf profiles...${NC}"
        mkdir -p "$PROFILES_DIR"

        # Create default profiles with templates
        create_profile "dev" "development"
        create_profile "browse" "work"
        create_profile "ghost" "anonymous"

        echo -e "${GREEN}[✓] Default profiles initialized${NC}"
    fi
}

# Profile selector
select_profile() {
    echo -e "${CYAN}[?] Select your hunting ground:${NC}"
    echo ""
    echo "  1) dev     - Development mode (tools enabled, moderate privacy)"
    echo "  2) browse  - Daily browsing (balanced privacy and features)"
    echo "  3) ghost   - Maximum stealth (no trace, Tor-ready)"
    echo ""
    read -p "Choice [1-3]: " choice

    case $choice in
        1) PROFILE="dev" ;;
        2) PROFILE="browse" ;;
        3) PROFILE="ghost" ;;
        *)
            echo -e "${RED}[!] Invalid choice. Defaulting to 'browse'${NC}"
            PROFILE="browse"
            ;;
    esac
}

# Launch WayneWolf
launch() {
    PROFILE_PATH="$PROFILES_DIR/$PROFILE"

    # Ensure profile exists
    if [ ! -d "$PROFILE_PATH" ]; then
        echo -e "${RED}[!] Profile '$PROFILE' not found at $PROFILE_PATH${NC}"
        exit 1
    fi

    echo -e "${GREEN}[✓] Launching WayneWolf in ${YELLOW}$PROFILE${GREEN} mode...${NC}"
    echo -e "${CYAN}[*] Profile: $PROFILE_PATH${NC}"

    # Build launch flags
    FLAGS="--profile $PROFILE_PATH"

    # Ghost mode extras
    if [ "$PROFILE" = "ghost" ]; then
        echo -e "${YELLOW}[*] Ghost mode: Private browsing enabled${NC}"
        FLAGS="$FLAGS --private-window"
    fi

    # Launch
    if command -v "$WAYNEWOLF_BIN" &> /dev/null; then
        exec $WAYNEWOLF_BIN $FLAGS "$@"
    else
        echo -e "${RED}[!] WayneWolf binary not found: $WAYNEWOLF_BIN${NC}"
        echo -e "${YELLOW}[*] Build it first with: make build${NC}"
        exit 1
    fi
}

# List available profiles
list_profiles() {
    echo -e "${CYAN}[*] Available profiles:${NC}"
    echo ""
    if [ -d "$PROFILES_DIR" ]; then
        for profile in "$PROFILES_DIR"/*; do
            if [ -d "$profile" ]; then
                local name=$(basename "$profile")
                local template="${PROFILE_TEMPLATES[$name]:-unknown}"
                echo -e "  ${GREEN}$name${NC} ($template)"
            fi
        done
    else
        echo -e "${YELLOW}[!] No profiles found${NC}"
    fi
}

# Show usage information
show_usage() {
    cat << EOF
${GREEN}WayneWolf Launcher${NC}

Usage: $0 [COMMAND|PROFILE] [OPTIONS]

${CYAN}Quick Launch:${NC}
  $0                    Interactive profile selector
  $0 dev               Launch development profile
  $0 browse            Launch work/browsing profile
  $0 ghost             Launch anonymous profile

${CYAN}Profile Management:${NC}
  --create NAME TYPE   Create new profile (TYPE: development, work, anonymous)
  --list               List all profiles
  --reset NAME         Reset profile configuration and extensions

${CYAN}Extensions:${NC}
  --install-ext NAME   Install extensions to existing profile

${CYAN}Examples:${NC}
  $0 browse                           # Launch browsing profile
  $0 --create mywork work             # Create work profile
  $0 --install-ext mywork             # Install extensions to mywork profile
  $0 dev --private-window             # Launch dev profile in private mode

${CYAN}Profile Types:${NC}
  development    Developer tools, relaxed security, all APIs enabled
  work           Balanced privacy and convenience for daily use
  anonymous      Maximum privacy, no persistence, Tor-ready

EOF
}

# Main
main() {
    # Handle special commands
    case "$1" in
        --help|-h)
            show_usage
            exit 0
            ;;
        --list)
            init_profiles
            list_profiles
            exit 0
            ;;
        --create)
            if [ -z "$2" ] || [ -z "$3" ]; then
                echo -e "${RED}[!] Usage: $0 --create NAME TYPE${NC}"
                echo -e "${CYAN}[*] Available types: development, work, anonymous${NC}"
                exit 1
            fi
            create_profile "$2" "$3"
            exit 0
            ;;
        --install-ext)
            if [ -z "$2" ]; then
                echo -e "${RED}[!] Usage: $0 --install-ext PROFILE_NAME${NC}"
                exit 1
            fi
            PROFILE_PATH="$PROFILES_DIR/$2"
            TEMPLATE_TYPE="${PROFILE_TEMPLATES[$2]:-work}"
            if [ ! -d "$PROFILE_PATH" ]; then
                echo -e "${RED}[!] Profile not found: $2${NC}"
                exit 1
            fi
            install_extensions "$PROFILE_PATH" "$TEMPLATE_TYPE"
            exit 0
            ;;
        --reset)
            if [ -z "$2" ]; then
                echo -e "${RED}[!] Usage: $0 --reset PROFILE_NAME${NC}"
                exit 1
            fi
            TEMPLATE_TYPE="${PROFILE_TEMPLATES[$2]:-work}"
            create_profile "$2" "$TEMPLATE_TYPE"
            exit 0
            ;;
    esac

    # Initialize profiles
    init_profiles

    # Check if profile specified as argument
    if [ -n "$1" ] && [[ "$1" =~ ^(dev|browse|ghost)$ ]]; then
        PROFILE="$1"
        shift
    else
        select_profile
    fi

    launch "$@"
}

main "$@"
