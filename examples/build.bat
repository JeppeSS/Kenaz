@echo off

if not exist ..\build\ (
    mkdir ..\build
)

if not exist ..\build\examples (
    mkdir ..\build\examples
) 

set output_name=basic
set compile_flags=-vet

echo Building example %output_name%...
odin build .\basic -debug %compile_flags% -out:../build/examples/%output_name%.exe

IF %ERRORLEVEL% NEQ 0 (ECHO Error:%ERRORLEVEL% && exit)

echo Build was successfull...