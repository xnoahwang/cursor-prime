# Prime this project

Scaffold cursor-prime's discipline rules, handoff standards, and starter docs into the **current project** so every chat here follows the Plan Gate and maintainability tiers.

Run the init script from the project root (Windows / PowerShell):

```powershell
& "$env:USERPROFILE\cursor-prime\init.ps1"
```

If that path does not exist, ask the user where they cloned `cursor-prime`, then run its `init.ps1` from the current project directory.

After it runs, confirm these files exist and report what was created vs. skipped:
- `.cursor/rules/behavior.mdc`         (always-applied Plan Gate + Karpathy rules)
- `.cursor/rules/maintainability.mdc`  (always-applied handoff standards — docs, comments, layout)
- `.cursor/rules/project.mdc`          (project context — fill in tech stack, verify commands, protected paths)
- `AGENTS.md`                          (successor map — layout, conventions, verify)
- `README.md`                          (how to run / test — skipped if one already exists)
- `progress.md`
- `.gitignore`
- Global slash commands: `/plan`, `/delta`, `/verify`, `/loop`, `/handoff`, `/prime-init`

Optional: `-WithHooks` also creates `.cursor/hooks/hooks.json` (destructive-command guard).

Note: Maintainability is **project-scoped** via init. Global User Rules still carry Plan Gate discipline only; run `/prime-init` (or `init.ps1`) in each repo so successors get docs + layout rules in-tree.
