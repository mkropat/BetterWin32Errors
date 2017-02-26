@cd %~dp0\BetterWin32Errors

call "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat"

msbuild /t:pack /p:Configuration=Release BetterWin32Errors.csproj
