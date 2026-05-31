# cursor-prime

Cursor-native configuration: Karpathy-derived coding rules, a strict Plan Gate, Cursor slash commands, and a global `.gitignore`. Adapted from [kiro-prime](https://github.com/xnoahwang/kiro-prime) for Cursor's rules/commands ecosystem.

## Why use this?

- **Save credits.** The agent plans before it codes, so you catch wrong directions *before* tokens are spent on wrong implementations.
- **Honest reporting, not blind trust.** Every non-trivial task ends with a Delta Report (files changed, anything outside plan, verify output) so you can spot drift without reading every diff.
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
- **Surgical Changes** — don't touch adjacent code, comments, or formatting; every changed line traces to the request.
- **Simplicity** — build only what was asked; no speculative abstractions.

**Honest reporting (what the AI is told to produce):**
- **Pre-flight File List** — every file the plan will touch is named; touching anything else mid-task forces a stop.
- **Verify Receipt** — exact command and exact output, not "tested and works".
- **Edge Case Checklist** — empty / malformed / large input behavior for every public function or CLI.
- **Delta Report** — at the end of every non-trivial task.

**Cursor extras:**
- **`/plan`** — force the Plan Gate on the current request.
- **`/delta`** — produce a Delta Report for work just done.
- **`/prime-init`** — scaffold the rules into the current project.
- **Global gitignore** — `__pycache__`, `node_modules`, `.venv`, IDE/OS noise, Cursor caches.

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
| `.cursor\rules\project.mdc` | Project context (tech stack / commands), pulled in when relevant |
| `progress.md` | Working log updated after milestones |
| `.gitignore` | Project-specific ignores (secrets, runtime data, Cursor caches) |

Existing files are never overwritten without `-Force` (which backs them up to `.bak.<timestamp>` first).

Or, from inside a Cursor chat, just run the `/prime-init` command.

## Verify

Open a new Cursor chat in an initialized project and ask for a non-trivial task, e.g.:

> Write a Python CLI that downloads a URL and prints all `<a>` links grouped by domain.

The agent should respond with a `<plan>` block and stop, waiting for `GO`. If it writes code immediately, check `.cursor/rules/behavior.mdc` exists and has `alwaysApply: true` in its frontmatter.

## What it changes on your machine

`install.ps1` touches only:

| Path | Source |
|------|--------|
| `~/.cursor/commands/*.md` | `home/.cursor/commands/*.md` |
| `~/.cursor/rules/behavior.mdc` | `templates/behavior.mdc` (best-effort) |
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
