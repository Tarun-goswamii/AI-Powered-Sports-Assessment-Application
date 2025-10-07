#!/usr/bin/env pwsh
# Quick Email Setup Script for Sports Assessment App

Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "   📧 Email Service Setup Wizard" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host "`n📋 Checking current configuration..." -ForegroundColor Yellow

$envVars = npx convex env list 2>&1 | Out-String

if ($envVars -match "RESEND_API_KEY") {
    Write-Host "`n✅ RESEND_API_KEY is configured!" -ForegroundColor Green
    Write-Host "   Email service should be working." -ForegroundColor Green
} else {
    Write-Host "`n⚠️ RESEND_API_KEY is NOT configured" -ForegroundColor Red
    Write-Host "   This is why emails are not being sent!" -ForegroundColor Red
    
    Write-Host "`n🚀 Quick Setup Steps:" -ForegroundColor Yellow
    Write-Host "   1. Sign up: https://resend.com/signup" -ForegroundColor Blue
    Write-Host "   2. Get API key: https://resend.com/api-keys" -ForegroundColor Blue
    Write-Host "   3. Run: npx convex env set RESEND_API_KEY re_your_key" -ForegroundColor Cyan
    
    Write-Host "`n📖 See EMAIL_FIX_GUIDE.md for detailed instructions" -ForegroundColor Gray
}

Write-Host "`n=========================================" -ForegroundColor Cyan
