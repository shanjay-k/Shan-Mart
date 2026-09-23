@echo off
setlocal
where java >nul 2>nul || (echo JDK not found. Install JDK 17 and add it to PATH.&pause&exit /b 1)
where mvn >nul 2>nul || (echo Maven not found. Install Maven and add it to PATH.&pause&exit /b 1)
echo Building SHAN MART...
mvn clean package
if errorlevel 1 (echo Build failed.&pause&exit /b 1)
echo.
echo Build successful: target\shanjays-mart.war
echo Copy that WAR to Tomcat 9 webapps and run startup.bat.
pause
