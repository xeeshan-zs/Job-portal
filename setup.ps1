#Requires -Version 5.1
<#
.SYNOPSIS
    Job Portal - Full Setup Script
    --------------------------------
    Run this once on the target machine after cloning the repo.
    It will:
      1. Auto-detect your SQL Server instance
      2. Drop & recreate the JobPortal_New1 database (clean slate)
      3. Create all tables, foreign keys, and stored procedures
      4. Seed sample data (employers, jobs, seekers, skills, applications, chat)
      5. Patch Web.config with the correct connection string
      6. Launch the app in IIS Express on http://localhost:5050

.NOTES
    Run as Administrator for best results.
    Password for all seeded accounts: Pak@123
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────
#  PATHS
# ─────────────────────────────────────────────
$ROOT        = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SQL_FILE    = Join-Path $ROOT "reset_and_setup_db.sql"
$WEB_CONFIG  = Join-Path $ROOT "JobPortal\JobPortal\Web.config"
$PROJECT_DIR = Join-Path $ROOT "JobPortal\JobPortal"
$PORT        = 5050

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  JOB PORTAL - FULL SETUP" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ─────────────────────────────────────────────
#  STEP 1 – Find sqlcmd
# ─────────────────────────────────────────────
Write-Host "[1/5] Locating sqlcmd..." -ForegroundColor Yellow

$sqlcmd = $null
# Try PATH first
try { $sqlcmd = (Get-Command sqlcmd -ErrorAction Stop).Source } catch {}

# Search common install locations
if (-not $sqlcmd) {
    $candidates = @(
        "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\sqlcmd.exe",
        "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe",
        "C:\Program Files\Microsoft SQL Server\150\Tools\Binn\sqlcmd.exe",
        "C:\Program Files\Microsoft SQL Server\140\Tools\Binn\sqlcmd.exe",
        "C:\Program Files\Microsoft SQL Server\130\Tools\Binn\sqlcmd.exe",
        "C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\sqlcmd.exe",
        "C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { $sqlcmd = $c; break }
    }
}

if (-not $sqlcmd) {
    Write-Host ""
    Write-Host "ERROR: sqlcmd not found." -ForegroundColor Red
    Write-Host "Please install SQL Server Management Studio (SSMS) or the SQL Server command-line tools." -ForegroundColor Red
    Write-Host "Download: https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-utility" -ForegroundColor Red
    exit 1
}
Write-Host "  sqlcmd found: $sqlcmd" -ForegroundColor Green

# ─────────────────────────────────────────────
#  STEP 2 – Auto-detect SQL Server instance
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "[2/5] Detecting SQL Server instance..." -ForegroundColor Yellow

$instances = @()

# Check registry for local instances
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Microsoft SQL Server\Instance Names\SQL"
)
foreach ($regPath in $regPaths) {
    if (Test-Path $regPath) {
        $names = Get-Item $regPath | Select-Object -ExpandProperty Property -ErrorAction SilentlyContinue
        foreach ($n in $names) {
            if ($n -eq "MSSQLSERVER") {
                $instances += "."
            } else {
                $instances += ".\$n"
            }
        }
    }
}

# Also try well-known names explicitly
$wellKnown = @(".", ".\SQLEXPRESS", ".\MSSQLSERVER", ".\SQLSERVER", ".\SQL2019", ".\SQL2022", "(local)", "localhost")
foreach ($wk in $wellKnown) {
    if ($instances -notcontains $wk) { $instances += $wk }
}

# Remove duplicates
$instances = $instances | Select-Object -Unique

Write-Host "  Testing instances: $($instances -join ', ')" -ForegroundColor DarkGray

$SQL_SERVER = $null
foreach ($inst in $instances) {
    try {
        $result = & $sqlcmd -S $inst -E -Q "SELECT 1" -l 3 2>&1
        if ($LASTEXITCODE -eq 0) {
            $SQL_SERVER = $inst
            break
        }
    } catch { }
}

if (-not $SQL_SERVER) {
    Write-Host ""
    Write-Host "ERROR: Could not connect to any local SQL Server instance." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please enter your SQL Server instance name manually." -ForegroundColor Yellow
    Write-Host "Examples: .   .\SQLEXPRESS   .\MSSQLSERVER   SERVER\INSTANCE" -ForegroundColor DarkGray
    $SQL_SERVER = Read-Host "SQL Server instance"
    if (-not $SQL_SERVER) { Write-Host "Cancelled."; exit 1 }

    # Verify manual entry
    $result = & $sqlcmd -S $SQL_SERVER -E -Q "SELECT 1" -l 5 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Still cannot connect to '$SQL_SERVER'. Check that SQL Server is running." -ForegroundColor Red
        exit 1
    }
}

Write-Host "  Connected to: $SQL_SERVER" -ForegroundColor Green

# ─────────────────────────────────────────────
#  STEP 3 – Run the reset + setup SQL
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "[3/5] Resetting & setting up database..." -ForegroundColor Yellow

