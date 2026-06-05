#!/usr/bin/env bash
# Runs INSIDE the container as the test user. Drives install.sh with the given
# interpreter, then asserts observable outcomes (black-box). Exits non-zero on any failure.
#   usage: assert.sh <bash|zsh>
set -uo pipefail
INTERP="${1:-bash}"
REPO=/repo
FAILS=0
ok(){ printf '  \033[0;32mPASS\033[0m %s\n' "$*"; }
no(){ printf '  \033[0;31mFAIL\033[0m %s\n' "$*"; FAILS=$((FAILS+1)); }

echo "### scenario: install via '$INTERP' (HOME=$HOME) ###"

# --- drive the installer non-interactively (name, email; extra y's are harmless) ---
printf 'Test User\ntest@example.com\ny\ny\n' | "$INTERP" "$REPO/install.sh" > /tmp/install.out 2>&1
rc=$?
[ $rc -eq 0 ] && ok "install.sh exited 0 under $INTERP" || { no "install.sh exited $rc under $INTERP"; sed 's/^/    | /' /tmp/install.out; }

# --- the installer must NOT have fallen back to a network clone (detect_repo works) ---
if grep -qiE 'cloning|git clone' /tmp/install.out; then no "installer tried to clone (detect_repo failed to find local repo)"; else ok "used local repo (no clone fallback)"; fi

# --- ~/.zshrc exists and sources the base module ---
[ -f "$HOME/.zshrc" ] && ok "~/.zshrc exists" || no "~/.zshrc missing"
if grep -q 'ai-native.zsh' "$HOME/.zshrc" 2>/dev/null; then ok "~/.zshrc sources ai-native.zsh"; else no "~/.zshrc does not source ai-native.zsh"; fi

# --- ~/.secrets created, mode 600 ---
if [ -f "$HOME/.secrets" ]; then
  mode=$(stat -c '%a' "$HOME/.secrets")
  [ "$mode" = "600" ] && ok "~/.secrets is chmod 600" || no "~/.secrets mode is $mode (want 600)"
else no "~/.secrets not created"; fi

# --- configs symlinked into the repo ---
for pair in "$HOME/.config/tmux/tmux.conf" "$HOME/.config/nvim/init.lua" "$HOME/.config/starship.toml"; do
  if [ -L "$pair" ]; then ok "symlink $(basename "$pair") -> $(readlink "$pair")"; else no "$pair is not a symlink"; fi
done
[ -f "$HOME/.claude/settings.json" ] && ok "~/.claude/settings.json present (copied)" || no "~/.claude/settings.json missing"

# --- idempotency: run again, source line must appear exactly once, exit 0 ---
printf 'Test User\ntest@example.com\ny\ny\n' | "$INTERP" "$REPO/install.sh" > /tmp/install2.out 2>&1
rc2=$?
[ $rc2 -eq 0 ] && ok "second install.sh run exited 0 (idempotent)" || { no "second run exited $rc2"; sed 's/^/    | /' /tmp/install2.out; }
n=$(grep -c 'ai-native.zsh' "$HOME/.zshrc" 2>/dev/null || echo 0)
[ "$n" = "1" ] && ok "source line present exactly once after 2 runs" || no "source line count = $n (want 1)"

# --- the base module loads cleanly under interactive zsh (loads ~/.zshrc -> base) ---
if zsh -ic 'exit' > /tmp/zload.out 2>&1; then ok "interactive zsh loads ~/.zshrc + base with no fatal error"; else no "interactive zsh failed to load"; sed 's/^/    | /' /tmp/zload.out; fi
# --- base module passes zsh syntax check ---
if zsh -n "$REPO/zsh/ai-native.zsh" 2>/tmp/zn.out; then ok "zsh -n ai-native.zsh (syntax ok)"; else no "ai-native.zsh syntax error"; sed 's/^/    | /' /tmp/zn.out; fi

echo "### $INTERP scenario: $FAILS failure(s) ###"
exit $([ $FAILS -eq 0 ] && echo 0 || echo 1)
