# End-to-end install tests

Clean-room Docker tests that prove `install.sh` works end-to-end, driven by **both
bash and zsh**, producing a valid zsh setup. Local-only (not wired into CI).

## Run

```bash
bash tests/e2e/run.sh
```

Exits non-zero if any scenario fails.

## What it does

- Builds a minimal Ubuntu image with real `bash` + `zsh` and stubbed optional deps
  (`tmux`/`nvim`/`fzf`/`starship`/`sesh`) so `check_deps` passes without heavy installs.
- For each interpreter in `{bash, zsh}`, runs the installer in a fresh container as a
  non-root user, with the repo mounted read-only and **`--network none`** (a correct
  install never needs the network — any clone fallback fails loudly).
- Asserts observable outcomes (black-box): `~/.zshrc` sources `ai-native.zsh`, `~/.secrets`
  is chmod 600, configs are symlinked, the install is idempotent (source line appears
  exactly once after two runs), and an interactive `zsh` loads the result with no errors.

## Files

- `Dockerfile` — the test image.
- `run.sh`     — host entrypoint; builds image, runs the bash/zsh matrix.
- `assert.sh`  — in-container assertions for one interpreter.
