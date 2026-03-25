@echo off
echo Building Kotlin Student Grading System...
call gradlew shadowJar

if %ERRORLEVEL% equ 0 (
    echo.
    echo ✅ Build successful!
    echo To run the application, use:
    echo     java -jar build\libs\grading-app.jar
) else (
    echo.
    echo ❌ Build failed! Please check the output above.
)
pause
