# Submission templates

Copy this folder into a project as **`submission/`**, then fill the three files in order. Filenames keep the `1.` / `2.` / `3.` prefix so readers see reading order in the tree.

| # | File | Role |
|---|------|------|
| 1 | `1. Handover.md` | Newcomer map — run, architecture, where to edit, verify (**final** design) |
| 2 | `2. Reflection.md` | Judgment — thought process, hard/easy, **abandoned approaches** |
| 3 | `3. Appendix.md` | Process — workflow notes, **final** paste-back file list |

**Timed assessment:** keep `meta-instruction.md` under your local gitignored `coderpad/` folder (not shipped in git). New empty project → copy that file to the project root as the **only** starter file → ask the agent to read it and guide in Chinese, one step at a time.

Auto-created on non-trivial tasks (unless opted out) or via `/submission-init`.

## Copy steps

```powershell
# from assessment project root (empty except you will add meta first)
Copy-Item "C:\XW\cursor-prime\coderpad\meta-instruction.md" ".\"
New-Item -ItemType Directory -Force submission | Out-Null
Copy-Item "$env:USERPROFILE\cursor-prime\payload\submission\1. Handover.md" "submission\"
Copy-Item "$env:USERPROFILE\cursor-prime\payload\submission\2. Reflection.md" "submission\"
Copy-Item "$env:USERPROFILE\cursor-prime\payload\submission\3. Appendix.md" "submission\"
```

Adjust paths if your clone lives elsewhere. You can copy `submission/` later when the agent scaffolds it.

## Language

- Chat with you: **Chinese**  
- `submission/*.md`, code, comments: **English**  
- Section headings: **Title Case**

## Grow as you work

All three files grow during the task. Log rejected approaches in Reflection as soon as you switch. Security: deliver if the prompt requires it; otherwise note “considered” in Reflection §8.1. Performance: think always; ship small proven opts; defer big speculative work to Reflection §8.2. Keep the Appendix sync checklist as the **final** paste-back list (exclude `meta-instruction.md`).
