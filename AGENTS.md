# AGENTS.md

This file is for AI coding agents reading this repo to **install cursor-prime** (most common) or to adapt it to a different IDE/tool or OS.

## Install cursor-prime (agent procedure)

When the user says something like *"read AGENTS.md and install cursor-prime"*, do ALL of the steps below autonomously. This is a trivial, well-scoped install task — do not ask for a plan; just execute, verify, and finish by surfacing the ONE manual step.

1. **Confirm location.** Make sure the current directory is the cloned `cursor-prime` repo root (it contains `install.ps1`, `templates/`, and `home/`). If not, `cd` into it.

2. **Run the installer for the host OS.**
   - **Windows:** run with the execution policy bypassed (cloned scripts are unsigned):
     ```
     powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
     ```
     Add `-Force` if a previous install exists. Add `-WithHooks` for an optional destructive-shell guard (off by default).
   - **macOS / Linux:** there is no `.sh` shipped yet. Port `install.ps1` → `install.sh` per the "OS adaptation" section below, run it, then keep the `.ps1` files in place.

3. **Know what the installer did automatically (no user action needed):**
   - Installed global slash commands `/plan`, `/delta`, `/verify`, `/prime-init` into `~/.cursor/commands/`.
   - Wrote `~/.gitignore_global` and set `git config --global core.excludesfile`.
   - Wrote a best-effort `~/.cursor/rules/behavior.mdc` (global; loading is version-dependent — do NOT rely on it).
   - Wrote a paste-ready `~/.cursor-prime-user-rules.txt` and copied the rule text to the clipboard.
   - Wrote the manifest `~/.cursor-prime-manifest.json` (version 2.0.1).
   - Optional: with `-WithHooks`, installed `~/.cursor/hooks.json` and guard script.

4. **Verify.** Confirm `~/.cursor/commands/plan.md` (and `delta.md`, `verify.md`, `prime-init.md`) and `~/.cursor-prime-manifest.json` exist. Report PASS/FAIL with the real paths checked.

5. **Surface the ONE manual step — this is mandatory and you CANNOT do it for the user** (Cursor has no file/API write for User Rules). End your response with this as the single, highlighted action item:
   > **One manual step left.** The rules text is already on your clipboard (backup at `~/.cursor-prime-user-rules.txt`). Open **Cursor → Settings → Rules → User Rules**, click the box, press **Ctrl+V** (Cmd+V on macOS), and **Save**. Do this once and the Plan Gate applies automatically to every project, including new ones.

   If the clipboard may have been cleared (e.g. you ran the installer in a non-interactive shell), read `~/.cursor-prime-user-rules.txt` and show its contents so the user can copy it directly.

6. **(Optional) Mention per-project scaffolding.** Tell the user that to also drop project-level files (`project.mdc`, `progress.md`, project `.gitignore`) into the CURRENT project, they can run the `/prime-init` command or `init.ps1`. This is optional — once User Rules is pasted, the discipline already applies everywhere.

**Do NOT** claim the install alone makes the Plan Gate globally automatic. The User Rules paste in step 5 is required for that; without it, only the slash commands and gitignore are active.

## What this repo is

A configuration installer for **Cursor**, adapted from kiro-prime. It delivers the same tool-agnostic discipline rules (Plan Gate, Surgical Changes, Pre-flight File List, Verify Receipt, Edge Case Checklist, Self-Review Delta Report) through Cursor's native mechanisms.

The rules themselves are tool-agnostic and live in `templates/behavior.mdc` (canonical). The only Cursor-specific wording is the Persistence section referencing `.cursor/rules/project.mdc`.

## Why Cursor's delivery differs from Kiro's

Kiro installs one global file (`~/.kiro/steering/behavior.md`) and every project picks it up. Cursor has **no reliable global rules file** (`~/.cursor/rules/` is a known, version-dependent bug). Cursor's reliable, file-based, native mechanisms are:

