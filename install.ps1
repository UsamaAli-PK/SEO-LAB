# install.ps1 — SEO Lab
# One-command full setup for a new machine.
# Idempotent: safe to run multiple times.
#
# Usage:
#   cd D:\path\to\SEO-LAB
#   .\install.ps1
#
# What it does:
#   1. Checks prerequisites (Python 3.10+, Node.js 18+, Git)
#   2. Creates Python venv + installs all dependencies
#   3. Installs Playwright browsers (for screenshot capture)
#   4. Verifies Node.js tools (.tools/gsd-tools.cjs)
#   5. Prints first command to run

$ErrorActionPreference = "Stop"
$ROOT = $PSScriptRoot

function Write-Step($msg) { Write-Host "`n>>> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "    [WARN] $msg" -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "`n    [FAIL] $msg" -ForegroundColor Red }

# ─────────────────────────────────────────────────────────
# Step 1: Check prerequisites
# ─────────────────────────────────────────────────────────
Write-Step "Checking prerequisites..."

# Python
$pythonCmd = $null
foreach ($cmd in @("python", "py", "python3")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($ver -match "Python (\d+)\.(\d+)") {
            $major = [int]$Matches[1]; $minor = [int]$Matches[2]
            if ($major -ge 3 -and $minor -ge 10) {
                $pythonCmd = $cmd
                Write-Ok "Python $major.$minor found ($cmd)"
                break
            }
        }
    } catch {}
}
if (-not $pythonCmd) {
    Write-Fail "Python 3.10+ not found. Install from: https://www.python.org/downloads/"
    exit 1
}

# Node.js
try {
    $nodeVer = node --version 2>&1
    if ($nodeVer -match "v(\d+)") {
        $nodeMajor = [int]$Matches[1]
        if ($nodeMajor -ge 18) {
            Write-Ok "Node.js $nodeVer found"
        } else {
            Write-Fail "Node.js 18+ required. Found: $nodeVer. Install from: https://nodejs.org/"
            exit 1
        }
    }
} catch {
    Write-Fail "Node.js not found. Install from: https://nodejs.org/"
    exit 1
}

# Git
try {
    $gitVer = git --version 2>&1
    Write-Ok "$gitVer found"
} catch {
    Write-Fail "Git not found. Install from: https://git-scm.com/"
    exit 1
}

# ─────────────────────────────────────────────────────────
# Step 2: Python venv for SEO scripts
# ─────────────────────────────────────────────────────────
Write-Step "Setting up Python venv for SEO scripts..."

$venvPath = Join-Path $ROOT "vendor\claude-seo\skills\seo\.venv"
$reqPath  = Join-Path $ROOT "vendor\claude-seo\skills\seo\requirements.txt"

if (-not (Test-Path $venvPath)) {
    Write-Host "    Creating venv at vendor\claude-seo\skills\seo\.venv ..."
    & $pythonCmd -m venv $venvPath
    Write-Ok "venv created"
} else {
    Write-Ok "venv already exists — skipping creation"
}

$pip = Join-Path $venvPath "Scripts\pip.exe"

if (Test-Path $reqPath) {
    Write-Host "    Installing SEO requirements..."
    & $pip install --quiet --upgrade pip
    & $pip install --quiet -r $reqPath
    Write-Ok "SEO requirements installed"
} else {
    Write-Warn "requirements.txt not found at $reqPath — skipping"
}

# ─────────────────────────────────────────────────────────
# Step 3: Playwright browsers
# ─────────────────────────────────────────────────────────
Write-Step "Installing Playwright browsers (for screenshot capture)..."

$python = Join-Path $venvPath "Scripts\python.exe"

# Check if playwright is installed in venv
$playwrightInstalled = $false
try {
    $result = & $python -c "import playwright; print('ok')" 2>&1
    if ($result -eq "ok") { $playwrightInstalled = $true }
} catch {}

if ($playwrightInstalled) {
    try {
        & $python -m playwright install chromium --quiet 2>&1 | Out-Null
        Write-Ok "Playwright chromium installed"
    } catch {
        Write-Warn "Playwright browser install failed — screenshots may not work. Run manually: python -m playwright install chromium"
    }
} else {
    Write-Warn "Playwright not in venv — skipping browser install (install requirements.txt first)"
}

# ─────────────────────────────────────────────────────────
# Step 4: Blog scripts dependencies
# ─────────────────────────────────────────────────────────
Write-Step "Checking blog script dependencies..."

$blogReq = Join-Path $ROOT "vendor\claude-blog\scripts\requirements.txt"
if (Test-Path $blogReq) {
    Write-Host "    Installing blog requirements..."
    & $pip install --quiet -r $blogReq
    Write-Ok "Blog requirements installed"
} else {
    Write-Ok "No separate blog requirements.txt — using SEO venv"
}

# ─────────────────────────────────────────────────────────
# Step 5: Verify Node.js tools
# ─────────────────────────────────────────────────────────
Write-Step "Verifying .tools/gsd-tools.cjs..."

$toolsPath = Join-Path $ROOT ".tools\gsd-tools.cjs"
if (Test-Path $toolsPath) {
    try {
        $slug = node $toolsPath generate-slug "SEO Lab" 2>&1
        if ($slug -match "seo-lab") {
            Write-Ok "gsd-tools.cjs working: generate-slug -> $slug"
        } else {
            Write-Warn "gsd-tools.cjs returned unexpected output: $slug"
        }
    } catch {
        Write-Warn "gsd-tools.cjs test failed: $_"
    }
} else {
    Write-Warn ".tools/gsd-tools.cjs not found — run update.ps1 to restore"
}

# ─────────────────────────────────────────────────────────
# Step 6: Verify hooks are wired
# ─────────────────────────────────────────────────────────
Write-Step "Checking hooks..."

$hookFiles = @(
    ".hooks\gsd-context-monitor.js",
    ".hooks\gsd-prompt-guard.js"
)
foreach ($h in $hookFiles) {
    $full = Join-Path $ROOT $h
    if (Test-Path $full) { Write-Ok "$h present" }
    else                  { Write-Warn "$h missing — hooks may not fire" }
}

# ─────────────────────────────────────────────────────────
# Step 7: Create Projects/ directory (gitignored)
# ─────────────────────────────────────────────────────────
Write-Step "Creating Projects/ directory..."
New-Item -ItemType Directory -Force (Join-Path $ROOT "Projects") | Out-Null
Write-Ok "Projects/ ready (gitignored — client data stays local)"

# ─────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────
Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  SEO Lab — Setup Complete"          -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "  Python venv : vendor\claude-seo\skills\seo\.venv"
Write-Host "  SEO skills  : vendor\claude-seo\skills\ (25 skills)"
Write-Host "  Blog skills : vendor\claude-blog\skills\ (30 skills)"
Write-Host "  State file  : .planning\STATE.md"
Write-Host ""
Write-Host "  First command to run in Claude Code or Gemini:" -ForegroundColor Cyan
Write-Host ""
Write-Host "    /seo audit https://yoursite.com" -ForegroundColor White
Write-Host ""
Write-Host "  Or resume current work:" -ForegroundColor Cyan
Write-Host "    Read .planning\STATE.md for the Next Up command"
Write-Host ""
