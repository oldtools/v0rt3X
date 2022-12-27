#NoEnv
#MaxMem 4095
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Persistent
FileEncoding UTF-8

RJPRJCT := "v0rt3X"
RELEASE := "2022-12-27 8:04 AM"
VERSION := "[CURV]"

EnvGet,LADTA,LOCALAPPDATA
EnvGet,USRPRF,USERPROFILE
EnvGet,SYSTMRT,SYSTEMROOT
EnvGet,PBLCFLDR,ALLUSERSPROFILE
EnvGet,DRVSYSTM,SYSTEM
EnvGet,xprgfls,PROGRAMFILES(X86)
EnvGet,DRVRT,WINDIR
home := A_ScriptDir
Splitpath,A_ScriptDir,tstidir,tstipth
if ((tstidir = "src")or(tstidir = "bin")or(tstidir = "binaries"))
	{
		home:= tstipth
	}
source:= home . "\src"
Loop %0%
	{
		
		GivenPath := %A_Index%
		Loop %GivenPath%,
			{
				if (plink = "")
					{
						plink:= A_LoopFileLongPath
						continue
					}
			}
		IF (!INSTR(LinkOptions,GivenPath)&& !instr(LinkOptions,plink)&& (GivenPath <> plink))
			{
				LinkOptions.= GivenPath . a_SpACE
			}
	}
splitpath,plink,scname,scpath,scextn,gmname,gmd
CFGDIR := SCPATH
RJDBINI := home . "\RJDB.ini"
if (scextn = "lnk")
	{
		FileGetShortcut,%plink%,inscname,inscpth,chkargl
		if instr(inscname,"jkvtx")
			{
				splitpath,chkargl,chkargxe,chkargpth
				CFGDIR := CHKARGPTH
				RJDBINI := CFGDIR . "\RJDB.ini"
			}

	}
	else {
		CFGDIR := home
		RJDBINI := CFGDIR . "\RJDB.ini"
	}
binhome := home . "\bin"
THELOG := home . "\log.txt"
if ((plink = "") or !fileExist(plink) or (scextn = ""))
	{
		;filedelete,%THELOG%
	}
gosub, DDPOPS
SRCFILE := home . "\continue.db"
repopbut := "hidden"
fileread,unlike,%source%\unlike.set
fileread,unselect,%source%\unsel.set
fileread,absol,%source%\absol.set
fileread,rabsol,%source%\rabsol.set
NSOURCEDLIST := ""
if fileexist(SRCFILE)
	{
		srcntot:= ""
		vavn:= ""
		repopbut:= ""
		fileread,SOURCEDLIST,%SRCFILE%
		Loop,parse,SOURCEDLIST,`n`r
			{
				if ((A_LoopField = "") or instr(NSOURCEDLIST,A_LoopField))
					{
						continue
					}
				vavn+=1
				%vavn%SDL:= A_LoopField
				NSOURCEDLIST.= A_LoopField . "`n"
			}
		srcntot:= vavn	
	}
SOURCEDLIST:= NSOURCEDLIST
NSOURCEDLIST := ""
filedelete,%SRCFILE%
fileappend,%SOURCEDLIST%,%SRCFILE%,UTF-8
FileDelete,%home%\log*.txt
fileread,exclfls,%source%\exclfnms.set
fileread,rlsgrps,%source%\rlsgrps.set
filextns := "exe"
;filextns= exe|lnk
SPCFIX= .|-|%A_Space%|_
RLSPFX= .|-|(|[|%A_Space%|_|
BGMPROGS= WindowManager|SpecialK|SpecialKtest|MultiMonitorFullscreenHelper|Magpie|SKIF|borderstripper|ShaderGlass|Magpie|Fullscreenizer|SRWE|borderlessgamingportable|BorderlessGaming|sizer|BorderlessGamingTool|WindowedBorderlessGaming|MultiMonitorFullscreenHelper|ShiftWindow|BorderlessWindowUtility|BetterFullscreen
RLSIFX= BYPASSED BY|CRACKED BY|REPACKED BY|UPDATE|MULTi10|MULTi11|MULTi12|MULTi13|MULTi14|MULTi15|MULTi16|MULTi17|MULTi18
MAPCFGS= Keysticks|JoyToKey|JoyXoff|Xpadder|AntimicroX|Antimicro
remotebins= _BorderlessGaming_|_Antimicro_|_AntimicroX_|_JoyToKey_|_Xpadder_|_JoyXoff_|_Keysticks_|_MultiMonitorTool_|_SetSoundDevice_|_SoundVolumeView_
MENU_X:= A_GuiX*(A_ScreenDPI/96)
MENU_Y:= A_GuiY*(A_ScreenDPI/96)
ptyx=|32|33|35|44|38|45|64|35|123|91|125|93|39|59|58|46|94|43|61|
reduced= |_Data|Assets|alt|shipping|Data|ThirdParty|engine|App|steam|steamworks|script|nocd|Tool|trainer|
priora= |Launcher64|Launcherx64|Launcherx8664|Launcher64bit|Launcher64|Launchx64|Launch64|Launchx8664|
priorb= |Launcher32|Launcherx86|Launcher32bit|Launcher32|Launchx86|Launch32|
prioraa= |win64|x64|64bit|64bits|64|x8664|bin64|bin64bit|windowsx64|windows64|binx64|exex64|exe64|binariesx64|binaries64|binariesx8664|
priorbb= |win32|32bit|32bits|x8632|x86|x8632bit|32|windows32|windows32|bin32|windowsx86|bin32bit|binx86|bin32|exex86|exe32|binariesx86|binaries32|binariesx86|
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")
progdirs:= A_ProgramFiles . "|" . ProgramW6432 . "|" . ProgramFilesX86 . "|" . A_MyDocuments . "|"
remProgdirs= Program Files|Program Files (x86)|ProgramData|users\%A_username%\AppData\Local|users\%A_username%\AppData\Roaming|
steamhome= Steam\SteamApps\common
dralbet= c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|
AmzQuery= Amazon Games
OriQuery= Origin\LocalContent
GogQuery= GOG|G.O.G|GOG Games
ItchQuery= itch\app*|Itch*Downloads|Itch.io
GenQuery= Games|Gaymes|My Games|juegos|spellen|Spiele|Jeux|Giochi|PC_Games|PC Games|PCGAMES|Windows Games|WinGames|Windows_Games|Win_Games|Games_for_Windows|Games for Windows|GamesForWindows|CHRONOS Releases
AllQuery:= GogQuery . | . "Origin" . "|" . "Epic Games" . "|" . steamhome
undira= |%A_WinDir%|%A_Programfiles%|%A_Programs%|%A_AppDataCommon%|%A_AppData%|%A_Desktop%|%A_DesktopCommon%|%A_StartMenu%|%A_StartMenuCommon%|%A_Startup%|%A_StartupCommon%|%A_Temp%|%LADTA%|
undirs= %undira%
pcgwbr= 400 Bad Request
pcgwbt= Bad title
patsup= Support us on Patreon
nopcgw= There is currently no text in this page.
STEAMIDB=https://store.steampowered.com/api/appdetails?appids=
PCGWURL=https://www.pcgamingwiki.com/wiki/
CENITEMS= CenKBM|CenPL1|CenPL2|CenMC|CenGM|CenMM|CenJAL|CenJBE|CenPRE|CenPST|
GUIVARS= ASADMIN|PostWait|PreWait|Localize|SCONLY|EXEONLY|BOTHSRCH|ADDGAME|ButtonClear|ButtonCreate|MyListView|CREFLD|GMCONF|GMJOY|GMLNK|UPDTSC|OVERWRT|POPULATE|RESET|EnableLogging|RJDB_Config|RJDB_Location|GAME_ProfB|GAME_DirB|SOURCE_DirB|SOURCE_DirectoryT|REMSRC|Keyboard_MapB|Player1_TempB|Player2_TempB|CENTRLCKB|MediaCenter_ProfB|MultiMonitor_Tool|MM_ToolB|MM_Game_CfgB|MM_MediaCenter_CfgB|BGM_ProgB|BGP_Enable|BGP_TE|BGP_TU|PREAPP|PREDD|DELPREAPP|POSTAPP|PostDD|DELPOSTAPP|REINDEX|KILLCHK|INCLALTS|SELALLBUT|SELNONEBUT|KBM_RC|MMT_RC|BGM_RC|JAL_ProgB|JBE_ProgB|JBE_RC|JAL_RC|PRE_RC|POST_RC|IncludeDD|Hide_Taskbar|JALWAIT|JBEWAIT|NAMECHK|NetChk|CenKBM|CenPL1|CenPL2|CenMC|CenGM|CenMM|CenJAL|CenJBE|CenPRE|CenPST|EXCL_DirB|EXCLUDE_DirectoryT|REMEXCL
STDVARS= EXCLUDE_Directory|EXCLUDE_DirectoryT|DIST_DIRECTORY|SOURCE_DirectoryT|SOURCE_Directory|KeyBoard_Mapper|MediaCenter_Profile|Player1_Template|Player2_Template|MultiMonitor_Tool|MM_MEDIACENTER_Config|MM_Game_Config|BorderLess_Gaming_Program|extapp|Game_Directory|Game_Profiles|RJDB_Location|Source_Directory|Mapper_Extension|1_Post|2_Post|3_Post|1_Post|2_Post|3_Post|Install_Directory|GameData|SaveData|BGP_State|Borderless_Gaming_Program|Name_Check|Net_Check|CENTRLCKB|Cloud_Backup|Cloud_Restore|JustBeforeExit|JustAfterLaunch|Hide_Taskbar|Steam_ID|Exe_File|Steam_UserID|exe_list
DDTA= <$This_prog$><Monitor><Mapper>
DDTB= <Monitor><$This_prog$><Mapper>
DDTC= <$This_prog$><Monitor><Mapper>
ascinumerate=!|#|$|@|`%|&|(|)|[|]|{|}|'|;
fringe:= "-_([{^`,`;"
alphanumiterate=a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
chariterate=%ascinumerate%|%alphanumiterate%
nosuc= {"success":false}
qte= "
;"
trig1a= <span class="mw-headline" id="Configuration_file
;"
trig1b= <span class="mw-headline" id="Save_game_data_location
;"
TrigDATA= <span class="template-infotable-monospace">
TrigN= class="table-gamedata-body-system">
;"
SupData=</span><sup id="cite_ref-gamedir_
;"
trig3=<span class="mw-headline" id="Save_game_cloud_syncing">
DBINF=(mounted in <a href="/wiki/DOSBox" title="DOSBox">DOSBox</a>)</i>
STINF=<a href="/wiki/Glossary:Game_data#Steam_client" title="Glossary:Game data"><abbr title="The base Steam installation folder">&lt;Steam-folder&gt;</abbr></a>
PRINF=<a href="/wiki/Glossary:Game_data#User_profile" title="Glossary:Game data"><abbr title="Windows: copy this path into a folder address bar to go to this location">`%USERPROFILE`%</abbr></a>
UAINF=<a href="/wiki/Glossary:Game_data#User_application_data" title="Glossary:Game data"><abbr title="Windows: copy this path into a folder address bar to go to this location">`%LOCALAPPDATA`%</abbr></a>
STUNF=<a href="/wiki/Glossary:Game_data#User_ID" title="Glossary:Game data"><abbr title="The user ID or profile name (specific to your account or computer)">&lt;user-id&gt;</abbr></a>
GSUIF=<a href="/wiki/Glossary:Game_data#User_ID" title="Glossary:Game data"><abbr title="The user ID or profile name (specific to your account or computer)">&lt;user-id&gt;</abbr></a>
REGIF=<a href="/wiki/Glossary:Game_data#Windows_registry" title="Glossary:Game data"><abbr title="Windows Registry path (use the Registry Editor to access)">
BSINF=<a href="/wiki/Glossary:Game_data#Installation_folder" title="Glossary:Game data"><abbr title="The base installation folder">&lt;path-to-game&gt;</abbr></a>
repA=</abbr>|</a>|</span></td>
Loop,parse,chariterate,|
	{
		uv_%A_Index%:= A_LoopField
	}
RJDBORIJ:= home . "\RJDB.ini"	
if !fileExist(RJDBORIJ)
	{
		ASADMIN:= 1
		gosub,INITALL
		Loop,parse,MAPCFGS,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				gosub, INIT%A_LoopField%
			}
		gosub,MM_AUTO
		gosub,GBT_AUTO
	}
SWAPMAPR:= "|"	
Loop,parse, MAPCFGS,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		iniread,mpxrf,%RJDBINI%,JOYSTICKS,%A_LoopField%_executable
		if fileexist(mpxrf)
			{
				SWAPMAPR.= A_LoopField . "|"
			}
	}	
gosub, popgui

/*
iniread,forecolor,%RJDBINI%,THEME,GUI_foreground
if ((forecolor = "")or(forecolor = "ERROR"))
	{
		forecolor= Default
		iniwrite,%A_Space%,%RJDBINI%,THEME,GUI_foreground
	}
iniread,bgcolor,%RJDBINI%,THEME,GUI_background
if ((bgcolor = "")or(bgcolor = "ERROR"))
	{
		bgcolor= Default
		iniwrite,%A_Space%,%RJDBINI%,THEME,GUI_background
	}
iniread,themen,%RJDBINI%,THEME,GUI_theme_name
if ((skthemen = "")or(skthemen = "ERROR"))
	{
		themen= Default
		iniwrite,%A_Space%,%RJDBINI%,THEME,GUI_theme_name
	}
iniread,fontColor,%RJDBINI%,THEME,GUI_font_color
if ((fontColor = "")or(fontColor = "ERROR"))
	{
		fontColor= Default
		iniwrite,%A_Space%,%RJDBINI%,THEME,GUI_font_color
	}
iniread,fontName,%RJDBINI%,THEME,GUI_font_name
if ((fontName = "")or(fontName = "ERROR"))
	{
		fontName:= ""
		iniwrite,%A_Space%,%RJDBINI%,THEME,GUI_font_name
	}
iniread,fontXlg,%RJDBINI%,THEME,GUI_font_large
if ((fontXlg = "")or(fontXlg = "ERROR"))
	{
		fontXlg= s11
		iniwrite,%fontXlg%,%RJDBINI%,THEME,GUI_font_large
	}
iniread,fontXmed,%RJDBINI%,THEME,GUI_font_medium
if ((fontXmed = "")or(fontXmed = "ERROR"))
	{
		fontXmed= s9
		iniwrite,%fontXmed%,%RJDBINI%,THEME,GUI_font_medium
	}
iniread,fontXsm,%RJDBINI%,THEME,GUI_font_small
if ((fontXsm = "")or(fontXsm = "ERROR"))
	{
		fontXsm= s7
		iniwrite,%fontXsm%,%RJDBINI%,THEME,GUI_font_small
	}
*/
	
if (Logging = 1)
	{
		loget:= "checked"
		enablelogging:= 1
	}
STM_DB:= source . "\steam.json"	
LKUP_DB:= home . "\lookup.db"	
if (Net_Check = 1)
	{
		gosub, getsivk
	}
gbtstate:= ""
bgptu:= "checked"
bgpte:= "checked"
if (BGP_State = 1)
	{
		gbtstate:= "checked"
		bgptu:= ""
		bgpte:= "" 
	}
if (BGP_State = 5)
	{
		gbtstate:= ""
		bgptu:= "checked"
		bgpte:= "" 
	}
if (BGP_State = 6)
	{
		gbtstate:= "checked"
		bgptu:= "checked"
		bgpte:= "" 
	}
if (BGP_State = 8)
	{
		gbtstate:= ""
		bgptu:= ""
		bgpte:= "checked"
	}
if (BGP_State = 9)
	{
		gbtstate:= "checked"
		bgptu:= ""
		bgpte:= "checked"
	}

if (BGP_State = 13)
	{
		gbtstate:= ""
		bgptu:= "checked"
		bgpte:= "checked"
	}

if (BGP_State = 14)
	{
		gbtstate:= "checked"
		bgptu:= "checked"
		bgpte:= "checked"
	}
nmchkst= 
if (Name_Check = 1)
	{
		nmchkst:= "checked"
	}
cnckb:= 	
Loop,parse,CENTRALIZE,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		stringreplace,cnitm,A_LoopField,Cen,cn
		%cnitm%:= "checked"
		cnitnum+= 1
	}
if (cnitnum = 10)
	{
		cnckb:= "checked"
	}
netnchk= 
cfgenbl:= "disabled"
joyenbl:= "disabled"
lnkenbl:= "disabled"
if (IncludeDD = 1)
	{
		InclDD:= "checked"
	}
if (CREFLD = 1)
	{
		fldrget:= "checked"
		cfgenbl:= ""
		joyenbl:= ""
		lnkenbl:= ""
		admnenabl:= ""
	}
ovrwrchk:= ""
updtchk:= "checked"
if (CREMODE = 0)
	{
		ovrwrchk:= "checked"
		updtchk:= ""
	}
if (GMCONF = 1)
	{
		cfgget:= "checked"
	}
if (GMJOY = 1)
	{
		joyget:= "checked"
	}
if (ASADMIN = 1)
	{
		admnget:= "checked"
	}	
if (Net_Check = 1)
	{
		netnchk:= "checked"
	}
if (GMLNK = 1)
	{
		lnkget:= "checked"
	}
if instr(1_PostT,"W<")
	{
		prestatus:= "checked"
	}
if instr(1_PostT,"W<")
	{
		poststatus:= "checked"
	}
stringsplit,jalaf,JustAfterLaunch,<	
JustAfterLaunchT=%jalaf2%
if instr(JustAfterLaunch,"W<")
	{
		jalstatus:= "checked"
	}
stringsplit,jalaf,JustBeforeExit,<	
JustBeforeExitT=%jalaf2%
if instr(JustBeforeExit,"W<")
	{
		jbestatus:= "checked"
	}	
if (JustAfterLaunch = "")
		{
			JustAfterLaunchT:= "Run After Launch"
		}
if (JustBeforeExit = "")
		{
			JustBeforeExitT:= "Run Before Exit"
		}
taskbarv:= "checked"
if (Hide_Taskbar = 0)
	{
		taskbarv:= ""	
	}

if (steamdir = "")
	{
		steamdir:= "[STEAMDIRECTORY]"
	}
if (SteamUser = "")
	{
		SteamUser:= "[STEAMUSERID]"
	}
Gui +hWndhMainWnd
Gui,Color,%bgcolor%
Gui,Font,%fontColor% %fontXmed%,%fontName%

Menu,PP_RCMenu,Add,,

Menu,MM_RCMenu,Add,Download,MMToolBDownload
Menu,MM_RCMenu,Add,,
Menu,MM_RCMenu,Add,RESET,MM_ToolBReset
Menu,MM_RCMenu,Add,Disable,DisableButs

Menu,KBM_RCMenu,Add,Download,KBMDownload
Menu,KBM_RCMenu,Add,,
Menu,KBM_RCMenu,Add,RESET,ResetMprs
Menu,KBM_RCMenu,Add,,
Menu,KBM_RCMenu,Add,Enable,Keyboard_MapBEnable
Menu,KBM_RCMenu,Add,Disable,Keyboard_MapBDisable

Menu,JAL_RCMenu,Add,Disable,JAL_ProgBDisable
Menu,JBE_RCMenu,Add,Disable,JBE_ProgBDisable

Menu,BGM_RCMenu,Add,Download,BGM_ProgBDownload
Menu,BGM_RCMenu,Add,,
Menu,BGM_RCMenu,Add,Disable,BGM_ProgBDisable

Menu,MMCFG_RCMenu,Add,Disable,MMCFGDisable
Menu,MDCFG_RCMenu,Add,Disable,MDCFGDisable
Menu,MMCFG_RCMenu,Add,Reset,MMCFGReset
Menu,MDCFG_RCMenu,Add,Reset,MDCFGReset

Menu,PL1_RCMenu,Add,Disable,PL1Disable
Menu,PL2_RCMenu,Add,Disable,PL2Disable
Menu,PL1_RCMenu,Add,Reset,PL1Reset
Menu,PL2_RCMenu,Add,Reset,PL2Reset
Menu,MCP_RCMenu,Add,Disable,MCPDisable
Menu,MCP_RCMenu,Add,Reset,MCPReset

Menu,UPDButton,Add,Update,UpdateRJLR

Menu,LookupDBCHK,Add,,
Menu,LookupDBCHK,Add,Reset the Lookup Table,RELOOKUP
Menu,LookupDBCHK,Add,Download a new steam list,RESTEAM

Menu,DelPerg,Add,,
Menu,DelPerg,Add,,

Menu,PropKBL,Add,Edit,PropKBCmdE
Menu,PropPL1,Add,Edit,PropPl1jpE
Menu,PropPL2,Add,Edit,PropPl2jpE
Menu,PropMC,Add,Edit,PropMCjpE
Menu,PropMM,Add,Edit,PropGMcfgE
Menu,PropGM,Add,Edit,PropGMcfgE
Menu,PropDM,Add,Edit,PropDMcfgE
Menu,PropJAL,Add,Edit,PropJALcE
Menu,PropJBE,Add,Edit,PropJBEcE
Menu,PropPRE,Add,Edit,PropPREcE
Menu,PropPST,Add,Edit,PropPSTcE
Menu,PropLNC,Add,,
Menu,PropPRO,Add,,
Menu,PropKBL,Add,,
Menu,PropPL1,Add,,
Menu,PropPL2,Add,,
Menu,PropMC,Add,,
Menu,PropMM,Add,,
Menu,PropGM,Add,,
Menu,PropDM,Add,,
Menu,PropBGE,Add,,
Menu,PropJAL,Add,,
Menu,PropJBE,Add,,
Menu,PropPRE,Add,,
Menu,PropPST,Add,,
Menu,PropLNC,Add,Edit,PropLNCE
Menu,PropPRO,Add,Edit,PropPROE
Menu,PropBGE,Add,Edit,PropBGEE
Menu,PropLNC,Add,Delete Profile Folders,Dellaunch
Menu,PropPRO,Add,Delete Launcher Folder,Delprof
Menu,PropKBL,Add,Propagate,PropKBCmd
Menu,PropPL1,Add,Propagate,PropPl1jp
Menu,PropPL2,Add,Propagate,PropPl2jp
Menu,PropMC,Add,Propagate,PropMCjp
Menu,PropMM,Add,Propagate,PropGMcfg
Menu,PropGM,Add,Propagate,PropGMcfg
Menu,PropDM,Add,Propagate,PropDMcfg
Menu,PropJAL,Add,Propagate,PropJALc
Menu,PropJBE,Add,Propagate,PropJBEc
Menu,PropPRE,Add,Propagate,PropPREc
Menu,PropPST,Add,Propagate,PropPSTc

gui,font, s16 bold
Gui,Font,Bold
Gui,Font, %fontXmed%

Gui, Add, Button, x310 y8 vButtonClear gButtonClear hidden disabled, Clear List
Gui, Add, Text, x377 y8 h12, Check
Gui, Add, Button, x420 y8 vSELALLBUT gSELALLBUT hidden, All
Gui, Add, Button, x445 y8 vSELNONEBUT gSELNONEBUT hidden, None
Gui, Add, Button, x490 y10 h20 vADDGAME gADDGAME disabled, ADD
Gui, Add, Edit, x530 y12 w50 disabled,
Gui, Add, Button, x565 y12 w14 h14 disabled,X
Gui, Font, Bold
Gui, Add, Button, x590 y8 vButtonCreate gButtonCreate hidden disabled,CREATE
Gui, Font, Normal
Gui, Add, ListView, r44 x310 y35 h560 w340 -Readonly vMyListView gMyListView hwndHLV1 AltSubmit Checked hidden,Name|Directory/Location|Opt /s|Arg /s|Name Override|KBM|P1|P2|McP|MMT|GM|DM|JAL|JBE|Pre|Pst|Bgm|SteamID

LV_ModifyCol(3, "Integer") 

																  
ImageListID1 := IL_Create(10)
ImageListID2 := IL_Create(10, 10, true) 

																			   
LV_SetImageList(ImageListID1)
LV_SetImageList(ImageListID2)

Menu, MyContextMenu, Add, Open Profile, ContextOpenFile
Menu, MyContextMenu, Add, Open Directory, ContextOpenGame
Menu, MyContextMenu, Add,,
Menu, MyContextMenu, Add, Add CLI opts/args, AddCLI
Menu, MyContextMenu, Add,,
Menu, MyContextMenu, Add, Clear from ListView, ContextClearRows


Gui, Add, GroupBox, x16 y0 w283 h97 center,
Gui, Add, GroupBox, x16 y91 w283 h120 center,

Gui Add, GroupBox, x16 y205 w283 h146,
Gui Add, GroupBox, x16 y345 w283 h72,
Gui Add, GroupBox, x16 y408 w283 h103,
Gui Add, GroupBox, x16 y505 w283 h65,
Gui Add, GroupBox, x16 y565 w283 h90,
Gui Add, GroupBox, x130 y649 w169 h27,
Gui Add, GroupBox, x105 y124 w175 h45,
;;Gui, Add, Radio, x95 y32 vEXEONLY gEXEONLY checked hidden, Exe`,Cmd`,Bat
Gui, Font, Bold
Gui, Add, Button, x18 y8 h18 w18 vRESET gRESET,R
Gui, Font, Normal
Gui, Add, Checkbox, x65 y10 h14 vNameChk gNameChk right %nmchkst%,Name-Check
Gui, Add, Checkbox, x155 y10 h14 vNetChk gNetChk right %netnchk%,Net-Check
GUi, Add, Checkbox, x100 y30 h14 vIncludeDD gIncludeDD %InclDD%,Incl Steam/GOG etc...
Gui, Add, Button, x241 y8 w45 h15 vREINDEX gREINDEX %repopbut%,re-index
Gui, Font, Bold
Gui, Add, Button, x241 y24 w45 h25 vPOPULATE gPOPULATE,GO>
Gui, Font, Normal
Gui, Add, Radio, x30 y32 vSCONLY gSCONLY hidden, Lnk Only
Gui, Add, Radio, x175 y32 vBOTHSRCH gBOTHSRCH hidden, Exe+Lnk

Gui, Add, Checkbox, x100 y14 h14 vINCLALTS gINCLALTS hidden,Alts

Gui, Font, Bold
Gui, Add, Button, x24 y50 w36 h21 vSOURCE_DirB gSOURCE_DirB,SRC

Gui, Font, Normal
Gui, Add, DropDownList, x64 y50 w200 vSOURCE_DirectoryT gSOURCE_DirectoryDD,%sourcepop%
Gui, Add, Button, x269 y52 w15 h15 vREMSRC gREMSRC,X
Gui, Add, Text, x20 y35 h14 vCURDP Right,<Game Fldrs>

Gui, Font, Bold
Gui, Add, Button, x80 y73 w36 h19 vEXCL_DirB gEXCL_DirB,EXC
Gui, Font, Normal
Gui, Add, DropDownList, x124 y72 w130 vEXCLUDE_DirectoryT gEXCLUDE_DirectoryDD,%exclpop%
Gui, Add, Button, x258 y75 w15 h15 vREMEXCL gREMEXCL,X
Gui, Add, Text, x25 y77 h14,<Exclude>

Gui, Font, Bold
Gui, Add, Button, x24 y108 w36 h21 vGame_DirB gGame_DirB,OUT
Gui, Font, cSilver
Gui, Add, Text, x64 y100 w222 h14 vGAME_DirectoryT Right,%GAME_Directory%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text, x84 y114 h14,<Shortcut Output Directory>

GUi, Add, Checkbox, x120 y134 h14 vCREFLD gCREFLD %fldrget%, Folders
GUi, Add, Checkbox, x188 y134 h14 vGMCONF gGMCONF %cfgget% %cfgenbl%,Cfg
GUi, Add, Checkbox, x240 y134 h14 vGMJOY gGMJOY %Joyget% %joyenbl%,Joy
Gui, Add, Checkbox, x1 y141 w14 h14 vCENTRLCKB gCENTRLCKB %cntz%, 
Gui, Font, Bold
Gui, Add, Text, x20 y140 h16,:CENTRALIZE
Gui, Font, Normal
Gui, Add, Checkbox, x225 y152 w52 h14 vKILLCHK gKILLCHK checked,Kill-List
GUi, Add, Checkbox, x157 y152 h14 vASADMIN gASADMIN %admnget% %admnenabl%,As Admin
GUi, Add, Checkbox, x112 y152 h14 vGMLNK gGMLNK %lnkget% %lnkenbl%,Lnk

Gui, Font, Bold
Gui, Add, Button, x21 y180 w36 h21 vGame_ProfB gGame_ProfB,GPD
Gui, Font, cSilver
Gui, Add, Text, x64 y175 w222 h14 vGAME_ProfilesT Right,%GAME_Profiles%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text,  x64 y189 w122 h14 vGame_ProfilesR,<Game Profiles Directory>
Gui, Font, Bold
Gui, Add, Checkbox, x208 y190 w85 h14 vLocalize gLocalize right,LOCALIZE:
Gui, Font, Normal

Gui, Font, Bold
Gui, Add, Button, x17 y224 w36 h21 vKeyboard_MapB gKeyboard_MapB,KBM
Gui, Add, Checkbox, x1 y227 w14 h14 vCenKBM gCenKBM %cnkbm%,
Gui Add, Button, x52 y224 w10 h21 vKBM_RC gKBM_RC, v
Gui, Font, cSilver
Gui, Add, Text,  x64 y224 w222 h14 vKeyboard_MapperT Right,%Keyboard_Mapper%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text,  x64 y238 w222 h14,<Keyboard Mapper Program>

Gui, Font, Bold
Gui, Add, Button, x21 y256 w35 h19 vPlayer1_TempB gPlayer1_TempB,PL1
Gui, Add, Checkbox, x1 y259 w14 h14 vCenPL1 gCenPL1 %cnpl1%,
Gui, Font, cSilver
Gui, Add, Text,  x64 y256 w222 h14 vPlayer1_TemplateT Right,%Player1_Template%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text,  x64 y270 w222 h14,.....Template Profile for Player 1>
Gui, Font, Bold

Gui, Add, Button, x21 y288 w36 h19 vPlayer2_TempB gPlayer2_TempB,PL2
Gui, Add, Checkbox, x1 y291 w14 h14 vCenPL2 gCenPL2 %cnpl2%,
Gui, Font, cSilver
Gui, Add, Text,  x64 y288 w222 h14 vPlayer2_TemplateT Right,%Player2_Template%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text,  x64 y302 w222 h14,.....Template for Player 2>

Gui, Font, Bold
Gui, Add, Button, x21 y320 w36 h19 vMediaCenter_ProfB gMediaCenter_ProfB,MCP
Gui, Add, Checkbox, x1 y323 w14 h14 vCenMC gCenMC %cnMC%,
Gui, Font, cSilver
Gui, Add, Text,  x64 y320 w222 h14 vMediaCenter_TemplateT Right,%MediaCenter_Template%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text,  x64 y334 w222 h14,.....Template for MediaCenter/Desktop>

Gui, Font, Bold
Gui, Add, Button, x17 y352 w36 h21 vBGM_ProgB gBGM_ProgB,GBT
Gui Add, Button, x53 y352 w10 h21 vBGM_RC gBGM_RC, v
Gui, Font, cSilver
Gui, Add, Text,  x64 y354 w222 h14 vBorderless_Gaming_ProgramT Right,%Borderless_Gaming_Program%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text,  x64 y368 w110 h14,<Borderless_Program>

Gui, Font, Bold
Gui, Add, Checkbox, x20 y380 h19 vBGP_Enable gBGP_Enable %gbtstate%, Enable
Gui, Font, Normal
Gui, Add, Checkbox, x205 y382 w89 h14 vHide_Taskbar gHide_Taskbar %taskbarv%,Hide Taskbar
Gui, Add, Checkbox, x45 y399 h15 vBGP_TU gBGP_TU %bgptu%,Terminate if unused
Gui, Add, Checkbox, x166 y399 h15 vBGP_TE gBGP_TE %bgpte%,Terminate on exit

Gui, Font, Bold
Gui, Add, Button, x17 y416 w36 h21 vMM_ToolB gMM_ToolB,MMT
Gui Add, Button, x53 y416 w10 h21 vMMT_RC gMMT_RC, v
Gui, Font, cSilver
Gui, Add, Text,  x64 y418 w222 h14 vMultiMonitor_ToolT Right,%MultiMonitor_Tool%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text,  x64 y432 w222 h14,<Multimonitor Program>

Gui, Font, Bold
Gui, Add, Button, x21 y448 w35 h19 vMM_Game_CfgB gMM_Game_CfgB,GMC
Gui, Add, Checkbox, x1 y451 w14 h14 vCenGM gCenGM %cnGM%,
Gui, Font, cSilver
Gui, Add, Text,  x64 y448 w222 h14 vMM_Game_ConfigT Right,%MM_Game_Config%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text,  x64 y462 w222 h14,.....Gaming Configuration File>

Gui, Font, Bold
Gui, Add, Button, x21 y480 w35 h19 vMM_MediaCenter_CfgB gMM_MediaCenter_CfgB,DMC
Gui, Add, Checkbox, x1 y480 w14 h14 vCenMM gCenMM %cnMM%,
Gui, Font, cSilver
Gui, Add, Text,  x64 y480 w225 h14 vMM_MediaCenter_ConfigT Right,%MM_MediaCenter_Config%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Text,  x64 y494 w234 h14,.....MediaCenter/Desktop Configuration File>
  
Gui, Font, Bold
Gui, Add, Checkbox, x1 y515 w14 h14 vCenJAL gCenJAL %cnJAL%,
Gui, Add, Button, x17 y512 w36 h21 vJAL_ProgB gJAL_ProgB,JAL
Gui Add, Button, x53 y512 w10 h21 vJAL_RC gJAL_RC, v
Gui, Font, cSilver
Gui, Add, Text,  x64 y515 w198 h14 vJustAfterLaunchT Right,%JustAfterLaunchT%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Checkbox, x270 y514 w12 h14 vJALWait gJALWait %jalstatus%
;Gui, Add, Text,  x64 y526 w198 h14,<Run After Launch>


Gui, Font, Bold
Gui, Add, Checkbox, x1 y547 w14 h14 vCenJBE gCenJBE %cnJBE%,
Gui, Add, Button, x17 y544 w35 h19 vJBE_ProgB gJBE_ProgB,JBE
Gui Add, Button, x53 y544 w10 h21 vJBE_RC gJBE_RC, v
Gui, Font, cSilver
Gui, Add, Text, x64 y544 w198 h14 vJustBeforeExitT Right,%JustBeforeExitT%
Gui, Font, cBlack
Gui, Font, Normal
Gui, Add, Checkbox, x270 y546 w12 h14 vJBEWait gJBEWait %jbestatus%
;Gui, Add, Text, x64 y548 w198 h14,<Run Before Exit>	   

Gui, Font, Bold
Gui, Add, Checkbox, x1 y579 w14 h14 vCenPRE gCenPRE %cnPRE%,
Gui, Add, Button, x17 y576 w36 h21 vPREAPP gPREAPP ,PRE
Gui Add, Button, x53 y576 w10 h21 vPRE_RC gPRE_RC, v
Gui, Font, Normal
Gui, Add, Text, x65 y578 h12 vPRETNUM,1
Gui, Add, DropDownList, x75 y576 w193 vPREDD gPREDD Right,%prelist%
Gui, Add, Text, x64 y597 h14 w230 vPREDDT,<$This_Prog$><Monitor><Mapper><game.exe>
Gui, Add, Checkbox, x270 y578 w12 h14 vPreWait gPreWait %prestatus%,
								  
Gui, Add, Button, x283 y579 w14 h14 vDELPREAPP gDELPREAPP ,X
Gui, Font, Bold
Gui, Add, Checkbox, x1 y617 w14 h14 vCenPST gCenPST %cnPST%,
Gui, Add, Button, x17 y614 w36 h21 vPOSTAPP gPOSTAPP,PST
Gui Add, Button, x53 y614 w10 h21 vPOST_RC gPOST_RC, v
Gui, Font, Normal

