@echo off
echo ========================================
echo My Diary App - Installation Script
echo ========================================
echo.

echo Checking if Docker is installed...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is not installed. Please install Docker Desktop first.
    echo Download from: https://www.docker.com/products/docker-desktop/
    echo.
    echo After installing Docker Desktop, run this script again.
    pause
    exit /b 1
)

echo Docker is installed!
echo.

echo Building and starting the application...
echo This may take a few minutes on first run...
echo.

docker-compose up --build -d

if %errorlevel% neq 0 (
    echo.
    echo Error: Failed to start the application.
    echo Please make sure Docker Desktop is running.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Your My Diary App is now running at:
echo http://localhost:3000
echo.
echo To stop the application, run: docker-compose down
echo To view logs, run: docker-compose logs -f
echo.
pause
