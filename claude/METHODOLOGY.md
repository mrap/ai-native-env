# Claude Code Environment Methodology

How Mike sets up and uses Claude Code for maximum productivity.

## Philosophy

The setup prioritizes a vim-native, terminal-first workflow where Claude Code operates
as a power tool inside tmux, with structured skills/plugins providing guardrails for
complex tasks (brainstorming before building, TDD, systematic debugging, verification
before completion).

## Settings & Permissions

- **Default mode: `plan`** — Claude starts in plan mode, requiring explicit approval
  before making changes. This prevents runaway edits.
- **`skipDangerousModePermissionPrompt: true`** — Combined with the zsh alias
  `claude --dangerously-skip-permissions`, this allows fast iteration when you trust
  Claude to act autonomously. The alias is in `.zshrc`.
- **Editor mode: vim** — Claude respects vim keybindings in its interface.

## Plugin System

Three plugins are enabled:

1. **`superpowers@superpowers-marketplace`** (obra/superpowers-marketplace)
   - The core skill system. Provides structured workflows:
     - `brainstorming` — MUST be used before any creative/building work
     - `writing-plans` — For multi-step tasks, creates implementation plans
     - `executing-plans` — Follows written plans with review checkpoints
     - `test-driven-development` — Write tests before implementation
     - `systematic-debugging` — Structured bug investigation
     - `verification-before-completion` — Run checks before claiming done
     - `subagent-driven-development` — Parallel agent execution
     - `dispatching-parallel-agents` — For independent parallel tasks
     - `finishing-a-development-branch` — Merge/PR/cleanup decisions
     - `requesting-code-review` / `receiving-code-review`
     - `using-git-worktrees` — Isolated feature work
     - `writing-skills` — Creating new skills

2. **`superpowers@claude-plugins-official`** (anthropics/claude-plugins-official)
   - Same superpowers plugin from the official Anthropic marketplace

3. **`code-review@claude-plugins-official`** (anthropics/claude-plugins-official)
   - Structured code review capability

## Marketplace Registry

Six marketplaces are registered (not all plugins from each are enabled):

| Marketplace | Repo | Purpose |
|-------------|------|---------|
| claude-plugins-official | anthropics/claude-plugins-official | Official Anthropic plugins |
| superpowers-marketplace | obra/superpowers-marketplace | Structured workflow skills |
| everything-claude-code | affaan-m/everything-claude-code | Community plugin collection |
| jezweb-skills | jezweb/claude-skills | Additional community skills |
| firebase | firebase/firebase-tools | Firebase tooling |
| ui-ux-pro-max-skill | nextlevelbuilder/ui-ux-pro-max-skill | UI/UX design skills |

## CLAUDE.md Methodology

Every project gets a `CLAUDE.md` at the root. This is how Claude Code learns about
the project. The structure follows this pattern:

### Required Sections

1. **Project Overview** — What the project is, one paragraph
2. **Tech Stack** — Table format: Layer | Choice
3. **Build & Dev Commands** — Exact commands to build, test, run, deploy
4. **Architecture Overview** — How data flows, key patterns, core primitives
5. **Key Design Decisions** — Numbered decisions with rationale

### Optional Sections (for larger projects)

6. **File Structure** — Tree view of important directories
7. **Testing Patterns** — How tests are organized, what fixtures exist
8. **Important Context** — Gotchas, non-obvious design choices

### Principles

- Be specific about commands (exact paths, flags)
- Include the "why" for architectural decisions, not just the "what"
- Reference companion docs (`docs/PLAN.md`, `docs/DESIGN.md`) for deep dives
- Keep it under ~150 lines — this is a quick reference, not a novel

## Project Memory

Claude Code maintains per-project memory at:
`~/.claude/projects/<encoded-path>/memory/MEMORY.md`

This captures:
- Current branch and test status
- Key architecture decisions discovered during work
- File organization patterns
- Testing patterns and fixtures

Memory is updated as Claude works, carrying knowledge across sessions.

## Workflow Patterns

### Starting a New Project

1. Create repo at `~/github.com/<owner>/<repo>`
2. Write `CLAUDE.md` with the sections above
3. Write `docs/` with spec, plan, design docs
4. Claude uses `brainstorming` skill first, then `writing-plans`
5. Execute plan with `executing-plans` skill

### Feature Development

1. `brainstorming` skill to explore requirements
2. `writing-plans` skill to create implementation plan
3. `using-git-worktrees` for isolation (optional)
4. `test-driven-development` — tests first
5. `subagent-driven-development` for parallel independent tasks
6. `verification-before-completion` before claiming done
7. `finishing-a-development-branch` to decide merge/PR

### Debugging

1. `systematic-debugging` skill — structured investigation
2. Never guess — reproduce first, then trace
