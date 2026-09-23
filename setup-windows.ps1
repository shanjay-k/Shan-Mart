$ErrorActionPreference='Stop'
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$tools=Join-Path $root 'tools'; New-Item -ItemType Directory -Force $tools | Out-Null
$items=@(
 @{url='https://aka.ms/download-jdk/microsoft-jdk-17-windows-x64.zip'; zip='jdk17.zip'; pattern='jdk-17*'},
 @{url='https://dlcdn.apache.org/maven/maven-3/3.9.16/binaries/apache-maven-3.9.16-bin.zip'; zip='maven.zip'; pattern='apache-maven-3.9.16'},
 @{url='https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.121/bin/apache-tomcat-9.0.121.zip'; zip='tomcat9.zip'; pattern='apache-tomcat-9.0.121'}
)
foreach($i in $items){if(-not(Get-ChildItem $tools -Directory | Where-Object {$_.Name -like $i.pattern})){ $z=Join-Path $tools $i.zip; Invoke-WebRequest $i.url -OutFile $z; Expand-Archive $z -DestinationPath $tools -Force }}
$jdk=Get-ChildItem $tools -Directory|Where-Object Name -like 'jdk-17*'|Select-Object -First 1
$mvn=Get-ChildItem $tools -Directory|Where-Object Name -eq 'apache-maven-3.9.16'
$tomcat=Get-ChildItem $tools -Directory|Where-Object Name -eq 'apache-tomcat-9.0.121'
[Environment]::SetEnvironmentVariable('JAVA_HOME',$jdk.FullName,'User')
$env:JAVA_HOME=$jdk.FullName; $env:Path="$($jdk.FullName);$($mvn.FullName)\bin;$env:Path"
if(Get-Command code -ErrorAction SilentlyContinue){code --install-extension vscjava.vscode-java-pack --force;code --install-extension adashen.vscode-tomcat --force}
Set-Location $root
java -version; mvn -version; mvn clean package
Copy-Item "$root\target\shanjays-mart.war" "$($tomcat.FullName)\webapps\shanjays-mart.war" -Force
& "$($tomcat.FullName)\bin\startup.bat"
Write-Host 'Open http://localhost:8080/shanjays-mart/' -ForegroundColor Green
