param(
    [switch]$Build,
    [switch]$Logs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Docker() {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Error "Docker CLI not found. Please install/open Docker Desktop."
    }
}

Ensure-Docker

# Resolve repo root (this script lives in ./scripts)
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Push-Location $RepoRoot
try {
    if ($Build.IsPresent) {
        Write-Host "Building images..." -ForegroundColor Cyan
        docker compose build
    }

    Write-Host "Starting containers..." -ForegroundColor Cyan
    docker compose up -d

    if ($Logs.IsPresent) {
        Write-Host "Tailing web logs (Ctrl+C to stop)..." -ForegroundColor Cyan
        docker compose logs -f web
    } else {
        Write-Host "Done. Visit http://localhost:3000" -ForegroundColor Green
    }
}
finally {
    Pop-Location
}
