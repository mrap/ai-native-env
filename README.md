# ai-native-env

Development environment configuration — zsh, tmux, neovim, starship, git, and Claude Code settings.

## Install

One command:

```bash
bash <(curl -sL https://raw.githubusercontent.com/mrap/ai-native-env/main/install.sh)
```

Or clone first:

```bash
git clone https://github.com/mrap/ai-native-env.git ~/.ai-native-env
cd ~/.ai-native-env && bash install.sh
```

The installer symlinks dotfiles, copies Claude settings, configures git (prompts for name/email), and backs up any existing files to `.backup-YYYY-MM-DD`.

## What's Included

| Component | Target | Description |
|-----------|--------|-------------|
| **zsh** | `~/.zshrc` | Vi-mode shell with git/docker aliases, fzf integration, starship prompt |
| **tmux** | `~/.config/tmux/tmux.conf` | Ctrl+Space prefix, vi copy mode, TPM plugins, Claude Code status bar |
| **starship** | `~/.config/starship.toml` | Minimal prompt with git status, node version, command duration |
| **neovim** | `~/.config/nvim/init.lua` | Space leader, 2-space indent, relative numbers, persistent undo |
| **git** | `~/.gitconfig` | Sane defaults, custom `changes` and `lg` aliases (copied from template) |
| **claude** | `~/.claude/settings.json` | Plan mode, superpowers plugin, code-review, 6 marketplaces |

## Prerequisites

git is required. The installer checks for these and tells you how to install any that are missing:

- tmux, zsh, neovim, fzf, starship

## Uninstall

```bash
bash uninstall.sh
```

Or if you used the curl install:

```bash
bash ~/.ai-native-env/uninstall.sh
```

Removes symlinks and restores backed-up originals. Optionally removes the cloned repo.

## Customize

Dotfiles are symlinked, so edit the source files directly and changes take effect immediately. Files that are copied (gitconfig, claude settings) need to be re-copied or re-run through the installer.

## Setting Up Someone Else

This repo includes a wizard designed for Claude Code to walk a non-technical
person through the full setup. See [WIZARD.md](WIZARD.md).

Open Claude Code and say:
```
Clone https://github.com/mrap/ai-native-env and follow WIZARD.md to set up my environment.
```

## Directory Convention

All GitHub repos live under `~/github.com/<owner>/<repo>`. The `clonerepo`
function in the zsh config handles this automatically:

```bash
clonerepo https://github.com/user/repo
# Clones to ~/github.com/user/repo via SSH
```

## Personal CLAUDE.md Wizard

Your personal `~/.claude/CLAUDE.md` is the most important file in your AI setup.
It tells Claude who you are, how you work, and what you care about — across every
project and session.

The wizard builds one interactively. Works for **anyone** — engineers, PMs,
designers, data analysts, writers.

Open Claude Code and say:
```
Follow the wizard at PERSONAL_CLAUDE_MD_WIZARD.md to build my personal CLAUDE.md.
```

See [PERSONAL_CLAUDE_MD_WIZARD.md](PERSONAL_CLAUDE_MD_WIZARD.md) for details.

## AI-Native Progression

The wizard includes a **Bronze → Silver → Gold → Diamond → World Class** progression
system. You don't write a perfect CLAUDE.md — you grow one through real usage.

To get coached on your current level and next steps:
```
Follow skills/ai-native-coach/SKILL.md to assess my AI-native level.
```

See [skills/ai-native-coach/SKILL.md](skills/ai-native-coach/SKILL.md).

## Claude Code Methodology

See [claude/METHODOLOGY.md](claude/METHODOLOGY.md) for how the Claude Code
environment is configured and the workflow patterns used (brainstorming,
planning, TDD, verification).
