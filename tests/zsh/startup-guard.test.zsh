#!/usr/bin/env zsh
# Startup guard test for zsh/ai-native.zsh.
# Proves: when the first external tool does not answer, the base falls back to
# a plain prompt within the deadline instead of hanging the shell; when the
# tool answers, nothing changes. Black-box: drives a real interactive zsh with
# an isolated HOME and a fake `starship` on PATH.
#   run: zsh tests/zsh/startup-guard.test.zsh
emulate -L zsh
setopt err_return no_unset
zmodload zsh/datetime
local here=${0:A:h} repo=${0:A:h:h:h}
local -i fails=0
ok(){ print "  PASS $*"; }
no(){ print "  FAIL $*"; (( fails++ )) || true; }
local tmp; tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin"

# Both fakes print a starship-style init when asked; the stalled one never
# answers `--version` (a process wedged behind macOS Gatekeeper looks exactly
# like this: exec started, nothing comes back).
print -r -- '#!/bin/sh
[ "$1" = "--version" ] && sleep 30
echo "PROMPT=\"fake> \""' > "$tmp/bin/starship.stalled"
print -r -- '#!/bin/sh
[ "$1" = "--version" ] && { echo "starship 0.0-fake"; exit 0; }
echo "PROMPT=\"fake> \""' > "$tmp/bin/starship.fast"
chmod +x "$tmp/bin/starship."*

run_shell() {  # $1 = fake variant, rest = extra env; prints mode=<n> and PROMPT
  local variant=$1; shift
  cp "$tmp/bin/starship.$variant" "$tmp/bin/starship"
  env -i HOME="$tmp" TERM=dumb PATH="$tmp/bin:/usr/bin:/bin" "$@" \
    zsh -ic "source '$repo/zsh/ai-native.zsh'; print \"mode=\$AIN_SAFE_MODE prompt=\$PROMPT\"" 2>&1
}

print "### scenario 1: stalled tool -> safe mode, prompt within deadline ###"
local t0=$EPOCHREALTIME out
out=$(run_shell stalled AIN_EXEC_DEADLINE=0.3) || true
local -F elapsed=$(( EPOCHREALTIME - t0 ))
[[ $out == *"mode=1"* ]] && ok "AIN_SAFE_MODE=1" || no "expected mode=1, got: $out"
[[ $out == *"ai-native: 'starship --version' did not answer"* ]] && ok "loud stderr notice" || no "no notice: $out"
[[ $out == *"prompt=%F{yellow}[safe]"* ]] && ok "plain [safe] prompt set" || no "prompt not set: $out"
[[ $out != *"fake>"* ]] && ok "starship init skipped" || no "starship init ran in safe mode"
(( elapsed < 3.0 )) && ok "shell ready in ${elapsed}s (< 3s)" || no "took ${elapsed}s"

print "### scenario 2: healthy tool -> normal startup ###"
out=$(run_shell fast) || true
[[ $out == *"mode=0"* ]] && ok "AIN_SAFE_MODE=0" || no "expected mode=0, got: $out"
[[ $out == *"prompt=fake>"* ]] && ok "starship init applied" || no "starship init missing: $out"
[[ $out != *"ai-native:"* ]] && ok "no notice" || no "unexpected notice: $out"

print "### scenario 3: AIN_SAFE_MODE=1 forced -> no probe, inits skipped ###"
t0=$EPOCHREALTIME
out=$(run_shell stalled AIN_SAFE_MODE=1) || true
elapsed=$(( EPOCHREALTIME - t0 ))
[[ $out == *"mode=1"* && $out != *"fake>"* ]] && ok "forced safe mode skips starship" || no "forced mode wrong: $out"
(( elapsed < 3.0 )) && ok "no probe wait (${elapsed}s)" || no "forced mode still waited ${elapsed}s"

print "### scenario 5: wedged probe child is killed, not orphaned ###"
# Regression: killing a shell wrapper would orphan the real stuck exec (the
# pile-up this guard prevents). The probe execs the command AS the coproc, so
# the kill reaches it. Isolated in its own shell: the probe returning non-zero
# is the expected result and must not trip this suite's err_return.
local s5
s5=$(zsh -f -c '
  source "'"$repo"'/zsh/ai-native.zsh" >/dev/null 2>&1
  sd=$(mktemp -d); printf "#!/bin/sh\nsleep 30\n" > "$sd/stall"; chmod +x "$sd/stall"
  _ain_exec_answers 0.3 "$sd/stall"; rc=$?
  sleep 0.5
  leaked=$(pgrep -f "$sd/stall" | wc -l | tr -d " ")
  print "rc=$rc leaked=$leaked"
  rm -rf "$sd"
') || true
[[ $s5 == *"rc=1"* ]] && ok "wedged probe returns stuck (rc=1)" || no "probe result: $s5"
[[ $s5 == *"leaked=0"* ]] && ok "no orphaned child after kill" || no "leak result: $s5"

print "### scenario 4: syntax ###"
zsh -n "$repo/zsh/ai-native.zsh" && ok "zsh -n ai-native.zsh" || no "syntax error"

print "### $fails failure(s) ###"
(( fails == 0 ))