Gui, Add, Text, x65 y616 h12 vPOSTDNUM,1
Gui, Add, DropDownList, x75 y616 w193 vPostDD gPostDD Right,%postlist%
Gui, Add, Text, x64 y638 h14 w230 vPOSTDDT,<game.exe><$This_Prog$><Mapper><Monitor>
Gui, Add, Checkbox, x270 y619 w12 h14 vPostWait gPostWait %poststatus%
Gui, Add, Button, x283 y621 w14 h14 vDELPOSTAPP gDELPOSTAPP ,X
gui,font,bold
Gui, Add, Button, x236 y7 w55 h17 vCANCLDBUT gCANCLDBUT hidden disabled,CANCEL
gui,font,normal


Gui, Font, Bold
Gui, Add, Checkbox, x20 y657 h18 w18 vEnableLogging gEnableLogging right %loget%,
Gui, Add, Button, x1 y656 h18 w18 vOPNLOG gOPNLOG,!
;Gui,Add,DropDownList, hwndDplHndl2 x42 y655 w85 vTHEMEN gTHEMEN,%themen%||Default|Gray|White|Blue|Black
Gui, Font, Normal

Gui, Font, Bold
Gui, Add, Radio, x143 y659 h14 vOVERWRT gUPDTSC %ovrwrchk%, Overwrite
Gui, Add, Radio, x225 y659 h14 vUPDTSC gOVERWRT %updtchk%, Update
gui,font,normal


OnMessage(0x200, "WM_MOUSEMOVE")

Gui, Add, StatusBar, x0 y675 w314 h28 vRJStatus, Status Bar
Gui Show, w314 h700, v0rt3X_GUI

  
SB_SetText("")
ADDGAME_TT :="Add a game with the file browser.`nAn attempt will be made to guess the appropriate name"
ASADMIN_TT :="sets shortcuts and programs to run as the aministrator."
SKTHEMEN_TT :="Theme`nRequires Restart"
BGP_Enable_TT := "Enables the Borderless Gaming Program"
BGP_TE_TT :="Kills the windowing program upon exiting a game."
BGP_TU_TT :="Kills the windowing program if not enabled for a game when launching."
Borderless_Gaming_ProgramT_TT :="The program used to manage and control the display of games as borderless windowed programs`n     Right_Click to Edit or propagate the selected item"
ButtonClear_TT :="clears the current queued it"
ButtonCreate_TT :="creates profiles for selected items in the current queued"
CenGM_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CenJAL_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CenJBE_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CenKBM_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CenMC_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CenMM_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CenPL1_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CenPL2_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CenPRE_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CenPST_TT := ":CENTRALIZE:`n`nAll Games will refer to this item's path`n`n:CENTRALIZE:"
CENTRLCKB_TT :="Joystick profiles, monitor configs and pre/post scritps are ''centralized'' as defined in the GUI `nand not copied to each profile folder."
CREFLD_TT :="Creates the profile folder"
DELPOSTAPP_TT :="removes the currently selected post-program"
DELPREAPP_TT :="removes the currently selected pre-program"
EnableLogging_TT :="enables logging"
EXCLUDE_DirectoryT_TT :="Excluded Directory`n     Right_Click to Edit or propagate the selected item"
Game_DirB_TT :="The location where shortcuts will be created"
GAME_DirectoryT_TT :="the current shortcut directory"
Game_ProfB_TT :="Sets the directory where profiles will be created"
GAME_ProfilesT_TT :="the profiles directory`n     Right_Click to Edit or propagate the selected item"
GMCONF_TT :="Creates the configuration files"
GMJOY_TT :="creates the joystick profiles"
GMLNK_TT :="creates the shortcuts"
Hide_TaskBar_TT :="Hides the windows taskbar while active"
INCLALTS_TT :="Alternate versions of a game will be created as alternates in a subfolder of the profile."
IncludeDD_TT :="Include Steam/GOG/Origin/Epic etc... games."
JALWAIT_TT :="waits for the program to exit"
JAL_ProgB_TT :="Assign a program to run after the game is launched`n*    (good for trainers or executable-aware programs.)"
JAL_RC_TT :="disable or download and assign a program after launch"
JBEWAIT_TT :="waits for the program to exit"
JBE_ProgB_TT :="Assign a program to run prior to executable termination"
JBE_RC_TT :="disable or download and assign an executable  prior to termination "
JustAfterLaunchT_TT :="a program after launch`n     Right_Click to Edit or propagate the selected item"
JustBeforeExitT_TT :="program to run prior to executable termination`n     Right_Click to Edit or propagate the selected item"
KBM_RC_TT :="disable or download and assign a supported keymapper`n(antimicro/JoyXoff/xpadder/...)"
Keyboard_MapB_TT :="Assigns the keymapper`n(antimicro/JoyXoff/xpadder/...)"
Keyboard_MapperT_TT :="the current keyboard mapper`n(supported mappers are auto-scripted '~_!.cmd')`n     Right_Click to Edit or propagate the selected item"
KILLCHK_TT :="ancilary and executable-subprocess are terminated upon exiting the game"
Localize_TT :="Sets the profile folder to`n the game's installation folder`n*     (not recommended)     *`n"
MediaCenter_TemplateT_TT :="the keymapper's configuration-template file for the Mediacenter/Frontend`n     Right_Click to Edit or propagate the selected item"
MMT_RC_TT :="disable or download and assign the multimonitor program"
MM_Game_CfgB_TT :="Select the multimonitor configuration template file used for games"
MM_MediaCenter_CfgB_TT :="Select the multimonitor configuration template file used for the MediaCenter/Frontend"
MM_ToolB_TT :="Assigns the multimonitor executable"
MM_Game_ConfigT_TT :="the multimonitor game-configuration template file`n     Right_Click to Edit or propagate the selected item"
MM_MediaCenter_ConfigT_TT :="the MediaCenter/Frontend configuration template file`n     Right_Click to Edit or propagate the selected item"
MultiMonitor_ToolT_TT :="the multimonitor program`n     Right_Click to Edit or propagate the selected item"
MyListView_TT :="The current queue"
NAMECHK_TT :="Matches guessed names at steam database."
NETCHK_TT :="Scrapes game-details from the steampowered api and PCGamingWiki databases.`nRight Click to reset the Lookup-Table"
Net_Check_TT :="Queries internet Databases to aquire save and configuration locations."
OPNLOG_TT :="opens the log file for this program"
OVERWRT_TT :="overwrite and recreate settings`nExisting configuration files *WILL* be overwritten"
Player1_TempB_TT :="sets the keymapper's configuration-template file for Player 1"
Player2_TempB_TT :="sets the keymapper's configuration-template file for Player 2"
Player1_TemplateT_TT :="the keymapper's configuration-template  for Player 1`n     Right_Click to Edit or propagate the selected item"
Player2_TemplateT_TT :="the keymapper's configuration-template file for Player 2`n     Right_Click to Edit or propagate the selected item"
POPULATE_TT :="Searches for games or loads the last queue"
POSTAPP_TT :="Assign a program to run after the game has exited"
PostWait_TT :="Waits for the currently selected post-program to exit"
POST_RC_TT :="disable or download and Assign a program to run after the game has exited"
PREAPP_TT :="Assign a program to run before the game is launched"
POSTDDT_TT :="Order of execution."
PostDD_TT :="the currently selected post-program`n*  ( ><ThisProg>< )`n     Right_Click to Edit or propagate the selected item"
PREDD_TT :="the currently selected pre-program`n*  ( ><ThisProg>< )  *`n     Right_Click to Edit or propagate the selected item"
PREDD_TT :="the currently selected pre-program`n*  ( ><ThisProg>< )"
POSTNUM_TT :="The Current Post-Config slot"
PRETNUM_TT :="The Current Pre-Config slot"
PreWait_TT :="Waits for the currently selected pre-program to exit"
PRE_RC_TT :="disable or download and Assign a program to run before the game is launched"
REINDEX_TT :="clears the queue and searches for games"
REMSRC_TT :="remove the currently selected source directory"
RESET_TT :="resets the application to default settings"
RJStatus_TT :="feedback display for the program"
SELALLBUT_TT :="Selects all items in the current queue"
SELNONEBUT_TT :="clears the selection of all items in the current queue"
SOURCE_DirB_TT :="Add a directory containing the root of game-installation/s."
SOURCE_DirectoryT_TT :="the current source directory`n     Right_Click to Edit or propagate the selected item"
UPDTSC_TT :="creates new profile/configurations and updates profiles with any blank/unset values`nExisting configuration files will *NOT* be overwritten"
Return


!esc::
GuiEscape:
GuiClose:
ExitApp



Game_ProfB:
gui,submit,nohide
FileSelectFolder,GAME_ProfilesT,%fldflt%,3,Select Folder
if (fileexist(GAME_ProfilesT)&&(GAME_ProfilesT <> "")&& !instr(GAME_ProfilesT,"<"))
	{
		if (instr(Game_ProfilesT,"profile")or instr(Game_ProfilesT,"Jacket"))or (instr(Game_ProfilesT,"RJ")&& instr(Game_ProfilesT,"data"))
			{
				Game_Profiles= %Game_Profiles%
			}
		else {
			stringright,gdtst,Game_ProfilesT,2
			stringLeft,rdtst,Game_ProfilesT,2
			if (gdtst = ":\")
				{
					Game_ProfilesT= %rdtst%
				}
			Game_Profiles= %GAME_ProfilesT%\Profiles
			Game_ProfilesT= %Game_Profiles%
		}

		GAME_Profiles= %GAME_ProfilesT%
		iniwrite,%GAME_Profiles%,%RJDBINI%,GENERAL,GAME_Profiles
		stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,All
		guicontrol,,GAME_ProfilesT,%GAME_ProfilesT%
	}
	else {
		stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,All
		guicontrol,,GAME_ProfilesT,<GAME_Profiles>
	}
return

Game_DirB:
gui,submit,nohide
FileSelectFolder,GAME_DirectoryT,%fldflt%,3,Select Folder
if (fileexist(GAME_DirectoryT)&&(GAME_DirectoryT <> "")&& !instr(GAME_DirectoryT,"<"))
	{
		if (instr(Game_DirectoryT,"launchers")or instr(Game_DirectoryT,"shortcuts")or instr(Game_DirectoryT,"links")or instr(Game_DirectoryT,"lnk") or instr(Game_DirectoryT,"runner"))
			{
				GAME_Directory= %GAME_DirectoryT%
			}
		else {
			stringright,gdtst,Game_DirectoryT,2
			stringLeft,rdtst,Game_DirectoryT,2
			if (gdtst = ":\")
				{
					Game_DirectoryT= %rdtst%
				}
			Game_Directory= %Game_DirectoryT%\Launchers
			Game_DirectoryT= %Game_Directory%
		}

		iniwrite,%GAME_Directory%,%RJDBINI%,GENERAL,GAME_Directory
		stringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,All
		guicontrol,,GAME_DirectoryT,%GAME_DirectoryT%
	}
	else {
		stringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,All
		guicontrol,,GAME_DirectoryT,<GAME_Directory
	}
return

SELALLBUT:
popui:= 1
NSOURCEDLIST:= ""
gui,submit,nohide
Gui, ListView, MyListView
LV_Modify(0, "+Check")
stringreplace,SOURCEDLIST,SOURCEDLIST,?,,All
stringreplace,SOURCEDLIST,SOURCEDLIST,`n,|`n,All
stringreplace,SOURCEDLIST,SOURCEDLIST,||`n,|`n,All
filedelete,%SRCFILE%
fileappend,%SOURCEDLIST%,%SRCFILE%,UTF-8
popui:= ""
return

SELNONEBUT:
gui,submit,nohide
popui:= 1
NSOURCEDLIST:= ""
Gui, ListView, MyListView
LV_Modify(0, "-check")
stringreplace,SOURCEDLIST,SOURCEDLIST,`n,|?`n,All
stringreplace,SOURCEDLIST,SOURCEDLIST,||?,|?,All
stringreplace,SOURCEDLIST,SOURCEDLIST,||`n,|?`n,All
stringreplace,SOURCEDLIST,SOURCEDLIST,|`n,|?`n,All
filedelete,%SRCFILE%
fileappend,%SOURCEDLIST%,%SRCFILE%,UTF-8
popui:= ""
return


SOURCE_DirB:
gui,submit,nohide
SFSLCTD:
FileSelectFolder,Source_DirectoryT,%fldflt%,3,Select Folder
if (fileexist(Source_DirectoryT)&&(Source_DirectoryT <> "")&& !instr(Source_DirectoryT,"<"))
	{
		Source_DirectoryX= %Source_DirectoryT%
		IniRead,SRCDIRS,%RJDBINI%,GENERAL,Source_Directory
		rnum:= ""
		srcdira:= SOURCE_DIRECTORYT . "|"
		Loop,parse,SRCDIRS,|
			{
				if (A_LoopField = "")
					{
						continue
				    }
				pkrs:= A_LoopField
				if ((pkrs = SOURCE_DIRECTORYT)or instr(pkrs,SOURCE_DIRECTORYT))
					{
						SB_SetText("The selected directory is a subdirectory of an existing source dir")
						return
					}
				srcdira.= pkrs . "|"
			}
		SOURCE_DIRECTORY:= srcdira
		iniwrite,%srcdira%,%RJDBINI%,GENERAL,Source_Directory
		guicontrol,,Source_DirectoryT,|%Source_DirectoryT%||%srcdira%
	}
return


EXCL_DirB:
gui,submit,nohide
Exclude_DirectoryT:= ""
FileSelectFolder,Exclude_DirectoryT,%fldflt%,3,Select Folder
if (fileExist(Exclude_DirectoryT) && (Exclude_DirectoryT <> "")&& !instr(Exclude_DirectoryT,"<"))
	{
		Loop,parse,Source_Directory,|
			{
				if instr(Exclude_DirectoryT,A_LoopField)
					{
						goto, AddExcl
					}
			}
		Loop,parse,DIST_DIRECTORY,|
			{
				if instr(Exclude_DirectoryT,A_LoopField)
					{
						goto, AddExcl
					}
			}
		SB_SetText("The selected directory is not a subdirectory of an existing source dir")
		return
		AddExcl:	
		Exclude_Directory= %Exclude_DirectoryT%
		IniRead,EXCDIRS,%RJDBINI%,GENERAL,Exclude_Directory
		excdira:= ""
		Loop,parse,EXCDIRS,|
			{
				if (A_LoopField = "")
					{
						continue
				    }
				pkrs:= A_LoopField
				if ((pkrs = Exclude_DirectoryT)or instr(pkrs,Exclude_DirectoryT))
					{
						SB_SetText("The selected directory is a subdirectory of an existing excluded dir")
						return
					}
				excdira.= pkrs . "|"
			}
		Exclude_Directory:= Exclude_Directory . "|" . excdira
		iniwrite,%Exclude_Directory%,%RJDBINI%,GENERAL,Exclude_Directory
		guicontrol,,Exclude_DirectoryT,|%Exclude_DirectoryT%||%excdira%
	}
return

Keyboard_MapBenable:
Menu,KBM_EMEN,Add,,
Loop, parse, SWAPMAPR,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		Menu,KBM_EMEN,Add,Enable %A_LoopField%,INIT%A_LoopField%
	}
Menu,KBM_EMEN,Show, %MENU_X% %MENU_Y%
Menu,KBM_EMEN,Delete
return

Keyboard_MapBDisable:
Keyboard_Mapper:= ""
Keyboard_MapperT:= ""
Player1_Template:= ""
Player1_TemplateT:= ""
Player2_Template:= ""
Player2_TemplateT:= ""
MediaCenter_Template:= ""
MediaCenter_TemplateT:= ""
iniwrite,%A_Space%,%RJDBINI%,JOYSTICKS,Keyboard_Mapper
iniwrite,%A_Space%,%RJDBINI%,JOYSTICKS,Player1_Template
iniwrite,%A_Space%,%RJDBINI%,JOYSTICKS,Player2_Template
iniwrite,%A_Space%,%RJDBINI%,JOYSTICKS,MediaCenter_Template
GuiControl,,Player1_TemplateT,
GuiControl,,Player2_TemplateT,
GuiControl,,MediaCenter_TemplateT,
GuiControl,,Keyboard_MapperT,
return

Keyboard_MapB:
KBMAPALRT:= "Lime"
gui,submit,nohide
mapovr:= ""
kbmdefloc:= home
xpadtmp:= ""
Antimtmp:= ""
jtktmp:= ""
if (dchk = "")
	{
		FileSelectFile,kbmpprt,35,%kbmdefloc%,Select File,xpadder.exe; antimicro.exe; JoyToKey.exe; JoyXoff.exe; DS4Windows.exe; rewasd.exe; antimicrox.exe
		;
	}
dchk:= ""
if ((kbmpprt <> "")&& !instr(kbmpprt,"<"))
	{
		Keyboard_Mappern:= kbmpprt
	}
	else {
		guicontrol,,Keyboard_MapperT,
		return
	}
prglp:=  ProgramFiles . "|" . Programfilesx86 . "|" . binhome
Loop,parse,MAPCFGS,|
	{
		gnm:= A_LoopField
		abb:= % %gnm%_executable
		if (abb = "")
			{
				lkgn:= gnm . "\" . gnm . ".exe"
				Loop,prglp,|
					{
						if fileexist(A_LoopField . "\" . lkgn)
							{
								kbmdefloc:= A_LoopField . "\" . gnm
								gnmte:= kbmdefloc . "\" . gnm . ".exe"
								iniwrite,%gnmte%,%RJDBINI%,JOYSTICKS,%gnm%_executable
							}
					}
			}
	}
Mapper:= ""
Loop,parse,MAPCFGS,|
	{
		if instr(kbmpprt,A_LoopField)
			{
				gosub, INIT%A_LoopField%
			}
	}
if !fileExist(Keyboard_Mapper)
	{
		KBMAPALRT= Red
	}
guicontrol, +c%KBMAPALRT%,keyboard_MapperT,
guicontrol,,keyboard_MapperT,%keyboard_Mapper%
tooltip,
return

Player1_TempB:
gui,submit,nohide
PLR1ALRT= Lime
FileSelectFile,Player1_TemplateT,3,%home%,Select File
if ((Player1_TemplateT <> "")&& !instr(Player1_TemplateT,"<"))
	{
		Player1_Template:= Player1_TemplateT
		iniwrite,%Player1_Template%,%RJDBINI%,JOYSTICKS,Player1_Template
	}
	else {
		guicontrol,,Player1_TemplateT,%Player1_Template%
		return
	}
guicontrol, +c%PLR1ALRT%,Player1_TemplateT
guicontrol,,Player1_TemplateT,%Player1_Template%
return

Player2_TempB:
gui,submit,nohide
PLR2ALRT= Lime
FileSelectFile,Player2_TemplateT,3,%home%,Select File
if ((Player2_TemplateT <> "")&& !instr(Player2_TemplateT,"<"))
	{
		Player2_Template:= Player2_TemplateT
		iniwrite,%Player2_Template%,%RJDBINI%,JOYSTICKS,Player2_Template
	}
	else {
		guicontrol,,Player2_TemplateT,%Player2_Template%
		return
	}
guicontrol, +c%PLR2ALRT%,Player2_TemplateT
guicontrol,,Player2_TemplateT,%Player2_Template%
return

MediaCenter_ProfB:
gui,submit,nohide
MCPRFALRT= Lime
FileSelectFile,MediaCenter_TemplateT,3,%home%,Select File
if ((MediaCenter_TemplateT <> "")&& !instr(MediaCenter_TemplateT,"<"))
	{
		MediaCenter_Template:= MediaCenter_TemplateT
		iniwrite,%MediaCenter_Template%,%RJDBINI%,JOYSTICKS,MediaCenter_Template																		
	}
	else {
		guicontrol,,MediaCenter_TemplateT,%MediaCenter_Template%
		return
	}
guicontrol, +c%MCPRFALRT%,MediaCenter_TemplateT
guicontrol,,MediaCenter_TemplateT,%MediaCenter_Template%
return

SVV_Prog:
ADMNV:= ""
if (ASADMIN = 1)
  {
		ADMNV:= "/RunAsAdmin" . A_Space
	  }
if (butrclick = "POSTAPP")
	{
		MsgBox,4096,MediaCenter Speakers,Select Your MediaCenter's Speakers After Clicking "OK"
		Loop,parse,GUIVARS,|
			{
				guicontrol,disable,%A_LoopField%
			}
		filedelete,%home%\MediaCenterAudio.cmd	
		fileappend,start "" "%binhome%\soundvolumeView.exe" %ADMNV%/setDefault "%sndvice%" all`n`nexit /b`n,%home%\MediaCenterAudio.cmd,UTF-8
		gosub,DeviceReturn
		POSTAPPF:= home . "\MediaCenterAudio.cmd"
		gosub, POSTAPP
	}
if (butrclick = "PREAPP")
	{
		MsgBox,4096,Game Speakers,Select Your Game Speakers After Clicking "OK"
		Loop,parse,GUIVARS,|
			{
				guicontrol,disable,%A_LoopField%
			}
		gosub,DeviceReturn
		filedelete,%home%\GameAudio.cmd
		fileappend,start "" "%binhome%\soundvolumeView.exe" %ADMNV%/setDefault "%sndvice%" all`n`nexit /b`n,%home%\GameAudio.cmd,UTF-8
		PREAPPF= %home%\GameAudio.cmd
		gosub, PREAPP
	}
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
	}	
mmtrc:= ""
return


MMPROG:
ADMNV:= ""
if (ASADMIN = 1)
  {
		ADMNV:= "/RunAsAdmin" . A_Space
	  }
alir= %home%\devlist.cmd
filedelete,%home%\cv.tmp
filedelete,%home%\cr.tmp
filedelete,%home%\tst.tmp
filedelete,%alir%
fileappend,echo off`n,%alir%,UTF-8
RunWait, "%multimonitor_tool%" /saveconfig tst.tmp,%home%,hide
RunWait, "%multimonitor_tool%" /scomma cr.tmp,%home%,hide
fileappend,for /f "tokens=1`,6`,8`,11`,12`,13`,17`,19`,20 delims=`," `%`%a in ('type "%home%\cr.tmp"') do if "`%`%~a" NEQ "Resolution" echo."`%`%~a|`%`%~b|`%`%~c|`%`%~d|`%`%~e|`%`%~f|`%`%~g|`%`%~h|`%`%~i|`%`%~j|`%`%~k" >>"%home%\cv.tmp",%home%\devlist.cmd,UTF-8
runwait,%alir%,,hide
fileread,inff,%home%\cv.tmp
filedelete,%alir%
filedelete,%home%\cr.tmp
filedelete,%home%\cv.tmp
vein:= ""
miny:= ""
Loop,parse,inff,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		miny+=1
		stringsplit,ebw,A_LoopField,|
		stringsplit,abk,ebw7,\
		monclv:= ebk2
		dispn%miny%:= ebk2 . "|" . ebw7
		Menu,addonz,Add,%ebw9%|%ebw6%|%ebw7%,XeinHC
	}
Menu, addonz, Show, x64 y354
return

XeinHC:
mondev:= A_ThisMenuItem
stringsplit,msp,mondev,|
stringsplit,abk,msp3,\
monclv:= abk2
abn:= 0
mon_sel:= ""
miny:= ""
Loop,7
	{
		resadx:= ""
		resady:= ""
		iniread,monid,%home%\tst.tmp,MONITOR%abn%,MonitorID
		stringsplit,monix,monid,\
		if ((monid = msp3)&&(monix2 = monclv))
			{
				mon_sel:=abn
				Loop,parse,inff,`n`r
					{
						if (A_LoopField = "")
							{
								continue
							}
						miny+=1	
						if (instr(A_LoopField,monix2)&& instr(A_LoopField,msp3))
							{
								Loop,20
									{
										eve%A_Index%:= ""
										ebe%A_Index%:= ""
									}
								stringsplit,ebe,A_LoopField,|
								stringsplit,eve,ebe5,%A_Space%
								resadx:= eve1
								resady:= eve3
								if ((resadx >= 2736)&&(resady >= 1824))
									{
										menu,addonh,add,2736 X 1824,TeinHC
									}
								if ((resadx >= 3840)&&(resady >= 2160))
									{
										menu,addonh,add,3840 X 2160,TeinHC
									}
								if ((resadx >=  1920)&&(resady >= 1080))
									{
										menu,addonh,add,1920 X 1080,TeinHC
									}	
								if ((resadx >= 1280)&&(resady >= 720))
									{
										menu,addonh,add,1280 X 720,TeinHC
									}
								if ((resadx >= 720)&&(resady >= 480))
									{
										menu,addonh,add,720 X 480,TeinHC
									}
								if ((resadx >= 640)&&(resady >= 480))
									{
										menu,addonh,add,640 X 480,TeinHC
									}
								break	
							}
					}
				break	
			}
		abn+=1
		}
Menu, addonh, Show,x64 y354
return

TeinHC:
splitres1:= ""
splitres2:= ""
reschoice:= A_ThisMenuItem
stringsplit,splitres,reschoice,%A_Space%,X
iniwrite,%splitres1%,%home%\tst.tmp,MONITOR%mon_sel%,Width
iniwrite,%splitres3%,%home%\tst.tmp,MONITOR%mon_sel%,Height
iniwrite,0,%home%\tst.tmp,MONITOR%mon_sel%,PositionX
iniwrite,0,%home%\tst.tmp,MONITOR%mon_sel%,PositionY
abn= 0
Loop,7
	{
		iniread,monid,%home%\tst.tmp,MONITOR%abn%,MonitorID
		stringsplit,monix,monid,\
		if ((abn <> mon_sel)&&(monid <> "ERROR"))
			{
				iniwrite,0,%home%\tst.tmp,MONITOR%abn%,Width
				iniwrite,0,%home%\tst.tmp,MONITOR%abn%,Height
				iniwrite,0,%home%\tst.tmp,MONITOR%abn%,BitsPerPixel
				iniwrite,0,%home%\tst.tmp,MONITOR%abn%,PositionX
				iniwrite,0,%home%\tst.tmp,MONITOR%abn%,PositionY
				iniwrite,0,%home%\tst.tmp,MONITOR%abn%,DisplayFrequency
				inidelete,%home%\tst.tmp,MONITOR%abn%,Name
			}
		abn+=1
	}
fileMove %home%\tst.tmp,%home%\GameMonitors.mon,1
MM_GAME_Config:= home . "\" . "GameMonitors.mon"
iniwrite,%MM_GAME_Config%,%RJDBINI%,CONFIG,MM_GAME_Config
guicontrol, +cLime, MM_Game_ConfigT
guicontrol,,MM_GAME_ConfigT,%MM_GAME_Config%
return

DeviceReturn:
alir:= home . "\devlist.cmd"
filedelete,%home%\cr.txt
filedelete,%alir%
fileappend,echo off`n,%alir%,UTF-8
fileappend,for /f "tokens=1`,2`,3 delims=`," `%`%a in ('"%binhome%\SoundVolumeView.exe" /scomma') do if "`%`%~b" == "Device" for /f `%`%x in ("`%`%~c") do if "`%`%~x" == "Render" echo.`%`%~a `>`>%home%\cr.txt`nexit /b`n,%home%\devlist.cmd,UTF-8
runwait,%alir%,,hide
fileread,inff,%home%\cr.txt
filedelete,%alir%
filedelete,%home%\cr.txt
vein:= ""
Loop,parse,inff,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		vein+=1
		ak%vein%:= A_LoopField
		Menu,addonx,Add,%A_loopField%,VeinHC
	}
Menu, addonx, Show, %A_GuiX%, %A_GuiY%	
return
VeinHC:
sndvice:= A_ThisMenuItem

return

SSD_Prog:
Run, %binhome%\ssd.exe,%binhome%,,
return


MM_ToolBDisable:
MultiMonitor_Tool:= ""
MultiMonitor_ToolT:= ""
MM_GAME_Config:= ""
MM_GAME_ConfigT:= ""
MM_MEDIACENTER_Config:= ""
MM_MEDIACENTER_ConfigT:= ""
iniwrite,%A_SPace%,%RJDBINI%,GENERAL,MultiMonitor_Tool
iniwrite,%A_SPace%,%RJDBINI%,CONFIG,MM_GAME_Config
iniwrite,%A_SPace%,%RJDBINI%,CONFIG,MM_Mediacenter_Config
Guicontrol,,MultiMonitor_ToolT,
Guicontrol,,MM_Game_ConfigT,
Guicontrol,,MM_MediaCenter_ConfigT,
return

