#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Persistent
FileEncoding, UTF-8
EnvGet,LADTA,LOCALAPPDATA
EnvGet,USRPRF,USERPROFILE
EnvGet,SYSTMRT,SYSTEMROOT
EnvGet,PBLCFLDR,ALLUSERSPROFILE
EnvGet,DRVSYSTM,SYSTEM
EnvGet,xprgfls,PROGRAMFILES(X86)
EnvGet,DRVRT,WINDIR
rootiterate=%LADTA%|%A_AppData%|%USRPRF%|%xprgfls%|%A_Temp%|%PBLCFLDR%|%DRVSYSTM%|%PBLCFLDR%


Loop %0%  
	{
		GivenPath := %A_Index%
		Loop %GivenPath%,
			{
				if (plink = "")
					{
						plink = %A_LoopFileLongPath%
						continue
					}
			}
		IF (!INSTR(LinkOptions,GivenPath)&& !instr(LinkOptions,plink)&& (GivenPath <> plink))
			{
				LinkOptions.= GivenPath . a_SpACE
			}
	}
splitpath,plink,scname,scpath,scextn,gmname,gmd
ExtID := FileExt
IconNumber:= 0				
if ((plink = "") or !fileExist(plink) or (scextn = ""))
	{
		Tooltip, No Item Detected
		Sleep, 3000
		exitapp
	}
home= %A_ScriptDir%
Splitpath,A_ScriptDir,tstidir,tstipth
if ((tstidir = "src")or(tstidir = "bin")or(tstidir = "binaries"))
	{
		home= %tstipth%
	}
source= %home%\src
binhome= %home%\bin
curpidf= %home%\rjpids.ini
if fileexist(curpidf)
	{
		iniread,crgpd,%curpidf%,Current_Game,pid
		iniread,mmtpd,%curpidf%,MultiMonitor_Tool,pid
		iniread,mappd,%curpidf%,Mapper,pid
		if process,exist,%crgpd%
			{
				process,close,%crgpd%
			}
		if process,exist,%mmtpd%
			{
				process,close,%mmtpd%
			}
		if process,exist,%mappd%
			{
				process,close,%mappd%
			}
		filedelete,%curpidf%
	}

Tooltip,Keyboad/Mouse Disabled`n::Please Be Patient::`n
Blockinput, on
if (GetKeyState("Alt")&&(scextn = "exe"))
	{
		FindName= 1
	}
;;LinkOptions= 
inif= %home%\RJDB.ini
scpini= %scpath%\Game.ini
if fileexist(scpini)
	{
		inif= %scpini%
	}
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")	
READINI:
sect= GENERAL|JOYSTICKS
Loop,parse,sect,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		section= %A_LoopField%
		IniRead,rjtbl,%inif%,%section%
		Loop,parse,rjtbl,`n`r
			{
				stringsplit,fi,A_LoopField,=
				iniread,vi,%inif%,%section%,%fi1%
				if (vi = "ERROR")
					{
						vi= 
					}
				if (vi <> "")
					{
						%fi1%= %vi%
					}
			}
	}
if fileexist(Install_Directory . "\" . Exe_file)
	{
		gamepath= %Install_Directory%\%Exe_file%
	}
if (gamepath = "")
	{
		FileGetShortcut,%plink%,gamepath,,,gamealtpth
		if instr(gamepath,"jkvtx")
			{
				gamepvm=%gamealtpath%
				if instr(gamepvm,A_Space . "")
					{
						splitpath,gmsx,gamepvm,%A_Space%
						Loop,%gmsx0%
							{
								jjh:= % A_Index
								if instr(jjh,":")
									{
										stringreplace,gamepvm,gamepvm,%jjh%,,	
										gamepvm.= %gamealtpath%
										break
									}
								stringreplace,gamepvm,gamepvm,%jjh%,,	
							}
					}
				if instr(gamepvm,"" . A_Space)
					{
						stringreplace,gamepvm,gamepvm,"%A_Space%,,All   
						;"
					}	
				if fileexist(gamepvm)
					{
						gamepath= %gamepvm%
					}
			}
	}
if (MULTIMONITOR_TOOL <> "")
	{
		splitpath,multimonitor_tool,mmtof,mmpath
	}
Loop, 4
	{
		stringleft,dhf,LinkOptions,1
		if ((dhf = A_Space)or(dhf = A_Tab))
			{
				stringtrimleft,linkoptions,linkoptions,1
			}
		stringright,dhg,LinkOptions,1
		if ((dhg = A_Space)or(dhg = A_Tab))
			{
				stringtrimright,linkoptions,linkoptions,1
			}
	}
	
linkoptions:= A_Space . LinkOptions

IniRead,rjtgl,%INIF%,CONFIG
if (MONH = "")
	{
		MONH= %A_ScreenHeight%
	}	
if (MONW = "")	
	{
		MONW= %A_ScreenWidth%
	}
stringreplace,rjtgl,rjtgl,[XRZ],%MonW%,All
stringreplace,rjtgl,rjtgl,[YRZ],%MonH%,All
Loop,parse,rjtgl,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		varit= %A_LoopField%
		Loop,6
			{
				dpro=
				dus= 
				stringsplit,fi,varit,=
				if instr(fi1,"extapp")
					{
						iniread,vi,%inif%,CONFIG,%fi1%
						dpro:= % extapp%A_Index%
						stringreplace,rjtgl,rjtgl,[extapp%A_Index%],%dpro%,All
					}
			}
	}
/*	
if (Run_Options = "")
	{
		Run_Options:= A_Space
	}
if (Run_Arguments = "")
	{
		Run_Arguments:= A_Space
	}
*/
Loop,10
	{
		kvl:= A_Index + 1
		arin= %A_Index%
		DSPI:= % DISPLAY%A_Index%
		DSPN:= % DISPLAY%kvl%
		vpr:= % extapp%A_Index%		
		stringreplace,rjtgl,rjtgl,[disp%A_Index%],%DSPI%,All
		stringreplace,rjtgl,rjtgl,[disp%kvl%],%DSPN%,All
		stringreplace,rjtgl,rjtgl,[extapp%A_Index%],%vpr%,All
	}
Loop,parse,rjtgl,`n`r
	{	
		ein= %A_LoopField%
		stringsplit,fn,ein,=
		stringreplace,evi,ein,%fn1%=,,All
		if ((evi <> "")&&(evi <> "ERROR"))
			{
				%fn1%= %evi%
			}
	}
if (disprogd = 1)
	{
		mmpath= %multimonitor_path%
		if (multimonitor_path = "")
			{
				splitpath,MultiMonitor_Tool,,mmpath
			}
	}
if (scextn = "lnk")
	{
		FileGetShortcut, %plink%, plfp, pldr, plarg
		if (plarg <> "")
			{
				plarg:= A_Space . plarg
				/*
				if (Run_Options <> A_Space)
					{
						LinkOptions.= Run_Options . A_Space
					}
				if (Run_Arguments <> A_Space)
					{
						plarg.= A_Space . Run_Arguments
					}
				*/	
			}
	}
	else {
		plfp= %plink%
		splitpath,plfp,,pldr,,plfname
		/*
		if (Run_Arguments <> A_Space)
			{
				plarg:= A_Space . Run_Arguments
			}
		*/	
	}
