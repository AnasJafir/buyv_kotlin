param(
    [switch]$SkipBackendSmoke
)

$ErrorActionPreference = 'Stop'

function Write-Step([string]$Message) {
    Write-Host "`n[$Message]" -ForegroundColor Yellow
}

function Ok([string]$Message) {
    Write-Host "✓ $Message" -ForegroundColor Green
}

$repoRoot = $PSScriptRoot
$flutterDir = Join-Path $repoRoot 'buyv_flutter'
$task26Script = Join-Path $repoRoot 'test_task_2.6_owner_edit_report.ps1'

if (-not (Test-Path $flutterDir)) {
    throw "Flutter directory not found: $flutterDir"
}

if (-not (Test-Path $task26Script) -and -not $SkipBackendSmoke) {
    throw "Task 2.6 script not found: $task26Script"
}

Write-Host '========== BUYV QUALITY GATE ==========' -ForegroundColor Cyan
Write-Host "Repo: $repoRoot" -ForegroundColor Gray

Push-Location $flutterDir
try {
    Write-Step '1 - Flutter analyze'
    flutter analyze
    if ($LASTEXITCODE -ne 0) { throw 'flutter analyze failed' }
    Ok 'Analyzer passed'

    Write-Step '2 - Flutter tests'
    flutter test
    if ($LASTEXITCODE -ne 0) { throw 'flutter test failed' }
    Ok 'Flutter tests passed'
}
finally {
    Pop-Location
}

if (-not $SkipBackendSmoke) {
    Write-Step '3 - Backend smoke test Task 2.6'
    & $task26Script
    if ($LASTEXITCODE -ne 0) { throw 'Task 2.6 smoke test failed' }
    Ok 'Task 2.6 passed'
} else {
    Write-Step '3 - Backend smoke skipped'
    Ok 'SkipBackendSmoke enabled'
}

Write-Host "`n========== QUALITY GATE PASSED ==========" -ForegroundColor Green
