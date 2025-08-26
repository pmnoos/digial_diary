# My Diary App - Windows Installer Creator
# This creates a more traditional Windows installer experience

param(
    [string]$OutputPath = "MyDiaryApp-Installer",
    [switch]$CreateNSIS
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "My Diary App - Windows Installer Creator" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create output directory
if (Test-Path $OutputPath) {
    Remove-Item $OutputPath -Recurse -Force
}
New-Item -ItemType Directory -Path $OutputPath | Out-Null

Write-Host "Creating Windows-style installer package..." -ForegroundColor Yellow

# Create a Windows application launcher
$launcherContent = @'
@echo off
title My Diary App
color 0A

echo ========================================
echo    My Diary App - Starting...
echo ========================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker Desktop is not installed!
    echo.
    echo Please install Docker Desktop first:
    echo https://www.docker.com/products/docker-desktop/
    echo.
    echo After installation, run this launcher again.
    echo.
    pause
    exit /b 1
)

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker Desktop is not running!
    echo.
    echo Please start Docker Desktop and try again.
    echo.
    pause
    exit /b 1
)

echo Docker is ready. Starting My Diary App...
echo.

REM Start the application
docker-compose up --build -d

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Failed to start the application.
    echo Please check the logs or ensure Docker is running.
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo    My Diary App is now running!
echo ========================================
echo.
echo Opening your browser...
echo.
echo If the browser doesn't open automatically,
echo go to: http://localhost:3000
echo.
echo To stop the application, close this window
echo and run the "Stop My Diary App" shortcut.
echo.

REM Wait a moment for the app to fully start
timeout /t 5 /nobreak >nul

REM Open browser
start http://localhost:3000

echo Application is running. Press any key to stop...
pause >nul

REM Stop the application
echo.
echo Stopping My Diary App...
docker-compose down
echo Application stopped.
echo.
pause
'@

Set-Content -Path "$OutputPath\MyDiaryApp.bat" -Value $launcherContent -Encoding ASCII
Write-Host "✓ Created: MyDiaryApp.bat" -ForegroundColor Green

# Create a stop script
$stopContent = @'
@echo off
title Stop My Diary App
color 0C

echo ========================================
echo    Stopping My Diary App...
echo ========================================
echo.

docker-compose down

echo.
echo My Diary App has been stopped.
echo.
pause
'@

Set-Content -Path "$OutputPath\StopMyDiaryApp.bat" -Value $stopContent -Encoding ASCII
Write-Host "✓ Created: StopMyDiaryApp.bat" -ForegroundColor Green

# Create a desktop shortcut creator
$shortcutCreator = @'
@echo off
echo Creating desktop shortcuts...

REM Create desktop shortcut for My Diary App
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\My Diary App.lnk'); $Shortcut.TargetPath = '%~dp0MyDiaryApp.bat'; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.IconLocation = '%~dp0icon.ico'; $Shortcut.Save()"

REM Create desktop shortcut for Stop My Diary App
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\Stop My Diary App.lnk'); $Shortcut.TargetPath = '%~dp0StopMyDiaryApp.bat'; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.IconLocation = '%~dp0icon.ico'; $Shortcut.Save()"

echo Desktop shortcuts created successfully!
echo.
pause
'@

Set-Content -Path "$OutputPath\CreateShortcuts.bat" -Value $shortcutCreator -Encoding ASCII
Write-Host "✓ Created: CreateShortcuts.bat" -ForegroundColor Green

# Create an uninstaller
$uninstaller = @'
@echo off
title Uninstall My Diary App
color 0C

echo ========================================
echo    Uninstalling My Diary App...
echo ========================================
echo.

echo This will:
echo 1. Stop the application
echo 2. Remove all data (diary entries will be lost)
echo 3. Remove desktop shortcuts
echo.

set /p confirm="Are you sure you want to continue? (y/N): "
if /i not "%confirm%"=="y" (
    echo Uninstallation cancelled.
    pause
    exit /b 0
)

