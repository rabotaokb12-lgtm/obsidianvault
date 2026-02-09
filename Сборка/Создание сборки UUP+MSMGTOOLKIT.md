1. https://uupdump.net/ Заходим на сайте выбираем какую винду скачать
     1.1. Выбираем расширение **amd64**
     1.2![[Pasted image 20250730105713.png]]
     1.3. В файле "ConvertConfig.ini" в строке "CustomList" ставим значение **1**
     1.4. В файле "CustomAppList.txt" выбираем что удалить. **#** = Удалить, 
        без решётки = оставить
        **Список того что нужно оставить:**
        **ВСЕ** кодеки - ### Media Codecs / Client non-N editions, Team edition
        Microsoft.StartExperiencesApp_8wekyb3d8bbwe
        Microsoft.ScreenSketch_8wekyb3d8bbwe
        Microsoft.WindowsCalculator_8wekyb3d8bbwe
        Microsoft.WindowsNotepad_8wekyb3d8bbwe
        Microsoft.Paint_8wekyb3d8bbwe
        Microsoft.WindowsTerminal_8wekyb3d8bbwe
        MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy
        Microsoft.WindowsStore_8wekyb3d8bbwe
        Microsoft.StorePurchaseApp_8wekyb3d8bbwe
        Microsoft.SecHealthUI_8wekyb3d8bbwe
        Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
        Microsoft.Windows.Photos_8wekyb3d8bbwe
    1.5. Запускаем файл **uup_download_windows**

2. https://msmgtoolkit.in/downloads.html Скачиваем MSMG TOOLKIT
     2.1 Разархивируем и ложим iso в папку ISO, и сам iso файл переименовываем 
     2.2 Открываем файл ToolKit.cmd
     2.3 Нажимаем Source(1) -> Extract Source from DVD ISO Image(3) и пишем имя iso файла
     2.4 Нажимаем 1 -> 1 и пишем 1,  N N 
     2.5 Для удаления ещё каких то утилит или приложений нажимаем 3,1,1 выбираем
        раздел и для удаления пишем цифру которая закреплена затем что мы хотим удалить
        **НЕ ТРОГАЕМ** = internet, network, privacy, remoting
        Я удаляю: 
        Windows apps(8) -> 1 7 9 10 11 12 15 16 28 29 38 43 44 45 47 53 56 57 58 61 68 69
                        70 71 72 73 
        System Apps(7) -> 17 20 44 50 
     2.5 Как всё выбрали нажимаем х пока не увидим 2 вкладки и нажимаем на Start Removing Windows Components(2)
     2.6 Установка NetFrameWork:
         2.6.1 Открываем наш iso образ запоминаем букву которую дала система 
         2.6.2 копируем путь ТВОЙ ПУТЬ/Mount/Install/1 
         2.6.3 Запуск cmd от имение админа
         2.6.4 Вписываем туда это dism /image:"ТВОЙ ПУТЬ\Mount\Install\1" /enable-feature /featurname:NetFX3 /All /Source:БУКВА ISO:\sources\sxs
     2.7 В MSMG TOOLKIT нажимаем Apply(6)->CleanUP(1) после нажимаем на 
         Apply & Save(2) Y
     2.8 Чтобы образ стал меньше в раза 2= Tools(8)->Wim Manager(1)->Convert(E)
     2.9 Дальше выбираем Target(7) -> Make a DVD ISO IMAGE(1) вписываем имя флешки и iso образа
3. Установка встроенных программ в систему 
     3.1 Создаём папки ![[Pasted image 20250801163757.png]]
     ![[Pasted image 20250801163839.png]]
     3.2 Создаём в первой папке SetupComplete.cmd и пишем туда(Для каждой проги свои строки, нужно тестить-**/S**)
@echo off
title Удаление шпионства из Windows 10 + Отключение ненужных служб
color 0A

:: === Удаление телеметрии ===
echo Отключение телеметрии...

sc stop DiagTrack
sc delete DiagTrack

sc stop dmwappushservice
sc delete dmwappushservice

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f

:: === Отключение задач-шпионов ===
echo Отключение задач планировщика...

schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable

:: === Блокировка шпионских доменов ===
echo Блокировка доменов...

echo 0.0.0.0 vortex.data.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 telemetry.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 settings-win.data.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 watson.telemetry.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 ssw.live.com >> %SystemRoot%\System32\drivers\etc\hosts

:: === Отключение сбора данных ввода ===
echo Отключение сбора данных ввода...

reg add "HKCU\Software\Microsoft\Input\TIPC" /v Enabled /t REG_DWORD /d 0 /f

:: === Удаление Microsoft Store ===
echo Удаление Microsoft Store...

powershell -Command "Get-AppxPackage *WindowsStore* | Remove-AppxPackage"
powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like '*WindowsStore*'} | Remove-AppxProvisionedPackage -Online"

:: === Отключение ненужных служб ===
echo Отключение ненужных служб...

setlocal

set services=^
 MapsBroker ^
 XblAuthManager ^
 WpcMonSvc ^
 XblGameSave ^
 XboxNetApiSvc ^
 RetailDemo ^
 RadioManagement ^
 TapiSrv ^
 Fax ^
 XboxGipSvc ^
 WbioSrvc ^
 dmwappushservice ^
 BDESVC ^
 PhoneSvc

for %%S in (%services%) do (
    echo Останавливаю %%S...
    sc stop %%S >nul 2>&1
    echo Отключаю %%S...
    sc config %%S start= disabled >nul 2>&1
)

echo.
echo Готово! Шпионство отключено, службы остановлены.

    4.3 Скачиваем xml файл и кидаем в наш файл iso который мы закинули в Ultra iso 
    и кидаем это в корень iso файла