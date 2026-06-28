# release.ps1
# Interactive PowerShell script to automate version bumping, tagging, and pushing releases.

# Ensure git working tree is clean
$status = git status --porcelain
if ($status) {
    Write-Host "⚠️ Warning: Your git working directory is not clean. Committing or stashing is recommended." -ForegroundColor Yellow
    $confirm = Read-Host "Do you want to proceed anyway? (y/N)"
    if ($confirm -ne 'y' -and $confirm -ne 'yes') {
        Write-Host "Release cancelled." -ForegroundColor Red
        exit 1
    }
}

# Load pubspec.yaml
$pubspecPath = "pubspec.yaml"
if (-not (Test-Path $pubspecPath)) {
    Write-Host "❌ Error: pubspec.yaml not found in current directory." -ForegroundColor Red
    exit 1
}

$content = Get-Content $pubspecPath -Raw
if ($content -match 'version:\s*([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)') {
    $major = [int]$Matches[1]
    $minor = [int]$Matches[2]
    $patch = [int]$Matches[3]
    $build = [int]$Matches[4]
} else {
    Write-Host "❌ Error: Could not parse version from pubspec.yaml." -ForegroundColor Red
    exit 1
}

$currentVersion = "$major.$minor.$patch+$build"
Write-Host "Current version is: " -NoNewline
Write-Host $currentVersion -ForegroundColor Green

# Calculate standard bump choices
$nextBuild = $build + 1
$patchVersion = "$major.$minor.$($patch + 1)+$nextBuild"
$minorVersion = "$major.$($minor + 1).0+$nextBuild"
$majorVersion = "$($major + 1).0.0+$nextBuild"

Write-Host "`nSelect version bump type:"
Write-Host "1) Patch: $patchVersion"
Write-Host "2) Minor: $minorVersion"
Write-Host "3) Major: $majorVersion"
Write-Host "4) Custom Version"
Write-Host "5) Cancel"

$choice = Read-Host "Enter option (1-5)"

switch ($choice) {
    "1" { $newVersion = $patchVersion }
    "2" { $newVersion = $minorVersion }
    "3" { $newVersion = $majorVersion }
    "4" { 
        $newVersion = Read-Host "Enter custom version (e.g. 1.0.2+3)"
        if ($newVersion -notmatch '^[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+$') {
            Write-Host "❌ Error: Invalid version format. Must be major.minor.patch+build" -ForegroundColor Red
            exit 1
        }
    }
    default {
        Write-Host "Release cancelled." -ForegroundColor Red
        exit 1
    }
}

Write-Host "`nUpdating version to $newVersion in pubspec.yaml..." -ForegroundColor Cyan
$newContent = $content -replace 'version:\s*[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+', "version: $newVersion"
Set-Content -Path $pubspecPath -Value $newContent -Encoding UTF8

Write-Host "Staging pubspec.yaml and creating commit..." -ForegroundColor Cyan
git add pubspec.yaml
git commit -m "chore: bump version to v$newVersion"

$tagVersion = "v" + ($newVersion -replace '\+.*$', '') # tag as vX.Y.Z (ignoring +build for git tag name standard)
Write-Host "Creating Git tag $tagVersion..." -ForegroundColor Cyan
git tag -a $tagVersion -m "Release $tagVersion"

Write-Host "`nVersion bumped and tagged successfully locally!" -ForegroundColor Green
$pushChoice = Read-Host "Do you want to push this release and tags to GitHub now? (y/N)"

if ($pushChoice -eq 'y' -or $pushChoice -eq 'yes') {
    Write-Host "Pushing main branch..." -ForegroundColor Cyan
    git push origin main
    Write-Host "Pushing tags..." -ForegroundColor Cyan
    git push origin --tags
    Write-Host "🎉 Successfully pushed release to GitHub! This will trigger the Release workflow." -ForegroundColor Green
} else {
    Write-Host "Done locally. Remember to run 'git push origin main --tags' when ready." -ForegroundColor Yellow
}
