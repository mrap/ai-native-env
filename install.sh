#!/usr/bin/env bash
# ai-native-env installer
# Usage:
#   bash <(curl -sL https://raw.githubusercontent.com/mrap/ai-native-env/main/install.sh)
#   git clone ... && bash install.sh
set -uo pipefail

REPO_URL="https://github.com/mrap/ai-native-env.git"
CLONE_DIR="$HOME/.ai-native-env"
BACKUP_SUFFIX=".backup-$(date +%Y-%m-%d)"
ACTIONS=()

# --- Output helpers ---
info()  { printf '  \033[0;32m✓\033[0m %s\n' "$*"; }
warn()  { printf '  \033[1;33m!\033[0m %s\n' "$*"; }
skip()  { printf '  \033[0;90m- %s (skipped)\033[0m\n' "$*"; }

# --- Determine repo directory ---
detect_repo() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd 2>/dev/null)" || true

    if [ -n "${script_dir:-}" ] && [ -f "$script_dir/zsh/zshrc" ]; then
        REPO_DIR="$script_dir"
    elif [ -d "$CLONE_DIR/.git" ]; then
        REPO_DIR="$CLONE_DIR"
        info "Using existing clone at $REPO_DIR"
    else
        if ! command -v git &>/dev/null; then
            echo "Error: git is required. Install it and try again."
            exit 1
        fi
        printf 'Cloning ai-native-env...\n'
        git clone "$REPO_URL" "$CLONE_DIR"
        REPO_DIR="$CLONE_DIR"
        ACTIONS+=("Cloned repo to $CLONE_DIR")
    fi
}

# --- Platform detection ---
detect_platform() {
    case "$(uname -s)" in
        Darwin) PLATFORM="macos" ;;
        Linux)  PLATFORM="linux" ;;
        *)      echo "Unsupported platform: $(uname -s)"; exit 1 ;;
    esac
}

# --- Check dependencies ---
check_deps() {
    local missing=()
    local deps=(git tmux zsh nvim fzf starship)

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done

    if [ ${#missing[@]} -eq 0 ]; then
        info "All dependencies found"
        return 0
    fi

    warn "Missing: ${missing[*]}"
    echo ""
    if [ "$PLATFORM" = "linux" ]; then
        if command -v apt-get &>/dev/null; then
            echo "  Install with: sudo apt-get install ${missing[*]}"
        elif command -v dnf &>/dev/null; then
            echo "  Install with: sudo dnf install ${missing[*]}"
        elif command -v pacman &>/dev/null; then
            echo "  Install with: sudo pacman -S ${missing[*]}"
        fi
    elif [ "$PLATFORM" = "macos" ]; then
        if command -v brew &>/dev/null; then
            echo "  Install with: brew install ${missing[*]}"
        else
            echo "  Install Homebrew first: https://brew.sh"
        fi
    fi
    echo ""
    read -p "  Continue anyway? [y/N] " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
}

# --- Backup helper ---
backup_if_needed() {
    local target="$1"
    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        return 0
    fi
    # Don't backup if it's already our symlink
    if [ -L "$target" ]; then
        local current
        current="$(readlink "$target")" || true
        if [[ "$current" == "$REPO_DIR/"* ]]; then
            return 0
        fi
    fi
    # Don't overwrite an existing backup from today
    if [ -e "${target}${BACKUP_SUFFIX}" ]; then
        mv "$target" "${target}${BACKUP_SUFFIX}.$(date +%H%M%S)"
    else
        mv "$target" "${target}${BACKUP_SUFFIX}"
    fi
    ACTIONS+=("Backed up $(basename "$target")")
}

# --- Symlink a dotfile ---
link_dotfile() {
    local src="$1" dst="$2" name="$3"
    mkdir -p "$(dirname "$dst")"

    # Already correctly linked — idempotent
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        skip "$name — already linked"
        return 0
    fi

    backup_if_needed "$dst"
    ln -sf "$src" "$dst"
    ACTIONS+=("Linked $name → $dst")
    info "Linked $name"
}

# --- Copy a file ---
copy_dotfile() {
    local src="$1" dst="$2" name="$3"
    mkdir -p "$(dirname "$dst")"

    # Already identical — idempotent
    if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
        skip "$name — already up to date"
        return 0
    fi

    backup_if_needed "$dst"
    cp "$src" "$dst"
    ACTIONS+=("Copied $name → $dst")
    info "Copied $name"
}

# --- Git config from template ---
setup_gitconfig() {
    local template="$REPO_DIR/git/gitconfig.template"
    local target="$HOME/.gitconfig"

    # If gitconfig already has user info, confirm before overwriting
    if [ -f "$target" ]; then
        local existing_name existing_email
        existing_name="$(git config --global user.name 2>/dev/null || true)"
        existing_email="$(git config --global user.email 2>/dev/null || true)"

        if [ -n "$existing_name" ] && [ -n "$existing_email" ]; then
            echo ""
            echo "  Git already configured: $existing_name <$existing_email>"
            read -p "  Overwrite with template? [y/N] " -r
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                skip "gitconfig — keeping existing"
                return 0
            fi
        fi
    fi

    echo ""
    read -p "  Full name (for git commits): " -r user_name
    read -p "  Email (for git commits): " -r user_email

    if [ -z "$user_name" ] || [ -z "$user_email" ]; then
        warn "Skipping gitconfig (name and email required)"
        return 0
    fi

    backup_if_needed "$target"
    # Use | delimiter to avoid issues with / in email
    sed "s|__USER_NAME__|${user_name}|g; s|__USER_EMAIL__|${user_email}|g" \
        "$template" > "$target"
    ACTIONS+=("Configured gitconfig")
    info "Configured gitconfig"
}

# --- Main ---
main() {
    echo ""
    echo "=== ai-native-env installer ==="
    echo ""

    detect_repo
    detect_platform
    info "Platform: $PLATFORM"
    info "Source: $REPO_DIR"
    echo ""

    check_deps
    echo ""

    # Symlink dotfiles
    link_dotfile "$REPO_DIR/zsh/zshrc"              "$HOME/.zshrc"                   "zshrc"
    link_dotfile "$REPO_DIR/tmux/tmux.conf"         "$HOME/.config/tmux/tmux.conf"   "tmux.conf"
    link_dotfile "$REPO_DIR/starship/starship.toml"  "$HOME/.config/starship.toml"   "starship.toml"
    link_dotfile "$REPO_DIR/nvim/init.lua"           "$HOME/.config/nvim/init.lua"   "nvim/init.lua"

    # Copy files (personalized, not symlinked)
    copy_dotfile "$REPO_DIR/claude/settings.json"    "$HOME/.claude/settings.json"   "claude/settings.json"

    # Git config (template substitution)
    setup_gitconfig

    # --- Summary ---
    echo ""
    echo "=== Done ==="
    if [ ${#ACTIONS[@]} -eq 0 ]; then
        info "Everything already up to date."
    else
        for action in "${ACTIONS[@]}"; do
            echo "  • $action"
        done
    fi
    echo ""
    echo "  Restart your shell or run: source ~/.zshrc"
    echo ""
}

main "$@"
