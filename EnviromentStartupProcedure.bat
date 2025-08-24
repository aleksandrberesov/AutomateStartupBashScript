@echo off
setlocal enabledelayedexpansion

:: === CONFIGURATION FILE ===
set "CONFIG_FILE=%~1"
if "%CONFIG_FILE%"=="" set "CONFIG_FILE=config.ini"

:: === LOAD CONFIGURATION ===
if not exist "%CONFIG_FILE%" (
    echo [ERROR] Configuration file "%CONFIG_FILE%" not found.
    echo Please provide a valid configuration file as a parameter or create "config.ini".
    endlocal
    exit /b 1
)

:: Initialize counter for successful processes
set "SUCCESS_COUNT=0"

:: === PROCESS CONFIGURATION ===
for /f "tokens=1,2 delims==" %%A in (%CONFIG_FILE%) do (
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
            ping 127.0.0.1 -n 1 -w 500 >nul
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