@echo off
title Lifesteal Server
color a
setlocal

:: Configuration
set "server_dir=D:\Server\Dev\Minecraft\Servers\lifesteal"
set "backup_dir=D:\Server\Dev\Minecraft\Servers\lifesteal\backup"
set "log_file=D:\Server\Dev\Minecraft\Servers\lifesteal\clogs\logs.txt"
set "java_dir=C:\"

:: Start the server
echo Starting Minecraft server...
cd /d "%server_dir%"
java -Xmx2G -jar paper-1.19.3-386.jar nogui > "%log_file%" 2>&1
echo Minecraft server has stopped.

:: Backup the world
echo Creating backup...
if not exist "%backup_dir%" mkdir "%backup_dir%"
xcopy /s /e /q /y "%server_dir%\world" "%backup_dir%\world-%date:/=-%-%time::=-%"
echo Backup created: "%backup_dir%\world-%date:/=-%-%time::=-%"

:: Wait for 24 hours
echo Waiting for 24 hours...
timeout /t 86400 /nobreak > nul

:: Reload the server
echo Reloading Minecraft server...
taskkill /f /im java.exe > nul
java -Xmx2G -jar server.jar nogui >> "%log_file%" 2>&1
echo Minecraft server has stopped.

:: Repeat the backup and wait loop
goto :backup_and_wait

:end
endlocal
echo Script has ended.
pause