#!/bin/bash

# My Diary App - Installation Script for Linux/macOS

echo "========================================"
echo "My Diary App - Installation Script"
echo "========================================"
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if Docker is installed
echo "Checking if Docker is installed..."
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed."
    echo
    print_info "Please install Docker first:"
    echo "  Ubuntu/Debian: sudo apt-get install docker.io docker-compose"
    echo "  macOS: Download Docker Desktop from https://www.docker.com/products/docker-desktop/"
    echo "  CentOS/RHEL: sudo yum install docker docker-compose"
    echo
    echo "After installing Docker, run this script again."
    exit 1
fi

print_status "Docker is installed: $(docker --version)"

# Check if Docker is running
echo "Checking if Docker is running..."
if ! docker info &> /dev/null; then
    print_error "Docker is not running."
    echo
    print_info "Please start Docker and try again:"
    echo "  Linux: sudo systemctl start docker"
    echo "  macOS: Start Docker Desktop application"
    exit 1
fi

print_status "Docker is running"

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    print_error "docker-compose.yml not found in current directory."
    echo "Please run this script from the directory containing the application files."
    exit 1
fi

# Check if user is in docker group (Linux only)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! groups $USER | grep -q docker; then
        print_warning "You are not in the docker group. You may need to run commands with sudo."
        echo "To add yourself to the docker group, run: sudo usermod -aG docker $USER"
        echo "Then log out and log back in."
        echo
    fi
fi

# Build and start the application
echo
echo "Building and starting the application..."
echo "This may take a few minutes on first run..."
echo

if docker-compose up --build -d; then
    echo
    echo "========================================"
    print_status "Installation Complete!"
    echo "========================================"
    echo
    echo "Your My Diary App is now running at:"
    echo -e "${BLUE}http://localhost:3000${NC}"
    echo
    echo "Useful commands:"
    echo "  Stop app:     docker-compose down"
    echo "  View logs:    docker-compose logs -f"
    echo "  Restart app:  docker-compose restart"
    echo "  Update app:   docker-compose down && docker-compose up --build -d"
    echo
    
    # Ask if user wants to open browser
    read -p "Would you like to open the application in your browser? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open http://localhost:3000
        elif command -v open &> /dev/null; then
            open http://localhost:3000
        else
            print_info "Please open your browser and navigate to: http://localhost:3000"
        fi
    fi
else
    echo
    print_error "Failed to start the application."
    echo
    print_info "Please check the logs using: docker-compose logs"
    echo
    echo "Common issues:"
    echo "  - Port 3000 is already in use"
    echo "  - Insufficient disk space"
    echo "  - Docker not running"
    exit 1
fi

echo
echo "Press Enter to exit..."
read
