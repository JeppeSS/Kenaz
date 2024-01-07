@ECHO OFF

ECHO Starting building script...

PUSHD examples
CALL build.bat
POPD
IF %ERRORLEVEL% NEQ 0 (ECHO Error:%ERRORLEVEL% && exit)



ECHO Building complete...