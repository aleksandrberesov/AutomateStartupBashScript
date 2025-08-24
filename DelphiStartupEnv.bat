@echo off
setlocal enabledelayedexpansion

:: === CONFIGURATION ===
:: Set full paths to your development tools below

set "DELPHI_IDE=C:\Program Files (x86)\Embarcadero\Studio\16.0\bin\bds.exe"
set "RPSERVER=C:\Eidos\RPServer-6.1\RPServer.exe"

:: === FLAGS ===
set "RUN_DELPHI=1"
set "RUN_RPSERVER=1"

:: === VALIDATION ===
if not exist "%DELPHI_IDE%" (
    echo [ERROR] Delphi IDE executable not found at "%DELPHI_IDE%".
    echo Please check the path in the configuration section.
    set "RUN_DELPHI=0"
)

if not exist "%RPSERVER%" (
    echo [ERROR] RPServer executable not found at "%RPSERVER%".
    echo Please check the path in the configuration section.
    set "RUN_RPSERVER=0"
)

:: === CHECK IF PROGRAMS ARE ALREADY RUNNING ===
if "%RUN_DELPHI%"=="1" (
    echo Checking if Delphi IDE is already running...
    tasklist | find /i "bds.exe"
    if !errorlevel!==0 (
        echo Delphi IDE is already running.
    ) else (
        echo Starting Delphi IDE...
        start "" "%DELPHI_IDE%"
        if %errorlevel%==0 (
            echo Delphi IDE launched successfully.
        ) else (
            echo [ERROR] Failed to launch Delphi IDE.
        )
    )
)

if "%RUN_RPSERVER%"=="1" (
    echo Checking if RPServer is already running...
    tasklist | find /i "RPServer.exe"
    if !errorlevel!==0 (
        echo RPServer is already running.
    ) else (
        echo Starting RPServer...
        start "" "%RPSERVER%"
        if %errorlevel%==0 (
            echo RPServer launched successfully.
        ) else (
            echo [ERROR] Failed to launch RPServer.
        )
    )
)

echo All environments launched successfully.
endlocal