splitpath,plfp,pfilef,pfdir,plxtn,plnkn
tempn= %gmname%	
if (FindName = 1)
	{
		gosub, NameTuning
		GoSub, AltKey
	}
	else {
		gmnamex= %tempn%
	}
if (Game_Profile = "")
	{
		Game_Profile= %scpath%\Game.ini
		Game_Profiles= %scpath%
		ifnotexist,%game_profile%
			{
				Game_Profile= %GAME_PROFILES%\%gmnamex%\game.ini
				Game_Profiles= %Game_Profiles%\%gmnamex%
				
				}
	}
if (fileexist(Game_Profile)&&(gbar <> 1))
	{
		gbar = 1
		inif= %Game_Profile%
		Tooltip,::Please Be Patient::`nReading Configuration
		goto, readini
	}
else {
	if !fileexist(Game_Profile)
		{			
			gosub, NameTuning
			gosub, SetupINIT
		}
}
SplitPath,Player1,Pl1file,pl1pth,pl1ext,pl1fnm
SplitPath,Player2,Pl2file,pl2pth,pl2ext,pl2fnm
SplitPath,MediaCenter_Profile,MCP1file,MCP1pth,MCP1ext,MCP1fnm
SplitPath,MediaCenter_Profile2,MCP2file,MCP2pth,MCP2ext,MCP2fnm

SplitPath,Player1_Template,Pt1file,pt1pth,pt1ext,pt1fnm
SplitPath,Player2_Template,Pt2file,pt2pth,pt2ext,pt2fnm
SplitPath,MediaCenter_Template,MCTfile,MCTpth,MCText,MCTfnm
MediaCenter_Profile1=%MediaCenter_Profile%
if ((Player1 = "")or !fileExist(Player1))
	{
		Player1= %scpath%\%gmnamex%.%mapper_extension%
	}
if ((MediaCenter_Profile = "")!fileExist(MediaCenter_Profile))
	{
		MediaCenter_Profile= %scpath%\MediaCenter.%mapper_extension%
	}
Loop, 16
	{
		nts:= % Player%A_Index%
		rnt:= % Mediacenter_Profile%A_Index%
		if ((nts = "")or !fileExist(nts))
			{
				Player%A_Index%VX= %scpath%\%gmnamex%.%mapper_extension%
			}
		if ((rnt = "")or !fileExist(rnt))
			{
				MediaCenter_Profile%A_Index%VX= %scpath%\MediaCenter_%A_Index%.%mapper_extension%
			}
	}
PRERUNORDER=PRE_1|PRE_MON|PRE_MAP|PRE_2|PRE_3|PRE_BGP|BEGIN
/*	
PRERUNORDERPROC:
*/
acwchk=
Loop,parse,PRERUNORDER,|
	{
		if (A_Loopfield = "")
			{
				continue
			}
			gosub, %A_LoopField%
		}
return

		
PRE_1:		
stringsplit,prestk,1_Pre,<
stringright,lnky,prestk2,4
runhow= 
wscrop=
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		prearun= 
		if (instr(prestk2,".vbs") or instr(prestk2,".vbe") or instr(prestk2,".wsf") or instr(prestk2,".wsc"))
			{
				prearun:= "wscript" . A_Space
				wscrop:= A_Space . "/b" . "/nologo"
			}
		if (instr(prestk2,".ps1")or instr(prestk2,".psd"))
			{
				prearun:= "powershell" . A_Space
			}
		prearun.= prestk2
		if (instr(prestk1,"H")&& (runhow = ""))
			{
				runhow= hide
			}	
		if fileexist(prestk2)
			{
				if instr(prestk1,"W")
					{
						RunWait,%prearun%%wscrop%,%A_ScriptDir%,%runhow%,preapid
					}
					else {
						Run,%prearun%%wscrop%,%A_ScriptDir%,,preapid	
					}
				iniwrite,%preapid%,%home%/rjpids.ini,1_Pre,pid
			}
		if (prestk2 = "CLOUD")
			{
				;gosub, PRECLOUD
			}
	}
return	

PRE_BGP:
GMGDBCHK= %gmnamex%	
Tooltip, Configuration Created`n:::running %gmnamx% preferences:::
if (fileexist(Borderless_Gaming_Program)&&(Borderless_Gaming_Program <> "")&&(BGP_State <> 0)&&(BGP_State <> ""))
	{
		splitpath,Borderless_Gaming_Program,bgpexe,bgpdir
		process,exist,%Borderless_Gaming_Program%
		bgpid= %errorlevel%
		if ((errorlevel = 0)or instr(Borderless_Gaming_Program,"portable"))
			{
				process, exist, BorderlessGaming.exe
				bgpid= %errorlevel%
			}			
		if ((BGP_State = 1)or(BGP_State = 6)or(BGP_State = 9)or(BGP_State = 14))
			{
				if (bgpid = 0)
					{
						Run, "%Borderless_Gaming_Program%",%bgpdir%,,bgpid
						sleep, 1200
						if instr(Borderless_Gaming_Program,"portable")
							{
								SB_SetText("Enabling Borderless-Gaming")
								process, wait, "BorderlessGaming.exe", 5
								bgpidx= %errorlevel%
							}
					}
			}
			else {
				process,close,%bgpexe%
				process,close,%bgpid%
				process,close,%bgpidx%
				process,close,BorderlessGaming.exe
			}
	}
	else {
		if ((bgpid <> 0)&&((BGP_State = 5)or(BGP_State = 8)))
			{
				splitpath,Borderless_Gaming_Program,bgpexe,bgpdir
				process,exist,%Borderless_Gaming_Program%
				bgpid= %errorlevel%
				if instr(Borderless_Gaming_Program,"portable")
					{
						process, exist, "BorderlessGaming.exe"
						bgpidX= %errorlevel%
						process,close,%bgpidx%
						process,close,BorderlessGaming.exe
					}
				process,close,%bgpexe%
				process,close,%bgpid%
			}
	}
	
return


PRE_MON:
if (MonitorMode > 0)
	{
		alir= %home%\devlist.cmd
		filedelete,%home%\cv.tmp
		filedelete,%home%\cr.tmp
		filedelete,%home%\tst.tmp
		filedelete,%alir%
		fileappend,echo off`n,%home%\%alir%
		RunWait, "%multimonitor_tool%" /saveconfig %home%\tst.tmp,%home%,hide
		RunWait, "%multimonitor_tool%" /scomma %home%\cr.tmp,%home%,hide
		fileappend,for /f "tokens=1`,6`,8`,11`,12`,13`,17`,19`,20 delims=`," `%`%a in ('type "%home%\cr.tmp"') do if "`%`%~a" NEQ "Resolution" echo."`%`%~a|`%`%~b|`%`%~c|`%`%~d|`%`%~e|`%`%~f|`%`%~g|`%`%~h|`%`%~i|`%`%~j|`%`%~k" >>"%home%\cv.tmp",%home%\devlist.cmd
		runwait,%alir%,,hide
		fileread,inff,%home%\cv.tmp
		filedelete,%alir%
		filedelete,%home%\cr.tmp
		filedelete,%home%\cv.tmp
		vein= 
		miny=
		Loop,parse,inff,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				miny+=1
				stringsplit,ebw,A_LoopField,|
				stringsplit,abk,ebw7,\
				dispn%miny%= %abk2%|%ebw7%
			}
		mon_sel=
		abn= 0
		Loop,7
			{
				iniread,monid,%MM_Game_Config%,MONITOR%ABN%,Monitorid
				if (monid = "ERROR")
					{
						abn+=1
						continue
					}
				stringsplit,monix,monid,\
				Loop,7
					{
						dspx:= % dispn%A_Index%
						stringsplit,gkh,dspx,|
						if (monix2 = gkh1)
							{
								iniwrite,%gkh2%,%MM_Game_Config%,MONITOR%ABN%,MonitorID
								inidelete,%MM_Game_Config%,MONITOR%ABN%,Name
								break
							}
					}
				abn+=1	
			}
		abn= 0
		Loop,7
			{
				iniread,monid,%MM_MediaCenter_Config%,MONITOR%ABN%,Monitorid
				if (monid = "ERROR")
					{
						abn+=1
						continue
					}
				stringsplit,monix,monid,\
				Loop,7
					{
						dspx:= % dispn%A_Index%
						stringsplit,gkh,dspx,|
						if (monix2 = gkh1)
							{
								iniwrite,%gkh2%,%MM_MediaCenter_Config%,MONITOR%ABN%,MonitorID
								inidelete,%MM_MediaCenter_Config%,MONITOR%ABN%,Name
								break
							}
					}
				abn+=1	
			}	
		Tooltip,
		WinGet, WindowList, List
		Loop, %WindowList%
			{
				WinMinimize, % "ahk_id " . WindowList%A_Index%
			}
		Send {LCtrl Down}&{LAlt Down}&B	
		Send {LCtrl Up}&{LAlt Up}
		if (instr(MULTIMONITOR_TOOL,"multimonitortool") && fileexist(multimonitor_tool) && fileexist(MM_Game_Config))
			{
				RunWait,%MultiMonitor_Tool% /LoadConfig "%MM_Game_Config%",%mmpath%,hide,mmpid
			}
		else {
				Run,%MultiMonitor_Tool%,%mmpath%,hide,mmpid
			}
		iniwrite,%mmpid%,%curpidf%,MultiMonitor_Tool,pid
	}
