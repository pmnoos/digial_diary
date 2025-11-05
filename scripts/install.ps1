# My Diary App - PowerShell Installation Script
param(
    [switch]$SkipDockerCheck,
    [switch]$Force,
    [string]$Port = "3000"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "My Diary App - Installation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed
if (-not $SkipDockerCheck) {
    Write-Host "Checking if Docker is installed..." -ForegroundColor Yellow
    try {
        $dockerVersion = docker --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Docker is installed: $dockerVersion" -ForegroundColor Green
        } else {
            throw "Docker not found"
        }
    } catch {
        Write-Host "✗ Docker is not installed or not running." -ForegroundColor Red
        Write-Host ""
        Write-Host "Please install Docker Desktop first:" -ForegroundColor Yellow
        Write-Host "Download from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Blue
        Write-Host ""
        Write-Host "After installing Docker Desktop, run this script again." -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# Check if Docker is running
Write-Host "Checking if Docker is running..." -ForegroundColor Yellow
try {
    docker info >$null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Docker is running" -ForegroundColor Green
    } else {
        throw "Docker not running"
    }
} catch {
    Write-Host "✗ Docker is not running." -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if docker-compose.yml exists
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "✗ docker-compose.yml not found in current directory." -ForegroundColor Red
    Write-Host "Please run this script from the directory containing the application files." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Update port in docker-compose.yml if specified
if ($Port -ne "3000") {
    Write-Host "Updating port to $Port..." -ForegroundColor Yellow
    $content = Get-Content "docker-compose.yml" -Raw
    $content = $content -replace '"3000:80"', "`"$Port`:80`""
    Set-Content "docker-compose.yml" $content
    Write-Host "✓ Port updated to $Port" -ForegroundColor Green
}

# Stop existing containers if force flag is used
if ($Force) {
    Write-Host "Stopping existing containers..." -ForegroundColor Yellow
    docker-compose down 2>$null
    Write-Host "✓ Existing containers stopped" -ForegroundColor Green
}

# Build and start the application
Write-Host ""
Write-Host "Building and starting the application..." -ForegroundColor Yellow
Write-Host "This may take a few minutes on first run..." -ForegroundColor Gray
Write-Host ""

try {
    docker-compose up --build -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "Installation Complete!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your My Diary App is now running at:" -ForegroundColor White
        Write-Host "http://localhost:$Port" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Useful commands:" -ForegroundColor Yellow
        Write-Host "  Stop app:     docker-compose down" -ForegroundColor Gray
        Write-Host "  View logs:    docker-compose logs -f" -ForegroundColor Gray
        Write-Host "  Restart app:  docker-compose restart" -ForegroundColor Gray
        Write-Host "  Update app:   docker-compose down && docker-compose up --build -d" -ForegroundColor Gray
        Write-Host ""
        
        # Open browser
        $openBrowser = Read-Host "Would you like to open the application in your browser? (y/n)"
        if ($openBrowser -eq "y" -or $openBrowser -eq "Y") {
            Start-Process "http://localhost:$Port"
        }
    } else {
        throw "Failed to start application"
    }
} catch {
    Write-Host ""
    Write-Host "✗ Error: Failed to start the application." -ForegroundColor Red
    Write-Host "Please check the logs using: docker-compose logs" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  - Port $Port is already in use" -ForegroundColor Gray
    Write-Host "  - Insufficient disk space" -ForegroundColor Gray
    Write-Host "  - Docker Desktop not running" -ForegroundColor Gray
    Read-Host "Press Enter to exit"
    exit 1
}

Read-Host "Press Enter to exit"
