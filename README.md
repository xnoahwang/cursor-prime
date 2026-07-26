# cursor-prime

A **global Cursor settings package**: Karpathy-derived coding rules, a strict Plan Gate, slash commands, and a global `.gitignore`. Install once on a machine; paste User Rules once; every project inherits them.

## Why use this?

- **Save credits.** The agent plans before it codes, so you catch wrong directions *before* tokens are spent on wrong implementations.
- **Honest reporting, not blind trust.** Every non-trivial task ends with a Delta Report (files changed, anything outside plan, verify output) so you can spot drift without reading every diff.
- **Handoff-ready by default.** User Rules include maintainability standards so new code is documented for the next human and the next AI — tiered so one-line fixes stay cheap.
- **Light loop discipline.** After `GO`, fix-and-retry with a hard verifier (test/lint/build), iteration cap, and `/loop` — session-only, not overnight automation.
- **Karpathy discipline, automated.** Surgical changes, simplicity first, verifiable goals, terse output. No "Great! Let me also refactor this for you" sprawl.
- **One machine setup.** Clone → `install.ps1` → paste into Settings → User Rules. No per-project init.
- **Submission-ready.** Optional `submission/` trio (Handover / Reflection / Appendix) for interviews and milestones. For timed pads, keep a local `coderpad/meta-instruction.md` (gitignored) and copy it into an empty project as the only starter file so the agent can guide step-by-step in Chinese.
- **Zero lock-in.** One uninstall command and your machine is back to how it was (clear User Rules paste manually if you want a full reset).

## Repository layout (settings package)

```
cursor-prime/
├── install.ps1 / uninstall.ps1
├── payload/                         # ONLY originals
│   ├── behavior.mdc / maintainability.mdc
│   ├── gitignore_global
│   ├── commands/                    # global slash commands
│   ├── hooks/                       # optional -WithHooks
│   └── submission/                  # Handover, Reflection, Appendix
├── README.md / AGENTS.md / LICENSE
```

**Deploy:** `git clone` → `install.ps1` → paste User Rules once. Done for all projects on that machine.

## Why a User Rules paste is required

Cursor has **no reliable global rules file** — that's a [known limitation](https://forum.cursor.com/t/how-do-i-configure-a-global-rules-file-that-gets-picked-up-by-agent-mode/157335/3). So cursor-prime uses:

| Mechanism | Scope | Set by | Reliability |
|---|---|---|---|
| User Rules (Settings → Rules) | global | manual paste | ✅ reliable (no file API) |
| Global slash commands `~/.cursor/commands/*.md` | global | `install.ps1` | ✅ reliable |
| `~/.cursor/rules/behavior.mdc` | global | `install.ps1` (best-effort) | ⚠️ version-dependent |
| `~/.gitignore_global` | global | `install.ps1` | ✅ reliable |

**Recommended setup:** `git clone` → run `install.ps1` once → paste into **Settings → Rules → User Rules** (clipboard + `~/.cursor-prime-user-rules.txt`). That paste is **Coding Behavior + Maintainability**. Optional: `/submission-init` or auto-bootstrap for `submission/` docs.

## What it does

After setup you get:

**Discipline (what the AI is told not to do):**
- **Plan Gate** — the agent outputs a `<plan>` and waits for your `GO` before writing code on non-trivial tasks.
- **Design check (optional)** — for fuzzy / greenfield / large work, refine design in short chunks before the implementation plan.
- **Task class** — trivial tasks skip ceremony; workflow-scale tasks need a bite-sized task breakdown with per-step verify.
- **Explore cheap** — search-first, read-minimal; the pre-flight file list bounds reads and writes.
- **Surgical Changes** — don't touch adjacent code, comments, or formatting; every changed line traces to the request.
- **Simplicity** — build only what was asked; no speculative abstractions.
- **Systematic debugging** — reproduce → hypothesize → evidence → fix (also `/debug`).

**Honest reporting (what the AI is told to produce):**
- **Pre-flight File List** — every file the plan will touch is named; touching anything else mid-task forces a stop.
- **Verify Receipt** — exact command and exact output, not "tested and works".
- **Hard verifier** — run plan verify commands before declaring done; no self-grade when test/lint/build exists.
- **Loop discipline (light loop)** — after `GO`, iterate fix → verify until PASS or max iterations (default 8); credit guard; loop-worthiness check on workflow-scale tasks.
- **Edge Case Checklist** — empty / malformed / large input behavior for every public function or CLI.
- **Delta Report** — at the end of every non-trivial task.
- **Session handoff** — `progress.md` Handoff and Loop State when pausing mid-task or mid-loop.

**Cursor extras:**
- **`/plan`** — force the Plan Gate on the current request.
- **`/verify`** — on-demand audit against the plan and pre-flight list.
- **`/loop`** — after `GO`, fix-and-retry until verify passes or iteration cap.
- **`/debug`** — systematic debugging: reproduce → hypothesize → evidence → fix.
- **`/handoff`** — raise the bar to tier D: public API docs, module headers, truthful `AGENTS.md` / `README` / `@project`.
- **`/delta`** — produce a Delta Report for work just done.
- **`/submission-init`** — scaffold `submission/` Handover / Reflection / Appendix trio.
- **Optional hooks** — `-WithHooks` on install asks before destructive shell commands (off by default).
- **Global gitignore** — `__pycache__`, `node_modules`, `.venv`, IDE/OS noise, Cursor caches.

