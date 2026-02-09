# GSTSync PWA Build & Deploy Helper Script
# Run this in PowerShell

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('build', 'serve', 'deploy', 'clean', 'test')]
    [string]$Action = 'help'
)

function Show-Help {
    Write-Host "`n=== GSTSync PWA Helper ===" -ForegroundColor Cyan
    Write-Host "`nUsage: .\build.ps1 -Action <action>`n"
    Write-Host "Actions:" -ForegroundColor Yellow
    Write-Host "  build   - Build the web app for production"
    Write-Host "  serve   - Build and serve locally for testing"
    Write-Host "  deploy  - Deploy to GitHub (push to main branch)"
    Write-Host "  clean   - Clean build artifacts"
    Write-Host "  test    - Run in Chrome for development"
    Write-Host "`nExamples:"
    Write-Host "  .\build.ps1 -Action build"
    Write-Host "  .\build.ps1 -Action serve"
    Write-Host "  .\build.ps1 -Action deploy`n"
}

function Build-Web {
    Write-Host "`n[BUILD] Building Flutter web app..." -ForegroundColor Green
    flutter clean
    flutter pub get
    flutter build web --release
    Write-Host "`n[SUCCESS] Build complete! Output in: build\web" -ForegroundColor Green
}

function Serve-Local {
    Write-Host "`n[SERVE] Building and serving locally..." -ForegroundColor Green
    flutter build web --release
    Write-Host "`n[INFO] Starting local server on port 8000..." -ForegroundColor Cyan
    Write-Host "[INFO] Open http://localhost:8000 in your browser" -ForegroundColor Cyan
    Write-Host "[INFO] Press Ctrl+C to stop the server`n" -ForegroundColor Yellow
    Set-Location "build\web"
    python -m http.server 8000
    Set-Location "..\..\"
}

function Deploy-ToGitHub {
    Write-Host "`n[DEPLOY] Preparing to deploy to GitHub..." -ForegroundColor Green
    
    # Check if git is initialized
    if (-not (Test-Path ".git")) {
        Write-Host "[ERROR] Git repository not initialized!" -ForegroundColor Red
        Write-Host "[INFO] Run these commands first:" -ForegroundColor Yellow
        Write-Host "  git init"
        Write-Host "  git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
        return
    }
    
    # Get commit message
    $commitMsg = Read-Host "Enter commit message"
    if ([string]::IsNullOrWhiteSpace($commitMsg)) {
        $commitMsg = "Update app - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
    
    Write-Host "`n[GIT] Adding files..." -ForegroundColor Cyan
    git add .
    
    Write-Host "[GIT] Committing changes..." -ForegroundColor Cyan
    git commit -m $commitMsg
    
    Write-Host "[GIT] Pushing to GitHub..." -ForegroundColor Cyan
    git push
    
    Write-Host "`n[SUCCESS] Deployed! Check GitHub Actions for build status." -ForegroundColor Green
    Write-Host "[INFO] Your app will be live in a few minutes at:" -ForegroundColor Cyan
    Write-Host "       https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/`n" -ForegroundColor White
}

function Clean-Build {
    Write-Host "`n[CLEAN] Cleaning build artifacts..." -ForegroundColor Yellow
    flutter clean
    Write-Host "[SUCCESS] Clean complete!`n" -ForegroundColor Green
}

function Test-InChrome {
    Write-Host "`n[TEST] Running in Chrome (development mode)..." -ForegroundColor Green
    Write-Host "[INFO] This will open Chrome with hot reload enabled" -ForegroundColor Cyan
    Write-Host "[INFO] Press 'q' in terminal to quit`n" -ForegroundColor Yellow
    flutter run -d chrome
}

# Main execution
switch ($Action) {
    'build'  { Build-Web }
    'serve'  { Serve-Local }
    'deploy' { Deploy-ToGitHub }
    'clean'  { Clean-Build }
    'test'   { Test-InChrome }
    'help'   { Show-Help }
    default  { Show-Help }
}
