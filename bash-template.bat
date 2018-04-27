@echo off
:main
REM Basic launcher for bash scripts on cmd. Assumes that a bash script with same
REM name as this file exists, but with an "sh" extension.
REM
REM Instead of this, it is better to properly set up the file type associations:
REM   assoc .sh=bash_script
REM   ftype bash_script="C:\msys64\usr\bin\bash.exe" "%L" %*
REM   setx PATHEXT=%PATHEXT%;.SH

setlocal enableextensions enabledelayedexpansion

set _BASH_SCRIPT=%~dp0%~n0.sh
call :bash "%_BASH_SCRIPT%" %*

endlocal
goto :exit

:bash %*
REM Run a bash script. Guesses some extra path directories if bash not on path.
setlocal enableextensions enabledelayedexpansion
where bash >NUL 2>&1 || for %%a in (
  "C:\msys64\usr\bin"
  "C:\Program Files\Git\bin"
) do (set PATH=!PATH!;%%~a)
bash %*

endlocal
goto :eof

:exit
REM Exit the script and set errorlevel.
if %errorlevel% equ 0 (
  exit /b 0
)

REM On error we exit with a command that fails in order to allow calling calling code
REM that checks the success of the last command to work properly, for example:
REM         > thisscript.bat && echo SUCCESS || echo FAIL
REM This must be the last command in the batch script!
(call)