sleep, 1200
return

PRE_JAL:
stringsplit,prestk,JustAfterLaunch,<
PRESA= %prestk1%
jalprog=
wscrop=
if (instr(prestk1,".vbs") or instr(prestk1,".vbe") or instr(prestk1,".wsf") or instr(prestk1,".wsc"))
	{
		jalprog:= "wscript" . A_Space
		wscrop:= A_Space . "/b" . A_Space . "/nologo"
	}
if (instr(prestk1,".ps1")or instr(prestk1,".psd"))
	{
		jalprog:= "powershell" . A_Space
	}
if (prestk2 <> "")
	{
		jalprog.= prestk2
	}	
if (prestk2 = "")
	{
		presA= 
		jalprog.= prestk1
	}
stringright,lnky,jalprog,4
runhow= 
if (jalprog <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		if (instr(prestk1,"H")&& (runhow = ""))
			{
				runhow= hide
			}
		if fileexist(prestk2)
			{
				if instr(presA,"0")
					{
						runhow= hide
					}
				if instr(presA,"W")
					{
						RunWait,%jalprog%%wscrop%,%A_ScriptDir%,%runhow%,jalpid
						return
						;goto, premapper
					}
				Run,%jalprog%%wscrop%,%A_ScriptDir%,%runhow%,jalpid
				iniwrite,%jalpid%,%curpidf%,JustAfterLaunch,pid
			}	
	}
return

PRE_2:
stringsplit,prestk,2_Pre,<
stringright,lnky,prestk2,4
runhow= 
wscrop=
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		prebrun= 
		if (instr(prestk2,".vbs") or instr(prestk2,".vbe") or instr(prestk2,".wsf") or instr(prestk2,".wsc"))
			{
				prebrun:= "wscript" . A_Space
				wscrop:= A_Space . "/b" . A_Space . "/nologo"
			}
		if (instr(prestk2,".ps1")or instr(prestk2,".psd"))
			{
				prebrun:= "powershell" . A_Space
			}
		prebrun.= prestk2
		if (instr(prestk1,"H")&& (runhow = ""))
			{
				runhow= hide
			}	
		if fileexist(prestk2)
			{
				if instr(prestk1,"W")
					{
						RunWait,%prebrun%%wscrop%,%A_ScriptDir%,%runhow%,prebpid
						;goto,postmapper
						return
					}
				Run,%prebrun%%wscrop%,%A_ScriptDir%,%runhow%,prebpid
				iniwrite,%prebpid%,%curpidf%,2_Pre,pid
			}
		if (prestk2 = "CLOUD")
			{
				;gosub, PRECLOUD
			}
	}
return

killmapper:
process,close,%mapperxn%
sleep,600
return

