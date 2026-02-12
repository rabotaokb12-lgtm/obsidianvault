@echo off
REM ===== Путь к твоему Vault =====
set VAULT=D:\install\Obsidian\Learn
set BACKUP=D:\install\Obsidian\Learn\ObsidianVaultBackups

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

REM ===== Проверяем, есть ли уже архив на эту дату =====
if exist "%ZIPFILE%" (
    echo Архив на %DD%.%MM%.%YYYY% уже существует. Создаём новый с индексом...
    set INDEX=1
    :loop
    set ZIPFILE_INDEXED=%BACKUP%\Backup_%DD%_%MM%_%YYYY%_%PCNAME%_%INDEX%.zip
    if exist "%ZIPFILE_INDEXED%" (
        set /a INDEX+=1
        goto loop
    )
    set ZIPFILE=%ZIPFILE_INDEXED%
)

REM ===== Создаём zip архив =====
powershell -command "Compress-Archive -Path '%VAULT%\*' -DestinationPath '%ZIPFILE%'"

REM ===== Переходим в папку репозитория =====
cd /d %VAULT%

REM ===== Git синхронизация =====
git add .
git commit -m "auto sync"
git pull --rebase
git push