echo.
echo Stopping application...
docker-compose down -v

echo.
echo Removing desktop shortcuts...
del "%USERPROFILE%\Desktop\My Diary App.lnk" 2>nul
del "%USERPROFILE%\Desktop\Stop My Diary App.lnk" 2>nul

echo.
echo ========================================
echo    Uninstallation Complete!
echo ========================================
echo.
echo My Diary App has been removed.
echo Note: Docker Desktop is still installed.
echo.
pause
'@

Set-Content -Path "$OutputPath\Uninstall.bat" -Value $uninstaller -Encoding ASCII
Write-Host "✓ Created: Uninstall.bat" -ForegroundColor Green

# Copy essential files
$essentialFiles = @(
    "docker-compose.yml",
    "Dockerfile",
    ".dockerignore"
)

foreach ($file in $essentialFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $OutputPath
        Write-Host "✓ Copied: $file" -ForegroundColor Green
    }
}

# Create a README
$readme = "# My Diary App - Windows Installation`n`n"
$readme += "## Quick Start`n`n"
$readme += "1. Install Docker Desktop`n"
$readme += "   - Download from: https://www.docker.com/products/docker-desktop/`n"
$readme += "   - Install and start Docker Desktop`n`n"
$readme += "2. Run the Application`n"
$readme += "   - Double-click MyDiaryApp.bat`n"
$readme += "   - OR run CreateShortcuts.bat to create desktop shortcuts`n`n"
$readme += "3. Access the App`n"
$readme += "   - The app will automatically open in your browser`n"
$readme += "   - Or go to: http://localhost:3000`n`n"
$readme += "## Managing the Application`n`n"
$readme += "- Start: Double-click My Diary App shortcut or MyDiaryApp.bat`n"
$readme += "- Stop: Double-click Stop My Diary App shortcut or StopMyDiaryApp.bat`n"
$readme += "- Uninstall: Run Uninstall.bat`n`n"
$readme += "## System Requirements`n`n"
$readme += "- Windows 10/11`n"
$readme += "- Docker Desktop`n"
$readme += "- 4GB RAM minimum - 8GB recommended`n"
$readme += "- 2GB free disk space`n`n"
$readme += "## Troubleshooting`n`n"
$readme += "- Ensure Docker Desktop is running`n"
$readme += "- Check available disk space`n"
$readme += "- If the app will not start, try running StopMyDiaryApp.bat first`n`n"
$readme += "## Data Storage`n`n"
$readme += "Your diary entries are stored locally and will persist between application restarts."

Set-Content -Path "$OutputPath\README.txt" -Value $readme -Encoding ASCII
Write-Host "✓ Created: README.txt" -ForegroundColor Green

# Create a simple icon (placeholder)
$iconContent = "This is a placeholder for an icon file. Replace with actual .ico file."
Set-Content -Path "$OutputPath\icon.ico" -Value $iconContent
Write-Host "✓ Created: icon.ico (placeholder)" -ForegroundColor Green

# Create a zip file
$zipPath = "$OutputPath.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Write-Host ""
Write-Host "Creating installer package..." -ForegroundColor Yellow
Compress-Archive -Path $OutputPath -DestinationPath $zipPath

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Windows Installer Package Created!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Package location: $zipPath" -ForegroundColor Cyan
Write-Host "Unpacked location: $OutputPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "This creates a more traditional Windows experience:" -ForegroundColor Yellow
Write-Host "✓ Desktop shortcuts" -ForegroundColor White
Write-Host "✓ Easy start/stop buttons" -ForegroundColor White
Write-Host "✓ Uninstaller" -ForegroundColor White
Write-Host "✓ Automatic browser opening" -ForegroundColor White
Write-Host ""
Write-Host "Note: Users still need Docker Desktop installed." -ForegroundColor Yellow
$sizeKB = [math]::Round((Get-Item $zipPath).Length / 1KB, 1)
Write-Host "Package size: $sizeKB KB" -ForegroundColor Gray
