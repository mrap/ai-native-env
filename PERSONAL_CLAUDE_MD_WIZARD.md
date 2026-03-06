# Personal CLAUDE.md Wizard

Instructions for Claude Code to build a personalized `~/.claude/CLAUDE.md` through
interactive conversation. This wizard works for **anyone** — engineers, PMs, designers,
data analysts, writers, ops — anyone who uses Claude Code.

## How to Use

Open Claude Code and say:

```
Follow the wizard at PERSONAL_CLAUDE_MD_WIZARD.md to build my personal CLAUDE.md.
```

## How This Works

You'll answer questions in progressive tiers. **Stop at any tier** and you'll still
have something useful. Each tier builds on the last. The whole thing takes 10-30 minutes
depending on how deep you go.

The output is a `~/.claude/CLAUDE.md` file — your personal instruction set that follows
you across every project and session.

---

## Wizard Instructions (for Claude)

Follow these tiers in order. Use `AskUserQuestion` for each section. After each tier,
offer to generate what you have so far or continue to the next tier.

Write the generated CLAUDE.md in **imperative voice** ("Do X", "Prefer Y", "Never Z").
Every line must be actionable — no filler, no philosophy.

### Important: Adapt to the User

Not every user writes code. Adapt your questions and the generated CLAUDE.md to their
actual work:

| Role | "Code" equivalent | "Testing" equivalent | "Debugging" equivalent |
|------|-------------------|---------------------|----------------------|
| Engineer | Source code | Unit/integration tests | Stack traces, logs |
| PM | PRDs, specs, roadmaps | Stakeholder review, data validation | Requirement gaps, priority conflicts |
| Designer | Mockups, prototypes | User testing, design review | Usability issues, consistency problems |
| Data Analyst | Queries, notebooks, dashboards | Data validation, sanity checks | Data quality issues, metric discrepancies |
| Writer | Docs, posts, copy | Editorial review, fact-checking | Clarity issues, audience mismatch |
| Ops/Infra | Configs, runbooks, automation | Monitoring, alerting verification | Incident investigation, system diagnosis |

---

## Tier 1: Identity (30 seconds) — Bronze

**Goal:** Claude knows who you are and how to talk to you.

