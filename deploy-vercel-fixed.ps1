# Quick Vercel Deployment (PowerShell)
# Deploys the submission page to Vercel

Write-Host ""
Write-Host "========================================"
Write-Host "   Vita Sports - Vercel Deployment"
Write-Host "========================================"
Write-Host ""

# Check if Vercel CLI is installed
$vercelExists = Get-Command vercel -ErrorAction SilentlyContinue
if (-not $vercelExists) {
    Write-Host "[ERROR] Vercel CLI not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Installing Vercel CLI globally..." -ForegroundColor Yellow
    
    npm install -g vercel
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "[ERROR] Failed to install Vercel CLI" -ForegroundColor Red
        Write-Host "Please run manually: npm install -g vercel"
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Write-Host ""
    Write-Host "[SUCCESS] Vercel CLI installed!" -ForegroundColor Green
    Write-Host ""
}

Write-Host "[INFO] Vercel CLI is ready" -ForegroundColor Cyan
Write-Host ""

# Navigate to script directory
Set-Location $PSScriptRoot

Write-Host "[INFO] Current directory: $PWD" -ForegroundColor Cyan
Write-Host ""

# Check if submission folder exists
if (-not (Test-Path "submission\index.html")) {
    Write-Host "[ERROR] submission\index.html not found!" -ForegroundColor Red
    Write-Host "Make sure you're in the project root directory."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[SUCCESS] Submission page found" -ForegroundColor Green
Write-Host ""

# Show deployment info
Write-Host "========================================"
Write-Host "   Deployment Information"
Write-Host "========================================"
Write-Host ""
Write-Host "   Deploying: submission/index.html"
Write-Host "   Target: Vercel Production"
Write-Host "   Configuration: vercel.json"
Write-Host ""

# Ask for confirmation
$confirm = Read-Host "Ready to deploy? (y/n)"
if ($confirm -ne "y") {
    Write-Host ""
    Write-Host "[CANCELLED] Deployment cancelled by user" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 0
}

Write-Host ""
Write-Host "========================================"
Write-Host "   Deploying to Vercel..."
Write-Host "========================================"
Write-Host ""

# Deploy to Vercel
vercel --prod

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================"
    Write-Host "   [SUCCESS] Deployment Complete!"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Your submission page is now live!" -ForegroundColor Green
    Write-Host "Copy the URL above and share it with judges."
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "========================================"
    Write-Host "   [ERROR] Deployment Failed"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Make sure you're logged in: vercel login"
    Write-Host "  2. Check your internet connection"
    Write-Host "  3. Try deploying from submission folder:"
    Write-Host "     cd submission"
    Write-Host "     vercel --prod"
    Write-Host ""
}

Read-Host "Press Enter to exit"
