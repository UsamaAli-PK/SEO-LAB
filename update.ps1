# update.ps1 — SEO Operations Platform
# Re-syncs vendor/ from upstream repositories.
# Your .planning/, .hooks/, .agents/, CLAUDE.md are NEVER touched.
#
# Usage:
#   cd D:\path\to\seo-ops
#   .\update.ps1
#
# What it does:
#   1. Reads vendor.json for upstream URLs + current commits
#   2. For each upstream: sparse clone -> copy needed dirs -> update vendor.json
#   3. Reports what changed (old commit -> new commit)
#   4. Reminds you to re-run install.ps1 if requirements changed

$ErrorActionPreference = "Stop"
$ROOT = $PSScriptRoot

function Write-Step($msg) { Write-Host "`n>>> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "    [WARN] $msg" -ForegroundColor Yellow }
function Write-Info($msg) { Write-Host "    $msg" -ForegroundColor Gray }

# Load vendor.json
$vendorFile = Join-Path $ROOT "vendor.json"
if (-not (Test-Path $vendorFile)) {
    Write-Host "[FAIL] vendor.json not found at $vendorFile" -ForegroundColor Red
    exit 1
}
$vendor = Get-Content $vendorFile | ConvertFrom-Json

$tempBase = Join-Path $env:TEMP "seo-ops-update"
$requirementsChanged = $false
$report = @()

# ─────────────────────────────────────────────────────────
# Sync function
# ─────────────────────────────────────────────────────────
function Sync-Upstream {
    param(
        [string]$Name,
        [string]$Upstream,
        [string]$Branch,
        [string[]]$CopyDirs,
        [string]$OldCommit
    )

    Write-Step "Syncing $Name from $Upstream ..."

    $tempDir = Join-Path $tempBase $Name
    if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }

    # Sparse clone (depth 1 = fastest, no full history)
    Write-Info "Cloning (depth 1)..."
    git clone --depth 1 --branch $Branch --no-tags $Upstream $tempDir --quiet 2>&1 | Out-Null

    # Get new commit hash
    $newCommit = (git -C $tempDir rev-parse --short HEAD).Trim()
    Write-Info "Upstream commit: $OldCommit -> $newCommit"

    $destDir = Join-Path $ROOT "vendor\$Name"

    # Copy each requested directory
    foreach ($dir in $CopyDirs) {
        $src = Join-Path $tempDir $dir.TrimEnd('/')
        $dst = Join-Path $destDir $dir.TrimEnd('/')

        if (Test-Path $src) {
            if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
            Copy-Item -Recurse $src $dst
            Write-Ok "Copied $dir"
        } else {
            Write-Warn "$dir not found in upstream — skipping"
        }
    }

    # Copy requirements.txt if present at root
    $req = Join-Path $tempDir "requirements.txt"
    if (Test-Path $req) {
        $oldReq = Join-Path $destDir "requirements.txt"
        $reqChanged = $false
        if (Test-Path $oldReq) {
            $oldHash = (Get-FileHash $oldReq -Algorithm MD5).Hash
            $newHash = (Get-FileHash $req     -Algorithm MD5).Hash
            if ($oldHash -ne $newHash) { $reqChanged = $true }
        } else { $reqChanged = $true }

        Copy-Item $req (Join-Path $destDir "requirements.txt") -Force
        if ($reqChanged) {
            Write-Warn "requirements.txt changed — re-run install.ps1 after update"
            $script:requirementsChanged = $true
        } else {
            Write-Ok "requirements.txt unchanged"
        }
    }

    # Cleanup temp
    Remove-Item $tempDir -Recurse -Force

    return $newCommit
}

# ─────────────────────────────────────────────────────────
# Sync claude-seo
# ─────────────────────────────────────────────────────────
$seoOld    = $vendor."claude-seo".commit
$seoDirs   = $vendor."claude-seo".copied
$seoNew    = Sync-Upstream `
    -Name      "claude-seo" `
    -Upstream  $vendor."claude-seo".upstream `
    -Branch    $vendor."claude-seo".branch `
    -CopyDirs  $seoDirs `
    -OldCommit $seoOld

if ($seoNew -eq $seoOld) {
    $report += "claude-seo : $seoOld (no change)"
} else {
    $report += "claude-seo : $seoOld -> $seoNew (UPDATED)"
}

# ─────────────────────────────────────────────────────────
# Sync claude-blog
# ─────────────────────────────────────────────────────────
$blogOld   = $vendor."claude-blog".commit
$blogDirs  = $vendor."claude-blog".copied
$blogNew   = Sync-Upstream `
    -Name      "claude-blog" `
    -Upstream  $vendor."claude-blog".upstream `
    -Branch    $vendor."claude-blog".branch `
    -CopyDirs  $blogDirs `
    -OldCommit $blogOld

if ($blogNew -eq $blogOld) {
    $report += "claude-blog: $blogOld (no change)"
} else {
    $report += "claude-blog: $blogOld -> $blogNew (UPDATED)"
}

# ─────────────────────────────────────────────────────────
# Update vendor.json with new commit hashes
# ─────────────────────────────────────────────────────────
Write-Step "Updating vendor.json..."

$vendor."claude-seo".commit  = $seoNew
$vendor."claude-seo".synced  = (Get-Date -Format "yyyy-MM-dd")
$vendor."claude-blog".commit = $blogNew
$vendor."claude-blog".synced = (Get-Date -Format "yyyy-MM-dd")

$vendor | ConvertTo-Json -Depth 5 | Set-Content $vendorFile -Encoding UTF8
Write-Ok "vendor.json updated"

# Cleanup temp base
if (Test-Path $tempBase) { Remove-Item $tempBase -Recurse -Force }

# ─────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────
Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  Update Complete" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
foreach ($line in $report) { Write-Host "  $line" }
Write-Host ""

if ($requirementsChanged) {
    Write-Host "  !! Requirements changed — run install.ps1 to update venv:" -ForegroundColor Yellow
    Write-Host "     .\install.ps1" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "  Review changes with: git diff vendor/" -ForegroundColor Cyan
Write-Host "  Commit when happy:   git add vendor/ vendor.json && git commit -m `"chore: update upstream vendors`"" -ForegroundColor Cyan
Write-Host ""
