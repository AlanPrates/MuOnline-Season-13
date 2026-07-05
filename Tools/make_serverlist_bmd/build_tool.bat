@echo off
call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
cl.exe /nologo /EHsc "%CD%\Tools\make_serverlist_bmd\decrypt_bmd.cpp" /Fe:"%CD%\Tools\make_serverlist_bmd\decrypt_bmd.exe" >nul 2>&1
if %errorlevel% neq 0 (
    cl.exe /nologo /EHsc "%CD%\Tools\make_serverlist_bmd\decrypt_bmd.cpp" /Fe:"%CD%\Tools\make_serverlist_bmd\decrypt_bmd.exe"
)
if %errorlevel% equ 0 (
    "%CD%\Tools\make_serverlist_bmd\decrypt_bmd.exe" "%CD%\Tools\make_serverlist_bmd\serverlist.bmd"
)
