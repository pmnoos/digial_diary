# My Diary App - Distribution Package Creator
param(
    [string]$OutputPath = "MyDiaryApp-Distribution",
    [switch]$IncludeSource
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "My Diary App - Distribution Creator" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create output directory
if (Test-Path $OutputPath) {
    $response = Read-Host "Directory '$OutputPath' already exists. Overwrite? (y/n)"
    if ($response -ne "y" -and $response -ne "Y") {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        exit 0
    }
    Remove-Item $OutputPath -Recurse -Force
}

New-Item -ItemType Directory -Path $OutputPath | Out-Null
Write-Host "✓ Created output directory: $OutputPath" -ForegroundColor Green

# Files to include in distribution
$distributionFiles = @(
    "docker-compose.yml",
    "Dockerfile",
    "install.bat",
    "install.ps1",
    "install.sh",
    "INSTALLATION.md",
    "README.md",
    ".dockerignore"
)

# Copy distribution files
foreach ($file in $distributionFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $OutputPath
        Write-Host "✓ Copied: $file" -ForegroundColor Green
    } else {
        Write-Host "⚠ Warning: $file not found" -ForegroundColor Yellow
    }
}

# Copy application source if requested
if ($IncludeSource) {
    Write-Host ""
    Write-Host "Copying application source code..." -ForegroundColor Yellow
    
    $sourceDirs = @(
        "app",
        "config",
        "db",
        "lib",
        "public",
        "bin"
    )
    
    foreach ($dir in $sourceDirs) {
        if (Test-Path $dir) {
            Copy-Item $dir -Destination $OutputPath -Recurse
            Write-Host "✓ Copied: $dir/" -ForegroundColor Green
        }
    }
    
    # Copy essential files
    $sourceFiles = @(
        "Gemfile",
        "Gemfile.lock",
        "config.ru",
        "Rakefile",
        ".ruby-version"
    )
    
    foreach ($file in $sourceFiles) {
        if (Test-Path $file) {
            Copy-Item $file -Destination $OutputPath
            Write-Host "✓ Copied: $file" -ForegroundColor Green
        }
    }
}

# Create a simple launcher script
$launcherContent = "@echo off`n"
$launcherContent += "echo ========================================`n"
$launcherContent += "echo My Diary App - Quick Launcher`n"
$launcherContent += "echo ========================================`n"
$launcherContent += "echo.`n"
$launcherContent += "echo Starting My Diary App...`n"
$launcherContent += "echo.`n"
$launcherContent += "echo If this is your first time running the app,`n"
$launcherContent += "echo it may take a few minutes to download and build.`n"
$launcherContent += "echo.`n"
$launcherContent += "echo The app will be available at: http://localhost:3000`n"
$launcherContent += "echo.`n"
$launcherContent += "echo Press Ctrl+C to stop the application.`n"
$launcherContent += "echo.`n"
$launcherContent += "docker-compose up"

Set-Content -Path "$OutputPath\launch.bat" -Value $launcherContent
Write-Host "✓ Created: launch.bat" -ForegroundColor Green

# Create a stop script
$stopContent = "@echo off`n"
$stopContent += "echo Stopping My Diary App...`n"
$stopContent += "docker-compose down`n"
$stopContent += "echo Application stopped.`n"
$stopContent += "pause"

Set-Content -Path "$OutputPath\stop.bat" -Value $stopContent
Write-Host "✓ Created: stop.bat" -ForegroundColor Green

# Create a README for the distribution
$distReadme = "# My Diary App - Distribution Package`n`n"
$distReadme += "This package contains everything needed to run the My Diary App on your local machine.`n`n"
$distReadme += "## Quick Start (Windows)`n`n"
$distReadme += "1. **Install Docker Desktop**`n"
$distReadme += "   - Download from: https://www.docker.com/products/docker-desktop/`n"
$distReadme += "   - Install and start Docker Desktop`n`n"
$distReadme += "2. **Run the Application**`n"
$distReadme += "   - Double-click `install.bat` OR`n"
$distReadme += "   - Double-click `launch.bat``n`n"
$distReadme += "3. **Access the App**`n"
$distReadme += "   - Open your browser`n"
$distReadme += "   - Go to: http://localhost:3000`n`n"
$distReadme += "## Alternative Installation Methods`n`n"
$distReadme += "### PowerShell (Windows)`n"
$distReadme += "```powershell`n"
$distReadme += ".\install.ps1`n"
$distReadme += "````n`n"
$distReadme += "### Command Line (Linux/macOS)`n"
$distReadme += "```bash`n"
$distReadme += "chmod +x install.sh`n"
$distReadme += "./install.sh`n"
$distReadme += "````n`n"
$distReadme += "### Manual Installation`n"
$distReadme += "```bash`n"
$distReadme += "docker-compose up --build -d`n"
$distReadme += "````n`n"
$distReadme += "## Managing the Application`n`n"
$distReadme += "- **Start**: `launch.bat` or `docker-compose up``n"
$distReadme += "- **Stop**: `stop.bat` or `docker-compose down``n"
$distReadme += "- **View Logs**: `docker-compose logs -f``n"
$distReadme += "- **Restart**: `docker-compose restart``n`n"
$distReadme += "## System Requirements`n`n"
$distReadme += "- Windows 10/11, macOS 10.15+, or Linux`n"
$distReadme += "- Docker Desktop or Docker Engine`n"
$distReadme += "- 4GB RAM minimum (8GB recommended)`n"
$distReadme += "- 2GB free disk space`n`n"
$distReadme += "## Troubleshooting`n`n"
$distReadme += "See `INSTALLATION.md` for detailed troubleshooting information.`n`n"
$distReadme += "## Support`n`n"
$distReadme += "If you encounter issues:`n"
$distReadme += "1. Ensure Docker Desktop is running`n"
$distReadme += "2. Check available disk space`n"
$distReadme += "3. Try restarting the application`n"
$distReadme += "4. Check logs using `docker-compose logs``n`n"
$distReadme += "## Data Storage`n`n"
$distReadme += "Your diary entries are stored locally in Docker volumes and will persist between application restarts."

Set-Content -Path "$OutputPath\README-DISTRIBUTION.md" -Value $distReadme
Write-Host "✓ Created: README-DISTRIBUTION.md" -ForegroundColor Green

# Create a zip file
$zipPath = "$OutputPath.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Write-Host ""
Write-Host "Creating distribution package..." -ForegroundColor Yellow
Compress-Archive -Path $OutputPath -DestinationPath $zipPath

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Distribution Package Created!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Package location: $zipPath" -ForegroundColor Cyan
Write-Host "Unpacked location: $OutputPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "To distribute your app:" -ForegroundColor Yellow
Write-Host "1. Share the zip file with users" -ForegroundColor White
Write-Host "2. Users extract the zip file" -ForegroundColor White
Write-Host "3. Users run install.bat (Windows) or install.sh (Linux/macOS)" -ForegroundColor White
Write-Host ""
Write-Host "Package size: $((Get-Item $zipPath).Length / 1MB) MB" -ForegroundColor Gray