PRE_MAP:
premapper:	
Mapper_Extension:= % Mapper_Extension
if ((Mapper > 0)&&(Mapper <> "")or(RESETJOY = 1))
	{
		ToolTip,Running %gmnamx% preferences`n:::Loading Joystick Configurations:::
		Loop, 16
			{
				player%A_Index%n=
				player%A_Index%t=
			}
		gosub, joytest
		RESETJOY=	
		if (JMap = "joytokey")
			{
				player2t:= A_Space . "" . Game_profiles . "\" . gmnamex . ""
				splitpath,joytokey_executable,mapperxn,mapperp
				gosub,killmapper
			}
		if (JMap = "xpadder")
			{
				splitpath,xpadder_executable,mapperxn,mapperp
				gosub,killmapper
			}
		if (JMap = "antimicro")
			{
				splitpath,antimicro_executable,mapperxn,mapperp
				gosub,killmapper
			}
		if (JMap = "JoyXoff")
			{
				splitpath,JoyXoff_executable,mapperxn,mapperp
				Run, "%JoyXoff_executable%" -close,%mapperp%,hide
				Run, %comspec% /c "" taskkill /f /im "JoyxSvc.exe",,hide
				process,close,JoyxXvc.exe
				gosub,killmapper
				player2t:= A_Space . "" . gamepath . ""
				player3t:= A_Space . "" . gmname . ""
				sleep,600
				Run,%joyxpth%\JoyxSvc.exe,%mapperp%,hide 
			}
		JOYMESSAGE= Joysticks: %JOYCOUNT%
		ToolTip, %JoyCount% Joysticks found
		JoyAsk:
		if ((JoyCount = 0)or if (JoyCount = ""))
			{
				if (joyrtry <> "")
					{
						if (joyrtry > 1)
							{
								Blockinput, off
								Msgbox,4610,CONTROLLERS,Polling the Joysticks again in %joyrtry% seconds,%joyrtry%
								ifmsgbox, Abort
									{
										iniwrite,0,%inif%,JOYSTICKS,MAPPER
										Blockinput, on
										return
									}
								ifmsgbox,Retry
									{
										Blockinput, on
										bretrt:
										if (joyrtry > 40)
											{
												joyrtry= 
												goto, PopCont
											}
										gosub, JoyTest
										if ((joycount = 0) or if (joycount = ""))
											{
												joyrtry+= 10
												goto,bretrt
											}
										goto, ContinueJoy
									}
								ifmsgbox, Ignore
									{
										Blockinput, on
										goto, ContinueJoy
									}
							}
					}
				PopCont:
				BlockInput, off
				Msgbox,4610,CONTROLLERS,CLick "Abort" to Disable Joysticks or "Ignore" to dismiss this prompt,3
				ifmsgbox, Abort
					{
						iniwrite,0,%inif%,JOYSTICKS,MAPPER
						Blockinput, on
						return
					}
				ifmsgbox,Retry
					{
						gosub, JoyTest
						if ((JoyCount = 0)or if (JoyCount = ""))
							{
								joyrtry+= 10
								goto,JoyAsk
							}
					}
				ifmsgbox, Ignore
					{
						Blockinput, on
						goto, ContinueJoy
					}
			}
		ContinueJoy:
		if (fileexist(keyboard_Mapper)&& fileexist(player1))
			{
				Run,%Keyboard_Mapper% "%player1%"%player2t%%player3t%%player4t%,%mapperp%,hide,kbmp
			}
		Loop,5
			{
				Process,Exist,%mapperp%
				if ((errorlevel <> 0)&&(errorlevel = kbmp))
					{
						Tooltip,"`n...   ...loading keyboard mapper...   ...`n"
						enfd= %errorlevel%
						break
					}
				else {
					Tooltip,"`n...   ...loading keyboard mapper...   ...`n"
				}				
				Sleep,500
			}
		iniwrite,%JoyCount%,%curpidf%,Mapper,connected
		iniwrite,%kbmp%,%curpidf%,Mapper,pid
	}
if (Logging = 1)
	{
		fileappend,`n#####`n%Keyboard_Mapper% "%player1%"%player2t%%player3t%%player4t%`npid=%kbmp%`n#####`n,%home%\log.txt
	}
return

PRE_3:
stringsplit,prestk,3_Pre,<
stringright,lnky,prestk2,4
runhow= 
wscrop=
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		precrun= 
		if (instr(prestk2,".vbs") or instr(prestk2,".vbe") or instr(prestk2,".wsf") or instr(prestk2,".wsc"))
			{
				precrun:= "wscript" . A_Space
				wscrop:= A_Space . "/b" . A_Space . "/nologo"
			}
		if (instr(prestk2,".ps1")or instr(prestk2,".psd"))
			{
				precrun:= "powershell" . A_Space
			}
		precrun.= prestk2
		if fileexist(prestk2)
			{	
				if (instr(prestk1,"H")&& (runhow = ""))
					{
						runhow= hide
					}
				if instr(prestk1,"W")
					{
						RunWait,%precrun%%wscrop%,%A_ScriptDir%,%runhow%,precpid
						;goto,postmapper
						return
					}
				Run,%precrun%%wscrop%,%A_ScriptDir%,%runhow%,precpid
				iniwrite,%precpid%,%curpidf%,3_Pre,pid
			}
		if (prestk2 = "CLOUD")
			{
				;gosub, PRECLOUD
			}
	}
return

begin:
ToolTip,Loading %gmnamex%`n%JOYMESSAGE%
if (nrx > 2)
	{
		Tooltip,reload exceeded marker`nBe sure you have the launched executable in the exe_list for this game.
		goto, givup
	}
Blockinput, Off	
ToolTip
tvi= %plfp%%linkoptions%%plarg%
gosub,TransformVarInput
Run, %tvo%,%pldr%,max UseErrorLevel,dcls
nerlv= %errorlevel%
Tooltip,%JOYMESSAGE%
Process, Exist, %bgmexe%

bgl:	
Tooltip, :::getting ancilary exes:::`n%JOYMESSAGE%
apchkn=
appcheck:
sleep, 1000
Loop,parse,exe_list,|
	{
		apchkn+=1
		if (A_LoopField = "")
			{
				continue
			}
		process,exist,%A_LoopField%
		erahkpid= %errorlevel%
		if (erahkpid <> 0)
			{
				break
			}
		if (apchkn > 10)
			{
				Tooltip,
				goto,appcheck
			}
	}
Tooltip,%JOYMESSAGE%
WinActivate
if (Hide_Taskbar <> 0)
	{
		WinHide, ahk_class Shell_TrayWnd
		WinHide, ahk_class Shell_SecondaryTrayWnd
	}
Tooltip,%JOYMESSAGE%
if (JustAfterLaunch <> "")
	{
		gosub, PRE_JAL
	}
if (instr(prestk1,"borderlessgaming")or instr(prestk2,"borderlessgaming")or instr(prrestk3,"borderlessgaming"))
	{
		sleep,1500
		if process,exist,borderlessgaming.exe
			{
				send #f6
			}
	}
BlockInput,Off
Tooltip,
iniwrite,%erahkpid%,%curpidf%,Current_Game,pid
process,WaitClose, %erahkpid%	
AppClosed:
if ((nerlv = 1234)or(gii = 1))
	{
		goto, givup
	}
ToolTip, Disabling Keyboard`n:::Please be patient:::
BlockInput, On
nrx+=1
goto, begin
return
Ctrl & f2::
process,close,%dcls%
ToolTip,Closing
process, close, %pfilef%
if (exe_list <> "")
	{
		Loop,parse,exe_list,|
			{
				process,close,%A_LoopField%
			}
		Tooltip,
	}
dcls= 
nrx=
return

^!+f9::
Run, NewOsk.exe
Return