GBT_AUTO:
Borderless_gaming_Program:= A_Space
if fileexist(ProgramFiles . "\" "Borderless Gaming" . "\" . "BorderlessGaming.exe")
	{
		Borderless_gaming_Program= %ProgramFiles%\Borderless Gaming\BorderlessGaming.exe
	}
if fileexist(ProgramFilesx86 . "\" "Borderless Gaming" . "\" . "BorderlessGaming.exe")
	{
		Borderless_gaming_Program= %ProgramFilesx86%\Borderless Gaming\BorderlessGaming.exe
	}
if fileexist(binhome . "\" "Borderless Gaming" . "\" . "borderless-gaming-portable.exe")
	{
		Borderless_gaming_Program= %ProgramFilesx86%\Borderless Gaming\borderless-gaming-portable.exe
	}
iniwrite,%Borderless_Gaming_Program%,%RJDBINI%,GENERAL,Borderless_Gaming_Program
return
	
MM_AUTO:
MultiMonitor_Tool:= A_Space
MM_GAME_Config:= A_Space
MM_MediaCenter_Config:= A_Space
if fileexist(ProgramFiles . "\Multimonitortool.exe")
	{
		MultiMonitor_Tool= %ProgramFiles%\Nirsoft\x64\Multimonitortool.exe
	}
if fileexist(ProgramFilesx86 . "\Nirsoft\x64\Multimonitortool.exe")
	{
		MultiMonitor_Tool= %ProgramFilesx86%\Nirsoft\x64\Multimonitortool.exe
	}
if fileexist(binhome . "\Multimonitortool.exe")
	{
		MultiMonitor_Tool= %binhome%\Multimonitortool.exe
	}
iniwrite,%MultiMonitor_ToolT%,%RJDBINI%,GENERAL,MultiMonitor_Tool
if fileexist(home . "\DesktopMonitors.mon")
		{
			MM_MediaCenter_Config= %home%\DesktopMonitors.mon
		}
if fileexist(home . "\GameMonitors.mon")
		{
			MM_GAME_Config= %home%\GameMonitors.mon
		}
iniwrite,%MultiMonitor_Tool%,%RJDBINI%,GENERAL,MultiMonitor_Tool
iniwrite,%MM_GAME_Config%,%RJDBINI%,CONFIG,MM_GAME_Config
iniwrite,%MM_MediaCenter_Config%,%RJDBINI%,CONFIG,MM_MediaCenter_Config
guicontrol,,MultiMonitor_ToolT,%MultiMontior_Tool%
guicontrol,,MM_Game_Config,%MM_Game_Config%
guicontrol,,MM_MediaCenter_Config,%MM_MediaCenter_Config%

if (fileexist(MM_Game_Config)&& fileexist(MM_MediaCenter_Config)&& fileExist(MultiMonitor_Tool))
	{
		iniwrite,1,%RJDBINI%,GENERAL,MonitorMode
	}
return

MM_ToolB:
gui,submit,nohide
if (dchk = "")
	{
		MultiMonitor_ToolT:= ""
		FileSelectFile,MultiMonitor_ToolT,3,%binhome%,Select File,multimonitor*.exe
	}
dchk:= ""
if ((MultiMonitor_ToolT <> "")&& !instr(MultiMonitor_ToolT,"<"))
	{
		MultiMonitor_Tool= %MultiMonitor_ToolT%
		iniwrite,%MultiMonitor_Tool%,%RJDBINI%,GENERAL,MultiMonitor_Tool
	}
	else {
		guicontrol,,MultiMonitor_ToolT,
		iniwrite,0,%RJDBINI%,GENERAL,MonitorMode
		return
	}
guicontrol,,MultiMonitor_ToolT,%MultiMonitor_Tool%
if ((MM_Mediacenter_Config = "")&& instr(MultiMonitor_Tool,"MultiMonitorTool.exe"))
    {
        msgbox,4100,Setup,Setup the MediaCenter Monitor Profile now?
        ifmsgbox,yes
            {
                gosub, MMSETUPD
            }
    }
if ((MM_GAME_Config = "")&& instr(MultiMonitor_Tool,"MultiMonitorTool.exe"))
    {
        msgbox,4100,Setup,Setup the Game Monitor Profile now?`nSelect the game-monitor in the dropdown menu
        ifmsgbox,yes
            {
                gosub, MMPROG
            }
    }
if (fileexist(MM_Game_Config)&& fileexist(MM_MediaCenter_Config)&& fileExist(MultiMonitor_Tool))
	{
		iniwrite,2,%RJDBINI%,GENERAL,MonitorMode
		guicontrol,,MultiMontior_ToolT,%MultiMontior_Tool%
		guicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_Config%
		guicontrol,,MM_Game_ConfigT,%MM_Game_Config%
	}
guicontrol,,MultiMonitor_ToolT,%MultiMonitor_Tool%
return


MM_Game_CfgB:
gui,submit,nohide
guicontrolget,gmcfg,,MM_Game_ConfigT
setupmm:= ""
if (!fileexist(CFGDIR . "\" . "GameMonitors.mon")or !fileexist(gmcfg))
	{
		 msgbox,4100,Setup,Setup the Multimonitor Tool now?
        ifmsgbox,yes
            {
				gosub, MMPROG
				setupmm= 1
            }
	}
if ((setupmm = "")or !fileexist(CFGDIR . "\" . "GameMonitors.mon"))
	{
		FileSelectFile,MM_GAME_ConfigT,35,,Select File,*.cfg; *.mon
		if ((MM_GAME_ConfigT <> "")&& !instr(MM_GAME_ConfigT,"<"))
			{
				MM_GAME_Config= %MM_GAME_ConfigT%
				FileCopy,%MM_GAME_Config%,%home%\GameMonitors.mon
				iniwrite,%MM_GAME_Config%,%RJDBINI%,CONFIG,MM_GAME_Config
			}
			else {
				guicontrol,,MM_GAME_ConfigT, 
				return
			}
	}
if (fileexist(MM_Game_Config)&& fileexist(MM_MediaCenter_Config)&& fileExist(MultiMonitor_Tool))
	{
		iniwrite,2,%RJDBINI%,GENERAL,MonitorMode
		guicontrol,,MultiMontior_ToolT,%MultiMontior_Tool%
		guicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_Config%
		guicontrol,,MM_Game_ConfigT,%MM_Game_Config%
	}
guicontrol,,MM_GAME_ConfigT,%MM_GAME_Config%
return

MM_MediaCenter_CfgB:
gui,submit,nohide
guicontrolget,dtcfg,,MM_MediaCenter_ConfigT
setupmm:= ""
if (!fileexist(CFGDIR . "\" . "DesktopMonitors.mon")or !fileexist(dtcfg))
	{
		 msgbox,4100,Setup,Setup the MediaCenter Monitors now?
        ifmsgbox,yes
            {
				gosub, MMSETUPD
				setupmm= 1
            }
	}
if ((setupmm = "")or !fileexist(CFGDIR . "\" . "DesktopMonitors.mon"))
	{
		FileSelectFile,MM_MediaCenter_ConfigT,35,%home%,Select File,*.cfg;*.mon
		if ((MM_MediaCenter_ConfigT <> "")&& !instr(MM_MediaCenter_ConfigT,"<"))
			{
				MM_MediaCenter_Config= %MM_MediaCenter_ConfigT%
				FileCopy,%MM_MediaCenter_Config%,%home%\DesktopMonitors.mon
				iniwrite,%MM_MediaCenter_Config%,%RJDBINI%,CONFIG,MM_MediaCenter_Config
			}
			else {
				guicontrol,,MM_MediaCenter_ConfigT, 
				return
			}
	}
setupmm:= ""
if (fileexist(MM_Game_Config)&& fileexist(MM_MediaCenter_Config)&& fileExist(MultiMonitor_Tool))
	{
		iniwrite,2,%RJDBINI%,GENERAL,MonitorMode
		guicontrol,,MultiMontior_ToolT,%MultiMontior_Tool%
		guicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_Config%
		guicontrol,,MM_Game_ConfigT,%MM_Game_Config%
	}
guicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_Config%
return


BGM_ProgBDisable:
Borderless_gaming_Program:= ""
Borderless_gaming_ProgramT:= ""
iniwrite,%A_Space%,%RJDBINI%,GENERAL,Borderless_Gaming_Program
GuiControl, +cSilver, Borderless_Gaming_ProgramT
Guicontrol,,Borderless_Gaming_ProgramT,DISABLED
return

BGM_ProgB:
gui,submit,nohide
BGP_State:= ""
Borderless_Gaming_ProgramT:= ""
if (dchk = "")
	{
		FileSelectFile,Borderless_Gaming_ProgramT,3,%binhome%,*.exe
	}
dchk=	
if ((Borderless_Gaming_ProgramT <> "")&& !instr(Borderless_Gaming_ProgramT,"<"))
	{
		guicontrolget,teval,,BGP_TE
		teval:= (teval * 8)
		guicontrolget,tuval,,BGP_TU
		tuval:= (tuval * 5)
		BGP_State:= (tuval + BGP_Enable + teval)
		Borderless_Gaming_Program= %Borderless_Gaming_ProgramT%
		iniwrite,%Borderless_Gaming_Program%,%RJDBINI%,GENERAL,Borderless_Gaming_Program
		iniwrite,%BGP_State%,%RJDBINI%,GENERAL,BGP_State
	}
	else {
		guicontrol,,BGP_Enable,0
		guicontrol,,Borderless_Gaming_ProgramT,
		return
	}
guicontrol,,Borderless_Gaming_ProgramT,%Borderless_Gaming_Program%
guicontrol,,BGP_Enable,1
guicontrol,,BGP_TU,1
guicontrol,,BGP_TE,1
return

JBE_ProgB:
gui,submit,nohide
guicontrolget,JBEWait,,JBEWait
predl=<
if (JBEWait = 1)
	{
		predl=W<
	}
if (dchk = "")
	{
		JustBeforeExitT:= ""
		FileSelectFile,JustBeforeExitT,3,%home%,*.*
	}
dchk:= ""
if ((JustBeforeExitT <> "")&& (JustBeforeExitT <> "Cloud_Backup"))
	{
		JustBeforeExit= %predl%%JustBeforeExitT%
		Guicontrol, +cLime, JustBeforeExitT
		iniwrite,%JustBeforeExit%,%RJDBINI%,GENERAL,JustBeforeExit
	}
	else {
		guicontrol,,JustBeforeExitT,Run Before Exit
		return
	}
guicontrol,,JustBeforeExitT,%JustBeforeExitT%
guicontrol,,JBEWAIT,%JBEWAIT%
return

JBE_ProgBDisable:
JustBeforeExit:= ""
JustBeforeExitT:= ""
iniwrite,%A_Space%,%RJDBINI%,GENERAL,JustBeforeExit
guicontrol,,JustBeforeExitT,Run Before Exit
JBEWAIT:= 0
guicontrol,,JBEWAIT,%JBEWAIT%
return

JAL_ProgBDisable:
JustAfterLaunch:= ""
JustAfterLaunchT:= ""
iniwrite,%A_Space%,%RJDBINI%,GENERAL,JustAfterLaunch
guicontrol,,JustAfterLaunchT,Run After Launch
JALWAIT:= 0
guicontrol,,JALWAIT,%JALWAIT%
return

JAL_ProgB:
gui,submit,nohide
guicontrolget,JALWait,,JALWait
predl:="<"
if (JALWait = 1)
	{
		predl:= "W<"
	}
if (dchk = "")
	{
		JustAfterLaunchT:= ""
		FileSelectFile,JustAfterLaunchT,3,%home%,*.*
	}
dchk:= ""
if ((JustAfterLaunchT <> "")&& (JustAfterLaunchT <> "Cloud_Restore"))
	{
		JustAfterLaunch:= predl . JustAfterLaunchT
		Guicontrol, +cLime, JustAfterLaunchT
		iniwrite,%JustAfterLaunch%,%RJDBINI%,GENERAL,JustAfterLaunch
	}
	else {
		guicontrol,,JustAfterLaunchT,Run After Launch
		return
	}
guicontrol,,JustAfterLaunchT,%JustAfterLaunch%
guicontrol,,JALWAIT,%JALWAIT%
return

BGP_TE:

BGP_TU:
gui,submit,nohide
BGP_State:= ""
guicontrolget,BGP_Enable,,BGP_Enable
guicontrolget,teval,,BGP_TE
teval:= (teval * 8)
guicontrolget,tuval,,BGP_TU
tuval:= (tuval * 5)
BGP_State:= (tuval + BGP_Enable + teval)
iniwrite,%BGP_State%,%RJDBINI%,GENERAL,BGP_State
return
gui,submit,nohide
BGP_State:= ""
guicontrolget,BGP_Enable,,BGP_Enable
guicontrolget,teval,,BGP_TE
teval:= (teval * 8)
guicontrolget,tuval,,BGP_TU
tuval:= (tuval * 5)
BGP_State:= (tuval + BGP_Enable + teval)
iniwrite,%BGP_State%,%RJDBINI%,GENERAL,BGP_State
return
BGP_Enable:
gui,submit,nohide
BGP_State:= ""
iniread,BGProg,%RJDBINI%,GENERAL,Borderless_Gaming_Program
if ((BGProg = "")or(BGProg = "ERROR"))
	{
		guicontrol,,BGP_Enable,0
		SB_SetText("Borderless Gaming Program Not Found")
		return
	}
guicontrolget,BGP_Enable,,BGP_Enable
guicontrolget,teval,,BGP_TE
teval:= (teval * 8)
guicontrolget,tuval,,BGP_TU
tuval:= (tuval * 5)
BGP_State:= (tuval + BGP_Enable + teval)
iniwrite,%BGP_State%,%RJDBINI%,GENERAL,BGP_State
return

PostAPP:
gui,submit,nohide
guicontrolget,fbd,,PostDD
guicontrolget,fbdnum,,PosTdNUM
guicontrolget,PostWait,,PostWait
Postwl:= ""
if (Postwait = 1)
	{
		Postwl= W
	}
if instr(POSTAPPF,".cmd")
	{
		Postwl.= "H"
	}
iniread,inn,%RJDBINI%,CONFIG,%fbdnum%_Post
if (inn = A_SPace)
	{
		inn:= A_Space
	}
if (POSTAPPF <> "")
  {
	  POSTAPPT= %POSTAPPF%
	  POSTAPPF= 
	  goto, POSTAPPDEF
	  }
FileSelectFile,PostAPPT,35,%flflt%,Select File
POSTAPPDEF:
if (PostAPPT <> "")
	{
		PostAPP= %PostAPPT%
		PostList= |
		Loop,3
			{
				iniread,cftsv,%RJDBINI%,CONFIG,%A_Index%_Post
				stringsplit,cftst,cftsv,<
				if (A_Index = fbdnum)
					{
						iniwrite,%fbdnum%%Postwl%<%PostAPP%,%RJDBINI%,CONFIG,%fbdnum%_Post
						Postlist.= fbdnum . Postwl . "<" . PostAPP . "|"
						if (A_Index = 1)
							{
								PostList.= "|"
							}
						continue
					}
				Postlist.= cftsv . "|"
				if (A_Index = 1)
					{
						PostList.= "|"
					}
			 }
		guicontrol,,PostDD,%PostList%
		guicontrol,,POSTDNUM,1
	}
return

PREAPP:
gui,submit,nohide
guicontrolget,fbd,,PREDD
guicontrolget,fbdnum,,PRETNUM
guicontrolget,PreWait,,PreWait
prewl:= ""
if (prewait = 1)
	{
		prewl:= "W"
	}
if instr(PREAPPF,"audio.cmd")
	{
		prewl.= "H"
	}
iniread,inn,%RJDBINI%,CONFIG,%fbdnum%_Pre
if (inn = A_SPace)
	{
		inn:= A_Space
	}
if (PREAPPF <> "")
  {
	  PREAPPT:= PREAPPF
	  PREAPPF:= "" 
	  goto, PREAPPDEF
	  }
FileSelectFile,PREAPPT,35,%flflt%,Select File
PREAPPDEF:
if (PREAPPT <> "")
	{
		PREAPP:= PREAPPT
		PreList:= "|"
		Loop,3
			{
				iniread,cftsv,%RJDBINI%,CONFIG,%A_Index%_Pre
				stringsplit,cftst,cftsv,<
				if (A_Index = fbdnum)
					{
						iniwrite,%fbdnum%%prewl%<%PREAPP%,%RJDBINI%,CONFIG,%fbdnum%_Pre
						PreList.= fbdnum . prewl . "<" . PREAPP . "|"
						if (A_Index = 1)
							{
								PreList.= "|"
							}
						continue
					}
				PreList.= cftsv . "|"
				if (A_Index = 1)
					{
						PreList.= "|"
					}
			 }
		guicontrol,,PreDD,%PreList%
		guicontrol,,PRETNUM,1
	}
return

REMEXCL:
gui,submit,nohide
guicontrolget,EXCLDIRDD,,EXCLUDE_DIRECTORYT
iniread,excltst,%RJDBINI%,GENERAL,Exclude_Directory
knum:= ""
Exclist:= ""
Loop,parse,excltst,|
    {
		IF (a_lOOPfIELD = "")
			{
				CONTINUE
			}
		if (A_LoopField = EXCLDIRDD)
			{
				 continue
			}
		knum+=1
		CURDP:= A_LoopField
		if (knum = 1)
			{
				exclist.= CURDP . "||"
				continue
			}
										   
		Exclist.= CURDP . "|"
    }
EXCLUDE_DIRECTORY= %excList%
iniwrite,%exclist%,%RJDBINI%,GENERAL,Exclude_Directory
guicontrol,,EXCLUDE_DirectoryT,|%exclist%
return

REMSRC:
gui,submit,nohide
guicontrolget,SRCDIRDD,,SOURCE_DIRECTORYT
iniread,cftst,%RJDBINI%,GENERAL,Source_Directory
knum:= ""
Srclist:= ""
Loop,parse,cftst,|
    {
		IF (a_lOOPfIELD = "")
			{
				CONTINUE
			}
		if (A_LoopField = SRCDIRDD)
			{
				 continue
			}
		knum+=1
		CURDP:= A_LoopField
		if (knum = 1)
			{
				Srclist.= CURDP . "||"
				continue
			}
										   
		Srclist.= CURDP . "|"
    }
SOURCE_DIRECTORY= %SrcList%
iniwrite,%Srclist%,%RJDBINI%,GENERAL,SOURCE_Directory
guicontrol,,SOURCE_DirectoryT,|%Srclist%
return

KILLCHK:
gui,submit,nohide
guicontrolget,KILLCHK,,KILLCHK
return

NAMECHK:
gui,submit,nohide
guicontrolget,namechk,,namechk,
iniwrite,%namechk%,%RJDBINI%,GENERAL,Name_Check
return

INCLALTS:
gui,submit,nohide
guicontrolget,INCLALTS,,INCLALTS
return

EXCLUDE_DirectoryDD:
gui,submit,nohide
guicontrolget,CUREM,,EXCLUDE_DIRECTORYT
return


SOURCE_DirectoryDD:
gui,submit,nohide
guicontrolget,CURDP,,SOURCE_DIRECTORYT
return

DELpostAPP:
gui,submit,nohide
guicontrolget,DELpostDD,,POSTDNUM
iniWrite,%DELpostDD%<,%RJDBINI%,CONFIG,%DELpostDD%_post
postList:= "|"
postWaitn:= ""
tpds:= ""
Loop, 3
	{
		iniread,tpds,%RJDBINI%,CONFIG,%A_Index%_post
		plre%a_index%:= tpds
		postList.= tpds . "|"
		
	}
guicontrol,,postDD,|%plre1%|%postList%
guicontrol,,postWAIT,%postwaitn%
guicontrol,,postDNUM,1
return

DELPREAPP:
gui,submit,nohide
guicontrolget,DELPreDD,,PRETNUM
iniWrite,%DELPreDD%<,%RJDBINI%,CONFIG,%DELPreDD%_Pre
PreList:= "|"
PreWaitn:= ""
tpds:= ""
Loop, 3
	{
		iniread,tpds,%RJDBINI%,CONFIG,%A_Index%_Pre
		plre%a_index%:= tpds
		PreList.= tpds . "|"
	}
guicontrol,,PreDD,|%plre1%|%PreList%
guicontrol,,PreWAIT,%prewaitn%
guicontrol,,PRETNUM,1
return

EXEONLY:
filextns= exe
return

SCONLY:
filextns= lnk
return

BOTHSRCH:
filextns= exe|lnk|_lnk_
return

PREWAIT:
PREwl:= ""
gui,submit,nohide
guicontrolget,fbdnum,,PRETNUM
guicontrolget,PREwait,,PREwait
if (PREwait = 1)
	{
		prewl= W
	}
guicontrolget,dd,,PREDD
stringsplit,ddn,dd,<
stringreplace,ddn1,ddn1,W,,
if ((ddn2 = A_Space) or (ddn2 = ""))
	{
		ddn2:= ""
		prewl:= ""
	}
PreList= |
Loop,3
	{
		iniread,cftsv,%RJDBINI%,CONFIG,%A_Index%_Post
		stringsplit,cftst,cftsv,<
		if (A_Index = fbdnum)
			{
				iniwrite,%fbdnum%%prewl%<%cftst2%,%RJDBINI%,CONFIG,%fbdnum%_Post
				PreList.= fbdnum . prewl . "<" . cftst2 . "||"
				continue
			}
		PreList.= cftsv . "|"
	 }
guicontrol,,PREDD,%PreList%
return

JALWait:
gui,submit,nohide
guicontrolget,JALWait,,JALWait
predl:="<"
if (JALWait = 1)
	{
		predl:="W<"
	}
JALtmp2:= ""
stringsplit,JALtmp,JustAfterLaunch,<
JustAfterLaunch:= JALtmp2
jalop:= JALtmp1
stringreplace,jalop,jalop,W,,
if (JALtmp2 = "")
	{
		jalop:= predl
		JustAfterLaunch:= JALtmp1
	}
if ((JustAfterLaunch = "")or(JustAfterLaunch = "ERROR")or !fileexist(JustAfterLaunch))
	{
		SB_SetText("A program must be assigned")
		iniwrite,%A_Space%,%RJDBINI%,GENERAL,JustAfterLaunch
		guicontrol,,JustAfterLaunchT,Run After Launch
		return
	}
jalcl:
JustAfterLaunch:= predl . JustAfterLaunch
iniwrite,%JustAfterLaunch%,%RJDBINI%,GENERAL,JustAfterLaunch
guicontrol,,JustAfterLaunchT,%justAfterLaunch%
return

JBEWait:
gui,submit,nohide
guicontrolget,JBEWait,,JBEWait
predl=<
if (JBEWait = 1)
	{
		predl:="W<"
	}
jbetmp2:= ""
stringsplit,jbetmp,JustBeforeExit,<
JustBeforeExit= %jbetmp2%
jbeop= %jbetmp1%
stringreplace,jbeop,jbeop,W,,
if (jbetmp2 = "")
	{
		jbeop:= predl
		JustBeforeExit:= jbetmp1
	}
if ((JustBeforeExit = "")or(JustbeforeExit = "ERROR")or !fileexist(JustBeforeExit))
	{
		SB_SetText("A program must be assigned")
		iniwrite,%A_Space%,%RJDBINI%,GENERAL,JustBeforeExit
		guicontrol,,JustBeforeExitT,Run Before Exit
		return
	}
jbecl:
JustBeforeExit:= predl . "<" . JustBeforeExit
iniwrite,%JustBeforeExit%,%RJDBINI%,GENERAL,JustBeforeExit
guicontrol,,JustBeforeExitT,%justbeforeexit%
return

postWAIT:
postwl:= ""
gui,submit,nohide
guicontrolget,fbdnum,,postDNUM
guicontrolget,postwait,,postwait
if (postwait = 1)
	{
		postwl:= "W"
	}
guicontrolget,dd,,postDD
stringsplit,ddn,dd,<
stringreplace,ddn1,ddn1,W,,
if ((ddn2 = A_Space) or (ddn2 = ""))
	{
		ddn2:= ""
		postwl:= ""
	}
postList= |
Loop,3
	{
		iniread,cftsv,%RJDBINI%,CONFIG,%A_Index%_post
		stringsplit,cftst,cftsv,<
		if (A_Index = fbdnum)
			{
				iniwrite,%fbdnum%%postwl%<%cftst2%,%RJDBINI%,CONFIG,%fbdnum%_post
				postList.= fbdnum . postwl . "<" . cftst2 . "||"
				continue
			}
		postList.= cftsv . "|"
	 }
guicontrol,,postDD,%postList%
return

avnix:
newavinx:= % gfmn%iinx%
ifnotinstring,gmnames,%newavinx%|
	{
		gmnames.= newavinx . "|"
	}
return

postDD:
gui,submit,nohide
guicontrolget,postdd,,postDD
stringsplit,povr,postdd,<
if instr(povr1,1)
	{
		guicontrol,,postDDT,<game.exe><$This_Prog$><Mapper><Monitor>
	}
if instr(povr1,2)
	{
		guicontrol,,postDDT,<game.exe><Mapper><$This_Prog$><Monitor>
	}
if instr(povr1,3)
	{
		guicontrol,,postDDT,<game.exe><Mapper><Monitor><$This_Prog$>
	}
if instr(povr1,"W")
	{
		guicontrol,,postwait,1
	}
	else {
		guicontrol,,postwait,0
		}
stringreplace,postDNUM,povr1,W,,
guicontrol,,postDNUM,%postDNUM%
return

PREDD:
gui,submit,nohide
guicontrolget,predd,,PreDD
stringsplit,povr,predd,<
if instr(povr1,3)
	{
		guicontrol,,PREDDT,<$This_Prog$><Monitor><Mapper><game.exe>
	}
if instr(povr1,2)
	{
		guicontrol,,PREDDT,<Monitor><$This_Prog$><Mapper><game.exe>
	}
if instr(povr1,1)
	{
		guicontrol,,PREDDT,<Monitor><Mapper><$This_Prog$><game.exe>
	}
if instr(povr1,"W")
	{
		guicontrol,,Prewait,1
	}
	else {
		guicontrol,,Prewait,0
		}
stringreplace,PRETNUM,povr1,W,,
guicontrol,,PRETNUM,%PRETNUM%
return

INITALL:
FileRead,RJTMP,%source%\RJDB.set
Loop,parse,STDVARS,|
    {
        %A_LoopField%:= ""
    }
initz= 1
stringreplace,RJTMP,RJTMP,[LOCV],%home%,All
FileDelete,%home%\RJDB.ini
fileappend,`n,%home%\RJDB.ini,UTF-8-RAW
FileAppend,%RJTMP%,%home%\RJDB.ini,UTF-8-RAW
return

RESET:
Msgbox,260,Reset,Reset the program to default settings?, 5
ifMsgbox,Yes
    {
        gosub,INITALL
        resetting= 1
        filedelete,%home%\AntimicroX_!.cmd
        filedelete,%home%\Antimicro_!.cmd
        filedelete,%home%\xpadder_!.cmd
        filedelete,%home%\joyXoff_!.cmd
        filedelete,%home%\joytokey_!.cmd
        filedelete,%home%\keysticks_!.cmd
        filedelete,%home%\lookup.db
        filedelete,%home%\MediaCenter.xpadderprofile
        filedelete,%home%\MediaCenter2.xpadderprofile
        filedelete,%home%\Player1.xpadderprofile
        filedelete,%home%\Player2.xpadderprofile
		filedelete,%home%\MediaCenter.gamecontroller.amgp
        filedelete,%home%\MediaCenter2.gamecontroller.amgp
        filedelete,%home%\Player1.gamecontroller.amgp
        filedelete,%home%\Player2.gamecontroller.amgp
		filedelete,%home%\MediaCenter.keyx
        filedelete,%home%\MediaCenter2.keyx
        filedelete,%home%\Player1.keyx
        filedelete,%home%\Player2.keyx
		filedelete,%home%\MediaCenter.cfg
        filedelete,%home%\MediaCenter2.cfg
        filedelete,%home%\Player1.cfg
        filedelete,%home%\Player2.cfg
        filedelete,%SRCFILE%
        filedelete,%home%\*.tmp
        filedelete,%home%\GameAudio.cmd
        filedelete,%home%\MediaCenterAudio.cmd
        filedelete,%home%\GameMonitors.mon
        filedelete,%home%\DesktopMonitors.mon
        goto,popgui
		LV_Delete()
		guicontrol,,SOURCE_DIRECTORYT,%SOURCE_Directory%
		guicontrol,,PreDD,|1<||2<|3<
		guicontrol,,PostDD,|1<||2<|3<
    }
return

EnableLogging:
gui,submit,nohide
guicontrolget,EnableLogging,,EnableLogging
iniwrite,%EnableLogging%,%RJDBINI%,GENERAL,Logging
return

OPNLOG:
gui,submit,NoHide
if fileexist(home . "\" . "log.txt")
	{
		Run,Notepad %thelog%,
	}
else {
	SB_SetText("no log exists")
}
return

MM_ToolBReset:
if (MultiMonitor_Tool = "")
	{
		SB_SetText("Multimonitor Tool is not configured")
		return
	}
mmtclr= Lime
if !fileExist(MultiMonitor_Tool)
	{
		SB_SetText("Multimonitor Tool not found")
		mmtclr= Red
	}
Guicontrol, +c%mmtclr%, MultiMonitor_ToolT
Guicontrol,, MultiMonitor_ToolT,%MultiMonitor_ToolT%
MM_GAME_Config:= ""
MM_GAME_ConfigT:= ""
MM_MEDIACENTER_Config:= ""
MM_MEDIACENTER_ConfigT:= ""
iniwrite,%A_SPace%,%RJDBINI%,CONFIG,MM_GAME_Config
iniwrite,%A_SPace%,%RJDBINI%,CONFIG,MM_Mediacenter_Config
Guicontrol,,MM_Game_ConfigT,
Guicontrol,,MM_MediaCenter_ConfigT,
gosub,MMSETUPD
gosub,MMPROG
return

WRITEMAPR:

INITANTIMICRO:
Mapper= 1
prf= am
JMAP= antimicro
%JMAP%_executable=%kbmpprt%
mapper_extension= gamecontroller.amgp
gosub,KEYMAPSET
iniwrite,%home%,%binhome%\%JMAP%_settings.ini,GENERAL,DefaultProfileDir
iniwrite,%home%,%binhome%\%JMAP%_settings.ini,GENERAL,LastProfileDir
iniwrite,1,%binhome%\%JMAP%_settings.ini,GENERAL,CloseToTray
iniwrite,1,%binhome%\%JMAP%_settings.ini,GENERAL,MinimizeToTaskbar
iniwrite,@Size(650 580),%binhome%\%JMAP%_settings.ini,GENERAL,WindowSize
iniwrite,@Point(0 0),%binhome%\%JMAP%_settings.ini,GENERAL,WindowPosition
return


INITXPADDER:
Mapper= 2
prf= xp
JMAP= Xpadder
%JMAP%_executable=%kbmpprt%
mapper_extension= xpadderprofile
goto,KEYMAPSET
return


INITJOYTOKEY:
Mapper= 3
prf= jk
JMAP= JoyToKey
%JMAP%_executable=%kbmpprt%
mapper_extension= cfg
goto,KEYMAPSET
return

INITJOYXOFF:
Mapper= 4
prf= of
JMAP= JoyXoff
%JMAP%_executable=%kbmpprt%
mapper_extension= joyx
goto,KEYMAPSET
return

INITANTIMICROX:
Mapper= 5
prf= ax
JMAP= antimicrox
%JMAP%_executable=%kbmpprt%
mapper_extension= gamecontroller.amgp
gosub,KEYMAPSET
iniwrite,%home%,%LADTA%\%JMAP%_settings.ini,GENERAL,DefaultProfileDir
iniwrite,%home%,%LADTA%\%JMAP%_settings.ini,GENERAL,LastProfileDir
iniwrite,1,%LADTA%\%JMAP%_settings.ini,GENERAL,CloseToTray
iniwrite,1,%LADTA%\%JMAP%_settings.ini,GENERAL,MinimizeToTaskbar
iniwrite,@Size(650 580),%LADTA%\%JMAP%_settings.ini,GENERAL,WindowSize
iniwrite,@Point(0 0),%LADTA%\%JMAP%_settings.ini,GENERAL,WindowPosition
return

INITKEYSTICKS:
Mapper= 6
prf= ks
JMAP= Keysticks
%JMAP%_executable=%kbmpprt%
mapper_extension= xpadderprofile
goto,KEYMAPSET
return

KEYMAPSET:
if (kbmpprt = "")
	{
		kbmt= \%jmap%\%jmap%.exe
		kbmdefloc:= ""
		kbmpprt:= ""
		JMAPini:= ""
		if fileexist(Programfilesx86 . kbmt)
			{
				kbmdefloc= %programfilesx86%\%JMAP%
				kbmpprt= %kbmdefloc%\%JMAP%.exe
			}
		if fileexist(A_Programfiles . kbmt)
			{
				kbmdefloc= %programfiles%\%JMAP%
				kbmpprt= %kbmdefloc%\%JMAP%.exe
			}	
		if fileexist(binhome . kbmt)
			{
				kbmdefloc= %binhome%\%JMAP%
				kbmpprt= %kbmdefloc%\%JMAP%.exe
			}
		ifexist,%jtkprgd%\%JMAP%.ini
			{
				%JMAP%ini:= jtkprgd "\" . JMAP . ".ini"
			}
		if fileexist(A_MyDocuments . "\JoyToKey" . "\" . JMAP . ".ini")
			{
				%JMAP%ini:= A_MyDocuments . "\JoyToKey\" . JMAP . ".ini"
			}
	}
if (kbmpprt <> "")
	{
		tmpx:= % %JMAP%_executable
		oskloc:= binhome . "\NewOSK.exe"
		stringreplace,osklok,oskloc,\,/,All
		fileread,jtktmp,%source%\%prf%_Trigger.set
		FileDelete,%home%\%JMAP%_!.cmd
		fileread,amks,%source%\%prf%_Trigger.set
		fileread,amcb,%source%\%prf%_Trigger.set
		fileread,amcp,%source%\%prf%_GameTemplate.set
		fileread,kbmamcp,%source%\%prf%_KBM_Template.set
		fileread,amcd,%source%\%prf%_DeskTemplate.set
		fileread,blcd,%source%\%prf%_Blank_Template.set
		keyboard_Mapper= %home%\%JMAP%_!.cmd
		Player1_Template=%home%\Player1.%mapper_extension%
		Player2_Template=%home%\Player2.%mapper_extension%
		KBM_Template=%home%\KBM.%mapper_extension%
		Blank_Template=%home%\Blank.%mapper_extension%
		MediaCenter_Template=%home%\MediaCenter.%mapper_extension%
		FileDelete,%Player1_Template%
		FileDelete,%Player2_Template%
		FileDelete,%KBM_Template%
		FileDelete,%Blank_Template%
		FileDelete,%MediaCenter_Template%
		stringreplace,amks,amks,[KEYSTX],%kbmpprt%,All
		stringreplace,amcb,amcb,[JOYXO],%kbmpprt%,All
		stringreplace,amcb,amcb,[J2KEY],%kbmpprt%,All
		stringreplace,amcb,amcb,[XPADR],%kbmpprt%,All
		stringreplace,amcb,amcb,[AMICRX],%kbmpprt%,All
		stringreplace,amcb,amcb,[AMICRO],%kbmpprt%,All
		stringreplace,kbmamcp,kbmamcp,[NEWOSK],%osklok%,All
		stringreplace,kbmamcp,kbmamcp,[AMICRX],%antimicrox_executable%,All
		stringreplace,kbmamcp,kbmamcp,[AMICRO],%antimicro_executable%,All
		stringreplace,amcp,amcp,[NEWOSK],%osklok%,All
		stringreplace,amcp,amcp,[AMICRX],%antimicrox_executable%,All
		stringreplace,amcp,amcp,[AMICRO],%antimicro_executable%,All
		stringreplace,amcd,amcd,[NEWOSK],%osklok%,All
		stringreplace,amcd,amcd,[AMICRX],%antimicrox_executable%,All
		stringreplace,amcd,amcd,[AMICRO],%antimicro_executable%,All
		FileAppend,%amcb%,%home%\%JMAP%_!.cmd,UTF-8-RAW
		FileAppend,%blcd%,%Blank_Template%,UTF-8-RAW
		FileAppend,%kbmamcp%,%KBM_Template%,UTF-8-RAW
		FileAppend,%amcp%,%Player1_Template%,UTF-8-RAW
		FileAppend,%amcp%,%Player2_Template%,UTF-8-RAW
		FileAppend,%amcd%,%MediaCenter_Template%,UTF-8-RAW
		iniwrite,%JMAP%,%RJDBINI%,JOYSTICKS,JMAP
		iniwrite,%Mapper%,%RJDBINI%,GENERAL,Mapper
		filecopy,%source%\%prf%_Blank.set,%home%\Blank.%mapper_extension%
		;Run,%home%\rjdb.ini
		iniwrite,%Mapper_Extension%,%RJDBINI%,JOYSTICKS,Mapper_Extension
		iniwrite,%kbmpprt%,%RJDBINI%,JOYSTICKS,%JMAP%_executable
		iniwrite,%keyboard_Mapper%,%RJDBINI%,JOYSTICKS,keyboard_Mapper
		iniwrite,%Player1_Template%,%RJDBINI%,JOYSTICKS,Player1_Template
		iniwrite,%Player2_Template%,%RJDBINI%,JOYSTICKS,Player2_Template
		iniwrite,%MediaCenter_Template%,%RJDBINI%,JOYSTICKS,MediaCenter_Template
		if (ASADMIN = 1)
			{
				RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %kbmpprt%, ~ RUNASADMIN
			}
		KBMAPALRT:= "Lime"	
		PLR1TALRT:= "Lime"	
		PLR2TALRT:= "Lime"	
		MCPRFALRT:= "Lime"	
		if !fileExist(Keyboard_Mapper)
			{
				KBMAPALRT:= "Red"
			}
		if !fileExist(Player1_Template)
			{
				PLR1TALRT:= "Red"
			}
		if !fileExist(Player2_Template)
			{
				PLR2TALRT:= "Red"
			}
		if !fileExist(MediaCenter_Template)
			{
				MCPRFALRT:= "Red"
			}
		guicontrol, +c%KBMAPALRT%,Keyboard_MapperT
		guicontrol, +c%PLR1TALRT%,Player1_TemplateT
		guicontrol, +c%PLR2TALRT%,Player2_TemplateT
		guicontrol, +c%MCPRFALRT%,MediaCenter_TemplateT
		guicontrol,,Keyboard_MapperT,%keyboard_Mapper%
		guicontrol,,Player1_TemplateT,%Player1_Template%
		guicontrol,,Player2_TemplateT,%Player2_Template%
		guicontrol,,MediaCenter_TemplateT,%MediaCenter_Template%
		
	}
kbmpprt:= ""
return

ReadLBF:
fileread,stmocs,%vdfile%
Loop,parse,stmocs,`r`n
	{
		if (A_LoopField = "")
			{
				continue
			}
		ifinstring,A_LoopField,"path"
			{
				stringsplit,fie,A_LoopField,"
				;"
				beb:= ""
				Loop,%fie0%
					{
							beb:= % fie%A_Index%
							if instr(beb,":")
								{
									stringreplace,ALLCHK,beb,\\,\,All
									if (fileexist(ALLCHK)&& !instr(STMORG,ALLCHK))
											{
												STMORG.= ALLCHK . "|"
											}
										break
									}
						
						}
				}
	}
Loop,parse,STMORG,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		kman:= A_LoopField . "\steamapps"
		if (fileexist(kman)&& !instr(CONCAT_ROOT,kman))
				{
					CONCAT_ROOT.= kman . "\common" . "|"
					GENERIC_ROOT.= kman .  "\common" . "|"
				}
		if !instr(CONCAT_ROOT,kman)
					{
						CONCAT_ROOT.= kman . "\common" . "|"
						GENERIC_ROOT.= kman . "\common" . "|"
					}
		Loop,files,%kman%\appmanifest*.acf
			{
				krmi:= A_LoopFileName
				krmx:= A_LoopFileFullPath
				gosub,PASTM
			}
	}
return

PASTM:
stringsplit,ebb,krmi,_.
steamidx:= ebb2
fileread,stmocs,%krmx%
Loop,parse,stmocs,`r`n
	{
		if (A_LoopField = "")
			{
				continue
			}	
		stringsplit,fie,A_LoopField,"
		;"
		aeb:= ""
		fii:= ""
		Loop,%fie0%
			{
				fixf:= (A_Index + 2)
				aeb:= % fie%A_Index%
				fii:= % fie%fixf%
				if (aeb = "installdir")
					{
						steamins:= fii
						stinsd:= kman . "\common\" . fii
						if (fileexist(stinsd)&& !instr(STMLKUP,stinsd))
								{
									STMLKUP.= stinsd . "|"
								}	
					}
				if (aeb = "appid")
					{
						steamidx:= fii
					}
				if (aeb = "name")
					{
						insan:= fii
						gosub, sanitizer
						stringreplace,clnname,outsan,\,-,All
					}
			}
	}
steamdba:= steamidx . "|" . clnname . "|" . stinsd
if !instr(steamdb,steamdba)
	{
		fileappend,%steamidx%|%clnname%|%stinsd%|%steamins%`n,%home%\steam.db,UTF-8
		steamdb.= steamdba . "`n"
	}
return	

INITQUERY:
FileDelete,%home%\steam.db
CONCAT_ROOT:= ""
GENERIC_ROOT:= ""
Loop,parse,dralbet,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		srchdrl:= A_LoopField .  ":"
		Loop,parse,GenQuery,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				GNCHK:= srchdrl . "\" . A_LoopField
				if fileexist(GNCHK)
					{
						Loop,files,%GNCHK%,D
							{
								Loop,parse,AllQuery,|
									{
										if (A_LoopField = "")
											{
												continue
											}
										ALLCHK:= A_LoopFileFullPath . "\" . A_LoopField
									}
								if (fileexist(ALLCHK)&& !instr(CONCAT_ROOT,ALLCHK))
									{
										ACONCAT_ROOT.= ALLCHK . "|"
										GENERIC_ROOT.= ALLCHK . "|"
									}
							}
						if !instr(ACONCAT_ROOT,GNCHK)
							{
								ACONCAT_ROOT.= GNCHK . "|"
								GENERIC_ROOT.= GNCHK . "|"
							}
					}
			}
	}
if (ACONCAT_ROOT <> "")
	{
		IncludeDD=0
		iniwrite,0,%RJDBINI%,GENERAL,IncludeDD
	}
STEAM_ROOT:= ""
RegRead, steamdir, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam,InstallPath
if fileExist(steamdir)
	{
			iniwrite,%steamdir%,%RJDBINI%,GENERAL,Steam_Directory
			Loop,files,%steamdir%\*.vdf,R
				{	
					if (A_Loopfilename = "libraryfolders.vdf")
						{
							vdfile:= A_LoopFileFullPath
							gosub, ReadLBF
							;break
						}
					if (A_LoopFilename = "localconfig.vdf")
						{
							splitpath,A_LoopFileFullPath,fn,fp,
							stringreplace,steamguid,fp,%steamdir%\userdata\,,
							stringreplace,steamuser,steamguid,config\localconfig.vdf,,
							
							/*
							fileread,logonu,%A_LoopFileLongPath%
							fndnum:= ""
							Loop,parse,logonu,`r`n
								{
									stringreplace,lnm,A_LoopField,",,
									;"
									if (lnm = "users")
										{
											fndnum=1
											continue
										}
									stringlen,stuid,A_LoopField	
									if ((fndnum = 1)&&(stuid = 17))
										{
											SteamUser:= A_LoopField
											break
										}
									if instr(A_LoopField,"<STEAMID64>")
										{
											stringsplit,dstb,A_LoopField,<>
											SteamUser= %dstb3%
											break
										}
								}
							*/	
						}
						
				}
	
	}

Loop,parse,dralbet,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		srclocd:= A_LoopField
		Loop,Files,%srclocd%,D
			{
				if instr(A_LoopFileName,"Steam")
					{
						kmin:= ""
						Loop,files,%A_LoopFileFullPath%\appmanifest*.*f,F
							{
								krmi:= A_LoopFileName
								gosub, PASTM
								kmin:= 1
							}
						if kmin = 1
							{
								goto, STMEND
								}
						Loop,files,%A_LoopFileFullPath%,D
							{
								if instr(A_LoopFileName,"apps")
									{
										Loop,files,%A_LoopFileFullPath%\appmanifest*.*f,F
											{
												krmi:= A_LoopFileName
												gosub, PASTM
												kmin:= 1
											}										
										if kmin = 1
											{
												goto, STMEND
											}	
										Loop,files,%A_LoopFileFullPath%,D
											{
												if (A_LoopFilename = "common")
													{	
														iniread,steamadd,%RJDBINI%,GENERAL,Steam_Directory
														if ((steamadd < >"") && (steamadd <> "ERROR") && !instr(steamadd,A_LoopFileFullPath)&& !instr(A_LoopFileFullPath,steamadd))
															{
																steamadd.= A_loopfilefullpath . "|"
															}
														iniwrite,%steamadd%,%RJDBINI%,GENERAL,Steam_Directory
														CONCAT_ROOT.= A_LoopFileFullPath . "|"
														STEAM_ROOT.= A_LoopFileFullPath . "|"
														break
													}
											}
									}
							}
					}
			}
	}
STMEND:
GOG_ROOT:= ""
;HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\GOG.com\Games
Loop, Reg, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\GOG.com\Games, K
	{
		if ((A_LoopRegType = "KEY") && A_LoopRegName is digit)
			{
				RegRead, gogname, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\GOG.com\Games\%A_LoopRegName%, GameName
				RegRead, gogPth, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\GOG.com\Games\%A_LoopRegName%, Path
				RegRead, gogExe, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\GOG.com\Games\%A_LoopRegName%, exe
				CONCAT_ROOT.= gogPth . "|"
				GOG_ROOT.= gogPth . "|"
				iniread,gogadd,%RJDBINI%,GENERAL,GOG_Directory
				if (gogadd = "ERROR")
					{
						gogadd:= ""
					}
				if ((gogPth <> "") && !instr(gogadd,gogPth))
					{
						gogadd.= gogPth . "|"
					}
				iniwrite,%gogadd%,%RJDBINI%,GENERAL,GOG_Directory
				;break
			}	
	}
AMZ_ROOT:= ""
Loop,parse,dralbet,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		srclocd:= A_LoopField . ":"
		Loop,parse,AMZQuery,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				amzitm= %srclocd%\%A_LoopField%
				if (fileexist(amzitem) && !instr(AMZ_ROOT,amzitem))
					{
						AMZ_ROOT.= amzitem . "|"
						CONCAT_ROOT.= amzitem . "|"
						iniwrite,%AMZ_ROOT%,%RJDBINI%,GENERAL,AMAZON_Directory
					}
			}
		Loop,parse,remProgdirs
			{
				if (A_LoopField = "")
					{
						continue
					}
				amzdir= %A_LoopField%	
				Loop,parse,AMZQuery,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						amzitm= %srclocd%\%amzdir%\%A_LoopField%
						if (fileexist(amzitem) && !instr(AMZ_ROOT,amzitem))
							{
								AMZ_ROOT.= amzitem . "|"
								CONCAT_ROOT.= amzitem . "|"
								iniwrite,%AMZ_ROOT%,%RJDBINI%,GENERAL,AMAZON_Directory
							}
					}
			}
	}