if (-not (Test-Path $SQL_FILE)) {
    Write-Host "ERROR: SQL file not found: $SQL_FILE" -ForegroundColor Red
    exit 1
}

Write-Host "  Running: $SQL_FILE" -ForegroundColor DarkGray
Write-Host "  (This drops the old DB and creates a fresh one with all data)" -ForegroundColor DarkGray
Write-Host ""

$output = & $sqlcmd -S $SQL_SERVER -E -i $SQL_FILE -b 2>&1
$exitCode = $LASTEXITCODE

# Print output line by line with color
foreach ($line in $output) {
    if ($line -match "ERROR|error|Msg \d+") {
        Write-Host "  $line" -ForegroundColor Red
    } elseif ($line -match "created|completed|ready|online|Seed") {
        Write-Host "  $line" -ForegroundColor Green
    } else {
        Write-Host "  $line" -ForegroundColor DarkGray
    }
}

if ($exitCode -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Database setup failed (exit code $exitCode)." -ForegroundColor Red
    Write-Host "Check the output above for details." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "  Database setup complete!" -ForegroundColor Green

# ─────────────────────────────────────────────
#  STEP 4 – Patch Web.config connection string
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "[4/5] Updating Web.config connection string..." -ForegroundColor Yellow

if (-not (Test-Path $WEB_CONFIG)) {
    Write-Host "ERROR: Web.config not found at: $WEB_CONFIG" -ForegroundColor Red
    exit 1
}

# Build the correct connection string for the detected instance
$connStr = "Data Source=$SQL_SERVER;Initial Catalog=JobPortal_New1;Integrated Security=True;Encrypt=False;TrustServerCertificate=True"

[xml]$config = Get-Content $WEB_CONFIG -Encoding UTF8

$connNode = $config.configuration.connectionStrings.add | Where-Object { $_.name -eq "mycon" }
if ($connNode) {
    $connNode.connectionString = $connStr
    Write-Host "  Connection string updated to use: $SQL_SERVER" -ForegroundColor Green
} else {
    Write-Host "WARNING: 'mycon' connection string not found in Web.config." -ForegroundColor Yellow
    Write-Host "         Please update it manually to: $connStr" -ForegroundColor Yellow
}

$config.Save($WEB_CONFIG)
Write-Host "  Web.config saved." -ForegroundColor Green

# ─────────────────────────────────────────────
#  STEP 5 – Launch via IIS Express
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "[5/5] Launching app in IIS Express..." -ForegroundColor Yellow

$iisExpress = $null
$iisSearchPaths = @(
    "${env:ProgramFiles(x86)}\IIS Express\iisexpress.exe",
    "$env:ProgramFiles\IIS Express\iisexpress.exe",
    "C:\Program Files (x86)\IIS Express\iisexpress.exe",
    "C:\Program Files\IIS Express\iisexpress.exe"
)
foreach ($p in $iisSearchPaths) {
    if (Test-Path $p) { $iisExpress = $p; break }
}

if (-not $iisExpress) {
    Write-Host ""
    Write-Host "IIS Express not found." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You can still run the project by:" -ForegroundColor Cyan
    Write-Host "  Option A) Open JobPortal\JobPortal.sln in Visual Studio and press F5" -ForegroundColor Cyan
    Write-Host "  Option B) Install IIS Express from: https://www.microsoft.com/en-us/download/details.aspx?id=48264" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Database is set up and ready. Login credentials:" -ForegroundColor Green
    Show-Credentials
    exit 0
}

if (-not (Test-Path $PROJECT_DIR)) {
    Write-Host "ERROR: Project directory not found: $PROJECT_DIR" -ForegroundColor Red
    exit 1
}

Write-Host "  Starting: http://localhost:$PORT" -ForegroundColor Green
Start-Process -FilePath $iisExpress -ArgumentList "/path:`"$PROJECT_DIR`" /port:$PORT" -WindowStyle Normal

Start-Sleep -Seconds 2

# Try to open browser
try {
    Start-Process "http://localhost:$PORT"
} catch {
    Write-Host "  Could not auto-open browser. Navigate to: http://localhost:$PORT" -ForegroundColor Yellow
}

# ─────────────────────────────────────────────
#  DONE - Print credentials
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  SETUP COMPLETE!" -ForegroundColor Green
Write-Host "  App running at: http://localhost:$PORT" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  LOGIN CREDENTIALS (password for all: Pak@123)" -ForegroundColor Cyan
Write-Host ""
Write-Host "  ADMIN" -ForegroundColor White
Write-Host "    Username : admin" -ForegroundColor DarkGray
Write-Host "    Password : Pak@123" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  JOB SEEKERS" -ForegroundColor White
Write-Host "    alikhan / fatimabibi / ahmedraza / saraahmed / zeeshanmalik" -ForegroundColor DarkGray
Write-Host "    Password: Pak@123" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  EMPLOYERS" -ForegroundColor White
Write-Host "    systemsltd / netsolpk / jazzpk / ublpk / arbisoft" -ForegroundColor DarkGray
Write-Host "    Password: Pak@123" -ForegroundColor DarkGray
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
