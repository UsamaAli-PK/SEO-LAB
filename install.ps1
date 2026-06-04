# install.ps1 — SEO Lab
# One-command full setup for a new machine.
# Idempotent: safe to run multiple times.
#
# Usage:
#   cd D:\path\to\SEO-LAB
#   .\install.ps1
#
# What it does:
#   1. Checks + installs/upgrades Python 3.10+, Node.js 18+, Git via winget
#   2. Creates Python venv + installs all dependencies
#   3. Installs Playwright browsers (for screenshot capture)
#   4. Installs blog script dependencies
#   5. Verifies Node.js tools
#   6. Runs update.ps1 to pull latest skill versions
#   7. Creates Projects/ directory

$ErrorActionPreference = "Stop"
$ROOT = $PSScriptRoot

function Write-Step($msg) { Write-Host "`n>>> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    [OK]   $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "    [WARN] $msg" -ForegroundColor Yellow }
function Write-Info($msg) { Write-Host "    [-->]  $msg" -ForegroundColor White }
function Write-Fail($msg) { Write-Host "`n    [FAIL] $msg" -ForegroundColor Red }

# ─────────────────────────────────────────────────────────
# Banner
# ─────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║                                                  ║" -ForegroundColor Cyan
Write-Host "  ║    ⚗  SEO Lab  -  Installer                     ║" -ForegroundColor Cyan
Write-Host "  ║    Audit  .  Strategize  .  Write               ║" -ForegroundColor Cyan
Write-Host "  ║                                                  ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ─────────────────────────────────────────────────────────
# Winget helper — install or upgrade a package
# ─────────────────────────────────────────────────────────
function Install-OrUpgrade {
    param(
        [string]$Name,
        [string]$WingetId,
        [string]$ManualUrl
    )

    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        Write-Warn "winget not available — install $Name manually: $ManualUrl"
        return $false
    }

    # Check if already installed
    $installed = winget list --id $WingetId --accept-source-agreements 2>$null |
                 Select-String $WingetId
    if ($installed) {
        Write-Info "Checking for $Name upgrade..."
        $result = winget upgrade --id $WingetId --accept-package-agreements `
                    --accept-source-agreements --silent 2>&1
        if ($result -match "No applicable upgrade") {
            Write-Ok "$Name is up to date"
        } else {
            Write-Ok "$Name upgraded"
        }
    } else {
        Write-Info "Installing $Name via winget..."
        winget install --id $WingetId --accept-package-agreements `
            --accept-source-agreements --silent 2>&1 | Out-Null
        Write-Ok "$Name installed"
        # Refresh PATH so newly installed tools are available
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
                    [System.Environment]::GetEnvironmentVariable("PATH","User")
    }
    return $true
}

# ─────────────────────────────────────────────────────────
# Step 1: Python 3.10+
# ─────────────────────────────────────────────────────────
Write-Step "Checking Python 3.10+..."

$pythonCmd = $null
foreach ($cmd in @("python", "py", "python3")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($ver -match "Python (\d+)\.(\d+)") {
            $major = [int]$Matches[1]; $minor = [int]$Matches[2]
            if ($major -ge 3 -and $minor -ge 10) {
                $pythonCmd = $cmd
                Write-Ok "Python $major.$minor already installed ($cmd)"
                break
            } elseif ($major -ge 3) {
                Write-Warn "Python $major.$minor found but 3.10+ required — upgrading..."
                Install-OrUpgrade "Python" "Python.Python.3.12" "https://www.python.org/downloads/" | Out-Null
                $pythonCmd = "python"; break
            }
        }
    } catch {}
}

if (-not $pythonCmd) {
    Write-Info "Python not found — installing..."
    $ok = Install-OrUpgrade "Python" "Python.Python.3.12" "https://www.python.org/downloads/"
    if (-not $ok) {
        Write-Fail "Python 3.10+ required. Install from: https://www.python.org/downloads/"
        exit 1
    }
    # Try again after install
    foreach ($cmd in @("python", "py", "python3")) {
        try {
            $ver = & $cmd --version 2>&1
            if ($ver -match "Python (\d+)\.(\d+)") {
                $major = [int]$Matches[1]; $minor = [int]$Matches[2]
                if ($major -ge 3 -and $minor -ge 10) { $pythonCmd = $cmd; break }
            }
        } catch {}
    }
    if (-not $pythonCmd) {
        Write-Fail "Python install succeeded but 'python' command not found. Restart your terminal and re-run."
        exit 1
    }
}