ORIGIN_ROOT:= ""
Loop,parse,dralbet,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		srclocd:= A_LoopField . ":"
		Loop,parse,ORIQuery,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				orgnitm= %srclocd%\%A_LoopField%
				if (fileexist(orgnitm) && !instr(ORIGIN_ROOT,orgnitm))
					{
						ORIGIN_ROOT.= orgnitm . "|"
						CONCAT_ROOT.= orgnitm . "|"
						iniwrite,%ORIGIN_ROOT%,%RJDBINI%,GENERAL,ORIGIN_Directory
					}
			}
		Loop,parse,remProgdirs
			{
				if (A_LoopField = "")
					{
						continue
					}
				orgndir= %A_LoopField%	
				Loop,parse,ORIQuery,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						orgnitm= %srclocd%\%orgndir%\%A_LoopField%
						if (fileexist(orgnitm) && !instr(ORIGIN_ROOT,orgnitm))
							{
								ORIGIN_ROOT.= orgnitm . "|"
								CONCAT_ROOT.= orgnitm . "|"
								iniwrite,%ORIGIN_ROOT%,%RJDBINI%,GENERAL,ORIGIN_Directory
							}
					}
			}
	}	
ITCH_ROOT:= ""
Loop,parse,dralbet,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		srclocd:= A_LoopField . ":"
		Loop,parse,ITCHQuery,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				itchitm= %srclocd%\%A_LoopField%
				if (fileexist(itchitm) && !instr(ITCH_ROOT,itchitm))
					{
						ITCH_ROOT.= itchitm . "|"
						CONCAT_ROOT.= itchitm . "|"
						iniwrite,%ITCH_ROOT%,%RJDBINI%,GENERAL,ITCH_Directory
					}
			}
		Loop,parse,remProgdirs
			{
				if (A_LoopField = "")
					{
						continue
					}
				itchdir= %A_LoopField%	
				Loop,parse,ITCHQuery,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						itchitm= %srclocd%\%itchdir%\%A_LoopField%
						if (fileexist(itchitm) && !instr(ITCH_ROOT,itchitm))
							{
								ITCH_ROOT.= itchitm . "|"
								CONCAT_ROOT.= itchitm . "|"
								iniwrite,%ITCH_ROOT%,%RJDBINI%,GENERAL,ITCH_Directory
							}
					}
			}
	}	
if (ACONCAT_ROOT <> "")
	{
		SOURCE_Directory= %ACONCAT_ROOT%
		sourcepop:= ""
		Loop,parse,ACONCAT_ROOT,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				if (sourcepop = "")
					{
						sourcepop= %A_LoopField%||
						continue
					}
				sourcepop.= A_LoopField . "|"
			}
		iniwrite,%Source_directory%,%RJDBINI%,GENERAL,SOURCE_DIRECTORY
	}
else {
	sourcepop:= ""
	Loop,parse,CONCAT_ROOT,|
		{
			if (A_LoopField = "")
				{
					continue
				}
			if (sourcepop = "")
				{
					sourcepop= %A_LoopField%||
					continue
				}
			sourcepop.= A_LoopField . "|"
		}
	iniwrite,%CONCAT_ROOT%,%RJDBINI%,GENERAL,SOURCE_DIRECTORY
	iniwrite,%CONCAT_ROOT%,%RJDBINI%,GENERAL,DIST_DIRECTORY
	return
}
iniwrite,%CONCAT_ROOT%,%RJDBINI%,GENERAL,DIST_DIRECTORY
return

popgui:
FileRead,rjdb,%RJDBINI%
Prelist:= ""
PreStatus:= ""
postlist:= ""
PostStatus:= ""
PREDDT:= ""
POSTDDT:= ""
iniread,RJDBSECTS,%RJDBINI%
Loop,parse,RJDBSECTS,`r`n
	{
		if (A_LoopField = "")
			{
				continue
			}
		iniread,sectp,%home%\RJDB.ini,%A_LoopField%
		Loop,parse,sectp,`r`n
			{
				if (A_LoopField = "")
					{
						continue
					}
				stringsplit,kval,A_LoopField,=
				val= %kval1%
				stringreplace,trval,A_LoopField,%kval1%=
				if (trval = "")
					{
						;trval= %kval1%
					}
				%val%:= trval
				stringreplace,trvald,trval,%A_Space%,_,All
				stringreplace,trvald,trvald,-,_,All
				%kval1%T:= trval
				if instr(kval1,"_post")
					{
						postlist.= trval . "|"
						if (kval1 = "1_post")
							{
								postlist.= "|"
							}
					}

				if instr(kval1,"_Pre")
					{
						Prelist.= trval . "|"
						if (kval1 = "1_Pre")
							{
								Prelist.= "|"
							}
					}
				if (resetting = 1)
					{
						guicontrol,,%kval1%T,%trvald%
					}
			}
	}
if (resetting = 1)
	{
		guicontrol,,PREDDT,<$This_Prog$><Monitor><Mapper><game.exe>
		guicontrol,,POSTDDT,<game.exe><$This_Prog$><Mapper><Monitor>
		guicontrol,hide,ButtonCreate
		guicontrol,disable,ButtonCreate
		guicontrol,disable,ButtonClear
		guicontrol,hide,ButtonClear
		guicontrol,hide,MyListView
		guicontrol,disable,MyListView
		GuiControl, Move, MyListView, w0
	}

Srcdeflt= %home%\Shortcuts
Iniread,Source_Directory,%RJDBINI%,GENERAL,Source_Directory
if ((Source_Directory = "")or (resetting = 1) or (initz = 1))
	{
		gosub, INITQUERY
	}
	else {
		sourcepop:= ""
		Loop,parse,SOURCE_Directory,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				if (sourcepop = "")
					{
						sourcepop= %A_LoopField%||
						continue
					}
				sourcepop.= A_LoopField . "|"
			}
		exclpop= 	
		Loop,parse,Exclude_Directory,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				if (exclpop = "")
					{
						exclpop= %A_LoopField%||
						continue
					}
				exclpop.= A_LoopField . "|"	
			}
		guicontrol,,Exclude_DirectoryT,|%exclpop%
	}
initz:= ""
guicontrol,,Source_DirectoryT,|%sourcepop%
resetting:= ""
return

RECREATEXPAD:
newoskfile= %binhome%\NewOSK.exe
ifnotexist,%home%\Player1.xpadderprofile
	{
		filecopy,%source%\xp_GameProfile.set,%home%\Player1.xpadderprofile
	}
ifnotexist,%home%\Player2.xpadderprofile
	{
		filecopy,%source%\xp_GameProfile.set,%home%\Player2.xpadderprofile
	}
ifnotexist,%home%\Mediacenter.xpadderprofile
	{
		filecopy,%source%\xp_DeskProfile.set,%home%\MediaCenter.xpadderprofile
	}
ifnotexist,%home%\Mediacenter2.xpadderprofile
	{
		filecopy,%source%\xp_DeskProfile.set,%home%\MediaCenter2.xpadderprofile
	}
return

RECREATEJOYTK:
newoskfile= %binhome%\NewOSK.exe
stringreplace,SCRIPTRV,newoskfile,\,/,All
ifnotexist,%home%\Player1.cfg
    {
		fileread,mctmp,%source%\JK_GameProfile.set
											 
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,%home%\Player1.cfg,UTF-8
    }
ifnotexist,%home%\Player2.cfg
    {
        fileread,mctmp,%source%\JK_GameProfile.set
											 
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,%home%\Player2.cfg,UTF-8
    }
ifnotexist,%home%\MediaCenter.cfg
    {
        fileread,mctmp,%source%\JK_DeskProfile.set
											 
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,%home%\MediaCenter.cfg,UTF-8
    }

return

CENTRLCKB:
gui,submit,nohide
guicontrolget,CENTRLCKB,,CENTRLCKB
Loop,parse,CENITEMS,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		guicontrol,,%A_LoopField%,%CENTRLCKB%	
		%A_LoopField%= %CENTRLCKB%
	}
CENTRLZ= %CENITEMS%	
if (CENCKB = 1)
	{
		CENTRLZ:= A_Space
	}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
return


CenKBM:
gui,submit,nohide
guicontrolget,CenKBM,,CenKBM
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenKBM = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenKBM|,,All
	}
else {
	if !instr(CENTRLZ,"CenKBM|")
		{
			CENTRLZ.= "CenKBM|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenKBM = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CenPL1:
gui,submit,nohide
guicontrolget,CenPL1,,CenPL1
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPL1 = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenPL1|,,All
	}
else {
	if !instr(CENTRLZ,"CenPL1|")
		{
			CENTRLZ.= "CenPL1|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPL1 = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CenPL2:
gui,submit,nohide
guicontrolget,CenPL2,,CenPL2
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPL2 = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenPL2|,,All
	}
else {
	if !instr(CENTRLZ,"CenPL2|")
		{
			CENTRLZ.= "CenPL2|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPL2 = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CenMC:
gui,submit,nohide
guicontrolget,CenMC,,CenMC
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenMC = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenMC|,,All
	}
else {
	if !instr(CENTRLZ,"CenMC|")
		{
			CENTRLZ.= "CenMC|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenMC = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CenGM:
gui,submit,nohide
guicontrolget,CenGM,,CenGM
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenGM = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenGM|,,All
	}
else {
	if !instr(CENTRLZ,"CenGM|")
		{
			CENTRLZ.= "CenGM|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenGM = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CenMM:
gui,submit,nohide
guicontrolget,CenMM,,CenMM
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenMM = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenMM|,,All
	}
else {
	if !instr(CENTRLZ,"CenMM|")
		{
			CENTRLZ.= "CenMM|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenMM = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CenJAL:
gui,submit,nohide
guicontrolget,CenJAL,,CenJAL
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenJAL = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenJAL|,,All
	}
else {
	if !instr(CENTRLZ,"CenJAL|")
		{
			CENTRLZ.= "CenJAL|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenJAL = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CenJBE:
gui,submit,nohide
guicontrolget,CenJBE,,CenJBE
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenJBE = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenJBE|,,All
	}
else {
	if !instr(CENTRLZ,"CenJBE|")
		{
			CENTRLZ.= "CenJBE|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenJBE = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CenPRE:
gui,submit,nohide
guicontrolget,CenPRE,,CenPRE
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPRE = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenPRE|,,All
	}
else {
	if !instr(CENTRLZ,"CenPRE|")
		{
			CENTRLZ.= "CenPRE|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPRE = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CenPST:
gui,submit,nohide
guicontrolget,CenPST,,CenPST
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPST = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenPST|,,All
	}
else {
	if !instr(CENTRLZ,"CenPST|")
		{
			CENTRLZ.= "CenPST|"
		}
}	
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPST = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return


UPDTSC:
OVERWRT:= ""
return
OVERWRT:
OVERWRT= 1
return

MMSETUPD:
Msgbox,,Default Desktop Config,Configure your monitor/s as you would have them for your`nMediaCenter or Desktop`nthen click "OK"
ifmsgbox,OK
    {
        FileMove,%home%\DesktopMonitors.mon,%home%\DesktopMonitors.mon.bak
        RunWait, %multimonitor_tool% /SaveConfig "%CFGDIR%\DesktopMonitors.mon",%home%,hide
        ifexist,%CFGDIR%\DesktopMonitors.mon
            {
				MM_MEDIACENTER_Config= %CFGDIR%\DesktopMonitors.mon
				iniwrite,%CFGDIR%\DesktopMonitors.mon,%RJDBINI%,CONFIG,MM_MEDIACENTER_Config
            }
           else {
            Msgbox,,Failure,The current monitor configuration could not be saved
			return
           }
SB_SetText("Monitor config saved")
    }
abn= 0
Loop,7
	{
		inidelete,%MM_Mediacenter_Config%,MONITOR%abn%,Name
		abn+= 1
	}
Guicontrol, +cLime,	MM_MediaCenter_ConfigT
guicontrol,,MM_MediaCenter_ConfigT,%MM_Mediacenter_Config%
return


DDPOPS:
iniread,cftst,%RJDBINI%,CONFIG
knum:= ""
snum:= ""
Loop,parse,cftst,`n`r
    {
        stringsplit,dkd,A_LoopField,=
        ifinstring,dkd1,_Post
            {
                stringreplace,dkv,A_LoopField,%dkd1%=,,
                if (dkv = "")
                    {
                        continue
                    }
                knum+=1
                %knum%_Post= dkv
                if (knum = 1)
                    {
                        PostList.= "|" . dkv . "||"
                        continue
                    }
                PostList.= dkv . "|"
            }
         ifinstring,dkd1,_Pre
            {
                stringreplace,dkv,A_LoopField,%dkd1%=,,
                if (dkv = "")
                    {
                        continue
                    }
                snum+=1
                %snum%_Pre= dkv
                if (snum = 1)
                    {
                        PreList.= dkv . "||"
                        continue
                    }
                PreList.= dkv . "|"
            }
    }
guicontrol,,PostDD,%PostList%
guicontrol,,PreDD,%PreList%
Return

CANCLDBUT:
CANCLD= 1
guicontrol,disable,CANCLDBUT
Return

ADDGAME:
gui,submit,NoHide
popui= 1
guicontrol,hide,REINDEX
guicontrol,show,CANCLDBUT
guicontrol,enable,CANCLDBUT				
FileSelectFile,Gametoadd,35,,Select a Game,*.exe;*.lnk
nFileName:= GameToAdd
splitpath,nFileName,FileNM,FilePath,FileExt,filtn
INFN= 1
Loop,parse,SOURCE_DIRECTORY,|
	{
		if instr(filepath,A_LoopField)
			{
				goto, gadded
			}
	}
if !instr(Extra_Source,filepath)
	{ 
		Extra_Source.= filepath . "|"
		iniwrite,%filepath%,%RJDBINI%,GENERAL,Extra_Source
	}
gadded:	
lvachk= +Check
NSPLIT= %filepath%
NSOURCEDLIST= 
;Nsivk= 
gosub, ADD_ITER
fileappend,%NSOURCEDLIST%,%SRCFILE%,UTF-8
srcntot = ""
vavn:= ""
Fileread,SOURCEDLIST,%SRCFILE%
Loop,parse,SOURCEDLIST,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		vavn+=1
		%vavn%SDL:= A_LoopField
	}
srcntot:= vavn
LV_ModifyCol()
guicontrol,hide,CANCLDBUT
guicontrol,disable,CANCLDBUT
guicontrol,show,REINDEX
popui:= ""
return

CREFLD:
gui,submit,nohide
guicontrol,enable,GMJOY
guicontrol,enable,GMLNK
guicontrol,enable,GMCONF
if (CREFLD = 0)
	{
		guicontrol,disable,GMJOY
		guicontrol,,GMJOY,0
		guicontrol,disable,GMLNK
		guicontrol,,GMLNK,0
		guicontrol,disable,GMCONF
		guicontrol,,GMCONF,0
		iniwrite,%CREFLD%,%RJDBINI%,CONFIG,GMJOY
		iniwrite,%CREFLD%,%RJDBINI%,CONFIG,GMLNK
		iniwrite,%CREFLD%,%RJDBINI%,CONFIG,GMCONF
	}
iniwrite,%CREFLD%,%RJDBINI%,CONFIG,CREFLD
return

GMCONF:
gui,submit,nohide
iniwrite,%GMCONF%,%RJDBINI%,CONFIG,GMCONF
return

GMJOY:
gui,submit,nohide
iniwrite,%GMJOY%,%RJDBINI%,CONFIG,GMJOY
return


ASADMIN:
gui,submit,nohide
iniwrite,%ASADMIN%,%RJDBINI%,CONFIG,ASADMIN
return

GMLNK:
gui,submit,nohide
iniwrite,%GMLNK%,%RJDBINI%,CONFIG,GMLNK
return

;;##########################################################################
;;############################### POPULATION ###############################;;
;;##########################################################################

REINDEX:
SOURCEDLIST:= ""
fullist:= ""
simpnk:= ""
omitd:= ""
filedelete,%SRCFILE%
POPULATE:
popui= 1
guicontrol,hide,REINDEX
guicontrol,show,CANCLDBUT
guicontrol,enable,CANCLDBUT
ControlFocus,Log,v0rt3X_GUI
bsvl:= ""
INFN:= ""
SPLIT_SRC:= SOURCE_DIRECTORY . "|" . Extra_Source
fileread,stmfz,%home%\steam.db	
Gui,Listview,MyListView
guicontrolget,enablelogging,,enablelogging
guicontrolget,NameChk,,NameChk
guicontrolget,IncludeDD,,IncludeDD
guicontrolget,BGP_Enable,,BGP_Enable
guicontrolget,teval,,BGP_TE
teval:= (teval * 8)
guicontrolget,tuval,,BGP_TU
tuval:= (tuval * 5)
BGP_State:= (tuval + BGP_Enable + teval)

LV_Delete()
if (!Fileexist(GAME_Directory)or !FileExist(Game_Profiles))
    {
        SB_SetText("Please Select Valid Directories")
    }
SB_SetText("Getting Lnk/Exe List")
Loop,parse,GUIVARS,|
	{
		guicontrol,disable,%A_LoopField%
	}
str := ""
guicontrolget,EXEONLY,,EXEONLY
if (exeonly = 1)
	{
		gosub, EXEONLY
	}
guicontrolget,SCONLY,,SCONLY
if (SCONLY = 1)
	{
		gosub, SCONLY
	}
guicontrolget,BOTHSRCH,,BOTHSRCH
if (BOTHSRCH = 1)
	{
		gosub, BOTHSRCH
	}
lvachk= +Check
fullist:= ""
vavn:= ""
srcntot:= ""
if (SOURCEDLIST <> "")
	{
		Loop,parse,SOURCEDLIST,`n
			{
				if (A_LoopField = "")
					{
						continue
					}
				Loop,20
					{
						rni%A_Index%:= ""
					}
				vavn+=1	
				lvachk= +Check
				stringsplit,rni,A_LoopField,|
				if instr(A_LoopField,"?")
					{
						lvachk:= ""
					}
				Loop,%rni0%
					{
						svt:= % (rni%A_Index%)
						if (svt = "")
							{
								rni%A_Index%:= A_Space
							}
					}
				LV_Add(lvachk,rni1, rni2, rni3, rni4, rni5,rni6, rni7, rni8, rni9, rni10, rni11, rni12, rni13, rni14, rni15, rni16, rni17, rni18)
				%vavn%SDL:= A_LoopField
				fullist.= rni2 . "\" . rni1 . "|"
			}	
		srcntot:= vavn	
		NSOURCEDLIST= %SOURCEDLIST%
		goto,REPOP
	}
SOURCEDLIST:= ""
NSOURCEDLIST= %SOURCEDLIST%

NSPLIT= %SPLIT_SRC%
ADD_ITER:
CANCLD:= ""
Loop,parse,NSPLIT,|
	{  
		if (INFN = 2)
			{
				return
			}
		if (CANCLD = 1)
			{
				break
			}
		SRCLOOP= %A_LoopField%
		if (!fileexist(SRCLOOP)or(A_LoopField = ""))
			{
				continue
			}
		Loop,parse,filextns,|
			{  
				if (INFN = 2)
					{
						return
					}
				if (CANCLD = 1)
					{
						break
					}
				if (A_LoopField = "")
					{
						continue
					}
				fsext= %A_LoopField%
				sfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
				VarSetCapacity(sfi, sfi_size)
				Loop,files,%SRCLOOP%\*,D
					{
						allfld.= A_LoopFileLongPath . "|"
					}
				loop, Files, %SRCLOOP%\*.%fsext%,FR
					{		   
						if (INFN = 2)
							{
								return
							}
						if (CANCLD = 1)
							{
								break
							}
						stmexcl= 
						Loop,parse,DIST_DIRECTORY,|
							{
								if (A_LoopField = "")
									{
										continue
									}
								if instr(A_LoopFileLongPath,A_LoopField)
									{
										TOPSTM= %A_LoopField%
										stmexcl= 1
										break
									}
							}
						if ((stmexcl = 1)&& (IncludeDD <> 1))
							{
								continue
							}
						stringright,rlxtn,A_LoopFileName,4
						if (rlxtn <> ".exe")
							{
								continue
							}
						excl:= ""
						lvachk= +Check
						FileName := A_LoopFileLongPath
						if (INFN = 1)
							{
								FileName= %nFileName%
								INFN+=1
							}
						filez:= A_LoopFileSizeKB
						splitpath,FileName,FileNM,FilePath,FileExt,filtn
						FilePPUT=%FilePath%
						filpn= %FileNM%
						exep= %FilePath%
						exechk= %filtn%
						
						if (instr(FileName,"Installer")or instr(FileName,"Uninstal"))
							{
								continue
							}
						exclu= 	
						Loop,parse,Exclude_Directory,|
							{
								if (A_LoopField = "")
									{
										continue
									}
								if instr(FilePath,A_LoopField)
									{
										exclu= 1
										break
									}
							}
						if (exclu = 1)
							{
								continue
							}
						TOPSCR= %SRCLOOP%
						if ((stmexcl = 1)&&(IncludeDD = 1))
							{
								TOPSCR= %TOPSTM%
							}
						stringreplace,simpath,FilePath,%TOPSCR%,,
						trukpath= %simpath%
						if ((trukpath = "")or(trukpath = FilePath))
							{
								Loop,parse,FilePath,\
									{
										if (A_LoopField = "")
											{
												continue
											}
										trukpath= %A_loopField%
									}
							}
						stringsplit,smjk,simpath,\	
						rootn= %smjk1%
						if (rootn = "")
							{
								rootn= %smjk2%
								if (rootn = "")
									{
										rootn= %trukpath%
									}
							}
						SB_SetText("adding " filenm "")
						invar= %filtn%
						gosub, StripVar
						chkstrip= %invarx%
						Loop,parse,absol,`r`n
							{
								if (A_LoopField = "")
									{
										continue
									}
								if instr(chkstrip,A_LoopField)
									{
										omitd.= filenm . "|" . simpath . "|"  . "`n"
										excl= 1
										break
									}
							}
						if (excl = 1)
							{
								continue
							}
						Loop,parse,rabsol,`r`n
							{
								if (A_LoopField = "")
									{
										continue
									}
								stringlen,hh,A_LoopField
								stringright,an,chkstrip,%hh%
								stringLeft,az,chkstrip,%hh%
								if ((an = A_LoopField) or (az = A_LoopField) or (chkstrip = A_LoopField) && !instr(rootn,A_LoopField))
									{
										omitd.= filenm . "|" . simpath . "`n"
										excl= 1
										break
									}
							}
						if (excl = 1)
							{
								continue
							}
						simpnk.= FileName . "`n"
						PostDirChk:
						smf:= ""
						Loop,parse,unlike,`r`n
							{
								if (A_LoopField = "")
									{
										continue
									}
								stringlen,hh,A_LoopField
								stringleft,lt,rootn,%hh%
								stringright,rt,rootn,%hh%
								stringright,an,chkstrip,%hh%
								stringLeft,az,chkstrip,%hh%
								if ( ((lt <> az) && (rt <> an) && (lt <> A_LoopField)&& (rt <> A_LoopField) && (hh > 3) && ((an = A_LoopField) or (az = A_LoopField))) or (chkstrip = A_LoopField))
									{
										smf+=1
										lvachk:= ""
										break
									}
							}
						kir=
						Loop,parse,FilePath,\
							{
								if (A_LoopField = "")
									{
										continue
									}
								kir:= A_LoopField
							}
						Loop,parse,unselect,`r`n
							{
								if (A_LoopField = "")
									{
										continue
									}
								prbn:= A_LoopField
								if (chkstrip = prbn)
									{
										smf+=1
										if (smf = 2)
											{
												break									
											}
									}
								if (kir = prbn)
									{
										smf+= 1
										if (smf = 2)
											{
												break									
											}
									}
							}
						if (smf = 2)
							{
								continue
							}
						if (smf = 1)
							{
								lvachk:= ""
								simpnk.= FileName . "`n"
							}
						if (lvachk <> "")
							{
								fullist.= A_LoopFileLongPath . "|"
							}
						Chkcon:
						njName:= ""
						SPZ= 0
						SPZa= |0|
						if ((namechk = 1)&&(lvachk <> ""))
							{
								gosub, GETGOODNAME
							}
						if (lvachk = "")
							{
								SPZa.= "?"
							}
							
						AddCPL:	
						FileOpts:= <
						FileArgs:= <
						SB_SetText("added " FileNM "")	
						LV_Add(lvachk,FileNM, FilePPUT, FileOpts, FileArgs, njName,"y","<","<","<","y","<","<","<","<","y","y","<",SPZ)
						if (lvachk <> "")
							{
								NSOURCEDLIST.= FileNM . "|" . FilePPUT . "|" . FileOpts . "|" . FileArgs . "|" . njName . "|y|<|<|<|y|<|<|<|<|y|y|<" . SPZa . "`n"	
							}
					}
			}
	}

SPZ= 0
SPZa= |0|?
Loop,parse,simpnk,`r`n
	{
		if (A_LoopField = "")
			{
				continue
			}
		fenx= %A_LoopField%
		splitpath,fenx,fenf,fendir,fenxtn,fenol
		Loop,NSPLIT,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				srcdtmp= %A_LoopField%\
				stringreplace,fen,fendir,%srcdtmp%,,UseErrorLevel
				if (errorlevel <> 0)
					{
						stringreplace,fltsmp,fullist,%scrdtmp%,,UseErrorLevel
						fenum2:= ""
						stringsplit,fenum,fen,\
						rplt= %fenum1%
						if (fenum2 <> "")
							{
								rplt= %fenum1%\%fenum2%
							}
						vd= <
						stringreplace,jtst,fltsmp,%rplt%,,UseErrorLevel
						if (errorlevel = 0)
							{
								LV_Add(lvachk,fenf, fendir, , , A_Space,"y","<","<","<","y","<","<","<","<","y","y","<",SPZ)
								NSOURCEDLIST.= fenf . "|" . fendir . "|" . vd . "|" . vd . "|" . A_Space . "|y|<|<|<|y|<|<|<|<|y|y|<" . SPZa . "`n"
								fullist.= fenx . "|"
								break
							}
					}
			}		
	}
SOURCEDCOMPLETE:	
fileappend,%NSOURCEDLIST%,%SRCFILE%,UTF-8
if (srcntot = "")
	{
		vavn:= ""
	}
Loop,parse,NSOURCEDLIST,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		vavn+=1
		%vavn%SDL= %A_LoopField%
	}
subtrfm:= (srcntot	- vavn)
krnf:= vavn
Loop, %subtrfrm%
	{
		krnf+=1
		%krnf%SDL= 
	}
srcntot:= vavn
REPOP:
Guicontrol,Show,MyListView
Guicontrol,Show,ButtonCreate
Guicontrol,Show,ButtonClear
Guicontrol,Show,SELALLBUT
Guicontrol,Show,SELNONEBUT

GuiControl, +Redraw, MyListView 
LV_ModifyCol(1, 140) 
LV_ModifyCol(2, 140) 
LV_ModifyCol(3, 60) 
LV_ModifyCol(4, 50) 
LV_ModifyCol(5, 100) 
listView_autoSize:
GUI, +LastFound 
totalWidth := 0 
					  
Loop % LV_GetCount("Column")
	{
		SendMessage, 4125, A_Index - 1, 0, SysListView321
		totalWidth := totalWidth + ErrorLevel
	}
								 
GuiControl, Move, MyListView, w500

GUI, Show,  w817 h713
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
	}

ICELV1 := New LV_InCellEdit(HLV1)
ICELV1.SetColumns(3,4,5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18)
ICELV1.OnMessage()
Gui, +Resize
SB_SetText("Completed Aquisition")
guicontrol,hide,CANCLDBUT
popui:= ""
SOURCEDLIST= %NSOURCEDLIST%
Return

RESTEAM:
dwnrej:= ""
iniread,URLFILE,%source%\repos.set,BINARIES,STEAMJSON
save= %STM_DB%
Filemove,%save%,%save%.bak,R
DownloadFile(URLFILE,save,dwnovwr,True)
dwnovwr=False
if !fileExist(save)
	{
		Msgbox,258,,Json Download Failed,Steam Database was not downloaded.`n     Try again?
		ifmsgbox,Abort
			{	
				Filemove,%save%.bak,%save%,R
				return
			}
		if Msgbox,Retry
			{
				goto, RESTEAM
			}
SB_SetText(" " save " ""downloaded")
}
goto, RELOOKUP

getsivk:
if fileexist(LKUP_DB)
	{
		filegetsize,nsvksize,%LKUP_DB%
		filegetsize,stmdbsrc,%STM_DB%
		if (stmdbsrc > nsvksize)
			{
				goto, RELOOKUP
			}
		fileread,Nsivk,%LKUP_DB%
		goto JSONPARSED
	}
RELOOKUP:
filedelete,%LKUP_DB%
sivk=
Nsivk=
RENMD=
fileread, stfn, %STM_DB%
stringreplace,json,stfn,",,All		;"
stringreplace,json,json,|,-,All
stringreplace,json,json,}`,,`n,All
stringreplace,json,json,{,,All
stringreplace,json,json,appid:,,All
stringreplace,json,json,`,name:,|,All
stringreplace,json,json,applist:apps:[,,All	
stringreplace,json,json,}]}},,All	
stringreplace,json,json,<,,All
stringreplace,json,json,>,,All
stringreplace,json,json,\,,All
stringreplace,json,json,/,-,All
stringreplace,json,json,?,-,All
stringreplace,json,json,*,-,All
stringreplace,json,json,:,-,All
stringreplace,json,json,--,-,All
stringreplace,json,json,&amp`;amp`;,&&,All
stringreplace,json,json,&amp`;,&,All
stringreplace,json,json,%A_Space%%A_Space%,%A_Space%,All
stringreplace,json,json,%A_Space%%A_Space%,%A_Space%,All
Loop,parse,json,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		anum+=1	
		stringsplit,jspi,A_LoopField,|
		invar= %jspi2%
		gosub, StripVar
		gosub, spechar
		if (RENNOS = "")
			{
				RENNOS= %invarx%
			}
		Nsivk.= "|" . jspi2 . "|" . RENNOS . "|" . jspi1 . "|" . RENMD . "|" .  "`n"
	}
if !fileexist(LKUP_DB)
	{
		fileappend,%NSIVK%,%LKUP_DB%,UTF-8
	}	
JSONPARSED:
return

spechar:
spechar:= ""
RENMD= 
RENNOS= 
loop,parse,invarp,`
	   {
		   Transform,B2,ASC,%A_LOOPFIELD%
			bf=|%b2%|
			if ((b2>47) and (b2<58)) or ((b2>64) and (b2<91)) or ((b2>96) and (b2<123)) or (instr(ptyx,bf))
				 {
					RENMD.= A_LoopField
				 }
				 else {
					spechar= 1
					RENMD:= ""
					Loop,parse,invarp,`
						{
							Transform,B2,ASC,%A_LOOPFIELD%
							bf=|%b2%|
							if ((b2>47) and (b2<58)) or ((b2>64) and (b2<91)) or ((b2>96) and (b2<123)) or (instr(ptyx,bf))
								{
									RENMD.= A_LoopField
								}
								else {
									continue
								}	
						}
					break	
				 }
			if (spechar = 1)
				{
					break
				}
	   }
RENMD= %RENMD%	   
stringreplace,RENMD,RENMD,%A_Space%%A_Space%%A_Space%,%A_Space%,All
stringreplace,RENMD,RENMD,%A_Space%%A_Space%,%A_Space%,All
stringreplace,RENNOS,RENMD,%A_Space%,,All
stringreplace,RENNOS,RENNOS,.,,All
spechar:= ""
return

KillToolTip:
   ToolTip
Return

GuiSize:
if (A_EventInfo = 1)
    return
																					
GuiControl, Move, MyListView, % "W" . (A_GuiWidth - 320) . "H" . (A_GuiHeight - 65)
return
NetCHK:
guicontrolget,NetChk,,NetChk
NET_Check= %netchk%
if (NetChk = 0)
	{
		iniwrite,0,%RJDBINI%,GENERAL,Net_Check
		SB_SetText("Right-click to delete the lookup table database.")
		return
	}
if !fileexist(LKUP_DB)
	{
		SB_SetText("Net-Check requires an internet connection.")
		if ((nsivk = "")or !fileexist(LKUP_DB))
			{
				Msgbox,8449,Confirm NetworkLookup,###   WARNING   ###`nThis option may add addtional processing time`n       Generate the Lookup Table?,7
				ifmsgbox,Ok
					{
						Loop,parse,GUIVARS,|
							{
								guicontrol,disable,%A_LoopField%
							}
						SB_SetText(".. Please be patient ... Generating Lookup Table....")
						gosub,getsivk
						SB_SetText("Lookup Table ''lookup.db'' Generated")
						Loop,parse,GUIVARS,|
							{
								guicontrol,enable,%A_LoopField%
							}
					}
			}
	}