## Changelog

### v0.3.1
- **Light absorb from [superpowers](https://github.com/obra/superpowers)-style process** (ideas only — not a fork): optional design check, workflow-scale task breakdown + step self-check, systematic debugging, `/debug`.
- Still **not** absorbed: mandatory TDD-always, default multi-hour subagent runs, per-task git worktrees.
- **Re-install + re-paste User Rules** required after upgrade (`install.ps1 -Force`).

### v0.3.0
- **Major: global Cursor settings package** — single `payload/` originals tree; removed `init.ps1`, `/prime-init`, `home/`, and `templates/` stubs.
- Deploy story only: clone → `install.ps1` → paste User Rules (all projects on the machine).
- **Submission + Maintainability** cover interview write-ups; no separate CoderPad guide or in-pad rule pack.
- Standalone product narrative (no kiro-prime attribution).

### v0.2.5
- **User Rules merge** — Coding Behavior + Maintainability in one paste.
- **Submission auto-bootstrap** + `/submission-init`.

### v0.2.4
- **Submission trio** for assessments; removed in-pad rule pack.

### v0.2.3
- **Maintainability** + `/handoff`; greenfield pattern grounding.

### v0.2.2
- **Light loop** + `/loop` + hard verifier.

### v0.2.1
- **Stricter task class** — any file edit is non-trivial.

### v0.2.0
- Discipline loop, `/verify`, enhanced `/plan`, optional hooks.

## Requirements

- Windows 10 / 11
- PowerShell 5.1+ (built-in)
- Git
- Cursor installed

## Install

### Option 1 — Ask your AI agent (recommended)

Clone the repo, open it in Cursor (or any AI IDE/agent), and paste this prompt:

```
Read AGENTS.md in this repo and install cursor-prime by following its
"Install cursor-prime (agent procedure)" section. Do everything automatically,
verify it, then tell me the single manual step I need to do.
```

### Option 2 — Manual (PowerShell)

```powershell
git clone https://github.com/xnoahwang/cursor-prime.git $env:USERPROFILE\cursor-prime
cd $env:USERPROFILE\cursor-prime
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

This installs global slash commands, the global gitignore, and a best-effort `~/.cursor/rules/behavior.mdc`. It **copies User Rules text to your clipboard** (backup: `~/.cursor-prime-user-rules.txt`).

Reinstall: `.\install.ps1 -Force`  
Optional hooks: `.\install.ps1 -Force -WithHooks`

> **The single manual step:** paste into Settings → Rules → User Rules. Cursor has no file/API for User Rules. ~10 seconds, once per machine.

## Testing

After install + User Rules paste, start a **new chat**.

### Plan Gate (non-trivial task)

Ask for something that clearly needs code. **Pass:** `<plan>` then wait for `GO`. Reply `GO` → implement + Delta Report.

### Trivial task

Ask a read-only question. **Pass:** direct answer, no wait for `GO`.

### Troubleshooting

| Symptom | Likely cause |
|---|---|
| Code before `GO` on non-trivial tasks | User Rules not pasted, or old chat — open a new one |
| Rules seem ignored | Re-paste from `~/.cursor-prime-user-rules.txt`; new chat |

## What it changes on your machine

| Path | Source |
|------|--------|
| `~/.cursor/commands/*.md` | `payload/commands/*.md` |
| `~/.cursor/rules/behavior.mdc` | `payload/behavior.mdc` (best-effort) |
| `~/.cursor/hooks.json` + hooks script | `payload/hooks/*` (only with `-WithHooks`) |
| `~/.gitignore_global` | `payload/gitignore_global` |
| `~/.cursor-prime-user-rules.txt` | generated from `payload/behavior.mdc` + `maintainability.mdc` |
| `git config --global core.excludesfile` | set to `~/.gitignore_global` |

Manifest: `~/.cursor-prime-manifest.json`.

## Customize

Edit files under `payload/`, then `.\install.ps1 -Force` and re-paste User Rules.

## Update

```powershell
cd $env:USERPROFILE\cursor-prime
git pull
.\install.ps1 -Force
```

Re-paste User Rules so they match **v0.3.1**.

## Uninstall

```powershell
cd $env:USERPROFILE\cursor-prime
.\uninstall.ps1
```

Removes manifest-listed files and restores `core.excludesfile`. Clear User Rules in Settings manually if desired. `-RestoreBackups` restores install-time backups.

## Safety

- `install.ps1` backs up existing files as `<file>.bak.<timestamp>`.
- `uninstall.ps1` touches only files listed in the manifest.
- Scripts are short. Read them before running.

## Adapt for other tools / OSes

See [AGENTS.md](AGENTS.md).

## License

MIT — see [LICENSE](LICENSE).
