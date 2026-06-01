@echo off
title Job Portal - Full Setup
color 0A

echo.
echo  ============================================================
echo   JOB PORTAL - FULL SETUP SCRIPT
echo   This will:
echo     1. Wipe the old database (if any)
echo     2. Create tables, stored procedures and seed all data
echo     3. Fix Web.config connection string automatically
echo     4. Launch the app at http://localhost:5050
echo  ============================================================
echo.
echo  Password for ALL accounts:  Pak@123
echo.
echo  Press any key to begin... (or close this window to cancel)
pause >nul

:: Check if PowerShell is available
where powershell >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found. Please install PowerShell.
    pause
    exit /b 1
)

:: Run the PowerShell setup script with execution policy bypass
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  Setup failed. See error above.
    echo  Press any key to close...
    pause >nul
    exit /b 1
)

echo.
echo  Press any key to close this window...
pause >nul
