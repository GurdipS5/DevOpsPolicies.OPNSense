#!/usr/bin/env pwsh

# TeamCity Build Script for OPNSense Conftest Policies
# This script demonstrates how to integrate nbgv versioning and changelog automation

param(
    [string]$Target = "CI",
    [string]$Configuration = "Release",
    [switch]$UpdateChangelog = $false
)

# Set error handling
$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting TeamCity Build Pipeline" -ForegroundColor Green
Write-Host "Target: $Target" -ForegroundColor Cyan
Write-Host "Configuration: $Configuration" -ForegroundColor Cyan

# Get TeamCity environment variables
$branchName = $env:BUILD_VCS_BRANCH ?? $env:BRANCH_NAME ?? "unknown"
$buildNumber = $env:BUILD_NUMBER ?? "0"
$commitMessage = $env:BUILD_VCS_COMMIT_MESSAGE ?? ""
$isMainBranch = ($branchName -eq "main") -or ($branchName -eq "master") -or ($branchName -like "*/main") -or ($branchName -like "*/master")

Write-Host "Branch: $branchName" -ForegroundColor Yellow
Write-Host "Build Number: $buildNumber" -ForegroundColor Yellow
Write-Host "Is Main Branch: $isMainBranch" -ForegroundColor Yellow

# Install/Update nbgv if needed
Write-Host "📦 Checking nbgv installation..." -ForegroundColor Blue
try {
    $nbgvVersion = & nbgv --version 2>$null
    Write-Host "✅ nbgv is available: $nbgvVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Installing nbgv..." -ForegroundColor Yellow
    & dotnet tool install -g nbgv
}

# Get version information from nbgv
Write-Host "📋 Getting version information..." -ForegroundColor Blue
try {
    $versionJson = & nbgv get-version --format json | ConvertFrom-Json
    $version = $versionJson.NuGetPackageVersion ?? $versionJson.SemVer2
    $majorMinor = "$($versionJson.MajorMinorVersion)"
    $buildHeight = $versionJson.BuildNumber
    
    Write-Host "Version: $version" -ForegroundColor Green
    Write-Host "Major.Minor: $majorMinor" -ForegroundColor Green
    Write-Host "Build Height: $buildHeight" -ForegroundColor Green
    
    # Set TeamCity build number
    if ($env:TEAMCITY_VERSION) {
        Write-Host "##teamcity[buildNumber '$version']"
        Write-Host "##teamcity[setParameter name='env.BUILD_VERSION' value='$version']"
        Write-Host "##teamcity[setParameter name='env.MAJOR_MINOR_VERSION' value='$majorMinor']"
    }
} catch {
    Write-Host "❌ Failed to get version from nbgv: $_" -ForegroundColor Red
    $version = "1.0.0-dev.$buildNumber"
    Write-Host "Using fallback version: $version" -ForegroundColor Yellow
}

# Prepare build arguments
$buildArgs = @(
    "--target", $Target
    "--configuration", $Configuration
    "--version", $version
    "--branch-name", $branchName
)

# Add commit message for changelog updates on main/master branches
if ($isMainBranch -and $commitMessage -and $UpdateChangelog) {
    $buildArgs += "--commit-message", $commitMessage
    Write-Host "📝 Changelog will be updated with commit: $commitMessage" -ForegroundColor Blue
}

# Add TeamCity-specific parameters
if ($env:HARBOR_REGISTRY) {
    $buildArgs += "--harbor-registry", $env:HARBOR_REGISTRY
}
if ($env:HARBOR_PROJECT) {
    $buildArgs += "--harbor-project", $env:HARBOR_PROJECT
}
if ($env:HARBOR_USERNAME) {
    $buildArgs += "--harbor-username", $env:HARBOR_USERNAME
}
if ($env:HARBOR_PASSWORD) {
    $buildArgs += "--harbor-password", $env:HARBOR_PASSWORD
}

# Execute the build
Write-Host "🔨 Executing build with arguments: $($buildArgs -join ' ')" -ForegroundColor Blue

try {
    if ($isMainBranch -and $UpdateChangelog) {
        # For main/master branches, run with changelog update
        & ./build.ps1 @buildArgs --target "CommitAndPushChanges"
    } else {
        # For other branches, run normal build
        & ./build.ps1 @buildArgs
    }
    
    Write-Host "✅ Build completed successfully!" -ForegroundColor Green
    
    # Publish artifacts information to TeamCity
    if ($env:TEAMCITY_VERSION) {
        $artifactsPath = Join-Path $PWD "artifacts"
        if (Test-Path $artifactsPath) {
            Get-ChildItem $artifactsPath -File | ForEach-Object {
                Write-Host "##teamcity[publishArtifacts '$($_.FullName)']"
            }
        }
    }
    
} catch {
    Write-Host "❌ Build failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 TeamCity Build Pipeline Completed!" -ForegroundColor Green