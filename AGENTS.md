---
description: 
alwaysApply: true
---

# AGENTS.md

This file is for AI coding agents reading this repo to **install cursor-prime** (most common) or to adapt it to a different IDE/tool or OS.

## Install cursor-prime (agent procedure)

When the user says something like *"read AGENTS.md and install cursor-prime"*, do ALL of the steps below autonomously. This is a trivial, well-scoped install task — do not ask for a plan; just execute, verify, and finish by surfacing the ONE manual step.

1. **Confirm location.** Make sure the current directory is the cloned `cursor-prime` repo root (it contains `install.ps1` and `payload/`). If not, `cd` into it.

2. **Run the installer for the host OS.**
   - **Windows:** run with the execution policy bypassed (cloned scripts are unsigned):
     ```
     powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
     ```
     Add `-Force` if a previous install exists. Add `-WithHooks` for an optional destructive-shell guard (off by default).
   - **macOS / Linux:** there is no `.sh` shipped yet. Port `install.ps1` → `install.sh` per the "OS adaptation" section below, run it, then keep the `.ps1` files in place.

3. **Know what the installer did automatically (no user action needed):**
   - Installed global slash commands `/plan`, `/delta`, `/verify`, `/loop`, `/handoff`, `/submission-init` into `~/.cursor/commands/`.
   - Wrote `~/.gitignore_global` and set `git config --global core.excludesfile`.
   - Wrote a best-effort `~/.cursor/rules/behavior.mdc` (global; loading is version-dependent — do NOT rely on it).
   - Wrote a paste-ready `~/.cursor-prime-user-rules.txt` (**Coding Behavior + Maintainability**, v0.2.6+) and copied the rule text to the clipboard.
   - Wrote the manifest `~/.cursor-prime-manifest.json` (version 0.2.6).
   - Optional: with `-WithHooks`, installed `~/.cursor/hooks.json` and guard script.
   - Removed obsolete `~/.cursor/commands/prime-init.md` if present (per-project init retired).

4. **Verify.** Confirm `~/.cursor/commands/plan.md`, `delta.md`, `verify.md`, `loop.md`, `handoff.md`, `submission-init.md`, and `~/.cursor-prime-manifest.json` exist. Report PASS/FAIL with the real paths checked. Confirm `prime-init.md` is absent.

5. **Surface the ONE manual step — this is mandatory and you CANNOT do it for the user** (Cursor has no file/API write for User Rules). End your response with this as the single, highlighted action item:
   > **One manual step left.** The rules text is already on your clipboard (backup at `~/.cursor-prime-user-rules.txt`). Open **Cursor → Settings → Rules → User Rules**, click the box, press **Ctrl+V** (Cmd+V on macOS), and **Save**. Do this once and Plan Gate **plus Maintainability** apply automatically to every project, including new ones.

   If the clipboard may have been cleared (e.g. you ran the installer in a non-interactive shell), read `~/.cursor-prime-user-rules.txt` and show its contents so the user can copy it directly.

6. **(Optional) Mention submission.** Non-trivial tasks may auto-bootstrap `submission/` from `payload/submission/`. `/submission-init` forces scaffold. User may opt out in the prompt.

**Do NOT** claim the install alone makes the rules globally automatic. The User Rules paste in step 5 is required for that; without it, only the slash commands and gitignore are active.

**Do NOT** run or recommend `init.ps1` / `/prime-init` — they were removed. This package is global-only.

## What this repo is

A **global Cursor settings package**. One install on a machine: slash commands, global gitignore, and paste-ready User Rules (Plan Gate + Karpathy discipline + handoff-ready maintainability). New projects inherit the rules after the User Rules paste — no per-project scaffold.

Canonical originals live only under `payload/`.

## Why a User Rules paste is required

Cursor has **no reliable global rules file** (`~/.cursor/rules/` is a known, version-dependent bug). This package therefore uses:

| Mechanism | Path | Scope | Notes |
|---|---|---|---|
| User Rules | Cursor Settings → Rules | global | plain text; **no file API** — paste once |
| Global commands | `~/.cursor/commands/*.md` | global | filename = `/command`. Reliable. |
| Best-effort rule file | `~/.cursor/rules/behavior.mdc` | global | version-dependent — do not rely on it |
| Global gitignore | `~/.gitignore_global` | global | via `core.excludesfile` |

## What you should do (retarget to another tool)

1. Detect host OS. The installers are Windows/PowerShell. For macOS/Linux, port to `install.sh` / `uninstall.sh` (see below). Keep the `.ps1` files.
2. Identify the target tool's user-level prompt path:

   | Tool        | Path                                               |
   |-------------|----------------------------------------------------|
   | Kiro        | `~/.kiro/steering/behavior.md`                     |
   | Cursor      | User Rules paste + `~/.cursor/commands/`           |
   | Claude Code | `~/.claude/CLAUDE.md`                              |
   | Continue    | `systemMessage` in `~/.continue/config.json`       |
   | Aider       | `~/.aider.conf.yml` `read:` entry                  |
   | Codex CLI   | `~/.codex/AGENTS.md`                               |

   If the target isn't listed, ask once for the correct path. Don't guess.
3. Update install paths so destinations match the target. Rule **content** stays in `payload/`.
4. For JSON/YAML targets (Continue, Aider), `install.ps1` must read-merge-write the field instead of copying a file. **Ask the user first** — it risks corrupting their config.
5. Rename the project display name and URLs in `README.md`; keep LICENSE and the Karpathy rules intact.
6. Verify (see below), then show a Delta Report of every file you changed.

## OS adaptation (macOS / Linux)

Port the installers to bash:
- shebang `#!/usr/bin/env bash`
- `$env:USERPROFILE` → `$HOME`
- `Copy-Item src dst -Force` → `cp -f src dst`
- `New-Item -ItemType Directory -Force` → `mkdir -p`
- `Get-Date -Format 'yyyyMMdd-HHmmss'` → `date +%Y%m%d-%H%M%S`
- `Set-Content -Encoding UTF8` → `cat > file`
- `ConvertTo-Json -Depth 6` → `jq` or `python3 -c`
- `chmod +x install.sh uninstall.sh`

Manifest stays `~/.cursor-prime-manifest.json` with the same shape. `git config --global core.excludesfile` is identical on every OS. Run the script on the host to verify end-to-end — don't declare done from theory.

## Verify

- Run `install.ps1`; confirm `~/.cursor/commands/*.md` (including `submission-init.md`, **not** `prime-init.md`) exist and the manifest is version **0.2.6**.
- Confirm this repo has a single originals tree: `payload/` (no `home/`, no `templates/`, no `init.ps1`).
- Open a Cursor chat after User Rules paste; ask for a non-trivial task; confirm `<plan>` and wait for `GO`.
- Confirm `/loop` and `/handoff` appear; non-trivial tasks may auto-bootstrap `submission/` unless opted out.

## What you should NOT do

- Do **not** change the discipline rules' substance. They're deliberately tool-agnostic.
- Do **not** remove the manifest mechanism — it keeps the install cleanly uninstallable.
- Do **not** add network calls, telemetry, or analytics.
- Do **not** change licensing without an explicit request.
- Do **not** reintroduce per-project `init.ps1` unless the product model changes.

## Repo structure

```
payload/                    # ONLY originals (rules, commands, hooks, submission)
install.ps1 / uninstall.ps1
README.md / AGENTS.md / LICENSE
```

## Out of scope

- Auto-writing Cursor User Rules (no file API; pasted manually).
- Per-project rule scaffolding (`init` retired).
- Web UI, telemetry, remote config.
