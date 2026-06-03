#Requires -Version 5.1
<#
.SYNOPSIS
    Initialize a project with cursor-prime rules and starter docs.

.DESCRIPTION
    Creates the following in the current working directory:
      - .cursor\rules\behavior.mdc  (always-applied Plan Gate + Karpathy rules)
      - .cursor\rules\project.mdc   (project context, agent-requested)
      - progress.md                 (working log)
      - .gitignore                  (project-specific ignores)
      - .cursor\hooks\*             (optional; -WithHooks)

    This is the most reliable way to make the Plan Gate apply, because Cursor
    loads .cursor/rules/*.mdc from the open project workspace.

    Existing files are never overwritten unless -Force is passed (in which case
    they are backed up to .bak.<timestamp>).

.PARAMETER Force
    Overwrite existing files; back them up first.

.PARAMETER WithHooks
    Install optional project hooks (.cursor/hooks.json) that ask before
    destructive shell commands. Default: off.

.EXAMPLE
    cd path\to\my\project
    & "$env:USERPROFILE\cursor-prime\init.ps1"

.EXAMPLE
    & "$env:USERPROFILE\cursor-prime\init.ps1" -Force -WithHooks
#>
[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$WithHooks
)

$ErrorActionPreference = 'Stop'

$Repo      = $PSScriptRoot
$Target    = (Get-Location).Path
$Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Log  ($m) { Write-Host "[cursor-prime init] $m" -ForegroundColor Cyan }
function Skip ($m) { Write-Host "[cursor-prime init] $m" -ForegroundColor DarkGray }

# (template-name-in-repo, target-path-relative-to-cwd) pairs.
$Files = @(
    @{ Src = 'behavior.mdc'; Dst = '.cursor\rules\behavior.mdc' }
    @{ Src = 'project.mdc';  Dst = '.cursor\rules\project.mdc'  }
    @{ Src = 'progress.md';  Dst = 'progress.md'                }
    @{ Src = 'gitignore';    Dst = '.gitignore'                 }
)

if ($WithHooks) {
    $Files += @{ Src = 'hooks\hooks.json'; Dst = '.cursor\hooks\hooks.json' }
    $Files += @{ Src = 'hooks\guard-destructive.ps1'; Dst = '.cursor\hooks\guard-destructive.ps1' }
}

# Validate sources before touching anything
foreach ($f in $Files) {
    $src = Join-Path $Repo "templates\$($f.Src)"
    if (-not (Test-Path $src)) { throw "Template missing: $src" }
}

foreach ($f in $Files) {
    $src     = Join-Path $Repo "templates\$($f.Src)"
    $dstAbs  = Join-Path $Target $f.Dst
    $dstDir  = Split-Path $dstAbs -Parent

    if (-not (Test-Path $dstDir)) {
        New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    }

    if (Test-Path $dstAbs) {
        if ($Force) {
            $backup = "$dstAbs.bak.$Timestamp"
            Copy-Item $dstAbs $backup -Force
            Copy-Item $src $dstAbs -Force
            Log "Replaced: $($f.Dst)  (backup: $(Split-Path $backup -Leaf))"
        } else {
            Skip "Skipped (exists): $($f.Dst)"
        }
    } else {
        Copy-Item $src $dstAbs -Force
        Log "Created:  $($f.Dst)"
    }
}

if ($WithHooks) {
    Log "Project hooks installed (.cursor/hooks.json). Restart Cursor if hooks do not load immediately."
} else {
    Skip "Hooks not installed (default). Re-run with -WithHooks to add destructive-command guard."
}

Log "Done. Open a new Cursor chat here and ask for a non-trivial task to verify Plan Gate."
