#Requires -Version 5.1
<#
.SYNOPSIS
    Install cursor-prime: a global Cursor settings package.

.DESCRIPTION
    Copies payload originals into the user profile:
      - payload\commands\*.md     -> ~/.cursor/commands/   (global slash commands)
      - payload\behavior.mdc      -> ~/.cursor/rules/behavior.mdc (best-effort; see note)
      - payload\gitignore_global  -> ~/.gitignore_global   (+ git config core.excludesfile)
      - payload\hooks\*           -> ~/.cursor/hooks/      (optional; -WithHooks)

    Builds paste-ready User Rules (Coding Behavior + Maintainability) from
    payload\behavior.mdc and payload\maintainability.mdc onto the clipboard
    and ~/.cursor-prime-user-rules.txt. Cursor has no file API for User Rules —
    paste once into Settings -> Rules -> User Rules; then every project inherits them.

    Existing files are backed up to <file>.bak.<timestamp>. A manifest at
    ~/.cursor-prime-manifest.json records what was installed so uninstall.ps1
    can undo precisely.

.PARAMETER Force
    Reinstall even if a manifest already exists.

.PARAMETER WithHooks
    Install optional user-level hooks (~/.cursor/hooks.json) that ask before
    destructive shell commands. Default: off.

.EXAMPLE
    .\install.ps1

.EXAMPLE
    .\install.ps1 -Force -WithHooks
#>
[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$WithHooks
)

$ErrorActionPreference = 'Stop'

$Repo         = $PSScriptRoot
$HomeDir      = $env:USERPROFILE
$ManifestPath = Join-Path $HomeDir '.cursor-prime-manifest.json'
$Timestamp    = Get-Date -Format 'yyyyMMdd-HHmmss'

function Log  ($m) { Write-Host "[cursor-prime] $m" -ForegroundColor Cyan }
function Warn ($m) { Write-Host "[cursor-prime] $m" -ForegroundColor Yellow }

function Install-FilePair {
    param(
        [string]$SrcRel,
        [string]$DstAbs,
        [ref]$InstalledList
    )
    $src = Join-Path $Repo $SrcRel
    if (-not (Test-Path $src)) { throw "Source missing: $src" }

    $dstDir = Split-Path $DstAbs -Parent
    if (-not (Test-Path $dstDir)) {
        New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    }

    $backup = $null
    if (Test-Path $DstAbs) {
        $backup = "$DstAbs.bak.$Timestamp"
        Copy-Item $DstAbs $backup -Force
        Log "Backed up: $DstAbs -> $backup"
    }

    Copy-Item $src $DstAbs -Force
    Log "Installed: $DstAbs"

    $InstalledList.Value += [pscustomobject]@{ path = $DstAbs; backup = $backup }
}

$Files = @(
    @{ Src = 'payload\behavior.mdc';     Dst = Join-Path $HomeDir '.cursor\rules\behavior.mdc' }
    @{ Src = 'payload\gitignore_global'; Dst = Join-Path $HomeDir '.gitignore_global'          }
)

$cmdSrcDir = Join-Path $Repo 'payload\commands'
if (Test-Path $cmdSrcDir) {
    Get-ChildItem -Path $cmdSrcDir -Filter '*.md' -File | ForEach-Object {
        $Files += @{
            Src = "payload\commands\$($_.Name)"
            Dst = Join-Path $HomeDir ".cursor\commands\$($_.Name)"
        }
    }
}

if ($WithHooks) {
    $Files += @{ Src = 'payload\hooks\hooks.json'; Dst = Join-Path $HomeDir '.cursor\hooks.json' }
    $Files += @{
        Src = 'payload\hooks\guard-destructive.ps1'
        Dst = Join-Path $HomeDir '.cursor\hooks\guard-destructive.ps1'
    }
}

if ((Test-Path $ManifestPath) -and -not $Force) {
    Warn "Already installed (manifest at $ManifestPath)."
    Warn "Run .\uninstall.ps1 first, or use -Force to reinstall."
    exit 1
}