# ─────────────────────────────────────────────────────────
# Step 2: Node.js 18+
# ─────────────────────────────────────────────────────────
Write-Step "Checking Node.js 18+..."

$nodeOk = $false
try {
    $nodeVer = node --version 2>&1
    if ($nodeVer -match "v(\d+)") {
        $nodeMajor = [int]$Matches[1]
        if ($nodeMajor -ge 18) {
            Write-Ok "Node.js $nodeVer already installed"
            $nodeOk = $true
        } else {
            Write-Warn "Node.js $nodeVer found but 18+ required — upgrading..."
            Install-OrUpgrade "Node.js" "OpenJS.NodeJS.LTS" "https://nodejs.org/" | Out-Null
            $nodeOk = $true
        }
    }
} catch {
    Write-Info "Node.js not found — installing..."
    $ok = Install-OrUpgrade "Node.js" "OpenJS.NodeJS.LTS" "https://nodejs.org/"
    if (-not $ok) {
        Write-Fail "Node.js 18+ required. Install from: https://nodejs.org/"
        exit 1
    }
    $nodeOk = $true
}

if (-not $nodeOk) {
    Write-Fail "Node.js 18+ required. Install from: https://nodejs.org/"
    exit 1
}

# ─────────────────────────────────────────────────────────
# Step 3: Git
# ─────────────────────────────────────────────────────────
Write-Step "Checking Git..."

try {
    $gitVer = git --version 2>&1
    Write-Ok "$gitVer already installed"
} catch {
    Write-Info "Git not found — installing..."
    $ok = Install-OrUpgrade "Git" "Git.Git" "https://git-scm.com/"
    if (-not $ok) {
        Write-Fail "Git required. Install from: https://git-scm.com/"
        exit 1
    }
    try {
        $gitVer = git --version 2>&1
        Write-Ok "$gitVer installed"
    } catch {
        Write-Fail "Git install succeeded but command not found. Restart terminal and re-run."
        exit 1
    }
}

# ─────────────────────────────────────────────────────────
# Step 4: Python venv for SEO scripts
# ─────────────────────────────────────────────────────────
Write-Step "Setting up Python venv for SEO scripts..."

$venvPath = Join-Path $ROOT "vendor\claude-seo\skills\seo\.venv"
$reqPath  = Join-Path $ROOT "vendor\claude-seo\skills\seo\requirements.txt"

if (-not (Test-Path $venvPath)) {
    Write-Info "Creating venv at vendor\claude-seo\skills\seo\.venv ..."
    & $pythonCmd -m venv $venvPath
    Write-Ok "venv created"
} else {
    Write-Ok "venv already exists"
}

$pip    = Join-Path $venvPath "Scripts\pip.exe"
$python = Join-Path $venvPath "Scripts\python.exe"

if (Test-Path $reqPath) {
    Write-Info "Installing / upgrading SEO requirements..."
    & $pip install --quiet --upgrade pip
    & $pip install --quiet --upgrade -r $reqPath
    Write-Ok "SEO requirements installed"
} else {
    Write-Warn "requirements.txt not found at $reqPath — skipping"
}

# ─────────────────────────────────────────────────────────
# Step 5: Playwright browsers
# ─────────────────────────────────────────────────────────
Write-Step "Installing Playwright browsers (for screenshot capture)..."

$playwrightInstalled = $false
try {
    $result = & $python -c "import playwright; print('ok')" 2>&1
    if ($result -eq "ok") { $playwrightInstalled = $true }
} catch {}

if ($playwrightInstalled) {
    try {
        & $python -m playwright install chromium 2>&1 | Out-Null
        Write-Ok "Playwright chromium installed"
    } catch {
        Write-Warn "Playwright browser install failed. Run manually: python -m playwright install chromium"
    }
} else {
    Write-Warn "Playwright not in venv — skipping (will work after requirements install)"
}

