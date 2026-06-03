# Prime this project

Scaffold cursor-prime's discipline rules and starter docs into the **current project** so every chat here follows the Plan Gate.

Run the init script from the project root (Windows / PowerShell):

```powershell
& "$env:USERPROFILE\cursor-prime\init.ps1"
```

If that path does not exist, ask the user where they cloned `cursor-prime`, then run its `init.ps1` from the current project directory.

After it runs, confirm these files exist and report what was created vs. skipped:
- `.cursor/rules/behavior.mdc`  (always-applied discipline rules)
- `.cursor/rules/project.mdc`   (project context — fill in tech stack, verify commands, protected paths)
- `progress.md`
- `.gitignore`

Optional: `-WithHooks` also creates `.cursor/hooks/hooks.json` (destructive-command guard).
