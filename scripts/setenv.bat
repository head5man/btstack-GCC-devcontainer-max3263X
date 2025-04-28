@echo off
rem Setting windows build environment for max32630-fthr using Maxim SDK tools
rem [ARMCortexToolchain.exe](https://download.analog.com/sds/exclusive/SFW0001500A/ARMCortexToolchain.exe).
rem Note!
rem Initial(pro) version absolutely no sanity checks for the paths.

set MAXIM_PATH=%~dp0..\btstack\port\max32630-fthr\maxim

echo.
echo Input MAXIM_PATH=(%MAXIM_PATH%)
set "maxim="
set /P maxim=": "
if defined maxim set "MAXIM_PATH=%maxim%"
echo Selected MAXIM_PATH=(%MAXIM_PATH%)
echo.

echo download and extract toolchain https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-mingw-w64-x86_64-arm-none-eabi.zip

set TOOLCHAIN_PATH=c:\toolchains\arm-gnu-toolchain-14.2.rel1-mingw-w64-x86_64-arm-none-eabi
echo Input TOOLCHAIN_PATH=(%TOOLCHAIN_PATH%)
set "toolchain="
set /P toolchain=": "
if defined toolchain set "TOOLCHAIN_PATH=%toolchain%"
echo Selected TOOLCHAIN_PATH=(%TOOLCHAIN_PATH%)
echo.

echo download and install msys64 https://github.com/msys2/msys2-installer/releases/
set MSYS_BIN=C:\msys64\usr\bin
echo Input MSYS_BIN=(%MSYS_BIN%)
set "msys="
set /P msys=": "
if defined msys set "MSYS_BIN=%msys%"
echo.

echo Current PATH=%PATH%
echo.

echo Prepend path with "%TOOLCHAIN_PATH%\bin;%MSYS_BIN%;"
set /p var="Continue?[Y/(N)]: "
if "%var%"=="" goto :prepend
if %var%== Y goto :prepend
if %var%== y goto :prepend
else goto :EOF

:prepend
  set ORIG_PATH=%PATH%
  set PATH=%TOOLCHAIN_PATH%\bin;%MSYS_BIN%;%PATH%
  echo %PATH%
  echo.