# ─────────────────────────────────────────────────────────
# Step 6: Blog script dependencies
# ─────────────────────────────────────────────────────────
Write-Step "Checking blog script dependencies..."

$blogReq = Join-Path $ROOT "vendor\claude-blog\scripts\requirements.txt"
if (Test-Path $blogReq) {
    Write-Info "Installing / upgrading blog requirements..."
    & $pip install --quiet --upgrade -r $blogReq
    Write-Ok "Blog requirements installed"
} else {
    Write-Ok "No separate blog requirements.txt — using SEO venv"
}

# ─────────────────────────────────────────────────────────
# Step 7: Verify Node.js tools
# ─────────────────────────────────────────────────────────
Write-Step "Verifying .tools/gsd-tools.cjs..."

$toolsPath = Join-Path $ROOT ".tools\gsd-tools.cjs"
if (Test-Path $toolsPath) {
    try {
        $slug = node $toolsPath generate-slug "SEO Lab" 2>&1
        if ($slug -match "seo-lab") {
            Write-Ok "gsd-tools.cjs working"
        } else {
            Write-Warn "gsd-tools.cjs returned unexpected output: $slug"
        }
    } catch {
        Write-Warn "gsd-tools.cjs test failed: $_"
    }
} else {
    Write-Warn ".tools/gsd-tools.cjs not found — will be restored by update.ps1"
}

# ─────────────────────────────────────────────────────────
# Step 8: Verify hooks
# ─────────────────────────────────────────────────────────
Write-Step "Checking hooks..."

foreach ($h in @(".hooks\gsd-context-monitor.js", ".hooks\gsd-prompt-guard.js")) {
    $full = Join-Path $ROOT $h
    if (Test-Path $full) { Write-Ok "$h present" }
    else                  { Write-Warn "$h missing" }
}

# ─────────────────────────────────────────────────────────
# Step 9: Create Projects/ directory
# ─────────────────────────────────────────────────────────
Write-Step "Creating Projects/ directory..."
New-Item -ItemType Directory -Force (Join-Path $ROOT "Projects") | Out-Null
Write-Ok "Projects/ ready (gitignored — client data stays local)"

# ─────────────────────────────────────────────────────────
# Step 10: Pull latest skill versions
# ─────────────────────────────────────────────────────────
Write-Step "Pulling latest skill versions via update.ps1..."

$updateScript = Join-Path $ROOT "update.ps1"
if (Test-Path $updateScript) {
    try {
        & $updateScript
        Write-Ok "Skills updated to latest versions"
    } catch {
        Write-Warn "update.ps1 encountered an issue: $_ (skills may be slightly outdated)"
    }
} else {
    Write-Warn "update.ps1 not found — skipping upstream sync"
}

# ─────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║                                                  ║" -ForegroundColor Green
Write-Host "  ║    [OK] SEO Lab - Setup Complete                 ║" -ForegroundColor Green
Write-Host "  ║                                                  ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "  Installed:" -ForegroundColor White
Write-Host "    SEO skills   vendor\claude-seo\skills\  (25 skills, 18 agents)" -ForegroundColor Green
Write-Host "    Blog skills  vendor\claude-blog\skills\ (30 skills,  5 agents)" -ForegroundColor Green
Write-Host "    Python venv  vendor\claude-seo\skills\seo\.venv" -ForegroundColor Green
Write-Host "    State file   .planning\STATE.md" -ForegroundColor Green
Write-Host ""
Write-Host "  Commands:" -ForegroundColor Cyan
Write-Host "    /seo audit <url>           Full parallel site audit" -ForegroundColor White
Write-Host "    /seo write-blog <keyword>  Write a ranked article" -ForegroundColor White
Write-Host "    /seo content-plan <url>    90-day editorial calendar" -ForegroundColor White
Write-Host ""
Write-Host "  Get started - open Claude Code or Gemini CLI and run:" -ForegroundColor Cyan
Write-Host "    /seo audit https://yoursite.com" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Resume previous work:" -ForegroundColor Cyan
Write-Host "    Read .planning\STATE.md - the Next Up block has your exact command." -ForegroundColor White
Write-Host ""