| Mechanism | Path | Scope | Notes |
|---|---|---|---|
| Project rules | `.cursor/rules/*.mdc` | per project | `.mdc` + frontmatter (`description`, `globs`, `alwaysApply`). Primary. |
| Global commands | `~/.cursor/commands/*.md` | global | filename = `/command`. Reliable. |
| AGENTS.md | `AGENTS.md` (nestable) | per dir | plain markdown, always applied. |
| User Rules | Cursor Settings → Rules | global | plain text, stored in Cursor (cloud/`state.vscdb`); **no file API**. |

So: per-project rules via `init.ps1` is the main path; global commands via `install.ps1`; User Rules must be pasted manually.

## MDC format

Project rules must be `.mdc` with frontmatter. `alwaysApply: true` = injected into every chat (globs/description ignored). `alwaysApply: false` + `description` = agent pulls it in when relevant. A plain `.md` in `.cursor/rules` is ignored (use `AGENTS.md` for plain markdown).

## What you should do (retarget to another tool)

1. Detect host OS. The installers are Windows/PowerShell. For macOS/Linux, port to `install.sh` / `init.sh` / `uninstall.sh` (see below). Keep the `.ps1` files.
2. Identify the target tool's user-level prompt path:

   | Tool        | Path                                               |
   |-------------|----------------------------------------------------|
   | Kiro        | `~/.kiro/steering/behavior.md`                     |
   | Cursor      | per-project `.cursor/rules/behavior.mdc` (+ commands `~/.cursor/commands/`) |
   | Claude Code | `~/.claude/CLAUDE.md`                              |
   | Continue    | `systemMessage` in `~/.continue/config.json`       |
   | Aider       | `~/.aider.conf.yml` `read:` entry                  |
   | Codex CLI   | `~/.codex/AGENTS.md`                               |

   If the target isn't listed, ask once for the correct path. Don't guess.
3. Update the `$Files` array(s) so destinations match the target's path. The rule **content** does not need to change (except tool-specific path references in Persistence).
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
- `chmod +x install.sh init.sh uninstall.sh`

Manifest stays `~/.cursor-prime-manifest.json` with the same shape. `git config --global core.excludesfile` is identical on every OS. Run the script on the host to verify end-to-end — don't declare done from theory.

## Verify

- Run `install.ps1`; confirm `~/.cursor/commands/*.md` exist and the manifest is written.
- In a scratch project, run `init.ps1`; confirm `.cursor/rules/behavior.mdc` (with `alwaysApply: true`), `.cursor/rules/project.mdc`, `progress.md`, `.gitignore` exist.
- Open a Cursor chat in that project, ask for a non-trivial task, confirm the agent outputs a `<plan>` and waits for `GO`.
- Ask to edit README (or another doc); confirm Plan Gate triggers before any file edit (v2.0.1 task class).

## What you should NOT do

- Do **not** change the discipline rules' substance. They're deliberately tool-agnostic.
- Do **not** remove the manifest mechanism — it keeps the install cleanly uninstallable.
- Do **not** add network calls, telemetry, or analytics.
- Do **not** change licensing or remove attribution to kiro-prime.

## Repo structure

```
templates/behavior.mdc          # canonical rules (alwaysApply) — used by init AND global install
templates/project.mdc           # project-context rule (agent-requested)
templates/progress.md           # progress log starter
templates/gitignore             # project .gitignore starter
home/.cursor/commands/*.md      # global slash commands (/plan, /delta, /verify, /prime-init)
home/.cursor/hooks/*            # optional user hooks (-WithHooks)
templates/hooks/*               # optional project hooks (init.ps1 -WithHooks)
home/.gitignore_global          # global gitignore
.cursor/rules/behavior.mdc      # this repo dogfoods its own rules
install.ps1                     # global install (commands, gitignore, best-effort rule)
init.ps1                        # per-project scaffold (primary mechanism)
uninstall.ps1                   # manifest-based undo
README.md / AGENTS.md / LICENSE
```

## Out of scope

- Auto-writing Cursor User Rules (no file API; pasted manually).
- Web UI, telemetry, remote config.
