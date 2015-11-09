@echo off
rem
rem  runMic1.bat
rem 
rem  This batch file sets the environment variables necessary for running
rem  Mic1MMV and launches the program.

rem  1) comment out or delete the following 4 commands

echo   NOTE: YOU NEED TO EDIT THE FILE RUNMIC1.BAT BEFORE YOUR Mic1MMV
echo   SOFTWARE will WORK CORRECTLY.
pause
goto end

rem  2) Set the environment variable JAVA_HOME to point to the base
rem     directory of the JDK

set JAVA_HOME=C:\j2sdk1.4.2\

rem  3) Uncomment one of the following (and delete the other)

rem %JAVA_HOME%/bin/java -jar Mic1MMV_lr.jar
rem %JAVA_HOME%/bin/java -jar Mic1MMV_hr.jar

:end
