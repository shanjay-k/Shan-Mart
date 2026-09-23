# First-time setup

## Automatic Windows setup
1. Extract this ZIP.
2. Open PowerShell in the `SHANJAYS_MART_CAPSTONE` folder.
3. Run `Set-ExecutionPolicy -Scope Process Bypass`.
4. Run `./setup-windows.ps1`.

The script downloads JDK 17, Maven 3.9.16 and Tomcat 9.0.121, installs the recommended VS Code Java/Tomcat extensions when the `code` command is available, builds the WAR, deploys it and starts Tomcat.

## Manual setup
See `SETUP_WINDOWS.md`.

## Application
Open `http://localhost:8080/shanjays-mart/`.

Buyer: `buyer@shanjaymart.local` / `1234`
Seller: `seller@shanjaymart.local` / `1234`
Admin: `admin@shanjaymart.local` / `1234`