if (fileexist(LKUP_DB)&& (NetChk = 1))
	{
		iniwrite,1,%RJDBINI%,GENERAL,Net_Check
	}
	else {
		iniwrite,0,%RJDBINI%,GENERAL,Net_Check
		SB_SetText("Right-click to delete the lookup table database.")
	}
return

SANITIZER:
stringreplace,insan,insan,:,-,All
SANITIZE:
stringreplace,insan,insan,/,-,All
stringreplace,insan,insan,?,-,All
stringreplace,insan,insan,`,,-,All
stringreplace,insan,insan,>,-,All
stringreplace,insan,insan,",,All
;"
stringreplace,insan,insan,=,-,All
stringreplace,insan,insan,|,-,All
stringreplace,outsan,insan,%A_Tab%,-,All
if instr(outsan,"<")
	{
		outsan= <
	}
return
;;#########################################################################################  
;;###############################  SHORTCUT CREATION  #####################################:;
;;#########################################################################################  
ButtonCreate:
popui= 1
guicontrol,show,CANCLDBUT
guicontrol,enable,CANCLDBUT
CANCLDBUT:= ""
SB_SetText("Creating Custom ShortCuts")
Loop,parse,GUIVARS,|
	{
		guicontrol,disable,%A_LoopField%
	}
SPLIT_SRC:= SOURCE_DIRECTORY . "|" . Extra_Source
fileread,cmdtpp,%home%\src\cmdtemplate.set
guicontrolget,CREFLD,,CREFLD
guicontrolget,ASADMIN,,ASADMIN
BGP_State:= ""
guicontrolget,BGP_Enable,,BGP_Enable
guicontrolget,teval,,BGP_TE
teval:= (teval * 8)
guicontrolget,tuval,,BGP_TU
tuval:= (tuval * 5)
BGP_State:= (tuval + BGP_Enable + teval)
guicontrolget,GMJOY,,GMJOY
guicontrolget,CenKBM,,CenKBM
guicontrolget,CenPL1,,CenPL1
guicontrolget,CenPL2,,CenPL2
guicontrolget,CenMC,,CenMC
guicontrolget,CenGM,,CenGM
guicontrolget,CenMM,,CenMM
guicontrolget,CenJAL,,CenJAL
guicontrolget,CenJBE,,CenJBE
guicontrolget,CenPRE,,CenPRE
guicontrolget,CenPST,,CenPST
guicontrolget,GMCONF,,GMCONF
guicontrolget,NameChk,,NameChk
guicontrolget,NetChk,,NetChk
guicontrolget,OVERWRT,,OVERWRT
guicontrolget,GMLNK,,GMLNK
guicontrolget,Localize,,Localize
guicontrolget,INCLALTS,,INCLALTS
guicontrolget,KILLCHK,,KILLCHK
guicontrolget,Hide_Taskbar,,Hide_Taskbar
guicontrolget,EnableLogging,,EnableLogging
complist:= LVGetCheckedItems("SysListView321","v0rt3X_GUI")
fullist:= complist
stringsplit,fullstn,fullist,`n
gmnames:= "|"
gmnameds:= "|"
gmnamed:= ""
exlist:= "|"
stmdbfnd:= "|"SS
fullstx= %fullstn%
if !fileexist(GAME_Directory)
	{
		filecreatedir,%Game_Directory%
	}
if !fileexist(GAME_Profiles)
	{
		filecreatedir,%GAME_Profiles%
	}
bsvl=|
GLBTRY:= 0
if (NETCHK <> 1)
	{
		GLBTRY:= 4
	}