Ctrl & f10::
Sleep, 1000
CWIN:= GetKeyState("LWin")
if (CWIN = 1)
	{
		playerVX=
		joypartX=
		Loop,16
			{
				if (3 >= A_Index)
					{
						continue
					}
				player%A_Index%= 0
				player%A_Index%X=
				player%A_Index%t=
				player%A_Index%n=
				joyPart%A_Index%=
				MediaCenter_Profile_%A_Index%=
				MediaCenter_Profile_%A_Index%t=
			}
		RESETJOY= 1	
		joycount:= 0
		gosub killmapper
		if (mapperp = "antimicro")
			{
				AmicroSize:= "@Size(700 400)"
				AmicroPos:= "@Point(100 100)"
				AmicroTray=0
				AmicroTB=1
				AmicroAP=0
				iniwrite,%AmicroPos%,%localappdata%\antimicro\antimicro_settings.ini,GENERAL,WindowPosition
				iniwrite,%AmicroSize%,%localappdata%\antimicro\antimicro_settings.ini,GENERAL,WindowSize
				iniwrite,%AmicroTray%,%localappdata%\antimicro\antimicro_settings.ini,GENERAL,LaunchInTray
				iniwrite,%AmicroTB%,%localappdata%\antimicro\antimicro_settings.ini,GENERAL,MinimizeToTaskbar
				iniwrite,%AmicroAP%,%localappdata%\antimicro\antimicro_settings.ini,AutoProfiles,AutoProfilesActive
				iniwrite,0,%localappdata%\antimicro\antimicro_settings.ini,DefaultAutoProfileAll,Active
			}
		gosub PRE_MAP
		if (joycount > 0)
			{
				MAPPER= 1
			}
		blockinput,on
		Send {RWin Up}
		Send {LWin Up}
		Send {RCtrl Up}
		Send {LCtrl Up}
		DetectHiddenWindows, On
		if (mapperp = "antimicro")
			{
				WinGet, vWinList, List, ahk_class Qt5QWindowIcon
				;vOutput := ""
				Loop, % vWinList
					{
						hWnd := vWinList%A_Index%
						WinGetTitle, vWinTitle, % "ahk_id " hWnd
						WinGetClass, vWinClass, % "ahk_id " hWnd
						WinGet, vPID, PID, % "ahk_id " hWnd
						WinGet, vWinStyle, Style, % "ahk_id " hWnd
						WinGet, vWinExStyle, ExStyle, % "ahk_id " hWnd
						vWinStyle := Format("0x{:08X}", vWinStyle)
						vWinExStyle := Format("0x{:08X}", vWinExStyle)
						;vOutput .= vWinTitle "|" vWinStyle "|" vWinExStyle "`r`n"
					}
				blockinput,off
				ToolTip,
				if !DllCall("user32\IsWindowVisible", Ptr,hWnd)
					{
						PostMessage, 0x8065, 0, 0x203,, ahk_class %vWinClass%
						PostMessage, 0x0112, 0xF120,,, %vWinTitle%
						PostMessage, 0x8065, 0, 0x0203,, ahk_class %vWinClass%
						PostMessage, 0x8065, 0, 0x400,, ahk_class %vWinClass%
						PostMessage, 0x8065, 0, 0x0400,, ahk_class %vWinClass%
						WinShow, antimicro ahk_class %vWinClass%
						WinActivate, antimicro ahk_class %vWinClass%
						WinRestore, antimicro ahk_class %vWinClass%
					}
			}
	}	
return	
	

Ctrl & f8::
nosave= 1
Sleep, 1000
CWIN:= GetKeyState("LWin")
if (CWIN = 0)
	{
		nosave=
		return
	}
goto,givup
Ctrl & f12::
nosave= 
Tooltip,Keyboard / Mouse are disabled`n:::Please be patient:::
givup:
Tooltip,...Quitting...
gii= 1
Quitout:
Blockinput,On

POSTRUNORDER=POST_BGP|POST_MON|POST_JBE|LOGOUT|POST_1|POST_MAP|POST_2|POST_3
/*	
POSTRUNORDERPROC:
*/
acwchk=
Loop,parse,POSTRUNORDER,|
	{
		if (A_Loopfield = "")
			{
				continue
			}
			gosub, %A_LoopField%
		}
if (Hide_Taskbar <> 0)
	{		
		WinShow, ahk_class Shell_TrayWnd
		WinShow, ahk_class Shell_SecondaryTrayWnd		
	}
if (instr(prestk1,"borderlessgaming")or instr(prestk2,"borderlessgaming")or instr(prrestk3,"borderlessgaming"))
	{
		process,close,borderlessgaming.exe
	}
if fileexist(curpidf)
	{
		filedelete,%curpidf%
	}
ExitApp

POST_JBE:
if (nosave = 1)
	{
		Tooltip,shutting down game`n:::Aborting Settings
		return
	}
Tooltip,shutting down game`n:::Writing Settings
stringsplit,prestk,JustBeforeExit,<
PRESA= %prestk1%
jbeprog= 
wscrop=
if (instr(prestk1,".vbs") or instr(prestk1,".vbe") or instr(prestk1,".wsf") or instr(prestk1,".wsc"))
	{
		jbeprog:= "wscript" . A_Space
		wscrop:= A_Space . "/b" . A_Space . "/nologo"
	}
if (instr(prestk1,".ps1")or instr(prestk1,".psd"))
	{
		jbeprog:= "powershell" . A_Space
	}
if (prestk2 <> "")
	{
		jbeprog.= prestk2
	}
if (prestk2 = "")
	{
		presA= 
		jbeprog.= prestk1
	}
stringright,lnky,jbeprog,4
runhow= 
if (jbeprog <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%jbeprog%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		if fileexist(jbeprog)
			{
				if instr(presA,"0")
					{
						runhow= hide
					}
				if instr(presA,"W")
					{
						ToolTip,
						;goto,LOGOUT
						;return
					}
				Run,%jbeprog%%wscrop%,%A_ScriptDir%,%runhow%,jbepid	
				iniwrite,%jbepid%%wscrop%,%curpidf%,JustBeforeExit,pid
			}
	}
return


POST_1:
if (nosave = 1)
	{
		Tooltip,shutting down game`n:::Aborting Settings
		return
	}
stringsplit,prestk,1_Post,<
stringright,lnky,prestk2,4
runhow= 
wscrop=
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		pstarun= 
		if (instr(prestk2,".vbs") or instr(prestk2,".vbe") or instr(prestk2,".wsf") or instr(prestk2,".wsc"))
			{
				pstarun:= "wscript" . A_Space
				wscrop:= A_Space . "/b" . A_Space . "/nologo"
			}
		if (instr(prestk2,".ps1")or instr(prestk2,".psd"))
			{
				pstarun:= "powershell" . A_Space
			}
		pstarun.= prestk2
		if fileexist(prestk2)
			{
				if (instr(prestk1,"H")&& (runhow = ""))
					{
						runhow= hide
					}
				if instr(prestk1,"W")
					{
						RunWait,%pstarun%%wscrop%,%A_ScriptDir%,%runhow%,postapid
						;goto,postmapper
						return
					}
				Run,%pstarun%%wscrop%,%A_ScriptDir%,%runhow%,postapid
			}
		if (prestk2 = "CLOUD")
			{
				gosub, POSTCLOUD
			}
	}
return

