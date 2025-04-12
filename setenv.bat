@echo off
rem Setting windows build environment for max32630-fthr using Maxim SDK tools
rem [ARMCortexToolchain.exe](https://download.analog.com/sds/exclusive/SFW0001500A/ARMCortexToolchain.exe).
rem Note!
rem Initial(pro) version absolutely no sanity checks for the paths.

set MAXIM_PATH=C:\Maxim

echo.
echo Input MAXIM_PATH=(%MAXIM_PATH%)
set "maxim="
set /P maxim=": "
if defined maxim set "MAXIM_PATH=%maxim%"
echo Selected MAXIM_PATH=(%MAXIM_PATH%)
echo.

set TOOLCHAIN_PATH=%MAXIM_PATH%\Toolchain
echo Input TOOLCHAIN_PATH=(%TOOLCHAIN_PATH%)
set "toolchain="
set /P toolchain=": "
if defined toolchain set "TOOLCHAIN_PATH=%toolchain%"
echo Selected TOOLCHAIN_PATH=(%TOOLCHAIN_PATH%)
echo.

set MSYS_PATH=%TOOLCHAIN_PATH%\msys\1.0
echo Input MSYS_PATH=(%MSYS_PATH%)
set "msys="
set /P msys=": "
if defined msys set "MSYS_PATH=%msys%"
echo Selected MSYS_PATH=(%MSYS_PATH%)
echo.

echo Current PATH=%PATH%
echo.

echo Prepend path with "%TOOLCHAIN_PATH%\bin;%MSYS_PATH%\bin;"
set /p var="Continue?[Y/(N)]: "
if %var%== Y goto prepend
if %var%== y goto prepend
else goto extract

:prepend
  set ORIG_PATH=%PATH%
  set PATH=%TOOLCHAIN_PATH%\bin;%MSYS_PATH%\bin;%PATH%
  echo %PATH%
  echo.

:extract
  rem btstack/chipset/cc256x/Makefile.inc uses unzip
  rem which is not included in the default msys distribution.
  rem Downloaded one from sourceforge:
  rem https://altushost-swe.dl.sourceforge.net/project/mingw/MSYS/Extension/unzip/unzip-6.0-1/unzip-6.0-1-msys-1.0.13-bin.tar.lzma?viasf=1
  rem The executables inside the tar are contained in relative bin-folder
  rem so the install is just extracting the files to msys root folder.
  echo Extract tools\unzip-6.0-1-msys-1.0.13-bin.tar.lzma to %MSYS_PATH%
  set /p var="Continue?[Y/(N)]: "
  if %var%== Y goto do-extract
  if %var%== y goto do-extract
  exit /b

:do-extract
  setlocal
  rem Having trouble making tar accept the "1.0".
  rem Resorting to working in the directory.
  @echo on
  cp tools\unzip-6.0-1-msys-1.0.13-bin.tar.lzma %MSYS_PATH%\unzip.tar.lzma
  cd /D %MSYS_PATH%
  tar --lzma -xvf unzip.tar.lzma
  del unzip.tar.lzma
  @echo off
  endlocal
  exit /b
