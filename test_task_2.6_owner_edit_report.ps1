# Test Task 2.6: Owner Edit Caption + Report Endpoint Smoke Test
param(
    [string]$BASE_URL = "http://localhost:8000",
    [string]$EMAIL = "",
    [string]$PASSWORD = "",
    [string]$TOKEN = "",
    [string]$POST_UID = "",
    [switch]$AUTO_CREATE_POST = $true
)

$ErrorActionPreference = "Stop"

function Write-Step($text) {
    Write-Host "`n[$text]" -ForegroundColor Yellow
}

function Fail($text) {
    Write-Host "✗ $text" -ForegroundColor Red
    exit 1
}

function Ok($text) {
    Write-Host "✓ $text" -ForegroundColor Green
}

function Get-HttpStatusFromError($err) {
    try {
        return [int]$err.Exception.Response.StatusCode.value__
    } catch {
        return -1
    }
}

Write-Host "========== TEST TASK 2.6: OWNER EDIT + REPORT ==========" -ForegroundColor Cyan
Write-Host "Backend: $BASE_URL" -ForegroundColor Gray

if ([string]::IsNullOrWhiteSpace($TOKEN)) {
    if ([string]::IsNullOrWhiteSpace($EMAIL) -or [string]::IsNullOrWhiteSpace($PASSWORD)) {
        Write-Host "No TOKEN provided and EMAIL/PASSWORD missing. Creating a random user..." -ForegroundColor DarkYellow
        $rand = Get-Random -Minimum 1000 -Maximum 9999
        $EMAIL = "owneredit$rand@test.com"
        $PASSWORD = "Test123!"

        Write-Step "1 - Register random user"
        $registerBody = @{
            email = $EMAIL
            password = $PASSWORD
            username = "owneredit$rand"
            display_name = "Owner Edit Test"
        } | ConvertTo-Json

        try {
            $registerResp = Invoke-RestMethod -Uri "$BASE_URL/auth/register" -Method POST -ContentType "application/json" -Body $registerBody
            $TOKEN = $registerResp.access_token
            Ok "User registered and token received ($EMAIL)"
        } catch {
            Fail "Registration failed: $($_.Exception.Message)"
        }
    } else {
        Write-Step "1 - Login"
        $loginBody = @{
            email = $EMAIL
            password = $PASSWORD
        } | ConvertTo-Json

        try {
            $loginResp = Invoke-RestMethod -Uri "$BASE_URL/auth/login" -Method POST -ContentType "application/json" -Body $loginBody
            $TOKEN = $loginResp.access_token
            Ok "Login success"
        } catch {
            $code = Get-HttpStatusFromError $_
            Fail "Login failed (HTTP $code): $($_.Exception.Message)"
        }
    }
} else {
    Write-Step "1 - Using provided token"
    Ok "Token provided by caller"
}

$headers = @{ Authorization = "Bearer $TOKEN" }

if ([string]::IsNullOrWhiteSpace($POST_UID) -and $AUTO_CREATE_POST) {
    Write-Step "2 - Create test post"
    $postBody = @{
        type = "reel"
        mediaUrl = "https://example.com/test-video.mp4"
        caption = "Initial caption for owner edit smoke test"
    } | ConvertTo-Json

    try {
        $postResp = Invoke-RestMethod -Uri "$BASE_URL/posts/" -Method POST -Headers $headers -ContentType "application/json" -Body $postBody
        $POST_UID = $postResp.id
        Ok "Post created: $POST_UID"
    } catch {
        $code = Get-HttpStatusFromError $_
        Fail "Post creation failed (HTTP $code): $($_.Exception.Message)"
    }
}

if ([string]::IsNullOrWhiteSpace($POST_UID)) {
    Fail "POST_UID is required when AUTO_CREATE_POST is false"
}

Write-Step "3 - PATCH caption"
$newCaption = "Updated caption smoke test $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$patchBody = @{ caption = $newCaption } | ConvertTo-Json

try {
    $patchResp = Invoke-RestMethod -Uri "$BASE_URL/posts/$POST_UID" -Method PATCH -Headers $headers -ContentType "application/json" -Body $patchBody
    if ($patchResp.caption -ne $newCaption) {
        Fail "PATCH response caption mismatch. Expected '$newCaption', got '$($patchResp.caption)'"
    }
    Ok "PATCH accepted and caption updated"
} catch {
    $code = Get-HttpStatusFromError $_
    Fail "PATCH failed (HTTP $code): $($_.Exception.Message)"
}

Write-Step "4 - GET post verify caption"
try {
    $getResp = Invoke-RestMethod -Uri "$BASE_URL/posts/$POST_UID" -Method GET -Headers $headers
    if ($getResp.caption -ne $newCaption) {
        Fail "GET verification failed. Expected '$newCaption', got '$($getResp.caption)'"
    }
    Ok "Caption persisted"
} catch {
    $code = Get-HttpStatusFromError $_
    Fail "GET post failed (HTTP $code): $($_.Exception.Message)"
}

Write-Step "5 - POST report"
$reportBody = @{
    target_type = "post"
    target_id = $POST_UID
    reason = "spam"
    description = "Smoke test report for owner-edit flow"
} | ConvertTo-Json

try {
    $reportResp = Invoke-RestMethod -Uri "$BASE_URL/api/reports" -Method POST -Headers $headers -ContentType "application/json" -Body $reportBody
    $reportTargetId = if ($null -ne $reportResp.target_id) { $reportResp.target_id } else { $reportResp.targetId }
    if ($reportTargetId -ne $POST_UID) {
        Fail "Report response target_id mismatch"
    }
    Ok "Report submitted (id=$($reportResp.id), status=$($reportResp.status))"
} catch {
    $code = Get-HttpStatusFromError $_
    Fail "Report submission failed (HTTP $code): $($_.Exception.Message)"
}

Write-Host "`n========== TEST TASK 2.6 PASSED ==========" -ForegroundColor Green
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  ✓ Caption patch endpoint works" -ForegroundColor Green
Write-Host "  ✓ Caption persistence verified" -ForegroundColor Green
Write-Host "  ✓ Report endpoint works" -ForegroundColor Green
Write-Host "  ✓ Owner edit + report smoke flow validated" -ForegroundColor Green
