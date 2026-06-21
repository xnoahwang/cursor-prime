# cursor-prime

Cursor-native configuration: Karpathy-derived coding rules, a strict Plan Gate, Cursor slash commands, and a global `.gitignore`. Adapted from [kiro-prime](https://github.com/xnoahwang/kiro-prime) for Cursor's rules/commands ecosystem.

## Why use this?

- **Save credits.** The agent plans before it codes, so you catch wrong directions *before* tokens are spent on wrong implementations.
- **Honest reporting, not blind trust.** Every non-trivial task ends with a Delta Report (files changed, anything outside plan, verify output) so you can spot drift without reading every diff.
- **Light loop discipline.** After `GO`, fix-and-retry with a hard verifier (test/lint/build), iteration cap, and `/loop` — session-only, not overnight automation.
- **Karpathy discipline, automated.** Surgical changes, simplicity first, verifiable goals, terse output. No "Great! Let me also refactor this for you" sprawl.
- **Cursor-native.** Uses `.cursor/rules/*.mdc` (always-applied), Cursor global slash commands, and `AGENTS.md`-compatible markdown — not a foreign format bolted on.
- **Zero lock-in.** One uninstall command and your machine is back to how it was.

## How Cursor differs from Kiro (important)

Kiro installs **one global file** and every project benefits. Cursor has **no reliable global rules file** — that's a [known limitation](https://forum.cursor.com/t/how-do-i-configure-a-global-rules-file-that-gets-picked-up-by-agent-mode/157335/3). So cursor-prime uses the mechanisms Cursor *does* support reliably:

| Mechanism | Scope | Set by | Reliability |
|---|---|---|---|
| `.cursor/rules/behavior.mdc` (`alwaysApply: true`) | per project | `init.ps1` | ✅ primary |
| Global slash commands `~/.cursor/commands/*.md` | global | `install.ps1` | ✅ reliable |
| User Rules (Settings → Rules) | global | manual paste | ✅ reliable (no file API) |
| `~/.cursor/rules/behavior.mdc` | global | `install.ps1` (best-effort) | ⚠️ version-dependent |

**Recommended setup:** run `install.ps1` once, then do its single manual step — paste the rules into **Settings → Rules → User Rules** (the installer copies them to your clipboard and saves a backup at `~/.cursor-prime-user-rules.txt`). That one paste makes the Plan Gate automatic in every project, including new ones. `init.ps1` / `/prime-init` is optional — only for project-level files (`project.mdc`, `progress.md`).

## What it does

After setup you get:

**Discipline (what the AI is told not to do):**
- **Plan Gate** — the agent outputs a `<plan>` and waits for your `GO` before writing code on non-trivial tasks.
- **Task class** — trivial tasks skip ceremony; workflow-scale tasks must be phased in the plan.
- **Explore cheap** — search-first, read-minimal; the pre-flight file list bounds reads and writes.
- **Surgical Changes** — don't touch adjacent code, comments, or formatting; every changed line traces to the request.
- **Simplicity** — build only what was asked; no speculative abstractions.

**Honest reporting (what the AI is told to produce):**
- **Pre-flight File List** — every file the plan will touch is named; touching anything else mid-task forces a stop.
- **Verify Receipt** — exact command and exact output, not "tested and works".
- **Hard verifier** — run plan verify commands before declaring done; no self-grade when test/lint/build exists.
- **Loop discipline (light loop)** — after `GO`, iterate fix → verify until PASS or max iterations (default 8); credit guard; loop-worthiness check on workflow-scale tasks.
- **Edge Case Checklist** — empty / malformed / large input behavior for every public function or CLI.
- **Delta Report** — at the end of every non-trivial task.
- **Session handoff** — `progress.md` Handoff and Loop State when pausing mid-task or mid-loop.

**Cursor extras:**
- **`/plan`** — force the Plan Gate on the current request (includes out-of-scope, done-when, max iterations, loop worthiness, pattern grounding).
- **`/verify`** — on-demand audit against the plan and pre-flight list (includes hard-verifier check; no always-on token cost).
- **`/loop`** — after `GO`, fix-and-retry until verify passes or iteration cap (requires hard gate in the plan).
- **`/delta`** — produce a Delta Report for work just done.
- **`/prime-init`** — scaffold the rules into the current project.
- **Optional hooks** — `-WithHooks` on install/init asks before destructive shell commands (off by default).
- **Global gitignore** — `__pycache__`, `node_modules`, `.venv`, IDE/OS noise, Cursor caches.

## Changelog

### v0.2.2
- **Loop discipline (light loop)** — session-only fix-and-retry after `GO`: iterate until verify PASS or max iterations (default 8); credit guard; loop-worthiness four-check on workflow-scale tasks.
- **Hard verifier** — non-trivial tasks must *run* verify commands (test/lint/build/typecheck) before done; transcript required; no self-grade as sole proof.
- **`/loop`** — global slash command for EXECUTE → VERIFY → ITERATE until `LOOP DONE` or `LOOP CAP`.
- **Enhanced `/plan`** — Max iterations, loop worthiness (workflow-scale), verify as hard gate.
- **Enhanced `/verify`** — Hard verifier audit line; suggests `/loop` when gate fails under cap.
- **`progress.md`** — Loop State section for multi-iteration work.
- **`project.mdc`** — Verify Commands documented as hard gates for plans and `/loop`.

### v0.2.1
- **Stricter task class** — any file edit (including README, docs, markdown) is non-trivial; only read-only Q&A or a single-line typo in one known location skips Plan Gate.
- Plan Gate now names Write / StrReplace / Delete explicitly; if the agent edits without a plan, it must stop and replan.

### v0.2.0
- **Discipline loop** — Task class, Explore cheap, Session continuity, Handoff in `progress.md`.
- **`/verify`** — on-demand audit against plan and pre-flight file list.
- **Enhanced `/plan`** — Out of scope, Done when, Scale, pattern grounding.
- **Optional hooks** — `install.ps1 -WithHooks` / `init.ps1 -WithHooks` for destructive-shell guard (off by default).
- **`project.mdc`** — verify commands and optional protected paths.

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

The agent runs the installer, verifies it, and ends by telling you the **one thing only you can do**: paste the rules into Cursor Settings → Rules → User Rules (the text is already on your clipboard). Everything else is automatic.

### Option 2 — Manual (PowerShell)

```powershell
git clone https://github.com/xnoahwang/cursor-prime.git $env:USERPROFILE\cursor-prime
cd $env:USERPROFILE\cursor-prime
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

This installs the global slash commands, the global gitignore (+ `git config core.excludesfile`), and a best-effort `~/.cursor/rules/behavior.mdc`. It then **copies the rule text to your clipboard** (and saves a backup at `~/.cursor-prime-user-rules.txt`) so the one un-scriptable step is just: open **Cursor Settings → Rules → User Rules**, click the box, `Ctrl+V`, save. Do it once and the Plan Gate applies to every project, including new ones.

Reinstall on top of an existing install: `.\install.ps1 -Force`

Optional destructive-command guard (user-level hooks): `.\install.ps1 -Force -WithHooks`

> **The single manual step (both options):** paste into Settings → Rules → User Rules. Cursor has no file/API to set User Rules, so no script can do it for you. It takes ~10 seconds, once per machine.

## Initialize a project (primary mechanism)

Run inside any project to make the Plan Gate apply there reliably:

```powershell
cd path\to\your\project
& "$env:USERPROFILE\cursor-prime\init.ps1"
```

Creates:

| File | Purpose |
|------|---------|
| `.cursor\rules\behavior.mdc` | Always-applied Plan Gate + Karpathy rules |
| `.cursor\rules\project.mdc` | Project context (tech stack / commands / verify / protected paths), pulled in when relevant |
| `progress.md` | Working log with Handoff and Loop State for session / loop resume |
| `.gitignore` | Project-specific ignores (secrets, runtime data, Cursor caches) |
| `.cursor\hooks\*` | Optional (`-WithHooks`): asks before destructive shell commands |

Existing files are never overwritten without `-Force` (which backs them up to `.bak.<timestamp>` first).

Project hooks: `& "$env:USERPROFILE\cursor-prime\init.ps1" -WithHooks`

Or, from inside a Cursor chat, just run the `/prime-init` command.

## Testing

Use these checks after install (and the User Rules paste) or after `init.ps1` in a project. Start a **new chat** so rules load cleanly.

### Plan Gate (non-trivial task)

Ask for something that clearly needs code, for example:

> Write a Python CLI that downloads a URL and prints all `<a>` links grouped by domain.

**Pass:** the agent replies with a `<plan>` block (pre-flight file list, Out of scope, Done when) and **stops** — no file edits, no implementation yet.

Reply with the literal word `GO`. **Pass:** the agent then implements and ends with a Delta Report.

**Fail:** the agent writes or edits files before you say `GO` → rules are not active in this chat (see troubleshooting below).

### Trivial task (should skip the gate)

Ask a read-only question, e.g. *What does the Plan Gate section in behavior.mdc require?*

**Pass:** a direct answer, no `<plan>` block and no wait for `GO`.

### Documentation edit (non-trivial — v0.2.1+)

Ask to change a doc file, for example:

> Add a short "Testing" section to README explaining how to verify Plan Gate.

**Pass:** `<plan>` with pre-flight file list (e.g. `README.md`), Out of scope, Done when — then **wait for `GO`** before editing.

**Fail:** the agent edits README or other docs immediately. Re-paste User Rules from `~/.cursor-prime-user-rules.txt` after `install.ps1 -Force`.

### Force the gate

Type `/plan` before a request (or run `/plan` alone) to treat the task as non-trivial even if the model might classify it as trivial.

### Audit after work

After you reply `GO` and the agent finishes, run `/verify` to check the diff against the plan and pre-flight list. Use `/delta` if you only need the end-of-task summary.

### Hard verifier

Fill **Verify Commands** in `.cursor/rules/project.mdc` (e.g. test, lint). After `GO`, the agent should run those commands and paste output in the Delta Report.

**Pass:** Delta Report includes a real command and transcript, not "tested and works".

**Fail:** claims done without running verify when a hard gate exists.

### Light loop (`/loop`)

Use after a plan with verify commands and `GO`. If verify fails, send `/loop` (or let the agent iterate per Loop Discipline).

**Pass:** `ITERATING (n/max)` → fixes one failure per pass → `LOOP DONE` when verify passes, or `LOOP CAP` at max iterations with a summary.

**Fail:** retries without running verify, or continues past the cap silently.

Quick smoke test (any project with `project.mdc` verify commands):

```
/plan
Goal: add one line to progress.md Completed: "loop test".
Verify: <your test or lint command from project.mdc>
Max iterations: 3
```

Reply `GO`. If verify fails, run `/loop`.

### Troubleshooting

| Symptom | Likely cause |
|---|---|
| Code before `GO` on non-trivial tasks | User Rules not pasted, or project missing `.cursor/rules/behavior.mdc` |
| Rules seem ignored | Old chat — open a new one; confirm frontmatter has `alwaysApply: true` |
| Gate works in one project only | You ran `init.ps1` there but skipped the global User Rules paste |

Confirm the file exists: `.cursor/rules/behavior.mdc` with `alwaysApply: true` in its YAML frontmatter.

## What it changes on your machine

`install.ps1` touches only:

| Path | Source |
|------|--------|
| `~/.cursor/commands/*.md` | `home/.cursor/commands/*.md` |
| `~/.cursor/rules/behavior.mdc` | `templates/behavior.mdc` (best-effort) |
| `~/.cursor/hooks.json` + `~/.cursor/hooks/*` | `home/.cursor/hooks/*` (only with `-WithHooks`) |
| `~/.gitignore_global` | `home/.gitignore_global` |
| `~/.cursor-prime-user-rules.txt` | generated from `templates/behavior.mdc` (paste-ready User Rules) |
| `git config --global core.excludesfile` | set to `~/.gitignore_global` |

A manifest at `~/.cursor-prime-manifest.json` records what was installed so uninstall is precise. `init.ps1` only writes inside the project folder you run it from.

## Customize

Edit `templates/behavior.mdc` (the canonical rule), then re-run `init.ps1 -Force` in your projects and/or `install.ps1 -Force` for the global copy. Add more global commands by dropping `.md` files into `home/.cursor/commands/` and re-running `install.ps1 -Force`.

## Update

```powershell
cd $env:USERPROFILE\cursor-prime
git pull
.\install.ps1 -Force
```

Re-paste User Rules from `~/.cursor-prime-user-rules.txt` (or the installer clipboard) so global rules match v0.2.2.

## Uninstall

```powershell
cd $env:USERPROFILE\cursor-prime
.\uninstall.ps1
```

Removes only the files in the manifest (global commands, global rule, global gitignore) and restores `core.excludesfile`. To also restore pre-install backups: `.\uninstall.ps1 -RestoreBackups`. Per-project files from `init.ps1` are yours — delete them manually.

## Safety

- `install.ps1` backs up existing files at install paths as `<file>.bak.<timestamp>`.
- `uninstall.ps1` touches only files listed in `~/.cursor-prime-manifest.json`.
- If you had `core.excludesfile` set before install, uninstall restores it; otherwise it unsets the key.
- `init.ps1` never overwrites without `-Force`.
- Scripts are short. Read them before running.

## Adapt for other tools / OSes

See [AGENTS.md](AGENTS.md) for the procedure an AI agent follows to retarget this to another tool or port the installer to macOS / Linux.

## License

MIT — see [LICENSE](LICENSE). Adapted from kiro-prime.
