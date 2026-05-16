@echo off
setlocal

set "ROOT=%~dp0"
set "PROJECT_PATH=%ROOT%JobPortal\JobPortal"
set "SEED_FILE=%ROOT%seed_sample_data.sql"
set "SQL_SERVER=.\SQLEXPRESS"
set "SQL_DATABASE=JobPortal_New1"
set "PORT=5050"

echo ======================================================
echo Job Portal Startup
echo ======================================================

where sqlcmd >nul 2>nul
if %errorlevel%==0 (
    if exist "%SEED_FILE%" (
        echo [1/2] Seeding database...
        sqlcmd -S "%SQL_SERVER%" -d "%SQL_DATABASE%" -E -i "%SEED_FILE%"
        if errorlevel 1 (
            echo Database seeding failed. Check SQL Server connection and DB name.
            exit /b 1
        )
    ) else (
        echo Seed file not found: "%SEED_FILE%"
    )
) else (
    echo sqlcmd not found, skipping database seed step.
)

set "IIS_EXPRESS=%ProgramFiles(x86)%\IIS Express\iisexpress.exe"
if not exist "%IIS_EXPRESS%" set "IIS_EXPRESS=%ProgramFiles%\IIS Express\iisexpress.exe"

if not exist "%IIS_EXPRESS%" (
    echo IIS Express is not installed.
    echo Install Visual Studio/IIS Express, then run this script again.
    exit /b 1
)

if not exist "%PROJECT_PATH%" (
    echo Project path not found: "%PROJECT_PATH%"
    exit /b 1
)

echo [2/2] Starting web app on http://localhost:%PORT%
start "" "%IIS_EXPRESS%" /path:"%PROJECT_PATH%" /port:%PORT%

echo Done. Open: http://localhost:%PORT%
endlocal
