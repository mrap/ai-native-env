# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

An open-source AI-native development environment — dotfiles, Claude Code configuration, and a progression system for becoming effective with AI tools. Designed for **any developer, any stack, any team** (and non-technical users too).

This is NOT a traditional software project. There is no build system, no tests, no application code. It is a collection of configuration files, documentation, and interactive wizards meant to be followed by Claude Code.

## Repo Structure

| Path | Purpose |
|------|---------|
| `WIZARD.md` | Step-by-step environment setup wizard (Claude follows interactively) |
| `PERSONAL_CLAUDE_MD_WIZARD.md` | Builds a personalized `~/.claude/CLAUDE.md` through tiered interview |
| `skills/ai-native-coach/SKILL.md` | Ongoing coaching skill for AI-native progression |
| `claude/METHODOLOGY.md` | How the Claude Code environment is configured and used |
| `claude/settings.json` | Claude Code settings (plan mode default, plugins, marketplaces) |
| `scripts/install.sh` | Standalone installer (interactive, gathers name/email/GitHub user) |
| `zsh/`, `nvim/`, `tmux/`, `starship/`, `git/` | Dotfile configs to be symlinked/copied |

## Key Conventions

- **All content is imperative voice** — "Do X", "Prefer Y", "Never Z" in generated CLAUDE.md files.
- **Role-adaptive** — Wizards and coaching adapt to the user's role (engineer, PM, designer, analyst, writer). Never assume the user writes code.
- **Progressive disclosure** — Wizards are tiered (Bronze → Silver → Gold). Users can stop at any tier and have something useful.
- **Git workflow** — Repos live under `~/github.com/<owner>/<repo>`. The `clonerepo` shell function handles this.
- **Config deployment** — Configs are copied (not symlinked) by the installer. Existing files get timestamped backups.
- **Template substitution** — `git/gitconfig.template` uses `__USER_NAME__` and `__USER_EMAIL__` placeholders.

## Working in This Repo

When editing wizards or skills:
- Keep instructions concrete and actionable — no filler prose
- Include role-adaptation tables so Claude asks the right questions for non-engineers
- Every generated CLAUDE.md line must be actionable — delete anything that doesn't change Claude's behavior
- The AI-Native Progression section (Bronze → World Class) should be appended to every generated CLAUDE.md

When editing dotfiles:
- Configs target both macOS and Linux — note platform differences (brew vs apt, fzf paths, clipboard tools)
- The zsh config uses vi mode (`bindkey -v`) — this is intentional
- The tmux prefix is `Ctrl+Space` (not the default `Ctrl+b`)
- Neovim uses 2-space indentation, space as leader key, relative line numbers

## Claude Code Settings Context

The `claude/settings.json` shipped by this repo:
- Default mode is `plan` — Claude requires approval before making changes
- `skipDangerousModePermissionPrompt: true` — pairs with the `--dangerously-skip-permissions` zsh alias for power users
- Three plugins enabled: superpowers (structured workflows), code-review
- Six plugin marketplaces registered (see `claude/METHODOLOGY.md` for details)
