@echo off
setlocal enabledelayedexpansion

:: === LOAD CONFIGURATION ===
if not exist "config.ini" (
    echo [ERROR] Configuration file "config.ini" not found.
    echo Please create the file with the required paths.
    endlocal
    exit /b 1
)

:: Initialize counter for successful processes
set "SUCCESS_COUNT=0"

:: === PROCESS CONFIGURATION ===
for /f "tokens=1,2 delims==" %%A in (config.ini) do (
    :: Validate if the executable exists
    if not exist "%%B" (
        echo [ERROR] %%A executable not found at "%%B".
        echo Please check the path in the configuration file.
        set "RUN_%%A=0"
    ) else (
        set "RUN_%%A=1"
    )

    :: Check if the program is already running
    if "!RUN_%%A!"=="1" (
        echo Checking if %%A is already running...
        tasklist | find /i "%%~nB.exe" >nul
        if !errorlevel!==0 (
            echo %%A is already running.
        ) else (
            echo Starting %%A...
            start "" "%%B"
            timeout /t 2 >nul
            tasklist | find /i "%%~nB.exe" >nul
            if !errorlevel!==0 (
                echo %%A launched successfully.
                set /a SUCCESS_COUNT+=1
            ) else (
                echo [ERROR] Failed to launch %%A.
            )
        )
    )
)

echo All environments processed successfully.
echo Total processes successfully run: !SUCCESS_COUNT!
endlocal