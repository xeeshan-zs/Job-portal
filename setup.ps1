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
      5. Restore NuGet packages
      6. Patch Web.config (connection string + remove broken codedom section)
      7. Launch the app in IIS Express on http://localhost:5050

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
$SOLUTION    = Join-Path $ROOT "JobPortal\JobPortal.sln"
$PROJECT_DIR = Join-Path $ROOT "JobPortal\JobPortal"
$PACKAGES    = Join-Path $ROOT "JobPortal\packages"
$PORT        = 5050

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  JOB PORTAL - FULL SETUP" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ─────────────────────────────────────────────
#  STEP 1 – Find sqlcmd
# ─────────────────────────────────────────────
Write-Host "[1/6] Locating sqlcmd..." -ForegroundColor Yellow

$sqlcmd = $null
try { $sqlcmd = (Get-Command sqlcmd -ErrorAction Stop).Source } catch {}

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
    Write-Host "Please install SQL Server Management Studio (SSMS) or SQL Server command-line tools." -ForegroundColor Red
    Write-Host "Download: https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-utility" -ForegroundColor Red
    exit 1
}
Write-Host "  sqlcmd found: $sqlcmd" -ForegroundColor Green

# ─────────────────────────────────────────────
#  STEP 2 – Auto-detect SQL Server instance
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "[2/6] Detecting SQL Server instance..." -ForegroundColor Yellow

$instances = @()

$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Microsoft SQL Server\Instance Names\SQL"
)
foreach ($regPath in $regPaths) {
    if (Test-Path $regPath) {
        $names = Get-Item $regPath | Select-Object -ExpandProperty Property -ErrorAction SilentlyContinue
        foreach ($n in $names) {
            if ($n -eq "MSSQLSERVER") { $instances += "." }
            else                       { $instances += ".\$n" }
        }
    }
}

$wellKnown = @(".", ".\SQLEXPRESS", ".\MSSQLSERVER", ".\SQLSERVER", ".\SQL2019", ".\SQL2022", "(local)", "localhost")
foreach ($wk in $wellKnown) {
    if ($instances -notcontains $wk) { $instances += $wk }
}
$instances = $instances | Select-Object -Unique

Write-Host "  Testing instances: $($instances -join ', ')" -ForegroundColor DarkGray

$SQL_SERVER = $null
foreach ($inst in $instances) {
    try {
        $result = & $sqlcmd -S $inst -E -Q "SELECT 1" -l 3 2>&1
        if ($LASTEXITCODE -eq 0) { $SQL_SERVER = $inst; break }
    } catch { }
}

if (-not $SQL_SERVER) {
    Write-Host ""
    Write-Host "ERROR: Could not auto-detect a SQL Server instance." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please enter your SQL Server instance name manually." -ForegroundColor Yellow
    Write-Host "Examples:  .    .\SQLEXPRESS    .\MSSQLSERVER    MYPC\SQL2022" -ForegroundColor DarkGray
    $SQL_SERVER = Read-Host "SQL Server instance"
    if (-not $SQL_SERVER) { Write-Host "Cancelled."; exit 1 }

    $result = & $sqlcmd -S $SQL_SERVER -E -Q "SELECT 1" -l 5 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Cannot connect to '$SQL_SERVER'. Check that SQL Server is running." -ForegroundColor Red
        exit 1
    }
}

Write-Host "  Connected to: $SQL_SERVER" -ForegroundColor Green

# ─────────────────────────────────────────────
#  STEP 3 – Run the reset + setup SQL
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "[3/6] Resetting & setting up database..." -ForegroundColor Yellow

if (-not (Test-Path $SQL_FILE)) {
    Write-Host "ERROR: SQL file not found: $SQL_FILE" -ForegroundColor Red
    exit 1
}

Write-Host "  Running: reset_and_setup_db.sql" -ForegroundColor DarkGray
Write-Host "  (Drops old DB, creates fresh schema, seeds all data)" -ForegroundColor DarkGray
Write-Host ""

