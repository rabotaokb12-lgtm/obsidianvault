@echo off
REM ===== Путь к твоему Vault =====
set VAULT=D:\Programs\Obsidian\Learn
set BACKUP=D:\Programs\Obsidian\Learn\ObsidianVaultBackups

REM ===== Создаём папку для бэкапов, если нет =====
if not exist "%BACKUP%" mkdir "%BACKUP%"

REM ===== Создаём архив с датой =====
set DATE=%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%
REM убираем пробел в часах
set DATE=%DATE: =0%
set ZIPFILE=%BACKUP%\ObsidianBackup_%DATE%.zip

REM ===== Создаём zip архив =====
powershell -command "Compress-Archive -Path '%VAULT%\*' -DestinationPath '%ZIPFILE%' -Force"

REM ===== Переходим в папку репозитория =====
cd /d %VAULT%

REM ===== Git синхронизация =====
git add .
git commit -m "auto sync"
git pull --rebase
git push