foreach ($f in $Files) {
    $src = Join-Path $Repo $f.Src
    if (-not (Test-Path $src)) { throw "Source missing: $src" }
}

$installedFiles = @()

foreach ($f in $Files) {
    Install-FilePair -SrcRel $f.Src -DstAbs $f.Dst -InstalledList ([ref]$installedFiles)
}

# Drop retired per-project init command if a previous install left it behind
$obsoletePrimeInit = Join-Path $HomeDir '.cursor\commands\prime-init.md'
if (Test-Path $obsoletePrimeInit) {
    Remove-Item $obsoletePrimeInit -Force
    Log "Removed obsolete: $obsoletePrimeInit"
}

$prevExcludes = git config --global --get core.excludesfile 2>$null
if (-not $prevExcludes) { $prevExcludes = $null }

$gitignoreGlobal = Join-Path $HomeDir '.gitignore_global'
git config --global core.excludesfile $gitignoreGlobal
Log "git config --global core.excludesfile = $gitignoreGlobal"

function Get-MdcBody([string]$Path) {
    $lines = Get-Content $Path -Encoding UTF8
    if ($lines.Count -gt 0 -and $lines[0].Trim() -eq '---') {
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i].Trim() -eq '---') {
                if ($i + 1 -le $lines.Count - 1) {
                    return ($lines[($i + 1)..($lines.Count - 1)] -join "`r`n").Trim()
                }
                return ''
            }
        }
    }
    return ($lines -join "`r`n").Trim()
}

$behaviorPath = Join-Path $Repo 'payload\behavior.mdc'
$maintPath    = Join-Path $Repo 'payload\maintainability.mdc'
$behaviorBody = Get-MdcBody $behaviorPath
$maintBody    = Get-MdcBody $maintPath
$userRulesText = @"
$behaviorBody

---

$maintBody
"@.Trim()

$userRulesFile = Join-Path $HomeDir '.cursor-prime-user-rules.txt'
Set-Content -Path $userRulesFile -Value $userRulesText -Encoding UTF8
$installedFiles += [pscustomobject]@{ path = $userRulesFile; backup = $null }

$clipOk = $false
try { Set-Clipboard -Value $userRulesText -ErrorAction Stop; $clipOk = $true } catch { $clipOk = $false }

$manifest = [pscustomobject]@{
    name         = 'cursor-prime'
    version      = '0.3.1'
    installed_at = (Get-Date).ToString('o')
    with_hooks   = [bool]$WithHooks
    files        = $installedFiles
    git_config   = [pscustomobject]@{
        key      = 'core.excludesfile'
        set_to   = $gitignoreGlobal
        previous = $prevExcludes
    }
}

$manifest | ConvertTo-Json -Depth 6 | Set-Content -Path $ManifestPath -Encoding UTF8
Log "Manifest: $ManifestPath"

Write-Host ""
Log "Global slash commands installed: /plan, /delta, /verify, /loop, /handoff, /debug, /submission-init (open the command menu to use them)."
if ($WithHooks) {
    Log "User hooks installed (~/.cursor/hooks.json). Restart Cursor if hooks do not load immediately."
} else {
    Warn "Hooks not installed (default). Use -WithHooks to add destructive-command guard."
}
Write-Host ""
Warn "ONE manual step makes the rules global + automatic (Cursor has no file API for User Rules):"
if ($clipOk) {
    Warn "  User Rules text (Behavior + Maintainability) is ALREADY ON YOUR CLIPBOARD."
    Warn "  1) Open Cursor Settings -> Rules -> User Rules"
    Warn "  2) Click the box, press Ctrl+V, then save."
    Warn "  Done once = applies to every project, including new ones. (Backup: $userRulesFile)"
} else {
    Warn "  Open this file and copy all of it, then paste into Settings -> Rules -> User Rules:"
    Warn "  $userRulesFile"
}
Log "Done."