POST_MAP:	
if ((Mapper > 0)&&(Mapper <> ""))
	{
		ToolTip,Please Be Patient`n:::Reloading Mediacenter/Desktop Profiles:::
		if (nosave = 1)
			{
				tooltip,''page_up'' detected`n.Saving aborted.
				gosub, joytest
			}
		joycount= 	
		gosub, joytest
		if (JMap = "joytokey")
			{
				player2t:= A_Space . "" . Game_profiles . "\" . gmnamex . ""
				splitpath,joytokey_executable,mapperxn,mapperp
				gosub,killmapper
			}
		if (JMap = "xpadder")
			{
				splitpath,xpadder_executable,mapperxn,mapperp
				gosub,killmapper
			}
		if (JMap = "antimicrox")
			{
				splitpath,antimicrox_executable,mapperxn,mapperp
				gosub,killmapper
			}
		if (JMap = "antimicro")
			{
				splitpath,antimicro_executable,mapperxn,mapperp
				gosub,killmapper
			}
		if (JMap = "JoyXoff")
			{
				splitpath,JoyXoff_executable,mapperxn,mapperp
				Run, "%JoyXoff_executable%" -close,%mapperp%,hide
				Run, %comspec% /c "" taskkill /f /im "JoyxSvc.exe",,hide
				process,close,JoyxXvc.exe
				gosub,killmapper
				player2t:= A_Space . "" . gamepath . ""
				player3t:= A_Space . "" . gmname . ""
				sleep,600
				Run,%joyxpth%\JoyxSvc.exe,%mapperp%,hide 
			}
		ToolTip, %joycount% Joysticks found
		savemap:
		if (fileexist(keyboard_Mapper)&& fileexist(mediacenter_profile))
			{
				Run, %Keyboard_Mapper% "%MediaCenter_Profile%"%MediaCenter_Profile_2t%%MediaCenter_Profile_3t%%MediaCenter_Profile_4t%,,hide,kbmp
				if (Logging = 1)
					{
						fileappend,%Keyboard_Mapper% "%MediaCenter_Profile%"%MediaCenter_Profile_2t%%MediaCenter_Profile_3t%%MediaCenter_Profile_4t%,%home%\log.txt
					}
			}
		Loop,5
			{
				Process,Exist,%mapperp%
				if ((errorlevel <> 0)&&(errorlevel = kbmp))
					{
						enfd= %errorlevel%
						break
					}
				Sleep,500
			}
		if (nosave = 1)
			{
				goto, Logout
			}
	}
 
if (Logging = 1)
	{
		FileAppend,Run="%plfp%[%linkoptions%|%plarg%]in%pldr%"`nkeyboard=|%Keyboard_Mapper% "%player1%"%player2t%%player3t%%player4t%|`njoycount1="%JoyCount%"`n%Keyboard_Mapper% "%MediaCenter_Profile%"%MediaCenter_Profile_2t%%MediaCenter_Profile_3t%%MediaCenter_Profile_4t%`njoycount2=%joycount%`n`n,%home%\log.txt
	} 	
iniwrite,%KeyBoard_Mapper%,%inif%,JOYSTICKS,KeyBoard_Mapper
iniwrite,%Jmap%,%inif%,JOYSTICKS,Jmap
iniwrite,%Mapper_Extension%,%inif%,JOYSTICKS,Mapper_Extension
iniwrite,%MAPPER%,%inif%,GENERAL,Mapper
Tooltip,Reloading Profiles`n:::shutting down game:::
return


POST_2:
if (nosave = 1)
	{
		Tooltip,shutting down game`n:::Aborting Settings
		return
	}
stringsplit,prestk,2_Post,<
stringright,lnky,prestk2,4
runhow= 
wscrop=
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		pstbrun= 
		if (instr(prestk2,".vbs") or instr(prestk2,".vbe") or instr(prestk2,".wsf") or instr(prestk2,".wsc"))
			{
				pstbrun:= "wscript" . A_Space
				wscrop:= A_Space . "/b" . A_Space . "/nologo"
			}
		if (instr(prestk2,".ps1")or instr(prestk2,".psd"))
			{
				pstbrun:= "powershell" . A_Space
			}
		pstbrun.= prestk2
		if (instr(prestk1,"H")&& (runhow = ""))
			{
				runhow= hide
			}		
		if fileexist(prestk2)
			{
				if instr(prestk1,"W")
					{
						RunWait,%pstbrun%%wscrop%,%A_ScriptDir%,%runhow%,postBpid
						;goto,postmapper
						return
					}
				Run,%prestk2%%wscrop%,%A_ScriptDir%,%runhow%,postbpid
			}
		if (prestk2 = "CLOUD")
			{
				gosub, POSTCLOUD
			}
	}
return

POST_BGP:
if ((Borderless_Gaming_Program <> "")&&(BGP_State > 4))
	{
		splitpath,Borderless_Gaming_Program,bgpexe,bgpdir
		process,exist,%Borderless_Gaming_Program%
		bgpid= %errorlevel%
		process,close,%bgpexe%
		process,close,%bgpid%
		if instr(Borderless_Gaming_Program,"portable")
			{
				process, exist, "BorderlessGaming.exe"
				bgpidX= %errorlevel%
				process,close,%bgpidx%
				process,close,BorderlessGaming.exe
			}
	}
return

POST_MON:
if (MonitorMode > 0)
	{
		if (instr(MULTIMONITOR_TOOL,"multimonitortool") fileexist(multimonitor_tool) && fileexist(MM_MediaCenter_Config))
			{
				if (nosave = "")
					{
						Run, %MultiMonitor_Tool% /SaveConfig "%MM_Game_Config%",%mmpath%,hide,dsplo
					}
				Run, %MultiMonitor_Tool% /LoadConfig "%MM_MediaCenter_Config%",%mmpath%,hide,dsplo
			}
		else {
			Run, %Multimonitor_Tool%,%mmpath%,hide,dsplo
		}	
	}
if (nosave = 1)
	{
		goto monsave
	}
iniwrite,%MONITORMODE%,%inif%,GENERAL,MonitorMode
iniwrite,%disprogw%,%inif%,GENERAL,disprogw
iniwrite,%MM_MEDIACENTER_Config%,%inif%,CONFIG,MM_MEDIACENTER_Config
iniwrite,%MultiMonitor_Tool%,%inif%,GENERAL,MultiMonitor_Tool
monsave:
sleep, 1000
Process,close,dsplo
Loop,20
	{
		process,close,vp%A_index%
		process,close,hp%A_index%
	}
Send {LCtrl Down}&{LAlt Down}&K
Send {LCtrl Up}&{LAlt Up}
return


