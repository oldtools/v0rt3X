﻿SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Persistent
SetBatchLines -1
FileEncoding UTF-8
rjrlupdfX= %1%
splitpath,rjrlupdfX,,rjrlupdpth
home= %rjrlupdpth%
splitpath,home,srcfn,srcpth
if ((srcfn = "src")or(srcfn = "bin")or(srcfn = "binaries")or(srcfn = "downloaded"))
	{
		home= %srcpth%
	}	
binhome= %home%\bin
source= %home%\src
SetWorkingDir, %home%
cacheloc= %home%\downloaded
inapp= 
if (rjrlupdfX <> "")
	{
		inapp= 1
		splitpath,rjrlupdfX,savefileX,home
		cacheloc= %home%\downloaded
		binhome= %home%\bin
		source= %home%\src
		SetWorkingDir, %home%
		goto, rjrlupdf
	}
ARIA:= binhome . "\aria2c.exe"
FileDelete, %cacheloc%\version.txt
ARCORG= %source%\repos.set
save=%cacheloc%\version.txt
splitpath,save,svaf,svap
IniRead,sourceHost,%ARCORG%,GLOBAL,SOURCEHOST
IniRead,UPDATEFILE,%ARCORG%,GLOBAL,UPDATEFILE
IniRead,RELEASE,%ARCORG%,GLOBAL,VERSION
getVer:
exe_get(ARIA,sourceHost,svap,svaf,CURPID,cacheloc)
;URLDownloadToFile, %sourceHost%,%cacheloc%\version.txt
ifnotexist, %cacheloc%\version.txt
	{
		MsgBox,4,Not Found,Update Versioning File not found.`nRetry?
		ifMsgBox, Yes
			{
				goto, getVer
			}
		return
	}
iniread,RJPRJCT,%home%\skopt.cfg,GLOBAL,ProjectName
if ((RJPRJCT = "")or(RJPRJCT = "ERROR"))
	{
		splitpath,home,RJRPJCT
		stringreplace,RJPRJCT,RJPRJCT,%A_Space%,_,All
		stringreplace,RJPRJCT,RJPRJCT,;,,All
		stringreplace,RJPRJCT,RJPRJCT,-,,All
		stringreplace,RJPRJCT,RJPRJCT,.,,All
		stringreplace,RJPRJCT,RJPRJCT,|,,All
		stringreplace,RJPRJCT,RJPRJCT,{,,All
		stringreplace,RJPRJCT,RJPRJCT,},,All
		stringreplace,RJPRJCT,RJPRJCT,(,,All
		stringreplace,RJPRJCT,RJPRJCT,),,All
		stringreplace,RJPRJCT,RJPRJCT,[,,All
		stringreplace,RJPRJCT,RJPRJCT,],,All
		stringreplace,RJPRJCT,RJPRJCT,=,,All
		stringreplace,RJPRJCT,RJPRJCT,^,,All
		stringreplace,RJPRJCT,RJPRJCT,`,,,All
		stringreplace,RJPRJCT,RJPRJCT,`%,,All
		stringreplace,RJPRJCT,RJPRJCT,+,,All
		stringreplace,RJPRJCT,RJPRJCT,&,,All
		stringreplace,RJPRJCT,RJPRJCT,$,,All
		stringreplace,RJPRJCT,RJPRJCT,#,,All
		stringreplace,RJPRJCT,RJPRJCT,~,,All
		stringreplace,RJPRJCT,RJPRJCT,!,,All
		stringreplace,RJPRJCT,RJPRJCT,@,,All
	}
FileReadLine,DATECHK,%cacheloc%\version.txt,1
stringsplit,VERCHKC,DATECHK,=
if (VERCHKC1 <> RELEASE)
	{
		msgbox,4,Update, Update available`n%VERCHKC1%`nWould you like to update?
		IfMsgBox, yes
			{
				gosub, getupdate
				guicontrol,enable,UpdateSK
				return
			}
		ifmsgbox, no
			{
				exitapp
				return
			}
	}
return

getupdate:
upcnt=
loop, %cacheloc%\Portable*.zip
	{
		upcnt+=1
	}
upcnt+=1
URLFILE= %UPDATEFILE%
save= %cacheloc%\Portable%upcnt%.zip
splitpath,save,svaf,svap
exe_get(ARIA,URLFILE,svap,svaf,CURPID,cacheloc)
;DownloadFile(URLFILE, save, True, True)
ifexist,%save%
	{
		Process, close, Setup.exe
		Process, close, lrdeploy.exe
		Process, close, %RJPRJCT%.exe
		Process, close, Build_Source.exe
		FileCreateDir,%home%\downloaded\Update
		Runwait, %binhome%\7za.exe x -y "%save%" -O"%home%\downloaded\Update",,hide
		if (ERRORLEVEL <> 0)
			{
				MsgBox,3,Update Failed,Update not found.`n    Retry?
				ifMsgBox, Yes
					{
						goto, getupdate
					}
				exitapp
			}
		FileDelete,%home%\Update.cmd
		FileAppend,`n`ntaskkill /f /im Update.exe`nxcopy /y `"%home%\Downloaded\Update`" `"%home%`" /E /H /C /I`nstart `"`" `"%binhome%\Setup.exe`"`nexit /b`n,%home%\Update.cmd
		Run, %home%\Downloaded\Update.cmd,%home%\downloaded,hide
		exitapp
	}
	else {
		MsgBox,3,Update Failed,Update not found.`nRetry?
		ifMsgBox, Yes
			{
				goto, getupdate
			}
		exitapp
	}
return

rjrlupdf:
TrayTip, Update, Extracting Update.`n%RJPRJCT% will restart,999,48
Runwait, %binhome%\7za.exe x -y "%rjrlupdfX%" -O"%home%",,hide
if (ERRORLEVEL <> 0)
	{
		MsgBox,,ERROR,Update Failed,3
	}
if (inapp = 1)
	{
		Run, %binhome%\Setup.exe
	}	
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
/*
DownloadFile(UrlToFile, _SaveFileAs, Overwrite := True, UseProgressBar := True) {
		FinalSize= 
	
      If (!Overwrite && FileExist(_SaveFileAs))
		  {
			FileSelectFile, _SaveFileAs,S, %_SaveFileAs%
			if !_SaveFileAs 
			  return
		  }

      If (UseProgressBar) {
          
            SaveFileAs := _SaveFileAs
          
            try WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
			catch {
			}
          
            try WebRequest.Open("HEAD", UrlToFile)
            catch {
			}
			try WebRequest.Send()
			catch {
			}
          
			try FinalSize := WebRequest.GetResponseHeader("Content-Length") 
			catch {
				FinalSize := 1
			}
			SetTimer, DownloadFileFunction_UpdateProgressBar, 100
		
 
      }
    
      UrlDownloadToFile, %UrlToFile%, %_SaveFileAs%
    
      If (UseProgressBar) {
          Progress, Off
          SetTimer, DownloadFileFunction_UpdateProgressBar, Off
      }
      return

      DownloadFileFunction_UpdateProgressBar:
    
      try CurrentSize := FileOpen(_SaveFileAs, "r").Length 
	  catch {
			}
			
      try CurrentSizeTick := A_TickCount
    catch {
			}
			
      try Speed := Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000)) . " Kb/s"
	  catch {
			}
    
      LastSizeTick := CurrentSizeTick
      try LastSize := FileOpen(_SaveFileAs, "r").Length
    catch {
			}
	
      try PercentDone := Round(CurrentSize/FinalSize*100)
    catch {
			}
			
	 if (PercentDone > 100)
		{
			PercentDone= 0
		}
	progress, %PercentDone%
		return
	}
progress, off
exitapp
return