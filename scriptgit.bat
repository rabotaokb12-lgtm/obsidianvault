@echo off
REM ===== Путь к твоему Vault =====
set VAULT=D:\Programs\Obsidian\Learn
set BACKUP=D:\Programs\Obsidian\Learn\ObsidianVaultBackups

REM ===== Создаём папку для бэкапов, если нет =====
if not exist "%BACKUP%" mkdir "%BACKUP%"

REM ===== Получаем день, месяц, год =====
for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
    set DD=%%a
    set MM=%%b
    set YYYY=%%c
)

REM ===== Получаем имя ПК =====
set PCNAME=%COMPUTERNAME%

REM ===== Собираем имя файла =====
set ZIPFILE=%BACKUP%\Backup_%DD%_%MM%_%YYYY%_%PCNAME%.zip

REM ===== Создаём zip архив =====
powershell -command "Compress-Archive -Path '%VAULT%\*' -DestinationPath '%ZIPFILE%' -Force"

REM ===== Переходим в папку репозитория =====
cd /d %VAULT%

REM ===== Git синхронизация =====
git add .
git commit -m "auto sync"
git pull --rebase
git push
