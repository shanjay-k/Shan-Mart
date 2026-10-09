@echo off
COLOR 0B
echo =========================================
echo       STARTING SHAN MART AUTO-DEPLOY
echo =========================================

echo [1/4] Building the project with Maven...
call mvn clean package
if %ERRORLEVEL% neq 0 (
    echo Build failed! Please check your Java code.
    pause
    exit /b %ERRORLEVEL%
)

echo [2/4] Deploying to Tomcat...

:: Change this path if your Tomcat is installed somewhere else
set TOMCAT_DIR=D:\apache-tomcat-9.0.121
copy /Y "target\shanjays-mart.war" "%TOMCAT_DIR%\webapps\"

echo [3/4] Starting Tomcat Server...
cd /d "%TOMCAT_DIR%\bin"
call startup.bat

echo [4/4] Launching Website...
:: Wait 4 seconds for Tomcat to boot up before opening the browser
timeout /t 4 /nobreak > nul
start http://localhost:8080/shanjays-mart/

echo.
echo =========================================================
echo  Success! SHAN MART is live locally:
echo  http://localhost:8080/shanjays-mart/
echo.
echo  To open on Android, iPhone, Tablets or other laptops:
echo  Run "share_public.bat" to get a worldwide public link + QR code!
echo =========================================================
pause