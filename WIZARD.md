# Environment Setup Wizard

Instructions for Claude Code to set up this environment for a new user.

## How to Use This

Open Claude Code on the new machine and paste:

```
I want to set up my development environment. Follow the wizard in this repo:
https://github.com/mrap/dotfiles
Clone it and follow WIZARD.md step by step. Ask me questions along the way.
```

## Wizard Flow

Claude should follow these steps interactively, asking the user for input at
each decision point. The user may be non-technical — use simple language and
explain what each tool does before installing it.

### Step 1: Gather User Info

Ask:
- "What is your full name?" (for git config)
- "What is your email address?" (for git config)
- "What is your GitHub username?" (for directory structure)

### Step 2: Install System Dependencies

Check what's already installed and install what's missing:

```bash
# Required
sudo apt update
sudo apt install -y zsh git curl wget tmux fzf neovim

# Set zsh as default shell
chsh -s $(which zsh)

# Install starship prompt
curl -sS https://starship.rs/install.sh | sh

# Install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# Then: nvm install --lts

# Install GitHub CLI (optional but recommended)
# See: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
```

Tell the user what each tool is:
- **zsh** — A better shell than the default bash
- **starship** — Makes your terminal prompt pretty and informative
- **tmux** — Lets you have multiple terminal windows and keeps them running
- **fzf** — Fuzzy finder for searching files and command history
- **neovim** — A modern text editor (used by Claude for editing)
- **nvm** — Manages Node.js versions (needed for web development)

### Step 3: Create Directory Structure

```bash
mkdir -p ~/github.com/__GITHUB_USERNAME__
```

Explain: "We organize all GitHub repos under `~/github.com/username/repo-name`.
This keeps everything tidy and matches how GitHub organizes things."

### Step 4: Deploy Config Files

Ask the user which configs they want (default: all):

| Config | Source | Destination | What it does |
|--------|--------|-------------|--------------|
| ZSh | `zsh/zshrc` | `~/.zshrc` | Shell configuration, aliases, vim mode |
| Starship | `starship/starship.toml` | `~/.config/starship.toml` | Terminal prompt theme |
| Neovim | `nvim/init.lua` | `~/.config/nvim/init.lua` | Text editor settings |
| Tmux | `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | Terminal multiplexer |
| Git | `git/gitconfig.template` | `~/.gitconfig` | Git settings and aliases |

For the git config, substitute `__USER_NAME__` and `__USER_EMAIL__` with the
values gathered in Step 1.

For the zsh config, make these adjustments:
- Update the `clonerepo` function if the user wants a different directory structure
- The `claude` alias uses `--dangerously-skip-permissions` — explain this means
  Claude can make changes without asking permission each time. Ask if they want this.
- The fzf source paths may differ on macOS vs Linux — check and adjust

### Step 5: Install Tmux Plugins

```bash
# TPM (Tmux Plugin Manager) auto-installs on first tmux launch via the config
# But we can pre-install:
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
~/.config/tmux/plugins/tpm/bin/install_plugins
```

### Step 6: Set Up Claude Code

```bash
# Install Claude Code if not already installed
# npm install -g @anthropic-ai/claude-code

# Deploy settings
mkdir -p ~/.claude
cp claude/settings.json ~/.claude/settings.json
```

Explain each plugin to the user:
- **superpowers** — "This gives Claude structured workflows. Instead of just
  diving in, Claude will brainstorm first, make a plan, then execute step by step.
  It's like having a senior engineer's discipline built in."
- **code-review** — "Claude can review code like a teammate would."

Ask: "Do you want all the plugin marketplaces registered? They give Claude access
to community-made skills." (Default: yes)

### Step 7: Set Up SSH Keys (if needed)

```bash
# Check if SSH keys exist
ls ~/.ssh/id_ed25519.pub 2>/dev/null || {
  ssh-keygen -t ed25519 -C "__USER_EMAIL__"
  echo "Copy this key and add it to GitHub > Settings > SSH Keys:"
  cat ~/.ssh/id_ed25519.pub
}
```

### Step 8: Create Secrets File

```bash
touch ~/.secrets
chmod 600 ~/.secrets
```

Explain: "This file is where you'll put API keys and tokens. It's loaded by your
shell but never committed to git. You'll add your Anthropic API key here later."

### Step 9: Verification

Run these checks and report results:

```bash
echo "Shell: $(echo $SHELL)"
echo "Zsh version: $(zsh --version)"
echo "Starship: $(starship --version 2>&1 | head -1)"
echo "Neovim: $(nvim --version 2>&1 | head -1)"
echo "Tmux: $(tmux -V)"
echo "Node: $(node --version 2>/dev/null || echo 'not installed yet')"
echo "Git user: $(git config user.name) <$(git config user.email)>"
echo "Claude: $(claude --version 2>/dev/null || echo 'not installed yet')"
```

### Step 10: Quick Tour

Give the user a brief tour of what they now have:

- "Type `gs` to check git status, `gl` to see git log"
- "Type `ll` to list files in detail"
- "Type `zz` to edit your shell config, `szz` to reload it"
- "In tmux, press `Ctrl+Space` then `c` for a new window"
- "In tmux, press `Ctrl+Space` then `Ctrl+V` for a vertical split"
- "In vim, press `Space` then `w` to save, `Space` then `q` to quit"
- "Use `clonerepo https://github.com/user/repo` to clone repos into the right place"

### Step 11: Personal CLAUDE.md

After the environment is set up, offer to run the Personal CLAUDE.md Wizard:

"Now that your environment is ready, let's personalize how Claude works with you.
This creates a personal instruction file that follows you across every project."

```
Follow the wizard at PERSONAL_CLAUDE_MD_WIZARD.md to build my personal CLAUDE.md.
```

This step is optional but highly recommended. It takes 10-30 minutes and makes
every future Claude session better. Works for technical and non-technical users.

See [PERSONAL_CLAUDE_MD_WIZARD.md](PERSONAL_CLAUDE_MD_WIZARD.md).

## Customization Points

The wizard should ask about these and adjust accordingly:

1. **Editor preference** — Not everyone wants vim mode. Offer to remove `bindkey -v`
   from zshrc if they prefer standard key bindings.
2. **Claude permissions** — The `--dangerously-skip-permissions` flag is power-user
   territory. For a new user, consider removing this alias.
3. **Docker aliases** — Only include if they'll use Docker.
4. **Tmux** — Some people find tmux confusing. Make it optional.
5. **Color scheme** — The starship config uses simple symbols. They can customize later.

## Platform Notes

### macOS Differences
- Install with `brew` instead of `apt`
- fzf keybinding paths differ: `$(brew --prefix)/opt/fzf/shell/key-bindings.zsh`
- Clipboard in tmux: use `pbcopy` (already in config)
- Neovim: `brew install neovim`

### Linux (Ubuntu/Debian)
- Everything in this repo is set up for Linux
- fzf paths: `/usr/share/doc/fzf/examples/`
- Clipboard in tmux: may need `xclip` or `wl-copy`