Ask:
1. "What's your name?"
2. "What's your role? What do you actually do day-to-day?" (Don't assume engineer — let them describe it)
3. "How should I communicate with you?"
   - Options: Concise and direct / Detailed with explanations / Casual and conversational / Formal and structured
4. "When you're wrong about something, should I push back directly or be diplomatic about it?"

**Generate these sections:**

```markdown
# About Me
- Name: {name}
- Role: {role}
- Day-to-day: {description}

# How to Communicate
- Style: {style}
- Push-back: {preference}
```

---

## Tier 2: Your World (5 minutes) — Bronze

**Goal:** Claude understands your tools, stack, and environment.

**For technical users,** ask:
1. "What languages and frameworks do you work with most?"
2. "What's your dev environment? (terminal-first, IDE like VS Code, hybrid)"
3. "What key tools do you use?" (Docker, cloud providers, CI/CD, databases, etc.)
4. "What OS/platform are you on?"
5. "Any project structure conventions you follow?"

**For non-technical users,** ask:
1. "What tools do you use most for your work?" (Google Docs, Sheets, Figma, Jira, Notion, Slack, etc.)
2. "Where does your work product live?" (wiki, Google Drive, shared folders, task boards)
3. "What formats do you work in?" (docs, spreadsheets, slides, email, chat)
4. "What OS/platform are you on?"
5. "Any naming conventions or organizational structures your team follows?"

**Generate / append to `# About Me`:**

```markdown
## My Stack
- Primary: {languages/tools}
- Environment: {setup}
- Platform: {os}
- Key tools: {tools}
- Conventions: {conventions}
```

---

## Tier 3: Working Style (10 minutes) — Silver

**Goal:** Claude matches your workflow, not the other way around.

Ask everyone:
1. "When you start a new piece of work, do you plan first, dive in and iterate, or a mix?"
2. "How do you verify your work is correct before sharing it?"
   - Engineers: tests, type checking, linting
   - PMs: stakeholder review, data checks, cross-referencing requirements
   - Designers: design review, user testing, component audits
   - Analysts: data validation, sanity checks, peer review
   - Writers: editorial review, fact-checking, style guide compliance
3. "What does your review process look like?"
   - Engineers: code review — what dimensions matter (correctness, readability, security, performance)?
   - PMs: who reviews your docs? What do they care about?
   - Designers: who gives design feedback? What do they focus on?
   - Everyone: what's the approval flow?
4. "How do you want to use Claude? Pick the modes that fit:"
   - Pair worker (we think through it together)
   - Autonomous executor (I give direction, you deliver)
   - Reviewer/critic (check my work, find problems)
   - Teacher (explain things, help me learn)
   - Brainstorm partner (explore ideas, challenge assumptions)
5. "How do you handle version control / tracking changes?"
   - Engineers: git workflow (trunk-based, feature branches, conventional commits)
   - Everyone else: versioning docs, tracking changes, naming conventions
6. "When something goes wrong, how do you debug/investigate?"
   - Engineers: structured hypotheses vs exploratory
   - PMs: root cause analysis, stakeholder interviews, data forensics
   - Everyone: systematic vs intuitive

**Generate these sections:**

```markdown
# How I Work
- Planning: {style}
- Verification: {approach}
- Review: {process}
- Claude's role: {modes}
- Version control: {workflow}
- Debugging: {approach}

# Verification Commands
{For engineers: exact commands to run — build, test, lint, typecheck}
{For others: checklist of verification steps}

# Commit Format / Change Tracking
{For engineers: commit message format, branch naming}
{For others: document versioning, naming conventions}
```

---

## Tier 4: Boundaries & Values (10 minutes) — Silver

**Goal:** Claude knows your non-negotiables and respects them without being told twice.

Ask:
1. "Rank these in order of importance for your work:"
   - Engineers: readability, performance, security, simplicity, maintainability
   - PMs: clarity, completeness, actionability, brevity, data-backed
   - Designers: consistency, accessibility, delight, simplicity, brand alignment
   - Analysts: accuracy, reproducibility, clarity, timeliness, actionability
   - Writers: clarity, accuracy, voice consistency, engagement, brevity
2. "What should Claude NEVER do?" (pet peeves, non-negotiables)
   - Examples for engineers: "Never use `any` type", "Never commit without tests"
   - Examples for PMs: "Never make up metrics", "Never skip the 'why'"
   - Examples for designers: "Never deviate from the design system", "Never use stock photos"
   - Examples for analysts: "Never round prematurely", "Never present correlation as causation"
   - Examples for writers: "Never use jargon without defining it", "Never use passive voice"
3. "What should Claude ASK FIRST before doing?" (things requiring permission)
   - Examples: deleting files, changing architecture, sending messages, restructuring docs,
     modifying shared resources, changing data models
4. "What frustrates you about AI assistants?"
   - Common answers to watch for: too verbose, too cautious, doesn't push back,
     makes things up, over-explains, doesn't follow instructions
5. "How do you feel about documentation?"
   - Do you want Claude to document as it goes? Only when asked? Auto-generate?

**Generate these sections:**

```markdown
# Quality Priorities (in order)
1. {first}
2. {second}
3. {third}
4. {fourth}
5. {fifth}

# Boundaries

## NEVER
- {non-negotiable 1}
- {non-negotiable 2}
...

## ASK FIRST
- {permission-required 1}
- {permission-required 2}
...

# Documentation
- {preference}
```

---

## Tier 5: Autonomy & Efficiency (5 minutes) — Gold

**Goal:** Claude works at your speed with your preferred tools.

Ask:
1. "For common tasks, do you have preferred tools or commands?"

   **For engineers:**
   | Task | Options |
   |------|---------|
   | Search code | grep, ripgrep, IDE search, Grep tool |
   | Build | make, npm, cargo, gradle, etc. |
   | Test | pytest, jest, go test, etc. |
   | Lint | eslint, ruff, golangci-lint, etc. |

   **For non-technical users:**
   | Task | Options |
   |------|---------|
   | Research | web search, internal wikis, specific databases |
   | Create documents | Google Docs, Notion, Word, markdown |
   | Data analysis | Sheets, Excel, SQL, Python notebooks |
   | Communication | email drafts, chat messages, doc comments |

2. "When should Claude work independently vs check in with you?"
   - Small changes: just do it / check first
   - Medium tasks: outline plan then execute / step-by-step approval
   - Large tasks: always plan first / trust Claude's judgment
3. "Any context management preferences?"
   - Keep sessions focused on one thing vs juggle multiple
   - How much prior context to reference
   - When to start fresh vs continue

**Generate these sections:**

```markdown
# Tool Preferences
| Task | Tool |
|------|------|
| {task} | {tool} |
...

# Autonomy
- Small changes: {preference}
- Medium tasks: {preference}
- Large tasks: {preference}

# Context
- {preferences}
```

---

## Generation Phase

After completing the tiers (or when the user says to stop), generate the full
`~/.claude/CLAUDE.md`:

1. Combine all sections from completed tiers
2. Write in imperative voice throughout
3. Append the AI-Native Progression section (below)
4. Write the file to `~/.claude/CLAUDE.md`
5. Show the user what was generated
6. Tell them: "This is your starting point. The real power comes from growing it
   through use. When you notice Claude doing something you don't like, add a rule.
   When a pattern works, capture it. See the AI-Native Progression section for
   your roadmap."

### AI-Native Progression Section to Append

Always append this section to every generated CLAUDE.md:

```markdown
# AI-Native Progression

Current level: Bronze

## The Levels

### Bronze — Using Claude on Real Work
You have a personal CLAUDE.md with identity and communication preferences.
You've completed your first real work session with Claude.
- [x] Created personal CLAUDE.md (you're here!)
- [ ] Completed a real task with Claude (not just a test)
- [ ] Added one rule based on something that went wrong

### Silver — Claude Knows Your World
Claude consistently matches your working style without being corrected.
- [ ] Verification commands/checklists defined and working
- [ ] Boundaries table (NEVER/ASK FIRST) has 3+ entries each
- [ ] Conventions documented (naming, structure, workflow)
- [ ] Commit format or change tracking process defined
- [ ] Added 3+ rules from real friction points

### Gold — Precision & Technique
You instinctively use Claude's strengths and work around its weaknesses.
- [ ] Search-Read-Plan is reflex before any non-trivial task
- [ ] Context hygiene: you scope sessions, manage window, start fresh when needed
- [ ] Plan mode is default for anything touching 3+ files or concepts
- [ ] You give Claude examples of what you want, not just descriptions
- [ ] CLAUDE.md is under 150 lines and every line earns its place

### Diamond — Systems & Automation
You've built systems that make AI-native work effortless and repeatable.
- [ ] Custom hooks or workflows that automate repetitive patterns
- [ ] Quality gates that catch issues before they become problems
- [ ] Project-level CLAUDE.md files for your key projects
- [ ] Reusable skills or templates for common tasks
- [ ] You teach others your AI-native patterns

### World Class — Personal AI OS
Your AI setup is a living system that learns, adapts, and evolves.
- [ ] System measures its own effectiveness and improves
- [ ] Knowledge persists and transfers across contexts intelligently
- [ ] You've contributed patterns back to the community
- [ ] Others adopt and adapt your approach
- [ ] You're pushing the boundaries of what's possible

## Core Principles

1. **Grow through pain, not theory** — Add rules when things go wrong, not preemptively
2. **Rule of 3** — Fix the prompt, fix the context, only then do it manually
3. **Wait for twice** — Only add rules for patterns, not one-off incidents
4. **Every line earns its place** — Rules cost context; delete what doesn't help
5. **Opinionated defaults** — Have a default for everything; override when needed
```

---

## Tips for Claude Running This Wizard

- **Match energy.** If the user gives one-word answers, keep questions tight. If they
  elaborate, explore deeper.
- **Offer defaults.** If someone says "I don't know" or "whatever works," give them a
  sensible default and move on. Don't stall.
- **Skip irrelevant tiers.** If a PM has no use for "verification commands" in the
  engineering sense, adapt — make it a review checklist instead.
- **Be concrete.** Don't ask "what's your testing philosophy?" to a PM. Ask "before
  you share a PRD, what do you check?"
- **Save progress.** After each tier, offer to write what you have so far. The user
  might need to leave.
- **Non-technical users are first-class.** A designer's CLAUDE.md is just as valuable
  as an engineer's. Adapt every concept — "testing" becomes "review," "debugging"
  becomes "investigating," "deployment" becomes "shipping/publishing."
