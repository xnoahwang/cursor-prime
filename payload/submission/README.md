# Submission templates

Copy this folder into a project as **`submission/`**, then fill the three files in order. Filenames keep the `1.` / `2.` / `3.` prefix so readers see order in the tree.

| # | File | Role |
|---|------|------|
| 1 | `1. Handover.md` | Newcomer map — run, architecture, where to edit, verify |
| 2 | `2. Reflection.md` | Judgment — thought process, hard/easy, tradeoffs |
| 3 | `3. Appendix.md` | Process — workflow notes, sync checklist, tooling highlights |

Auto-created on non-trivial tasks (unless opted out) or via `/submission-init`.

## Copy steps

```powershell
# from project root
New-Item -ItemType Directory -Force submission | Out-Null
Copy-Item "$env:USERPROFILE\cursor-prime\payload\submission\1. Handover.md" "submission\"
Copy-Item "$env:USERPROFILE\cursor-prime\payload\submission\2. Reflection.md" "submission\"
Copy-Item "$env:USERPROFILE\cursor-prime\payload\submission\3. Appendix.md" "submission\"
```

Adjust the cursor-prime path if your clone lives elsewhere (e.g. `C:\XW\cursor-prime`).

## Language

- Chat with you: Chinese OK  
- `submission/*.md`, code, comments: **English**  
- Section headings: **Title Case**

## Grow as you work

All three files grow during the task. Keep the Appendix sync checklist current with every pre-flight / Delta file list.
