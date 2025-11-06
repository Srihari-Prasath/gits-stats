# GitTrack - Setup and Run Script
# Run this script to quickly set up and launch the app

Write-Host "🔥 GitTrack - GitHub Contribution Tracker" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
Write-Host "🔍 Checking Flutter installation..." -ForegroundColor Yellow
$flutterCheck = flutter --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Flutter is installed!" -ForegroundColor Green
} else {
    Write-Host "❌ Flutter is not installed. Please install Flutter first." -ForegroundColor Red
    Write-Host "Visit: https://flutter.dev/docs/get-started/install" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Get dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencies installed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Check for connected devices
Write-Host "📱 Checking for connected devices..." -ForegroundColor Yellow
flutter devices
Write-Host ""

# Prompt user to run
Write-Host "🚀 Ready to launch GitTrack!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Options:" -ForegroundColor Yellow
Write-Host "  1. Run on connected device/emulator" -ForegroundColor White
Write-Host "  2. Run on Chrome (Web)" -ForegroundColor White
Write-Host "  3. Exit" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🚀 Launching app..." -ForegroundColor Green
        flutter run
    }
    "2" {
        Write-Host ""
        Write-Host "🌐 Launching on Chrome..." -ForegroundColor Green
        flutter run -d chrome
    }
    "3" {
        Write-Host ""
        Write-Host "👋 Goodbye!" -ForegroundColor Cyan
        exit 0
    }
    default {
        Write-Host ""
        Write-Host "❌ Invalid choice. Exiting..." -ForegroundColor Red
        exit 1
    }
}