$output   = & $sqlcmd -S $SQL_SERVER -E -i $SQL_FILE -b 2>&1
$exitCode = $LASTEXITCODE

foreach ($line in $output) {
    if ($line -match "ERROR|Msg \d+,") {
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
    exit 1
}

Write-Host ""
Write-Host "  Database setup complete!" -ForegroundColor Green

# ─────────────────────────────────────────────
#  STEP 4 – NuGet package restore
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "[4/6] Restoring NuGet packages..." -ForegroundColor Yellow

$nugetExe = $null

# 1) Try nuget.exe already on PATH
try { $nugetExe = (Get-Command nuget -ErrorAction Stop).Source } catch {}

# 2) Try well-known locations (Visual Studio ships nuget.exe)
if (-not $nugetExe) {
    $nugetCandidates = @(
        "$env:ProgramFiles\NuGet\nuget.exe",
        "${env:ProgramFiles(x86)}\NuGet\nuget.exe",
        "$env:LOCALAPPDATA\NuGet\nuget.exe"
    )
    # Also search inside Visual Studio install folders
    $vsroots = @(
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio",
        "$env:ProgramFiles\Microsoft Visual Studio"
    )
    foreach ($vsr in $vsroots) {
        if (Test-Path $vsr) {
            $found = Get-ChildItem -Path $vsr -Filter "nuget.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) { $nugetCandidates += $found.FullName }
        }
    }
    foreach ($n in $nugetCandidates) {
        if (Test-Path $n) { $nugetExe = $n; break }
    }
}

# 3) Try msbuild /t:Restore as a fallback
$msbuildExe = $null
try { $msbuildExe = (Get-Command msbuild -ErrorAction Stop).Source } catch {}
if (-not $msbuildExe) {
    $vsroots = @(
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio",
        "$env:ProgramFiles\Microsoft Visual Studio"
    )
    foreach ($vsr in $vsroots) {
        if (Test-Path $vsr) {
            $found = Get-ChildItem -Path $vsr -Filter "msbuild.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) { $msbuildExe = $found.FullName; break }
        }
    }
}

if ($nugetExe) {
    Write-Host "  Using nuget.exe: $nugetExe" -ForegroundColor DarkGray
    $nugetOut = & $nugetExe restore $SOLUTION 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  NuGet restore succeeded." -ForegroundColor Green
    } else {
        Write-Host "  NuGet restore had issues (non-fatal, continuing):" -ForegroundColor Yellow
        $nugetOut | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
    }
} elseif ($msbuildExe) {
    Write-Host "  nuget.exe not found. Using msbuild /t:Restore..." -ForegroundColor DarkGray
    $msbOut = & $msbuildExe $SOLUTION /t:Restore /v:minimal 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  msbuild restore succeeded." -ForegroundColor Green
    } else {
        Write-Host "  msbuild restore had issues (non-fatal, continuing)." -ForegroundColor Yellow
    }
} else {
    Write-Host "  nuget.exe and msbuild not found. Will download nuget.exe..." -ForegroundColor Yellow
    $nugetDest = Join-Path $env:TEMP "nuget.exe"
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" `
                          -OutFile $nugetDest -UseBasicParsing
        Write-Host "  Downloaded nuget.exe to temp." -ForegroundColor DarkGray
        $nugetOut = & $nugetDest restore $SOLUTION 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  NuGet restore succeeded." -ForegroundColor Green
        } else {
            Write-Host "  NuGet restore had issues. Continuing anyway." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  Could not download nuget.exe. Continuing without package restore." -ForegroundColor Yellow
        Write-Host "  If the app shows a CodeDom error, open the .sln in Visual Studio and" -ForegroundColor Yellow
        Write-Host "  do: Build > Restore NuGet Packages, then re-run SETUP.bat." -ForegroundColor Yellow
    }
}

# ─────────────────────────────────────────────
#  STEP 5 – Patch Web.config
#           a) connection string
#           b) remove <system.codedom> if packages missing
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "[5/6] Patching Web.config..." -ForegroundColor Yellow

