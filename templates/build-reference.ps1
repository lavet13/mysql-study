# templates/build_reference.ps1
# Run from PROJECT ROOT: .\templates\build_reference.ps1

$ErrorActionPreference = "Stop"

Write-Host "[1/2] Building node image..."
docker compose -f docker-compose.docs.yml build node

Write-Host "[2/2] Generating reference.docx..."
docker compose -f docker-compose.docs.yml run --rm node make_reference.js

Write-Host "Done: templates/reference.docx"
