@echo off
setlocal enabledelayedexpansion

rem Set default values for memory, port, jar file, Aikar’s flags, and auto-restart
set DEFAULT_MEMORY_GB=4
set DEFAULT_PORT=25565
set DEFAULT_USE_AIKAR_FLAGS=Y
set DEFAULT_AUTORESTART=Y
set DEFAULT_JAR_INDEX=1

rem Title
title Minecraft Server - Initializing...

rem Display default settings with added spacing
echo ========================================
echo         Minecraft Server Setup         
echo ========================================
echo.
echo Default Settings:
echo   Memory: %DEFAULT_MEMORY_GB% GB
echo   Port: %DEFAULT_PORT%
echo   Aikar's Flags: %DEFAULT_USE_AIKAR_FLAGS% (Y = Enabled, N = Disabled)
echo   Auto-Restart: %DEFAULT_AUTORESTART% (Y = Enabled, N = Disabled)
echo   Default .jar File Index: %DEFAULT_JAR_INDEX%
echo.
echo ========================================
echo.

rem Ask to use default settings
<nul set /p "Prompt=Do you want to use all default settings? (Y/N, default is Y): "
set /p USE_DEFAULTS=

if "%USE_DEFAULTS%"=="" set USE_DEFAULTS=Y

if /I "%USE_DEFAULTS%"=="Y" (
    rem Set all default values and skip prompts
    set MEMORY_GB=%DEFAULT_MEMORY_GB%
    set PORT=%DEFAULT_PORT%
    set USE_AIKAR_FLAGS=%DEFAULT_USE_AIKAR_FLAGS%
    set AUTORESTART=%DEFAULT_AUTORESTART%
    set JAR_CHOICE=%DEFAULT_JAR_INDEX%
    goto :validate_memory
)

rem If user chooses not to use defaults, proceed with manual input
rem Recommend and validate memory input
:input_memory
echo.
set /p MEMORY_GB="Enter the amount of memory to allocate in GB (minimum 2, default is %DEFAULT_MEMORY_GB%): "
if "%MEMORY_GB%"=="" set MEMORY_GB=%DEFAULT_MEMORY_GB%

if %MEMORY_GB% LSS 2 (
    echo Please enter at least 2 GB of memory.
    goto :input_memory
)

:validate_memory
rem Convert GB to MB (e.g., 2 GB -> 2048 MB)
set /a MEMORY_MB=%MEMORY_GB%*1024

rem Ensure MEMORY_MIN_MB has a default value
if "%MEMORY_MB%"=="" set /a MEMORY_MB=4096
set /a MEMORY_MIN_MB=%MEMORY_MB%*35/100

rem Check for java\bin\java.exe, fallback to system Java if not found
set JAVA_EXEC=java\bin\java.exe
if not exist "%JAVA_EXEC%" (
    echo "java\bin\java.exe" not found. Trying system default Java...
    set JAVA_EXEC=java
)

rem Test if Java is available
"%JAVA_EXEC%" -version >nul 2>&1
if errorlevel 1 (
    echo.
    echo Error: Java was not found. Please install Java to continue.
    echo.
    echo You can download Java from:
    echo https://adoptium.net/en-GB/temurin/releases/?os=windows&arch=x64&package=jdk
    start https://adoptium.net/en-GB/temurin/releases/?os=windows&arch=x64&package=jdk
    pause
    exit /b
)

rem Search for all .jar files in the current directory
set JAR_FILES=
set JAR_INDEX=1
for %%f in (*.jar) do (
    set "JAR_FILES=!JAR_FILES!%%f;"
    echo !JAR_INDEX!: %%f
    set "JAR[!JAR_INDEX!]=%%f"
    set /a JAR_INDEX+=1
)

rem If no .jar files are found, display an error and exit
if "!JAR_FILES!"=="" (
    echo.
    echo No .jar files found in the current directory.
    echo Please place your Minecraft server .jar file in this folder and try again.
    pause
    exit /b
)

rem Select the default JAR file if using defaults
if /I "%USE_DEFAULTS%"=="Y" (
    set JAR_FILE=!JAR[%DEFAULT_JAR_INDEX%]!
    goto :start_server
)

rem Prompt the user to select a JAR file
:select_jar
echo.
set /p JAR_CHOICE="Enter the number of the .jar file you want to run (default is %DEFAULT_JAR_INDEX%): "
if "!JAR_CHOICE!"=="" set JAR_CHOICE=%DEFAULT_JAR_INDEX%
if "!JAR[%JAR_CHOICE%]!"=="" (
    echo Invalid selection. Please try again.
    goto :select_jar
)
set JAR_FILE=!JAR[%JAR_CHOICE%]!

rem Prompt for custom port
echo.
set /p PORT="Enter the server port (default is %DEFAULT_PORT%): "
if "%PORT%"=="" set PORT=%DEFAULT_PORT%

rem Prompt the user for Aikar's Flags
echo.
<nul set /p "Prompt=Do you want to use Aikar's Flags? (Y/N, default is %DEFAULT_USE_AIKAR_FLAGS%): "
set /p USE_AIKAR_FLAGS=
if "%USE_AIKAR_FLAGS%"=="" set USE_AIKAR_FLAGS=%DEFAULT_USE_AIKAR_FLAGS%

rem Prompt the user for Auto-Restart
echo.
<nul set /p "Prompt=Enable Auto-Restart? (Y/N, default is %DEFAULT_AUTORESTART%): "
set /p AUTORESTART=
if "%AUTORESTART%"=="" set AUTORESTART=%DEFAULT_AUTORESTART%

:start_server
rem Display settings with added spacing
echo.
echo Selected server file: %JAR_FILE%
echo Allocating %MEMORY_MB% MB of memory with a minimum heap size of %MEMORY_MIN_MB% MB.
echo Using port: %PORT%.
if /I "%USE_AIKAR_FLAGS%"=="Y" (
    echo Aikar's Flags: Enabled
) else (
    echo Aikar's Flags: Disabled
)
if /I "%AUTORESTART%"=="Y" (
    echo Auto-Restart: Enabled
) else (
    echo Auto-Restart: Disabled
)

:start_loop
rem Run the server based on the choice
if /I "%USE_AIKAR_FLAGS%"=="Y" (
    title Minecraft Server - Aikar's Flags Enabled
    "%JAVA_EXEC%" -Xms%MEMORY_MIN_MB%M -Xmx%MEMORY_MB%M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -jar "%JAR_FILE%" --nogui --port %PORT%
) else (
    title Minecraft Server - Default Settings
    "%JAVA_EXEC%" -Xms%MEMORY_MIN_MB%M -Xmx%MEMORY_MB%M -jar "%JAR_FILE%" --nogui --port %PORT%
)

rem Check if auto-restart is enabled
if /I "%AUTORESTART%"=="Y" (
    echo Server crashed or stopped unexpectedly. Restarting in 15 seconds. Press Ctrl+C to cancel...
    timeout /t 15
    goto :start_loop
) else (
    echo Server has stopped.
    pause
    goto :end_script
)

:end_script
echo Exiting script...
pause