;Gui,Listview,MyListView	
;LV_Modify(0, "-Select")
Loop, %fullstn0%
	{
		if (CANCLD = 1)
			{
				break
			}
		steamquery:=0
		STMTRY:=0
		PCGWTRY:=0
		exfnm:= ""
		expth:= ""
		gmopts:= ""
		gmargs:= ""
		nameOverride:= ""
		kbmovr:= ""
		p1ovr:= ""
		p2ovr:= ""
		mcovr:= ""
		mmovr:= ""
		gmovr:= ""
		dmovr:= ""
		jlovr:= ""
		jbovr:= ""
		preovr:= ""
		pstovr:= ""
		bgmovr:= ""
		upi:= % fullstn%A_Index%
		Loop,parse,upi,|
			{			
				if (A_Index = 1)
					{
						exfnm:= A_LoopField
					}
				if (A_Index = 2)
					{
						expth:= A_LoopField
					}
				if (A_Index = 3)
					{
						gmopts:= A_LoopField
					}
				if (A_Index = 4)
					{
						gmargs:= A_LoopField
					}
				if (A_Index = 5)
					{
						nameOverride:= A_LoopField
					}
				if (A_Index = 6)
					{
						kbmovr:= A_LoopField
					}
				if (A_Index = 7)
					{
						pl1ovr:= A_LoopField
					}
				if (A_Index = 8)
					{
						pl2ovr:= A_LoopField
					}
				if (A_Index = 9)
					{
						mcpovr:= A_LoopField
					}
				if (A_Index = 10)
					{
						mmovr:= A_LoopField
					}
				if (A_Index = 11)
					{
						gmovr:= A_LoopField
					}
				if (A_Index = 12)
					{
						dmovr:= A_LoopField
					}
				if (A_Index = 13)
					{
						jlovr:= A_LoopField
					}
				if (A_Index = 14)
					{
						jbovr:= A_LoopField
					}
				if (A_Index = 15)
					{
						preovr:= A_LoopField
					}
				if (A_Index = 16)
					{
						pstovr:= A_LoopField
					}
				if (A_Index = 17)
					{
						bgmovr:= A_LoopField
					}
				if (A_Index = 18)
					{
						steamquery:= A_LoopField
					}
				if (A_Index = 18)
					{
						ChkMode:= A_LoopField
					}
			}
			if (!instr(stmdbfnd,steamquery)or(STEAMQUERY = 0))
				{
					GameData:= ""
					SaveData:= ""
					exe_list:= ""
					klist:= ""
				}
			prn= %expth%\%exfnm%
			stringlen,prt,prn
			if (!fileexist(prn)or (prt < 6))
				{
					continue
				}
			fnd64:= ""
			fnd32:= ""
			getaplist:= ""
			splitpath,prn,prnmx,OutDir,prnxtn,gmnamex
			exep= %OutDir%
			tlevel= %OutDir%
			exechk= %gmnamex%
			sx= 0
			exclu= 
			Loop,parse,Exclude_Directory,|
				{
					if (A_LoopField = "")
						{
							continue
						}
					if instr(prn,A_LoopField)
						{
							exclu= 1
							break
						}
				}
			if (exclu = 1)
				{
					continue
				}
			Loop,parse,SPLIT_SRC,| 
				{
					if (A_LoopField = "")
						{
							continue
						}
					if instr(prn,A_LoopField)
						{
							stringlen,tn,A_LoopField
							if (tn > sx)
								{
									TOPSCR:= A_LoopField
									sx:= tn
									goto, SCRLOOPFND
								}
						}
				}
			CONTINUE
			
			SCRLOOPFND:
			Stringreplace,gfnamecx,outdir,%TOPSCR%\,,All
			Loop,parse,gfnamecx,\
				{
					gfnamex:= A_LoopField
					break
				}	

			priority:= 0
			filtnx= %gmnamex%
			gosub,PAPT
			filtv= %gmnamex%
			exCAP= %sepr%
			exABR= %abbrv%
			stringreplace,exCAPs,exCAP,%A_Space%,,All
			njName= 	
			if ((nameOverride <> "")&& (nameOverride <> gmnamex) && !instr(bsvl,nameOverride))
				{
					gmnamed= %nameOverride%
					sexjnj= %nameOverride%
					njName= %gmnamed%
					exedp= %gmnamed%
					stringreplace,excp,gmnamed,%A_Space%,,All
					excn=|%excp%|
					goto, nameOVR
				}
			
			gosub, GETGOODNAME
			gmnamed= %njname%
			
			nameOVR:						

			invar= %gmnamed%
			gosub, CleanVar
			
			gmnamecm= %invarx%
			
			filtnx=%gmnamecm%	
			filtv= %njName%
			gosub,PAPT
			gnCAP= %sepr%
			gnABR= %abbrv%
			stringreplace,gnCAPs,gnCAP,%A_Space%,,All
			
			gmnamedx= |%gmnamecm%|
			invar= %gmnamex%
			gosub, CleanVar
			ExeSN= %invarx%
			gmnamfcm= %invarx%
			if instr(gmnamecm,ExeSN)
				{
					priority:= 2
				}
			if instr(gmnamecm,gmnamfcm)
				{
					priority:= 4
				}
			if (gmnamfcm = gmnamecm)
				{
					priority:= 5
				}
			if ((exABR = gnABR) or (exCAPs = gnABR) or (exCAP = gnCAP) or (gnCAPs = exCAPs))
				{
					priority:= 5
				}
			if (instr(gmnamex,"launch")or instr(gmnamex,"start"))
				{
					priority:= 6
				}
			SUBDCHK:
			if instr(priorb,gmnamedx)
				{
					priority:= 7
				}
			if instr(priora,gmnamedx)
				{
					priority:= 10
				}
			Loop,parse,gfnamex,\
				{
					if (A_LoopField = "")
						{
							continue
						}
					kinn:= A_LoopField
					invar= %kinn%
					gosub, CleanVar
					gmtnm= %invarx%
					kivx= |%gmtnm%|
					if instr(priorbb,kivx)
						{
							priority+=1
						}
					if instr(prioraa,kivx)
						{
							priority+=3
							if instr(priorbb,kivx)
								{
									priority+=-1
								}
								else {
									Loop,parse,priorbb,|
										{
											if (A_LoopField = "")
												{
													continue
												}
											if instr(gmnamex,A_LoopField)
												{
													priority+=-1
													break
												}
										}
								}
						}
					if (instr(unlike,kinn)or instr(reduced,kinn))
						{
							priority+=-1
						}
				}
			Loop,parse,reduced,|
				{
					if (A_LoopField = "")
						{
							continue
						}
					if (instr(gfnamex,A_LoopField)or instr(gmnamex,A_LoopField))
						{
							priority+=-1
							break
						}
				}
			Loop,parse,rabsol,`r`n
				{
					if (A_LoopField = "")
						{
							continue
						}
					if (instr(refname,A_LoopField)or instr(gmnamex,A_LoopField)&& !instr(gfnamex,A_LoopField))
						{
							priority+=-1
							break
						}
				}
			posa= %gmnamed%
			posb= |%gmnamed%|
			stringsplit,expa,exlist,|
			renum:= ""
			rn:= ""
			fp:= ""
			tot:=-20
			poscnt:= 0
			if instr(exlist,posb)
				{
					rn= 1
					fp:= ""
					nm:= ""
					Loop,%expa0%
						{
							fp= 0
							fn:= A_Index + 1
							fu:= % expa%A_index%
							if (fu = "")
								{
									continue
								}
							if (fu = posa)
								{
									poscnt+=1
									fp:= % expa%fn%
									if (fp > tot)
										{
											tot:= fp
										}
								}
						}
					if (priority >= tot)
						{
							renum= 1
						}
				}
				else {
				gmnamex= %gmnamed%
				}
			exlist.= posa . "|" . priority . "|"
			subfldrep:= ""
			if ((rn = 1)or instr(bsvl,gmnamex))
				{
					poscntx:= poscnt + 1
					if (poscnt > 0)
						{
							Loop,12
								{
									GMMO%A_Index%:= ""
								}
							stringsplit,GMMO,gmnamed,%A_Space%_-([{}
							if (GMMO3 = "")
								{
									stringleft,gmo,GMMO1,4
									stringleft,gmb,GMMO2,3
									stringupper,gmo,gmo,T
									stringupper,gmb,gmb,T
									gmname:= gmo . gmb
								}
							if (GMMO2 = "")
								{
									Stringleft,gmname,GMMO1,7
									stringupper,gmname,gmname,T
								}
							if ((GMMO1 = "the") or (GMMO1 = "A")&&(GMMO4 = ""))
								{
									stringleft,INNSG,GMMO1,1
									stringupper,INNSG,INNSG,T
									stringleft,INNSJ,GMMO2,1
									stringupper,INNSJ,INNSJ,T
									stringleft,gmop,GMMO3,3
									stringupper,gmop,gmop,T
									gmname= INNSG . INNSJ . GMOP
									if (gmop = "")
										{
											stringleft,INNSK,GMMO2,3
											stringupper,INNSK,INNSK,T
											gmname:= .INNSG . INNSK
										}
									if (INNSJ = "")
										{
											Stringleft,SICRME,INNSJ,5
											stringupper,SIRCME,SIRCME,T
											gmname= %SICRME%
										}
								}
							else {
									stringleft,abegin,GMMO1,3
									SIRCME= %abegin%
									stringleft,amidl,GMMO2,3
									SIRCAD= %amidl%
									stringleft,amend,GMMO3,2
									SIRCEND= %amend%
									stringupper,SIRCME,SIRCME,T
									stringupper,SIRCAD,SIRCAD,T
									stringupper,SIRCEND,SIRCEND,T
									gmname:= SIRCME . SIRCAD . SIRCEND
								}
							subnumbr:= poscnt
							;subfldrep= %poscnt%_More\
							subfldrep= alternates\
							substfldrc= %poscnt%_More\%gmname%_[0%poscntx%]
							if (INCLALTS = "")
								{
									gmnamex= %gmname%_[0%poscnt%]
								}
						}
					else {
						subfldrep:= ""
						if (INCLALTS = "")
							{
								gmnamex= %gmnamed%
							}
					}
				}
			bsvl.= gmnamed . "|"
			stringtrimright,subfldrepn,subfldrep,1
			
			sidn= %Game_Profiles%\%gmnameD%
			if (Localize = 1)
				{
					sidn= %OUTDIR%
				}
			splitpath,sidn,sidnf,sidnpth
			GMon= %subfldrep%%gmnamex%_GameMonitors.mon
			DMon= %subfldrep%%gmnamex%_DesktopMonitors.mon
			gamecfgn= %subfldrep%%gmnamex%.ini
			if ((renum = 1)or(rn = ""))
				{
					FileCreateDir,%sidn%\alternates
					subfldrep:= ""
					GMon= GameMonitors.mon
					DMon= DesktopMonitors.mon
					gamecfgn= Game.ini
					gmnamex= %gmnamed%
					
					FileMove,%sidn%\%gmnamed%.lnk,%sidn%\alternates\%gmnamed%_[0%poscntx%].lnk,1
					FileMove,%sidn%\Game.ini,%sidn%\alternates\%gmnamed%_[0%poscntx%].ini,1
					filedelete,%sidn%\*.xpadderprofile
					filedelete,%sidn%\*.amgp
					filedelete,%sidn%\.cfg
				}
			gamecfg= %sidn%\%subfldrep%%gamecfgn%
			if (CREFLD = 1)
				{
					FileCreateDir, %sidn%
					if (subfldrep <> "")
						{
							FileCreateDir, %sidn%\%subfldrepn%
							FileSetAttrib, +H, %sidn%\%Subfldrepn%
						}
				}
			else {
				if ((CREFLD = 0)&& !fileExist(sidn))
					{
						continue
					}
				}
			if fileExist(sidn . "\" . gamecfgn)
				{
					fileread,gfg,%sidn%\%gamecfgn%
					Loop,parse,gfg,`n`r
						{
							if (A_LoopField = "")
								{
									continue
								}
							stringleft,bb,A_LoopField,1
							if (bb = "[")
								{
									stringreplace,sect,A_LoopField,[,,
									stringreplace,section,sect,],,
									continue
								}
							stringsplit,an,A_LoopField,=<
							stringreplace,vb,A_LoopField,%an1%=,,
							stringright,pptx,an2,1
							if (((pptx is digit)&&(an3 = "")) && (instr(an1,"Pre")or instr(an1,"Post")) or ((an3 = "") && (an1 = "JustBeforeExit") or (an1 = "JustAfterLaunch")))
								{
									vb:= ""
								}
							if ((vb <> "")&&(vb <> "ERROR"))
								{
									%an1%:= vb
									G_%an1%:= vb
								}
						}
				
				}	
			skip:= ""
			cfgcopied:= ""
			if (!FileExist(gamecfg)or(OVERWRT = 1))
				{
					Filecopy,%RJDBINI%,%gamecfg%
					cfgcopied:= 1
					klist:= ""
				}
			fileread,grg,%RJDBINI%
			Loop,parse,grg,`n`r
				{
					if (A_LoopField = "")
						{
							continue
						}
					stringleft,bb,A_LoopField,1
					if (bb = "[")
						{
							stringreplace,sect,A_LoopField,[,,
							stringreplace,section,sect,],,
							continue
						}
					stringsplit,an,A_LoopField,=<
					stringreplace,vb,A_LoopField,%an1%=,,
					stringright,pptx,an2,1
					gexprv:= % (%an1%)
					gexpr:= % (G_%an1%)
					if (((pptx is digit)&&(an3 = "")) && (instr(an1,"Pre")or instr(an1,"Post")) or ((an3 = "") && (an1 = "JustBeforeExit") or (an1 = "JustAfterLaunch")))
						{
							vb:= ""
						}
					if ((vb <> "")&&(vb <> "ERROR"))
						{
							krs:= % an1
							Loop,parse,SPLIT_SRC,|
								{
									if ((an1 = A_LoopField) or (an1 = "Game_Profiles")or(an1 = "Game_Directory"))
										{
											Continue
										}
								}
							R_%an1%:= vb	
							if (instr(vb,".cmd")or instr(vb,".bat")or instr(vb,".vbs")or instr(vb,".ps1")or instr(vb,".vbe")or instr(vb,".wsc")or instr(vb,".wsf")or instr(vb,".psd"))
								  {
										eb2:= ""
										stringsplit,eb,vb,<
										if (eb2 <> "")
											{
												splitpath,eb2,vb
												vbp:= eb2
												eb1.= "<"
											}
											else {
													splitpath,eb1,vb
													vbp:= eb1
													eb1:= "" 
											}
										R_%an1%:= eb1 . vbp	
										%an1%:= eb1 . vbp
										if ((OVERWRT = 1)&& instr(an1,"Before") && (CENJBE <> 1))
											{
											    G_%an1%:= eb1 . sidn "\" . vb
												filecopy,%eb1%%vbp%,%sidn%,%OVERWRT%
												iniwrite,%eb1%%sidn%\%vb%,%gamecfg%,CONFIG,%an1%
											}
											else {
												if ((CENJBE = 1)&& instr(an1,"Before") && (OVERWRT = 1))
													{
														G_%an1%:= eb1 . vbp	
														iniwrite,%eb1%%vbp%,%GAMECFG%,CONFIG,%an1%
													}
											}
										if ((OVERWRT = 1)&& instr(an1,"After") && (CENJAL <> 1))																					
											{
											    G_%an1%:= eb1 . sidn . "\" . vb
												filecopy,%vbp%,%sidn%,%OVERWRT%
												iniwrite,%eb1%%sidn%\%vb%,%gamecfg%,CONFIG,%an1%
											}
											else {
												if ((CENJAL = 1)&& instr(an1,"After") && (OVERWRT = 1))										  
													{
														G_%an1%:= eb1 . vbp	
														iniwrite,%eb1%%vbp%,%GAMECFG%,CONFIG,%an1%
													}
											}
										if ((OVERWRT = 1)&& instr(an1,"Pre") && (CENPRE <> 1))
											{
											  G_%an1%:= eb1 . sidn . "\" . vb
											  filecopy,%vbp%,%sidn%,%OVERWRT%
											  iniwrite,%eb1%%sidn%\%vb%,%gamecfg%,%section%,%an1%
											} 
											else {
												if ((CENPRE = 1)&& instr(an1,"Pre")&&(OVERWRT = 1))
													{
														G_%an1%:= eb1 . vbp	
														iniwrite,%eb1%%vbp%,%gamecfg%,%section%,%an1%
													}
												}
										if ((OVERWRT = 1)&& instr(an1,"Post") && (CENPST <> 1))
											{
											  G_%an1%= eb1 . sidn . "\" . vb
											  filecopy,%vbp%,%sidn%,%OVERWRT%
											  iniwrite,%eb1%%sidn%\%vb%,%gamecfg%,%section%,%an1%
											} 			  
											else {
												if ((CENPST = 1)&& instr(an1,"Post")&&(OVERWRT = 1))
													{
														G_%an1%:= eb1 . vbp	
														iniwrite,%eb1%%vbp%,%gamecfg%,%section%,%an1%
													}
											}
										if (OVERWRT = 1)
											{
												G_%an1%:= vb	
											}
										R_%an1%:= vb
										CONTINUE
								  }
							if !instr(an1,"template")
								{
									if (OVERWRT = 1)
										{
											G_%an1%:= vb
											R_%an1%:= vb
											iniwrite,%vb%,%gamecfg%,%section%,%an1%
										}
									continue
								}	
						}
					if (gexpr <> "")
						{
							vb:= gexpr
							%an1%:= vb
							G_%an1%:= vb
							R_%an1%:= vb
						}
					iniwrite,%vb%,%gamecfg%,%section%,%an1%	
				}
			if (GMLNK = 1)
				{
					OutRunState:= 1
					OutTarget:= prn
					refname:= gmnamex
					OutDescription:= gmnamex
					IconNumber:= 0
					prvv:= sidn . "\" . subfldrep . gmnamex . ".lnk"
					linktar:= GAME_Directory . "\" . gmnamex
					linktarget:= linktar . ".lnk"
					linktargez:= linktar . ".cmd"
					linkprox:= sidn . "\" . subfldrep . gmnamex
					linkproxy:= linkprox . ".lnk"
					linkproxz:= linkprox . ".cmd"
					jkoptz= 
					if ((OVERWRT = 1)&&(prnxtn = "lnk"))
						{
							if (!fileexist(linkproxy) or (renum = 1))
								{
									FileCreateShortcut,%prn%,%linkproxy%,%outdir%,%OutArgs%,%refname%, %OutTarget%,, %IconNumber%, %OutRunState%
									Filecopy,%prvv%,%sidn%\%subfldrep%%gmnamed%._lnk_,%OVERWRT%
								}
							if (!fileexist(linktarget)or(renum = 1))
								{
									FileDelete,%linktarget%
									FileCreateShortcut, %RJDB_LOCATION%\bin\jkvtx.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%jkoptz%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
								}
						}
					if (prnxtn = "exe")
						{
							OutArgs=						
							OutArgz=						
							if ((gmopts <> "")&&(gmopts <> "<"))
								{
									OutArgs:= gmopts
								}
							if ((gmargs <> "")&&(gmargs <> "<"))
								{
									if (outopts <> "")
										{
											OutArgs:= A_Space
										}
									OutArgs.= gmargs
								}
							if ((OVERWRT = 1)or(renum = 1))
								{
									FileDelete,%linkproxy%
								}
							FileCreateShortcut,%prn%,%linkproxy%,%outdir%,%OutArgs%,%refname%, %OutTarget%,, %IconNumber%, %OutRunState%
							if (renum = 1)
								{
									if fileexist(linktarget)
										{
											FileDelete,%linktarget%
										}
								}
							if ((rn = "")or(renum = 1))
								{
									FileCreateShortcut, %RJDB_LOCATION%\bin\jkvtx.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%jkoptz%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
								}
							if (!fileexist(linktarget)&&(renum = "")&&(SETALTSALL = 1))
								{
									FileCreateShortcut, %RJDB_LOCATION%\bin\jkvtx.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%jkoptz%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
								}
						}
					if (ASADMIN = 1)
						{
							RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %linkproxy%, ~ RUNASADMIN
						}
					if (GMCONF = 1)
						{
							Player1x= %sidn%\%subfldrep%%GMNAMEX%.%Mapper_Extension%
							Player2x= %sidn%\%subfldrep%%GMNAMEX%_2.%Mapper_Extension%
							
							
							stringreplace,pl1ovr,pl1ovr,<,,All
							stringreplace,pl1ovr,pl1ovr,>,,All
							stringreplace,pl1ovr,pl1ovr,/,\,All
							stringreplace,pl1ovr,pl1ovr,",,All   ;"
							if ((pl1ovr <> "<")&&(pl1ovr <> "")&&fileexist(pl1ovr))
								{
									Player1_Template:= pl1ovr
									splitpath,pl1ovr,pl1flnm
								}
							stringreplace,pl2ovr,pl2ovr,<,,All
							stringreplace,pl2ovr,pl2ovr,>,,All
							stringreplace,pl2ovr,pl2ovr,/,\,All
							stringreplace,pl2ovr,pl2ovr,",,All   ;"
							if ((pl2ovr <> "<")&&(pl2ovr <> "")&&fileexist(pl2ovr))
								{
									Player2_Template:= pl1ovr
									splitpath,pl2ovr,pl2flnm
								}
							stringreplace,mcpovr,mcpovr,<,,All
							stringreplace,mcpovr,mcpovr,>,,All
							stringreplace,mcpovr,mcpovr,/,\,All
							stringreplace,mcpovr,mcpovr,",,All   ;"
							if ((mcpovr <> "<")&&(mcpovr <> "")&&fileExist(mcpovr))
								{
									MediaCenter_Template:= mcpovr
								}
								
							SplitPath,MediaCenter_Template,MediaCenter_TemplateName	
							MediaCenter_ProfileX= %sidn%\%subfldrep%%MediaCenter_TemplateName%	
							if (CENPL1 = 1)
								{
									Player1x:= Player1_Template
								}
							if (CENPL2 = 1)
								{
									Player2x:= Player2_Template
								}
							if (CENMC = 1)
								{
									MediaCenter_ProfileX:= MediaCenter_Template
								}	
							if ((G_SaveData = "") or (G_SaveData = "ERROR"))
								{
									iniwrite, %SaveData%,%Savecfg%,CONFIG,SaveData
								}
							if ((G_GameData = "") or (G_GameData = "ERROR"))
								{
									iniwrite, %GameData%,%gamecfg%,CONFIG,GameData
								}	
							if ((OVERWRT = 1)or(cfgcopied = 1))
								{
									iniwrite, %sidn%,%gamecfg%,CONFIG,GAME_PROFILES
									inidelete,%gamecfg%,GENERAL,GAME_PROFILES
									iniwrite, %outdir%,%gamecfg%,CONFIG,Source_Directory
									inidelete,%gamecfg%,GENERAL,Source_Directory
									iniwrite, %gamecfg%,%gamecfg%,CONFIG,RJDB_Config
									inidelete,%gamecfg%,GENERAL,RJDB_Config
									iniwrite, %klist%,%gamecfg%,CONFIG,exe_list
									iniwrite, %GameData%,%gamecfg%,CONFIG,GameData
									iniwrite, %SaveData%,%gamecfg%,CONFIG,SaveData
								}
							if ((dmovr <> "")&& fileExist(dmovr))
								{
									SplitPath,dmovr,DMon
								}
							DeskMon:= sidn . "\" . subfldrep . DMon
							if ((gmovr <> "")&& fileExist(gmovr))
								{
									SplitPath,gmovr,GMon
								}
							GameMon:= sidn . "\" . subfldrep . GMon
							if (CENMM = 1)
								{
									DeskMon:= R_MM_MediaCenter_Config
									if ((dmovr <> "")&& fileExist(dmovr))
										{
											SplitPath,dmovr,DMon
											DeskMon:= dmovr
										}
								}
							if (MM_MediaCenter_Config = "DISABLED")
								{
									DeskMon:= "disabled"
								}
							if (CENGM = 1)
								{
									GameMon= %R_MM_Game_Config%
									if ((gmovr <> "")&& fileExist(gmovr))
										{
											GameMon:= gmovr
										}
								}
							if (MM_Game_Config = "DISABLED")
								{
									GameMon:= "disabled"
								}
							if ((dgovr <> "<")&&(dgovr <> "")&&fileexist(dgovr))
								{
									DeskMon:= dgovr
								}
							if ((mgovr <> "<")&&(mgovr <> "")&&fileExist(mgovr))
								{
									GameMon:= mgovr
								}
							if ((OVERWRT = 1) or (G_MM_MediaCenter_Config = "") or (G_MM_MediaCenter_Config = "ERROR")) or (!fileexist(DeskMon)&& fileexist(MM_MediaCenter_Config))
								{
									if (MM_MediaCenter_Config <> DeskMon)
										{
											filecopy, %MM_MediaCenter_Config%,%DeskMon%,%OVERWRT%
										}
									iniwrite,%DeskMon%,%gamecfg%,CONFIG,MM_MediaCenter_Config
								}
							if ((OVERWRT = 1) or (G_MM_Game_Config = "") or (G_MM_Game_Config = "ERROR"))or (!fileexist(GameMon)&& fileexist(MM_Game_Config))
								{
									if (MM_Game_Config <> GameMon)
										{
											filecopy, %MM_GAME_Config%,%GameMon%,%OVERWRT%
										}
									iniwrite,%GameMon%,%gamecfg%,CONFIG,MM_Game_Config
								}
							GameProfs:= sidn
							iniwrite,%GameMon%,%gamecfg%,CONFIG,MM_Game_Config
							iniwrite,%DeskMon%,%gamecfg%,CONFIG,MM_MediaCenter_Config
							iniwrite,%OutDir%,%gamecfg%,CONFIG,Install_Directory
							iniwrite,%prnmx%,%gamecfg%,CONFIG,Exe_File
							killist:
							fileappend,tlevel=%tlevel%`n0-klist=%klist%`nkillchk=%killchk%`nprnmx=%prnmx%`n,%home%\log.txt,UTF-8
							if ((KILLCHK = 1)&&(klist = ""))
								{										   
									fileappend,ok...tlevel=%tlevel%`n0-klist=%klist%`nkillchk=%killchk%`nprnmx=%prnmx%`n,%home%\log.txt,UTF-8
									klist= |%prnmx%|
									Loop,files,%tlevel%\*.exe,R
										{
											splitpath,A_LoopFileFullPath,tmpfn,tmpfd,,tmpfo
											abson=
											abexe=|%tmpfn%|
											Loop,parse,absol,`r`n
												{
													if (A_LoopField = "")
														{
															continue
														}
													if instr(tmpfo,A_LoopField)
														{
															abson= 1
															continue
														}		
												}
											if (!instr(klist,abexe) && (abson = ""))
												{
													klist.= tmpfn . "|"
												}
										}
									fileappend,1-%klist%`n,%home%\log.txt,UTF-8
									iniread,nklist,%gamecfg%,CONFIG,exe_list
									if ((nklist = "")or(nklist = "ERROR")or(OVERWRT = 1))
										{
											iniwrite,%klist%,%gamecfg%,CONFIG,exe_list
										}
									fileappend,2-%klist%`n,%home%\log.txt,UTF-8
								}
						}
				}
			if ((GMJOY = 1) && (subfldrep = ""))
				{
					IF ((CENPL1 <> 1)or(Player1_Template = "DISABLED"))
						{							
							if (Player1_Template <> player1X)
								{
									Filecopy,%Player1_Template%,%player1X%,%OVERWRT%
								}
							if ((errorlevel = 0)or fileexist(player1X))
								{
									if (OVERWRT = 1)
										{
											iniwrite,%player1x%,%GAMECFG%,JOYSTICKS,Player1
										}
									else {
											if ((G_Player1 = "ERROR")or(G_Player1 = ""))
												{
													iniwrite,%player1x%,%GAMECFG%,JOYSTICKS,Player1
												}
										}
								}
						}
						else {
							if ((G_Player1 = "ERROR")or(G_Player1 = "")or(OVERWRT = 1))
								{
									iniwrite,%Player1_Template%,%gamecfg%,JOYSTICKS,Player1
								}
						}
					if ((MAPPER <> 3)&&(Mapper <> "")&&(Mapper <> 0))
						{
							if ((CENPL2 <> 1)or(Player2_Template = "DISABLED"))
								{
									if (Player2_Template <> player2X)
										{
											Filecopy,%Player2_Template%,%player2X%,%OVERWRT%
										}
									if ((errorlevel = 0)or fileexist(player2x))
										{
											if (OVERWRT = 1)
												{
													iniwrite,%player2x%,%GAMECFG%,JOYSTICKS,Player2
												}
											else {
													if ((G_Player2 = "ERROR")or(G_Player2 = ""))
														{
															iniwrite,%player2x%,%GAMECFG%,JOYSTICKS,Player2
														}
												}
										}
								}
							else {
								if ((G_Player2 = "ERROR")or(G_Player2 = "")or(OVERWRT = 1))
									{
										iniwrite,%Player2_Template%,%gamecfg%,JOYSTICKS,Player2
									}
							}	
						}
					if ((CENMC <> 1)&&(MediaCenter_Template = "DISABLED"))
						{
							if (MediaCenter_Template <> MediaCenter_ProfileX)
								{
									Filecopy,%MediaCenter_Template%,%MediaCenter_ProfileX%,%OVERWRT%
								}
							if ((errorlevel = 0)or fileexist(MediaCenter_ProfileX)or(MediaCenter_ProfileX = "DISABLED"))
								{
									if (OVERWRT = 1)
										{
											iniwrite,%MediaCenter_ProfileX%,%GAMECFG%,JOYSTICKS,MediaCenter_Profile
										}
									else {
											if ((G_MediaCenter_Profile = "ERROR")or(G_MediaCenter_Profile = ""))
												{
													iniwrite,%MediaCenter_ProfileX%,%GAMECFG%,JOYSTICKS,MediaCenter_Profile
												}
										}
								}	
						}
					else {
						if ((G_MediaCenter_Profile = "ERROR")or(G_MediaCenter_Profile = "")or(OVERWRT = 1))
							{
								iniwrite,%MediaCenter_Template%,%gamecfg%,JOYSTICKS,MediaCenter_Profile
							}
					}	
				}
			JUSTB:= JustBeforeExit
			JUSTA:= JustAfterLaunch	
			stringreplace,jlovr,jlovr,<,,All
			stringreplace,jlovr,jlovr,>,,All
			stringreplace,jlovr,jlovr,/,\,All
			stringreplace,jlovr,jlovr,?,,All
			stringreplace,jlovr,jlovr,*,,All
			if ((jbovr <> "<")&& fileexist(jbovr))
				{
					stringsplit,prexx,JustAfterLaunch,<
					JUSTA:= prexx1 . "<" . jbovr
					iniwrite,%JUSTA%,%gamecfg%,GENERAL,JustAfterLaunch
				}
			stringreplace,jbovr,jbovr,<,,All
			stringreplace,jbovr,jbovr,>,,All
			stringreplace,jbovr,jbovr,/,\,All
			stringreplace,jbovr,jbovr,?,,All
			stringreplace,jbovr,jbovr,*,,All
			if ((jbovr <> "<")&& fileexist(jbovr))
				{
					stringsplit,prexx,JustBeforeExit,<
					JUSTB:= prexx1 . "<" . jbovr
					iniwrite,%JUSTB%,%gamecfg%,GENERAL,JustBeforeExit
				}
			if (GMLNK = 1)
				{
					newcmd:= linkproxz
					if ((OVERWRT = 1)or(renum = 1))
						{
							MonitorMode:= 2
							if ((mmovr = "n") or (mmovr ="0"))
								{
									MonitorMode:= 0
								}
							stringreplace,cmdtmp,cmdtpp,[MonitorMode],%MonitorMode%
							stringreplace,cmdtmp,cmdtmp,[multimonitor_tool],%multimonitor_tool%
							stringreplace,cmdtmp,cmdtmp,[Mapper],%mapper%
							stringreplace,cmdtmp,cmdtmp,[GAME_EXE],%prn%

							Loop,3
								{
									prea2= ""
									npre:= % %A_Index%_Post
									npst:= % %A_Index%_Post
									stringsplit,prea,npre,<
									%A_Index%_PostW:= "call"
									if (prea2 <> "")
										{
											if instr(prea1,"W")
												{
													%A_Index%_PostW= start /Wait ""
												}
											%A_Index%_Post:= prea2
										}
									prea2= 
									stringsplit,prea,npst,<
									%A_Index%_PostW=call
									if (prea2 <> "")
										{
											if instr(prea1,"W")
												{
													%A_Index%_PostW= start /Wait ""
												}
											%A_Index%_Post:= prea2
										}
								}
							prea2:= ""
							stringsplit,prea,JUSTB,<
							JBEW=call
							if (prea2 <> "")
								{
									if instr(prea1,"W")
										{
											JBEW= start /Wait ""
										}
									JUSTB:= prea2
								}
							prea2:= ""
							JALW=call
							stringsplit,prea,JUSTA,<
							if (prea2 <> "")
								{
									if instr(prea1,"W")
										{
											JALW= start /Wait ""
										}
									JUSTA:= prea2
								}
							stringreplace,cmdtmp,cmdtmp,[1_Post],%1_Post%
							stringreplace,cmdtmp,cmdtmp,[1_PostW],%1_PostW%
							stringreplace,cmdtmp,cmdtmp,[2_Post],%2_Post%
							stringreplace,cmdtmp,cmdtmp,[2_PostW],%2_PostW%
							stringreplace,cmdtmp,cmdtmp,[3_Post],%3_Post%
							stringreplace,cmdtmp,cmdtmp,[3_PostW],%3_PostW%
							stringreplace,cmdtmp,cmdtmp,[3_PostW],%3_PostW%
							stringreplace,cmdtmp,cmdtmp,[3_Post],%3_Post%
							stringreplace,cmdtmp,cmdtmp,[2_Post],%2_Post%
							stringreplace,cmdtmp,cmdtmp,[2_PostW],%2_PostW%
							stringreplace,cmdtmp,cmdtmp,[1_Post],%1_Post%
							stringreplace,cmdtmp,cmdtmp,[1_PostW],%1_PostW%
							stringreplace,cmdtmp,cmdtmp,[JustBeforeExit],%JUSTB%
							stringreplace,cmdtmp,cmdtmp,[JBEW],%JBEW%
							stringreplace,cmdtmp,cmdtmp,[JustAfterLaunch],%JUSTA%
							stringreplace,cmdtmp,cmdtmp,[JALW],%JALW%
							stringreplace,cmdtmp,cmdtmp,[exelist],%klist%
							stringreplace,cmdtmp,cmdtmp,[MultiMonitor_tool],%MultiMonitor_Tool%
							stringreplace,cmdtmp,cmdtmp,[keyboard_mapper],%keyboard_mapper%
							stringreplace,cmdtmp,cmdtmp,[MM_Game_config],%GameMon%
							stringreplace,cmdtmp,cmdtmp,[MM_MediaCenter_config],%DeskMon%
							stringreplace,cmdtmp,cmdtmp,[MediaCenter_profile],%MediaCenter_ProfileX%
							stringreplace,cmdtmp,cmdtmp,[Borderless_Gaming_Program],%Borderless_Gaming_Program%
							stringreplace,cmdtmp,cmdtmp,[BGP_State],%BGP_State%
							stringreplace,cmdtmp,cmdtmp,[Player1],%Player1x%
							stringreplace,cmdtmp,cmdtmp,[Player2],%Player2x%
							stringreplace,cmdtmp,cmdtmp,1<,,All
							stringreplace,cmdtmp,cmdtmp,2<,,All
							stringreplace,cmdtmp,cmdtmp,3<,,All				 
											 
							FileDelete,%linkproxz%
						}
					if (renum = 1)
						{
							if (fileexist(linkproxz)&&(OVERWRT = 1))
								{
									FileDelete,%linkproxz%
								}
						}
					if ((rn = "")or(renum = 1)&& !fileexist(linkproxz))
						{
							fileappend,%cmdtmp%,%linkproxz%,UTF-8
						}
					if (!fileexist(linkproxz)&&(renum = "")&&(SETALTSALL = 1))
						{
							fileappend,%cmdtmp%,%linkproxz%,UTF-8
						}
				}
			if ((kbmovr = "n") or (kbmovr = "0") or (MAPPER = "") or (Mapper = 0))
				{
					iniwrite,0,%GAMECFG%,GENERAL,Mapper
				}
			if (((mmovr = "n") or (mmovr ="0") && (OVERWRT = 1)) or ((G_MonitorMode = "") or (G_MonitorMode = "ERROR") && ((mmovr = "n") or (mmovr ="0"))))
				{
					iniwrite,0,%GAMECFG%,GENERAL,MonitorMode
				}
			if (((bgmovr <> "<")or(G_BGP_State <> R_BGP_State)&&(OVERWRT = 1))or((G_BGP_State = "") or (G_BGP_State = "ERROR")))
				{
					if (bgmovr <> "<")
						{
							bgmovrW:= bgmovr
						}
						else {
							bgmovrW:= BGP_State
						}
					iniwrite,%bgmovrW%,%GAMECFG%,GENERAL,BGP_State
				}
			if (((preovr = "n") or (preovr ="0")) && ((G_1_Pre = "ERROR")&&(OVERWRT = 1)))
				{
					iniwrite,%A_Space%,%GAMECFG%,CONFIG,1_Pre
				}
			if (((preovr = "n") or (preovr ="0")) && ((G_2_Pre = "ERROR")&&(OVERWRT = 1)))
				{
					iniwrite,%A_Space%,%GAMECFG%,CONFIG,2_Pre
				}
			if (((preovr = "n") or (preovr ="0")) && ((G_3_Pre = "ERROR")&&(OVERWRT = 1)))
				{
					iniwrite,%A_Space%,%GAMECFG%,CONFIG,3_Pre
				}
			if (((Pstovr = "n") or (Pstovr ="0")) && ((G_1_Post = "ERROR")&&(OVERWRT = 1)))
				{
					iniwrite,%A_Space%,%GAMECFG%,CONFIG,1_Post
				}
			if (((Pstovr = "n") or (Pstovr ="0")) && ((G_2_Post = "ERROR")&&(OVERWRT = 1)))
				{
					iniwrite,%A_Space%,%GAMECFG%,CONFIG,2_Post
				}
			if (((Pstovr = "n") or (Pstovr ="0")) && ((G_3_Post = "ERROR")&&(OVERWRT = 1)))
				{
					iniwrite,%A_Space%,%GAMECFG%,CONFIG,3_Post
				}
			if ((G_Steam_ID = "")&&(STEAMQUERY <> 0))or((OVERWRT = 1)&&(steamquery <> 0))
				{
					iniwrite,%steamquery%,%GAMECFG%,CONFIG,Steam_ID
				}
			if ((GLBTRY >= 3)or(Net_Check = 0))
				{
					goto, PROFILECOMPLETE
				}
			if (((steamquery = 0)&&(G_Steam_ID <> "")&& !fileExist(sidn . "\" G_Steam_ID . ".json"))or (!instr(stmdbfnd,steamquery)&&(steamquery <> 0)))
				{
					if (steamquery = 0)
						{
							steamquery= %G_Steam_ID%
							iniwrite,%steamquery%,%GAMECFG%,CONFIG,Steam_ID
						}
					if !instr(stmdbfnd,steamquery)
						{
							GameData:= ""
							SaveData:= ""
							SB_SetText("Querying intenet-databases")
							iniwrite,%steamquery%,%GAMECFG%,CONFIG,Steam_ID
							stmdbfnd.= steamquery . "|"
							gosub, steamappinfo
						}
				}
				else {
					if ((steamquery = 0)&&(G_Steam_ID = 0)or(G_Steam_ID = ""))
						{
							GameData:= ""
							SaveData:= ""
						}
				}
			PROFILECOMPLETE:	
			SB_SetText("created profile for " gmnamex "")
	}
SB_SetText("Shortcuts Created")
if (ASADMIN = 1)
	{
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %binhome%\jkvtx.exe, ~ RUNASADMIN
	}
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
		stringreplace,exlisting,exlist,|,`n,All
	}
guicontrol,hide,CANCLDBUT
guicontrol,disable,CANCLDBUT
popui:= ""
return

RlsGrpRoll:
stringlen,rgv,rgg
stringright,nv,njname,%rgv%
sexenj= %njname%
if (instr(njname,rgg)&&(nv = rgg))
	{		
		Loop,parse,RLSPFX,|
			{
				ccba:= A_LoopField . rgg
				stringreplace,sexenj,njname,%ccba%,,All
				if ((sexenj <> njname)&& !instr(exechk,ccba))
					{
						nJname= %sexenj%
						hh= 1
						break
					}
			}
	}
return

PAPT:
inpapt=%filtnx%
stringreplace,filtnx,filtnx,_,,All
stringreplace,filtnx,filtnx,Win32,,
stringreplace,filtnx,filtnx,Win64,,
stringreplace,filtnx,filtnx,x86,,
stringreplace,filtnx,filtnx,x86,,
stringreplace,filtnx,filtnx,x64,,
stringreplace,filtnx,filtnx,-64,,
stringreplace,filtnx,filtnx,-32,,
stringreplace,filtnx,filtnx,-,,All
if instr(filtnx,"Shipping")
	{
		stringreplace,filtnx,filtnx,Shipping,,	
		priority+= -1
	}
if ((filtni <> filtnx) && !instr(filtnx,"Shipping"))
sepr:= % RegexReplace(filtnx, "[^A-Z\s]\K([A-Z])", " $1")
fnCAPS:= % RegexReplace(filtv,"((?<=[a-z])[A-Z]|[A-Z](?=[a-z]))", " $1")	
fsCAPS= %fnCAPS%
r:= "" . sepr . ""
var := r, abbrv := ""
Loop, Parse, var, %A_Space%
	{
		abbrv := abbrv SubStr(A_LoopField, "1", "1")
	}
return

WinStrip:
stringreplace,WinStrip,WinStrip,[,,All	
stringreplace,WinStrip,WinStrip,],,All	
stringreplace,WinStrip,WinStrip,\,,All
stringreplace,WinStrip,WinStrip,|,,All
stringreplace,WinStrip,WinStrip,/,,All
stringreplace,WinStrip,WinStrip,<,,All	
stringreplace,WinStrip,WinStrip,>,,All	
stringreplace,WinStrip,WinStrip,?,-,All	
stringreplace,WinStrip,WinStrip,:,-,All	
stringreplace,WinStrip,WinStrip,*,-,All	
stringreplace,WinStrip,WinStrip,_,%A_Space%,All	
return
	
StripVar:
stringreplace,invarx,invar,\,,All
stringreplace,invarx,invarx,/,,All
stringreplace,invarx,invarx,!,,All
stringreplace,invarx,invarx,&,and,All
stringreplace,invarx,invarx,$,,All
stringreplace,invarx,invarx,`%,,All
stringreplace,invarx,invarx,@,,All
stringreplace,invarx,invarx,+,,All
stringreplace,invarx,invarx,~,,All
stringreplace,invarx,invarx,#,,All
stringreplace,invarx,invarx,`;,,All
invar=%invarx%
CleanVar:
stringreplace,invarx,invar,`,,,All
stringreplace,invarx,invarx,_,,All	
stringreplace,invarx,invarx,(,,All
stringreplace,invarx,invarx,),,All
stringreplace,invarx,invarx,{,,All
stringreplace,invarx,invarx,},,All
stringreplace,invarx,invarx,[,,All
stringreplace,invarx,invarx,],,All
stringreplace,invarx,invarx,',,All
stringreplace,invarp,invarx,-,,All
stringreplace,invarx,invarp,%A_SPace%,,All
stringreplace,invarp,invarp,.,,All
return

senclean:
stringright,gta,vartu,2
stringright,gtn,vartu,3
stringright,gth,vartu,4
sr= %vartu%
if (gth = " The")
	stringtrimright,kn,sr,4
if (gta = " A")
	stringtrimright,kn,sr,2
if (gtn = " An")
	stringtrimright,kn,sr,3
if (kn <> "")
	{
		sr= %kn%
	}
stringleft,gta,sr,2
stringleft,gtn,sr,3
stringleft,gth,sr,4
if (gth = "The ")
	stringtrimleft,kn,sr,4
if (gta = "A ")
	stringtrimleft,kn,sr,2
if (gtn = "An ")
	stringtrimleft,kn,sr,3
if (kn <> "")
	{
		tuvar= %kn%
	}
	else {
		tuvar= %sr%
	}
return	

IncludeDD:
gui,submit,nohide
iniwrite,%IncludeDD%,%RJDBINI%,GENERAL,IncludeDD
return

GETGOODNAME:
stringreplace,exepo,exep,%TOPSCR%,,
nfn=
scrtst:= ""
if (exepo = "")
	{
		Loop,parse,srcloop,\
			{
				if (A_LoopField = "")
					{
						continue
					}
				exepo:= A_LoopField
			}
	}	
if instr(Extra_Source,TOPSCR . "\" . exepo)
	{
		scrtst= 1
	}
exepN= %exepo%
jpiter:= ""
repscr:= SRCLOOP
stringsplit,exepar,exepo,\
exepJ=
nsl=
exeJ: 
stringleft,a,exepo,1
if (a = "\")
	{
		stringtrimleft,exepo,exepo,1
	}
stringsplit,exer,exepo,\
chkag= 
Loop,%exer0%
	{
		ns:= exer%A_Index%
		if (ns = "")
			continue
		if (chkag = "")
			{
				chkag= %ns%
			}
		stringlen,e,ns
	}
e+=1
stringtrimright,exepo,exepo,%e%
exepj.= ns . "\"
if ((exepo = "\")or(exepo = ""))
	{
		goto, jpd
	}
goto, exej
jpd:
Loop,parse,exepJ,\
	{
		if (A_LoopField = "")
			{
				continue
			}
		ac= 	
		din= %A_LoopField%
		njName= %din%
		invar= %din%
		gosub, StripVar
		xin= %invarx%
		brk= |%din%|	
		xrk= |%xin%|
		if (instr(exclfls,brk) or instr(exclfls,xrk))
			{
				njname:= ""
				ac= 1
			}
		if (ac = 1)
			{
				continue
			}
		Loop,parse,rabsol,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				if instr(din,A_LoopField)
					{
						njname:= ""
						ac= 1
						break
					}
			}
		if (ac = 1)
			{
				continue
			}
		Loop,parse,absol,`r`n
			{
				if (A_LoopField = "")
					{
						continue
					}
				if instr(din,A_LoopField)
					{
						njname:= ""
						ac= 1
						break
					}
			}
		if (ac = 1)
			{
				continue
			}
	}
if ((instr(exechk,chkag) or instr(chkag,exechk) && !instr(njname,chkag) && !instr(chkag,njname)) or ((chkag = exechk)))
	{
		njname= %chkag%
	}
redux:
nexenj:= ""
mf=	
vmo= 
ap= 
Loop,parse,rlspfx,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		delim:= A_LoopField
		stringsplit,vm,njName,%delim%
		if (vm2 = "")
			{
				continue
			}
		vmind:= delim
		vmc= 
		Loop,%vm0%
			{
				vmc+=1
			}
		njnx= %njname%
		Loop,%vm0%
			{
				vmnn:= ""
				pkr:= % vm%A_Index%
				Loop, 20
					{
						if (A_Index = vmc)
							{
								vmind= 	
								stringreplace,njnx,njnx,%pkr%,,
								break
							}
						stringreplace,njnx,njnx,%pkr%%delim%,,
						if (errorlevel = 1)
							{
								break
							}
					}
				ap:= regexmatch(njnx,"i)^Pre.?Rel.*|^Pre.?Alpha.*|^Early.?Access.*|^Early.?B.*l.*d.*|Early.?Rel.*|^Rls.?[0-9].*|^Rls.v.*[0-9].*|^Demo.?v.[0-9]*|^Demo.?B.*ld.*|^Alpha.?B.*ld.*|^Alpha.R.?l.*s.*|^devel.*b.*l.*d.*|^Devel.?R.*l.*s.*|^R.?l.*s.?+[0-9].*|^Rel.v.?[0-9].*|^Build.v.?[0-9].*|^Build.[0-9].*|^Debug.?[0-9].*|^Debug.v.*[0-9].*|^UPDATE.*|^final.?v.?[0-9].*|^fin.?v.?[0-9].*|^Updt.*v.?[0-9].*|^v.?[0-9].*|^ver.?[0-9].*|^Developer.*",trmp)
				if (ap = 1)
					{
						stringreplace,njnameg,njname,%vmind%%trmp%,,
						if (njnameg <> njname)
							{
								njname= %njnameg%
								break
							}
					}
			}
	}
jexenj:= ""
loop,parse,RLSIFX,|
	{
		if (jexenj = "")
			jexenj= %njname%
		if instr(jexenj,A_LoopField)
			{
				stringreplace,nexenj,jexenj,%A_LoopField%,,
				if ((nexenj <> jexenj)&&(nexenj <> ""))
					{
						njName= %nexenj%
						break
					}
			}
	}
if (nexenj = "")
	{
		nexenj= %njname%
	}
sexjnj= %njName%
Loop,parse,rlsgrps,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		hh=	
		rgg:= A_LoopField
		rgj:= A_LoopField
		if instr(A_LoopField,A_Space)
			{
				Loop,parse,SPCFIX,|
					{
						stringreplace,rgg,rgj,%A_Space%,%A_LoopField%,All
						gosub,RlsGrpRoll
						if (hh = 1)
							{
								break
							}
					}
				stringreplace,rgg,rgj,%A_SPace%,,,All	
				if (hh = 1)
					{
						break
					}
			}
		gosub,RlsGrpRoll			
		if (hh = 1)
			{
				break
			}
	}
stringlen,njlen,njname
stringreplace,njname,njname,_,%A_Space%,All
stringreplace,njname,njname,%A_Space%%A_Space%,%A_Space%,All
njnameX= %njname%
if (nameOverride <> "")
	{
		stringreplace,njns,njname,.,%A_Space%,All
		njnamex := RegExReplace(njns, "[^A-Z\s]\K([A-Z])", " $1",aoa)
		r:= "" . njnamex . ""
		var := r, njabrv := ""
		Loop, Parse, var, %A_Space%
			{
				njabrv := njabrv SubStr(A_LoopField, "1", "1")
			}		
		stringlen,njabrl,njabrv	
		if ((aoa >= 3) && (aoa > njabrl))
			{
				njname:= njnameX				
			}
	}
	else {
		r:= "" . njnamex . ""
		njns= %njnamex%
		var := r, njabrv := ""
		Loop, Parse, var, %A_Space%
			{
				njabrv := njabrv SubStr(A_LoopField, "1", "1")
			}		
		stringlen,njabrl,njabrv	
	}
stringright,frng,njns,1
if instr(fringe,frng)
	{
		stringtrimright,njns,njns,1
		njns= %njns%
	}

str= %njname%
StrReplace(str, A_Space,, scnt)
str= %njname%
StrReplace(str, ".",, ncnt)
clpc:= ncnt + scnt
stringlen,kinm,str			
kivm:= (3 . ncnt ) + 1 
if ((clpc > njabrl) or (kinm > clpc) && (njabrl < kinm))
	{
		stringreplace,njname,njname,.,%A_Space%,All
		stringreplace,njname,njname,%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%,%A_Space%,All
		stringreplace,njname,njname,%A_Space%%A_Space%%A_Space%%A_Space%,%A_Space%,All
		stringreplace,njname,njname,%A_Space%%A_Space%%A_Space%,%A_Space%,All
		stringreplace,njname,njname,%A_Space%%A_Space%,%A_Space%,All
		njname= %njname%
	}
excn=|%njname%|
stringreplace,excn,excn,%A_Space%,,All
stringreplace,excn,excn,-,,All
stringreplace,excn,excn,.,,All
stringreplace,excn,excn,_,,All

stringleft,rlschkn,njname,7
stringleft,dplychkn,njname,6
stringleft,winochkn,njname,5
stringleft,winychkn,njname,4
stringleft,winvchkn,njname,3
if ((rlschkn = "windows")or (rlschkn = "release")or (dplychkn = "deploy")or(dplychkn = "winx86")or(dplychkn = "vista")or(dplychkn = "winx64")or (winochkn = "win32")or(winochkn = "win64")or(winochkn = "win10")or(winochkn = "win95")or(winochkn = "win2k")or(winochkn = "winxp")or(winychkn = "win7")or(winychkn = "win8")or(winvchkn = "x86")or(winvchkn = "x64"))
	{
		splitpath,exepN,excn,jik,,njname										
		if instr(exepN,".")
			{
				excn= %njname%
				njname= %excn%
			}
		exepN= %jik%
		goto, redux
	}
stringsplit,njtest,njname,(
if (njtest2 <> "")
	{
		njname= %njtest1%
	}
stringsplit,njtest,njname,[
if (njtest2 <> "")
	{
		njname= %njtest1%
	}
invar= %njname%
gosub, stripvar
exedp= %invarx%
stringtrimright,frng,njame,1
stringreplace,exedp,njname,.,,All
stringreplace,exedp,exedp,%A_SPace%,,All
stringreplace,exedp,exedp,(,,All
stringreplace,exedp,exedp,),,All
stringreplace,exedp,exedp,-,,All
stringreplace,exedp,exedp,[,,All
stringreplace,exedp,exedp,],,All
stringreplace,exedp,exedp,{,,All
stringreplace,exedp,exedp,},,All
stringreplace,exedp,exedp,`,,All
stringreplace,exedp,exedp,+,,All
stringreplace,exedp,exedp,',,All
stringreplace,exedp,exedp,!,,All
stringreplace,exedp,exedp,&,and,All
stringreplace,exedp,exedp,$,,All
stringreplace,exedp,exedp,`%,,All
stringreplace,exedp,exedp,@,,All
stringreplace,exedp,exedp,;,,All
stringreplace,exedp,exedp,~,,All
stringreplace,exedp,exedp,#,,All
stringreplace,exedp,exedp,_,,All
stringlen,exelen,exedp
bexp:= "|" . exedp . "|"
xenjx:= "|" . njname . "|"
snov:= ""
spechar:= ""
SPZ:= 0
SPZa:= "|" . 0 . "|"
if (instr(Nsivk,bexp) or instr(Nsivk,xenjx))
	{
		njx:= "|" . njnamex . "|"
		njj:= "|" . njns . "|"
		Loop,parse,Nsivk,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				stringsplit,bei,A_LoopField,|
				if ((instr(A_LoopField,xenjx) or instr(A_LoopField,njx)or instr(A_LoopField,njj) or ((bei3 = exedp)&&(exelen >= 7)) && instr(A_LoopField,bexp)))
					{
						njName:= bei2
						snov:= A_LoopField
						SPZa:= "|" . bei4 . "|"
						SPZ:= bei4
						loop,parse,snov,`
							   {
								   Transform,B2,ASC,%A_LOOPFIELD%
								   bf:= "|" . b2 . "|"
									if ((b2>47) and (b2<58)) or ((b2>64) and (b2<91)) or ((b2>96) and (b2<123)) or (instr(ptyx,bf))
										 {
											continue
										 }
										 else {
											spechar:= 1
											break
										 }
							   }
						if (spechar <> 1)
							{
								break
							}
					}
			}
	}

if (snov = "")
	{
		invar:= filtn
		gosub, stripvar
		nbv= %invarx%
		if (instr(Nsivk,xenjx)&&(exedp <> "")&&(exelen > 2))
			{
				Loop,parse,Nsivk,`n`r
					{
						if (A_LoopField = "")
							{
								continue
							}
						stringsplit,bei,A_LoopField,|
						if ((bei2 = exedp) or (bei3 = exedp) or (bei5 = njname) or (bei2 = njname) && instr(A_LoopField,nbv))
							{
								njName:= bei2
								snov:= A_LoopField
								SPZa:= "|" . bei4 . "|"
								SPZ:= bei4
								loop,parse,snov,`
								   {
									   Transform,B2,ASC,%A_LOOPFIELD%
									   bf:= "|" . b2 . "|"
										if ((b2>47) and (b2<58)) or ((b2>64) and (b2<91)) or ((b2>96) and (b2<123)) or (instr(ptyx,bf))
											 {
												continue
											 }
											 else {
												spechar:= 1
												break
											 }
								   }
						if (spechar <> 1)
							{
								break
							}
						}	
					}
			}
	}
Loop,parse,RLSPFX,|
	{
		stringright,tbb,njname,1
		if (tbb = A_LoopField)
			{
				stringtrimright,njname,njname,1
			}
	}
return

Localize:
gui,submit,NoHide
guicontrolget,localize,,localize
if (localize = 1)
	{
		Guicontrol,disable,Game_ProfB
		return
	}
Guicontrol,enable,Game_ProfB
return

Hide_Taskbar:
gui,submit,nohide
iniwrite,%Hide_Taskbar%,%RJDBINI%,GENERAL,Hide_Taskbar
return
ResetButs:
gui,submit,nohide
goto,%butrclick%Reset
return
DisableButs:
goto,%butrclick%Disable
return
DeleteButs:
goto,%butrclick%Delete
return

PPDownload:
Menu,addonp,Add
Menu,addonp,DeleteAll
if (butrclick = "PREAPP")
	{
		Menu,addonp, Add,soundVolumeView,SNDVOLVIEWDOWNLOAD
	}
if (butrclick = "POSTAPP")
	{
		Menu,addonp, Add,soundVolumeView,SNDVOLVIEWDOWNLOAD											  
	}
Menu,addonp,show
return

MMDownload:
curemote= _MultiMonitorTool_
gosub, BINGETS
gosub, DOWNLOADIT
MultiMonitor_ToolT= %binhome%\multimonitortool.exe
gosub, MM_ToolB
dchk:= ""
SB_SetText("")
return

BGM_ProgBDownload:
curemote= _BorderlessGaming_
gosub, BINGETS
gosub, DOWNLOADIT
Borderless_Gaming_Program= %binhome%\Borderless Gaming\borderless-gaming-portable.exe
Borderless_Gaming_ProgramT= %Borderless_Gaming_Program%
if !fileexist(Borderless_Gaming_Program)
	{
		Borderless_Gaming_Program:= ""
		Borderless_Gaming_ProgramT:= ""
	}
gosub, BGM_ProgB
dchk:= ""
SB_SetText("")
return

SNDVOLVIEWDOWNLOAD:
curemote:= "_SoundVolumeView_"
gosub, BINGETS
gosub, DOWNLOADIT
flflt:= binhome
if (butrclick = "PREAPP")
	{
		gosub, PREAPP
	}
if (butrclick = "POSTAPP")
	{
		gosub, POSTAPP
	}
dchk:= ""
SB_SetText("")
prerc:= ""
bgmrc:= ""
mmtrc:= ""
postrc:= ""
kbmrc:= ""
return

PreCloud:
KXM=PREDD
guicontrolget,PWait,,PreWait
guicontrolget,PPNUM,,PRETNUM
PPRY:= "Pre"
ebe:= PPNUM . ">"
if (PWait = 1)
	{
		ebe:= PPNUM . "W>"
	}
goto, CloudAquire

PostCloud:
KXM:= "POSTDD"
guicontrolget,PWait,,PostWait
guicontrolget,PPNUM,,POSTDNUM
PPRY:= "Post"
ebe:= PPNUM . ">" 
if (PWait = 1)
	{
		ebe:= PPNUM . "W>"
	}
goto, CloudAquire

CloudAquire:

CLDBCKT:= ""
FileSelectFolder,CLDBCKT,Cloud Directory,3,Select Cloud-Backup-Folder
if ((CLDBCKT = "")or !fileexist(CLDBCKT))
	{
		SB_SetText("No Cloud-Backup-Folder Selected")
		return
	}
CLDBCK:= CLDBCKT	
KMT:= KXM . "T"
iniwrite,%CLDBCKT%,%RJDBINI%,GENERAL,Cloud_Drive
iniwrite,%ebe%CLOUD,%RJDBINI%,CONFIG,%PPNUM%_%PPRY%
dchk:= ""
return



KBMDownload:
Menu,dwnlbmn,Add
Menu,dwnlbmn,DeleteAll
Loop,parse,MAPCFGS,|
	{
		Menu,dwnlbmn,Add,%A_LoopField%,keymapdownload
	}
Menu,dwnlbmn,show
return

MMToolBDownload:
Menu,dwnlbmn,Add
Menu,dwnlbmn,DeleteAll
Menu,dwnlbmn,Add,MultiMonitorTool,MMdownload
Menu,dwnlbmn,show
return


BGMDownload:
Menu,dwnlbmn,Add
Menu,dwnlbmn,DeleteAll
Menu,dwnlbmn,Add,BorderlessGaming,BGM_ProgBDownload
Menu,dwnlbmn,show
return


keymapdownload:
curemote:= "_" . A_ThisMenuItem . "_"
gosub, BINGETS
gosub, DOWNLOADIT
gosub, INIT%A_ThisMenuItem%
jkfn:= % (%A_ThisMenuItem%_executable)
jkAB:= "|" . jkfn . "|"
if fileexist(jkfn)
	{
		if !instr(SWAPMAPR,jkAB)
			{
				SWAPMAPR.= A_ThisMenuItem . "|"
			}
	}
SB_SetText("")
dchk:= ""
return


THEMEN:
gui,submit,nohide
guicontrolget,themen,,THEMEN
if (themen = "Default")
	{
		iniwrite,Default,%RJDBINI%,THEME,GUI_theme_name
		iniwrite,Default,%RJDBINI%,THEME,GUI_background
		iniwrite,Default,%RJDBINI%,THEME,GUI_foreground
		iniwrite,s11,%RJDBINI%,THEME,GUI_font_large
		iniwrite,s9,%RJDBINI%,THEME,GUI_font_medium
		iniwrite,s7,%RJDBINI%,THEME,GUI_font_small
		iniwrite,Default,%RJDBINI%,THEME,GUI_font_color
		iniwrite,%A_Space%,%RJDBINI%,THEME,GUI_font_name
		SB_SetText("Theme change requires restart")
		return
	}
if (themen = "Gray")
	{
		iniwrite,Dark,%RJDBINI%,THEME,GUI_theme_name
		iniwrite,Gray,%RJDBINI%,THEME,GUI_background
		iniwrite,White,%RJDBINI%,THEME,GUI_foreground
		iniwrite,s11,%RJDBINI%,THEME,GUI_font_large
		iniwrite,s9,%RJDBINI%,THEME,GUI_font_medium
		iniwrite,s7,%RJDBINI%,THEME,GUI_font_small
		iniwrite,cWhite,%RJDBINI%,THEME,GUI_font_color
		;;iniwrite,Segoe UI,%RJDBINI%,THEME,GUI_font_name
		SB_SetText("Theme change requires restart")
		return
	}
if (themen = "Black")
	{
		iniwrite,Dark,%RJDBINI%,THEME,GUI_theme_name
		iniwrite,Black,%RJDBINI%,THEME,GUI_background
		iniwrite,White,%RJDBINI%,THEME,GUI_foreground
		iniwrite,s11,%RJDBINI%,THEME,GUI_font_large
		iniwrite,s9,%RJDBINI%,THEME,GUI_font_medium
		iniwrite,s7,%RJDBINI%,THEME,GUI_font_small
		iniwrite,cWhite,%RJDBINI%,THEME,GUI_font_color
		;;iniwrite,Segoe UI,%RJDBINI%,THEME,GUI_font_name
		SB_SetText("Theme change requires restart")
		return
	}
if (themen = "White")
	{
		iniwrite,White,%RJDBINI%,THEME,GUI_theme_name
		iniwrite,White,%RJDBINI%,THEME,GUI_background
		iniwrite,Black,%RJDBINI%,THEME,GUI_foreground
		iniwrite,s11,%RJDBINI%,THEME,GUI_font_large
		iniwrite,s9,%RJDBINI%,THEME,GUI_font_medium
		iniwrite,s7,%RJDBINI%,THEME,GUI_font_small
		iniwrite,cBlack,%RJDBINI%,THEME,GUI_font_color
		;;iniwrite,Palatino Linotype,%RJDBINI%,THEME,GUI_font_name
		SB_SetText("Theme change requires restart")
		return
	}
if (themen = "Blue")
	{
		iniwrite,Blue,%RJDBINI%,THEME,GUI_theme_name
		iniwrite,0000FF,%RJDBINI%,THEME,GUI_background
		iniwrite,FFFFFF,%RJDBINI%,THEME,GUI_foreground
		iniwrite,s11,%RJDBINI%,THEME,GUI_font_large
		iniwrite,s9,%RJDBINI%,THEME,GUI_font_medium
		iniwrite,s7,%RJDBINI%,THEME,GUI_font_smallf
		iniwrite,cWhite,%RJDBINI%,THEME,GUI_font_color
		;;iniwrite,MS Serif,%RJDBINI%,THEME,GUI_font_name
		SB_SetText("Theme change requires restart")
		return
	}
return


UpdateRJLR:
curemote= originalBinary
gosub, BINGETS
UPDATING= 1
gosub, DOWNLOADIT
UPDATING:= ""
ifexist,%save%
	{
		Process, close, jkvtx.exe
		Process, close, Update.exe
		Process, close, Source_Builder.exe
		Process, close, NewOSK.exe
		Process, close, lrdeploy.exe
		FileCopy, %binhome%\Update.exe, %A_Temp%
		Run, "%A_Temp%\Update.exe" "%save%"
		Process, close, Setup.exe
		exitapp
	}
SB_SetText("Update file not found")
return

JAL_RC:
jalrc:= 1
butrclick:= "JAL_ProgB"
Menu,JAL_RCMenu,Show,x53 y512
return

JBE_RC:
jberc:= 1
butrclick:= "JBE_ProgB"
Menu,JBE_RCMenu,Show,x53 y512
return

BGM_RC:
bgmrc:= 1
butrclick:= "BGM_ProgB"
Menu,BGM_RCMenu,Show,x53 y448
return

MMT_RC:
butrclick:= "MM_ToolB"
mmtrc:= 12801
Menu,MM_RCMenu,Show,x53 y416
return

PRE_RC:
butrclick:= "PREAPP"
prerc:= 1
guicontrolget,PPNUM,,PREDNUM
vikb:= % (%PPNUM%_Pre)
Menu,PP_RCMenu,Delete
Menu,PP_RCMenu,Add,Download,PPDownload
Menu,PP_RCMenu,Add,,
Menu,PP_RCMenu,Add,Cloud_Backup,PreCloud
Menu,PP_RCMenu,Add,,
if (fileexist(binhome . "\" . "SoundVolumeView.exe")or instr(vikb,"SoundVolumeView.exe"))
	{
		Menu,PP_RCMenu,Add,SoundVolumeView,SVV_Prog
	}
Menu,PP_RCMenu,Show,%MENU_X% %MENU_Y%
return

Menu,PP_RCMenu,Show,x52 y576
return

POST_RC:
butrclick:= "POSTAPP"
postrc:= 1
guicontrolget,PPNUM,,POSTDNUM
vikb:= % (%PPNUM%_Post)
Menu,PP_RCMenu,Delete
Menu,PP_RCMenu,Add,Download,PPDownload
Menu,PP_RCMenu,Add,,
Menu,PP_RCMenu,Add,Cloud_Backup,PostCloud
Menu,PP_RCMenu,Add,,
if (fileexist(binhome . "\" . "SoundVolumeView.exe")or instr(vikb,"SoundVolumeView.exe"))
	{
		Menu,PP_RCMenu,Add,SoundVolumeView,SVV_Prog
	}
Menu,PP_RCMenu,Show,%MENU_X% %MENU_Y%
return


KBM_RC:
butrclick:= "Keyboard_MapB"
kbmrc:= 1
Menu,KBM_RCMenu,Show, x52 y224
return

ResetMprs:
Loop,parse,MAPCFGS,|
	{
		abb:= % %A_LoopField%_executable
		if fileexist(abb)
			{
				menu,keycfgm,Add,%A_LoopField%,INIT%A_LOOPFIELD%
			}
	}
menu,keycfgm,Show
return


Menu,dwnlbmn,show
prerc:= ""
jalrc:= ""
jberc:= ""
bgmrc:= ""
mmtrc:= ""
postrc:= ""
kbmrc:= ""
;goto,%butrclick%Download
return


ButtonClear:
if (srcntot > 25)
	{
		Msgbox,8449,Confirm,You are about to clear an item list of`n     %srcntot% games.`nAre you sure?
		ifmsgbox,Ok
			{
				goto, CLRLIST
			}
		return	
	}
CLRLIST:	
LV_Delete()
SOURCEDLIST:= ""
fileDelete,%SRCFILE%
guicontrol,show,REINDEX
return

MyListView:
Gui,ListView,MyListView
FocusedRowNumber := LV_GetNext(0, "F")
if (popui = 1)
	{
		return
	}
chkrepl:= ""
chktest:= % (%A_EventInfo%SDL)
RPL:= ""
vavn:= ""
Blockinput, on
if ((!FocusedRowNumber)&& instr(A_GuiEvent,"ColClick"))
	{
		Critical 
		RowNumber:= 0 ; This causes the first loop iteration to start the search at the top of the list.
		SOURCEDLIST:= ""
		Loop
			{
				RowNumber := LV_GetNext()           ;get first selected row
				RowChecked := LV_GetNext(RowNumber - 1 , "Checked" )
				If ( RowNumber = RowChecked )
				   SO:= "|`n"
				Else
				   SO:= "|?`n"
				RowNumber := LV_GetNext(RowNumber) ; Resume the search at the row after that found by the previous iteration.
				if not RowNumber ; The above returned zero, so there are no more selected rows.
				break
				vavn+=1
				chktest:= % (%A_EventInfo%SDL)
				LV_GetText(alla , RowNumber , 1)
				LV_GetText(allb , RowNumber , 2)
				LV_GetText(allc , RowNumber , 3)
				LV_GetText(alld , RowNumber , 4)
				LV_GetText(alle , RowNumber , 5)
				LV_GetText(allf , RowNumber , 6)
				LV_GetText(allg , RowNumber , 7)
				LV_GetText(allh , RowNumber , 8)
				LV_GetText(alli , RowNumber , 9)
				LV_GetText(allj , RowNumber , 10)
				LV_GetText(allk , RowNumber , 11)
				LV_GetText(alll , RowNumber , 12)
				LV_GetText(allm , RowNumber , 13)
				LV_GetText(alln , RowNumber , 14)
				LV_GetText(allo , RowNumber , 15)
				LV_GetText(allp , RowNumber , 16)
				LV_GetText(allq , RowNumber , 17)
				LV_GetText(allr , RowNumber , 18)
				prmv:= alla . "|" . allb . "|" . allc . "|" . alld . "|" . alle . "|" . allf . "|" . allg . "|" . allh . "|" . alli . "|" . allj . "|" . allk . "|" . alll . "|" . allm . "|" . alln . "|" . allo . "|" . allp . "|" . allq . "|" . allr
				%vavn%SDL:= prmv . SO
				SOURCEDLIST.= prmv . SO
			}				
		filedelete,%SRCFILE%
		fileappend,%SOURCEDLIST%,%SRCFILE%,UTF-8
		chktest:= % (%A_EventInfo%SDL)
	}
stringright,chkq,chktest,1
StringCaseSense, On
if (A_GuiEvent == "I")
	{
		if InStr(ErrorLevel, "C", true)
			{
				SPENB:= "+Check"
				if (chkq = "?")
					SPENQ:= "|"
				stringreplace,chkrepl,chktest,?,,All
				stringreplace,chkrepl,chkrepl,`n,,All
				stringreplace,chkrepl,chkrepl,`r,,All
			}
		else 
			{
				SPENB:= ""
				if (chkq = "?")
					SPENQ:= "?"
				stringreplace,chkrepl,chktest,?,,All
				stringreplace,chkrepl,chkrepl,`n,,All
				stringreplace,chkrepl,chkrepl,`r,,All
				chkrepl.= "?"
			}
		if (SPENQ <> chkq)
			{
				stringreplace,NSOURCEDLIST,SOURCEDLIST,%chktest%,%chkrepl%,All
				filedelete,%SRCFILE%
				fileappend,%NSOURCEDLIST%,%SRCFILE%,UTF-8
				%A_EventInfo%SDL:= chkrepl
				SOURCEDLIST:= NSOURCEDLIST
				StringCaseSense, Off
				blockinput,off
				popui:= ""
				return
			}
	}

StringCaseSense, Off	
Msx:= ""
If (A_GuiEvent == "F") {
   If (ICELV1["Changed"]) { 
      For I, O In ICELV1.Changed
		{
			if (msx = "")
				{
					Msx := "" . "Row " . O.Row . " - Column " . O.Col . " : " . O.Txt	
				}
		}
	  
	  ToolTip, % "Changes in " . A_GuiControl . "`r`n`r`n" . Msx
      SetTimer, KillToolTip, 2000
	  
      ICELV1.Remove("Changed")
		OnTxt:= O.Txt
		OnCol:= O.Col
		OVnV:= % (FocusedRowNumber . "SDL")
		rpl:= % (%OVnV%)
		stringsplit,baj,rpl,|
		replRw:= ""
		Loop,%baj0%
			{
				bax:= baj%A_Index%
				if (bax = "")
					{
						bax=""
					}
				replRw.= bax . ","
			}
		stringtrimright,ReplRw,ReplRw,1	
		redo:= % baj%OnCol%
 }
  if ((OnCol = 6)or(OnCol = 10)or(OnCol = 13)or(OnCol = 14)or(OnCol = 15)or(OnCol = 16))
	{
		if ((OnTxt = "0") or (OnTxt = "1") or (OnTxt = "y") or (OnTxt = "n") or (OnTxt = "off") or (OnTxt = "on"))
			{
				goto, RECONT
			}
			else {
				LV_Modify(FocusedRowNumber,"" " Col" OnCol,redo)
				SB_SetText("Booleans Only: 0`,off`,n`,1`,on`,or y")
				popui:= ""
				blockinput,off
				return
			}
	}
  if ((OnCol = 3)or(OnCol = 4)or(OnCol = 7)or(OnCol = 8)or(OnCol = 9)or(OnCol = 11)or(OnCol = 13)or(OnCol = 14)or(OnCol = 12))
	{
		SB_SetText("input commands, paths, anything")
		goto, RECONT
	}
  if (OnCol = 5)
	{
		WinStrip:= OnTxt
		gosub, WinStrip
		OnTxt= %WinStrip%
		SB_SetText("input commands, paths, anything")
		goto, RECONT
	}
  if (OnCol = 17)
	{
		if ((OnTxt = "0") or (OnTxt = "y") or (OnTxt = "1") or (OnTxt = "5")  or (OnTxt = "6") or (OnTxt = "8") or (OnTxt = "9") or (OnTxt = "n"))
			{
				goto, RECONT
			}
		else {
				LV_Modify(FocusedRowNumber,"" " Col" OnCol,redo)
				SB_SetText("0 or N=off,1 or Y=on, 5=unused kill,8=exit kill, 9= all on")
				popui:= ""
				blockinput,off
				return
		}	
	}
  if (OnCol = 18)
	{
		if onTxt is digit
			{
				goto, RECONT
			}
		else {
				LV_Modify(FocusedRowNumber,"" SPENB " Col" OnCol,redo)
				SB_SetText("SteamID must be a number and only a number")
				popui:= ""
				return
		}	
	}
}
popui:= ""
blockinput,off
return

RECONT:
RRP:= ""
vavn:= ""
Loop,parse,rpl,|
	{
		vavn+=1	
		semat:= A_LoopField
		if (vavn = OnCol)
			{
				RRP.= OnTxt . "|"
				if (OnTxt = semat)
					{
						popui:= ""
						blockinput,off
						return
					}
				continue
			}
		RRP.= semat . "|"
		if (A_Index = 18)
			{
				break
			}
	}
if (SPENB <> "+Check")
	{
		RRP.= "?"
	}	
if (RRP <> rpl)
	{
		%FocusedRowNumber%SDL:= RRP
		stringreplace,SOURCEDLIST,SOURCEDLIST,%rpl%,%RRP%,All
		filedelete,%SRCFILE%
		fileappend,%SOURCEDLIST%,%SRCFILE%,UTF-8
	}
popui= 	
blockinput,off
return

steamappinfo:
URLFILE:= STEAMIDB . steamquery
jsave:= sidn . "\" . steamquery . ".json"
save:= jsave
dwnovwr:= "True"
if (!fileexist(jsave)&& (Net_Check = 1))
	{
		gosub, DWNCONFIRM
	}
if (!fileexist(jsave)&&(STMTRY < 4)&&(GLBTRY < 4))
	{
		STMTRY+=1
		goto, steamappinfo
	}
else {
	if ((STMTRY > 3)or(GLBTRY > 3))
		{
			SB_SetText("SteamPowered Data not found for " njName "")
			GLBTRY+=1
			return
		}
}	
Loop,read,%jsave%
	{
		if ((A_LoopReadLine = "")or(A_LoopReadLine = "`r")or(A_LoopReadLine = "`n")or(A_LoopReadLine = "`r`n")or(A_LoopReadLine = "`n`r"))
			{
				continue
			}
		if (instr(A_LoopReadLine,nosuc)&&(STMTRY < 4))
			{
				filedelete,%jsave%
				STMTRY+=1
				goto, steamappinfo
			}
		break	
	}

if (STMTRY > 3)
	{
		SB_SetText("SteamPowered Data not found for " njName "")
		GLBTRY+=1
		return
	}		
STEAMDBINFO:
if (PCGWTRY > 3)
	{
		GLBTRY+=1
		return
	}
if fileexist(jsave)
	{
		fileread,savesteam,%jsave%
		stringreplace,savesteam,savesteam,`,,`n,All
		stringreplace,savesteam,savesteam,[,`n,All
		stringreplace,savesteam,savesteam,],`n,All
		stringreplace,savesteam,savesteam,{,`n,All
		stringreplace,savesteam,savesteam,},`n,All
		Loop,parse,savesteam,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				stringleft,abk,A_LoopField,1
				if (abk <> qte)
					{
						CONTINUE
					}
				stringreplace,tlop,A_LoopField,",,All
				;"
				stringsplit,nvar,tlop,:
				if (nvar1 = "name")
					{
						GETPCGW:
						stringreplace,nvar2,nvar2,",,All	;"
						stringreplace,nvar2,nvar2,;,,All
						stringreplace,nvar2,nvar2,/,,All
						stringreplace,nvar2,nvar2,\,,All
						stringreplace,nvar2,nvar2,\/,-,All
						stringreplace,nvarz,nvar2,?,-,All
						stringreplace,nvarz,nvarZ,*,-,All
						stringreplace,nvarz,nvarZ,<,-,All
						stringreplace,nvarz,nvarZ,>,-,All
						stringreplace,pcgws,nvar2,%A_Space%,_,All
						stringreplace,pcgws,pcgws,*,`%2A,All
						stringreplace,pcgws,pcgws,<,`%3C,All
						stringreplace,pcgws,pcgws,>,`%3E,All
						stringreplace,pcgws,pcgws,?,`%3F,All
						stringreplace,pcgws,pcgws,+,`%2B,All
						stringreplace,pcgws,pcgws,=,`%3D,All
						stringreplace,pcgws,pcgws,&,`%26,All
						stringreplace,pcgws,pcgws,`%,`%25,All
						;cvturl:= uriEncode(nvar2)
						URLFILE:= PCGWURL . pcgws 
						hsave= %sidn%\%nvarz%.html
						save= %hsave%
						if ((PCGWTRY < 4)&&(Net_Check = 1))
							{
								dwnovwr=True
								if !fileexist(hsave)
									{
										gosub, DWNCONFIRM
										
									}
								if !fileExist(hsave)
									{
										PCGWTRY+=1
										sleep,2000
										goto, GETPCGW
									}
							}
						if fileExist(hsave)
							{
								gosub, READPCGW
							}
						if !fileExist(hsave)
							{
								PCGWTRY:= 4
							}
						if (PCGWTRY > 3)
							{
								GLBTRY+=1
								
								return
							}
						break
					}
			}
	}
return



DOWNLOADIT:
STEAMQUERY:= ""
extractloc:= binhome . "\" . xtractpath
if (redp = 1)
	{
		extractloc:= xtractpath
	}
extractlocf= "%extractloc%"
filecreateDir,%home%\downloaded
save:= home . "\downloaded\" . binarcf
splitpath,save,savefile,savepath,savextn
savef= "%save%"
compltdwn:= % curemote
if (fileexist(save)&& (compltdwn = 1))
	{
		Msgbox,260,Redownload,Download the %binarcf% file again?`noriginal will be renamed ".bak",3
		ifmsgbox,yes
			{
				gosub,DOWNBIN
			}
		if (dwnrej = "")
			{
				goto, EXTRACTING
			}
		dwnrej:= ""
	}
DOWNBIN:
SB_SetText("Downloading " "" binarcf "")

Loop,parse,GUIVARS,|
	{
		guicontrol,disable,%A_LoopField%
	}

DWNCONFIRM:
dwnrej:= ""
DownloadFile(URLFILE,save,dwnovwr,True)
dwnovwr=False
SB_SetText(" " binarcf " ""downloaded")
if (UPDATING = 1)
	{		
		Loop,parse,GUIVARS,|
			{
				guicontrol,enable,%A_LoopField%
			}
		return
	}

if ((STEAMQUERY <> "")&&(STEAMQUERY <> 0))
	{
		SB_SetText("")
		goto, STEAMDBINFO
		return 
	}
EXTRACTING:
ToolTip,
Sleep, 500
if (fileexist(save)&& !fileexist(exetfnd))
	{
		ToolTip, Extracting...
		if !fileexist(extractloc . "\")
			{
				FileCreateDir,%extractloc%
			}
		if (!fileexist(binhome . "\" . "7za.exe")&&(savextn <> "7z"))
			{
				Extract2Folder(savef,extractlocf)
			}
			else {
			if fileexist(binhome . "\" . "7za.exe")
				{
					RunWait,%binhome%\7za.exe x -y "%home%\downloaded\%binarcf%" -O"%extractloc%",%binhome%,hide
				}
				else {
					Msgbox,258,,7za.exe not found,Binary file 7za.exe is missing from`n%binhome%`n`nContinue?
					ifmsgbox,Abort
						{
							exitapp
						}
					if Msgbox,Retry
						{
							curemote= originalBinary
							xtractpath:= ""
							gosub, BINGETS
							goto, DOWNLOADIT
						}
				}
			}
		Tooltip,Extracted.
		dchk= 1
		if (rento <> "")
			{
				FileMoveDir,%extractloc%,%rento%,R
			}
		if (msi = 1)
			{
				RunWait, MSIEXEC /I "%extractloc%\%exetfndsp%" DIR="%renfrm%" INSTALLDIR="%renfrm%" INSTALLLOCATION="%renfrm%" APPDIR="%renfrm%" DEFAULTPATHC="%renfrm%" APPLICATIONFOLDER="%renfrm%" DIRECTORY="%renfrm%" TARGETDIR="%renfrm%" INSTALLFOLDER="%renfrm%" /quiet /passive /norestart,%extractloc%
			}
	}

Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
	}
	
Sleep, 500
ToolTip,
ifnotexist,%save%
	{
		msgbox,258,Download Failed,%binarcf% did not download.`nYou may select the location of support files later`n`nContinue?
		ifmsgbox,Abort
			{
				if (curemote = "originalBinary")
					{
						exitapp
					}
			}
		if Msgbox,Retry
			{
				goto, DOWNLOADIT
			}
	}
SB_SetText("")
return

BINGETS:
Loop,6,
	{
		URLNX%A_Index%:= ""
	}
renfrm:= ""
rento:= ""
iniread,URLFILESPLIT,%source%\repos.set,BINARIES,%curemote%
stringsplit,URLNX,URLFILESPLIT,|
URLFILE:= URLNX1
Splitpath,URLFILE,binarcf
exetfndsp:= URLNX2
xtractpath:= URLNX3
redp:= ""
if instr(xtractpath,"{temp}")
	{
		stringreplace,xtractpath,xtractpath,{temp},%home%\downloaded
		redp:= 1
	}
stringsplit,rensp,urlnx4,?
	
renfrm:= rensp1
stringreplace,renfrm,renfrm,{home},%home%,
rento:= rensp2
msi:= ""	
if instr(exetfndsp,".msi")
	{
		msi:= 1
	}
if (URLFILE = "") or (URLFILE = "ERROR")
	{
		URLFILE:= URLFILEX
	}
return

GuiContextMenu:
gui,submit,nohide
If A_GuiControlEvent RightClick
	{
	butrclick:= A_GuiControl
	MENU_X:= A_GuiX*(A_ScreenDPI/96)
	MENU_Y:= A_GuiY*(A_ScreenDPI/96)
	if A_GuiControl = RESET
		{
			Menu, UPDButton, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = Player1_TempB
		{
			Menu, Pl1_RCMenu, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = Player2_TempB
		{
			Menu, Pl2_RCMenu, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = MediaCenter_ProfB
		{
			Menu, MCP_RCMenu, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = MM_ToolB
		{
			Menu, MM_RCMenu, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = MM_Game_CfgB
		{
			Menu, MMCFG_RCMenu, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = MM_MediaCenter_CfgB
		{
			Menu, MDCFG_RCMenu, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = BGM_ProgB
		{
			Menu, BGM_RCMenu, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = Keyboard_MapB
		{
			Menu, KBM_RCMenu, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = POSTAPP
		{
			butrclick:= "POSTAPP"
			postrc:= 1
			guicontrolget,PPNUM,,POSTDNUM
			vikb:= % (%PPNUM%_Post)
			Menu,PP_RCMenu,Delete
			Menu,PP_RCMenu,Add,Download,PPDownload
			Menu,PP_RCMenu,Add,,
			Menu,PP_RCMenu,Add,Cloud_Backup,PostCloud
			Menu,PP_RCMenu,Add,,
			if (fileexist(binhome . "\" . "SoundVolumeView.exe")or instr(vikb,"SoundVolumeView.exe"))
				{
					Menu,PP_RCMenu,Add,SoundVolumeView,SNDVOLVIEWDOWNLOAD
				}
			Menu,PP_RCMenu,Show,%MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = PREAPP
		{
			butrclick=PREAPP
			prerc=1
			guicontrolget,PPNUM,,PREDNUM
			vikb:= % (%PPNUM%_Pre)
			Menu,PP_RCMenu,Delete
			Menu,PP_RCMenu,Add,Download,PPDownload
			Menu,PP_RCMenu,Add,,
			Menu,PP_RCMenu,Add,Cloud_Backup,PreCloud
			Menu,PP_RCMenu,Add,,
			if (fileexist(binhome . "\" . "SoundVolumeView.exe")or instr(vikb,"SoundVolumeView.exe"))
				{
					Menu,PP_RCMenu,Add,SoundVolumeView,SNDVOLVIEWDOWNLOAD
				}
			Menu,PP_RCMenu,Show,%MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = JBE_ProgB
		{
			Menu,JBE_RCMenu,Show,%MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = JAL_ProgB
		{
			Menu,JAL_RCMenu,Show,%MENU_X% %MENU_Y%
			return
		}
		
		
	if A_GuiControl = GAME_DirectoryT
			{
				Menu, PropLNC, Show, %MENU_X% %MENU_Y%
				return
			}
	if A_GuiControl = GAME_ProfilesT
			{
				Menu, PropPRO, Show, %MENU_X% %MENU_Y%
				return
			}
	if A_GuiControl = BGM_ProgB
			{
				Menu, MM_RCMenu, Show, %MENU_X% %MENU_Y%
				return
			}
	if A_GuiControl = NetChk
			{
				Menu, LookupDBCHK, Show, %MENU_X% %MENU_Y%
				return
			}			
	if A_GuiControl = Keyboard_MapperT
			{
				Menu, PROPKBL, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = Player1_TemplateT
			{
				Menu, PROPPl1, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = Player2_TemplateT
			{
				Menu, PROPPl2, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = MediaCenter_TemplateT
			{
				Menu, PROPMC, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = MM_Game_ConfigT
			{
				Menu, PROPGM, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = MM_MediaCenter_ConfigT
			{
				Menu, PROPDM, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = JustAfterLaunchT
			{
				Menu, PropJAL, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = JustBeforeExitT
			{
				Menu, PropJBE, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = PREDDT
			{
				Menu, PropPRE, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = POSTDDT
			{
				Menu, PropPST, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = Borderless_Gaming_ProgramT
			{
				Menu, PropBGE, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if A_GuiControl = MultiMonitor_ToolT
			{
				Menu, PropMMTE, Show, %MENU_X% %MENU_Y%
				return
			}							  
	if (A_GuiControl != "MyListView")
		return

																				 
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
}
return
ContextOpenGame:  
openum:= ""
Loop
	{
		FocusedRowNumber := LV_GetNext(0, "F") 
		if not FocusedRowNumber 
		   {
			continue
		   }
		 else {
			opnum+=1
			LV_GetText(nmFDir, FocusedRowNumber, 2)
			Run, Explorer "%nmFDir%", %nmfdir%,,
			break
			}
	}
return
ContextOpenFile:  
openum:= ""
Loop
	{
		FocusedRowNumber := LV_GetNext(0, "F") 
		if not FocusedRowNumber 
		   {
			continue
		   }
		 else {
				LV_GetText(nmFDir, FocusedRowNumber, 2)
				LV_GetText(nmovr, FocusedRowNumber, 5)
				LV_GetText(nmFName, FocusedRowNumber, 1)
				splitpath,nmfdir,nmfnm
				splitpath,nmfname,,,,nmfno
				explthf= %Game_Profiles%							
				if (fileExist(Game_Profiles . "\" . nmfno . "\"))
					{
						explthf= %Game_Profiles%\%nmfnm%							
					}
				if (fileExist(Game_Profiles . "\" . nmfnm . "\"))
					{
						explthf= %Game_Profiles%\%nmfnm%							
					}
				if ((nmovr <> "") && fileExist(Game_Profiles . "\" . nmOvr . "\"))
					{
						explthf= %Game_Profiles%\%nmOvr%
					}
				Run, Explorer "%explthf%", %nmfdir%,,
				break
			}
	}
return

ContextProperties: 
Loop
	{																				   
		FocusedRowNumber := LV_GetNext(0, "F") 
		if not FocusedRowNumber 
		   {
			continue
		   }
		 else {
				LV_GetText(nmFName, FocusedRowNumber, 1) 
				LV_GetText(nmFDir, FocusedRowNumber, 2)
				LV_GetText(nmOpt, FocusedRowNumber, 3)
				LV_GetText(nmArg, FocusedRowNumber, 4)

				LV_GetText(nmovr, FocusedRowNumber, 5)
				LV_GetText(kbmstat, FocusedRowNumber, 6)
				LV_GetText(pl1stat, FocusedRowNumber, 7)
				LV_GetText(pl2stat, FocusedRowNumber, 8)
				LV_GetText(mcpstat, FocusedRowNumber, 9)
				LV_GetText(mmtstat, FocusedRowNumber, 10)
				LV_GetText(gmsstat, FocusedRowNumber, 11)
				LV_GetText(dmsstat, FocusedRowNumber, 12)
				LV_GetText(jaltat, FocusedRowNumber, 13)
				LV_GetText(jbetat, FocusedRowNumber, 14)
				LV_GetText(prestat, FocusedRowNumber, 15)
				LV_GetText(pststat, FocusedRowNumber, 16)
				LV_GetText(bgmstat, FocusedRowNumber, 17)
				LV_GetText(stqstat, FocusedRowNumber, 18)
				LV_GetText(chkmode, FocusedRowNumber, 19)
				gosub, TOGITMLST
		 }  
	}
return
TOGITMLST:
if InStr(A_ThisMenuItem, "Open in Explorer") 
	{
		Run, Explorer `"%nmfDir%`"
	}

	else {
		if InStr(A_ThisMenuItem, "Toggle")
			{
				if instr(A_ThisMenuItem, "KBM")
					{
						if ((kmstat = "1")or(kmstat = "on")or(kmstat = "y"))
							{
								LV_Modify(FocusedRowNumber,"" " Col" OnCol,redo)
							}
					}
			}
	
														  
	} 
if ErrorLevel
    {
		;; MsgBox Could not perform requested action on "%FileDir%\%FileName%".
	}
return

DelProf:
gui,submit,nohide
Msgbox,8449,Confirm Delete,Are you sure you want to delete profiles?
ifmsgbox,ok
	{
		SB_SetText("Deleting Profiles")
		Loop,files,%Game_Profiles%\*,D
			{
				FileDelete,%A_LoopFIleFUllPath%
			}
		SB_SetText("Profiles Deleted")
	}
return

PropMMTE:
InterpXpnd= MultiMonitor_Tool
extrpa=T	
goto, EDITPV
PropKBCmdE:
InterpXpnd= Keyboard_Mapper
extrpa=T	
goto, EDITPV

PropPl1jpE:
InterpXpnd= Player1_Template
extrpa=T	
goto, EDITPV

PropPl2jpE:
InterpXpnd= Player2_Template
extrpa=T	
goto, EDITPV

PropMCjpE:
InterpXpnd= MediaCenter_Template
extrpa=T
goto, EDITPV

PropGMcfgE:
InterpXpnd= MM_Game_Config
extrpa=T
goto, EDITPV

PropDMcfgE:
InterpXpnd= MM_Mediacenter_Config
extrpa=T
goto, EDITPV

PropJALcE:
InterpXpnd= JustAfterLaunch
extrpa=T
goto, EDITPV

PropJBEcE:
InterpXpnd= JustAfterExit
extrpa=T
goto, EDITPV

PropPREcE:
InterpXpnd= PREDD
extrpa:= ""
goto, EDITPV

PropPSTcE:
InterpXpnd= POSTDD
extrpa:= ""
goto, EDITPV

PropLNCE:
InterpXpnd= Game_Directory
extrpa=T
goto, EDITPV

PropPROE:
InterpXpnd= Game_Profiles
extrpa=T
goto, EDITPV

PropBGEE:
InterpXpnd= Borderles_Gaming_Program
extrpa=T
goto, EDITPV

EDITPV:
PREPSTALRT= Lime
prtxb= 
epvsec= GENERAL
iniread,ExtrpExpnd,%RJDBINI%,%epvsec%,%InterpXpnd%
if (ExtrpExpnd = "ERROR")
	{
		epvsec= JOYSTICKS
		iniread,ExtrpExpnd,%RJDBINI%,%epvsec%,%InterpXpnd%
	}
if (ExtrpExpnd = "ERROR")
	{
		epvsec= CONFIG
		iniread,ExtrpExpnd,%RJDBINI%,%epvsec%,%InterpXpnd%
	}
if !fileExist(ExtrpExpnd)
	{
		PREPSTALRT= Red
	}
if ((InterpXpnd = "JustAfterLaunch")or(InterpXpnd = "JustBeforeExit"))
	{
		epvsec= CONFIG
		iniread,JUSTtmpx,%RJDBINI%,%epvsec%,%InterpXpnd%
		stringsplit,ah,JUSTtmpx,<
		ExtrpExpnd= %ah2%
		prtxb= %ah1%
	}
if ((InterpXpnd = "POSTDD")or(InterpXpnd = "PREDD"))
	{
		epvsec= CONFIG
		guicontrolget,pnum,,POSTDNUM
		InterpCCn= Post
		if instr(InterXpnds,"Pre")
			{
				InterpCCn= Pre
				guicontrolget,pnum,,PREDNUM
				InterpXpnd= %pnum%_%InterpCCn%
			}
		iniread,PPRS,%RJDBINI%,%epvsec%,%InterpXpnd%
		stringsplit,ah,PPRS,<
		ExtrpExpnd= %ah2%
		prtxb= %ah1%
		guicontrol,,%InterpXpnd%,%prtxb%%ExtrpExpnd%
		if !fileExist(ExtrpExpnd)
			{
				PREPSTALRT= Red
			}	
	}
if (ExtrpExpnd = "ERROR")
	{
		ExtrpExpnd= 
	}
Gui +LastFound +OwnDialogs +AlwaysOnTop
tooltip, !!!!!Incorrect Values may lead to program malfunction!!!!! 
InputBox, TRNSFERVAR, Invalid Paths will cause errors.,Enter the path for %InterpXpnd%,,520,300,,,Locale,,%ExtrpExpnd%
if (TRNSFERVAR <> "")
	{
		stringright,ablb,InterpXpnd,1
		if ((ablb = "\") or (ablb = "/"))
			{
				stringtrimright,InterpXpnd,InterpXpnd,1
			}
		Guicontrol,,%InterpXpnd%%extrpa%,%TRNSFERVAR%
		iniwrite,%prtxb%%TRNSFERVAR%,%RJDBINI%,%epvsec%,%InterpXpnd%
		guicontrol, +c%PREPSTALRT%, %InterpXpnd%%extrpa%
		guicontrol,,%InterpXpnd%%extrpa%,%prtxb%%ExtrpExpnd%
	}
if ((TRNSFERVAR = "disable")or (TRNSFERVAR = "disabled")or (TRNSFERVAR = "terminate")or (TRNSFERVAR = "frontend")or (TRNSFERVAR = "nothing")or(TRNSFERVAR = "del")or(TRNSFERVAR = "none")or(TRNSFERVAR = "delete")or(TRNSFERVAR = "*.*"))
	{
		if ((InterpXpnd = Player1_Template)or (InterpXpnd = Player2_Template)or (InterpXpnd = MediaCenter_Profile))
			{
				iniwrite,Disabled,%RJDBINI%,JOYSTICKS,%InterpXpnd%
				guicontrol, +cLime, %InterpXpnd%
				guicontrol,,%InterpXpnd%%extrpa%,DISABLED
			}			
	}
return

Pl1Reset:
InterpXpnd= %Player1_Template%
ExtrpExpnd=%home%\Player1.%mapper_extension%
Player1_Template=%home%\Player1.%mapper_extension%
FileDelete,%Player1_Template%
FileDelete,%home%\KBM.%mapper_extension%
goto, RESETPROFILES
Pl2Reset:
InterpXpnd= %Player2_Template%
ExtrpExpnd=%home%\Player2.%mapper_extension%
Player2_Template=%home%\Player2.%mapper_extension%
FileDelete,%Player2_Template%
goto, RESETPROFILES
MCPReset:
InterpXpnd= %MediaCenter_Template%
ExtrpExpnd=%home%\MediaCenter.%mapper_extension%
MediaCenter_Template=%home%\MediaCenter.%mapper_extension%
FileDelete,%MediaCenter_Template%
goto, RESETPROFILES

RESETPROFILES:
iniread,kbmpprt,%RJDBINI%,JOYSTICKS,Keyboard_Mapper
iniread,JMAP,%RJDBINI%,JOYSTICKS,JMAP
if (JMAP = "antimicro")
	{
		prf= am
	}
if (JMAP = "antimicrox")
	{
		prf= ax
	}
if (JMAP = "JoyXoff")
	{
		prf= ax
	}
if (JMAP = "Xpadder")
	{
		prf= xp
	}
if (JMAP = "Keysticks")
	{
		prf= ks
	}
if (JMAP = "Joy2Key")
	{
		prf= jk
	}
fileread,amcp,%source%\%prf%_GameTemplate.set
fileread,kbmamcp,%source%\%prf%_KBM_Template.set
fileread,amcd,%source%\%prf%_DeskTemplate.set
stringreplace,amks,amks,[KEYSTX],%kbmpprt%,All
stringreplace,amcb,amcb,[JOYXO],%kbmpprt%,All
stringreplace,amcb,amcb,[J2KEY],%kbmpprt%,All
stringreplace,amcb,amcb,[XPADR],%kbmpprt%,All
stringreplace,amcb,amcb,[AMICRX],%kbmpprt%,All
stringreplace,amcb,amcb,[AMICRO],%kbmpprt%,All
stringreplace,kbmamcp,kbmamcp,[NEWOSK],%osklok%,All
stringreplace,kbmamcp,kbmamcp,[AMICRX],%antimicrox_executable%,All
stringreplace,kbmamcp,kbmamcp,[AMICRO],%antimicro_executable%,All
stringreplace,amcp,amcp,[NEWOSK],%osklok%,All
stringreplace,amcp,amcp,[AMICRX],%antimicrox_executable%,All
stringreplace,amcp,amcp,[AMICRO],%antimicro_executable%,All
stringreplace,amcd,amcd,[NEWOSK],%osklok%,All
stringreplace,amcd,amcd,[AMICRX],%antimicrox_executable%,All
stringreplace,amcd,amcd,[AMICRO],%antimicro_executable%,All
if (InterpXpnd = MediaCenter_Profile)
	{
		FileAppend,%amcd%,%MediaCenter_Template%,UTF-8-RAW
	}
if (InterpXpnd = Player1_Template)
	{
		FileAppend,%amcp%,%Player1_Template%,UTF-8-RAW
		FileAppend,%kbmamcp%,KBM.%mapper_extension%,UTF-8-RAW
	}
if (InterpXpnd = Player2_Template)
	{
		FileAppend,%amcp%,%Player2_Template%,UTF-8-RAW
	}
iniwrite,%ExtrpExpnd%,%RJDBINI%,JOYSTICKS,%InterpXpnd%
guicontrol, +cLime, %InterpXpnd%T
guicontrol,,%InterpXpnd%T,%ExtrpExpnd%
return

MMCFGDisable:
iniwrite,Disable,%RJDBINI%,CONFIG,MM_Game_Config
guicontrol, +cLime, MM_Game_ConfigT
guicontrol,,MM_Game_ConfigT,DISABLED
return

MDCFGDisable:
iniwrite,Disable,%RJDBINI%,CONFIG,MM_MediaCenter_Config
guicontrol, +cLime, MM_MediaCenter_ConfigT
guicontrol,,MM_MediaCenter_ConfigT,DISABLED
return

MDCFGReset:
if (MultiMonitor_Tool = "")
	{
		SB_SetText("Multimonitor Tool is not configured")
		return
	}
MM_MEDIACENTER_Config:= ""
MM_MEDIACENTER_ConfigT:= ""
iniwrite,%A_SPace%,%RJDBINI%,CONFIG,MM_Mediacenter_Config
gosub,MMSETUPD
return

MMCFGReset:
if (MultiMonitor_Tool = "")
	{
		SB_SetText("Multimonitor Tool is not configured")
		return
	}
MM_GAME_Config:= ""
MM_GAME_ConfigT:= ""
iniwrite,%A_SPace%,%RJDBINI%,CONFIG,MM_GAME_Config
gosub,MMPROG
return

Pl1Disable:
InterpXpnd= Player1_Template
goto, DISABLEPROFILE
Pl2Disable:
InterpXpnd= Player1_Template
goto, DISABLEPROFILE
MCPDisable:
InterpXpnd= MediaCenter_Template
goto, DISABLEPROFILE

DISABLEPROFILE:
iniwrite,Disabled,%RJDBINI%,JOYSTICKS,%InterpXpnd%
guicontrol, +cLime, %InterpXpnd%T
guicontrol,,%InterpXpnd%T,DISABLED
return

DelLaunch:
gui,submit,nohide
Msgbox,8449,Confirm Delete,Are you sure you want to delete launchers?
ifmsgbox,ok
	{
		SB_SetText("Deleting Launchers")
		Loop,files,%Game_Directory%\*.lnk,R
			{
				FileDelete,%A_LoopFIleFUllPath%
			}
		SB_SetText("Launchers Deleted")
	}
return

PropKBCmd:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles?
ifmsgbox, ok
	{
		if ((localize = 1)or(CenKBM = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}
				SB_SetText("...Propagating...")
		Loop,files,%Game_Profiles%\*,D
			{
				Filecopy,%keyboard_Mapper%,%A_LoopFileFullPath%,1
			}
				SB_SetText("Propagation Complete")
	}
return	
PropPl1jp:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles?
ifmsgbox, ok
	{
		if ((localize = 1)or(CenPL1 = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}
				SB_SetText("...Propagating...")
		Loop,files,%Game_Profiles%\*,D
			{
				Filecopy,%Player1_Template%,%A_LoopFileFullPath%\%A_loopFileName%.%mapper_extension%,1
			}
				SB_SetText("Propagation Complete")
	}
return	
PropPl2jp:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles?
ifmsgbox, ok
	{
		if ((localize = 1)or(CenPL2 = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}
				SB_SetText("...Propagating...")
		Loop,files,%Game_Profiles%\*,D
			{
				Filecopy,%Player2_Template%,%A_LoopFileFullPath%\%A_loopFileName%_2.%mapper_extension%,1
			}
				SB_SetText("Propagation Complete")
	}
return	
PropMCjp:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles?
ifmsgbox, ok
	{
		if ((localize = 1)or(CenMC = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}
		SB_SetText("...Propagating...")
		Loop,files,%Game_Profiles%\*,D
			{
				Filecopy,%MediaCenter_Template%,%A_LoopFileFullPath%,1
			}
		SB_SetText("Propagation Complete")
	}
return	
PropGMcfg:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles?
ifmsgbox, ok
	{
		if ((localize = 1)or(CenGM = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}
				SB_SetText("...Propagating...")
		Loop,files,%Game_Profiles%\*,D
			{
				Filecopy,%MM_Game_Config%,%A_LoopFileFullPath%,1
			}
		SB_SetText("Propagation Complete")
	}
return	
PropDMcfg:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles?
ifmsgbox, ok
	{
ifmsgbox, ok
	{
		if ((localize = 1)or(CenMM = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}
				SB_SetText("...Propagating...")
		Loop,files,%Game_Profiles%\*,D
			{
				Filecopy,%MM_Mediacenter_Config%,%A_LoopFileFullPath%,1
			}
		SB_SetText("Propagation Complete")
	}
	}
return	
PropJBEc:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles
ifmsgbox, ok
	{		
		if ((localize = 1)or(CenJBE = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}
		iniread,prln,%RJDBINI%,CONFIG,JustBeforeExit
		stringsplit,prlx,prln,>
		splitpath,prlx2,,,prxtn
		if ((prxtn = "cmd")or (prxtn = "bat")or (prxtn = "ps1")or (prxtn = "ps1")or (prxtn = "vbs")or (prxtn = "vbe") && (CenPRE <> 1))
			{
				SB_SetText("...Propagating...")
		Loop,files,%Game_Profiles%\*,D
			{
				Filecopy,%prlx2%,%A_LoopFileFullPath%,1
			}
				SB_SetText("Propagation Complete")
			}
	}
return	
PropJALc:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles?
ifmsgbox, ok
	{
		if ((localize = 1)or(CenJAL = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}
		iniread,prln,%RJDBINI%,CONFIG,JustAfterLaunch	
		stringsplit,prlx,prln,>
		splitpath,prlx2,,,prxtn
		if ((prxtn = "cmd")or (prxtn = "bat")or (prxtn = "ps1")or (prxtn = "ps1")or (prxtn = "vbs")or (prxtn = "vbe") && (CenPRE <> 1))
			{
										SB_SetText("...Propagating...")
		Loop,files,%Game_Profiles%\*,D
			{
				Filecopy,%prlx2%,%A_LoopFileFullPath%,1
			}
				SB_SetText("Propagation Complete")
			}
	}
return	
PropPREc:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles?
ifmsgbox, ok
	{		
		if ((localize = 1)or(CenPRE = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}		
		iniread,prln,%RJDBINI%,CONFIG,%PRETNUM%_Pre			
		stringsplit,prlx,prln,>
		splitpath,prlx2,,,prxtn
		if ((prxtn = "cmd")or (prxtn = "bat")or (prxtn = "ps1")or (prxtn = "ps1")or (prxtn = "vbs")or (prxtn = "vbe") && (CenPRE <> 1))
			{
						SB_SetText("...Propagating...")
				Loop,files,%Game_profiles%\*,D
					{
						FileCopy,%prlx2%,%A_LoopFIleFUllPath%,1
					}
						SB_SetText("Propagation Complete")
			}
	}
return	
PropPSTc:
Msgbox,8449,Confirm Propagate,Are you sure you want to propagate this to all profiles?
ifmsgbox, ok
	{
		if ((localize = 1)or(CenPST = 1))
			{
				SB_SetText("Propagation not supported for centralized items or localized profile folders")
				return
			}
		iniread,prln,%RJDBINI%,CONFIG,%POSTDNUM%_Post
		stringsplit,prlx,prln,>
		splitpath,prlx2,,,prxtn
		if ((prxtn = "cmd")or (prxtn = "bat")or (prxtn = "ps1")or (prxtn = "ps1")or (prxtn = "vbs")or (prxtn = "vbe") && (CenPRE <> 1))
			{
						SB_SetText("...Propagating...")
				Loop,files,%Game_profiles%\*,D
					{
						FileCopy,%prln%,%A_LoopFIleFUllPath%,%OVERWRT%
					}
						SB_SetText("Propagation Complete")
			}

	}
return	



AddCLI:
RowNumber := 0
clth:= ""
Loop
	{
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber
		{
		continue
		}
		else {
			LV_GetNext(RowNumber, Focused)
			LV_GetText(nmFName, RowNumber, 1) 
			LV_GetText(nmFDir, RowNumber, 2)
			LV_GetText(nmovr, RowNumber, 5)
			clth.= 	RowNumber . "|" . nmFDir . "\" . nmFName . "`n"
			gosub, ADCLIFUNC
		}
}
return
ADCLIFUNC:
Gui +LastFound +OwnDialogs +AlwaysOnTop
tooltip,Respected Expanded Variables`n{GameDir}: game's path`n{GameExe}: Game's Execuatable`n{ProfileDir}: Game's Jacket Dir`n`%programfiles`%:program files`n`%username`%`n`%username`%: user name`n`%temp`%: temp folder`nmore...
InputBox, CLIADDED, add opts and args,replace [variables] with options and arguments,,520,,,,,,[options] "{TARGET}" [arguments]
stringreplace,CLIADDED,CLIADDED,|,#!#,All
stringreplace,CLIADDED,CLIADDED,"{TARGET}",|,All
stringreplace,CLIADDED,CLIADDED,[options],,All
stringreplace,CLIADDED,CLIADDED,[arguments],,All
stringsplit,CLISPL,CLIADDED,|
clioptions= %CLISPL1%
cliargs= %CLISPL2%
cli_obj= 
Gui,ListView,MyListView
srcdlrpl:= ""
Loop,parse,clth,`n
	{
		if (A_LoopField = "")
			{
				continue
			}
		stringsplit,lsvs,A_LoopField,|
		rwnm:= lsvs1
		mdo= lsvs2
		mdo= lsvs3
		LV_Modify(lsvs1,"COL3", clioptions)
		LV_Modify(lsvs1,"COL4", cliargs)
		cli_obj.= A_LoopField . "|" . clioptions . "|" . cliargs . "`n"
		Loop,parse,SOURCEDLIST,`n
			{
				stringsplit,oab,A_LoopField,|
				splitpath,oab1,rpxe,rppth
				if ((rpxe = lsvs1)&&(rppth = mdo))
					{
						srcdlrpl:= rpxe . "|" . rppth . "|" . clioptions . "|" . cliargs . "|"
						Loop, %oab0%
							{
								if (A_Index < 5)
									{
										continue
									}
								au:= % oab%A_Index%
								if (au = "")
									{
										au:= A_Space
									}
								srcdlrpl.= au . "|"
							}
						stringreplace,srcdlrpl,srcdlrpl,|||,|,All
						stringreplace,srcdlrpl,srcdlrpl,||,|,All
						stringtrimright,srcdlrpl,srcdlrpl,1
						stringreplace,SOURCEDLIST,SOURCEDLIST,%A_LoopField%,%srcdlrpl%,
						break
					}
			}
	}
LV_ModifyCol()
filedelete,%SRCFILE%
fileappend,%SOURCEDLIST%,%SRCFILE%,UTF-8
Return

READPCGW:
fileread,pcgw,%hsave%
datve:= ""
DATV:= ""
pcgwin= 
GameData:= ""
SaveData:= ""
if (instr(pcgw,nopcgw)or instr(pcgw,pcgwbt)or instr(pcgw,pcgwbr) or instr(pcgw,patsup))
	{
		filedelete,%hsave%
		
		PCGWTRY+=1
		return
	}
GLBTRY:= 0
pcgwin:= ""
Loop,parse,pcgw,`r`n
	{
		if (A_LoopField = "")
			{
				continue
			}
		kng:= A_LoopField
		if instr(A_LoopField,trig1a)
			{
				trigR= %trig1a%
				DATV= SaveData
				pcgwin= 1
				continue
			}
		if instr(A_LoopField,trig1b)
				{
					trigR= %trig1b%
					DATV= GameData
					pcgwin= 1
					continue
				}
		if ((kng = "</tr>")&&(pcgwin = 2))
			{
				pcgwin= 1
				continue
			}
		if (instr(A_LoopField,TrigN)&&(pcgwin = 1))
			{
				sysline:= % RegExReplace(A_LoopField, "^(.*)" (trigN) "", "")
				stringreplace,sysline,sysline,`n,,All
				stringreplace,sysline,sysline,`r,,All
				alnin:= 0
				sysline= %sysline%
				stringsplit,syssplit,sysline,<
				Loop,%syssplit0%
					{
						rba:= % syssplit%A_Index%
						if (rba = "")
							{
								continue
							}
						alnin= +1	
						if (alnin > 5)
							{
								break
							}
						SystemType= %rba%
						if ((SystemType = "windows")or(SystemType = "Steam")or(SystemType = "Microsoft Store"))
							{
								pcgwin= 2
							}
						if (instr(SystemType,"MacOS")or instr(SystemType,"Linux"))
							{
								pcgwin= 1
								break	
							}
					}
				CONTINUE
			}
		if (pcgwin = 2)
			{
				apnd:= ""
				if (datve <> "")
					{
						apnd:= "|"
					}
				if instr(A_LoopField,TrigDATA)
					{			
						datve:= % %DATV%			
						infolin:= % RegExReplace(A_LoopField, "^(.*)" (TrigDATA) "", "")
						infolinx:= % RegExReplace(infolin,"" SupData "(.*)", "")
						stringreplace,infolin,infolinx,%REGIF%,,All
						stringreplace,infolin,infolin,%DBINF%,,All
						stringreplace,infolin,infolin,%STINF%,%steamdir%,All
						stringreplace,infolin,infolin,%PRINF%,%USRPRF%,All
						stringreplace,infolin,infolin,%UAINF%,%LADTA%,All
						stringreplace,infolin,infolin,%BSINF%,%outdir%,All
						stringreplace,infolin,infolin,%GSUIF%,%SteamUser%,All
						stringreplace,infolin,infolin,`n,,All
						stringreplace,infoline,infolin,`r,,All
						%DATV%.= apnd . infoline . "|"
					}
				continue	
			}
		if ((kng = "<br>") && (pcgwin = 2))	
			{
				%DATV%.= "|"
				continue
			}
		if instr(kng,trig3)
			{
				Loop,parse,repA,|
					{
						stringreplace,SaveData,SaveData,%A_LoopField%,,All
						stringreplace,GameData,GameData,%A_LoopField%,,All
					}
				stringreplace,SaveData,SaveData,<,,All
				stringreplace,SaveData,SaveData,>,,All
				stringreplace,SaveData,SaveData,`%LOCALAPPDATA`%,%LADTA%,All
				stringreplace,SaveData,SaveData,`%APPPDATA`%,%A_AppData%,All
				stringreplace,SaveData,SaveData,`%HOMEPATH`%,%USRPRF%,All
				stringreplace,SaveData,SaveData,`%USERPROFILE`%,%USRPRF%,All
				stringreplace,SaveData,SaveData,`%TMP`%,%A_Temp%,All
				stringreplace,SaveData,SaveData,`%TEMP`%,%A_Temp%,All
				stringreplace,SaveData,SaveData,`%USERNAME`%,%A_Username%,All
				stringreplace,SaveData,SaveData,`%PUBLIC`%,%PBLCFLDR%,All
				stringreplace,SaveData,SaveData,`%SYSTEM`%,%DRVSYSTM%,All
				stringreplace,SaveData,SaveData,`%ALLUSERSPROFILE`%,%PBLCFLDR%,All
				stringreplace,SaveData,SaveData,`%PROGRAMDATA`%,%A_AppDataCommon%,All
				stringreplace,SaveData,SaveData,`%PROGRAMFILES`%,%A_ProgramFiles%,All
				stringreplace,SaveData,SaveData,`%PROGRAMFILES(X86)`%,%xprgfls%,All

				stringreplace,GameData,GameData,<,,All
				stringreplace,GameData,GameData,>,,All
				stringreplace,GameData,GameData,`%LOCALAPPDATA`%,%LADTA%,All
				stringreplace,GameData,GameData,`%APPPDATA`%,%A_AppData%,All
				stringreplace,GameData,GameData,`%HOMEPATH`%,%USRPRF%,All
				stringreplace,GameData,GameData,`%USERPROFILE`%,%USRPRF%,All
				stringreplace,GameData,GameData,`%TMP`%,%A_Temp%,All
				stringreplace,GameData,GameData,`%TEMP`%,%A_Temp%,All
				stringreplace,GameData,GameData,`%USERNAME`%,%A_Username%,All
				stringreplace,GameData,GameData,`%PUBLIC`%,%PBLCFLDR%,All
				stringreplace,GameData,GameData,`%SYSTEM`%,%DRVSYSTM%,All
				stringreplace,GameData,GameData,`%ALLUSERSPROFILE`%,%PBLCFLDR%,All
				stringreplace,GameData,GameData,`%PROGRAMDATA`%,%A_AppDataCommon%,All
				stringreplace,GameData,GameData,`%PROGRAMFILES`%,%A_ProgramFiles%,All
				stringreplace,GameData,GameData,`%PROGRAMFILES(X86)`%,%xprgfls%,All
				iniwrite,%SaveData%,%gamecfg%,CONFIG,SaveData
				iniwrite,%gamedata%,%gamecfg%,CONFIG,GameData
				pcgwin:= ""
				break
			}
	}
return	
MakeMeTop:
tooltip,Respected Expanded Variables`n{GameDir}: game's path`n{GameExe}: Game's Execuatable`n{Profile}: Game's Jacket Dir`n`%programfiles`%:program files`n`%username`%`n`%username`%: user name`n`%temp`%: temp folder`nmore...
WinSet, AlwaysOnTop, On, add opts/args
Return

ContextClearRows:
RowNumber := 0 
Loop
	{				 
    RowNumber := LV_GetNext(RowNumber - 1)
    if not RowNumber 
        {
			break
		}
	LV_GetText(lnv,RowNumber)
    LV_Delete(RowNumber)  
	remvln:= % %RowNumber%SDL
	stringreplace,SOURCEDLIST,SOURCEDLIST,%remvln%,,
}
filedelete,%SRCFILE%
vavn:= ""
nsrcdl:= ""
Loop,parse,sourcedlist,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		Loop,19
			{
				rni%A_Index%:= ""
			}
		vavn+=1	
		%vavn%SDL:= A_LoopField
		nsrcdl:= A_LoopField
	}
subtrfm:= (srcntot	- vavn)
krnf:= vavn
Loop, %subtrfrm%
	{
		krnf+=1
		%krnf%SDL= ""
	}
srcntot:= vavn
SOURCEDLIST:= nsrcdl
fileappend,%SOURCEDLIST%,%SRCFILE%,UTF-8
return

LVGetCheckedItems(cN,wN) {
	noen= \|
    ControlGet, LVItems, List,, % cN, % wN
    Pos:=!Pos,Item:=Object()
    While Pos
        Pos:=RegExMatch(LVItems,"`am)(^.*?$)",_,Pos+StrLen(_)),mCnt:=A_Index-1,Item[mCnt]:=_1
    Loop % mCnt {
        SendMessage, 0x102c, A_Index-1, 0x2000, % cN, % wN
        ChekItems:=(ErrorLevel ? Item[A_Index-1] "`n" : "")
		stringsplit,dbb,ChekItems,%A_Tab%
		tstchki:= dbb1 . "|" . dbb2 . "|" . dbb3 . "|" . dbb4 . "|" . dbb5 . "|" . dbb6 . "|" . dbb7 . "|" . dbb8 . "|" . dbb9 . "|" . dbb10 . "|" . dbb11 . "|" . dbb12 . "|" . dbb13 . "|" . dbb14 . "|" . dbb15 . "|" . dbb16 . "|" . dbb17 . "|" . dbb18 . "|" . dbb19 . "`n"
		if !instr(ChkItems,tstchki)
			{
				ChkItems.= tstchki
			}
    }
	stringreplace,chkitems,chkitems,|||||||||||||||||,,All
	stringreplace,chkitems,chkitems,?%A_Space%,,All
    Return ChkItems
}

DownloadFile(UrlToFile, _SaveFileAs, Overwrite := True, UseProgressBar := True) {
	FinalSize:= ""

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
		if (FinalSize <> "")
			{
				prevsize:= finalsize
			}
			else {
				if (finalsize <= prevsize)
					{
						if (attmp > 3)
							{
								return
							}
						attmp+=1
					}	
				}
		try FinalSize := WebRequest.GetResponseHeader("Content-Length")
		catch {
			FinalSize := 1
		}
		SetTimer, DownloadFileFunction_UpdateProgressBar, 100
		if (CANCLD = 1)
			{
				return
			}

  }
  UrlDownloadToFile, %UrlToFile%, %_SaveFileAs%
If (UseProgressBar) {
	ToolTip,
  }

      DownloadFileFunction_UpdateProgressBar:

      try CurrentSize := FileOpen(_SaveFileAs, "r").Length
	  catch {
			}

      try CurrentSizeTick := A_TickCount
    catch {
			}
	kto:= A_TickCount
      try Speed := Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000)) . " Kb/s"
	  catch {
			}

      LastSizeTick := CurrentSizeTick
      try LastSize := FileOpen(_SaveFileAs, "r").Length
    catch {
			}

	ktov:= A_TickCount
      try PercentDone := Round(CurrentSize/FinalSize*100)
    catch {
			}
	if (LastSizeTick < CurrentSizeTick)
		{
			prctl:= percentDone
		}
	else {
		if (attmp > 3)
			{
				return
			}
		attmp+=1
	}	
	if (CANCLD = 1)
		{
			return
		}
	 if (PercentDone > 100)
		{
			ToolTip,
			PercentDone:= ""
		}
		
	 SB_SetText(" " Speed " at " PercentDone "`% " CurrentSize " bytes completed")
	
	 return
  }


Extract2Folder(Zip, Dest="", jhFln="")
{
    SplitPath, Zip,, SourceFolder
    if ! SourceFolder
        Zip := A_ScriptDir . "\" . Zip

    if ! Dest {
        SplitPath, Zip,, DestFolder,, Dest
        Dest := DestFolder . "\" . Dest . "\"
    }
    if SubStr(Dest, 0, 1) <> "\"
        Dest .= "\"
    SplitPath, Dest,,,,,DestDrive
    if ! DestDrive
        Dest := A_ScriptDir . "\" . Dest

    fso := ComObjCreate("Scripting.FileSystemObject")
    If Not fso.FolderExists(Dest)
		{
			fso.CreateFolder(Dest)
		}

    AppObj := ComObjCreate("Shell.Application")
    FolderObj := AppObj.Namespace(Zip)
    if jhFln {
        FileObj := FolderObj.ParseName(jhFln)
        AppObj.Namespace(Dest).CopyHere(FileObj, 4|16)
    }
    else
    {
        FolderItemsObj := FolderObj.Items()
        AppObj.Namespace(Dest).CopyHere(FolderItemsObj, 4|16)
    }
}
CmdRet(sCmd, callBackFuncObj := "", encoding := ""){
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
WM_MOUSEMOVE() {
	
	static CurrControl, PrevControl, _TT
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl)
		{
			SetTimer, DisplayToolTip, -300
			PrevControl := CurrControl
		}
	return

	DisplayToolTip:
	try
			ToolTip % %CurrControl%_TT
	catch
			ToolTip
	SetTimer, RemoveToolTip, -6000
	return

	RemoveToolTip:
	ToolTip
	return
}
																													
Class LV_InCellEdit {																						
    __New(HWND, HiddenCol1 := False, BlankSubItem := False, EditUserFunc := "") {
      If (This.Base.Base.__Class) 
         Return False
      If This.Attached[HWND] 
         Return False
      If !DllCall("IsWindow", "Ptr", HWND)
         Return False
      VarSetCapacity(Class, 512, 0)
      DllCall("GetClassName", "Ptr", HWND, "Str", Class, "Int", 256)
      If (Class <> "SysListView32") 
         Return False
      If (EditUserFunc <> "") && (Func(EditUserFunc).MaxParams < 6)
         Return False											 
      SendMessage, 0x1036, 0x010000, 0x010000, , % "ahk_id " . HWND
      This.HWND := HWND
      This.HEDIT := 0
      This.Item := -1
      This.SubItem := -1
      This.ItemText := ""
      This.RowCount := 0
      This.ColCount := 0
      This.Cancelled := False
      This.Next := False
      This.Skip0 := !!HiddenCol1
      This.Blank := !!BlankSubItem
      This.Critical := "Off"
      This.DW := 0
      This.EX := 0
      This.EY := 0
      This.EW := 0
      This.EH := 0
      This.LX := 0
      This.LY := 0
      This.LR := 0
      This.LW := 0
      This.SW := 0
      If (EditUserFunc <> "")
         This.EditUserFunc := Func(EditUserFunc)
      This.OnMessage()
      This.Attached[HWND] := True
   }
																														
   __Delete() {
      This.Attached.Remove(This.HWND, "")
      WinSet, Redraw, , % "ahk_id " . This.HWND
   }																										
   EditCell(Row, Col := 0) {
      If !This.HWND
         Return False
      ControlGet, Rows, List, Count, , % "ahk_id " . This.HWND
      This.RowCount := Rows - 1
      ControlGet, ColCount, List, Count Col, , % "ahk_id " . This.HWND
      This.ColCount := ColCount - 1
      If (Col = 0) {
         If (This["Columns"])
            Col := This.Columns.MinIndex() + 1
         ELse If This.Skip0
            Col := 2
         Else
            Col := 1
      }
      If (Row < 1) || (Row > Rows) || (Col < 1) || (Col > ColCount)
         Return False
      If (Column = 1) && This.Skip0
         Col := 2
      If (This["Columns"])
         If !This.Columns[Col - 1]
            Return False
      VarSetCapacity(LPARAM, 1024, 0)
      NumPut(Row - 1, LPARAM, (A_PtrSize * 3) + 0, "Int")
      NumPut(Col - 1, LPARAM, (A_PtrSize * 3) + 4, "Int")
      This.NM_DBLCLICK(&LPARAM)
      Return True
   }																											
   SetColumns(ColNumbers*) {
      If !This.HWND
         Return False
      This.Remove("Columns")
      If (ColNumbers.MinIndex() = "")
         Return True
      ControlGet, ColCount, List, Count Col, , % "ahk_id " . This.HWND
      Indices := []
      For Each, Col In ColNumbers {
         If Col Is Not Integer
            Return False
         If (Col < 1) || (Col > ColCount)
            Return False
         Indices[Col - 1] := True
      }
      This["Columns"] := Indices
      Return True
   }																									
    OnMessage(Apply := True) {
      If !This.HWND
         Return False
      If (Apply) && !This.HasKey("NotifyFunc") {
         This.NotifyFunc := ObjBindMethod(This, "On_WM_NOTIFY")
         OnMessage(0x004E, This.NotifyFunc)
      }
      Else If !(Apply) && This.HasKey("NotifyFunc") {
         OnMessage(0x004E, This.NotifyFunc, 0)
         This.NotifyFunc := ""
         This.Remove("NotifyFunc")
      }
      WinSet, Redraw, , % "ahk_id " . This.HWND
      Return True
   }																	
   Static Attached := {}
   Static OSVersion := DllCall("GetVersion", "UChar")														
   On_WM_COMMAND(W, L, M, H) {
																  
      Critical, % This.Critical
      If (L = This.HEDIT) {
         N := (W >> 16)
         If (N = 0x0400) || (N = 0x0300) || (N = 0x0100) { 
            If (N = 0x0100)
               SendMessage, 0x00D3, 0x01, 0, , % "ahk_id " . L
            ControlGetText, EditText, , % "ahk_id " . L
            SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % &EditText, , % "ahk_id " . This.HWND
            EW := ErrorLevel + This.DW
            , EX := This.EX
            , EY := This.EY
            , EH := This.EH + (This.OSVersion < 6 ? 3 : 0) 
            If (EW < This.MinW)
               EW := This.MinW
            If (EX + EW) > This.LR
               EW := This.LR - EX
            DllCall("SetWindowPos", "Ptr", L, "Ptr", 0, "Int", EX, "Int", EY, "Int", EW, "Int", EH, "UInt", 0x04)
            If (N = 0x0400) 
               Return 0
         }
      }
   }																				
   On_WM_HOTKEY(W, L, M, H) {
																	  
      If (H = This.HWND) {
         If (W = 0x801B) {
            This.Cancelled := True
            PostMessage, 0x10B3, 0, 0, , % "ahk_id " . H
         }
         Else {
            This.Next := True
            SendMessage, 0x10B3, 0, 0, , % "ahk_id " . H
            This.Next := True
            This.NextSubItem(W)
         }
         Return False
      }
   }																							
   On_WM_NOTIFY(W, L) {
      Critical, % This.Critical
      If (H := NumGet(L + 0, 0, "UPtr") = This.HWND) {
         M := NumGet(L + (A_PtrSize * 2), 0, "Int")
																														   
         If (M = -175) || (M = -105)
            Return This.LVN_BEGINLABELEDIT(L)
																														   
         If (M = -176) || (M = -106)
            Return This.LVN_ENDLABELEDIT(L)
																														   
         If (M = -3)
            This.NM_DBLCLICK(L)
      }
   }
																														
   LVN_BEGINLABELEDIT(L) {
      Static Indent := 4
      If (This.Item = -1) || (This.SubItem = -1)
         Return True
      H := This.HWND
      SendMessage, 0x1018, 0, 0, , % "ahk_id " . H 
      This.HEDIT := ErrorLevel
      , VarSetCapacity(ItemText, 2048, 0)
      , VarSetCapacity(LVITEM, 40 + (A_PtrSize * 5), 0)
      , NumPut(This.Item, LVITEM, 4, "Int")
      , NumPut(This.SubItem, LVITEM, 8, "Int")
      , NumPut(&ItemText, LVITEM, 16 + A_PtrSize, "Ptr")
      , NumPut(1024 + 1, LVITEM, 16 + (A_PtrSize * 2), "Int")
      SendMessage, % (A_IsUnicode ? 0x1073 : 0x102D), % This.Item, % &LVITEM, , % "ahk_id " . H ; LVM_GETITEMTEXT
      This.ItemText := StrGet(&ItemText, ErrorLevel)

									  
      If (This.EditUserFunc)
         This.EditUserFunc.Call("BEGIN", This.HWND, This.HEDIT, This.Item + 1, This.Subitem + 1, This.ItemText)
      SendMessage, 0x000C, 0, % &ItemText, , % "ahk_id " . This.HEDIT
      If (This.SubItem > 0) && (This.Blank) {
         Empty := ""
         , NumPut(&Empty, LVITEM, 16 + A_PtrSize, "Ptr") 
         , NumPut(0,LVITEM, 16 + (A_PtrSize * 2), "Int")
         SendMessage, % (A_IsUnicode ? 0x1074 : 0x102E), % This.Item, % &LVITEM, , % "ahk_id " . H ; LVM_SETITEMTEXT
      }
      VarSetCapacity(RECT, 16, 0)
      , NumPut(This.SubItem, RECT, 4, "Int")
      SendMessage, 0x1038, This.Item, &RECT, , % "ahk_id " . H 
      This.EX := NumGet(RECT, 0, "Int") + Indent
      , This.EY := NumGet(RECT, 4, "Int")
      If (This.OSVersion < 6)
         This.EY -= 1
      If (This.SubItem = 0) {
         SendMessage, 0x101D, 0, 0, , % "ahk_id " . H
         This.EW := ErrorLevel
      }
      Else
         This.EW := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
      This.EH := NumGet(RECT, 12, "Int") - NumGet(RECT, 4, "Int")
								   
      VarSetCapacity(LVCOL, 56, 0)
      , NumPut(1, LVCOL, "UInt")
      SendMessage, % (A_IsUnicode ? 0x105F : 0x1019), % This.SubItem, % &LVCOL, , % "ahk_id " . H
      If (NumGet(LVCOL, 4, "UInt") & 0x0002) {
         SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % &ItemText, , % "ahk_id " . This.HWND
         EW := ErrorLevel + This.DW
         If (EW < This.MinW)
            EW := This.MinW
         If (EW < This.EW)
            This.EX += ((This.EW - EW) // 2) - Indent
      }
								   
      This.CommandFunc := ObjBindMethod(This, "On_WM_COMMAND")
      , OnMessage(0x0111, This.CommandFunc)
						
      If !(This.Next)
         This.RegisterHotkeys()
      This.Cancelled := False
      This.Next := False
      Return False
   }
																														
   LVN_ENDLABELEDIT(L) {
      H := This.HWND
									 
      OnMessage(0x0111, This.CommandFunc, 0)
      This.CommandFunc := ""
						  
      If !(This.Next)
         This.RegisterHotkeys(False)
      ItemText := This.ItemText
      If !(This.Cancelled)
         ControlGetText, ItemText, , % "ahk_id " . This.HEDIT
      If (ItemText <> This.ItemText) {
         If !(This["Changed"])
            This.Changed := []
         This.Changed.Insert({Row: This.Item + 1, Col: This.SubItem + 1, Txt: ItemText})
      }
														
      If (ItemText <> This.ItemText) || ((This.SubItem > 0) && (This.Blank)) {
         VarSetCapacity(LVITEM, 40 + (A_PtrSize * 5), 0)
         , NumPut(This.Item, LVITEM, 4, "Int")
         , NumPut(This.SubItem, LVITEM, 8, "Int")
         , NumPut(&ItemText, LVITEM, 16 + A_PtrSize, "Ptr")
         SendMessage, % (A_IsUnicode ? 0x1074 : 0x102E), % This.Item, % &LVITEM, , % "ahk_id " . H
      }
      If !(This.Next)
         This.Item := This.SubItem := -1
      This.Cancelled := False
      This.Next := False
									  
      If (This.EditUserFunc)
         This.EditUserFunc.Call("END", This.HWND, This.HEDIT, This.Item + 1, This.Subitem + 1, ItemText)
      Return False
   }																												
   NM_DBLCLICK(L) {
      H := This.HWND
      This.Item := This.SubItem := -1
      Item := NumGet(L + (A_PtrSize * 3), 0, "Int")
      SubItem := NumGet(L + (A_PtrSize * 3), 4, "Int")
      If (This["Columns"]) {
         If !This["Columns", SubItem]
            Return False
      }
      If (Item >= 0) && (SubItem >= 0) {
         This.Item := Item, This.SubItem := SubItem
         If !(This.Next) {
            ControlGet, V, List, Count, , % "ahk_id " . H
            This.RowCount := V - 1
            ControlGet, V, List, Count Col, , % "ahk_id " . H
            This.ColCount := V - 1
            , NumPut(VarSetCapacity(WINDOWINFO, 60, 0), WINDOWINFO)
            , DllCall("GetWindowInfo", "Ptr", H, "Ptr", &WINDOWINFO)
            , This.DX := NumGet(WINDOWINFO, 20, "Int") - NumGet(WINDOWINFO, 4, "Int")
            , This.DY := NumGet(WINDOWINFO, 24, "Int") - NumGet(WINDOWINFO, 8, "Int")
            , Styles := NumGet(WINDOWINFO, 36, "UInt")
            SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % "WWW", , % "ahk_id " . H ; LVM_GETSTRINGWIDTH
            This.MinW := ErrorLevel
            SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % "III", , % "ahk_id " . H ; LVM_GETSTRINGWIDTH
            This.DW := ErrorLevel
            , SBW := 0
            If (Styles & 0x200000)
               SysGet, SBW, 2
            ControlGetPos, LX, LY, LW, , , % "ahk_id " . H
            This.LX := LX
            , This.LY := LY
            , This.LR := LX + LW - (This.DX * 2) - SBW
            , This.LW := LW
            , This.SW := SBW
            , VarSetCapacity(RECT, 16, 0)
            , NumPut(SubItem, RECT, 4, "Int")
            SendMessage, 0x1038, %Item%, % &RECT, , % "ahk_id " . H
            X := NumGet(RECT, 0, "Int")
            If (SubItem = 0) {
               SendMessage, 0x101D, 0, 0, , % "ahk_id " . H
               W := ErrorLevel
            }
            Else
               W := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
            R := LW - (This.DX * 2) - SBW
            If (X < 0)
               SendMessage, 0x1014, % X, 0, , % "ahk_id " . H
            Else If ((X + W) > R)
               SendMessage, 0x1014, % (X + W - R + This.DX), 0, , % "ahk_id " . H
         }
         PostMessage, % (A_IsUnicode ? 0x1076 : 0x1017), %Item%, 0, , % "ahk_id " . H
      }
      Return False
   }																											
   NextSubItem(K) {
      H := This.HWND
      Item := This.Item
      SubItem := This.SubItem
      If (K = 0x8009)
         SubItem++
      Else If (K = 0x8409) {
         SubItem--
         If (SubItem = 0) && This.Skip0
            SubItem--
      }
      Else If (K = 0x8028)
         Item++
      Else If (K = 0x8026)
         Item--
      IF (K = 0x8409) || (K = 0x8009) {
         If (This["Columns"]) {
            If (SubItem < This.Columns.MinIndex())
               SubItem := This.Columns.MaxIndex(), Item--
            Else If (SubItem > This.Columns.MaxIndex())
               SubItem := This.Columns.MinIndex(), Item++
			   Else {
               While (This.Columns[SubItem] = "") {
                  If (K = 0x8009)
                     SubItem++
                  Else
                     SubItem--
               }
            }
         }
      }
      If (SubItem > This.ColCount)
         Item++, SubItem := This.Skip0 ? 1 : 0
      Else If (SubItem < 0)
         SubItem := This.ColCount, Item--
      If (Item > This.RowCount)
         Item := 0
      Else If (Item < 0)
         Item := This.RowCount
      If (Item <> This.Item)
         SendMessage, 0x1013, % Item, False, , % "ahk_id " . H 
      VarSetCapacity(RECT, 16, 0), NumPut(SubItem, RECT, 4, "Int")
      SendMessage, 0x1038, % Item, % &RECT, , % "ahk_id " . H
      X := NumGet(RECT, 0, "Int"), Y := NumGet(RECT, 4, "Int")
      If (SubItem = 0) {
         SendMessage, 0x101D, 0, 0, , % "ahk_id " . H
         W := ErrorLevel
      }
      Else
         W := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
      R := This.LW - (This.DX * 2) - This.SW, S := 0
      If (X < 0)
         S := X
      Else If ((X + W) > R)
         S := X + W - R + This.DX
      If (S)
         SendMessage, 0x1014, % S, 0, , % "ahk_id " . H 
      Point := (X - S + (This.DX * 2)) + ((Y + (This.DY * 2)) << 16)
      SendMessage, 0x0201, 0, % Point, , % "ahk_id " . H 
      SendMessage, 0x0202, 0, % Point, , % "ahk_id " . H 
      SendMessage, 0x0203, 0, % Point, , % "ahk_id " . H 
      SendMessage, 0x0202, 0, % Point, , % "ahk_id " . H 
   }
																														
   RegisterHotkeys(Register = True) {			  
      H := This.HWND
      If (Register) {
         DllCall("RegisterHotKey", "Ptr", H, "Int", 0x801B, "UInt", 0, "UInt", 0x1B)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8009, "UInt", 0, "UInt", 0x09)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8409, "UInt", 4, "UInt", 0x09)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8028, "UInt", 0, "UInt", 0x28)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8026, "UInt", 0, "UInt", 0x26)
         , This.HotkeyFunc := ObjBindMethod(This, "On_WM_HOTKEY")
         , OnMessage(0x0312, This.HotkeyFunc)
      }
      Else {
         DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x801B)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8009)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8409)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8028)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8026)
         , OnMessage(0x0312, This.HotkeyFunc, 0)
         , This.HotkeyFunc := ""
      }
   }
}

uriDecode(str) {
    Loop
 If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
    StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
    Else Break
 Return, str
}															  
																  
UriEncode(Uri, Enc = "UTF-8")
{
	StrPutVar(Uri, Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop
	{
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
			Break
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
	Return, Res
}
StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	Return, StrPut(Str, &Var, Enc)
}