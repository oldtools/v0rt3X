#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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
			}
		if (A_LoopFileName = "Unicode 32-bit.bin")
			{
				BIN32FILE:= A_LoopFileFullPath
			}
		}	
	}
iniread,gituser,%home%\skopt.cfg,GLOBAL,Git_username
iniread,rjprjct,%home%\skopt.cfg,GLOBAL,Project_name
getversf= %home%\site\index.html
cacheloc= %A_Temp%
if !fileexist(getversf)
	{
		FileDelete,%cacheloc%\ORIGHTML.html
		save= %cacheloc%\ORIGHTML.html
		URLFILE= https://%GITUSER%.github.io/%RJPRJCT%/index.html
		splitpath,save,svaf,svap
		exe_get(ARIA,URLFILE,svap,svaf,CURPID,cacheloc)
		;;DownloadFile(URLFILE, save, True, True)
		getversf= %cacheloc%\ORIGHTML.html
	}

Loop, Read, %getversf%
	{
		if (A_LoopReadLine = "")
			{
				continue
			}
		sklnum+=1
		getvern= 
		if instr(A_LoopReadLine,"<h99>")
			{
				stringgetpos,verstr,A_LoopReadLine,<h99>
				stringgetpos,endstr,A_LoopReadLine,</h99>
				strstr:= verstr + 6
				midstr:= (endstr - verstr - 5)
				stringmid,vernum,A_LoopReadLine,strstr,midstr
				if (midstr = 0)
					{
						vernum= 0.99.00.00
					}
				Loop,Parse,vernum,.
					{
						if A_LoopField is not digit
							{
								vernum= 0.99.00.00
							}
					}
				continue
			}
			ifinstring,A_LoopReadLine,<h88>
					{
						stringgetpos,verstr,A_LoopReadLine,<h88>
						FileReadLine,sklin,%SITEDIR%\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsize,sklin,%getvern%,4
						continue
					}
			ifinstring,A_LoopReadLine,<h87>
					{
						stringgetpos,verstr,A_LoopReadLine,<h87>
						FileReadLine,sklin,%SITEDIR%\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsize,sklin,%getvern%,4
						continue
					}
			ifinstring,A_LoopReadLine,<h77>
					{
						stringgetpos,verstr,A_LoopReadLine,<h77>
						FileReadLine,sklin,%SITEDIR%\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsha,sklin,%getvern%,40
						continue
					}
			ifinstring,A_LoopReadLine,<h66>
					{
						stringgetpos,verstr,A_LoopReadLine,<h66>
						FileReadLine,sklin,%SITEDIR%\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,olrlsdt,sklin,%getvern%,18
						continue
					}	
			ifinstring,A_LoopReadLine,<h55>
					{
						stringgetpos,donat,A_LoopReadLine,<h55>
						FileReadLine,donit,%SITEDIR%\index.html,%sklnum%
						getvern:= donat+6
						StringMid,donation,donit,%getvern%,5
						continue
					}	
	}

if (vernum = "")
	{
		vernum= 0.99.00.00
	}	
FileMove,%source%\Setup.ahk,%DEPL%\Setup.bak,1
FileMove,%source%\Setup_theme.ahk,%DEPL%\Setup_theme.bak,1
FileCopy, %source%\working.ahk, %source%\Setup.tmp,1
sktmp= 
sktmc= 
sktmv= 
FileRead, sktmp,%source%\Setup.tmp
StringReplace,sktmv,sktmp,[VERSION],%date% %TimeString%,All
StringReplace,sktmv,sktmv,[CURV],%vernum%,All
StringReplace,sktmv,sktmv,[RJ_PROJ],%RJPRJCT%,All
StringReplace,sktmv,sktmv,[RJ_EXE],%RJ_PROJ%,All
stringreplace,sktmv,sktmv,`/`*  `;`;[DEBUGOV],,All
stringreplace,sktmv,sktmv,`*`/  `;`;[DEBUGOV],,All
stringreplace,sktmNv,sktmv,`/`*  `;`;[DEBUG32],,All
stringreplace,sktmNv,sktmNv,`*`/  `;`;[DEBUG32],,All
fileappend,%sktmv%,%source%\Setup.ahk,UTF-8
fileappend,%sktmNv%,%source%\Setup_theme.ahk,UTF-8
FileDelete,%source%\%RJEXFN%.ahk
FileRead, itmv,%source%\jkvtx.ahk
StringReplace,itmv,itmv,[VERSION],%date% %TimeString%,All
StringReplace,itmv,itmv,[CURV],%vernum%,All
StringReplace,itmv,itmv,[RJ_PROJ],%RJPRJCT%,All
StringReplace,itmv,itmv,[RJ_EXE],%RJEXFN%,All
fileDelete,%source%\%RJEXFN%.ahk
fileappend,%itmv%,%source%\%RJEXFN%.ahk,UTF-8	
RunWait,"%AHKEXE%" /in "%source%\%RJPRJCT%.ahk" /icon "%source%\Run.ico" /bin "%BINFILE%" /out "%binhome%\%RJPRJCT%.exe",%source%,hide
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
RunWait,"%AHKEXE%" /in "%source%\Setup_theme.ahk" /icon "%source%\Setup.ico" /bin "%BIN32FILE%" /out "%binhome%\Setup_theme.exe",%source%,hide
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


exe_get($ARIA = "", $URL = "", $TARGET = "", $FNM = "", $SAG = "", $CACHESTAT = "")
{
	Global $exeg_pid
	StringReplace, $URL, $URL, "&", "^&", All
	$CMD = "%$ARIA%" -x16 -s16 -j16 -k1M --always-resume=true --enable-http-pipelining=true --retry-wait=3 --http-no-cache=false --http-accept-gzip=true --allow-overwrite=true --stop-with-process=%$SAG% --truncate-console-readout=false --check-certificate=false --dir="%$TARGET%" --out="%$FNM%" "%$URL%" 1>"%$CACHESTAT%\%$FNM%.status" 2>&1
	Run, %comspec% /c "%$CMD%",,hide,$exeg_pid
	Process, Exist, %$exeg_pid%
	$lastline =
	while ErrorLevel != 0
	{
		Loop Read, %$CACHESTAT%\%$FNM%.status
		{
			L = %A_LoopReadLine%
			if ( InStr(L, `%) != 0 )
			{
				StringSplit, DownloadInfo, L, (`%,
				StringLeft, L1, DownloadInfo2, 3
				stringsplit,tosb,DownloadInfo1,/%A_Space%
				stringsplit,spr,DownloadInfo3,%A_Space%:,]
				SB_SetText("" spr5 "ps " tosb2 "/" tosb3 " [" spr7 "]")
				if ( L1 = "100" )
				{
					Break
				}
			}
			if ( InStr(L, `%) = 0 )
			{
				L = 0
			}
		}
		if ( L1 is digit )
			Process, Exist, %$exeg_pid%
		Sleep, 50
	}
	sleep 200
	FileGetSize, d_size, %$TARGET%\%$FNM%
	if d_size > 0
	{
		FileDelete, %$CACHESTAT%\%$FNM%.status
		Return true
	}
	else
	{
		SB_SetText(" " FNM ".status being deleted")
		if ((batchdl = 1)or(LOGGING = 1))
		{
			FileRead,statdel,%$CACHESTAT%\%$FNM%.status
			fileappend,%statdel%,%$FNM%.log
			statdel=
		}
		else {
			FileDelete, %$CACHESTAT%\%$FNM%.status
			Return false
		}
	}
}