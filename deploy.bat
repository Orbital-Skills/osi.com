@echo off
echo ================================
echo   ORBITAL APP DEPLOY STARTED
echo ================================

echo.
echo 🔥 Building Flutter Web...
flutter build web --release --web-renderer canvaskit

if %errorlevel% neq 0 (
    echo ❌ Build Failed!
    pause
    exit /b
)

echo.
echo 🚀 Deploying to Firebase Hosting...
firebase deploy --only hosting

if %errorlevel% neq 0 (
    echo ❌ Deployment Failed!
    pause
    exit /b
)

echo.
echo ================================
echo   ✅ DEPLOY SUCCESSFUL!
echo ================================
pause
