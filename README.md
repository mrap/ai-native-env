# dotfiles

Mike's development environment configuration, packaged for replication.

## What's Included

| Component | Description |
|-----------|-------------|
| **zsh** | Vi-mode shell with git/docker aliases, fzf integration, starship prompt |
| **starship** | Minimal prompt with git status, node version, command duration |
| **neovim** | Clean config: space leader, 2-space indent, relative numbers, persistent undo |
| **tmux** | Ctrl+Space prefix, vi copy mode, TPM plugins, Claude Code status bar |
| **git** | Sane defaults, custom `changes` and `lg` aliases |
| **claude** | Plan mode, superpowers plugin, code-review, 6 marketplaces |

## Quick Start (for yourself)

```bash
# Clone
git clone git@github.com:mrap/dotfiles.git ~/github.com/mrap/dotfiles

# Symlink what you want
ln -sf ~/github.com/mrap/dotfiles/zsh/zshrc ~/.zshrc
ln -sf ~/github.com/mrap/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -sf ~/github.com/mrap/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/github.com/mrap/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
cp ~/github.com/mrap/dotfiles/claude/settings.json ~/.claude/settings.json
```

## Setting Up Someone Else

This repo includes a wizard designed for Claude Code to walk a non-technical
person through the full setup. See [WIZARD.md](WIZARD.md).

Open Claude Code and say:
```
Clone https://github.com/mrap/dotfiles and follow WIZARD.md to set up my environment.
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
