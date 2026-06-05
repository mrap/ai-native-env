#!/usr/bin/env bash
# ai-native-env uninstaller
# Removes symlinks and restores backups created by install.sh
set -euo pipefail

# Capture our own path at TOP LEVEL. Inside a function zsh sets $0 to the
# function name (FUNCTION_ARGZERO), and bash's BASH_SOURCE is unset under zsh —
# so this must be read here, before any function runs, to survive `zsh uninstall.sh`.
if [ -n "${ZSH_VERSION:-}" ]; then SELF_SRC="$0"; else SELF_SRC="${BASH_SOURCE[0]:-$0}"; fi

CLONE_DIR="$HOME/.ai-native-env"
ACTIONS=()

# --- Output helpers ---
info()  { printf '  \033[0;32m✓\033[0m %s\n' "$*"; }
warn()  { printf '  \033[1;33m!\033[0m %s\n' "$*"; }
skip()  { printf '  \033[0;90m- %s (skipped)\033[0m\n' "$*"; }

# --- Determine repo directory ---
detect_repo() {
    local script_dir
    script_dir="$(cd "$(dirname "$SELF_SRC")" 2>/dev/null && pwd 2>/dev/null)" || true

    if [ -n "${script_dir:-}" ] && [ -f "$script_dir/zsh/ai-native.zsh" ]; then
        REPO_DIR="$script_dir"
    elif [ -d "$CLONE_DIR/.git" ]; then
        REPO_DIR="$CLONE_DIR"
    else
        # Can't verify symlinks without repo dir, but still proceed
        REPO_DIR=""
        warn "Could not locate ai-native-env repo (checking symlinks by target pattern)"
    fi
}

# --- Find the most recent backup for a file ---
find_latest_backup() {
    local target="$1"
    local latest=""

    # Look for .backup-YYYY-MM-DD and .backup-YYYY-MM-DD.HHMMSS
    for f in "${target}".backup-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*; do
        if [ -e "$f" ]; then
            # Pick the lexicographically last (most recent date)
            if [ -z "$latest" ] || [[ "$f" > "$latest" ]]; then
                latest="$f"
            fi
        fi
    done
    echo "$latest"
}

# --- Remove the ai-native.zsh source line from ~/.zshrc (idempotent) ---
unwire_zshrc() {
    local target="$HOME/.zshrc"
    if [ ! -f "$target" ]; then
        skip "~/.zshrc — not present"
        return 0
    fi
    if ! grep -Fq "ai-native.zsh" "$target"; then
        skip "~/.zshrc — no ai-native.zsh source line"
        return 0
    fi
    local tmp="${target}.uninstall.$$"
    # Drop lines mentioning ai-native.zsh AND the comment marker just above it.
    awk '
      /ai-native.zsh/ { skip_next=0; next }
      /^# AI-native base \(managed by ai-native-env\):/ { next }
      { print }
    ' "$target" > "$tmp"
    mv "$tmp" "$target"
    ACTIONS+=("Removed ai-native.zsh source line from ~/.zshrc")
    info "Unwired ~/.zshrc"
}

# --- Remove a symlink if it points to our repo ---
remove_link() {
    local target="$1" name="$2"

    if [ ! -L "$target" ] && [ ! -e "$target" ]; then
        skip "$name — not present"
        return 0
    fi

    if [ -L "$target" ]; then
        local link_dest
        link_dest="$(readlink "$target")" || true

        # Only remove if it points to our repo
        local is_ours=false
        if [ -n "$REPO_DIR" ] && [[ "$link_dest" == "$REPO_DIR/"* ]]; then
            is_ours=true
        elif [ -z "$REPO_DIR" ] && [[ "$link_dest" == *"/ai-native-env/"* ]]; then
            is_ours=true
        fi

        if [ "$is_ours" = true ]; then
            rm "$target"
            ACTIONS+=("Removed symlink $name")
            info "Removed $name"

            # Restore backup if available
            local backup
            backup="$(find_latest_backup "$target")"
            if [ -n "$backup" ]; then
                mv "$backup" "$target"
                ACTIONS+=("Restored backup $(basename "$backup") → $name")
                info "Restored $(basename "$backup")"
            fi
        else
            skip "$name — not managed by ai-native-env (points to $link_dest)"
        fi
    else
        skip "$name — exists but is not a symlink (not touching)"
    fi
}