POST_3:
if (nosave = 1)
	{
		Tooltip,shutting down game`n:::Aborting Settings
		return
	}
stringsplit,prestk,3_Post,<
stringright,lnky,prestk2,4
runhow= 
wscrop=
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		pstcrun= 
		if (instr(prestk2,".vbs") or instr(prestk2,".vbe") or instr(prestk2,".wsf") or instr(prestk2,".wsc"))
			{
				pstcrun:= "wscript" . A_Space
				wscrop:= A_Space . "/b" . A_Space . "/nologo"
			}
		if (instr(prestk2,".ps1")or instr(prestk2,".psd"))
			{
				pstcrun:= "powershell" . A_Space
			}
		pstcrun.= prestk2
		if (instr(prestk1,"H")&& (runhow = ""))
			{
				runhow= hide
			}	
		if fileexist(prestk2)
			{
				if instr(prestk1,"W")
					{
						RunWait,%pstcrun%%wscrop%,%A_ScriptDir%,%runhow%,postcpid
						;goto,postmapper
						return
					}
				Run,%pstcrun%%wscrop%,%A_ScriptDir%,%runhow%,postcpid
			}
		if (prestk2 = "CLOUD")
			{
				gosub, POSTCLOUD
			}
	}
return

POSTCLOUD:
filecreatedir,%Cloud_Drive%
if (GameData <> "")
	{
		CLOUD_Typ:= GameData
		Cloud_SRC= %Cloud_Drive%\%gmname%\CFG		
		gosub,SVTCLOUD
	}
if (SaveData <> "")
	{
		CLOUD_Typ:= SaveData
		Cloud_SRC= %Cloud_Drive%\%gmname%\SAVE
		gosub,SVTCLOUD
	}
return

SVTCLOUD:
Cloud_Local= %Cloud_SRC%
Loop,parse,CLOUD_Typ,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		stringright,baV,A_LoopField,1
		CLDPath= %A_LoopField%
		dcir= %A_LoopField%
		splitpath,A_LoopField,ALPFN,ALPTH
		if instr(ALPFN,"*")
			{
				dcir= %ALPTH%							
			}
		else {
			ALPFN= *
		}
		if ((ALPTH = A_LoopField) or (bav = "\"))
			{
				CLDPath= %ALPTH%
			}
		rootiteratex= %rootiterate%|%Install_Directory%
		Loop,parse,rootiteratex,|
			{
				if instr(CLDPath,A_LoopField)
						{
							stringreplace,CLPTR,CLDPath,%A_LoopField%,,
							Cloud_Local= %Cloud_SRC%\%CLPTR%
							break
						}
			}
		if (LocalLink = 1)
			{
				if !fileExist(Cloud_Local)
					{
						RunWait, %comspec% /c "" mklink /J "%Cloud_Local%" "%CLDPath%",,hide
					}
			}
		else {
				if !fileExist(Cloud_Local)
					{
						FilecreateDir,%Cloud_Local%
					}
		}	
		if fileExist(ALPTH)
			{
				if instr(prestk1,"W")
					{
						Loop, files, %CLDPath%\%ALPFN%,FR
							{
								RunWait, %comspec% /c robocopy "%CLDPath%" "%Cloud_Local%" /E /XO,,hide
							}
					}
				else {
					Run, %comspec% /c robocopy "%CLDPath%" "%Cloud_Local%" /E /XO,,hide
				}	
			}
	}
return	

LOGOUT:	
process,close, %erahkpid%
process,close, %dcls%
process, close, %pfilef%

if (exe_list <> "")
	{
		Loop,parse,exe_list,|
			{
				process,close,%A_LoopField%
			}
	}
Run,%comspec%  /c "" taskkill /f /im "%plnkn%*",,hide
if (Logging = 1)
	{
		fileappend,er=%erahkpid%`ndcls=%dcls%`npfile=%pfile%,%home%\log.txt
	}

WinGet, WindowList, List
Loop, %WindowList%
	{
		WinRestore, % "ahk_id " . WindowList%A_Index%
	}
return

nonmres:
FileRead,bgm,Borderless_Gaming_Program
if (instr(bgm,GMGDBCHK)&& fileexist(Borderless_Gaming_Program))or (instr(bgm,gmname)&& fileexist(Borderless_Gaming_Program))
	{
		splitpath,Borderless_Gaming_Program,bgmexe,BGMLOC
			{
				Process,exist,%bgmexe%
				if (errorlevel = 0)	
					{
						Run, %Borderless_Gaming_Program%,%BGMLOC%,hide,bgpid
					}
					else {
						bgpid= %errorlevel%
					}
				if (acwchk = 1)
					{
						return
					}
			}
	}
return


TransformVarInput:
stringreplace,tvo,tvi,#!#,|,All
stringreplace,tvo,tvo,{GamePath},%Install_Directory%,All
stringreplace,tvo,tvo,{GameExe},%Exe_File%,All
stringreplace,tvo,tvo,{ProfileDir},%scpath%,All
stringreplace,tvo,tvo,`%programfiles`%,%A_ProgramFiles%,All
stringreplace,tvo,tvo,`%programfilesx86`%,%ProgramFilesx86%,All
stringreplace,tvo,tvo,`%username`%,%A_Username%,All
stringreplace,tvo,tvo,`%Windir`%,%A_Windir%,All
stringreplace,tvo,tvo,`%appdata`%,%A_AppData%,All
stringreplace,tvo,tvo,`%programdata`%,%A_AppDatacommon%,All
stringreplace,tvo,tvo,`%temp`%,%A_Temp%,All
return

;;#####################################################################
AltKey:
Tooltip,!! AltKey Detected !!`nKeyboad/Mouse Disabled`n::Please Be Patient::`n
SetupINIT:
nogmnx= WIN32|WIN64|Game|Win|My Documents|My Games|Windows Games|Shortcuts
nogmne= Launch|Launcher|bat|cmd|exe|Program Files|Program Files (x86)|Windows|Roaming|Local|AppData|Documents|Desktop|%A_Username%|\|/|:|
CreateSetup= 1
iniread,Game_Profiles,%home%\RJDB.ini,GENERAL,Game_Profiles
Game_Profiles= %Game_Profiles%\%gmnamex%
iniread,mapper_extension,%home%\RJDB.ini,JOYSTICKS,mapper_extension
iniread,Game_Directory,%home%\RJDB.ini,GENERAL,Game_Directory
ifnotexist,%GAME_PROFILES%\game.ini
	{
		filecopy,%RJDB_Config%,%GAME_PROFILES%\game.ini
	}
FileCreateDir,%Game_Profiles%
ToolTip, Creating Configurations
FileCreateDir,%Game_Profiles%
Game_Profile= %Game_Profiles%\Game.ini
This_Profile= %Game_Profiles%
player1= %This_Profile%\%gmnamex%.%mapper_extension%
FileCopy,%Player1_Template%,%player1%,
player2= %This_Profile%\%gmnamex%_2.%mapper_extension%
FileCopy,%Player2_Template%,%player2%,
Filecopy,%home%\GameMonitors.mon,%This_Profile%\GameMonitors.mon
Filecopy,%home%\DesktopMonitors.mon,%This_Profile%\DesktopMonitors.mon
Filecopy,%home%\Mediacenter.%mapper_extension%,%This_Profile%\Mediacenter.%mapper_extension%
FileCopy,%home%\RJDB.ini,%This_Profile%\Game.ini
iniwrite,%This_Profile%\DesktopMonitors.mon,%Game_Profile%,CONFIG,MM_MEDIACENTER_Config
iniwrite,%This_Profile%\GameMonitors.mon,%Game_Profile%,CONFIG,MM_Game_Config
iniwrite,%player1%,%Game_Profile%,JOYSTICKS,Player1
iniwrite,%player2%,%Game_Profile%,JOYSTICKS,Player2
iniwrite,%This_Profile%\MediaCenter.%mapper_extension%,%Game_Profile%,JOYSTICKS,MediaCenter_Profile
FileCreateShortcut,%plink%,%This_Profile%\%gmnamex%.lnk,%scpath%, ,%gmnamex%,%plink%,,%iconnumber%
FileCreateShortcut,%binhome%\%RJPRJCT%.exe, %Game_Directory%\%gmnamex%.lnk,%scpath%, `"%This_Profile%\%gmname%.lnk`",%gmname%,%plink%,,%iconnumber%
inif= %RJDB_Config%,%GAME_PROFILES%\game.ini
iniwrite,%Game_Profile%,%inif%,JOYSTICKS,Game_Profile
Return

JoyTest:
joycount=
loop, 16 
	{
		joypartX:= % joyGetName(A_Index)
		joypart%A_Index%:= joypartX
		if (joypartX = "failed")
			{
				PlayerVX= 
				player%A_Index%n=
				player%A_Index%t=
				continue
			}
		joycount+= 1
		templt= %Player2_Template%
		templm= %MediaCenter_Template%
		pinum:= % Player%A_Index%
		minum:= % MediaCenter_Profile%A_Index%
		if (A_Index = 1)
			{
				minum= %MediaCenter_Profile%
			}
		playerVX:= % player%JoyCount%VX
		MediaCenter_ProfileVX:= % MediaCenter_Profile_%JoyCount%VX
		cpyplyrs:
		if (!fileExist(pinum)or(pinum = "disabled"))
			{
				if (pinum = "")
					{
						pinum= %scpath%\%gmnamex%_%A_Index%.%mapper_extension%
					}
				if (pinum = "disabled")	
					{
						pinum= %scpath%\%gmnamex%_%A_Index%.%mapper_extension%
					}
				if (A_Index = 1)
					{
						pinum= %scpath%\%gmnamex%.%mapper_extension%
						templt= %Player1_Template%
					}	
				fileCopy,%templt%,%pinum%,1
				if ((errorlevel <> 0)&&(PlayerVX <> pinum))
					{
						pinum= %PlayerVX%
						Player%A_Index%= %playerVX%
						goto, cpyplyrs
					}
			}
			else {
				Player%joycount%= %pinum%
				}
		cpymcntrs:
		if !fileExist(minum)
			{
				if (minum = "")
					{
						minum= %scpath%\MediaCenter_%A_Index%.%mapper_extension%
					}
				fileCopy,%MediaCenter_Template%, %minum%,1
				if ((errorlevel <> 0)&&(MediaCenter_ProfileVX <> minum))
					{
						minum= %MediaCenter_ProfileVX%
						MediaCenter_Profile%A_Index%= %MediaCenter_ProfileVX%
						goto, cpymcntrs
					}
			}
			else {
			MediaCenter_Profile_%joycount%= %minum%
			}
		zinum="%minum%"
		MediaCenter_Profile_%joycount%t:= A_Space . zinum
		vinum="%pinum%"
		player%joycount%t:= A_Space . vinum
		if (nosave <> 1)
			{
				iniwrite,%pinum%,%curpidf%,JOYSTICKS,Player%joycount%
				iniwrite,%minum%,%curpidf%,JOYSTICKS,MediaCenter_Profile%joycount%
			}
	}
return
NameTuning:
StringReplace,gmnamex,tempn,%A_Space%Launcher,,All
StringReplace,gmnamex,gmnamex,_Launcher,,All
StringReplace,gmnamex,gmnamex,%A_Space%Shortcut,,All
StringReplace,gmnamex,gmnamex,-Launcher,,All
StringReplace,gmnamex,gmnamex,Launch%A_Space%,,All
StringReplace,gmnamex,gmnamex,Launch-,,All
StringReplace,gmnamex,gmnamex,Launch_,,All
StringReplace,gmnamex,gmnamex,WIN64,,All
StringReplace,gmnamex,gmnamex,WIN_64,,All
StringReplace,gmnamex,gmnamex,WIN_32,,All
StringReplace,gmnamex,gmnamex,WIN32,,All
StringReplace,gmnamex,gmnamex,%A_Space%x64,,All
StringReplace,gmnamex,gmnamex,x-64,,All
StringReplace,gmnamex,gmnamex,_x64,,All
StringReplace,gmnamex,gmnamex,Shortcut to%A_Space%,,All
Stringleft,chka,gmnamex,1
StringRight,chkb,gmnamex,1

Loop,4
	{
		if ((chka = "_") or (chka = "-")or (chka = ".") or (chka = "%A_Space%"))
			{
				stringtrimleft,gmnamex,gmnamex,1
				Stringleft,chka,gmnamex,1
			}			
	}
Loop,4
	{
		if ((chkb = "_")or (chkb = "-")or (chkb = ".")or (chkb = "%A_Space%"))
			{
				stringtrimRight,gmnamex,gmnamex,1
				StringRight,chkb,gmnamex,1
			}
	}
absgmx= |%gmnamex%|
absgme= |%gmname%|
if (instr(nogmnx,absgmx)or instr(nogmne,absgme))
	{
		if (lnkg = 1)
			{
				 if (lnkrg = 1)
					{
						if (lnkft = 1)
							{
								gmnamex= %tempn%
								gosub, nonmres
								;goto,PRE_MON
								return
							}
						splitpath,npfdir,,,,tempn
						lnkft= 1
						goto,NameTuning
					}
				splitpath,pfdir,,,,tempn
				lnkrg= 1
				splitpath,pfdir,,npfdir
				goto, NameTuning	
			}
		lnkg= 1
		tempn= %plnkn%
		goto, NameTuning
	}
return

CmdRet(sCmd, callBackFuncObj := "", encoding := "")
	{
	   static HANDLE_FLAG_INHERIT := 0x00000001, flags := HANDLE_FLAG_INHERIT
			, STARTF_USESTDHANDLES := 0x100, CREATE_NO_WINDOW := 0x08000000
			
	   (encoding = "" && encoding := "cp" . DllCall("GetOEMCP", "UInt"))
	   DllCall("CreatePipe", "PtrP", hPipeRead, "PtrP", hPipeWrite, "Ptr", 0, "UInt", 0)
	   DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", flags, "UInt", HANDLE_FLAG_INHERIT)
	   
	   VarSetCapacity(STARTUPINFO , siSize :=    A_PtrSize*4 + 4*8 + A_PtrSize*5, 0)
	   NumPut(siSize              , STARTUPINFO)
	   NumPut(STARTF_USESTDHANDLES, STARTUPINFO, A_PtrSize*4 + 4*7)
	   NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*3)
	   NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*4)
	   
	   VarSetCapacity(PROCESS_INFORMATION, A_PtrSize*2 + 4*2, 0)

	   if !DllCall("CreateProcess", "Ptr", 0, "Str", sCmd, "Ptr", 0, "Ptr", 0, "UInt", true, "UInt", CREATE_NO_WINDOW
								  , "Ptr", 0, "Ptr", 0, "Ptr", &STARTUPINFO, "Ptr", &PROCESS_INFORMATION)
	   {
		  DllCall("CloseHandle", "Ptr", hPipeRead)
		  DllCall("CloseHandle", "Ptr", hPipeWrite)
		  throw "CreateProcess is failed"
	   }
	   DllCall("CloseHandle", "Ptr", hPipeWrite)
	   VarSetCapacity(sTemp, 4096), nSize := 0
	   while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", &sTemp, "UInt", 4096, "UIntP", nSize, "UInt", 0) {
		  sOutput .= stdOut := StrGet(&sTemp, nSize, encoding)
		  ( callBackFuncObj && callBackFuncObj.Call(stdOut) )
	   }
	   DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION))
	   DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, A_PtrSize))
	   DllCall("CloseHandle", "Ptr", hPipeRead)
	   Return sOutput
	}
joyGetName(ID) {
	VarSetCapacity(caps, 728, 0)
	if DllCall("winmm\joyGetDevCapsW", "uint", ID-1, "ptr", &caps, "uint", 728) != 0
		return "failed"
	return StrGet(&caps+4, "UTF-16")
}	
