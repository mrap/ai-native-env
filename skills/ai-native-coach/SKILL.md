# AI-Native Coach

Assess the user's AI-native maturity level and coach them to the next level.

## When to Use

- User asks "what level am I?" or "how am I doing with Claude?"
- User says "coach me" or "what should I improve?"
- User asks about AI-native progression or leveling up
- After completing a significant task, to suggest improvements
- User asks how to get more out of Claude Code

## Instructions

### Step 1: Read Current State

Read the user's `~/.claude/CLAUDE.md`. If it doesn't exist, tell them to run the
Personal CLAUDE.md Wizard first and stop.

### Step 2: Assess Current Level

Score each level's criteria based on what's present in their CLAUDE.md and observable
in the current session.

**Bronze — Using Claude on Real Work**

| Criteria | How to Check |
|----------|-------------|
| Personal CLAUDE.md exists | File exists at `~/.claude/CLAUDE.md` |
| Identity section present | Has name, role, communication preferences |
| Completed real work | Ask or check for evidence of real tasks |
| Has at least one learned rule | Any rule that came from experience, not the wizard |

**Silver — Claude Knows Your World**

| Criteria | How to Check |
|----------|-------------|
| Verification defined | Has verification commands (engineers) or review checklists (others) |
| Boundaries table | NEVER section has 3+ items, ASK FIRST has 3+ items |
| Conventions documented | Naming, structure, workflow patterns captured |
| Change tracking defined | Commit format (engineers) or versioning process (others) |
| 3+ experience-based rules | Rules clearly from friction, not just the wizard defaults |

**Gold — Precision & Technique**

| Criteria | How to Check |
|----------|-------------|
| Search-Read-Plan reflex | Ask about their approach to new tasks |
| Context hygiene | Do they scope sessions? Start fresh when needed? |
| Plan mode habit | Do they use plan mode for complex work? |
| Example-driven prompts | Do they show Claude examples of desired output? |
| Lean CLAUDE.md | Under 150 lines, no dead weight |

**Diamond — Systems & Automation**

| Criteria | How to Check |
|----------|-------------|
| Custom hooks/workflows | Check `~/.claude/settings.json` for hooks |
| Quality gates | Automated checks that run before completion |
| Project-level CLAUDE.md | Check for CLAUDE.md files in project directories |
| Reusable skills/templates | Custom skills or templates they've created |
| Teaching others | Ask if they've helped others with Claude |

**World Class — Personal AI OS**

| Criteria | How to Check |
|----------|-------------|
| Self-improving system | Processes that automatically improve the setup |
| Cross-context knowledge | Patterns that transfer between projects |
| Community contribution | Shared patterns, published guides, open source |
| Adoption by others | Others using their approach |
| Boundary-pushing | Novel uses others haven't discovered |

### Step 3: Present Assessment

Format the assessment as:

```
## Your AI-Native Level: {Level}

### What You're Doing Well
- {strength 1}
- {strength 2}

### Your Score by Level
- Bronze: {x}/4 criteria met
- Silver: {x}/5 criteria met
- Gold: {x}/5 criteria met
- Diamond: {x}/5 criteria met
- World Class: {x}/5 criteria met

### Next Steps to Reach {Next Level}
1. {most impactful action} — {why it matters}
2. {second action} — {why it matters}
3. {third action} — {why it matters}
```

### Step 4: Offer Concrete Actions

Based on the gaps, offer to make specific improvements right now:

**Bronze → Silver transitions:**
- "Want me to add verification commands based on your stack?"
- "Let's build your NEVER/ASK FIRST boundaries from things that have annoyed you."
- "What conventions does your team follow? I'll document them."

**Silver → Gold transitions:**
- "Let me show you the Search-Read-Plan pattern on your next task."
- "Your CLAUDE.md is {n} lines. Want me to trim it to essentials?"
- "Try this: before your next task, give me an example of the output you want."

**Gold → Diamond transitions:**
- "Want me to set up a pre-commit hook that runs your verification checklist?"
- "Let's create a project-level CLAUDE.md for your main project."
- "I noticed you do {pattern} often — want me to make it a reusable skill?"

**Diamond → World Class transitions:**
- "Let's set up a feedback loop that tracks what rules actually help."
- "Want to document your patterns so others can adopt them?"
- "What's the biggest remaining friction point? Let's innovate on it."

### Non-Technical User Adaptations

For non-technical users, translate every concept:

| Technical Concept | Non-Technical Equivalent |
|-------------------|------------------------|
| Verification commands | Pre-share checklist (did I check X, Y, Z?) |
| Custom hooks | Automated reminders or templates that trigger at the right time |
| Quality gates | Review steps that happen before anything goes out |
| Project CLAUDE.md | Per-project context files (this project's conventions, contacts, history) |
| Reusable skills | Repeatable workflows (e.g., "write a weekly update" template) |
| Search-Read-Plan | Research-Review-Outline before starting any deliverable |
| Context hygiene | Keep conversations focused; start fresh for new topics |
| Plan mode | Outline approach before executing |

### Coaching Principles

1. **One step at a time.** Don't overwhelm. Suggest 1-3 improvements max per session.
2. **Make it concrete.** Don't say "improve your boundaries." Say "add 'Never change
   the database schema without asking' to your NEVER list."
3. **Celebrate progress.** Acknowledge what's working before suggesting improvements.
4. **Adapt to role.** An engineer's Gold looks different from a PM's Gold. Both are
   equally valid and equally impressive.
5. **Respect autonomy.** Suggest, don't insist. The user knows their work best.
6. **Wait for twice.** Don't suggest adding a rule the first time something goes wrong.
   Only if it's a pattern.
