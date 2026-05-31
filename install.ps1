#Requires -Version 5.1
<#
.SYNOPSIS
    Install cursor-prime: Cursor global commands, a best-effort global
    behavior rule, and a global gitignore.

.DESCRIPTION
    Copies files from this repo into the user profile:
      - home\.cursor\commands\*.md   -> ~/.cursor/commands/   (Cursor global slash commands; reliable)
      - templates\behavior.mdc       -> ~/.cursor/rules/behavior.mdc (best-effort global rule; see note)
      - home\.gitignore_global       -> ~/.gitignore_global   (+ git config core.excludesfile)

    Cursor's true global "User Rules" live in Settings -> Rules and are stored
    inside Cursor (cloud-synced), so they CANNOT be installed from a file.
    This script prints the rule text at the end so you can paste it once.
    For per-project enforcement, use init.ps1 instead (writes .cursor/rules/*.mdc).

    Existing files are backed up to <file>.bak.<timestamp>. A manifest at
    ~/.cursor-prime-manifest.json records what was installed so uninstall.ps1
    can undo precisely.

.PARAMETER Force
    Reinstall even if a manifest already exists.

.EXAMPLE
    .\install.ps1

.EXAMPLE
    .\install.ps1 -Force
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$Repo         = $PSScriptRoot
$HomeDir      = $env:USERPROFILE
$ManifestPath = Join-Path $HomeDir '.cursor-prime-manifest.json'
$Timestamp    = Get-Date -Format 'yyyyMMdd-HHmmss'

function Log  ($m) { Write-Host "[cursor-prime] $m" -ForegroundColor Cyan }
function Warn ($m) { Write-Host "[cursor-prime] $m" -ForegroundColor Yellow }

# (source-relative-to-repo, destination-absolute) pairs.
$Files = @(
    @{ Src = 'templates\behavior.mdc'; Dst = Join-Path $HomeDir '.cursor\rules\behavior.mdc' }
    @{ Src = 'home\.gitignore_global'; Dst = Join-Path $HomeDir '.gitignore_global'          }
)

# Add every global command in home\.cursor\commands\*.md
$cmdSrcDir = Join-Path $Repo 'home\.cursor\commands'
if (Test-Path $cmdSrcDir) {
    Get-ChildItem -Path $cmdSrcDir -Filter '*.md' -File | ForEach-Object {
        $Files += @{
            Src = "home\.cursor\commands\$($_.Name)"
            Dst = Join-Path $HomeDir ".cursor\commands\$($_.Name)"
        }
    }
}

if ((Test-Path $ManifestPath) -and -not $Force) {
    Warn "Already installed (manifest at $ManifestPath)."
    Warn "Run .\uninstall.ps1 first, or use -Force to reinstall."
    exit 1
}

# Validate all sources before touching anything
foreach ($f in $Files) {
    $src = Join-Path $Repo $f.Src
    if (-not (Test-Path $src)) { throw "Source missing: $src" }
}

$installedFiles = @()

foreach ($f in $Files) {
    $src = Join-Path $Repo $f.Src
    $dst = $f.Dst

    $dstDir = Split-Path $dst -Parent
    if (-not (Test-Path $dstDir)) {
        New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    }

    $backup = $null
    if (Test-Path $dst) {
        $backup = "$dst.bak.$Timestamp"
        Copy-Item $dst $backup -Force
        Log "Backed up: $dst -> $backup"
    }

    Copy-Item $src $dst -Force
    Log "Installed: $dst"

    $installedFiles += [pscustomobject]@{ path = $dst; backup = $backup }
}

# Capture and update git core.excludesfile
$prevExcludes = git config --global --get core.excludesfile 2>$null
if (-not $prevExcludes) { $prevExcludes = $null }

$gitignoreGlobal = Join-Path $HomeDir '.gitignore_global'
git config --global core.excludesfile $gitignoreGlobal
Log "git config --global core.excludesfile = $gitignoreGlobal"

# Build the User Rules text: behavior.mdc with its leading --- frontmatter block removed
$behaviorPath  = Join-Path $Repo 'templates\behavior.mdc'
$behaviorLines = Get-Content $behaviorPath -Encoding UTF8
$bodyLines     = $behaviorLines
if ($behaviorLines.Count -gt 0 -and $behaviorLines[0].Trim() -eq '---') {
    for ($i = 1; $i -lt $behaviorLines.Count; $i++) {
        if ($behaviorLines[$i].Trim() -eq '---') {
            $bodyLines = $behaviorLines[($i + 1)..($behaviorLines.Count - 1)]
            break
        }
    }
}
$userRulesText = ($bodyLines -join "`r`n").Trim()

# Save a paste-ready copy and try to put it on the clipboard
$userRulesFile = Join-Path $HomeDir '.cursor-prime-user-rules.txt'
Set-Content -Path $userRulesFile -Value $userRulesText -Encoding UTF8
$installedFiles += [pscustomobject]@{ path = $userRulesFile; backup = $null }

$clipOk = $false
try { Set-Clipboard -Value $userRulesText -ErrorAction Stop; $clipOk = $true } catch { $clipOk = $false }

# Write manifest
$manifest = [pscustomobject]@{
    name         = 'cursor-prime'
    version      = '1.0.0'
    installed_at = (Get-Date).ToString('o')
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
Log "Global slash commands installed: /plan, /delta, /prime-init (open the command menu to use them)."
Write-Host ""
Warn "ONE manual step makes the rules global + automatic (Cursor has no file API for User Rules):"
if ($clipOk) {
    Warn "  The rule text is ALREADY ON YOUR CLIPBOARD."
    Warn "  1) Open Cursor Settings -> Rules -> User Rules"
    Warn "  2) Click the box, press Ctrl+V, then save."
} else {
    Warn "  Open this file and copy all of it, then paste into Settings -> Rules -> User Rules:"
    Warn "    $userRulesFile"
}
Warn "  Done once = applies to every project, including new ones. (Backup copy: $userRulesFile)"
Log "Done."
