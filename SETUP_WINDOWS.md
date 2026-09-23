# SHAN MART — Windows + VS Code Setup

## A. JDK 17
Install a JDK 17 distribution (Temurin/OpenJDK 17). After installation, open a NEW terminal:

    java -version
    javac -version

Both should report version 17.

## B. Maven
Install Apache Maven and add its `bin` directory to PATH. Then open a NEW terminal:

    mvn -version

Maven should show Java 17.

## C. VS Code extensions
Open Extensions (`Ctrl+Shift+X`) and install the recommended extensions from this project's `.vscode/extensions.json`.

Recommended:
- Extension Pack for Java
- Java support from Red Hat
- Tomcat extension for VS Code

You can also open the Extensions view and type `@recommended`.

## D. Tomcat 9
Download/extract Apache Tomcat 9.x. Do not use Tomcat 10/11 for this project because the code uses `javax.servlet.*` as required by the supplied guide.

Example location:
`C:\apache-tomcat-9.0.xx`

## E. Build
In VS Code terminal, inside the project folder:

    mvn clean package

Expected result:
`BUILD SUCCESS`

WAR file:
`target\shanjays-mart.war`

## F. Deploy
Copy the WAR into:
`C:\apache-tomcat-9.0.xx\webapps\`

Then run:
`C:\apache-tomcat-9.0.xx\bin\startup.bat`

Open:
`http://localhost:8080/shanjays-mart/`

## G. If something fails
Run these and send the full output/screenshot:

    java -version
    mvn -version
    mvn clean package

Also send the Tomcat console error if the browser shows HTTP 404/500.
