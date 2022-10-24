﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
ToolTip,building LinkRunner
#SingleInstance Force
Send, {LCtrl Down}{f12}
Send, {LCtrl Up}
home:= A_ScriptDir
splitpath,home,srcfn,srcpth
if ((srcfn = "src")or(srcfn = "bin")or(srcfn = "binaries"))
	{
		home:= srcpth
	}	
binhome:= home . "\" . "bin"
source:= home . "\" . "src"	
splitpath,home,RJPRJCT
SetWorkingDir, %home%
FileDelete,%binhome%\%RJPRJCT%.exe
FileDelete,%binhome%\NewOSK.exe
FileDelete,%binhome%\Setup.exe
FileDelete,%binhome%\Source_Builder.exe

SplitPath,A_AhkPath,AHKFNM,AHKLOC
Loop,files,%AHKLOC%\*.exe,R
	{
		if (A_LoopFileName = "Ahk2Exe.exe")
			{
				AHKEXE:= A_LoopFileFullPath
				splitpath,AHKEXE,AHKEXN,AHKEXEPATH
				break
			}
Loop,files,%AHKLOC%\*.bin,R
	{
		if (A_LoopFileName = "Unicode 64-bit.bin")
			{
				BINFILE:= A_LoopFileFullPath
				break
			}
		}	
	}
RunWait,"%AHKEXE%" /in "%source%\%RJPRJCT%.ahk" /icon "%source%\%RJPRJCT%.ico" /bin "%BINFILE%" /out "%binhome%\%RJPRJCT%.exe",%source%,hide
if (errorlevel <> 0)
	{
		Msgbox,,LINKRUNNER BUILD FAIL,LinkRunner Build Failed	
	}
ToolTip,Compiling Setup
RunWait,"%AHKEXE%" /in "%source%\Setup.ahk" /icon "%source%\Setup.ico" /bin "%BINFILE%" /out "%binhome%\Setup.exe",%source%,hide
if (errorlevel <> 0)
	{
		Msgbox,,SETUP BUILD FAIL,Setup Build Failed	
	}
ToolTip,Compiling NewOSK
RunWait,"%AHKEXE%" /in "%source%\NewOSK.ahk" /icon "%source%\NewOSK.ico" /bin "%BINFILE%" /out "%binhome%\NewOSK.exe",%source%,hide
if (errorlevel <> 0)
	{
		Msgbox,,NEWOSK BUILD FAIL,NewOSK Build Failed	
	}
ToolTip,Compiling Source Builder
RunWait,"%AHKEXE%" /in "%source%\build.ahk" /icon "%source%\Source_Builder.ico" /bin "%BINFILE%" /out "%binhome%\Source_Builder.exe",%source%,hide
if (errorlevel <> 0)
	{
		Msgbox,,BUILDER BUILD FAIL,Builder Build Failed	
	}

ToolTip,complete
sleep,2000
exitapp
esc::
exitapp