# My Diary App - Installation Guide

This guide will help you install and run the My Diary App on your local machine.

## Prerequisites

Before installing the app, you need to have Docker Desktop installed on your system:

### Windows
1. Download Docker Desktop from: https://www.docker.com/products/docker-desktop/
2. Install Docker Desktop
3. Start Docker Desktop
4. Ensure Docker is running (you should see the Docker icon in your system tray)

### macOS
1. Download Docker Desktop from: https://www.docker.com/products/docker-desktop/
2. Install Docker Desktop
3. Start Docker Desktop

### Linux
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

## Quick Installation (Windows)

1. Download all the files from this distribution
2. Double-click `install.bat`
3. Follow the prompts
4. Open your browser and go to: http://localhost:3000

## Manual Installation

### Step 1: Extract Files
Extract all the application files to a folder on your computer.

### Step 2: Open Terminal/Command Prompt
Navigate to the folder containing the application files.

### Step 3: Build and Start
Run the following command:
```bash
docker-compose up --build -d
```

### Step 4: Access the Application
Open your web browser and navigate to: http://localhost:3000

## Managing the Application

### Start the Application
```bash
docker-compose up -d
```

### Stop the Application
```bash
docker-compose down
```

### View Logs
```bash
docker-compose logs -f
```

### Restart the Application
```bash
docker-compose restart
```

### Update the Application
```bash
docker-compose down
docker-compose up --build -d
```

## Data Persistence

Your diary entries and user data are stored in Docker volumes, which means:
- Data persists between application restarts
- Data is stored locally on your machine
- Data is not lost when you stop the application

## Troubleshooting

### Port Already in Use
If you get an error about port 3000 being in use:
1. Stop the application: `docker-compose down`
2. Edit `docker-compose.yml` and change the port mapping from `"3000:80"` to `"3001:80"`
3. Restart: `docker-compose up -d`
4. Access at: http://localhost:3001

### Database Connection Issues
If the application fails to start due to database issues:
1. Stop the application: `docker-compose down`
2. Remove volumes: `docker-compose down -v`
3. Restart: `docker-compose up --build -d`

### Docker Not Running
Make sure Docker Desktop is running before starting the application.

## System Requirements

- **Operating System**: Windows 10/11, macOS 10.15+, or Linux
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: At least 2GB free space
- **Docker**: Docker Desktop or Docker Engine

## Security Notes

- The application runs locally on your machine
- Data is stored in local Docker volumes
- No data is sent to external servers
- Default database credentials are used for local development only

## Support

If you encounter any issues:
1. Check that Docker Desktop is running
2. Ensure you have sufficient disk space
3. Try restarting the application
4. Check the logs using `docker-compose logs -f`

For additional help, please refer to the application documentation or contact support.