# --- Remove a copied file ---
# Only removes if a backup exists (meaning install displaced it) or if the
# file matches our source (meaning install created it fresh). This prevents
# deleting the user's original file on a second run after restore.
remove_copy() {
    local target="$1" name="$2" source="${3:-}"

    if [ ! -e "$target" ]; then
        skip "$name — not present"
        return 0
    fi

    local backup
    backup="$(find_latest_backup "$target")"

    if [ -n "$backup" ]; then
        # Backup exists — install displaced this file, safe to remove and restore
        rm "$target"
        ACTIONS+=("Removed $name")
        info "Removed $name"
        mv "$backup" "$target"
        ACTIONS+=("Restored backup $(basename "$backup") → $name")
        info "Restored $(basename "$backup")"
    elif [ -n "$source" ] && [ -f "$source" ] && cmp -s "$target" "$source"; then
        # No backup, but file matches our source — install created it fresh
        rm "$target"
        ACTIONS+=("Removed $name")
        info "Removed $name"
    else
        skip "$name — not managed by ai-native-env (not touching)"
    fi
}

# --- Main ---
main() {
    echo ""
    echo "=== ai-native-env uninstaller ==="
    echo ""

    detect_repo
    echo ""

    echo "  This will remove ai-native-env dotfiles and restore backups."
    echo ""
    echo "  Files to update/remove:"
    echo "    ~/.zshrc (remove ai-native.zsh source line only)"
    echo "    ~/.config/tmux/tmux.conf (symlink)"
    echo "    ~/.config/tmux/sesh-picker.sh (symlink)"
    echo "    ~/.config/starship.toml (symlink)"
    echo "    ~/.config/nvim/init.lua (symlink)"
    echo "    ~/.claude/settings.json (copy)"
    echo "    ~/.gitconfig (copy)"
    echo ""
    read -p "  Continue? [y/N] " -r || true
    if [[ ! ${REPLY:-} =~ ^[Yy]$ ]]; then
        echo "  Aborted."
        exit 0
    fi
    echo ""

    # Unwire ~/.zshrc (remove only the ai-native.zsh source line)
    unwire_zshrc

    # Remove symlinked dotfiles
    remove_link "$HOME/.config/tmux/tmux.conf"      "~/.config/tmux/tmux.conf"
    remove_link "$HOME/.config/tmux/sesh-picker.sh" "~/.config/tmux/sesh-picker.sh"
    remove_link "$HOME/.config/starship.toml"       "~/.config/starship.toml"
    remove_link "$HOME/.config/nvim/init.lua"       "~/.config/nvim/init.lua"

    # Remove copied files (pass source for content matching when no backup exists)
    local claude_src="${REPO_DIR:+$REPO_DIR/claude/settings.json}"
    remove_copy "$HOME/.claude/settings.json"    "~/.claude/settings.json"  "$claude_src"
    remove_copy "$HOME/.gitconfig"               "~/.gitconfig"

    # Offer to remove the cloned repo
    if [ -d "$CLONE_DIR/.git" ]; then
        echo ""
        read -p "  Also remove cloned repo at $CLONE_DIR? [y/N] " -r || true
        if [[ ${REPLY:-} =~ ^[Yy]$ ]]; then
            rm -rf "$CLONE_DIR"
            ACTIONS+=("Removed $CLONE_DIR")
            info "Removed $CLONE_DIR"
        else
            skip "Keeping $CLONE_DIR"
        fi
    fi

    # --- Summary ---
    echo ""
    echo "=== Done ==="
    if [ ${#ACTIONS[@]} -eq 0 ]; then
        info "Nothing to uninstall."
    else
        for action in "${ACTIONS[@]}"; do
            echo "  • $action"
        done
    fi
    echo ""
}

main "$@"