if (-not (Test-Path $WEB_CONFIG)) {
    Write-Host "ERROR: Web.config not found at: $WEB_CONFIG" -ForegroundColor Red
    exit 1
}

# --- a) Read file as raw text (preserves encoding) ---
$rawXml = Get-Content $WEB_CONFIG -Raw -Encoding UTF8

# --- b) Fix connection string ---
$connStr   = "Data Source=$SQL_SERVER;Initial Catalog=JobPortal_New1;Integrated Security=True;Encrypt=False;TrustServerCertificate=True"
$rawXml    = $rawXml -replace '(?i)(name="mycon"\s+connectionString=")[^"]*(")', "`${1}$connStr`${2}"
Write-Host "  Connection string updated  ->  $SQL_SERVER" -ForegroundColor Green

# --- c) Check if the DotNetCompilerPlatform DLL actually exists in packages ---
$dllExists = $false
if (Test-Path $PACKAGES) {
    $dll = Get-ChildItem -Path $PACKAGES -Filter "Microsoft.CodeDom.Providers.DotNetCompilerPlatform.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($dll) { $dllExists = $true }
}

if (-not $dllExists) {
    # Remove the <system.codedom>...</system.codedom> block entirely
    # so IIS Express uses the built-in C# compiler (perfectly fine for .NET 4.7.2)
    $rawXml = $rawXml -replace '(?s)\s*<system\.codedom>.*?</system\.codedom>', ''
    Write-Host "  <system.codedom> removed   (DotNetCompilerPlatform package not found)" -ForegroundColor Green
    Write-Host "  The app will use the default .NET 4.7.2 compiler -- fully compatible." -ForegroundColor DarkGray
} else {
    Write-Host "  DotNetCompilerPlatform DLL found -- keeping <system.codedom> intact." -ForegroundColor Green
}

# --- d) Save ---
[System.IO.File]::WriteAllText($WEB_CONFIG, $rawXml, [System.Text.Encoding]::UTF8)
Write-Host "  Web.config saved." -ForegroundColor Green

# ─────────────────────────────────────────────
#  STEP 6 – Launch via IIS Express
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "[6/6] Launching app in IIS Express..." -ForegroundColor Yellow

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
    Write-Host "  IIS Express not found." -ForegroundColor Yellow
    Write-Host "  Open  JobPortal\JobPortal.sln  in Visual Studio and press F5." -ForegroundColor Cyan
} else {
    if (-not (Test-Path $PROJECT_DIR)) {
        Write-Host "ERROR: Project directory not found: $PROJECT_DIR" -ForegroundColor Red
        exit 1
    }

    Write-Host "  Starting IIS Express -> http://localhost:$PORT" -ForegroundColor Green
    Start-Process -FilePath $iisExpress -ArgumentList "/path:`"$PROJECT_DIR`" /port:$PORT" -WindowStyle Normal
    Start-Sleep -Seconds 2

    try { Start-Process "http://localhost:$PORT" } catch {}
}

# ─────────────────────────────────────────────
#  DONE
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  SETUP COMPLETE!" -ForegroundColor Green
Write-Host "  App: http://localhost:$PORT" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  LOGIN CREDENTIALS  (password for all accounts: Pak@123)" -ForegroundColor Cyan
Write-Host ""
Write-Host "  ADMIN" -ForegroundColor White
Write-Host "    admin / Pak@123" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  JOB SEEKERS" -ForegroundColor White
Write-Host "    alikhan   fatimabibi   ahmedraza   saraahmed   zeeshanmalik" -ForegroundColor DarkGray
Write-Host "    Password: Pak@123" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  EMPLOYERS" -ForegroundColor White
Write-Host "    systemsltd   netsolpk   jazzpk   ublpk   arbisoft" -ForegroundColor DarkGray
Write-Host "    Password: Pak@123" -ForegroundColor DarkGray
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
