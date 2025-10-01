#!/usr/bin/env pwsh
# Sports Assessment App - Auto Deploy & Run Script
# This script automatically deploys Convex and runs your Flutter app

Write-Host "🚀 Starting Sports Assessment App with Auto-Deploy..." -ForegroundColor Green

# Function to check if Convex is deployed
function Test-ConvexDeployment {
    try {
        $result = npx convex export --format json 2>$null
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

# Function to deploy Convex
function Deploy-Convex {
    Write-Host "📦 Deploying Convex backend..." -ForegroundColor Yellow
    npm run deploy
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Convex deployed successfully!" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ Convex deployment failed!" -ForegroundColor Red
        return $false
    }
}

# Function to run Flutter app
function Start-FlutterApp {
    Write-Host "📱 Starting Flutter app..." -ForegroundColor Blue
    flutter run
}

# Main execution
try {
    # Check if we're in the right directory
    if (!(Test-Path "pubspec.yaml")) {
        Write-Host "❌ Error: Not in Flutter project directory!" -ForegroundColor Red
        Write-Host "Please run this script from your Flutter project root." -ForegroundColor Yellow
        exit 1
    }

    # Check if Convex needs deployment
    Write-Host "🔍 Checking Convex deployment status..." -ForegroundColor Cyan
    
    # Always deploy for fresh state (you can modify this logic)
    $deployed = Deploy-Convex
    
    if ($deployed) {
        # Small delay to ensure deployment is complete
        Start-Sleep -Seconds 2
        
        # Run Flutter app
        Start-FlutterApp
    } else {
        Write-Host "❌ Cannot start app due to Convex deployment failure." -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "❌ An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}