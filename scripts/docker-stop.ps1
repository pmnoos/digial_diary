param(
    [switch]$WithVolumes
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Docker() {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Error "Docker CLI not found. Please install/open Docker Desktop."
    }
}

Ensure-Docker

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Push-Location $RepoRoot
try {
    if ($WithVolumes.IsPresent) {
        Write-Host "Stopping containers and removing volumes..." -ForegroundColor Yellow
        docker compose down -v
    } else {
        Write-Host "Stopping containers (volumes preserved)..." -ForegroundColor Yellow
        docker compose down
    }
    Write-Host "Stopped." -ForegroundColor Green
}
finally {
    Pop-Location
}
