#NoEnv
#MaxMem 4095
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Persistent
FileEncoding UTF-8

/*  ;;[DEBUG32]
if !(A_IsUnicode=1 and A_PtrSize=4)
{
	SplitPath, A_AhkPath, , sknshrpd
	Run, %sknshrpd%\AutoHotkeyU32.exe "%A_ScriptFullPath%"
	goto, QUITOUT
}
*/  ;;[DEBUG32]
;{#################################   ENVIRONMENT SETUP   #################################
;###########################################################################################
RJPRJCT := "[RJ_PROJ]"
RJEXFN := "[RJ_EXE]"
RELEASE := "[VERSION]"
VERSION := "[CURV]"
EnvGet,LADTA,LOCALAPPDATA
EnvGet,USRPRF,USERPROFILE
EnvGet,SYSTMRT,SYSTEMROOT
EnvGet,PBLCFLDR,ALLUSERSPROFILE
EnvGet,xprgfls,PROGRAMFILES(X86)
EnvGet,DRVRT,WINDIR
splitpath,DRVRT,,,,,DRVSYSTM
USERRT=%DRVSYSTM%\Users
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
Process,Exist
CURPID= %ERRORLEVEL%
if fileExist(USRPRF . "\My Documents\")
	{
		MYDOX= %USRPRF%\My Documents
	}
if fileExist(USRPRF . "\Documents\")
	{
		MYDOX= %USRPRF%\Documents
	}
splitpath,plink,scname,scpath,scextn,gmname,gmd
CFGDIR := SCPATH
RJDBINI := home . "\RJDB.ini"
if (scextn = "lnk")
{
	FileGetShortcut,%plink%,inscname,inscpth,chkargl
	if (instr(inscname,"jkvtx.exe")or instr(inscname,RJEXFN . ".exe"))
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
site_local := home . "\site"
binhome := home . "\bin"
THELOG := home . "\log.txt"
ARIA:= binhome . "\aria2c.exe"
cacheloc:= home . "\downloaded"

/*  ;;[DEBUG32]
SkinStyle= %source%\
iniread,ThemeNV,%RJDBINI%,THEME,GUI_Theme_Name
splitpath,ThemeNV,ThemeN,skinpth,skinxtn
ThemeA= Native_Light|Native_Dark|LightMode.msstyles|LightMode.she|DarkMode.msstyles|DarkMode.she

if fileExist(source . "\" . ThemeN)
	{
		ThemeA= Native_Light|Native_Dark|LightMode.msstyles|LightMode.she|DarkMode.msstyles|DarkMode.she|
		stringreplace,ThemeA,ThemeA,%ThemeN%|,,
		ThemeALL=|%ThemeN%||%ThemeA%
		iniwrite,%ThemeN%,%RJDBINI%,THEME,GUI_theme_name
		if (skinxtn = "msstyles")
			{
				SkinForm(Apply, binhome "\USkin.dll", SkinStyle . ThemeN)
				goto, ThemeLoaded
			}
		if (skinxtn = "she")
			{
				hSkinH := DllCall("LoadLibrary", "Str", binhome "\SkinHu.dll")
				DllCall("SkinHu\SkinH_AttachEx", "Str", SkinStyle . ThemeN)
				goto, ThemeLoaded
			}
	}
else {
		
		ThemeA= Native_Light|Native_Dark|LightMode.msstyles|LightMode.she|DarkMode.msstyles|DarkMode.she
		stringreplace,ThemeA,ThemeA,%ThemeN%|,,
		ThemeAll=|%ThemeN%||%ThemeA%
		iniwrite,%ThemeN%,%RJDBINI%,THEME,GUI_theme_name
		goto, ThemeLoaded
	}
ThemeA= Native_Light|Native_Dark|LightMode.msstyles|LightMode.she|DarkMode.msstyles|DarkMode.she|
stringreplace,ThemeA,ThemeA,%ThemeN%|,,
ThemeAll=|%ThemeN%||%ThemeA%
iniwrite,%ThemeN%,%RJDBINI%,THEME,GUI_theme_name

ThemeLoaded:
*/ ;;[DEBUG32]

;}#################################  ENVIRONMENT SET  #################################
;###########################################################################################
;{#################################   VARIABLE SETUP   #################################
;##########################################################################################
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
PROFINST=Profile
stmdbeb= <td><code>
stmdbee= </code></td>
GUI_THEMES= Native_Light|LightMode.msstyles|LightMode.she|DarkMode.msstyles|DarkMode.she|
	
ini_p=IniSel|MMODET|TBARTOG|MapDDL|exeDDL|iniexe|ExeBut|DelExe|cfgDDL|inicfg|CfgBut|Delcfg|SappID|PRFNAME|SaveName|LcLcP|LcLeP|CeneP|cencp|keyboard_Mapper|opnif|opnRLD|CloudSavDDL|CloudSavEDT|CloudSavBut|DelCloudSav|CloudCfgDDL|CloudCfgEDT|CloudCfgBut|DelCloudCfg
exe_p=Keysticks-Exe|Xpadder-Exe|JoyXoff-Exe|Antimicrox-Exe|joy2key-Exe|Antimicro-Exe|MultiMonitor-Tool|Display-Changer|BorderLess-Gaming-Program|Exe-File|1-Pre|2-Pre|3-Pre|1-Post|2-Post|3-Post|Just Before Exit|Just After Launch|Cloud-Backup|Cloud-Restore
cfg_p=MediaCenter-Profile|Player 1|Player 2|Player 3|Player 4|Player 5|Player 6|Player 7|Player 8|Monitor-MEDIACENTER-Cfg|Monitor-Game-Cfg|Save Data|Install-Folder|Game Data|keyboard-Mapper
ptyx=|32|33|35|44|38|45|64|35|123|91|125|93|39|59|58|46|94|43|61|
reduced= |_Data|Assets|alt|shipping|Data|ThirdParty|engine|App|steam|steamworks|steamclient|script|nocd|Tool|trainer|
priora= |loader64|Launcher64|Launcherx64|Launcherx8664|Launcher64bit|Launcher64|Launchx64|Launch64|Launchx8664|
priorb= |loader32|Launcher32|Launcherx86|Launcher32bit|Launcher32|Launchx86|Launch32|
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
ItchQuery= itch\app*|Itch*games|Itch.io
GenQuery= Games|Gaymes|My Games|juegos|spellen|Spiele|Jeux|Giochi|PC_Games|PC Games|PCGAMES|Windows Games|WinGames|Windows_Games|Win_Games|Games_for_Windows|Games for Windows|GamesForWindows|CHRONOS Releases
AllQuery:= GogQuery . | . "Origin" . "|" . "Epic Games" . "|" . steamhome
undira= |%A_WinDir%|%A_Programfiles%|%A_Programs%|%A_AppDataCommon%|%A_AppData%|%A_Desktop%|%A_DesktopCommon%|%A_StartMenu%|%A_StartMenuCommon%|%A_Startup%|%A_StartupCommon%|%A_Temp%|%LADTA%|
undirs= %undira%
pcgwbr= 400 Bad Request
pcgwbt= Bad title
patsup= Support us on Patreon
nopcgw= There is currently no text in this page.
nopcga= would you like to create it?
nostmdbi= No app was found matching this AppID.
STEAMIDB=https://store.steampowered.com/api/appdetails?appids=
PC_GWB=https://pcgamingwiki.com
PCGWB=https://www.pcgamingwiki.com
PCGWURL=%PCGWB%/wiki/
PCGWAPI=https://www.pcgamingwiki.com/api/appid.php?appid=
STEAMDBI=https://steamdb.info/app/
TRIEND=x64|x86|x32|app|pak
cfgfld=GAME_PROFILES|Source_Directory|
DDPRVD=Steam|Itch|EA|Origin|GOG|Amazon|Epic|XBox|XCloud|Battle
PakLST=KBPak|Pl1Pak|Pl2Pak|MCjPak|GMPak|DMPak|JALPak|JBEPak|PREPak|PSTPak
CENITEMS= CenKBM|CenPL1|CenPL2|CenMC|CenGM|CenMM|CenJAL|CenJBE|CenPRE|CenPST|
GUIVARS= ASADMIN|PostWait|PreWait|Localize|SCONLY|EXEONLY|BOTHSRCH|ADDGAME|ButtonClear|ButtonCreate|MyListView|CREFLD|GMCONF|GMJOY|GMLNK|UPDTSC|OVERWRT|POPULATE|RESET|EnableLogging|RJDB_Config|RJDB_Location|GAME_ProfB|GAME_DirB|SOURCE_DirB|SOURCE_DirectoryT|REMSRC|Keyboard_MapB|Player1_TempB|Player2_TempB|CENTRLCKB|MediaCenter_ProfB|MultiMonitor_Tool|MM_ToolB|MM_Game_CfgB|MM_MediaCenter_CfgB|BGM_ProgB|BGP_Enable|BGP_TE|BGP_TU|PREAPP|PREDD|DELPREAPP|POSTAPP|PostDD|DELPOSTAPP|REINDEX|KILLCHK|INCLALTS|SELALLBUT|SELNONEBUT|KBM_RC|MMT_RC|MMT_RC|BGM_RC|JAL_ProgB|JBE_ProgB|JBE_RC|JAL_RC|PRE_RC|POST_RC|IncludedD|DDINCLD|Hide_Taskbar|JALWAIT|JBEWAIT|NAMECHK|NetChk|CenKBM|CenPL1|CenPL2|CenMC|CenGM|CenMM|CenJAL|CenJBE|CenPRE|CenPST|EXCL_DirB|EXCLUDE_DirectoryT|REMEXCL|IniSel|MMODET|TBARTOG|MapDDL|exeDDL|iniexe|ExeBut|DelExe|cfgDDL|inicfg|CfgBut|Delcfg|SappID|PRFNAME|SaveName|LcLcP|LcLeP|CeneP|cencp|keyboard_Mapper|opnif|opnRLD|Package|iniBut|MMODET|TBARTOG|MapDDL|exeDDL|_LCLeP|_CENeP|ExeBut|DelExe|cfgDDL|_LCLcP|_CENcP|CfgBut|Delcfg|PRFNAME|SappID|eName|ToolTips|CloudSavDDL|CloudSavEDT|CloudSavBut|DelCloudSav|CloudCfgDDL|CloudCfgEDT|CloudCfgBut|DelCloudCfg
STDVARS= EXCLUDE_Directory|EXCLUDE_DirectoryT|SOURCE_DirectoryT|SOURCE_Directory|KeyBoard_Mapper|MediaCenter_Profile|Player1_Template|Player2_Template|MultiMonitor_Tool|MMLOAD|MMSAVE|MM_MEDIACENTER_Config|MM_Game_Config|BorderLess_Gaming_Program|extapp|Game_Directory|Game_Profiles|RJDB_Location|Source_Directory|Mapper_Extension|1_Post|2_Post|3_Post|1_Post|2_Post|3_Post|Install_Folder|GameData|SaveData|BGP_State|Borderless_Gaming_Program|Name_Check|Net_Check|CENTRLCKB|Cloud_Backup|Cloud_Restore|JustBeforeExit|JustAfterLaunch|Hide_Taskbar|Steam_AppID|Exe_File|Steam_UserID|exe_list
DDTA= <$This_prog$><Monitor><Mapper>
DDTB= <Monitor><$This_prog$><Mapper>
DDTC= <$This_prog$><Monitor><Mapper>
ascinumerate=!|#|$|@|`%|&|(|)|[|]|{|}|'|;/
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
STINQ=abbr title="replace with My Documents for Windows XP"
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
RJREPOS:= home . "\repos.ini"
if (!fileExist(RJDBORIJ)or !fileExist(RJREPOS))
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

iniread,Gui_Theme_Name,%RJDBINI%,THEME,Gui_Theme_Name
/*  ;;[DEBUG32]
if (fileexist(site_local . "\" . "TruenoLt.otf")&& fileexist(site_local . "\" . "AnkaCoder_b.ttf")&& fileexist(site_local . "\" . "Hermit-Regular.otf")&& fileexist(site_local . "\" . "InterUI.ttf"))
	{
		font1:= New CustomFont(site_local . "\" . "TruenoLt.otf")
		font2:= New CustomFont(site_local . "\" . "AnkaCoder_b.ttf")
		font3:= New CustomFont(site_local . "\" . "Hermit-Regular.otf")
		font4:= New CustomFont(site_local . "\" . "InterUI.ttf")
		fontAName= Hermit
		fontBName= Anka/Coder
		fontCName= Trueno
		fontDName= Inter UI
		fontEName= Default
		iniread,LFontL,%RJDBINI%,THEME,Gui_Light_FontL
		iniread,LFontM,%RJDBINI%,THEME,Gui_Light_FontM
		iniread,LFontS,%RJDBINI%,THEME,Gui_Light_FontS
		iniread,LFontB,%RJDBINI%,THEME,Gui_Light_FontB
		iniread,LFontG,%RJDBINI%,THEME,Gui_Light_FontG
		iniread,DFontL,%RJDBINI%,THEME,Gui_Dark_FontL
		iniread,DFontM,%RJDBINI%,THEME,Gui_Dark_FontM
		iniread,DFontS,%RJDBINI%,THEME,Gui_Dark_FontS
		iniread,DFontB,%RJDBINI%,THEME,Gui_Dark_FontB
		iniread,DFontG,%RJDBINI%,THEME,Gui_Dark_FontG
		iniread,bgLightcolor,%RJDBINI%,THEME,GUI_Light_BG
		iniread,bgccolor,%RJDBINI%,THEME,Gui_Dark_BG
	}
	else {
*/  ;;[DEBUG32]
		fontAName= Default
		fontBName= Default
		fontCName= Default
		fontDName= Default
		fontEName= Default
		fontAColor= cSilver
		fontBColor= cSilver
		fontCColor= cSilver
		fontDColor= cSilver
		fontEColor= cSilver
		bgDarkcolor= 151515
		bgLightcolor= 000000
		LFontM=%fontAColor% s7,Default
		LFontL=%fontBColor% s7 Bold,Default	
		LFontG=%fontCColor% s7,Default
		LFontB=%fontDColor% s7 Bold,Default
		LFontS=%fontEColor% s6 Bold,Default
		DFontM=%fontAColor% s7,Default
		DFontL=%fontBColor% s7 Bold,Default	
		DFontG=%fontCColor% s7,Default
		DFontB=%fontDColor% s7 Bold,Default
		DFontS=%fontEColor% s6 Bold,Default
/*  ;;[DEBUG32]
	}
*/  ;;[DEBUG32]	
FontM=Gui, Font, %DFontM%
FontL=Gui, Font, %DFontL%
FontG=Gui, Font, %DFontG%
FontB=Gui, Font, %DFontB%
FontS=Gui, Font, %DFontS%
bgcolor= %bgDarkcolor%
if instr(Gui_Theme_Name,"Light")
	{
		FontM=Gui, Font, %LFontM%
		FontL=Gui, Font, %LFontL%
		FontG=Gui, Font, %LFontG%
		FontB=Gui, Font, %LFontB%
		FontS=Gui, Font, %LFontS%
		bgcolor= %bgLightcolor%
	}

gosub, popgui

if (Logging = 1)
{
	loget:= "checked"
	enablelogging:= 1
}

STM_DB:= source . "\steam.json"
LKUP_DB:= home . "\lookup.db"

if (Name_Check = 1)
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
if (cnitm = "Localize")
	{
		cnlocz:= "checked"
	}
if (cnitnum = 10)
	{
		cnckb:= "checked"
	}
Tltp=
netnchk=
cfgenbl:= "disabled"
joyenbl:= "disabled"
lnkenbl:= "disabled"
if (ToolTips = 1)
	{
		Tltp:= "checked"
	}
if (IncludedD = 1)
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
stmddchk:= ""
if instr(IncludedD,"Steam")
	{
		stmddchk:= "checked"
	}
if (Steam_Directory = "")
	{
		Steam_Directory:= "[STEAMDIRECTORY]"
	}
if (Steam_UserID = "")
	{
		Steam_UserID:= "[STEAMUSERID]"
	}
;}#################################    VARIABLES SET   #################################
;###########################################################################################
;{################################# MENU PREPERATION #################################
;#####################################################################################

BLDGUI:
Menu,PP_RCMenu,Add,,
Menu,MM_RCMenu,Add,: Download ::>,MMToolBDownload
Menu,MM_RCMenu,Add,,
Menu,MM_RCMenu,Add,RESET,MM_ToolBReset
Menu,MM_RCMenu,Add,Disable,DisableButs
Menu,KBM_RCMenu,Add,: Download ::>,KBMDownload
Menu,KBM_RCMenu,Add,,
Menu,KBM_RCMenu,Add,RESET,ResetMprs
Menu,KBM_RCMenu,Add,,
Menu,KBM_RCMenu,Add,Enable,Keyboard_MapBEnable
Menu,KBM_RCMenu,Add,Disable,Keyboard_MapBDisable
Menu,JAL_RCMenu,Add,Disable,JAL_ProgBDisable
Menu,JBE_RCMenu,Add,Disable,JBE_ProgBDisable
Menu,BGM_RCMenu,Add,: Download ::>,BGM_ProgBDownload
Menu,BGM_RCMenu,Add,,
Menu,BGM_RCMenu,Add,Disable,BGM_ProgBDisable
Menu,MMCFG_RCMenu,Add,Disable,MMCFGDisable
Menu,MMCFG_RCMenu,Add,Reset,MMCFGReset
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
Menu, MyContextMenu, Add, Edit Profile, ContextEditProfile
Menu, MyContextMenu, Add,,
Menu, MyContextMenu, Add, Open Profile Dir, ContextOpenFile
Menu, MyContextMenu, Add, Open Game Dir, ContextOpenFile
Menu, MyContextMenu, Add,,
Menu, MyContextMenu, Add, Add CLI opts/args, AddCLI
Menu, MyContextMenu, Add,,
Menu, MyContextMenu, Add, Download Meta-Data, GetMetaData
Menu, MyContextMenu, Add,,
Menu, MyContextMenu, Add, Clear from ListView, ContextClearRows

ITERTARE:
;} ################################# MENU PREPARED ####################################
;#######################################################################################
;{ ################################# GUI GENERATION #########################################
;###################################################################################################
Gui +hWndhMainWnd
Gui,Color,%bgcolor%
Gui, Add, GroupBox, x680 y0 w123 h35
Gui, Add, GroupBox, x683 y0 w121 h35
Gui, Font, %FontB%
Gui, Add, Button, x318 y10 h20 vADDGAME gADDGAME disabled, ADD+
Gui, Font, %FontM%
Gui, Add, GroupBox, x432 y0 w122 h35
Gui, Add, Text, x439 y12 h12, Check:
Gui, Font, %FontB%
Gui, Add, Button, x480 y10 h19 vSELALLBUT gSELALLBUT hidden, All
Gui, Add, Button, x507 y10 h19 vSELNONEBUT gSELNONEBUT hidden, None
Gui, Add, Button, x580 y10 h19 vButtonClear gButtonClear hidden disabled, Empty List
Gui, Add, Button, x688 y11 h19 vButtonCreate gButtonCreate hidden disabled,CREATE
Gui, Font, %FontM%
Gui, Add, Text, x744 y13 h12,Launchers
Gui, Add, ListView, r44 x310 y35 h560 w340 -Readonly vMyListView gMyListView hwndHLV1 AltSubmit Checked hidden,Name|Directory/Location|Opt /s|Arg /s|Name Override|KBM|P1|P2|McP|MMT|GM|DM|JAL|JBE|Pre|Pst|Bgm|SteamID
LV_ModifyCol(3, "Integer")
ImageListID1 := IL_Create(10)
ImageListID2 := IL_Create(10, 10, true)
LV_SetImageList(ImageListID1)
LV_SetImageList(ImageListID2)
Gui, Font, %FontB%
Gui, Add, Button, x236 y4 w55 h20 vCANCLDBUT gCANCLDBUT hidden disabled,CANCEL
Gui, Font, %FontM%
GUI Add,TAB2, x2 y0 w297 h676 vTABMENU, Setup||Config|Edit
Gui, Add, StatusBar, x0 y675 w314 h28 vRJStatus -Theme Background404040, Status Bar
Gui,Tab, 1
Gui Tab, Setup
Gui, Add, GroupBox, x0 y20 w296 h655
Gui, Font, %FontG%
GUi, Add, Checkbox, x90 y80 h14 vIncludedD gIncludedD Right %stmddchk%,<Include>
Gui, Font, %FontS%
Gui, Add, DropDownList, x184 y77 w80 vDDINCLD gDDINCLD,Steam||Itch|EA|Origin|GOG|Amazon|Epic|XBox|XCloud|Battle
;;Gui, Add, Radio, x95 y32 vEXEONLY gEXEONLY checked hidden, Exe`,Cmd`,Bat
Gui, Font, %FontB%
Gui, Add, Button, x24 y50 w41 h21 vSOURCE_DirB gSOURCE_DirB,SRC+
Gui, Font, %FontG%
Gui, Add, Text, x24 y33 h14 vCURDP Right,<Game Fldrs>
Gui, Font, %FontS%
Gui, Add, DropDownList, x72 y50 w192 vSOURCE_DirectoryT gSOURCE_DirectoryDD,%sourcepop%
Gui, Font, %FontB%
Gui, Add, Button, x269 y52 w15 h15 vREMSRC gREMSRC,X
Gui, Add, Button, x24 y104 w41 h19 vEXCL_DirB gEXCL_DirB,EXC+
Gui, Font, %FontG%
Gui, Add, Text, x28 y87 h14,<Exclude>
Gui, Font, %FontS%
Gui, Add, DropDownList, x72 y104 w192 vEXCLUDE_DirectoryT gEXCLUDE_DirectoryDD,%exclpop%
Gui, Font, %FontB%
Gui, Add, Button, x268 y107 w15 h15 vREMEXCL gREMEXCL,X
Gui, Font, %FontG%
Gui, Add, Text, x24 y128 h14,<Shortcut Output Directory>
Gui, Font, %FontB%
Gui, Add, Button, x21 y144 w35 h21 vGame_DirB gGame_DirB,OUT
Gui, Font, %FontG%
Gui, Add, Text, x64 y148 w222 h14 vGAME_DirectoryT Right,%GAME_Directory%
Gui, Add, Text, x24 y168 w132 h14 vGame_ProfilesR,<Game-Profiles-Directory>
Gui, Font, %FontB%
Gui, Add, Button, x21 y184 w35 h21 vGame_ProfB gGame_ProfB,GPD
Gui, Font, %FontM%
Gui, Add, Text, x64 y186 w222 h14 vGAME_ProfilesT Right,%GAME_Profiles%
Gui, Font, %FontG%
Gui, Add, Text, x24 y206 w206 h14,<Keyboard Mapper Program>
Gui, Font, %FontB%
Gui, Add, Button, x21 y222 w35 h21 vKeyboard_MapB gKeyboard_MapB,KBM
Gui Add, Button, x4 y222 w14 h17 vKBM_RC gKBM_RC, v
Gui, Font, %FontM%
Gui, Add, Text, x67 y224 w222 h14 vKeyboard_MapperT Right,%Keyboard_Mapper%
Gui, Font, %FontG%
Gui, Add, Text, x24 y248 w222 h14,<Template Profile for Player 1>
Gui, Font, %FontB%
Gui, Add, Button, x25 y266 w35 h19 vPlayer1_TempB gPlayer1_TempB,PL1
Gui, Font, %FontG%
Gui, Add, Text, x64 y268 w222 h14 vPlayer1_TemplateT Right,%Player1_Template%
Gui, Font, %FontG%
Gui, Add, Text, x24 y285 w222 h14,<Template for Player 2>
Gui, Font, %FontB%
Gui, Add, Button, x25 y303 w36 h19 vPlayer2_TempB gPlayer2_TempB,PL2
Gui, Font, %FontM%
Gui, Add, Text, x64 y305 w222 h14 vPlayer2_TemplateT Right,%Player2_Template%
Gui, Font, %FontG%
Gui, Add, Text, x24 y324 w222 h14,<Template for MediaCenter/Desktop>
Gui, Font, %FontB%
Gui, Add, Button, x25 y339 w35 h19 vMediaCenter_ProfB gMediaCenter_ProfB,MCP
Gui, Font, %FontM%
Gui, Add, Text, x64 y341 w222 h14 vMediaCenter_TemplateT Right,%MediaCenter_Template%
Gui, Font, %FontG%
Gui, Add, Text, x24 y361 w125 h14,<Borderless_Program>
Gui, Font, %FontB%
Gui, Add, Button, x21 y376 w36 h21 vBGM_ProgB gBGM_ProgB,BGP
Gui Add, Button, x4 y376 w14 h17 vBGM_RC gBGM_RC, v
Gui, Font, %FontM%
Gui, Add, Text, x67 y378 w222 h14 vBorderless_Gaming_ProgramT Right,%Borderless_Gaming_Program%
Gui, Font, %FontG%
Gui, Add, Text, x24 y399 w222 h14,<Multimonitor Program>
Gui, Font, %FontB%
Gui, Add, Button, x21 y415 w35 h21 vMM_ToolB gMM_ToolB,MMT
Gui Add, Button, x4 y415 w14 h17 vMMT_RC gMMT_RC, v
Gui, Font, %FontM%
Gui, Add, Text, x70 y417 w202 h14 vMultiMonitor_ToolT Right,%MultiMonitor_Tool%
Gui, Font, %FontG%
Gui, Add, Text, x24 y440 w222 h14,<Game Monitor CFG>
Gui, Font, %FontM%
Gui, Add, Radio, x205 y458 w18 h14 vMMResDR gMMResDR hidden,
Gui, Add, Radio, x223 y458 w18 h14 vMMResTR gMMResTR hidden,
Gui, Add, Radio, x241 y458 w18 h14 vMMResSR gMMResSR hidden,
Gui, Font, %FontS%
Gui, Add, DropDownList, x64 y456 w95 vMMResDD gMMResDD hidden,
Gui, Add, DropDownList, x162 y456 w40 vMMResHD gMMResHD hidden,
Gui, Font, %FontB%
Gui, Add, Button, x25 y456 w35 h19 vMM_Game_CfgB gMM_Game_CfgB,GMC
Gui, Font, %FontM%
Gui, Add, Text, x163 y442 h14 vMMResXX hidden,hz __ | [_] [C] [S]
Gui, Font, %FontB%
Gui, Add, Button, x261 y456 w28 vMMResB gMMResB hidden,OK
Gui, Font, %FontG%
Gui, Add, Text, x64 y458 w222 h14 vMM_Game_ConfigT Right,%MM_Game_Config%
Gui, Font, %FontG%
Gui, Add, Text, x24 y478 w214 h14,<HTPC/Desktop Monitor CFG>
Gui, Font, %FontB%
Gui, Add, Button, x25 y495 w35 h19 vMM_MediaCenter_CfgB gMM_MediaCenter_CfgB,DMC
Gui, Font, %FontG%
Gui, Add, Text, x64 y497 w225 h14 vMM_MediaCenter_ConfigT Right,%MM_MediaCenter_Config%
Gui, Font, %FontB%
Gui, Add, Button, x21 y522 w35 h21 vJAL_ProgB gJAL_ProgB,JAL
Gui Add, Button, x4 y522 w14 h17 vJAL_RC gJAL_RC,v
Gui, Font, %FontM%
Gui, Add, Text, x71 y525 w195 h14 vJustAfterLaunchT Right,%JustAfterLaunchT%
Gui, Add, Checkbox, x273 y524 w12 h14 vJALWait gJALWait %jalstatus%
;Gui, Add, Text,  x64 y526 w198 h14,<Run After Launch>
Gui, Font, %FontB%
Gui, Add, Button, x21 y550 w35 h19 vJBE_ProgB gJBE_ProgB,JBE
Gui Add, Button, x4 y550 w14 h17 vJBE_RC gJBE_RC,v
Gui, Font, %FontM%
Gui, Add, Text, x67 y550 w198 h14 vJustBeforeExitT Right,%JustBeforeExitT%
Gui, Add, Checkbox, x273 y552 w12 h14 vJBEWait gJBEWait %jbestatus%
;Gui, Add, Text, x64 y548 w198 h14,<Run Before Exit>
Gui, Font, %FontB%
Gui, Add, Button, x21 y576 w36 h21 vPREAPP gPREAPP ,PRE
Gui Add, Button, x4 y576 w14 h17 vPRE_RC gPRE_RC, v
Gui, Font, %FontG%
Gui, Add, Text, x63 y578 h12 vPRETNUM,1 
Gui, Font, %FontS%
Gui, Add, DropDownList, x72 y576 w193 vPREDD gPREDD Right,%prelist%
Gui, Add, Text, x4 y597 h14 w260 vPREDDT cAqua,<$This_Prog$><Monitor><Mapper><game.exe>
Gui, Font, %FontM%
Gui, Add, Checkbox, x273 y578 w12 h14 vPreWait gPreWait %prestatus%,
Gui, Font, %FontB%
Gui, Add, Button, x273 y595 w14 h14 vDELPREAPP gDELPREAPP ,X
Gui, Add, Button, x21 y614 w36 h21 vPOSTAPP gPOSTAPP,PST
Gui Add, Button, x4 y614 w14 h17 vPOST_RC gPOST_RC, v
Gui, Font, %FontG%
Gui, Add, Text, x63 y616 h12 vPOSTDNUM,1
Gui, Font, %FontS%
Gui, Add, DropDownList, x72 y616 w193 vPostDD gPostDD Right,%postlist%
Gui, Font, %FontG%
Gui, Add, Text, x4 y638 h14 w260 vPOSTDDT cAqua,<game.exe><$This_Prog$><Mapper><Monitor>
Gui, Font, %FontM%
Gui, Add, Checkbox, x273 y619 w12 h14 vPostWait gPostWait %poststatus%
Gui, Font, %FontB%
Gui, Add, Button, x273 y636 w14 h14 vDELPOSTAPP gDELPOSTAPP ,X
Gui, Add, Button, x268 y656 h16 w18 vRESET gRESET,R
Gui, Font, %FontM%
/*  ;;[DEBUGINT]
	Gui, Add, Checkbox, x40 y657 h16 w18 vEnableLogging gEnableLogging right %loget%,
Gui, Font, %FontB%
	Gui, Add, Button, x20 y656 h16 w18 vOPNLOG gOPNLOG,!
*/  ;;[DEBUGINT]
Gui, Tab, 2
Gui, Tab, Config
Gui, Font, %FontG%
Gui, Add, Radio, x30 y38 h14 vOVERWRT gUPDTSC %ovrwrchk%,Overwrite
Gui, Add, Radio, x110 y38 h14 vUPDTSC gOVERWRT %updtchk%,Update
Gui, Add, GroupBox, x7 y50 w284 h218
GUi, Add, Checkbox, x30 y68 h14 vCREFLD gCREFLD %fldrget%, Profile Folders
GUi, Add, Checkbox, x50 y87 h14 vGMCONF gGMCONF %cfgget% %cfgenbl%,Config File
Gui, Add, Checkbox, x65 y107 w92 h14 vKILLCHK gKILLCHK checked,Kill-List
GUi, Add, Checkbox, x65 y123 h14 vASADMIN gASADMIN %admnget% %admnenabl%,As Admin
Gui, Add, Checkbox, x65 y141 w109 h14 vHide_Taskbar gHide_Taskbar %taskbarv%,Hide Taskbar
GUi, Add, Checkbox, x50 y159 h14 vGMLNK gGMLNK %lnkget% %lnkenbl%,Launcher Shortcuts
GUi, Add, Checkbox, x50 y177 h14 vGMJOY gGMJOY %Joyget% %joyenbl%,Joystick Profiles
Gui, Add, Checkbox, x202 y169 h14 vToolTips gToolTips %Tltp% Right,Tool-Tips
Gui, Add, GroupBox, x7 y280 w284 h370 center,
Gui, Add, Checkbox, x30 y205 h14 vBGP_Enable gBGP_Enable %gbtstate%, Enable Borderless-Gaming Program
Gui, Add, Checkbox, x50 y225 h14 vBGP_TU gBGP_TU %bgptu%,Terminate if unused
Gui, Add, Checkbox, x50 y243 h14 vBGP_TE gBGP_TE %bgpte%,Terminate on exit

Gui, Add, Checkbox, x185 y112 h14 vNameChk gNameChk right %nmchkst%,Name-Check
Gui, Add, Checkbox, x185 y92 h14 vNetChk gNetChk right %netnchk%,Net-Check

Gui, Add, Checkbox, x125 y295 w85 h14 vLocalize gLocalize %cnlocz% %fontAColor% Right,LOCALIZE
Gui, Add, Checkbox, x202 y309 h14 vPackage gPackage %pkckb% %pkcol% Right,Package
Gui, Add, Checkbox, x38 y300 h14 vCENTRLCKB gCENTRLCKB %cntz% %fontAColor%,CENTRALIZE
Gui, Add, Checkbox, x55 y330 w14 h14 vCenKBM gCenKBM %cnkbm%,
Gui, Add, Checkbox, x55 y360 w14 h14 vCenPL1 gCenPL1 %cnpl1%,
Gui, Add, Checkbox, x55 y390 w14 h14 vCenPL2 gCenPL2 %cnpl2%,
Gui, Add, Checkbox, x55 y418 w14 h14 vCenMC gCenMC %cnMC%,
Gui, Add, Checkbox, x55 y451 w14 h14 vCenGM gCenGM %cnGM%,
Gui, Add, Checkbox, x55 y484 w14 h14 vCenMM gCenMM %cnMM%,
Gui, Add, Checkbox, x55 y515 w14 h14 vCenJAL gCenJAL %cnJAL%,
Gui, Add, Checkbox, x55 y547 w14 h14 vCenJBE gCenJBE %cnJBE%,
Gui, Add, Checkbox, x55 y579 w14 h14 vCenPRE gCenPRE %cnPRE%,
Gui, Add, Checkbox, x55 y617 w14 h14 vCenPST gCenPST %cnPST%,
Gui, Add, Checkbox, x272 y330 w14 h14 vKBPak gKBPak %KBPak_p% %pkcvz%,
Gui, Add, Checkbox, x272 y360 w14 h14 vPl1Pak gPl1Pak %Pl1Pak_p% %pkcvz%,
Gui, Add, Checkbox, x272 y390 w14 h14 vPl2Pak gPl2Pak %Pl2Pak_p% %pkcvz%,
Gui, Add, Checkbox, x272 y418 w14 h14 vMCjPak gMCjPak %MCjPak_p% %pkcvz%,
Gui, Add, Checkbox, x272 y451 w14 h14 vGMPak gGMPak %GMPak_p% %pkcvz%,
Gui, Add, Checkbox, x272 y484 w14 h14 vDMPak gDMPak %DMPak_p% %pkcvz%,
Gui, Add, Checkbox, x272 y515 w14 h14 vJALPak gJALPak %JALPak_p% %pkcvz%,
Gui, Add, Checkbox, x272 y547 w14 h14 vJBEPak gJBEPak %JBEPak_p% %pkcvz%,
Gui, Add, Checkbox, x272 y579 w14 h14 vPREPak gPREPak %PREPak_p% %pkcvz%,
Gui, Add, Checkbox, x272 y617 w14 h14 vPSTPak gPSTPak %PSTPak_p% %pkcvz%,
Gui, Font, %FontG%
Gui, Add, Text, x22 y330 w31 h14,KBM:
Gui, Add, Text, x22 y360 w31 h14,PL1:
Gui, Add, Text, x22 y390 w31 h14,PL2:
Gui, Add, Text, x22 y420 w31 h14,MCT:
Gui, Add, Text, x22 y450 w31 h14,GMC:
Gui, Add, Text, x22 y482 w31 h14,DMC:
Gui, Add, Text, x22 y515 w31 h14,JAL:
Gui, Add, Text, x22 y547 w31 h14,JBE:
Gui, Add, Text, x22 y579 h14 w31 h14,PRE:
Gui, Add, Text, x22 y618 h14 w31 h14,PST:
Gui, Font, %FontM%
Gui, Add, Text, x84 y330 w182 h14 v_Keyboard_MapperT Right,%Keyboard_Mapper%
Gui, Add, Text, x84 y360 w182 h14 v_Player1_TemplateT Right,%Player1_Template%
Gui, Add, Text, x84 y390 w182 h14 v_Player2_TemplateT Right,%Player2_Template%
Gui, Add, Text, x84 y418 w182 h14 v_MediaCenter_TemplateT Right,%MediaCenter_Template%
Gui, Add, Text, x84 y448 w182 h14 v_MM_Game_ConfigT Right,%MM_Game_Config%
Gui, Add, Text, x84 y482 w182 h14 v_MM_MediaCenter_ConfigT Right,%MM_MediaCenter_Config%
Gui, Add, Text, x84 y515 w182 h14 v_JustAfterLaunchT Right,%JustAfterLaunchT%
Gui, Add, Text, x84 y544 w182 h14 v_JustBeforeExitT Right,%JustBeforeExitT%
Gui, Add, Text, x72 y578 h14 w8 v_PRETNUM,1
Gui, Font, %FontG%
Gui, Add, Text, x72 y616 h14 w8 v_POSTDNUM,1
Gui, Font, %FontM%
Gui, Add, Text, x84 y578 h14 w182 v_PREDDT Right,
Gui, Add, Text, x84 y616 h14 w182 v_POSTDDT Right,
Gui, Font, %FontB%
Gui, Add, Button, x231 y4 w55 h15 vREINDEX gREINDEX %repopbut%,re-index
Gui, Add, Button, x241 y27 w45 h23 vPOPULATE gPOPULATE,GO>
/*  ;;[DEBUG32]
Gui, Add, DDL, x70 y652 w170 hwndDplHndl2 vTHEMEN gTHEMEN,%themeALL%
*/  ;;[DEBUG32]
Gui, Tab, 3
Gui, Tab, Edit
Gui, Font, %FontM%
Gui, Add, GroupBox, x7 y20 w288 h116
Gui, Font, %FontG%
Gui,Add,Text,x15 y45 h15,Game.ini
Gui,Add,Text, x100 y42 w177 h15 vIniSel hidden right,%gameifile%
Gui, Font, %FontB%
Gui,add,Button,x70 y42 w26 h21 viniBut giniBut,...
Gui, Font, %FontM%
Gui,Add,Checkbox,x30 y66 w144 h20 vMMODET gMMODET hidden,Multimonitor Mode
Gui,Add,Checkbox,x30 y90 w142 h20 vTBARTOG gTBARTOG hidden,Hide Taskbar
Gui, Font, %FontM%
Gui,Add,Text,x208 y80 w43 h15,Mapper
Gui, Font, %FontS%
Gui,Add,DropDownList,x184 y96 w90 vMapDDL gMapDDL hidden, %MAPCFGS%
Gui, Font, %FontM%
Gui,Add, GroupBox, x7 y138 w288 h68,Programs/Scripts
Gui, Font, %FontS%
Gui,Add,DDL,x25 y160 w175 vexeDDL gexeDDL hidden,%exe_p%
Gui, Font, %FontM%
Gui, Add, Checkbox, x205 y160 w25 h20 v_LCLeP gLCLeP hidden,L
Gui, Add, Checkbox, x230 y160 w25 h20 v_CENeP gCENeP hidden,C
Gui, Font, %FontG%
Gui,Add,Text,x25 y184 w222 h15 viniexe right hidden,
Gui, Font, %FontB%
Gui,Add, Button, x258 y182 w26 h21889 gExeBut hidden, ...
Gui,add,Button,x278 y162 w15 h15 vDelExe gDelExe hidden,x
Gui, Font, %FontM%
Gui,Add, GroupBox, x7 y208 w288 h69,Config-File/Folder
Gui,Add,DDL,x25 y232 w175 vcfgDDL gcfgDDL hidden,%cfg_p%
Gui, Font, %FontM%
Gui, Add, Checkbox, x205 y232 w25 h20 v_LCLcP gLCLcP hidden,L
Gui, Add, Checkbox, x230 y232 w25 h20 v_CENcP gCENcP hidden,C
Gui, Font, %FontG%
Gui,Add,Text,x25 y256 w222 h15 vinicfg right hidden,
Gui, Font, %FontB%
Gui,Add, Button, x258 y251 w26 h21 vCfgBut gCfgBut hidden,...
Gui,add,Button,x278 y230 w15 h15 vDelcfg gDelCfg hidden,x
Gui, Font, %FontM%
Gui,Add, GroupBox,x7 y280 w288 h127 right,Name/Attributes
Gui, Font, %FontM%
Gui,Add, Text,x25 y303 w75 h15,Profile Name
Gui, Font, %FontG%
Gui,Add, Edit,x105 y303 w170 h23 vPRFNAME gPRFNAME cWhite hidden,
Gui, Font, %FontM%
Gui,Add, Text,x25 y335 w75 h15,Steam AppID
Gui, Font, %FontG%
Gui,Add, Edit,x105 y335 w70 h23 vSappID gSappID hidden cWhite,
Gui, Font, %FontB%
Gui,Add, Button,x245 y372 w40 h23 vSaveName gSaveName hidden,save
Gui, Font, %FontM%
Gui,Add, GroupBox,x7 y412 w288 h135 right,Save Data/Game Data
Gui, Font, %FontM%
Gui,Add,DropDownList,x25 y435 w175 vCloudSavDDL gCloudSavDDL hidden,
Gui, Font, %FontM%
Gui,Add, Text,x205 y435 h15,Save Files
Gui, Font, %FontB%
Gui,add,Button,x278 y435 w15 h15 vDelCloudSav gDelCloudSav hidden,x
Gui, Font, %FontG%
Gui,Add, Edit,x25 y462 w222 h21 vCloudSavEdt gCloudSavedt cWhite hidden,
Gui, Font, %FontB%
Gui,Add, Button, x254 y462 w31 h21 vCloudSavBut gCloudSavBut hidden,... +
Gui, Font, %FontS%
Gui,Add,DropDownList,x25 y491 w175 vCloudCfgDDL gCloudCfgDDL hidden,
Gui, Font, %FontM%
Gui,Add, Text,x205 y491 h15,Config Files
Gui, Font, %FontB%
Gui,add,Button,x278 y491 w15 h15 vDelCloudCfg gDelCloudCfg hidden,x
Gui, Font, %FontG%
Gui,Add, Edit,x25 y520 w222 h21 vCloudCfgEdt gCloudCfgedt cWhite hidden,
Gui, Font, %FontB%
Gui,Add, Button, x254 y520 w31 h21 vCloudCfgBut gCloudCfgBut hidden,... +
Gui, Font, %FontM%
/*  ;;[DEBUGOV]
	OnMessage(0x200, "WM_MOUSEMOVE")
*/  ;;[DEBUGOV]
Gui Show, w314 h700, [RJ_PROJ]_GUI
GuiOpen := 1
;}    #######################################  GUI CREATED ##############################
;###################################################################################################
;{#####################  TOOL-TIP GENERATION  #################################
;##################################################################
SB_SetText("")
ADDGAME_TT :="Add a game with the file browser.`nAn attempt will be made to guess the appropriate name"
ASADMIN_TT :="sets shortcuts and programs to run as the aministrator."
SKTHEMEN_TT :="Theme`nRequires Restart"
PRFNAME_TT :="Profile Name"
PRFNAME_TT :="Renames the profile-directory name, shortcut-name and sub-items to match."
inicfg_TT :="Configuration File for " . cfgDDL
ExeBut_TT :="Select an Application or Script for " . exeDDL
CfgBut_TT :="Select a config file for " . cfgDDL
MapDDL_TT :="Assigns a Keyboard Mapper"
iniexe_TT :="Exe File for " . exeDDL
MMODET_TT :="Enables the MultiMonitor Program"
TBARTOG_TT :="Disables and hides the windows taskbar during gameplay"
LCLcP_TT :="Localize"
LCLeP_TT :="Localize"
CENeP_TT :="Centralize"
CENcP_TT :="Centralize"
BGP_Enable_TT := "Enables the Borderless Gaming Program"
BGP_TE_TT :="Kills the windowing program upon exiting a game."
BGM_ProgB_TT :=" ''B''orderless''G''aming''P''rogram`nFile-Seletion dialog box for a borderless windowing program"
BGP_TU_TT :="Kills the windowing program if not enabled for a game when launching."
Borderless_Gaming_ProgramT_TT :="The program used to manage and control the display of games as borderless windowed programs`n Right_Click to Edit or propagate the selected item"
ButtonClear_TT :="clears the current queued it"
ButtonCreate_TT :="creates profiles for selected items in the current queued"
CenGM_TT := ": CENTRALIZED :`n Each configuration will refer to this singular game's monitor config-file path as defined.`n: UNCHECKED :`n Component will be copied to the profile folder."
CenJAL_TT := ": CENTRALIZED :`n Each configuration will refer to this singular file for each game's JAL program.`n: UNCHECKED :`n Component will be copied to the profile folder."
CenJBE_TT := ": CENTRALIZED :`n Each configuration will refer to this singular file for each game's JBE program.`n: UNCHECKED :`n Component will be copied to the profile folder."
CenKBM_TT := ": CENTRALIZED :`n Each configuration will refer to this singular file for each game's keyboard-mapper.`n: UNCHECKED :`n Component will be copied to the profile folder."
CenMC_TT := ": CENTRALIZED :`n Each configuration will refer to this singular file for the mediaCenter joystick config-file.`n:UNCHECKED :`n Component will be copied to the profile folder."
CenMM_TT := ": CENTRALIZED :`n Each configuration will refer to this singular file for each the mediaCenter monitor config-file.`n: UNCHECKED :`n Component will be copied to the profile folder."
CenPL1_TT := ": CENTRALIZED :`n Each configuration will refer to this singular file for each game's Player 1 Joystick config-file.`n: UNCHECKED :`n Component will be copied to the profile folder."
CenPL2_TT := ": CENTRALIZED :`n Each configuration will refer to this singular file for each game's Player 2 Joystick config-file`n: UNCHECKED :`n Component will be copied to the profile folder."
CenPRE_TT := ": CENTRALIZED :`n Each configuration will refer to this singular file for each game's PRE-execution programs/scripts.`n: UNCHECKED :`n Component will be copied to the profile folder."
CenPST_TT := ": CENTRALIZED :`n Each configuration will refer to this singular file for each game's POST-execution programs/scripts`n: UNCHECKED :`n Component will be copied to the profile folder."
CENTRLCKB_TT :="Joystick profiles, monitor configs and pre/post scritps are ''centralized'' as defined in the GUI `nand not copied to each profile folder."
CREFLD_TT :="Creates the profile folder"
PACKAGE_TT :="Enables supporting programs to be deployed to The Game's Installation Folder.`nChecks for executables and scripts,and *(if needed)* copies them with the supporting files to the GAME's intallation path`n***WARNING***`n`nThis is an expensive option and may add a significant increase to a Game's installation size"
MMResDR_TT :="Default Scaling"
MMResSR_TT :="Stretched Scaling"
MMResTR_TT :="Centered Scaling"
ToolTips_TT :="Displays the current process as a tool-tip during game-launch"
DDINCLD_TT :="Digital Distribution System"
REMEXCL_TT :="Removes the currently visable path in the dropdown"
DELPOSTAPP_TT :="removes the currently selected post-program"
DELPREAPP_TT :="removes the currently selected pre-program"
EnableLogging_TT :="enables logging"
EXCLUDE_DirectoryT_TT :="Excluded Directory"
Game_DirB_TT :=" OUTPUT`nThe location where shortcuts will be created"
GAME_DirectoryT_TT :="the current shortcut directory"
Game_ProfB_TT :=" ''G''ame ''P''rofiles ''D''irectory`nSets the directory where profiles will be created"
GAME_ProfilesT_TT :="the profiles directory"
GMCONF_TT :="Creates the configuration files"
GMJOY_TT :="creates the joystick profiles"
GMLNK_TT :="creates the shortcuts"
Hide_TaskBar_TT :="Hides the windows taskbar while game is running"
INCLALTS_TT :="Alternate versions of a game will be created as alternates in a subfolder of the profile."
IncludedD_TT :="Include games from digital distributor to include"
JALWAIT_TT :="waits for the program to exit"
JAL_ProgB_TT :=" ''J''ust ''A''fter ''L''aunch`nAssign a program to run after the game is launched`n* (good for trainers or executable-aware programs.)"
JAL_RC_TT :="disable or download and assign a program after launch"
JBEWAIT_TT :="waits for the program to exit"
JBE_ProgB_TT :=" ''J''ust ''B''efore ''E''xit`n Assign a program to run prior to executable termination"
JBE_RC_TT :="disable or download and assign an executable prior to termination "
JustAfterLaunchT_TT :="a program after launch`n Right_Click to Edit or propagate the selected item"
JustBeforeExitT_TT :="program to run prior to executable termination`n Right_Click to Edit or propagate the selected item"
KBM_RC_TT :="disable or download and assign a supported keymapper`n(antimicro/JoyXoff/xpadder/...)"
Keyboard_MapB_TT :=" ''K''ey''B''oard ''M''apper`nAssigns the keymapper`n(antimicro/JoyXoff/xpadder/...)"
Keyboard_MapperT_TT :="the current keyboard mapper`n(supported mappers are auto-scripted '~_!.cmd')`n Right_Click to Edit or propagate the selected item"
KILLCHK_TT :="ancilary and executable-subprocess are terminated upon exiting the game"
Localize_TT :="Sets the profile folder to`n the game's installation folder`n* (not recommended) *`n"
MediaCenter_TemplateT_TT :="the keymapper's configuration-template file for the Mediacenter/Frontend`n Right_Click to Edit or propagate the selected item"
MediaCenter_ProfB_TT :=" ''M''edia''C''enter ''P''rofile`nMediaCenter Template File Selection"
MMT_RC_TT :="disable or download and assign the multimonitor program"
MM_Game_CfgB_TT :=" ''G''ame ''M''onitor ''C''onfig`nSelect the multimonitor configuration template file used for games"
MM_MediaCenter_CfgB_TT :=" ''D''esktop ''M''onitor ''C''onfig`nSelect the multimonitor configuration template file used for the MediaCenter/Frontend"
MM_ToolB_TT :=" ''M''ulti''M''onitor''T''ool`nAssigns the multimonitor executable"
MM_Game_ConfigT_TT :="the multimonitor game-configuration template file`n Right_Click to Edit or propagate the selected item"
MM_MediaCenter_ConfigT_TT :="the MediaCenter/Frontend configuration template file`n Right_Click to Edit or propagate the selected item"
MultiMonitor_ToolT_TT :="the multimonitor program`n Right_Click to Edit or propagate the selected item"
MyListView_TT :="The current queue`n The fields marked with ''y'' may be edited to ''1'' for ''on''`n and ''n'' for ''off'' or ''Ø''`n The fields marked with ''<'' may be edited to the path to any file as an override`n (.cmd,.bat,.ps1,.psm1,.vb,.vbs,.vbe,.wsf,.wse,.sh,.tsch) script files obey localization."
NAMECHK_TT :="Matches guessed names at steam database."
NETCHK_TT :="Scrapes game-details from the steampowered api and PCGamingWiki databases.`nRight Click to reset the Lookup-Table"
Net_Check_TT :="Queries internet Databases to aquire save and configuration locations."
OPNLOG_TT :="opens the log file for this program"
OVERWRT_TT :="overwrite and recreate settings`nExisting configuration files *WILL* be overwritten"
Player1_TempB_TT :=" ''P''''L''ayer ''1''`nsets the keymapper's configuration-template file for Player 1"
Player2_TempB_TT :=" ''P''''L''ayer ''2''`nsets the keymapper's configuration-template file for Player 2"
Player1_TemplateT_TT :="the keymapper's configuration-template for Player 1`n Right_Click to Edit or propagate the selected item"
Player2_TemplateT_TT :="the keymapper's configuration-template file for Player 2`n Right_Click to Edit or propagate the selected item"
POPULATE_TT :="Searches for games or loads the last queue"
POSTAPP_TT :="Assign a program to run after the game has exited"
PostWait_TT :="Waits for the currently selected post-program to exit"
POST_RC_TT :="disable or download and Assign a program to run after the game has exited"
PREAPP_TT :="Assign a program to run before the game is launched"
POSTDDT_TT :="Order of execution."
EXCL_DirB_TT :=" ''EXC''lude`nAdds directory to exclude from the search"
PostDD_TT :="the currently selected post-program`n* ( ><ThisProg>< )`n Right_Click to Edit or propagate the selected item"
PREDD_TT :="the currently selected pre-program`n* ( ><ThisProg>< ) *`n Right_Click to Edit or propagate the selected item"
PREDD_TT :="the currently selected pre-program`n* ( ><ThisProg>< )"
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
SOURCE_DirB_TT :=" ''S''ou''R''''C''e`nAdd a directory containing the root of game-installation/s."
SOURCE_DirectoryT_TT :="the current source directory`n Right_Click to Edit or propagate the selected item"
UPDTSC_TT :="creates new profile/configurations and updates profiles with any blank/unset values`nExisting configuration files will *NOT* be overwritten"
Return
;} ######################  TT GENERATED  ################################;;
!esc::
Msgbox,4100,Quit?,Quit [RJ_PROJ]
if Msgbox,No
return

GuiClose:
Gui, Hide
/*  ;;[DEBUG32]
if instr(themen,"msstyles")
	{
		SkinForm(0)
	}
*/  ;;[DEBUG32]	
Gui, Destroy
GuiOpen := 0
return

QUITOUT:
Gui, Hide
/*  ;;[DEBUG32]
if instr(skinxtn,"msstyles")
	{
		SkinForm(0)
	}
*/  ;;[DEBUG32]	
ExitApp

Game_ProfB:
gui,submit,nohide
FileSelectFolder,GAME_ProfilesT,*%home%,3,Select Folder
if (fileexist(GAME_ProfilesT)&&(GAME_ProfilesT <> "")&& !instr(GAME_ProfilesT,"<"))
{
	if ((GAME_ProfilesT = home)or(GAME_ProfilesT = A_MyDocuments)or(GAME_ProfilesT = MYDOX))
	{
		Game_ProfilesT.= "\Profiles"
		goto, PRFGETEND
	}
	else {
		stringright,gdtst,Game_ProfilesT,2
		stringLeft,rdtst,Game_ProfilesT,2
		if ((gdtst = ":\")or instr(Game_ProfilesT,A_ProgramsCommon)or instr(Game_ProfilesT,A_DesktopCommon)or instr(Game_ProfilesT,A_Temp)or instr(Game_ProfilesT,PROGRAMFILES)or instr(Game_ProfilesT,XPRGFLS)or(Game_ProfilesT = USRPRF)or instr(Game_ProfilesT,A_AppDataCommon)or(Game_ProfilesT = A_AppData)or(Game_ProfilesT = LDATA))
			{
				Msgbox,4356,Problematic Folder Choice,     %Game_ProfilesT%`n       is an unwise folder choice.`nAre you sure you want to continue?`n`nThe directory "%Game_ProfilesT%\Profiles" will be created.
				ifMsgbox, Yes
					{
						Game_ProfilesT= %Game_ProfilesT%\Profiles
						goto, PRFGETEND
					}
				goto, Game_ProfB
			}
		if (instr(Game_ProfilesT,SYSTMRT)or(Game_ProfilesT = USERRT))
		{
			MsgBox,4096,Invalid Folder Choice,%Game_ProfilesT% is an invalid folder.`n Please select a different Folder.,5
			goto, Game_ProfB
		}
	}
	PRFGETEND:
	GAME_Profiles= %GAME_ProfilesT%
	iniwrite,%GAME_Profiles%,%RJDBINI%,GENERAL,GAME_Profiles
	stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,All
	guicontrol,,GAME_ProfilesT,%GAME_ProfilesT%
}
else {
	if ((Game_Profiles = "")or !fileExist(Game_Profiles))
		{
			stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,All
			guicontrol,,GAME_ProfilesT,<GAME_Profiles>
		}
}
return
Game_DirB:
gui,submit,nohide
FileSelectFolder,GAME_DirectoryT,*%home%,3,Select Folder for Launchers
if (fileexist(GAME_DirectoryT)&&(GAME_DirectoryT <> "")&& !instr(GAME_DirectoryT,"<"))
{
	if ((Game_DirectoryT = home)or(Game_DirectoryT = A_MyDocuments)or(Game_DirectoryT = MYDOX))
	{
		Game_DirectoryT.= "\Launchers"
		goto, LNCHGETEND
	}
	else {
		stringright,gdtst,Game_DirectoryT,2
		stringLeft,rdtst,Game_DirectoryT,2
		if ((gdtst = ":\")or instr(Game_DirectoryT,A_ProgramsCommon)or instr(Game_DirectoryT,A_DesktopCommon)or instr(Game_DirectoryT,A_Temp)or instr(Game_DirectoryT,PROGRAMFILES)or instr(Game_DirectoryT,XPRGFLS)or(Game_DirectoryT = USRPRF)or instr(Game_DirectoryT,A_AppDataCommon)or(Game_DirectoryT = A_AppData)or(Game_DirectoryT = LDATA))
			{
				Msgbox,4356,Problematic Folder Choice,     %Game_DirectoryT%`n       is an unwise folder choice.`nAre you sure you want to continue?`n`nThe directory "%Game_DirectoryT%\Launchers" will be created.
				ifMsgbox, Yes
					{
						Game_DirectoryT= %Game_DirectoryT%\Launchers
						goto, LNCHGETEND
					}
				goto, Game_DirB
			}
		if (instr(Game_DirectoryT,SYSTMRT)or(Game_DirectoryT = USERRT))
		{
			MsgBox,4096,Invalid Folder Choice,%Game_DirectoryT% is an invalid folder.`n Please select a different Folder.,5
			goto, Game_DirB
		}
	}
	LNCHGETEND:
	Game_Directory= %Game_DirectoryT%
	iniwrite,%GAME_Directory%,%RJDBINI%,GENERAL,GAME_Directory
	stringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,All
	guicontrol,,GAME_DirectoryT,%GAME_DirectoryT%
}
else {
		if ((Game_Directory = "")or !fileExist(Game_Directory))
		{
			stringreplace,Game_DirectoryT,Game_DirectoryT,%A_Space%,`%,All
			guicontrol,,Game_DirectoryT,<Game_Directory>
		}
}
return
SELALLBUT:
Blockinput, on
popui:= 1
NSOURCEDLIST:= ""
gui,submit,nohide
Gui, ListView, MyListView
LV_Modify(0, "+Check")
nwtgt= |`n
Gosub, RprseLV
Blockinput,off
return
SELNONEBUT:
gui,submit,nohide
popui:= 1
NSOURCEDLIST:= ""
Gui, ListView, MyListView
LV_Modify(0, "-check")
nwtgt= |?`n
Gosub, RprseLV
Blockinput,off
return
RPRSELV:
nrplsrl=       
RowNumber:= 0                  
Gui, ListView, MyListView
LV_Modify(RowNumber, "Select")
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber
	{
		break
	}
	alla=
	allb=
	allc=
	alld=
	alle=%A_Space%
	allf=y
	allg=<
	allh=<
	alli=<
	allj=y
	allk=<
	alll=<
	allm=<
	alln=<
	allo=y
	allp=y
	allq=<
	allr=0
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
	nrplsrl.= alla . "|" . allb . "|" . allc . "|" . alld . "|" . alle . "|" . allf . "|" . allg . "|" . allh . "|" . alli . "|" . allj . "|" . allk . "|" . alll . "|" . allm . "|" . alln . "|" . allo . "|" . allp . "|" . allq . "|" . allr . nwtgt
}
SOURCEDLIST:= nrplsrl    
filedelete,%SRCFILE%
fileappend,%SOURCEDLIST%,%SRCFILE%,UTF-8
NSOURCEDLIST= %SOURCEDLIST%
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
	Loop,parse,ORIGIN_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	Loop,parse,Steam_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	Loop,parse,GOG_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	Loop,parse,ITCH_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	Loop,parse,AMAZON_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	Loop,parse,XCLOUD_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	Loop,parse,XBox_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	Loop,parse,Battle_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	Loop,parse,EPIC_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	Loop,parse,EA_Directory,|
	{
		if instr(Exclude_DirectoryT,A_LoopField)
		{
			goto, AddExcl
		}
	}
	SB_SetText("The selected directory is not a subdirectory of an existing source dir")
	return
	AddExcl:
	Exclude_Fldr= %Exclude_DirectoryT%
	IniRead,EXCDIRS,%RJDBINI%,GENERAL,Exclude_Directory
	Exclude_Directory:= ""
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
		Exclude_Directory.= pkrs . "|"
	}
	Exclude_Directory.= Exclude_DirectoryT . "|"
	iniwrite,%Exclude_Directory%,%RJDBINI%,GENERAL,Exclude_Directory
	guicontrol,,Exclude_DirectoryT,|%Exclude_Fldr%||%Exclude_Directory%
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
prglp:= ProgramFiles . "|" . Programfilesx86 . "|" . binhome
Loop,parse,MAPCFGS,|
{
	gnm:= A_LoopField
	abb:= % %gnm%_executable
	if (abb = "")
	{
		lkgn:= gnm . "\" . gnm . ".exe"
		Loop,parse,prglp,|
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
GUIMSG:= ""
for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
{
	btt(GUIMSG,,,,"Style2",{Transparent:v})
	Sleep, 30
}
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
OpenCloudSave_Prog:
if (exedpl = 1)
	{
		return
	}
ADMNV:= ""
if (ASADMIN = 1)
	{
		ADMNV:= "/RunAsAdmin" . A_Space
	}
if (butrclick = "POSTAPP")
	{
		MsgBox,4096,OpenCloudSave CloudBackup,OpenCloudSave Query
		POSTAPPF:= home . "\OpenCloudSave_.cmd"
		filedelete,%POSTAPPF%
		Loop,parse,GUIVARS,|
			{
				guicontrol,disable,%A_LoopField%
			}
		gosub,opencloudsaveReturn
		gosub, POSTAPP
	}
if (butrclick = "PREAPP")
	{
		MsgBox,4096,OpenCloudSave CloudBackup,OpenCloudSave Query
		PREAPPF:= home . "\_OpenCloudSave.cmd"
		filedelete,%PREAPPF%
		Loop,parse,GUIVARS,|
			{
				guicontrol,disable,%A_LoopField%
			}
		gosub,opencloudsaveReturn
		gosub, PREAPP
	}
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
	}
mmtrc:= ""
return
ludusavi_Prog:
if (exedpl = 1)
	{
		return
	}
ADMNV:= ""
if (ASADMIN = 1)
	{
		ADMNV:= "/RunAsAdmin" . A_Space
	}
if (butrclick = "POSTAPP")
	{
		MsgBox,4096,ludusavi CloudBackup,ludusavi Query
		POSTAPPF:= home . "\ludusavi_.cmd"
		filedelete,%POSTAPPF%
		Loop,parse,GUIVARS,|
			{
				guicontrol,disable,%A_LoopField%
			}
		gosub,ludusaviReturn
		gosub, POSTAPP
	}
if (butrclick = "PREAPP")
{
	MsgBox,4096,ludusavi CloudBackup,ludusavi Query
	PREAPPF:= home . "\_ludusavi.cmd"
	filedelete,%PREAPPF%
	Loop,parse,GUIVARS,|
		{
			guicontrol,disable,%A_LoopField%
		}
	gosub,ludusaviReturn
	gosub, PREAPP
}
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
	}
mmtrc:= ""
return
RCLONE_Prog:
if (exedpl = 1)
	{
		return
	}
ADMNV:= ""
if (ASADMIN = 1)
	{
		ADMNV:= "/RunAsAdmin" . A_Space
	}
if (butrclick = "POSTAPP")
{
	MsgBox,4096,rclone CloudBackup,rclone setup is not automagic yet
	POSTAPPF:= home . "\post_rclone.cmd"
	rclf=%POSTAPPF%
	filedelete,%POSTAPPF%
	Loop,parse,GUIVARS,|
		{
			guicontrol,disable,%A_LoopField%
		}
	gosub,rcloneReturn
	gosub, POSTAPP
}
if (butrclick = "PREAPP")
{
	MsgBox,4096,rclone CloudBackup,rclone setup is not automagic yet
	PREAPPF:= home . "\pre_rclone.cmd"
	filedelete,%PREAPPF%
	rclf=%PREAPPF%
	Loop,parse,GUIVARS,|
		{
			guicontrol,disable,%A_LoopField%
		}
	gosub,rcloneReturn
	gosub, PREAPP
}
Loop,parse,GUIVARS,|
{
	guicontrol,enable,%A_LoopField%
}
mmtrc:= ""
return
SYN_Prog:
if (exedpl = 1)
{
	return
}
ADMNV:= ""
if (ASADMIN = 1)
{
	ADMNV:= "/RunAsAdmin" . A_Space
}
if (butrclick = "POSTAPP")
{
	MsgBox,4096,Syncthing CloudBackup,Syncthing Query
	POSTAPPF:= home . "\SyncThing_.cmd"
	filedelete,%POSTAPPF%
	Loop,parse,GUIVARS,|
		{
			guicontrol,disable,%A_LoopField%
		}
	gosub,DeviceReturn
	gosub, POSTAPP
}
if (butrclick = "PREAPP")
{
	MsgBox,4096,Syncthing CloudBackup,Syncthing Query
	PREAPPF:= home . "\_SyncThing.cmd"
	filedelete,%PREAPPF%
	Loop,parse,GUIVARS,|
		{
			guicontrol,disable,%A_LoopField%
		}
	gosub,DeviceReturn
	gosub, PREAPP
}
Loop,parse,GUIVARS,|
{
	guicontrol,enable,%A_LoopField%
}
mmtrc:= ""
return
SVV_Prog:
if (exedpl = 1)
{
	return
}
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
DCPROG:
if (exedpl = 1)
	{
		return
	}
ADMNV:= ""
if (ASADMIN = 1)
	{
		ADMNV:= "/RunAsAdmin" . A_Space
	}
filedelete,%home%\cv.xml
SB_SetText("Querying Monitor Devices")
RunWait, "%MultiMonitor_Tool%" -create="%home%\cv.xml",%home%,hide
fileread,cv,%home%\cv.xml
vn=
Loop,parse,cv,`n`r
{
	if (A_LOopfield = "")
		{
			continue
		}
	kv= %A_LoopField%
	if (kv = "</monitor>")
		{
			vn+=1	
			%vn%Nice= %Nice%
			%vn%Name= %Name%
			%vn%Path= %Path%
			Menu,addona,Add,%nice%`,%name%`,%path%,ReinHC
			AL_NM.= name . "|"
			continue
		}
	stringsplit,en,kv,<>=
	if (en2 = "path")
		{
			Path= %en3%
			stringreplace,path,path,?,.,All
			stringreplace,path,path,&amp`;,&,All
			stringleft,path,path,40
			continue
		}
	if (en2 = "name")
		{
			if instr(en3,"\")
				{
					name=%en3%
					continue
				}
			Nice= %en3%
			continue	
		}
} 
/*
	dispx=	
	Loop,%vn%
	{	
		za:= A_Index . "Nice"
		zb:= A_Index . "Name"
		zc:= A_Index . "Path"
		va:= % za
		vb:= % zb
		vc:= % zc
		dispx:= va . "`," . vb . "`," . vc
		Menu,addona,Add,%dispx%,ReinHC
	}
*/
SB_SetText("Select your Game Monitor")
Menu, addona, Show, x64 y354
return
ReinHC:
SB_SetText("Generating Monitor Config Choices")
Loop,parse,GUIVARS,|
{
	guicontrol,disable,%A_LoopField%
}
filedelete,%home%\cv.cmd
filedelete,%home%\cv.tmp
mondev:= A_ThisMenuItem
stringsplit,tspl,mondev,`,
splitpath,MultiMonitor_Tool,,MLTMP
SB_SetText("Generating Monitor Config Script")
FileAppend,pushd "%home%"`n"%MLTMP%\dc64cmd.exe" -monitor="%tspl2%" -listmodes>"%home%\cv.tmp"`nping -n 10 127.0.0.1 > nul`nexit /b`n,%home%\cv.cmd,UTF-8-RAW
sleep,4800
SB_SetText("Executing Monitor Config Script")
Run, %comspec% /c "%home%\cv.cmd",%home%,hide
sleep,8000
if !fileExist(home . "\" . "cv.tmp")
{
	Runwait, %MLTMP%\dc64cmd.exe -monitor="%tspl2%" -listmodes>>"%home%\cv.tmp",%home%,hide
	sleep,10000
	if !fileExist(home . "\" . "cv.tmp")
	{
		Run, %comspec% /c ""%MLTMP%\dc64cmd.exe" -monitor=%tspl2% -listmodes>>"%home%\cv.tmp"",%home%,hide
		sleep,8000
	}
}
monch= %tspl2%
SB_SetText("Populating Resolution Options")
Fileread,cvtmp,%home%\cv.tmp
reslist=
ftmp=
Loop,parse,cvtmp,`n`r
{
	if (A_LoopField = "")
	{
		continue
	}
	ab5=	
	lk= %A_LoopField%	
	stringsplit,ab,lk,%A_Space%%A_Tab%
	ftmp.= ab1 . " X " . ab2 . A_Space . ab4 . "hz" . A_Space . ab5 .  "`n"
	if !instr(reslist,ab1 . " X " . ab2)
	{
		reslist.= ab1 . " X " . ab2 . "|"
		continue						
	}
}
reslist.= "|" . ab1 . " X " . ab2	
Sort,reslist,F RevDir D|		
GuiControl,hide,MM_Game_ConfigT	
GuiControl,show,MMResDD	
GuiControl,show,MMResHD	
GuiControl,show,MMResDR	
GuiControl,show,MMResXX	
GuiControl,show,MMResTX	
GuiControl,show,MMResB	
GuiControl,,MMResDD,|%reslist%
gosub, MMResDD
SB_SetText("Select A Resolution and refresh-rate.  Strech or Center is optional")
return
MMPROG:
if (exedpl = 1)
{
	return
}
SB_SetText("Querying Monitor Devices")
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
SB_SetText("Select Game Monitor")
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
SB_SetText("Generating Monitor Resolution Choices")
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
				if ((resadx >= 1920)&&(resady >= 1080))
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
SB_SetText("Select a Monitor Resolution")
Menu, addonh, Show,x64 y354
return
TeinHC:
SB_SetText("Creating a Monitor Configuration File ")
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
SB_SetText("Monitor Configuration File Created")
return
openCloudSaveReturn:
fileappend,echo off`n,%rclf%,UTF-8
fileappend,%openCloudSave% [commands]`n,%rclf%
return
syncthingReturn:
fileappend,echo off`n,%rclf%,UTF-8
fileappend,%syncthing% [commands]`n,%rclf%
return
ludusaviReturn:
fileappend,echo off`n,%rclf%,UTF-8
fileappend,%ludusavi% [commands]`n,%rclf%
return
rcloneReturn:
fileappend,echo off`n,%rclf%,UTF-8
fileappend,%rclone% [commands]`n,%rclf%
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
iniwrite,%A_SPace%,%RJDBINI%,CONFIG,MMSAVE
iniwrite,%A_SPace%,%RJDBINI%,CONFIG,MMLOAD
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
MultiMonitor_ToolT=
MM_GAME_Config:= A_Space
MM_MediaCenter_Config:= A_Space
MMLOAD:= A_Space
MMSAVE:= A_Space
monxtn= mon
MONGT=MM
MPIter=MultimonitorTool.exe|dc2.exe
Loop,parse,MPIter,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		if fileExist(A_ProgramFiles . "\" . A_LoopField)
			{
				MultiMonitor_Tool= %A_ProgramFiles%
				MultiMonitor_ToolT= %A_ProgramFiles%
			}
		if fileexist(A_ProgramFiles . "\" . A_LoopFIeld)
			{
				MultiMonitor_Tool= %A_ProgramFiles%\%A_LoopField%
			}
		if fileexist(A_ProgramFilesx86 . "\Nirsoft\x64\" . A_LoopFIeld)
			{
				MultiMonitor_Tool= %A_ProgramFilesx86%\Nirsoft\x64\%A_LoopFIeld%
				MultiMonitor_ToolT= %A_ProgramFilesx86%\Nirsoft\x64\%A_LoopFIeld%
			}
		if fileexist(binhome . "\" . A_LoopField)
			{
				MultiMonitor_Tool= %binhome%\%A_LoopFIeld%
				MultiMonitor_ToolT= %binhome%\%A_LoopFIeld%
			}
	}
if instr(MultiMonitor_Tool,"multimonitortool.exe")
{
	iniwrite,%MultiMonitor_Tool%,%RJDBINI%,GENERAL,MultiMonitor_Tool
	MMLOAD:= "/loadconfig "
	MMSAVE:= "/saveconfig "
	monxtn= mon
	MONGT=MM			
}
if instr(MultiMonitor_Tool,"dc2.exe")
{
	iniwrite,%MultiMonitor_Tool%,%RJDBINI%,GENERAL,MultiMonitor_Tool
	splitpath,MultiMonitor_Tool,,MMTPTH
	Display_ChangerCMD= %MMTPTH%\dc64cmd.exe
	if fileexist(Display_ChangerCMD)
	{
		iniwrite,%Display_ChangerCMD%,%RJDBINI%,GENERAL,Display_Changer
	}
	MMLOAD:= "-configure="
	MMSAVE:= "-create="
	monxtn= xml
	MONGT=DC
}
if (MultiMonitor_ToolT <> "")
{
	if fileexist(home . "\DesktopMonitors." . monxtn)
	{
		MM_MediaCenter_Config= %home%\DesktopMonitors.%monxtn%
	}
	if fileexist(home . "\GameMonitors." . monxtn)
	{
		MM_GAME_Config= %home%\GameMonitors.%monxtn%
	}
	iniwrite,%MultiMonitor_Tool%,%RJDBINI%,GENERAL,MultiMonitor_Tool
	iniwrite,%MM_GAME_Config%,%RJDBINI%,CONFIG,MM_GAME_Config
	iniwrite,%MM_MediaCenter_Config%,%RJDBINI%,CONFIG,MM_MediaCenter_Config
	guicontrol,,MultiMonitor_ToolT,%MultiMontior_Tool%
	guicontrol,,MM_Game_Config,%MM_Game_Config%
	guicontrol,,MM_MediaCenter_Config,%MM_MediaCenter_Config%
	iniwrite,%MMLOAD%,%RJDBINI%,GENERAL,MMLOAD
	iniwrite,%MMSAVE%,%RJDBINI%,GENERAL,MMSAVE
	if (fileexist(MM_Game_Config)&& fileexist(MM_MediaCenter_Config)&& fileExist(MultiMonitor_Tool))
	{
		iniwrite,1,%RJDBINI%,GENERAL,MonitorMode
	}
}
return
syncthing_Toolb:
iniwrite,%syncthing%,%RJDBINI%,GENERAL,syncthing
return
rclone_Toolb:
iniwrite,%rclone%,%RJDBINI%,GENERAL,rclone
return
ludusavi_Toolb:
iniwrite,%ludusavi%,%RJDBINI%,GENERAL,ludusavi
return
OpenCloudSave_Toolb:
iniwrite,%OpenCloudSave%,%RJDBINI%,GENERAL,OpenCloudSave
return
MM_ToolB:
gui,submit,nohide
if (dchk = "")
	{
		MultiMonitor_ToolT:= ""
		FileSelectFile,MultiMonitor_ToolT,3,%binhome%,Select File,multimonitor*.exe;dc2.exe
	}
dchk:= ""
if ((MultiMonitor_ToolT <> "")&& !instr(MultiMonitor_ToolT,"<"))
	{
		MultiMonitor_Tool= %MultiMonitor_ToolT%
		if instr(MultiMonitor_Tool,"dc2.exe")
			{
				splitpath,MultiMonitor_Tool,,MMTPTH
				Display_ChangerCMD= %MMTPTH%\dc64cmd.exe
				if fileexist(Display_ChangerCMD)
					{
						iniwrite,%Display_ChangerCMD%,%RJDBINI%,GENERAL,Display_Changer
					}
				MMLOAD:= "-configure="
				MMSAVE:= "-create="
				monxtn= xml
				MONGT=DC
			}
		if instr(MultiMonitor_Tool,"multimonitortool.exe")
			{
				MMLOAD:= "/loadconfig "
				MMSAVE:= "/saveconfig "
				monxtn= mon
				MONGT=MM			
			}
		iniwrite,%MultiMonitor_Tool%,%RJDBINI%,GENERAL,MultiMonitor_Tool
		iniwrite,%MMLOAD%,%RJDBINI%,GENERAL,MMLOAD
		iniwrite,%MMSAVE%,%RJDBINI%,GENERAL,MMSAVE
	}
else {
	guicontrol,,MultiMonitor_ToolT,
	iniwrite,0,%RJDBINI%,GENERAL,MonitorMode
	return
}
guicontrol,,MultiMonitor_ToolT,%MultiMonitor_Tool%
if ((MM_Mediacenter_Config = "")&& instr(MultiMonitor_ToolT,"MultiMonitorTool.exe")or instr(MultiMonitor_ToolT,"dc2.exe"))
	{
		MMSAVE:= "/SaveConfig "
		MMLOAD:= "/SaveConfig "
		monxtn= mon
		MONGT=MM
		if instr(MultiMonitor_ToolT,"dc2.exe")
			{
				splitpath,MultiMonitor_Tool,,MMTPTH
				Display_ChangerCMD= %MMTPTH%\dc64cmd.exe
				MMSAVE:= "-create="
				MMLOAD:= "-configure="
				monxtn= xml
				MONGT=DC
			}
		if (exedpl <> 1)
			{
				msgbox,4100,Setup,Setup the MediaCenter Monitor Profile now?
				ifmsgbox,yes
					{
						gosub, MMSETUPD
					}
			}
	}
if ((MM_GAME_Config = "")&& instr(MultiMonitor_Tool,"MultiMonitorTool.exe")or instr(MultiMonitor_Tool,"dc2.exe"))
{
	if (exedpl <> 1)
	{
		msgbox,4100,Setup,Setup the Game Monitor Profile now?`nSelect the game-monitor in the dropdown menu
		ifmsgbox,yes
		{
			gosub, %MONGT%PROG
		}
	}
}
if (fileexist(MM_Game_Config)&& fileexist(MM_MediaCenter_Config)&& fileExist(MultiMonitor_ToolT))
{
	MMLOAD:= "/loadconfig "
	MMSAVE:= "/saveconfig "
	monxtn= mon
	MONGT=MM
	if instr(MultiMonitor_ToolT,"dc2.exe")
	{
		splitpath,MultiMonitor_Tool,,MMTPTH
		Display_ChangerCMD= %MMTPTH%\dc64cmd.exe
		MMLOAD:= "-configure="
		MMSAVE:= "-create="
		monxtn= xml
		MONGT=DC
	}
	iniwrite,2,%RJDBINI%,GENERAL,MonitorMode
	guicontrol,,MultiMontior_ToolT,%MultiMontior_Tool%
	guicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_Config%
	guicontrol,,MM_Game_ConfigT,%MM_Game_Config%
	iniwrite,%MMLOAD%,%RJDBINI%,GENERAL,MMLOAD
	iniwrite,%MMSAVE%,%RJDBINI%,GENERAL,MMSAVE
}
return
MMResDD:
gui,submit,nohide
GuiControl,,MMResDR,1
GuiControl,hide,MMResTR	
GuiControl,hide,MMResSR	
guicontrolget,MMResDD,,MMRESDD
stringreplace,MMResPP,MMResDD,%A_Space%,,All
stringsplit,MMResP,MMResPP,X
hzlist=
Loop,parse,cvtmp,`n`r
{
	if (A_LoopField = "")
	{
		continue
	}
	ab5=	
	lk= %A_LoopField%	
	stringsplit,ab,lk,%A_Space%%A_Tab%
	if ((ab1 = MMResP1)&& (ab2 = MMResP2)&& !instr(hzlist,ab4))
	{
		hzlist.= ab4 . "|"
		continue						
	}
}
hzlist.= "|" . ab4
Sort,hzlist,F RevDir D|
if instr(ftmp,MMResDD . A_Space . ab4 . "hz" . A_Space . "center")
{
	GuiControl,show,MMResTR	
}
if instr(ftmp,MMResDD . A_Space . ab4 . "hz" . A_Space . "stretch")
{
	GuiControl,show,MMResSR	
}
guicontrol,,MMResHD,|%hzlist%
gosub, MMResHD
return	
MMResHD:
gui,submit,nohide
GuiControl,hide,MMResTR	
GuiControl,hide,MMResSR
GuiControl,,MMResDR,1
guicontrolget,MMResDD,,MMRESDD
guicontrolget,MMResHD,,MMRESHD
if instr(ftmp,MMResDD . A_Space . MMRESHD . "hz" . A_Space . "center")
{
	GuiControl,show,MMResTR	
}
if instr(ftmp,MMResDD . A_Space . MMRESHD . "hz" . A_Space . "stretch")
{
	GuiControl,show,MMResSR	
}
gui,submit,nohide
return	
MMResDR:
gui,submit,nohide
MMResTR:
gui,submit,nohide
MMResSR:
gui,submit,nohide
Return
MMResB:
Blockinput,on
gui,submit,nohide
SB_SetText("Querying Monitor Devices")
guicontrolget,MMResHD,,MMRESHD
guicontrolget,MMResDD,,MMRESDD
guicontrolget,MMResDR,,MMRESDR
guicontrolget,MMResSR,,MMRESSR
guicontrolget,MMResTR,,MMRESTR
if (MMresDR = 1)
{
}
GuiControl,hide,MMResDD	
GuiControl,hide,MMResHD	
GuiControl,hide,MMResXX	
GuiControl,hide,MMResTX	
GuiControl,hide,MMResDR	
GuiControl,hide,MMResTR	
GuiControl,hide,MMResSR	
GuiControl,hide,MMResB	
monxtn= xml
stringreplace,MMResPP,MMResDD,%A_Space%,,All
stringsplit,MMResP,MMResPP,X
NCDCOM:= A_Space . "-refresh=" . MMResHD
if (MMResTR = 1)
{
	NCDCOM.= A_Space . "-fixedoutput=center"
}
if (MMResSR = 1)
{
	NCDCOM.= A_Space . "-fixedoutput=stretch"
}	
Loop,parse,AL_NM,|
{
	if (A_LoopField = "")
	{
		continue
	}
	if (A_LoopField <> monch)
	{
		DCCOM.= A_Space . "-monitor=" . A_LoopField . A_Space . "-detach"
	}
}
SB_SetText("Generating Preview")
FileDelete,%home%\dcmd.cmd	
FileDelete,%home%\DCTemplate.cmd	
FileDelete,%home%\cv.xml
FileAppend,`npushd "%home%"`n"%Display_ChangerCMD%" -monitor="%monch%" -width=%MMResP1% -height=%MMResP2%%NCDCOM% -apply`n"%Display_ChangerCMD%"%DCCOM% -apply`nexit /b`n,%home%\DCTemplate.cmd,UTF-8-RAW
FileAppend,`npushd "%home%"`n"%Display_ChangerCMD%" -monitor="%monch%" -width=%MMResP1% -height=%MMResP2%%NCDCOM% -apply`nping -n 2 127.0.0.1 > nul`n"%Display_ChangerCMD%"%DCCOM% -apply`nping -n 10 127.0.0.1 > nul`nexit /b`n,%home%\dcmd.cmd,UTF-8-RAW
Sleep,4000
Run, %comspec% /c "%home%\dcmd.cmd",%home%,hide
Sleep,8000
SB_SetText("...Generating Preview....")
Runwait, "%MultiMonitor_Tool%" -create="%home%\cv.%monxtn%",%home%,hide
tooltip,`n:::::     current resolution-template for games      :::::::`n:::::::            testing           :::::::`n`ncurrent layout:`n%A_Tab%%home%\GameMonitors.xml`n:::::::::::%A_Tab%%A_Tab%:::::::::::::
Sleep,4000
SB_SetText("Setting Desktop Config")
ToolTip,
Runwait, "%MultiMonitor_Tool%" -configure="%home%\DesktopMonitors.%monxtn%",%home%,hide
Sleep,2500
Blockinput,off
SB_SetText("")
Msgbox,4100,Correct?,Did the monitor layout look correct for your games?
ifmsgbox,yes
{
	Filecopy,%home%\cv.xml,%home%\GameMonitors.xml,1
	MM_Game_Config= %home%\GameMonitors.xml
	MM_Game_ConfigT= %MM_Game_Config%MM_GAME_Config= %MM_GAME_ConfigT%
	splitpath,MM_Game_ConfigT,,,
	FileDelete,%home%\Multimonitor_Tool.cmd
	FileDelete,%home%\%MONGT%Template.cmd
	FileDelete,%home%\MonitorSwitch.cmd
	FileCopy,%MM_GAME_Config%,%home%\GameMonitors.%monxtn%
	GMMT= `npushd "`%~dp0"`nstart "[MMTLOC]"[MMLOAD]"[GAMCFGLOC]"`nexit /b`n
	FileAppend,%GMMT%,%home%\%MONGT%Template.cmd,UTF-8
	stringreplace,GMMO,GMMO,[GAMCFGLOC],%home%\GameMonitors.%monxtn%,All
	stringreplace,GMMO,GMMT,[MMTLOC],%MultiMonitor_Tool%,All
	stringreplace,GMMO,GMMO,[GAMCFGLOC],%home%\GameMonitors.%monxtn%,All
	stringreplace,GMMO,GMMO,[MMLOAD],%MMLOAD%,All
	FileAppend,%GMMO%,%home%\MonitorSwitch.cmd,UTF-8
	iniwrite,%MM_GAME_Config%,%RJDBINI%,CONFIG,MM_GAME_Config
	guicontrol,,MM_Game_ConfigT,%MM_Game_ConfigT%
	iniwrite,%MM_Game_Config%,%RJDBINI%,CONFIG,MM_Game_Config
} 
Loop,parse,GUIVARS,|
{
	guicontrol,enable,%A_LoopField%
}
GuiControl,show,MM_Game_ConfigT
return
MM_Game_CfgB:
gui,submit,nohide
guicontrolget,gmcfg,,MM_Game_ConfigT
setupmm:= ""
MMLOAD:= "/loadconfig "
MMSAVE:= "/saveconfig "
monxtn= mon
MONGT=MM
SB_SetText("Querying Monitor Devices")
if instr(MultiMonitor_ToolT,"dc2.exe")
{
	splitpath,MultiMonitor_Tool,,MMTPTH
	Display_ChangerCMD= %MMTPTH%\dc64cmd.exe
	MMLOAD:= "-configure="
	MMSAVE:= "-create="
	monxtn= xml
	MONGT=DC
}
if !fileexist(gmcfg)
{
	msgbox,4100,Setup,Setup the Multimonitor Tool now?
	ifmsgbox,yes
	{
		gosub, %MONGT%PROG
		setupmm= 1
	}
}
if ((setupmm = "")or !fileexist(CFGDIR . "\" . "GameMonitors." . monxtn))
{
	FileSelectFile,MM_GAME_ConfigT,35,,Select File,*.cfg; *.mon; *.xml
	if ((MM_GAME_ConfigT <> "")&& !instr(MM_GAME_ConfigT,"<"))
	{
		MM_GAME_Config= %MM_GAME_ConfigT%
		splitpath,MM_Game_ConfigT,,,
		FileDelete,%home%\Multimonitor_Tool.cmd
		FileDelete,%home%\%MONGT%Template.cmd
		FileDelete,%home%\MonitorSwitch.cmd
		FileCopy,%MM_GAME_Config%,%home%\GameMonitors.%monxtn%
		GMMT= `npushd "`%~dp0"`nstart "[MMTLOC]"[MMLOAD]"[GAMCFGLOC]"`nexit /b`n
		FileAppend,%GMMT%,%home%\%MONGT%Template.cmd
		stringreplace,GMMO,GMMO,[GAMCFGLOC],%home%\GameMonitors.%monxtn%,All
		stringreplace,GMMO,GMMT,[MMTLOC],%MultiMonitor_Tool%,All
		stringreplace,GMMO,GMMO,[GAMCFGLOC],%home%\GameMonitors.%monxtn%,All
		stringreplace,GMMO,GMMO,[MMLOAD],%MMLOAD%,All
		FileAppend,%GMMO%,%home%\MonitorSwitch.cmd
		iniwrite,%MM_GAME_Config%,%RJDBINI%,CONFIG,MM_GAME_Config
	}
	else {
		guicontrol,,MM_GAME_ConfigT,
		SB_SetText("Cleared Game-Monitor Config Location")
		return
	}
}
if (fileexist(MM_Game_Config) && fileexist(MM_MediaCenter_Config) && fileExist(MultiMonitor_Tool))
{
	iniwrite,2,%RJDBINI%,GENERAL,MonitorMode
	guicontrol,,MultiMontior_ToolT,%MultiMontior_Tool%
	guicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_Config%
	guicontrol,,MM_Game_ConfigT,%MM_Game_Config%
}
SB_SetText("Assigned Game-Monitor Config File Location")
guicontrol,,MM_GAME_ConfigT,%MM_GAME_Config%
return
MM_MediaCenter_CfgB:
gui,submit,nohide
guicontrolget,dtcfg,,MM_MediaCenter_ConfigT
setupmm:= ""
if !fileexist(dtcfg)
{
	msgbox,4100,Setup,Setup the MediaCenter Monitors now?
	ifmsgbox,yes
	{
		gosub, MMSETUPD
		setupmm= 1
	}
}
if ((setupmm = "")or !fileexist(MM_MediaCenter_Config))
{
	FileSelectFile,MM_MediaCenter_ConfigT,35,%home%,Select File,*.cfg;*.mon;*.xml
	if ((MM_MediaCenter_ConfigT <> "")&& !instr(MM_MediaCenter_ConfigT,"<"))
	{
		MM_MediaCenter_Config= %MM_MediaCenter_ConfigT%
		FileCopy,%MM_MediaCenter_Config%,%home%,1
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
predl=<
if (JALWait = 1)
{
	predl=W<
}
if (dchk = "")
{
	JustAfterLaunchT:= ""
	FileSelectFile,JustAfterLaunchT,3,%home%,*.*
}
dchk:= ""
if ((JustAfterLaunchT <> "")&& (JustAfterLaunchT <> "Cloud_Restore"))
{
	JustAfterLaunch= %predl%%JustAfterLaunchT%
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
if (instr(POSTAPPF,"audio.cmd")or instr(POSTAPPF,"rclone.cmd")or instr(POSTAPPF,"ludusavi.cmd")or instr(POSTAPPF,"OpenCloudSave.cmd")or instr(POSTAPPF,"syncthing.cmd"))
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
						_PostList= %PostApp%
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
		guicontrol,,_PostDDT,%_PostList%
		guicontrol,,POSTDNUM,1
		guicontrol,,_POSTDNUM,1
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
if (instr(PREAPPF,"audio.cmd")or instr(PREAPPF,"rclone.cmd")or instr(PREAPPF,"ludusavi.cmd")or instr(PREAPPF,"OpenCloudSave.cmd")or instr(PREAPPF,"syncthing.cmd"))
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
						_PreList=%PREAPP%
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
		guicontrol,,_PreDDT,%_PreList%
		guicontrol,,PRETNUM,1
		guicontrol,,_PRETNUM,1
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
if !fileexist(LKUP_DB)
{
	if ((nsivk = "")or !fileexist(LKUP_DB))
	{
		Msgbox,8449,Confirm Database Lookup,### WARNING ###`nThis option may add addtional processing time`n Generate the Lookup Table?,7
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
if (fileexist(LKUP_DB)&& (NameChk = 1))
{
	iniwrite,1,%RJDBINI%,GENERAL,Name_Check
}
else {
	iniwrite,0,%RJDBINI%,GENERAL,Name_Check
	SB_SetText("Right-click to delete the lookup table database.")
}
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
guicontrol,,_postDDT,%plre1%
guicontrol,,postWAIT,%postwaitn%
guicontrol,,postDNUM,1
guicontrol,,_postDNUM,1
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
guicontrol,,_PreDDT,%plre1%
guicontrol,,PreWAIT,%prewaitn%
guicontrol,,PRETNUM,1
guicontrol,,_PRETNUM,1
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
		_PreList=%cftst2%
		iniwrite,%fbdnum%%prewl%<%cftst2%,%RJDBINI%,CONFIG,%fbdnum%_Post
		PreList.= fbdnum . prewl . "<" . cftst2 . "||"
		continue
	}
	PreList.= cftsv . "|"
}
guicontrol,,PREDD,%PreList%
guicontrol,,_PREDDT,%_PreList%
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
	guicontrol,,JALWAIT,0
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
	guicontrol,,JBEWAIT,0
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
		_postList= %cftst2%
		iniwrite,%fbdnum%%postwl%<%cftst2%,%RJDBINI%,CONFIG,%fbdnum%_post
		postList.= fbdnum . postwl . "<" . cftst2 . "||"
		continue
	}
	postList.= cftsv . "|"
}
guicontrol,,postDD,%postList%
guicontrol,,_postDDT,%_postList%
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
guicontrol,,_postDDT,%postdd%
guicontrol,,_postDNUM,%postDNUM%
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
guicontrol,,_PRETNUM,%PRETNUM%
guicontrol,,_PREDDT,%predd%
return
INITALL:
niniloc= %home%\RJDB.ini
FileDelete,%niniloc%
FileRead,INIGOT,%source%\RJDB.set
stringreplace,INIGOT,INIGOT,[LOCV],%home%,All
gosub, reWriteINI
niniloc= %home%\repos.ini
FileDelete,%niniloc%
FileRead,INIGOT,%source%\repos.set
gosub, reWriteINI
Loop,parse,STDVARS,|
{
	%A_LoopField%:= ""
}
initz= 1
if !fileexist(cacheloc)
{
	filecreatedir,%cacheloc%
}
return
ReWriteINI:
Loop, parse, INIGOT,`n`r
{
	if (A_LoopField = "")
	{
		Continue
	}
	lpab= %A_LoopField%
	stringsplit,avx,lpab,=
	stringleft,aba,lpab,1
	if (aba = "[")
	{
		cursc= %lpab%
		stringreplace,cursc,cursc,[,,All
		stringreplace,cursc,cursc,],,All
		continue
	}
	stringreplace,aval,lpab,%avx1%=,,
	iniwrite,%aval%,%niniloc%,%cursc%,%avx1%
}
Loop,parse,PAKLST,|
{
	guicontrol,,%A_LoopField%,0
	guicontrol,disable,%A_LoopField%
	guicontrol,hide,%A_LoopField%
	%A_LoopField%=			
}
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
		filedelete,%home%\GameMonitors.xml
		filedelete,%home%\DesktopMonitors.xml
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
gosub,%MONGT%PROG
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
		guicontrol,+c%KBMAPALRT%,Keyboard_MapperT
		guicontrol,+c%PLR1TALRT%,Player1_TemplateT
		guicontrol,+c%PLR2TALRT%,Player2_TemplateT
		guicontrol,+c%MCPRFALRT%,MediaCenter_TemplateT
		guicontrol,,Keyboard_MapperT,%keyboard_Mapper%
		guicontrol,,Player1_TemplateT,%Player1_Template%
		guicontrol,,Player2_TemplateT,%Player2_Template%
		guicontrol,,MediaCenter_TemplateT,%MediaCenter_Template%
	}
kbmpprt:= ""
return
ReadLBL:
acnt=
Steam_TID=
Steam_UserID=
Steam_UserTmp=
Steam_ClientID=
fileread,stmocs,%vdfile%
Loop,parse,stmocs,`r`n
{
	if (A_LoopField = "")
		{
			continue
		}
	jnm= %A_LoopField%
	stringreplace,jnm,jnm,",,All ;"
	if (jnm = "friends")
		{
			acnt= 1
			continue
		}
	if (acnt <> 1)
		{
			continue
		}
	if ((jnm <> "}") && (Steam_UserID <> ""))
		{
			Steam_TID= %jnm%
		}
	stringsplit,jnsp,jnm,%A_Space%," ;"
	if ((jnsp1 = "PersonaName")&&(Steam_UserName = "")&&(Steam_UserTmp = 1))
		{
			Steam_UserID= %Steam_TID%
			stringreplace,jnm,jnm,PersonaName,,
			Steam_UserName= %jnm%
			Steam_UserTmp= 0
			continue
		}
	if ((jnsp1 = "0")&&(Steam_UserTmp = ""))
		{
			Steam_UserTmp= 1
			continue
		}
	if (jnm = "GetEquippedProfileItemsForUser")
		{
			stringreplace,jnm,jnm,"GetEquippedProfileItemsForUser",,All
			Steam_ClientID= %jnm%
			break
		}
}
return
ReadLBC:
acnt=
fileread,stmocs,%vdfile%
Loop,parse,stmocs,`r`n
{
	if (A_LoopField = "")
		{
			continue
		}
	jnm= %A_LoopField%
	stringreplace,jnm,jnm,",,All ;"
	if (jnm = "Accounts")
		{
			acnt= 1
			continue
		}
	if (acnt - 1)
		{
			if ((jnm <> "}") && (Steam_ClientID <> ""))
				{
					Steam_ClientID= %jnm%
					break
				}
		}
}
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
			GENERIC_ROOT.= kman . "\common" . "|"
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
DDSwitch=
FileDelete,%home%\steam.db
CONCAT_ROOT:= ""
GENERIC_ROOT:= ""
Loop,parse,dralbet,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		srchdrl:= A_LoopField . ":"
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
		IncludedD=0
				;iniwrite,0,%RJDBINI%,GENERAL,IncludedD
	}
STEAM_Q:
STEAM_ROOT:= ""
RegRead, Steam_ROOT, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam,InstallPath
if (fileExist(Steam_ROOT)&& !instr(Steam_directory,Steam_ROOT))
	{
		Steam_Directory.= Steam_ROOT . "|"
		iniwrite,%Steam_Directory%,%RJDBINI%,GENERAL,Steam_Directory
		Loop,parse,Steam_Directory,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				Loop,files,%A_LoopField%\*.vdf,R
					{
						if (A_Loopfilename = "")
							{
								continue
							}
						if (A_Loopfilename = "libraryfolders.vdf")
							{
								vdfile:= A_LoopFileFullPath
								gosub, ReadLBF
										;break
							}
						if (A_LoopFilename = "localconfig.vdf")
							{
								vdfile:= A_LoopFileFullPath
								splitpath,A_LoopFileFullPath,fn,fp,
								stringreplace,steamguid,fp,%Steam_Directory%\userdata\,,
								stringreplace,steamuser,steamguid,config\localconfig.vdf,,
								gosub, ReadLBL
							}
						/*
								if (A_LoopFilename = "config.vdf")
							{
								vdfile:= A_LoopFileFullPath
								splitpath,A_LoopFileFullPath,fn,fp,
								stringreplace,steamguid,fp,%Steam_Directory%\userdata\,,
								stringreplace,steamuser,steamguid,config\config.vdf,,
								gosub, ReadLBC
							}
						*/
					}
			}
	}
else {
	if fileexist(STEAM_ROOT)
		{
			STEAM_ROOT.= "|"
		}
}
STMLKUP=
Loop,parse,dralbet,|
{
	if (A_LoopField = "")
		{
			continue
		}
	srclocd= %A_LoopField%:\
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
													iniread,_Steam_Directory,%RJDBINI%,GENERAL,Steam_Directory
													if ((_Steam_Directory < >"") && (_Steam_Directory <> "ERROR") && !instr(_Steam_Directory,A_LoopFileFullPath)&& !instr(A_LoopFileFullPath,_Steam_Directory))
														{
																	Steam_Directory.= A_loopfilefullpath . "|"
														}
													iniwrite,%Steam_Directory%,%RJDBINI%,GENERAL,Steam_Directory
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
if (DDSwitch <> "")
	{
		return
	}
GOG_Q:
GOG_ROOT:= ""
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
if (DDSwitch <> "")
{
	return
}
AMAZON_Q:
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
if (DDSwitch <> "")
{
	return
}
ORIGIN_Q:
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
ITCH_Q:
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
if (DDSwitch <> "")
	{
		return
	}
iniwrite,%ITCH_ROOT%%STEAM_ROOT%%AMZ_ROOT%%ORIGIN_ROOT%%GOG_ROOT%,%RJDBINI%,GENERAL,Exclude_Directory
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
	return
}
return
EA_Q:
Epic_Q:
XBox_Q:
XCloud_Q:
Battle_Q:
SB_SetText("coming soon!...maybe")
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
pakval= 
pkcol= cRed
PACKAGE= 0
pkcvz= hidden disabled
if (initz <> 1)
	{
		Loop,parse,PAKLST,|
			{
				iniread,an,%RJDBINI%,DEPLOYMENTS,%A_LoopField%
				pakv= %an%
				pakval+= pakv
				%A_LoopField%= %an%
			}
		if (pakval <> 0)
			{
				PACKAGE= 1
				pkckb= checked
				pkcol= cLime
				pkcvz= 
				Guicontrol,,PACKAGE,%PACKAGE%
				gosub, PACKAGE
				Loop,parse,PAKLST,|
					{
						pakiv:= % (%A_LoopField%)
						guicontrol,,%A_LoopField%,%pakiv%
						%A_LoopField%_p= 
						if (pakiv = 1)
							{
								%A_LoopField%_p= checked
							}
						guicontrol,show,%A_LoopField%
						guicontrol,enable,%A_LoopField%
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
CENTRLZ= %CENITEMS%
Loop,parse,CENITEMS,|
{
	if (A_LoopField = "")
	{
		continue
	}
	guicontrol,,%A_LoopField%,%CENTRLCKB%
	%A_LoopField%= %CENTRLCKB%
}
if (CENTRLCKB = 1)
{
	guicontrol,,Localize,0
	gosub, Localize						
	Gui, Font, cBlue 
	GuiControl, Font, CENTRLCKB
	GuiControl, Font, Localize
}
else {
	CENTRLZ:= A_Space						
	Gui, Font, cTeal
	GuiControl, Font, CENTRLCKB
	GuiControl, Font, Localize
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
return
CENKBM:
gui,submit,nohide
guicontrolget,CenKBM,,CenKBM
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenKBM = 0)
{
	stringreplace,CENTRLZ,CENTRLZ,CenKBM,,All
	Guicontrol,,_Keyboard_MapperT,<%PROFINST% Folder>
}
else {
	if !instr(CENTRLZ,"CenKBM")
	{
		CENTRLZ.= "CenKBM|"
	}
	Guicontrol,,KBPak,0
	Guicontrol,,_Keyboard_MapperT,%Keyboard_Mapper%
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenKBM = 0)
{
	guicontrol,,CENTRLCKB,0
}
return
CENPL1:
gui,submit,nohide
guicontrolget,CenPL1,,CenPL1
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPL1 = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenPL1|,,All
		Guicontrol,,_Player1_TemplateT,<%PROFINST% Folder>
	}
else {
	if !instr(CENTRLZ,"CenPL1|")
	{
		CENTRLZ.= "CenPL1|"
	}
	Guicontrol,,_Player1_TemplateT,%Player1_Template%
	Guicontrol,,PL1Pak,0
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPL1 = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CENPL2:
gui,submit,nohide
guicontrolget,CenPL2,,CenPL2
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPL2 = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenPL2|,,All
		Guicontrol,,_Player2_TemplateT,<%PROFINST% Folder>
	}
else {
	if !instr(CENTRLZ,"CenPL2|")
	{
		CENTRLZ.= "CenPL2|"
	}
	Guicontrol,,_Player2_TemplateT,%Player2_Template%
	Guicontrol,,PL2Pak,0
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPL2 = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CENMC:
gui,submit,nohide
guicontrolget,CenMC,,CenMC
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenMC = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenMC|,,All
		Guicontrol,,_MM_MediaCenter_TemplateT,<%PROFINST% Folder>
	}
else {
	if !instr(CENTRLZ,"CenMC|")
	{
		CENTRLZ.= "CenMC|"
	}
	Guicontrol,,_MM_MediaCenter_TemplateT,%MM_MediaCenter_Template%
	Guicontrol,,MCjPak,0
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenMC = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CENGM:
gui,submit,nohide
guicontrolget,CenGM,,CenGM
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
Guicontrol,,_MM_Game_ConfigT,%MM_Game_Config%
if (CenGM = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenGM|,,All
		Guicontrol,,_MM_Game_ConfigT,<%PROFINST% Folder>
	}
else {
	if !instr(CENTRLZ,"CenGM|")
		{
			CENTRLZ.= "CenGM|"
		}
	Guicontrol,,_MM_Game_ConfigT,%MM_Game_Config%
	Guicontrol,,GMPak,0
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenGM = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CENMM:
gui,submit,nohide
guicontrolget,CenMM,,CenMM
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
Guicontrol,,_MM_MediaCenter_ConfigT,%MM_MediaCenter_Config%
if (CenMM = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenMM|,,All
		Guicontrol,,_MM_MediaCenter_ConfigT,<%PROFINST% Folder>
	}
else {
	if !instr(CENTRLZ,"CenMM|")
		{
			CENTRLZ.= "CenMM|"
		}
	Guicontrol,,_MM_MediaCenter_ConfigT,%MM_MediaCenter_Config%
	Guicontrol,,DMPak,0
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenMM = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CENJAL:
gui,submit,nohide
guicontrolget,CenJAL,,CenJAL
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenJAL = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenJAL|,,All
		Guicontrol,,_JustAfterLaunchT,<%PROFINST% Folder>
	}
else {
	if !instr(CENTRLZ,"CenJAL|")
		{
			CENTRLZ.= "CenJAL|"
		}
	Guicontrol,,_JustAfterLaunchT,%JustAfterLaunchT%
	Guicontrol,,JALPak,0
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenJAL = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CENJBE:
gui,submit,nohide
guicontrolget,CenJBE,,CenJBE
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
if (CenJBE = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenJBE|,,All
		Guicontrol,,_JustBeforeExitT,<%PROFINST% Folder>
	}
else {
	if !instr(CENTRLZ,"CenJBE|")
		{
			CENTRLZ.= "CenJBE|"
		}
	Guicontrol,,_JustBeforeExitT,%JustBeforeExitT%
	Guicontrol,,JBEPak,0
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenJBE = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CENPRE:
gui,submit,nohide
guicontrolget,CenPRE,,CenPRE
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
Guicontrol,,_PREDDT,
if (CenPRE = 0)
	{
		stringreplace,CENTRLZ,CENTRLZ,CenPRE|,,All
		Guicontrol,,_PREDDT,<%PROFINST% Folder>
	}
else {
	if !instr(CENTRLZ,"CenPRE|")
		{
			CENTRLZ.= "CenPRE|"
		}
	Guicontrol,,PREPak,0
}
iniwrite,%CENTRLZ%,%RJDBINI%,GENERAL,CENTRALIZE
if (CenPRE = 0)
	{
		guicontrol,,CENTRLCKB,0
	}
return
CENPST:
gui,submit,nohide
guicontrolget,CenPST,,CenPST
iniread,CENTRLZ,%RJDBINI%,GENERAL,CENTRALIZE
Guicontrol,,_POSTDDT,
if (CenPST = 0)
{
	stringreplace,CENTRLZ,CENTRLZ,CenPST|,,All
	Guicontrol,,_POSTDDT,<%PROFINST% Folder>
}
else {
	if !instr(CENTRLZ,"CenPST|")
		{
			CENTRLZ.= "CenPST|"
		}
	Guicontrol,,PSTPak,0
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
MMSAVE:= "/SaveConfig " . A_Space
monxtn= mon
if instr(Multimonitor_Tool,"dc2.exe")
	{
		MMSAVE:= "-create="
		monxtn= xml
	}
mon_loc="%CFGDIR%\DesktopMonitors.%monxtn%"
Msgbox,,Default Desktop Config,Configure your monitor/s as you would have them for your`nMediaCenter or Desktop`nthen click "OK"
ifmsgbox,OK
	{
		FileMove,%home%\DesktopMonitors.%monxtn%,%home%\DesktopMonitors.%monxtn%.bak
		RunWait, "%multimonitor_tool%" %MMSAVE%"%mon_loc%",%home%,hide
		ifexist,%CFGDIR%\DesktopMonitors.%monxtn%
			{
				MM_MEDIACENTER_Config= %CFGDIR%\DesktopMonitors.%monxtn%
				iniwrite,%CFGDIR%\DesktopMonitors.%monxtn%,%RJDBINI%,CONFIG,MM_MEDIACENTER_Config
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
					_PostList= %dkv%
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
		snum+=1z
		%snum%_Pre= dkv
		if (snum = 1)
			{
				_PreList= %dkv%
				PreList.= dkv . "||"
				continue
			}
		PreList.= dkv . "|"
	}
}
guicontrol,,PostDD,%PostList%
guicontrol,,_PostDDT,%_PostList%
guicontrol,,PreDD,%PreList%
guicontrol,,_PreDDT,%_PreList%
Return
CANCLDBUT:
CANCLD= 1
guicontrol,disable,CANCLDBUT
Process,close,%$exeg_pid%
Return
ADDGAME:
gui,submit,NoHide
popui= 1
guicontrol,hide,REINDEX
guicontrol,show,CANCLDBUT
guicontrol,enable,CANCLDBUT      
guicontrolget,NameChk,,NameChk
FileSelectFile,Gametoadd,35,,Select a Game,*.exe;*.lnk
nFileName:= GameToAdd
splitpath,nFileName,FileNM,FilePath,FileExt,filtn
INFN= 1
Loop,parse,SOURCE_DIRECTORY,|
{
	if (A_LoopField = "")
		{
			continue
		}
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
ab=
Loop,parse,SOURCE_DIRECTORY,|
{
	if (A_LoopField = "")
		{
			continue
		}
	if instr(filepath . "\",A_Loopfield . "\")
	{
		stringlen,nb,A_LoopField
		if ((nb < ab)or(ab = ""))
			{
				TOPSCRV= %A_LoopField%
				ab= %nb%
			}
	}
}
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
    ;{;##########################################################################
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
ControlFocus,Log,[RJ_PROJ]_GUI
bsvl:= ""
INFN:= ""
SPLIT_SRC:= SOURCE_DIRECTORY . "|" . Extra_Source
fileread,stmfz,%home%\steam.db
Gui,Listview,MyListView
guicontrolget,enablelogging,,enablelogging
guicontrolget,NameChk,,NameChk
guicontrolget,IncludedD,,IncludedD
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
nb=
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
				Loop,parse,DDPRVD,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						DDLp= %A_LoopField%
						iniread,IncludedD,%RJDBINI%,GENERAL,IncludedD
						if (instr(IncludedD,DDLp) or (IncludedD = "") or (IncludedD = "ERROR"))
							{
								continue
							}
						iniread,IncludeRG,%RJDBINI%,GENERAL,%DDLp%_Directory
						if ((IncludeRG = "")or(IncludeRG = "ERROR"))
							{
								continue
							}
						Loop,parse,IncludeRG,|
						{
							if instr(A_LoopFileLongPath,A_LoopField)
								{
									stmexcl= 1
									break
								}
						}
					}
				if (stmexcl = 1)
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
				splitpath,FileName,FileNM,FilePath,FileExt,filtn,filtdrv
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
				if (nb <> "")
					{
						TOPSCR= %TOPSCRV%
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
								omitd.= filenm . "|" . simpath . "|" . "`n"
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
		Loop,Parse,NSPLIT,|
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
GUI, Show, w817 h713
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
;} ###########################   POPULATED ###################################;
RESTEAM:
dwnrej:= ""
iniread,URLFILE,%source%\repos.set,GLOBAL,STEAMJSON
save= %STM_DB%
splitpath,save,svaf,svap
Filemove,%save%,%save%.bak,R
DownloadFile(URLFILE,save,dwnovwr,True)
                ;exe_get(ARIA,URLFILE,svap,svaf,CURPID,cacheloc)
dwnovwr=False
if !fileExist(save)
	{
		Msgbox,258,,Json Download Failed,Steam Database was not downloaded.`n Try again?
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
		goto, JSONPARSED
	}
RELOOKUP:
filedelete,%LKUP_DB%
sivk=
Nsivk=
RENMD=
fileread, stfn, %STM_DB%
intl= {"applist":{"apps":[{
	entl= }]}}
	split="}`,{"
	join="`r"
	nnm=`,"name"
	nxm=`r"name"
	aid= "appid":
	nid= "name":
	ali= "applist":
	appz= "apps": [
	singq= "
			;"
	stringreplace,json,stfn,{`r,,All		;"
	stringreplace,json,json,:"",:"-",All
	stringreplace,json,json,%intl%,,All
	stringreplace,json,json,%entl%,,All
	stringreplace,json,json,%split%,%join%,All
	stringreplace,json,json,%nnm%,%nxm%,All
	stringreplace,json,json,}`,,,All
	stringreplace,json,json,}`,`r,,,All
	stringreplace,json,json,}`r,,,All
	stringreplace,json,json,]`r,,,All
	stringreplace,json,json,`,`r,,All
	stringreplace,json,json,%ali%,,All
	stringreplace,json,json,%appz%,,All
	stringreplace,json,json,%aid%,,All
	stringreplace,json,json,%nid%,,All
	stringreplace,json,json,<,,All
	stringreplace,json,json,>,,All
	stringreplace,json,json,\,,All
	stringreplace,json,json,/,-,All
	stringreplace,json,json,?,-,All
	stringreplace,json,json,*,-,All
	stringreplace,json,json,:,-,All
	stringreplace,json,json,|,-,All
	stringreplace,json,json,--,-,All
	stringreplace,json,json,",,All		;"
	stringreplace,json,json,&amp`;amp`;,&&,All
	stringreplace,json,json,&amp`;,&,All
	stringreplace,json,json,%A_Space%%A_Space%,%A_Space%,All
	stringreplace,json,json,%A_Space%%A_Space%,%A_Space%,All
	appid= 
	Loop, parse, json,`r`n
	{
		if (A_LoopField = "")
		{
			continue
		}
		if (Appid = "")
		{
			appid= %A_LoopField%
			continue
		}
		kame= %A_LoopField%
		invar= %kame%
		gosub, StripVar
		gosub, spechar
		if (RENNOS = "")
		{
			RENNOS= %invarx%
		}
		Nsivk.= "|" . kame . "|" . RENNOS . "|" . appid . "|" . RENMD . "|" . "`n"
		appid=
	}
	fileappend,%NSIVK%,%LKUP_DB%,UTF-8
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
	iniwrite,1,%RJDBINI%,GENERAL,Net_Check 
	SB_SetText("Net-Check requires an internet connection.")
	return
	SANITIZER:
	stringreplace,insan,insan,:,-,All
	SANITIZE:
	stringreplace,insan,insan,/,-,All
	stringreplace,insan,insan,?,-,All
	stringreplace,insan,insan,`,,-,All
	stringreplace,insan,insan,>,-,All
	stringreplace,insan,insan,",,All		;"
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
            ;{;#########################################################################################
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
		Loop,parse,PAKLST,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				sr= %A_LoopField%	
				guicontrolget,%A_LoopField%,,%sr%
			}
		aprc=
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
		complist:= LVGetCheckedItems("SysListView321","[RJ_PROJ]_GUI")
		fullist:= complist
		stringsplit,fullstn,fullist,`n
		gmnames:= "|"
		gmnameds:= "|"
		gmnamed:= ""
		exlist:= "|"
		stmdbfnd:= "|"
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
				GLBTRY:= 8
			}
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
						exfnm= %A_LoopField%
					}
					if (A_Index = 2)
						{
						expth= %A_LoopField%
					}
					if (A_Index = 3)
						{
						gmopts= %A_LoopField%
					}
					if (A_Index = 4)
						{
						gmargs= %A_LoopField%
					}
					if (A_Index = 5)
						{
						nameOverride= %A_LoopField%
					}
					if (A_Index = 6)
						{
						kbmovr= %A_LoopField%
					}
					if (A_Index = 7)
						{
						pl1ovr= %A_LoopField%
					}
					if (A_Index = 8)
						{
						pl2ovr= %A_LoopField%
					}
					if (A_Index = 9)
						{
						mcpovr= %A_LoopField%
					}
					if (A_Index = 10)
						{
						mmovr= %A_LoopField%
					}
					if (A_Index = 11)
						{
						gmovr= %A_LoopField%
					}
					if (A_Index = 12)
						{
						dmovr= %A_LoopField%
					}
					if (A_Index = 13)
						{
						jlovr= %A_LoopField%
					}
					if (A_Index = 14)
						{
						jbovr= %A_LoopField%
					}
					if (A_Index = 15)
						{
						preovr= %A_LoopField%
					}
					if (A_Index = 16)
						{
						pstovr= %A_LoopField%
					}
					if (A_Index = 17)
						{
						bgmovr= %A_LoopField%
					}
					if (A_Index = 18)
						{
						steamquery= %A_LoopField%
					}
					if (A_Index = 19)
						{
							ChkMode= %A_LoopField%
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
				if (((nameOverride <> "")&& (steamquery <> 0) && (steamquery <> "")) or ((nameOverride <> "") && (nameOverride <> gmnamex) && !instr(bsvl,nameOverride)))
					{
					gmnamed= %nameOverride%
					sexjnj= %nameOverride%
					njName= %nameOverride%
					exedp= %nameOverride%
					stringreplace,excp,gmnamed,%A_Space%,,All
					excn=|%excp%|
					goto, nameOVR
				}
				if (nameOverride <> "")
					{
						gmnamed= %nameOverride%
						sexjnj= %nameOverride%
						njName= %nameOverride%
						exedp= %nameOverride%
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
				sidn= %Game_Profiles%\%gmnameD%
				if (LOCALIZE = 1)
					{
						sidn= %OUTDIR%
					}
				bsvl.= gmnamed . "|"
				stringtrimright,subfldrepn,subfldrep,1
				monxtn= mon
				if (fileexist(sidn . "\" . "Game.ini") && (OVERWRT = ""))
					{
						iniread,sffb,%sidn%\Game.ini,GENERAL,Multimonitor_Tool
						if instr(sffb,"dc2.exe")
							{
								monxtn= xml
							}
					}
				else {
					iniread,sffb,%RJDBINI%,GENERAL,Multimonitor_Tool
					if instr(sffb,"dc2.exe")
						{
							monxtn= xml
						}
				}	
				sida= %sidn%
				sidb= %sidn%
				sidc= %sidn%
				sidd= %sidn%
				sidx= %sidn%
				sidy= %sidn%
				sidk= %sidn%
				sidj= %sidn%
				sidd= %sidn%
				side= %sidn%
				sidg= %sidn%
				if (KBPak = 1)
					{
						sidk= %OUTDIR%
						exedpl= 1
						if !FileExist(sidk . "\" . JMAP . "\" . JMAP . ".exe")
							{
								curemote:= "_" . JMAP . "_"
								gosub, keymapcont
							}
						exedpl= 0
					}
				if (PL1Pak = 1)
					{
						sida= %OUTDIR%
					}
				if (PL2Pak = 1)
					{
						sidb= %OUTDIR%
					}
				if (MCjPak = 1)
					{
						sidc= %OUTDIR%
					}
				if (GMPak = 1)
					{
						sidg= %OUTDIR%
						if instr(MultiMonitor_Tool,"dc2.exe")
							{
								gosub, DC2Download
							}
						if instr(MultiMonitor_Tool,"multimonitortool.exe")
							{
								gosub, MMDownload
							}
						exedpl= 0
					}
				if (DMPak = 1)
					{
						sidd= %OUTDIR%								
						if instr(MultiMonitor_Tool,"dc2.exe")
							{
								gosub, DC2Download
							}								
						if instr(MultiMonitor_Tool,"multimonitortool.exe")
							{
								gosub, MMDownload
							}
						exedpl= 0
					}
				if (JALPak = 1)
					{
						sidj= %OUTDIR%						
						if instr(JustAfterLaunch,"multimonitortool.exe")
							{
								gosub, MMDownload
							}					
						if instr(JustAfterLaunch,"dc2.exe")
							{
								gosub, DC2Download
							}					
						if instr(JustAfterLaunch,"soundvolumeview.exe")
							{
								gosub, SNDVOLVIEWDOWNLOAD
							}					
						if instr(JustAfterLaunch,"borderlessgaming")
							{
								gosub, BGM_ProgBDownload
							}					
					}
				if (JBEPak = 1)
					{
						side= %OUTDIR%			
						if instr(JustBeforeExit,"multimonitortool.exe")
							{
								gosub, MMDownload
							}					
						if instr(JustBeforeExit,"dc2.exe")
							{
								gosub, DC2Download
							}					
						if instr(JustBeforeExit,"soundvolumeview.exe")
							{
								gosub, SNDVOLVIEWDOWNLOAD
							}					
						if instr(JustBeforeExit,"borderlessgaming")
							{
								gosub, BGM_ProgBDownload
							}					
					}
				if (PREPak = 1)
					{
						sidx= %OUTDIR%
						if (instr(1_Pre,"dc2.exe")or instr(2_Pre,"dc2.exe")or instr(3_Pre,"dc2.exe"))
							{
								gosub, DC2Download
							}		
						if (instr(1_Pre,"multimonitortool.exe")or instr(2_Pre,"multimonitortool.exe")or instr(3_Pre,"multimonitortool.exe"))
							{
								gosub, MMDownload
							}
						if (instr(1_Pre,"soundvolumeview")or instr(2_Pre,"soundvolumeview")or instr(3_Pre,"soundvolumeview"))
							{
								gosub, SNDVOLVIEWDOWNLOAD
							}					
						if (instr(1_Pre,"borderlessgaming")or instr(2_Pre,"borderlessgaming")or instr(3_Pre,"borderlessgaming"))
							{
								gosub, BGM_ProgBDownload
							}					
					}
				if (PSTPak = 1)
					{
						sidy= %OUTDIR%
						if (instr(1_Post,"dc2.exe")or instr(2_Post,"dc2.exe")or instr(3_Post,"dc2.exe"))
							{
								gosub, DC2Download
							}		
						if (instr(1_Post,"multimonitortool.exe")or instr(2_Post,"multimonitortool.exe")or instr(3_Post,"multimonitortool.exe"))
							{
								gosub, MMDownload
							}
						if (instr(1_Post,"soundvolumeview")or instr(2_Post,"soundvolumeview")or instr(3_Post,"soundvolumeview"))
							{
								gosub, SNDVOLVIEWDOWNLOAD
							}					
						if (instr(1_Post,"borderlessgaming")or instr(2_Post,"borderlessgaming")or instr(3_Post,"borderlessgaming"))
							{
								gosub, BGM_ProgBDownload
							}		
					}
				splitpath,sidn,sidnf,sidnpth
				GMon= %subfldrep%%gmnamex%_GameMonitors.%monxtn%
				DMon= %subfldrep%%gmnamex%_DesktopMonitors.%monxtn%
				gamecfgn= %subfldrep%%gmnamex%.ini
				if ((renum = 1)or(rn = ""))
					{
						FileCreateDir,%sidn%\alternates
						subfldrep:= ""
						GMon= GameMonitors.%monxtn%
						DMon= DesktopMonitors.%monxtn%
						gamecfgn= Game.ini
						gmnamex= %gmnamed%
						FileMove,%linktar%\%gmnamed%.lnk,%sidn%\alternates\%gmnamed%__[0%poscntx%].lnk,1
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
						FileRead,RJTMP,%RJDBINI%
						Loop, parse, RJTMP,`n`r
							{
							if (A_LoopField = "")
								{
									Continue
								}
							lpab= %A_LoopField%
							stringsplit,avx,lpab,=
							stringleft,aba,lpab,1
							if (aba = "[")
								{
								cursc= %lpab%
								stringreplace,cursc,cursc,[,,All
								stringreplace,cursc,cursc,],,All
								continue
							}
							stringreplace,aval,lpab,%avx1%=,,
							iniwrite,%aval%,%gamecfg%,%cursc%,%avx1%
					}
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
						if (((pptx is digit)&&(an3 = "")) && (instr(an1,"Pre")or instr(an1,"Post")) or ((an3 = "") && ((an1 = "JustBeforeExit") or (an1 = "JustAfterLaunch"))))
							{
								vb:= ""
							}
						if ((vb <> "")&&(vb <> "ERROR"))
							{
								krs:= % an1
								Loop,parse,SPLIT_SRC,|
									{
										if ((an1 = A_LoopField) or (an1 = "Game_Profiles") or (an1 = "Game_Directory"))
											{
												Continue
											}
									}
								R_%an1%:= vb
								if (instr(vb,".cmd") or instr(vb,".bat") or instr(vb,".vbs") or instr(vb,".ps1") or instr(vb,".vbe")or instr(vb,".wsc")or instr(vb,".wsf")or instr(vb,".psd"))
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
												G_%an1%:= eb1 . sida "\" . vb
												filecopy,%eb1%%vbp%,%sida%,%OVERWRT%
												iniwrite,%eb1%%sida%\%vb%,%gamecfg%,GENERAL,%an1%
											}
										else {
											if ((CENJBE = 1)&& instr(an1,"Before") && (OVERWRT = 1))
												{
													G_%an1%:= eb1 . vbp
													iniwrite,%eb1%%vbp%,%GAMECFG%,GENERAL,%an1%
												}
										}
										if ((OVERWRT = 1)&& instr(an1,"After") && (CENJAL <> 1))
											{
												G_%an1%:= eb1 . side . "\" . vb
												filecopy,%eb1%%vbp%,%side%,%OVERWRT%
												iniwrite,%eb1%%side%\%vb%,%gamecfg%,GENERAL,%an1%
											}
										else {
											if ((CENJAL = 1)&& instr(an1,"After") && (OVERWRT = 1))
												{
													G_%an1%:= eb1 . vbp
													iniwrite,%eb1%%vbp%,%GAMECFG%,GENERAL,%an1%
												}
										}
										if ((OVERWRT = 1)&& instr(an1,"Pre") && (CENPRE <> 1))
											{
												G_%an1%:= eb1 . sidx . "\" . vb
												filecopy,%vbp%,%sidx%,%OVERWRT%
												iniwrite,%eb1%%sidx%\%vb%,%gamecfg%,%section%,%an1%
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
												G_%an1%= eb1 . sidy . "\" . vb
												filecopy,%vbp%,%sidy%,%OVERWRT%
												iniwrite,%eb1%%sidy%\%vb%,%gamecfg%,%section%,%an1%
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
						GAME_LT= %GAME_Directory%
						/*
						if (Localize = 1)
						{
							GAME_LT= %prn%
						}
						*/
						OutTarget:= prn
						refname:= gmnamex
						OutDescription:= gmnamex
						IconNumber:= 0
						prvv:= sidn . "\" . subfldrep . gmnamex . ".lnk"
						linktar:= GAME_Directory . "\" . gmnamex
						/*
						if (Localize = 1)
						{
							linktar= %outdir%
						}
						*/
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
										FileCreateShortcut, %RJDB_LOCATION%\bin\%RJEXFN%.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%jkoptz%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
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
									FileCreateShortcut, %RJDB_LOCATION%\bin\%RJEXFN%.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%jkoptz%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
								
								}
								if (!fileexist(linktarget)&&(renum = "")&&(SETALTSALL = 1))
									{
										FileCreateShortcut, %RJDB_LOCATION%\bin\%RJEXFN%.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%jkoptz%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
							
									}
							}
						if (ASADMIN = 1)
							{
								RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %linkproxy%, ~ RUNASADMIN
							}
						if (GMCONF = 1)
							{
								Player1x=
								Player2x=
								Player3x=
								Player4x=
								MediaCenter_ProfileX=
								if ((Mapper <> "")&&(Mapper <> 0))
									{
										Player1x= %sida%\%subfldrep%%GMNAMEX%.%Mapper_Extension%
										Player2x= %sidb%\%subfldrep%%GMNAMEX%_2.%Mapper_Extension%
									}
								stringreplace,pl1ovr,pl1ovr,<,,All
								stringreplace,pl1ovr,pl1ovr,>,,All
								stringreplace,pl1ovr,pl1ovr,/,\,All
								stringreplace,pl1ovr,pl1ovr,",,All ;"
								if ((pl1ovr <> "<")&&(pl1ovr <> "")&&fileexist(pl1ovr))
									{
										Player1_Template:= pl1ovr
										splitpath,pl1ovr,pl1flnm
									}
								stringreplace,pl2ovr,pl2ovr,<,,All
								stringreplace,pl2ovr,pl2ovr,>,,All
								stringreplace,pl2ovr,pl2ovr,/,\,All
								stringreplace,pl2ovr,pl2ovr,",,All ;"
								if ((pl2ovr <> "<")&&(pl2ovr <> "")&&fileexist(pl2ovr))
									{
										Player2_Template:= pl1ovr
										splitpath,pl2ovr,pl2flnm
									}
								stringreplace,mcpovr,mcpovr,<,,All
								stringreplace,mcpovr,mcpovr,>,,All
								stringreplace,mcpovr,mcpovr,/,\,All
								stringreplace,mcpovr,mcpovr,",,All ;"
								if ((mcpovr <> "<")&&(mcpovr <> "")&&fileExist(mcpovr))
									{
										MediaCenter_Template:= mcpovr
									}
								SplitPath,MediaCenter_Template,MediaCenter_TemplateName
								if ((Mapper <> "")&&(Mapper <> 0))
									{
										MediaCenter_ProfileX= %sidc%\%subfldrep%%MediaCenter_TemplateName%
									}
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
								DeskMon:= sidd . "\" . subfldrep . DMon
								if ((gmovr <> "")&& fileExist(gmovr))
									{
										SplitPath,gmovr,GMon
									}
								GameMon:= sidg . "\" . subfldrep . GMon
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
								if ((dmovr <> "<")&&(dmovr <> "")&&fileexist(dmovr))
									{
										DeskMon:= dmovr
									}
								if ((gmovr <> "<")&&(gmovr <> "")&&fileExist(gmovr))
									{
										GameMon:= gmovr
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
								iniwrite,%OutDir%,%gamecfg%,CONFIG,Install_Folder
								iniwrite,%prnmx%,%gamecfg%,CONFIG,Exe_File
								killist:
								invar= %gmnamed%
								gosub, stripvar
								stringreplace,invarx,invarx,.,,All
								t_inv:= % (_%invarx%)
								iniwrite,%exe_list%,%home%\cst.tmp,%invarx%,exe
								bvar:= % t_inv
								if ((KILLCHK = 1)&&(klist = ""))
									{
										klist=
														;;klist= |%prnmx%|
										Loop,files,%tlevel%\*.exe,R
											{
												splitpath,A_LoopFileFullPath,tmpfn,tmpfd,,tmpfo
												abson=
												stringreplace,tmpfz,A_LoopFileFullPath,%tlevel%\,,All
												abexe=|%A_LoopFileFullPath%|
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
													klist.= A_LoopFileFullPath . "|"
												}
											}
										iniread,nklist,%gamecfg%,CONFIG,exe_list
										if ((nklist = "")or(nklist = "ERROR")or(OVERWRT = 1))
											{
												iniwrite,%klist%,%gamecfg%,CONFIG,exe_list
												iniwrite,%klist%,%home%\cst.tmp,%invarx%,exe
											}
										if (nklist <> "")
											{
												nklist.= klist
												iniwrite,%nklist%,%gamecfg%,CONFIG,exe_list
												iniwrite,%nklist%,%home%\cst.tmp,%invarx%,exe
											}
									}
							}
					}
				if ((GMJOY = 1) && (subfldrep = ""))
					{
						IF ((CENPL1 <> 1)or(Player1_Template = "DISABLED"))
							{
								if ((Player1_Template <> player1X)&&if (player1x <> "")&&(Player1_Template <> ""))
									{
										Filecopy,%Player1_Template%,%player1X%,%OVERWRT%
										if ((errorlevel = 0)or fileexist(player1X))
											{
												if (OVERWRT = 1)
													{
														iniwrite,%player1x%,%GAMECFG%,JOYSTICKS,Player1
													}
											}
									}
									else {
										if ((G_Player1 = "ERROR")or(G_Player1 = ""))
											{
												iniwrite,%player1x%,%GAMECFG%,JOYSTICKS,Player1
											}
									}
								}
							else {
								if ((Player1_Template <> "")&&(G_Player1 = "ERROR")or(G_Player1 = "")or(OVERWRT = 1))
									{
										iniwrite,%Player1_Template%,%gamecfg%,JOYSTICKS,Player1
									}
							}
							if ((MAPPER <> 3)&&(Mapper <> "")&&(Mapper <> 0))
								{
									if ((CENPL2 <> 1)or(Player2_Template = "DISABLED"))
										{
											if ((Player2_Template <> player2X)&&(player2x <> "")&&(Player2_Template <> ""))
												{
													Filecopy,%Player2_Template%,%player2X%,%OVERWRT%
													if ((errorlevel = 0)or fileexist(player2x))
													{
														if (OVERWRT = 1)
															{
																iniwrite,%player2x%,%GAMECFG%,JOYSTICKS,Player2
															}
													}
												}
											else {
												if ((G_Player2 = "ERROR")or(G_Player2 = ""))
													{
														iniwrite,%player2x%,%GAMECFG%,JOYSTICKS,Player2
													}
											}
										}
									else {
										if ((Player2_Template <> "")&&(G_Player2 = "ERROR")or(G_Player2 = "")or(OVERWRT = 1))
											{
												iniwrite,%Player2_Template%,%gamecfg%,JOYSTICKS,Player2
											}
									}
								}
							if ((CENMC <> 1)&&(MediaCenter_Template = "DISABLED"))
								{
									if ((MediaCenter_Template <> MediaCenter_ProfileX) && (MediaCenter_Template <> "") && (Mapper <> "") && (Mapper <> "0"))
										{
											Filecopy,%MediaCenter_Template%,%MediaCenter_ProfileX%,%OVERWRT%
											if ((errorlevel = 0)or fileexist(MediaCenter_ProfileX)or(MediaCenter_ProfileX = "DISABLED"))
												{
													if (OVERWRT = 1)
														{
															iniwrite,%MediaCenter_ProfileX%,%GAMECFG%,JOYSTICKS,MediaCenter_Profile
														}
												}
										}
									else {
										if ((MediaCenter_ProfileX <> "")&&(G_MediaCenter_Profile = "ERROR")or(G_MediaCenter_Profile = ""))
											{
												iniwrite,%MediaCenter_ProfileX%,%GAMECFG%,JOYSTICKS,MediaCenter_Profile
											}
									}
								}
							else {
							if ((MediaCenter_ProfileX <> "")&&(G_MediaCenter_Profile = "ERROR")or(G_MediaCenter_Profile = "")or(OVERWRT = 1))
							{
								iniwrite,%MediaCenter_ProfileX%,%gamecfg%,JOYSTICKS,MediaCenter_Profile
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
				if ((jlovr <> "<")&& fileexist(jlovr))
					{
						stringsplit,prexx,JustAfterLaunch,<
						JUSTA:= prexx1 . "<" . jlovr
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
								if (DEPLOY_DC = 1)
									{
										Loop,files,%Downloaded%\*noon*
											{
												noon=%A_LoopfieldLongPath%
											}
										RunWait, %home%\7za.exe e -y "%noon%" -O"%outdir%"
										MultiMonitor_Tool= %outdir%\dc2.exe
										Display_ChangerCMD= %outdir%\dc64cmd.exe
										GameMon= %outdir%\GameMonitors.xml
										DeskMon= %outdir%\DesktopMonitors.xml
										MMSAVE:= "-create"
										MMLOAD:= "-configure="
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
								stringreplace,cmdtmp,cmdtmp,[MMSAVE],%MMSAVE%
								stringreplace,cmdtmp,cmdtmp,[MMLOAD],%MMLOAD%
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
				if ((G_Steam_AppID = "")&&(STEAMQUERY <> 0))or((OVERWRT = 1)&&(steamquery <> 0))
					{
						iniwrite,%steamquery%,%GAMECFG%,CONFIG,Steam_AppID
					}
				if ((G_Steam_ClientID = "")&&(STEAMQUERY <> 0))or((OVERWRT = 1)&&(steamquery <> 0))
					{
						iniwrite,%steam_clientID%,%GAMECFG%,CONFIG,Steam_ClientID
					}
				if ((G_Steam_UserID = "")&&(STEAMQUERY <> 0))or((OVERWRT = 1)&&(steamquery <> 0))
					{
						iniwrite,%steam_UserID%,%GAMECFG%,CONFIG,Steam_UserID
					}
				if ((G_Steam_Name = "")&&(STEAMQUERY <> 0))or((OVERWRT = 1)&&(steamquery <> 0))
					{
						iniwrite,%steam_name%,%GAMECFG%,CONFIG,Steam_Name
					}
				if ((GLBTRY >= 7)or(Net_Check = 0))
					{
						goto, PROFILECOMPLETE
					}
				if (((steamquery = 0)&&(G_Steam_AppID <> "")&& !fileExist(sidn . "\" G_Steam_AppID . ".json"))or (!instr(stmdbfnd,steamquery)&&(steamquery <> 0)))
					{
						if (steamquery = 0)
							{
								steamquery= %G_Steam_AppID%
								iniwrite,%steamquery%,%GAMECFG%,CONFIG,Steam_AppID
							}
						if !instr(stmdbfnd,steamquery)
							{
								GameData:= ""
								SaveData:= ""
								SB_SetText("Querying intenet-databases")
								iniwrite,%steamquery%,%GAMECFG%,CONFIG,Steam_AppID
								stmdbfnd.= steamquery . "|"
								gosub, steamappinfo
							}
					}
				else {
					if ((steamquery = 0)&&(G_Steam_AppID = 0)or(G_Steam_AppID = ""))
					{
						GameData:= ""
						SaveData:= ""
					}
				}
				PROFILECOMPLETE:			 
				if (LOCALIZE = 1)
					{
						if fileExist(Game_Profiles . "\" . njName)
							{
								FileCreateDir,%Game_Profiles%\.moved
								ffpath:= Game_Profiles . "\" . njName
								if symlink(ffpath,target,type)
									{
										FileDelete,%Game_Profiles%\%njName%
									}
								else
									{
										FileMoveDir,%Game_Profiles%\%njName%,%Game_Profiles%\.moved\%njName%
										aprc+=1
									}
							}
						RunWait,%comspec% /c mklink /J  "%Game_Profiles%\%njName%" "%sidn%",%Game_Profiles%,hide
					}
				if (aprc = "")
					{
						fileDelete,%Game_Profiles%\.moved\%njName%
					}
				SB_SetText("created profile for " gmnamex "")
			}
		SB_SetText("Shortcuts Created")
		if (ASADMIN = 1)
			{
				RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %binhome%\%RJEXFN%.exe, ~ RUNASADMIN
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
;}############################    SHORTCUT COMPLETE ####################################;;;
	RlsGrpRoll:
		stringlen,rgv,rgg
		stringright,nv,njname,%rgv%
		sexenj= %njname%
		if (instr(njname,rgg)&&(nv = rgg))
		{
			Loop,parse,RLSPFX,|
				{
					if (A_LoopField = "")
						{
							continue
						}
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
		DDINCLD:
		gui,submit,nohide
		guicontrolget,DDINCLD,,DDINCLD
		guicontrolget,IncludedD,,IncludedD
		iniread,IncDD,%RJDBINI%,GENERAL,IncludedD
		if instr(IncDD,DDINCLD)
			{
				guicontrol,,IncludedD,1
				return
			}
		guicontrol,,IncludedD,0
		return
		IncludedD:
		gui,submit,nohide
		guicontrolget,IncludedD,,IncludedD
		guicontrolget,DDInc,,DDIncld
		iniread,IncDD,%RJDBINI%,GENERAL,IncludedD
		guicontrolget,Exclude_Fldr,,EXCLUDE_DirectoryT
		if (IncludedD = 0)
			{
				if ((INcDD = "ERROR")or(IncDD = ""))
					{
						INcDD=
						return
					}
				_Exd= %DDinc%_Directory
				iniread,selddlir,%RJDBINI%,GENERAL,%_Exd%
				acnt=
				if ((selddlir <> "")&&(selddlir <> "ERROR"))
					{
						Loop, parse,selddlir,|
						{
							if (A_LoopField = "")
								{
									continue
								}
							if !instr(Exclude_Directory,A_LoopField)
								{
									acnt+=1
									if (acnt = 1)
										{
											Exclude_Fldr= %A_LoopField%
											acnt+=1
											continue
										}
									Exclude_Directory.= A_LoopField . "|"
								}
							else {
								stringreplace,Exclude_Directory,Exclude_Directory,%A_LoopField%|,,All
							}
						}
				}
			stringreplace,IncDD,IncDD,%DDinc%|,,
			iniwrite,%IncDD%,%RJDBINI%,GENERAL,IncludedD
			iniwrite,%Exclude_Directory%,%RJDBINI%,GENERAL,Exclude_Directory
			guicontrol,,Exclude_DirectoryT,|%Exclude_Fldr%||%Exclude_Directory%
			return
		}
		if (IncludedD = 1)
			{
				if ((INcDD = "ERROR")or(IncDD = ""))
					{
						INcDD=
					}
				gotrt=
				gotr=
				seldlir= %DDinc%_Directory
				iniread,selddlir,%RJDBINI%,GENERAL,%seldlir%
				if ((selddlir <> "")&&(selddlir <> "ERROR"))
					{
						DDSwitch= %DDinc%
						gosub, %DDSwitch%_Q
						gotr= %IncDD%_ROOT
						gotrt:= % gotr
						DDswtch=
					}
				if (gotrt <> "")
					{
						acnt=
						_Exclude_Directory:= Exclude_Directory
						Loop,parse,selddlir,|
							{
								if (A_LoopField = "")
									{
										continue
									}
								nwxcl= %A_LoopField%
								if instr(_Exclude_Directory,nwxcl)
									{
										Loop,parse,_Exclude_Directory,|
											{
												Cxclf= %A_LoopField%
												if instr(A_LoopField,nwxcl)
													{
														stringreplace,_Exclude_Directory,_Exclude_Directory,%A_LoopField%|,,All
														if (ERRORLEVEL = 0)
															{
																break
															}
													}
											}
									}
								else {
									acnt+=1
									if (acnt = 1)
										{
											Exclude_Fldr= %Cxclf%
											acnt+=1
										}
								}
							}
						Exclude_Directory:= _Exclude_Directory
					}
				stringreplace,IncDD,IncDD,%DDinc%|,,
				IncDD.= DDInc . "|"
				iniwrite,%IncDD%,%RJDBINI%,GENERAL,IncludedD
				iniwrite,%Exclude_Directory%,%RJDBINI%,GENERAL,Exclude_Directory
				guicontrol,,Exclude_DirectoryT,|%Exclude_Fldr%||%Exclude_Directory%
				return
			}
		return
		GETGOODNAME:
		stringreplace,exepo,exep,%TOPSCR%,,
		nfn=
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
		if instr(Extra_Source,FilePath)
			{
				exepo=
				exqu:= genquery . "|" . GogQuery . "|" . ItchQuery . "|" . AmzQuery . "|" . OriQuery . "|" . steamhome
				Loop,parse,undira,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						cugpth=%A_LoopField%
						stringreplace,exepot,filepath,%A_LoopField%\,,
						if (ERRORLEVEL = 0)
							{
								TOPSCR= %A_LoopField%
								EXEVS= %exepot%
								Loop,parse,EXQU,|
									{
										if (A_LoopField = "")
											{
												continue
											}
										stringreplace,exepov,filepath,%cugpth%\%A_LoopField%,,
										if (ERRORLEVEL = 0)
											{
												TOPSCR= %cugpth%\%A_LoopField%
												exepo= %exepov%
												goto, EXEPO
											}
									}
								break
							}
					}
				if (exepot <> filepath)
					{
						goto, EXEPO
					}
				Loop,parse,EXQU,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						GNCHK= %filtdrv%\%A_LoopField%
						stringreplace,exepo,filepath,%GNCHK%,,
						if (errorlevel = 0)
							{
								TOPSCR= %GNCHK%
								goto, EXEPO
							}
					}
				if (exepo <> filepath)
					{
						goto, EXEPO
					}
				stringreplace,exepo,filepath,%filtdrv%\,,
				TOPSCR= %filtdrv%
			}
		EXEPO:
		exepN= %exepo%
		jpiter:= ""
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
		lastn=
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
				lastn= %A_LoopField%
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
		if (njname = "")
			{
				njname= %lastn%
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
						ap:= regexmatch(njnx,"i)^Pre.?Rel.*|^Pre.?Alpha.*|^Early.?Access.*|^Early.?B.*l.*d.*|Early.?Rel.*|^Rls.?[0-9].*|^Rls.v.*[0-9].*|^Demo.?v.[0-9]*|^Demo.?B.*ld.*|^Alpha.?B.*ld.*|^Alpha.R.?l.*s.*|^devel.*b.*l.*d.*|^Devel.?R.*l.*s.*|^R.?l.*s.?+[0-9].*|^Rel.v.?[0-9].*|^Build.v.?[0-9].*|^FIXED.*|^Build.[0-9].*|^Debug.?[0-9].*|^Debug.v.*[0-9].*|^UPDATE.*|^final.?v.?[0-9].*|^fin.?v.?[0-9].*|^Updt.*v.?[0-9].*|^v.?[0-9].*|^ver.?[0-9].*|^Developer.*",trmp)
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
		stringright,tri,njName,3
		Loop,parse,TRIEND,|
			{
				if (tri = A_LoopField)
					{
						stringtrimright,njname,njname,3
						break
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
						if ((instr(A_LoopField,xenjx) or instr(A_LoopField,njx)or instr(A_LoopField,njj) && instr(A_LoopField,bexp)) or ((bei3 = exedp)&&(exelen >= 7)))
							{
								if (bei5 = "")
									{
										break
									}
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
									if (bei5 = "")
										{
											break
										}
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
				Loop,parse,CENITEMS,|
					{
						guicontrol,,%A_Loopfield%,0
						guicontrol,disable,%A_LoopFIeld%
					}
				guicontrol,,CENTRLCKB,0									
				Gui, Font, cBlue 
				GuiControl, Font, CENTRLCKB
				GuiControl, Font, Localize
				iniwrite,Localize,%RJDBINI%,GENERAL,CENTRALIZE
				return
			}
		iniwrite,%A_Space%,%RJDBINI%,GENERAL,CENTRALIZE
		guicontrol,enable,CENTRLCKB
		Loop,parse,CENITEMS,|
			{
				guicontrol,enable,%A_LoopFIeld%
			}								
		Guicontrol,enable,Game_ProfB
		Gui, Font, cTeal
		GuiControl, Font, CENTRLCKB
		GuiControl, Font, Localize
		return
		
		ToolTips:
		gui,submit,nohide
		guicontrolget,ToolTips,,ToolTips
		iniwrite,%ToolTips%,%RJDBINI%,GENERAL,ToolTips
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
				Menu,addonp, Add,,
				Menu,addonp, Add,ludusavi,ludusaviDOWNLOAD
				Menu,addonp, Add,rclone,RCLONEDOWNLOAD
				Menu,addonp, Add,syncthing,SYNCTHINGDOWNLOAD
				Menu,addonp, Add,OpenCloudSave,OpenCloudSaveDOWNLOAD
			}
		if (butrclick = "POSTAPP")
			{
				Menu,addonp, Add,soundVolumeView,SNDVOLVIEWDOWNLOAD
				Menu,addonp, Add,,
				Menu,addonp, Add,ludusavi,ludusaviDOWNLOAD
				Menu,addonp, Add,rclone,RCLONEDOWNLOAD
				Menu,addonp, Add,syncthing,SYNCTHINGDOWNLOAD
				Menu,addonp, Add,OpenCloudSave,OpenCloudSaveDOWNLOAD
			}
		Menu,addonp,show
		return
		DC2Download:
		curemote= _Display_Changer_
		gosub, BINGETS
		gosub, DOWNLOADIT
		if (exedpl = 1)
			{
				return
			}
		binka=2
		MultiMonitor_ToolT= %binhome%\dc2.exe
		Display_ChangerCMD= %binhome%\dc64cmd.exe
		gosub, MM_ToolB
		dchk:= ""
		SB_SetText("")
		return
		MMDownload:
		curemote= _MultiMonitorTool_
		gosub, BINGETS
		gosub, DOWNLOADIT
		if (exedpl = 1)
			{
				return
			}
		MultiMonitor_ToolT= %binhome%\multimonitortool.exe
		gosub, MM_ToolB
		dchk:= ""
		SB_SetText("")
		return
		BGM_ProgBDownload:
		curemote= _BorderlessGaming_
		gosub, BINGETS
		gosub, DOWNLOADIT
		if (exedpl = 1)
			{
				return
			}
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
		if (exedpl = 1)
			{
				return
			}
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
		OpenCloudSaveDOWNLOAD:
		curemote:= "_OpenCloudSave_"
		gosub, BINGETS
		gosub, DOWNLOADIT
		if (exedpl = 1)
			{
				return
			}
		OpenCloudSave= %binhome%\OpenCloudSave\OpenCloudSave.exe
		gosub, OpenCloudSave_ToolB
		dchk:= ""
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
		ludusaviDOWNLOAD:
		curemote:= "_ludusavi_"
		gosub, BINGETS
		gosub, DOWNLOADIT
		if (exedpl = 1)
			{
				return
			}
		ludusavi= %binhome%\ludsavi\ludusavi.exe
		gosub, ludusavi_ToolB
		dchk:= ""
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
		RCLONEDOWNLOAD:
		curemote:= "_rclone_"
		gosub, BINGETS
		gosub, DOWNLOADIT
		if (exedpl = 1)
			{
				return
			}
		rclone= %binhome%\rclone\rclone.exe
		gosub, rclone_ToolB
		dchk:= ""
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
		SYNCTHINGDOWNLOAD:
		curemote:= "_syncthing_"
		gosub, BINGETS
		gosub, DOWNLOADIT
		if (exedpl = 1)
			{
				return
			}
		syncthing= %binhome%\syncthing\syncthing.exe
		gosub, rclone_ToolB
		dchk:= ""
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
		Menu,dwnlbmn,Add,Display_Changer,DC2download
		Menu,dwnlbmn,Add,,
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
		keymapcont:
		gosub, BINGETS
		gosub, DOWNLOADIT
		if (exedpl = 1)
			{
				return
			}
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
		PACKAGE:
		guicontrolget,PACKAGE,,PACKAGE
		Blockinput,on
		iniread,KBPak,%RJDBINI%,DEPLOYMENTS,KBPak
		iniread,Pl1Pak,%RJDBINI%,DEPLOYMENTS,Pl1Pak
		iniread,Pl2Pak ,%RJDBINI%,DEPLOYMENTS,Pl2Pak 
		iniread,MCjPak,%RJDBINI%,DEPLOYMENTS,MCjPak
		iniread,GMPak,%RJDBINI%,DEPLOYMENTS,GMPak
		iniread,DMPak,%RJDBINI%,DEPLOYMENTS,DMPak
		iniread,JALPak,%RJDBINI%,DEPLOYMENTS,JALPak
		iniread,JBEPak,%RJDBINI%,DEPLOYMENTS,JBEPak
		iniread,PREPak,%RJDBINI%,DEPLOYMENTS,PREPak
		iniread,PSTPak,%RJDBINI%,DEPLOYMENTS,PSTPak
		paknum=
		Loop,parse,PAKLST,|
			{
				paknum+= % (%A_LoopField%)
				guicontrol,show,%A_LoopField%
			}	
		if (INITZ = 1)
			{
				return
			}	
		if (PACKAGE = 1)
			{
				if ((paknum = 0)&&(recfl <> 1))
					{
						Blockinput,off
						MsgBox,4096,WARNING,***        WARNING        ***`n`nThese options may consume (in)significant disk space to the Game's Installation path`nIt is recommended to run this program with administrator priveleges before continuing.
						ifmsgbox,Ok
							{
								Blockinput,on
								Gui, Font, cLime Bold, 
								GuiControl, move, PACKAGE,x160 w125
								GuiControl, Font, PACKAGE
								Loop,parse,PAKLST,|
									{
										if (A_LoopField = "")
											{
												continue
											}
										guicontrol,,%A_LoopField%,0
										guicontrol,enable,%A_LoopField%
										guicontrol,show,%A_LoopField%
										Blockinput,off
										return
									}
							}
						Gui, Font, cRed s9, 
						GuiControl, move, PACKAGE,x180 w125
						GuiControl, Font, PACKAGE
					}
				else {
					recfl= 1	
					Loop,parse,PAKLST,|
					{
						if (A_LoopField = "")
						{
							continue
						}
						pakiv:= % (%A_LoopField%)
						guicontrol,,%A_LoopField%, %pakiv%
						guicontrol,show,%A_LoopField%
						guicontrol,enable,%A_LoopField%		
					}
				}
				Loop,parse,CENITEMS,|
				{
					if (A_LoopField = "")
						{
							continue
						}
					kks= %A_LoopField%	
					javj:= % (%kks%)
					if (javj = 1)
						{
							gosub, %A_LoopField%									
						}
				}
				Gui, Font, cLime Bold, 
				GuiControl, move, PACKAGE,x160 w125
				GuiControl, Font, PACKAGE
			}
		else if (PACKAGE = 0)
			{
				Gui, Font, cRed s9, 
				GuiControl, move, PACKAGE,x180 w105
				GuiControl, Font, PACKAGE
				Loop,parse,PAKLST,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						guicontrol,,%A_LoopField%,0
						guicontrol,hide,%A_LoopField%
						iniwrite,%A_Space%,%RJDBINI%,DEPLOYMENTS,%A_LoopField%
						%A_LoopField%=
					}
				Blockinput,off	
				return
			}
		Blockinput,off	
		return
		KBPak:
		Gui,Submit,nohide
		guicontrolget,KBPak,,KBPak
		if (KBPak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CenKBM,0
				gosub,CenKBM
			}
		else {
			PROFINST= Profile
			guicontrol,,_Keyboard_MapperT,%Keyboard_Mapper%
		}
		iniwrite,%KBPak%,%RJDBINI%,DEPLOYMENTS,KBPak
		return
		Pl1Pak:
		Gui,Submit,nohide
		guicontrolget,Pl1Pak,,Pl1Pak
		if (Pl1Pak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CenPl1,0
				gosub,CenPl1
			}
		else {
			PROFINST= Profile
			guicontrol,,_Player1_TemplateT,%Player1_Template%
		}
		iniwrite,%Pl1Pak%,%RJDBINI%,DEPLOYMENTS,Pl1Pak
		return
		Pl2Pak:
		Gui,Submit,nohide
		guicontrolget,Pl2Pak,,Pl2Pak
		if (Pl2Pak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CenPl2,0
				gosub,CenPl2
			}
		else {
			PROFINST= Profile
			guicontrol,,_Player2_TemplateT,%Player2_Template%
		}
		iniwrite,%Pl2Pak%,%RJDBINI%,DEPLOYMENTS,Pl2Pak
		return
		MCjPak:
		Gui,Submit,nohide
		guicontrolget,MCjPak,,MCjPak
		if (MCjPak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CenMC,0
				gosub,CenMC
			}
		else {
			PROFINST= Profile
			guicontrol,,_MM_MediaCenter_TemplateT,%MM_MediaCenter_Template%
		}
		iniwrite,%MCjPak%,%RJDBINI%,DEPLOYMENTS,MCjPak
		return
		GMPak:
		Gui,Submit,nohide
		guicontrolget,GMPak,,GMPak
		if (GMPak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CenGM,0
				gosub,CenGM
			}
		else {
			PROFINST= Profile
			guicontrol,,_MM_Game_ConfigT,%MM_Game_ConfigT%
		}
		iniwrite,%GMPak%,%RJDBINI%,DEPLOYMENTS,GMPak
		return
		DMPak:
		Gui,Submit,nohide
		guicontrolget,DMPak,,DMPak
		if (DMPak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CenMM,0
				gosub,CenMM
			}
		else {
			PROFINST= Profile
			guicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_Config%
		}
		iniwrite,%DMPak%,%RJDBINI%,DEPLOYMENTS,DMPak
		return
		JALPak:
		Gui,Submit,nohide
		guicontrolget,JALPak,,JALPak
		if (JALPak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CENJAL,0
				gosub,CENJAL
			}
		else {
			PROFINST= Profile
			guicontrol,,_JustAfterLaunchT,%JustAfterLaunch%
		}
		iniwrite,%JALPak%,%RJDBINI%,DEPLOYMENTS,JALPak
		return
		JBEPak:
		Gui,Submit,nohide
		guicontrolget,JBEPak,,JBEPak
		if (JBEPak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CenJBE,0
				gosub,CenJBE
			}
		else {
			PROFINST= Profile
			guicontrol,,_JustBeforeExitT,%JustBeforeExit%
		}
		iniwrite,%JBEPak%,%RJDBINI%,DEPLOYMENTS,JBEPak
		return
		PREPak:
		Gui,Submit,nohide
		guicontrolget,PREPak,,PREPak
		if (PREPak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CenPRE,0
				gosub,CenPRE
			}
		else {
			PROFINST= Profile
		}
		iniwrite,%PREPak%,%RJDBINI%,DEPLOYMENTS,PREPak
		return
		PSTPak:
		Gui,Submit,nohide
		guicontrolget,PSTPak,,PSTPak
		if (PSTPak = 1)
			{
				PROFINST= Game Installation
				guicontrol,,CenPST,0
				gosub,CenPST
			}
		else {
			PROFINST= Profile
		}
		iniwrite,%PSTPak%,%RJDBINI%,DEPLOYMENTS,PSTPak
		return
		CENeP:
		CENcP:
		LCLcP:
		LCLeP:
		return
		DelXE:
		IniSel:
		return
		PRFNAME:
		gui,submit,nohide
		guicontrolget,PRFNAME,,PRFNAME
		splitpath,gamefini,,gamefpth
		splitpath,gamefpth,gamefname
		stringreplace,gamefname,gamefname,\,,All
		stringreplace,gamefname,gamefname,/,,All
		stringreplace,gamefname,gamefname,:,,All
		stringreplace,gamefname,gamefname,*,,All
		stringreplace,gamefname,gamefname,?,,All
		stringreplace,gamefname,gamefname,>,,All
		stringreplace,gamefname,gamefname,<,,All
		guicontrol,,PRFNAME,%PRFNAME%
		return
		opnRLD:
		gui,submit,nohide
		gosub, LoadGameIni
		return
		opnif:
		gui,submit,nohide
		Run,notepad %gamefini%,,
		return
		SaveName:
		gui,submit,nohide
		guicontrolget,PRFNAME,,PRFNAME
		if (PRFNAME = "")
			{
				SB_SetText("Enter a name before saving")
				return
			}
		splitpath,R_GAME_PROFILES,prfold,GAME_PROFDIR
		FileGetShortcut,%R_Game_Directory%\%prfold%.lnk,inscname,inscpth,chkargl
		FileDelete,%R_Game_Directory%\%prfold%
		FIleCreateShortcut,%R_game_directory%\%prfname%.lnk,%GAME_PROFDIR%\%PRFNAME%,,%prfname%,%Source_Directory%
		fileread,cmdfile,%R_GAMEPROFILES%\%prfold%.cmd
		fileread,inifile,%gamefini%
		Filedelete,%R_GAMEPROFILES%\%prfold%.cmd
		Filedelete,%gamefini%
		Loop,files,%R_GAME_PROFILES%\*%prfold%.*
			{
				splitpath,A_LoopFileName,olfnm,,olfxtn,olfnmo
				stringreplace,APRFNAME,A_LoopFileName,%prfold%,%PRFNAME%,				
				FileMove,%A_LoopFileFullPath%,%APRFNAME%.%olfxtn%,R
				stringreplace,inifile,inifile,%A_LoopFIleFullPath%,%R_GAME_PROFDir%\%PRFNAME%\%APRFNAME%,All
				stringreplace,cmdfile,cmdfile,%A_LoopFIleFullPath%,%R_GAME_PROFDir%\%PRFNAME%\%APRFNAME%,All
			}
		FileMoveDir,%R_GAME_PROFILES%,%GAME_PROFDIR%\%PRFNAME%,R
		Fileappend,%inifile%,%GAME_PROFDir%\%PRFNAME%\Game.ini
		Fileappend,%cmdfile%,%GAME_PROFDir%\%PRFNAME%\%PRFNAME%.cmd
		return
		SAPPID:
		gui,submit,nohide
		guicontrolget,sappid,,sappid
		iniwrite,%sappid%,%gamefini%,CONFIG,Steam_Appid
		return
		TBARTOG:
		MMODET:
		return
		CloudCfgDDL:
		gui,submit,nohide
		guicontrolget,clsvdv,,CloudCfgDDL
		guicontrol,,CloudCfgEDT,%clsvev%
		return
		CloudCfgEDT:
		gui,submit,nohide
		guicontrolget,clsvev,,CloudCfgEDT
		guicontrolget,clsvdv,,CloudCfgDDL
		sleep,1000
		if ((clsvev = "")or(clsvdv = ""))
			{
				return
			}
		stringreplace,clsvev,clsvev,`%,```%,All
		sttypin= 
		NGameData=
		if (clsvdv <> clsvev)
			{
				Loop,parse,GameData,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						if (A_LoopField = clsvdv)
							{
								sleep,250
								guicontrolget,clsvex,,CloudCfgEDT
								if (clsvex <> clsvev)
									{
										sttypin= 1
										break
									}
								 else {
									NGameData.= clsvev . "|"
									continue
								 }	
							}
						NGameData.= A_LoopFIeld . "|"	
					}
				if (sttypin = "")
					{
						GameData= %NGameData%
						guicontrol,,CloudCfgDDL,|%clsvev%||%GameData%
						IniWrite,%NGameData%,%gamefini%,CONFIG,GameData
					}
			}
		return
		CloudCfgBut:
		guicontrolget,clsvdv,,CloudCfgDDL
		gui,submit,nohide
		CloudCfgT=
		FileSelectFile,CloudCfgT,35,,Select A File to add to the Cloud Backup List,*.*; \
		if Instr(GameData,clsvdv)
			{
				SB_SetText("This is already in your CloudConfig-List")
				return
			}
		else {
				GameData.= CloudCfgT . "|"
				guicontrol,,CloudCfgDDL,|%clsvdv%||%GameData%
				guicontrol,,CloudCfgEdt,%clsvdv%
			}	
		return
		DelCloudCfg:
		NGameData=
		pki=
		guicontrolget,clsvdv,,CloudCfgDDL
		gui,submit,nohide
		Loop,parse,GameData,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				if (A_LoopFIeld = clsvdv)
					{
						continue
					}
				pki+=1
				if (pki = 1)
					{
						TSCLDVK=a_LoopField
					}
				NGameData.= A_LoopField . "|"	
			}
		GameData= %NGameData%
		guicontrol,,CloudCfgDDL,|%TSCLDVK%||%GameData%
		guicontrol,,CloudCfgEDT,%TSCLDVK%
		return
		CloudSavDDL:
		gui,submit,nohide
		guicontrolget,clsvdv,,CloudSavDDL
		guicontrol,,CloudSavEDT,%clsvev%
		return
		CloudSavEDT:
		gui,submit,nohide
		guicontrolget,clsvev,,CloudSavEDT
		guicontrolget,clsvdv,,CloudSavDDL
		sleep,1000
		sttypin= 
		NSaveData=
		if (clsvdv <> clsvev)
			{
				Loop,parse,SaveData,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						if (A_LoopField = clsvdv)
							{
								sleep,250
								guicontrolget,clsvex,,CloudSavEDT
								if (clsvex <> clsvev)
									{
										sttypin= 1
										break
									}
								 else {
									NSaveData.= clsvev . "|"
									continue
								 }	
							}
						NSaveData.= A_LoopFIeld . "|"	
					}
				if (sttypin = "")
					{
						SaveData= %NSaveData%
						guicontrol,,CloudSavDDL,|%clsvev%||%savedata%
						IniWrite,%NSaveData%,%gamefini%,CONFIG,SaveData
					}
			}
		return
		CloudSavBut:
		guicontrolget,clsvdv,,CloudSavDDL
		gui,submit,nohide
		CloudSavT=
		FileSelectFile,CloudSavT,35,,Select A File to add to the Cloud Backup List,*.*; \
		if Instr(SaveData,clsvdv)
			{
				SB_SetText("This is already in your CloudSave-List")
				return
			}
		else {
				SaveData.= CloudSavT . "|"
				guicontrol,,CloudSavDDL,|%clsvdv%||%SaveData%
				guicontrol,,CloudSavEdt,%clsvdv%
			}	
		return
		DelCloudSav:
		NSaveData=
		pki=
		guicontrolget,clsvdv,,CloudSavDDL
		gui,submit,nohide
		Loop,parse,SaveData,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				if (A_LoopFIeld = clsvdv)
					{
						continue
					}
				pki+=1
				if (pki = 1)
					{
						TSCLDVK=a_LoopField
					}
				NSaveData.= A_LoopField . "|"	
			}
		SaveData= %NSaveData%
		guicontrol,,CloudSavDDL,|%TSCLDVK%||%SaveData%
		guicontrol,,CloudSavEDT,%TSCLDVK%
		return
		Delcfg:
		gui,submit,nohide
		guicontrolget,cfgddlt,,cfgddl
		guicontrol,,inicfg, 
		stringreplace,cfgDDLt,cfgDDLt,%A_Space%,,all
		stringreplace,cfgDDLt,cfgDDLt,cfg,config,all
		stringreplace,cfgDDLt,cfgDDLt,-exe,-executable,all
		stringreplace,cfgDDLt,cfgDDLt,Monitor,MM,all
		stringreplace,cfgDDL,cfgDDLt,-,_,all
		Loop,parse,inifile,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				br= %A_Loopfield%
				stringleft,bra,br,1
				if (bra = "[")
					{
						stringtrimleft,br,br,1
						stringtrimright,sec,br,1
						continue
					}
				if instr(omitsec,sec)
					{
						continue
					}
				stringsplit,iva,br,=
				stringreplace,nvs,br,%iva1%=,,
				if (iva1 = cfgDDL)
					{
						iniWrite,%A_Space%,%gamefini%,%sec%,%cfgDDL%
						break
					}
			}		
		return
		DelExe:
		gui,submit,nohide
		guicontrolget,exeDDLT,,exeDDL		
		stringreplace,exeddlt,exeddlt,%A_Space%,,all
		stringreplace,exeddlt,exeddlt,-exe,-executable,all
		stringreplace,exeddlt,exeddlt,cfg,config,all
		stringreplace,exeddl,exeddlt,-,_,all
		Loop,parse,inifile,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				br= %A_Loopfield%
				stringleft,bra,br,1
				if (bra = "[")
					{
						stringtrimleft,br,br,1
						stringtrimright,sec,br,1
						continue
					}
				if instr(omitsec,sec)
					{
						continue
					}
				stringsplit,iva,br,=
				stringreplace,nvs,br,%iva1%=,,
				if (iva1 = exeddl)
					{
						iniWrite,%A_Space%,%gamefini%,%sec%,%exeDDL%						break
					}
			}
		return
		MapDDL:
		gui,submit,nohide
		guicontrolget,mapddl,,mapddl
		iniwrite,%mapddl%,%gamefini%,JOYSTICKS,JMAP
		return
		cfgDDL:
		nva=
		nvs=
		iva1=
		iva2=
		gui,submit,nohide
		guicontrol,,inicfg, 
		guicontrolget,cfgDDLT,,cfgDDL
		stringreplace,cfgDDLt,cfgDDLt,%A_Space%,,all
		stringreplace,cfgDDLt,cfgDDLt,cfg,config,all
		stringreplace,cfgDDLt,cfgDDLt,-exe,-executable,all
		stringreplace,cfgDDLt,cfgDDLt,Monitor,MM,all
		stringreplace,cfgDDL,cfgDDLt,-,_,all
		Loop,parse,inifile,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				br= %A_Loopfield%
				stringleft,bra,br,1
				if (bra = "[")
					{
						stringtrimleft,br,br,1
						stringtrimright,sec,br,1
						continue
					}
				if instr(omitsec,sec)
					{
						continue
					}
				stringsplit,iva,br,=
				stringreplace,nvs,br,%iva1%=,,
				if (iva1 = cfgDDL)
					{
						nva=%nvs%
						break
					}
			}		
		stringreplace,nvat,nva,%A_Space%,·,All
		guicontrol,,inicfg,%nvat%
		return
		CfgBut:
		nva=
		nvs=
		iva1=
		iva2=
		gui,submit,nohide
		guicontrol,,inicfg,||
		guicontrolget,cfgDDLT,,cfgDDL
		cfgbutt=
		if instr(cfgfld,cfgDDLT)
			{
				goto,cfgfld
			}
		FileSelectFile,cfgbutt,35,*%home%\,Executable/Script,*.mon; *.xml; *.ini; *.cfg; *.conf; *.json; *.amgp; *.xpadder; *.keysticks
		if (cfgbutt = "")
			{
				return
			}
		cfgbut=%cfgbutt%
		goto,cfgb	
		cfgfld:
		FileSelectFolder,cfgbutt,%fldflt%,3,Select Folder
		if (cfgbutt = "")
			{
				return
			}
		cfgbut=%cfgbutt%
		cfgb:
		stringreplace,cfgddlt,cfgddlt,%A_Space%,,all
		stringreplace,cfgDDLt,cfgDDLt,-exe,-executable,all
		stringreplace,cfgDDLt,cfgDDLt,cfg,config,all
		stringreplace,cfgDDLt,cfgDDLt,Monitor,MM,all
		stringreplace,cfgddl,cfgddlt,-,_,all
		Loop,parse,inifile,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				br= %A_Loopfield%
				stringleft,bra,br,1
				if (bra = "[")
					{
						stringtrimleft,br,br,1
						stringtrimright,sec,br,1
						continue
					}
				if instr(omitsec,sec)
					{
						continue
					}
				stringsplit,iva,br,=
				stringreplace,nvs,br,%iva1%=,,
				if (iva1 = cfgDDL)
					{
						nva="%nvs%"
						break
					}
			}
		if ((iva1 = "GameData")or(iva1 = "SaveData"))
			{
				nva.= "|" . exebut
			}
		else {
			nva= %exebut%
		}	
		iniwrite,%nva%,%gamefini%,%sec%,%iva1%
		stringreplace,nvat,nva,%A_Space%,·,All
		guicontrol,,inicfg,%nvat%
		return	
		ExeBut:
		nva=
		nvs=
		iva1=
		iva2=
		gui,submit,nohide	
		guicontrol,,iniexe,||
		exebut=
		FileSelectFile,exebutt,35,%home%\,Executable/Script,*.exe; *.ps1; *.vb; *.bat; *.cmd; *.vbs
		if (exebutt = "")
			{
				return
			}
		exebut= %exebutt%	
		guicontrolget,exeDDLT,,exeDDL
		stringreplace,exeddlt,exeddlt,%A_Space%,,all
		stringreplace,exeddlt,exeddlt,-exe,-executable,all
		stringreplace,exeddlt,exeddlt,cfg,config,all
		stringreplace,exeddl,exeddlt,-,_,all
		Loop,parse,inifile,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				br= %A_Loopfield%
				stringleft,bra,br,1
				if (bra = "[")
					{
						stringtrimleft,br,br,1
						stringtrimright,sec,br,1
						continue
					}
				if instr(omitsec,sec)
					{
						continue
					}
				stringsplit,iva,br,=
				stringreplace,nvs,br,%iva1%=,,
				if (iva1 = exeddl)
					{
						nva=%nvs%
						break
					}
			}
		if (iva1 = "Exe_File")
			{
				splitpath,exebut,nva
				stringreplace,exebutt,nva,%A_Space%,·,All
			}
		iniwrite,%exebut%,%gamefini%,%sec%,%iva1%	
		stringreplace,exebutt,exebutt,%A_Space%,·,All
		guicontrol,,iniexe,%exebutt%
		return
		exeDDL:
		nva=
		nvs=
		iva1=
		iva2=
		gui,submit,nohide	
		guicontrol,,iniexe,||
		guicontrolget,exeDDLT,,exeDDL
		stringreplace,exeddlt,exeddlt,%A_Space%,,all
		stringreplace,exeddlt,exeddlt,-exe,-executable,all
		stringreplace,exeddlt,exeddlt,cfg,config,all
		stringreplace,exeddl,exeddlt,-,_,all
		Loop,parse,inifile,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				br= %A_Loopfield%
				stringleft,bra,br,1
				if (bra = "[")
					{
						stringtrimleft,br,br,1
						stringtrimright,sec,br,1
						continue
					}
				if instr(omitsec,sec)
					{
						continue
					}
				stringsplit,iva,br,=
				stringreplace,nvs,br,%iva1%=,,
				if (iva1 = exeddl)
					{
						nva=%nvs%
						break
					}
			}	
		stringreplace,nvat,nva,%A_Space%,·,All
		guicontrol,,iniexe,%nvat%	
		return
		iniBut:
		gamefinit=
		Loop,parse,ini_p,|
			{
				guicontrol,disable,%A_LoopField%
			}
		FileSelectFile,gamefinit,35,*%home%\,Profile Game ini,Game.ini; *.ini
		if (gamefinit = "")
			{
				Loop,parse,ini_p,|
					{
						guicontrol,hide,%A_LoopField%
						guicontrol,enable,%A_LoopField%
					}
				return
			}
		if (gamefinit <> "")
			{
				gamefini= %gamefinit%	
			}
		LoadGameIni:
		Guicontrol,,IniSel,
		Guicontrol,,MMODET,0
		Guicontrol,,TBARTOG,0
		Guicontrol,,MapDDL,|%MAPCFGS%
		Guicontrol,,exeDDL,|%exe_p%
		Guicontrol,,LCLeP,0
		Guicontrol,,CENeP,0
		Guicontrol,,iniexe,
		Guicontrol,,cfgDDL,|%cfg_p%
		Guicontrol,,LCLcP,0
		Guicontrol,,CENcP,0
		Guicontrol,,inicfg,
		Guicontrol,,PRFNAME,
		Guicontrol,,SappID,
		Guicontrol,,CloudsavEdt,
		Guicontrol,,CloudCfgEdt,
		Guicontrol,,cloudCfgDDL,
		Guicontrol,,cloudSavDDL,
		Fileread,inifile,%gamefini%
		SaveData=
		GameData=
		Loop,parse,inifile,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				br= %A_Loopfield%
				stringleft,bra,br,1
				if (bra = "[")
					{
						stringtrimleft,br,br,1
						stringtrimright,sec,br,1
						continue
					}
				if instr(omitsec,sec)
					{
						continue
					}
				stringsplit,iva,br,=
				stringreplace,nva,br,%iva1%=,,
				R_%iva1%:= nva
			}	
		if ((R_Steam_AppID <> "")&&(R_Steam_AppID <> 0))
			{
				guicontrol,,SappID,%R_Steam_AppID%
			}
		if ((MonitorMode <> 0)&&(MonitorMode <> ""))
			{
				guicontrol,,MMODET,1
			}
		if ((Hide_Taskbar <> 0)&&(Hide_Taskbar <> ""))
			{
				guicontrol,,TBARTOG,1
			}
		if (R_GameData <> "")
			{
				GameData=%R_GameData%
				guicontrol,,CloudCfgDDL,|%GameData%
			}
		if (R_SaveData <> "")
			{
				SaveData=%R_SaveData%
				guicontrol,,CloudSavDDL,|%SaveData%
			}
		if (R_JMAP <> "")
			{
				guicontrol,,MAPDDL,|%R_JMAP%||%MAPCFGS%
			}
		gui,submit,nohide
		splitpath,gamefini,,gamefpth
		splitpath,gamefpth,gamefname
		guicontrol,,PRFNAME,%gamefname%
		Loop,parse,ini_P,|
			{
				guicontrol,show,%A_LoopField%
				guicontrol,enable,%A_LoopField%
			}
		stringreplace,nvat,gamefini,%A_Space%,·,All
		guicontrol,,IniSel,%nvat%	
		return
/*  ;;[DEBUG32]		
		THEMEN:
		gui,submit,nohide
		guicontrolget,themen,,THEMEN
		if instr(themen,"Light")
			{
				iniwrite,Default,%RJDBINI%,THEME,GUI_Light_BG
				iniwrite,cSilver s7,Inter UI,%RJDBINI%,THEME,Gui_Light_FontL
				iniwrite,cSilver s7,Hermit,%RJDBINI%,THEME,Gui_Light_FontS
				iniwrite,c151515 s7,Hermit,%RJDBINI%,THEME,Gui_Light_FontM
				iniwrite,cSilver s7,Anka/Coder,%RJDBINI%,THEME,Gui_Light_FontB
				iniwrite,c151515 s7,Trueno,%RJDBINI%,THEME,Gui_Light_FontG
				SB_SetText("Theme change may require restarting [RJ_PROJ]")
			}
		if instr(themen,"Dark")
			{
				iniwrite,151515,%RJDBINI%,THEME,GUI_Dark_BG
				iniwrite,cWhite s7,Inter UI,%RJDBINI%,THEME,Gui_Light_FontL
				iniwrite,cSilver s7,Hermit,%RJDBINI%,THEME,Gui_Light_FontS
				iniwrite,cSilver s7,Hermit,%RJDBINI%,THEME,Gui_Light_FontM
				iniwrite,cWhite s7,Anka/Coder,%RJDBINI%,THEME,Gui_Light_FontB
				iniwrite,cWhite s7,Trueno,%RJDBINI%,THEME,Gui_Light_FontG
				SB_SetText("Theme change requires restart")
			}
		iniwrite,%themen%,%RJDBINI%,THEME,GUI_theme_name
		ThemeA= Native_Dark|Native_Light|LightMode.msstyles|LightMode.she|DarkMode.msstyles|DarkMode.she|
		stringreplace,ThemeA,ThemeA,%themen%|,,
		Guicontrol,,ThemeN,|%themen%||%themeA%
		if instr(ThemeN,"msstyles")
			{
				DllCall(binhome . "\USkin.dll" . "\USkinExit")
				DllCall(binhome . "\USkin.dll" . "\USkinInit", Int,0, Int,0, AStr,_Skin)
				Gui, Hide
				SkinForm(0)
				Gui, Destroy
				GuiOpen := 0
				while (1) 
					{
						if (GuiOpen)
							Sleep, 500
						else
							break
					}
				SkinForm("0", binhome "\USkin.dll", SkinStyle . ThemeN)
				SkinForm(Apply, binhome "\USkin.dll", SkinStyle . ThemeN)
				goto, ThemeRenew
			}
		if instr(ThemeN,"she")
			{
				hSkinH := DllCall("LoadLibrary", "Str", binhome "\SkinHu.dll")
				LV_GetText(OutputVar, A_EventInfo)
				DllCall("SkinHu\SkinH_AttachEx", "Str", SkinStyle . ThemeN)
				goto, ThemeRenew
			}
		return
		ThemeRenew:
		return
*/  ;;[DEBUG32]	

		UpdateRJLR:
		curemote= originalBinary
		gosub, BINGETS
		UPDATING= 1
		gosub, DOWNLOADIT
		UPDATING:= ""
		ifexist,%save%
			{
				Process, close, %RJEXFN%.exe
				Process, close, Update.exe
				Process, close, Source_Builder.exe
				Process, close, NewOSK.exe
				Process, close, lrdeploy.exe
				FileCopy, %binhome%\Update.exe, %A_Temp%
				Run, "%A_Temp%\Update.exe" "%save%"
				Process, close, Setup.exe
				goto, QUITOUT
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
		Menu,PP_RCMenu,Add,: Download ::>,PPDownload
		Menu,PP_RCMenu,Add,,
		Menu,PP_RCMenu,Add,Cloud_Backup,PreCloud
		if (fileexist(binhome . "\" . "SoundVolumeView.exe")or instr(vikb,"SoundVolumeView.exe"))
			{
				Menu,PP_RCMenu,Add,,
				Menu,PP_RCMenu,Add,SoundVolumeView,SVV_Prog
			}
		if (fileexist(binhome . "\" . "OpenCloudSave" . "\" . "OpenCloudSave.exe")or instr(vikb,"OpenCloudSave.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,OpenCloudSave,OpenCloudSave_Prog
				}
		if (fileexist(binhome . "\" . "ludusavi" . "\" . "ludusavi.exe")or instr(vikb,"ludusavi.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,ludusavi,ludusavi_Prog
				}
		if (fileexist(binhome . "\" . "rclone" . "\" . "rclone.exe")or instr(vikb,"rclone.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,rclone,RCLONE_Prog
				}
		if (fileexist(binhome . "\" . "syncthing" . "\" . "syncthing.exe")or instr(vikb,"syncthing.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,syncthing,SYN_Prog
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
		Menu,PP_RCMenu,Add,: Download ::>,PPDownload
		Menu,PP_RCMenu,Add,,
		Menu,PP_RCMenu,Add,Cloud_Backup,PostCloud
		Menu,PP_RCMenu,Add,,
		if (fileexist(binhome . "\" . "SoundVolumeView.exe")or instr(vikb,"SoundVolumeView.exe"))
			{
				Menu,PP_RCMenu,Add,SoundVolumeView,SVV_Prog
			}
		if (fileexist(binhome . "\" . "OpenCloudSave" . "\" . "OpenCloudSave.exe")or instr(vikb,"OpenCloudSave.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,OpenCloudSave,OpenCloudSave_Prog
				}
		if (fileexist(binhome . "\" . "ludusavi" . "\" . "ludusavi.exe")or instr(vikb,"ludusavi.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,ludusavi,ludusavi_Prog
				}
		if (fileexist(binhome . "\" . "rclone" . "\" . "rclone.exe")or instr(vikb,"rclone.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,rclone,RCLONE_Prog
				}
		if (fileexist(binhome . "\" . "syncthing" . "\" . "syncthing.exe")or instr(vikb,"syncthing.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,syncthing,SYN_Prog
				}
		Menu,PP_RCMenu,Show,%MENU_X% %MENU_Y%
		return
		KBM_RC:
		butrclick:= "Keyboard_MapB"
		kbmrc:= 1
		Menu,KBM_RCMenu,Show, x52 y224
		return
		KeyCfgM:
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
		return
		ButtonClear:
		if (srcntot > 25)
			{
				Msgbox,8449,Confirm,You are about to clear an item list of`n %srcntot% games.`nAre you sure?
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
				if (FocusedRowNumber = 0)
					{
						return
					}
				Critical
				RowNumber:= 0 ; This causes the first loop iteration to start the search at the top of the list.
				SOURCEDLIST:= ""
				Loop
					{
						RowNumber := LV_GetNext() ;get first selected row
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
						stringreplace,NSOURCEDLIST,SOURCEDLIST,??,?,All
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
				/*  ;;[DEBUGOV]
					ToolTip, % "Changes in " . A_GuiControl . "`r`n`r`n" . Msx
					SetTimer, KillToolTip, 2000
				*/  ;;[DEBUGOV]
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
					if ((OnTxt = "0") or (OnTxt = "y") or (OnTxt = "1") or (OnTxt = "5") or (OnTxt = "6") or (OnTxt = "8") or (OnTxt = "9") or (OnTxt = "n"))
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
				stringreplace,SOURCEDLIST,SOURCEDLIST,??,?,All
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
		splitpath,save,svaf,svap
		dwnovwr:= "True"
		if (!fileexist(jsave)&& (Net_Check = 1))
			{
				gosub, DWNCONFIRM
			}
		if (!fileexist(jsave)&&(STMTRY < 4)&&(GLBTRY < 8))
			{
				STMTRY+=1
				goto, steamappinfo
			}
		else {
			if ((STMTRY > 3)or(GLBTRY > 7))
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
		/*
			URLFILE=%STEAMDBI%/%steamquery%/config
			dsave= %sidn%\steamdb.info.html
			save= %dsave%
			dwnovwr=True
			if !fileexist(dsave)
			{
				gosub, DWNCONFIRM
			}
			if !fileExist(dsave)
			{
				SB_SetText("SteamDBInfo html not downloaded")
			}
		*/
		if fileExist(hsave)
			{
				gosub, READSTBINFO
			}
		if (PCGWTRY = 4)
			{
				CNCLPCW= 1
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
								APIPCGW:
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
								URLFILE:= PCGWAPI . steamquery
								hsave= %sidn%\%nvarz%.html
								save= %hsave%
								splitpath,save,svaf,svap
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
												if (PCGWTRY > 4)
													{
														URLFILE:= PCGWURL . pcgws
														goto, GETPCGW
													}
																		;goto, APIPCGW
											}
									}
								if fileExist(hsave)
									{
										gosub, READPCGW
									}
								if (!fileExist(hsave)&&(CNCLPCW <> 1))
									{
										PCGWTRY:= 4
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
		if (exedpl = 1)
			{
				extractloc:= sidn . "\" . xtractpath
			}
		extractlocf= "%extractloc%"
		filecreateDir,%home%\downloaded
		save:= home . "\downloaded\" . binarcf
		splitpath,save,savefile,savepath,savextn
		svaf= %savefile%
		svap=%savepath%
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
							;exe_get(ARIA,URLFILE,svap,svaf,CURPID,cacheloc)
		dwnovwr=False
		SB_SetText(" " binarcf " ""downloaded")
		if (exedpl = 1)
			{
				goto, EXTRACTING
			}
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
		GUIMSG:=
		for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
			{
				btt(GUIMSG,,,,"Style2",{Transparent:v})
				Sleep, 30
			}
		Sleep, 500
		if (fileexist(save)&& !fileexist(exetfndex))
			{
				GUIMSG:= "Extracting..."
				for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
					{
						btt(GUIMSG,,,,"Style2",{Transparent:v})
						Sleep, 30
					}
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
								goto, QUITOUT
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
				GUIMSG:= "Extracted."
				for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
					{
						btt(GUIMSG,,,,"Style2",{Transparent:v})
						Sleep, 30
					}
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
		GUIMSG:= ""
		for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
			{
				btt(GUIMSG,,,,"Style2",{Transparent:v})
				Sleep, 30
			}
		ifnotexist,%save%
			{
				msgbox,258,Download Failed,%binarcf% did not download.`nYou may select the location of support files later`n`nContinue?
				ifmsgbox,Abort
					{
						if (curemote = "originalBinary")
							{
								goto, QUITOUT
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
		Loop,6
			{
				URLNX%A_Index%:= ""
			}
		renfrm:= ""
		rento:= ""
		iniread,URLFILESPLIT,%RJREPOS%,BINARIES,%curemote%
		stringsplit,URLNX,URLFILESPLIT,|
		URLFILE:= URLNX1
		Splitpath,URLFILE,binarcf
		exetfndsp:= URLNX2
		exetfndex:= home . "\bin\" URLNX2
		xtractpath:= URLNX3
		if (exedpl = 1)
			{
				xtractpath:= sidn . "\" URLNX2
				exetfndex:= sidn . "\" URLNX2
			}
		redp:= ""
		if instr(xtractpath,"{temp}")
			{
				stringreplace,xtractpath,xtractpath,{temp},%home%\downloaded
				redp:= 1
			}
		if (urlnx4 <> "")
			{
				stringsplit,rensp,urlnx4,?
				renfrm:= rensp1
				if (exedpk = 1)
					{
						stringreplace,renfrm,renfrm,{home},%sidn%,											
					}
				stringreplace,renfrm,renfrm,{home},%home%,
				rento:= rensp2
			}
		msi:= ""
		if instr(exetfndsp,".msi")
		{
			msi:= 1
		}
		if (URLFILE = "") or (URLFILE = "ERROR")
		{
			URLFILE:= URLFILESPLIT
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
				Menu,PP_RCMenu,Add,: Download ::>,PPDownload
				Menu,PP_RCMenu,Add,,
				Menu,PP_RCMenu,Add,Cloud_Backup,PostCloud
				Menu,PP_RCMenu,Add,,
				if (fileexist(binhome . "\" . "SoundVolumeView.exe")or instr(vikb,"SoundVolumeView.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,SoundVolumeView,SNDVOLVIEWDOWNLOAD
				}
				if (fileexist(binhome . "\" . "OpenCloudSave" . "\" . "OpenCloudSave.exe")or instr(vikb,"OpenCloudSave.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,OpenCloudSave,OpenCloudSaveDOWNLOAD
				}
				if (fileexist(binhome . "\" . "ludusavi" . "\" . "ludusavi.exe")or instr(vikb,"ludusavi.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,ludusavi,ludusaviDOWNLOAD
				}
				if (fileexist(binhome . "\" . "rclone" . "\" . "rclone.exe")or instr(vikb,"rclone.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,rclone,rcloneDOWNLOAD
				}
				if (fileexist(binhome . "\" . "syncthing" . "\" . "syncthing.exe")or instr(vikb,"syncthing.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,syncthing,SYNCTHINGDOWNLOAD
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
				Menu,PP_RCMenu,Add,: Download ::>,PPDownload
				Menu,PP_RCMenu,Add,,
				Menu,PP_RCMenu,Add,Cloud_Backup,PreCloud
				Menu,PP_RCMenu,Add,,
				if (fileexist(binhome . "\" . "SoundVolumeView.exe")or instr(vikb,"SoundVolumeView.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,SoundVolumeView,SNDVOLVIEWDOWNLOAD
				}				
				if (fileexist(binhome . "\" . "OpenCloudSave" . "\" . "OpenCloudSave.exe")or instr(vikb,"OpenCloudSave.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,OpenCloudSave,OpenCloudSaveDOWNLOAD
				}
				if (fileexist(binhome . "\" . "ludusavi" . "\" . "ludusavi.exe")or instr(vikb,"ludusavi.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,ludusavi,ludusaviDOWNLOAD
				}
				if (fileexist(binhome . "\" . "rclone" . "\" . "rclone.exe")or instr(vikb,"rclone.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,rclone,rcloneDOWNLOAD
				}
				if (fileexist(binhome . "\" . "syncthing" . "\" . "syncthing.exe")or instr(vikb,"syncthing.exe"))
				{
					Menu,PP_RCMenu,Add,,
					Menu,PP_RCMenu,Add,syncthing,SYNCTHINGDOWNLOAD
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
		ContextEditProfile:
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
				if fileexist(explthf . "\" . "Game.ini")
					{
						gamefini= %explthf%\Game.ini
						gosub, LoadGameIni
						GuiControl, Choose, TABMENU, 3
						break
					}
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
			epvsec= GENERAL
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
		GUIMSG:= "!!!!!Incorrect Values may lead to program malfunction!!!!!"
		for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
		{
			btt(GUIMSG,,,,"Style2",{Transparent:v})
			Sleep, 30
		}
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
		if (MultiMonitor_Tool = "") ;*[working]
		{ ;*[working]
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
		gosub,%MONGT%PROG
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
		GetMetaData:
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
				LV_GetText(cg_exe, RowNumber, 2)
				LV_GetText(cg_path, RowNumber, 3)
				LV_GetText(steamquery, RowNumber, 18)
				LV_GetText(njName, RowNumber, 5)
				if ((njName <> "")&&(steamquery <> "0")&&(steamquery <> ""))
				{
					sidn= %Game_Profiles%\%njName%
					if (LOCALIZE = 1)
					{
						sidn= %cg_path%
					}
					gosub, steamappinfo
				}
			}
			if ((clicncld = 1)or (RowNumber = 0) or(GLBTRY > 7))
			{
				break
			}
		}
		return
		AddCLI:
		clicncld=
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
				if ((clicncld = 1)or (RowNumber = 0))
				{
					break
				}
			}
		}
		return
		ADCLIFUNC:
		deftop= [options] `"{TARGET}`" [arguments]
		Gui +LastFound +OwnDialogs +AlwaysOnTop
		InputBox, CLIADDED, add opts and args,replace [variables] with options and arguments`nRespected Expanded Variables`n{GameDir}: game's path`n{GameExe}: Game's Execuatable`n{ProfileDir}: Game's Jacket Dir`n `%programfiles`%: [ ]:\Program Files`n `%programfilesx86`%: [ ]:\Program Files (x86)`n `%username`%: current user name`n `%temp`%: system's temp folder`n Current Game: ''%nmFDir%\%nmFName%'', , 520, 300,,,,,%deftop%
		if ((CLIADDED = deftop)or(CLIADDED = ""))
		{
			clicncld= 1
			return
		}
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
		if ((clth = "")or (CLIADDED = "|"))
		{
			clicncld= 1
			return
		}
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
		READSTBINFO:
		fileread,stbih,%dsave%
		datve:= ""
		DATV:= ""
		pcgwin=
		GameData:= ""
		SaveData:= ""
		if (instr(stbih,nostmdbi)or instr(stbih,pcgwbr))
		{
			filedelete,%dsave%
			return
		}
		stmdbwin:= ""
		EXELAP=|
		ak=
		Loop,parse,stbih,`n`r
		{
			if (A_LoopField = "")
			{
				continue
			}
			if instr(A_LoopField,cb)
			{
				ak= 1
				continue
			}
			if (ak = 1)&& instr(A_LoopField,stmdbeb)&& instr(A_LoopField,stmdbee)
			{
				stringreplace,exenm,A_LoopField,%eb%,,
				stringreplace,exenm,exenm,%ee%,,
				if !instr(EXELAP,exenm . "|")
				{
					EXELAP.= exenm . "|"
				}
				ak=
				continue
			}
		}
		if (EXELAP <> "|")
		{
			iniread,STMGX,%gamecfg%,CONFIG,EXE_LIST
			if (STMGX = "ERROR")
			{
				STMGX=
			}
			Loop,parse,STMGX,|
			{
				if (A_LoopField = "")
				{
					continue
				}
				if instr(EXELAP,"|" . A_LoopField . "|")
				{
					stringreplace,EXELAP,EXELAP,%A_LoopField%|,,
				}
			}
			STMGX.= EXELAP
			iniwrite,%STMGX%,%gamecfg%,CONFIG,EXE_LIST
		}
		return
		READPCGW:
		fileread,pcgw,%hsave%
		filedelete,%hsave%
		datve:= ""
		DATV:= ""
		pcgwin=
		GameData:= ""
		SaveData:= ""
		if (instr(pcgw,nopcga)or instr(pcgw,nopcgw)or instr(pcgw,pcgwbt)or instr(pcgw,pcgwbr) or instr(pcgw,patsup))
		{
			PCGWTRY+=1
			return
		}
		GLBTRY:= 0
		pcgwin:= ""
		stringreplace,pcgw,pcgw,="/,="https://pcgamingwiki.com/,All
		stringreplace,pcgw,pcgw,="//,="https://,All
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
					stringreplace,infolinx,infolinx,%REGIF%,,All
					stringreplace,infolin,infolinx,%PC_GWB%,,All
					stringreplace,infolin,infolin,%PCGWB%,,All
					stringreplace,infolin,infolin,%DBINF%,,All
					stringreplace,infolin,infolin,%STINQ%,,All
					stringreplace,infolin,infolin,%STINF%,%Steam_Directory%,All
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
				;stringreplace,SaveData,SaveData,`%SYSTEM`%,%DRVSYSTM%,All
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
				;stringreplace,GameData,GameData,`%SYSTEM`%,%DRVSYSTM%,All
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
		fileappend,%pcgw%,%hsave%
		return
		MakeMeTop:
		GUIMSG:= "Respected Expanded Variables`n{GameDir}: game's path`n{GameExe}: Game's Execuatable`n{Profile}: Game's Jacket Dir`n`%programfiles`%:program files`n`%username`%`n`%username`%: user name`n`%temp`%: temp folder`nmore..."
		for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
			{
				btt(GUIMSG,,,,"Style2",{Transparent:v})
				Sleep, 30
			}
		WinSet, AlwaysOnTop, On, add opts/args
		Return
		ContextClearRows:
		gui,submit,nohide
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
				stringreplace,SOURCEDLIST,SOURCEDLIST,%lnv%,,
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
				nsrcdl.= A_LoopField . "`n"
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
		

Return

MenuHandler:
Return
testMenu:
Return

;;##########################################################################################
;{;##############################  FUNCTIONS ####################################
;;##########################################################################################;;

/*  ;;[DEBUG32]

SkinForm(Param1 = "Apply", DLL = "", SkinName = ""){
	;Dll:=binhome . "\Uskin.dll"
	if(Param1 = Apply){
		DllCall("LoadLibrary", str, DLL)
		DllCall(DLL . "\USkinInit", Int,0, Int,0, AStr, SkinName)
	}else if(Param1 = 0){
		DllCall(DLL . "\USkinExit")
		}
}
*/  ;;[DEBUG32]
Class CustomFont
{
	static FR_PRIVATE  := 0x10
	__New(FontFile, FontName="", FontSize=30) {
		if RegExMatch(FontFile, "i)res:\K.*", _FontFile) {
			this.AddFromResource(_FontFile, FontName, FontSize)
		} else {
			this.AddFromFile(FontFile)
		}
	}
	AddFromFile(FontFile) {
		DllCall( "AddFontResourceEx", "Str", FontFile, "UInt", this.FR_PRIVATE, "UInt", 0 )
		this.data := FontFile
	}
	AddFromResource(ResourceName, FontName, FontSize = 30) {
		static FW_NORMAL := 400, DEFAULT_CHARSET := 0x1
		nSize    := this.ResRead(fData, ResourceName)
		fh       := DllCall( "AddFontMemResourceEx", "Ptr", &fData, "UInt", nSize, "UInt", 0, "UIntP", nFonts )
		hFont    := DllCall( "CreateFont", Int,FontSize, Int,0, Int,0, Int,0, UInt,FW_NORMAL, UInt,0
		            , Int,0, Int,0, UInt,DEFAULT_CHARSET, Int,0, Int,0, Int,0, Int,0, Str,FontName )
		this.data := {fh: fh, hFont: hFont}
	}
	ApplyTo(hCtrl) {
		SendMessage, 0x30, this.data.hFont, 1,, ahk_id %hCtrl%
	}
	__Delete() {
		if IsObject(this.data) {
			DllCall( "RemoveFontMemResourceEx", "UInt", this.data.fh    )
			DllCall( "DeleteObject"           , "UInt", this.data.hFont )
		} else {
			DllCall( "RemoveFontResourceEx"   , "Str", this.data, "UInt", this.FR_PRIVATE, "UInt", 0 )
		}
	}
	; ResRead() By SKAN, from http://www.autohotkey.com/board/topic/57631-crazy-scripting-resource-only-dll-for-dummies-36l-v07/?p=609282
	ResRead( ByRef Var, Key ) {
		VarSetCapacity( Var, 128 ), VarSetCapacity( Var, 0 )
		If ! ( A_IsCompiled ) {
			FileGetSize, nSize, %Key%
			FileRead, Var, *c %Key%
			Return nSize
		}
		If hMod := DllCall( "GetModuleHandle", UInt,0 )
			If hRes := DllCall( "FindResource", UInt,hMod, Str,Key, UInt,10 )
				If hData := DllCall( "LoadResource", UInt,hMod, UInt,hRes )
					If pData := DllCall( "LockResource", UInt,hData )
						Return VarSetCapacity( Var, nSize := DllCall( "SizeofResource", UInt,hMod, UInt,hRes ) )
							,  DllCall( "RtlMoveMemory", Str,Var, UInt,pData, UInt,nSize )
		Return 0
	}
}
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
		if (CANCLD = 1)
		{
			return
		}
	}
	UrlDownloadToFile, %UrlToFile%, %_SaveFileAs%
	If (UseProgressBar) {
		GUIMSG:= ""
		for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
		{
			btt(GUIMSG,,,,"Style2",{Transparent:v})
			Sleep, 30
		}
	}
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
	if (CANCLD = 1)
	{
		return
	}
	if (PercentDone > 100)
	{
		GUIMSG:= ""
		for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
		{
			btt(GUIMSG,,,,"Style2",{Transparent:v})
			Sleep, 30
		}
		PercentDone=
	}
	/*  ;;[DEBUGOV]
		SB_SetText(" " Speed " at " PercentDone "`% " CurrentSize " bytes completed")
	*/  ;;[DEBUGOV]
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
	{ ;*[working]
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
WM_MOUSEMOVE(){
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
		for k, v in [15,35,55,75,95,115,135,155,175,195,215,235,255]
		{
			CurTTC:= % %CurrControl%_TT
			btt(CurTTC,,,,"Style2",{Transparent:v})
			Sleep, 30
		}
	catch
		SetTimer, RemoveToolTip, -2000
	return
	RemoveToolTip:
	for k, v in [240,220,200,180,160,140,120,100,80,60,40,20,0]
	{
		btt(CurTTC,,,,"Style2",{Transparent:v})
		Sleep, 30
	}
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
RevDir(a1, a2, offset)
{
	return offset
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
btt(Text:="", X:="", Y:="", WhichToolTip:="", BulitInStyleOrStyles:="", BulitInOptionOrOptions:="")
{
  static BTT
       , Style99 :=  {Border:20
                    , Rounded:30
                    , Margin:30
                    , TabStops:[50, 80, 100]
                    , BorderColor:0xffaabbcc
                    , BorderColorLinearGradientStart:0xff16a085
                    , BorderColorLinearGradientEnd:0xfff4d03f
                    , BorderColorLinearGradientAngle:45
                    , BorderColorLinearGradientMode:1
                    , TextColor:0xff112233
                    , TextColorLinearGradientStart:0xff00416a
                    , TextColorLinearGradientEnd:0xffe4e5e6
                    , TextColorLinearGradientAngle:90
                    , TextColorLinearGradientMode:1
                    , BackgroundColor:0xff778899
                    , BackgroundColorLinearGradientStart:0xff8DA5D3
                    , BackgroundColorLinearGradientEnd:0xffF4CFC9
                    , BackgroundColorLinearGradientAngle:135
                    , BackgroundColorLinearGradientMode:1
                    , Font:"Font Name"
                    , FontSize:20
                    , FontRender:5
                    , FontStyle:"Regular Bold Italic BoldItalic Underline Strikeout"}
       , Option99 := {TargetHWND:""
                    , CoordMode:"Screen Relative Window Client"
                    , Transparent:""
                    , MouseNeverCoverToolTip:""
                    , DistanceBetweenMouseXAndToolTip:""
                    , DistanceBetweenMouseYAndToolTip:""
                    , JustCalculateSize:""}
       , Style1 := {TextColor:0xffeef8f6
                  , BackgroundColor:0xff1b8dff
                  , FontSize:14}
       , Style2 := {Border:1
                  , Rounded:8
                  , TextColor:0xfff4f4f4
                  , BackgroundColor:0xaa3e3d45
                  , FontSize:14}
       , Style3 := {Border:2
                  , Rounded:0
                  , TextColor:0xffF15839
                  , BackgroundColor:0xffFCEDE6
                  , FontSize:14}
       , Style4 := {Border:10
                  , Rounded:20
                  , BorderColor:0xff604a78
                  , TextColor:0xffF3AE00
                  , BackgroundColor:0xff6A537F
                  , FontSize:20
                  , FontStyle:"Bold Italic"}
       , Style5 := {Border:0
                  , Rounded:5
                  , TextColor:0xffeeeeee
                  , BackgroundColorLinearGradientStart:0xff134E5E
                  , BackgroundColorLinearGradientEnd:0xff326f69
                  , BackgroundColorLinearGradientAngle:0
                  , BackgroundColorLinearGradientMode:1}
       , Style6 := {Border:2
                  , Rounded:5
                  , TextColor:0xffCAE682
                  , BackgroundColor:0xff434343
                  , FontSize:14}
       , Style7 := {Border:20
                  , Rounded:30
                  , Margin:30
                  , BorderColor:0xffaabbcc
                  , TextColor:0xff112233
                  , BackgroundColorLinearGradientStart:0xffF4CFC9
                  , BackgroundColorLinearGradientEnd:0xff8DA5D3
                  , BackgroundColorLinearGradientAngle:0
                  , BackgroundColorLinearGradientMode:1
                  , FontStyle:"BoldItalic"}
       , Style8 := {Border:3
                  , Rounded:30
                  , Margin:30
                  , BorderColorLinearGradientStart:0xffb7407c
                  , BorderColorLinearGradientEnd:0xff3881a7
                  , BorderColorLinearGradientAngle:45
                  , BorderColorLinearGradientMode:1
                  , TextColor:0xffd9d9db
                  , BackgroundColor:0xff26293a}
  if (BTT="")
    BTT := new BeautifulToolTip()
  return, BTT.ToolTip(Text, X, Y, WhichToolTip
                    , %BulitInStyleOrStyles%=""   ? BulitInStyleOrStyles   : %BulitInStyleOrStyles%
                    , %BulitInOptionOrOptions%="" ? BulitInOptionOrOptions : %BulitInOptionOrOptions%)
}
Class BeautifulToolTip
{
  static DebugMode:=0
  __New()
  {
    if (!this.pToken)
    {
      SavedBatchLines:=A_BatchLines
      SetBatchLines, -1
      this.pToken := Gdip_Startup(1)
      if (!this.pToken)
      {
        MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
/*  ;;[DEBUG32
        SkinForm(0)
*/  ;;[DEBUG32		
		exitapp
      }
      this.Monitors := MDMF_Enum()
      for hMonitor, v in this.Monitors.Clone()
      {
        if (hMonitor="TotalCount" or hMonitor="Primary")
          continue
        osv := StrSplit(A_OSVersion, ".")
        if (osv[1] < 6 || (osv[1] == 6 && osv[2] < 3))
        {
          hDC  := DllCall("Gdi32.dll\CreateDC", "Str", hMonitor.name, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
          dpiX := DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", hDC, "Int", 88)
          DllCall("Gdi32.dll\DeleteDC", "Ptr", hDC)
        }
        else
          DllCall("Shcore.dll\GetDpiForMonitor", "Ptr", hMonitor, "Int", Type, "UIntP", dpiX, "UIntP", dpiY, "UInt")
        this.Monitors[hMonitor].DPIScale := this.NonNull_Ret(dpiX, A_ScreenDPI)/96
      }
      SysGet, VirtualWidth, 78
      SysGet, VirtualHeight, 79
      this.DIBWidth  := VirtualWidth
      this.DIBHeight := VirtualHeight
      this.ToolTipFontName := this.Fnt_GetTooltipFontName()
      loop, 20
      {
        Gui, _BTT%A_Index%: +E0x80000 -Caption +ToolWindow +LastFound +AlwaysOnTop +Hwnd_hBTT%A_Index%
        Gui, _BTT%A_Index%: Show, NA
          this["hBTT" A_Index] := _hBTT%A_Index%
        , this["hbm" A_Index]  := CreateDIBSection(this.DIBWidth, this.DIBHeight)
        , this["hdc" A_Index]  := CreateCompatibleDC()
        , this["obm" A_Index]  := SelectObject(this["hdc" A_Index], this["hbm" A_Index])
        , this["G" A_Index]    := Gdip_GraphicsFromHDC(this["hdc" A_Index])
        , Gdip_SetSmoothingMode(this["G" A_Index], 4)
        , Gdip_SetPixelOffsetMode(this["G" A_Index], 2)
      }
      SetBatchLines, %SavedBatchLines%
    }
    else
      return
  }
  __Delete()
  {
    loop, 20
    {
        Gdip_DeleteGraphics(this["G" A_Index])
      , SelectObject(this["hdc" A_Index], this["obm" A_Index])
      , DeleteObject(this["hbm" A_Index])
      , DeleteDC(this["hdc" A_Index])
    }
    Gdip_Shutdown(this.pToken)
  }
  ToolTip(Text:="", X:="", Y:="", WhichToolTip:="", Styles:="", Options:="")
  {
    this.NonNull(WhichToolTip, 1, 1, 20)
    O:=this._CheckStylesAndOptions(Styles, Options)
    FirstCallOrNeedToUpdate:=(Text       != this["SavedText" WhichToolTip] 
                           or O.Checksum != this["SavedOptions" WhichToolTip])
    if (Text="")
    {
      Gdip_GraphicsClear(this["G" WhichToolTip])
      UpdateLayeredWindow(this["hBTT" WhichToolTip], this["hdc" WhichToolTip])
        this["SavedText" WhichToolTip]        := ""
      , this["SavedOptions" WhichToolTip]     := ""
      , this["SavedX" WhichToolTip]           := ""
      , this["SavedY" WhichToolTip]           := ""
      , this["SavedW" WhichToolTip]           := ""
      , this["SavedH" WhichToolTip]           := ""
      , this["SavedTargetHWND" WhichToolTip]  := ""
      , this["SavedCoordMode" WhichToolTip]   := ""
      , this["SavedTransparent" WhichToolTip] := ""
      return
    }
    else if (FirstCallOrNeedToUpdate)
    {
      SavedBatchLines:=A_BatchLines
      SetBatchLines, -1
        TargetSize:=this._CalculateDisplayPosition(X, Y, "", "", O, GetTargetSize:=1)
      , MaxTextWidth:=TargetSize.W - O.Margin*2 - O.Border*2
      , MaxTextHeight:=(TargetSize.H*90)//100 - O.Margin*2 - O.Border*2
      , O.Width:=MaxTextWidth, O.Height:=MaxTextHeight
      , TextArea:=StrSplit(this._TextToGraphics(this["G" WhichToolTip], Text, O, Measure:=1), "|")
      , TextWidth:=Min(Ceil(TextArea[3]), MaxTextWidth)
      , TextHeight:=Min(Ceil(TextArea[4]), MaxTextHeight)
      , RectWidth:=TextWidth+O.Margin*2                                   
      , RectHeight:=TextHeight+O.Margin*2
      , RectWithBorderWidth:=RectWidth+O.Border*2                         
      , RectWithBorderHeight:=RectHeight+O.Border*2
      , R:=(O.Rounded>Min(RectWidth, RectHeight)//2) ? Min(RectWidth, RectHeight)//2 : O.Rounded
      if (O.JustCalculateSize!=1)
      {
        Gdip_GraphicsClear(this["G" WhichToolTip])
        if (O.BCLGA!="" and O.BCLGM and O.BCLGS and O.BCLGE)
          pBrushBorder := this._CreateLinearGrBrush(O.BCLGA, O.BCLGM, O.BCLGS, O.BCLGE
                                                  , 0, 0, RectWithBorderWidth, RectWithBorderHeight)
        else
          pBrushBorder := Gdip_BrushCreateSolid(O.BorderColor)
        if (O.Border>0)
          switch, R
          {
            case, "0": Gdip_FillRectangle(this["G" WhichToolTip]
            , pBrushBorder, 0, 0, RectWithBorderWidth, RectWithBorderHeight)
            Default  : Gdip_FillRoundedRectanglePath(this["G" WhichToolTip]
            , pBrushBorder, 0, 0, RectWithBorderWidth, RectWithBorderHeight, R)
          }
        if (O.BGCLGA!="" and O.BGCLGM and O.BGCLGS and O.BGCLGE)
          pBrushBackground := this._CreateLinearGrBrush(O.BGCLGA, O.BGCLGM, O.BGCLGS, O.BGCLGE
                                                      , O.Border, O.Border, RectWidth, RectHeight)
        else
          pBrushBackground := Gdip_BrushCreateSolid(O.BackgroundColor)
        switch, R
        {
          case, "0": Gdip_FillRectangle(this["G" WhichToolTip]
          , pBrushBackground, O.Border, O.Border, RectWidth, RectHeight)
          Default  : Gdip_FillRoundedRectanglePath(this["G" WhichToolTip]
          , pBrushBackground, O.Border, O.Border, RectWidth, RectHeight
          , (R>O.Border) ? R-O.Border : R)
        }
        Gdip_DeleteBrush(pBrushBorder)
        Gdip_DeleteBrush(pBrushBackground)
        O.X:=O.Border+O.Margin, O.Y:=O.Border+O.Margin, O.Width:=TextWidth, O.Height:=TextHeight
        if (TextArea[5]<StrLen(Text))
          TempText:=TextArea[5]>4 ? SubStr(Text, 1 ,TextArea[5]-4) "…………" : SubStr(Text, 1 ,1) "…………"
        else
          TempText:=Text
        this._TextToGraphics(this["G" WhichToolTip], TempText, O)
        if (this.DebugMode)
        {
          pBrush := Gdip_BrushCreateSolid(0x20ff0000)
          Gdip_FillRectangle(this["G" WhichToolTip], pBrush, O.Border+O.Margin, O.Border+O.Margin, TextWidth, TextHeight)
          Gdip_DeleteBrush(pBrush)
        }
        this._CalculateDisplayPosition(X, Y, RectWithBorderWidth, RectWithBorderHeight, O)
        UpdateLayeredWindow(this["hBTT" WhichToolTip], this["hdc" WhichToolTip]
                          , X, Y, RectWithBorderWidth, RectWithBorderHeight, O.Transparent)
        DllCall("SetWindowPos", "ptr", this["hBTT" WhichToolTip], "ptr", -1, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 26139)
      }
        this["SavedText" WhichToolTip]        := Text
      , this["SavedOptions" WhichToolTip]     := O.Checksum
      , this["SavedX" WhichToolTip]           := X
      , this["SavedY" WhichToolTip]           := Y
      , this["SavedW" WhichToolTip]           := RectWithBorderWidth
      , this["SavedH" WhichToolTip]           := RectWithBorderHeight
      , this["SavedTargetHWND" WhichToolTip]  := O.TargetHWND
      , this["SavedCoordMode" WhichToolTip]   := O.CoordMode
      , this["SavedTransparent" WhichToolTip] := O.Transparent
      SetBatchLines, %SavedBatchLines%
    }
    else if ((X="" or Y="") or O.CoordMode!="Screen"
          or O.TargetHWND!=this.SavedTargetHWND or O.CoordMode!=this.SavedCoordMode
          or O.Transparent!=this.SavedTransparent)
    {
      this._CalculateDisplayPosition(X, Y, this["SavedW" WhichToolTip], this["SavedH" WhichToolTip], O)
      if (X!=this["SavedX" WhichToolTip] or Y!=this["SavedY" WhichToolTip]
      or  O.Transparent!=this.SavedTransparent)
      {
        UpdateLayeredWindow(this["hBTT" WhichToolTip], this["hdc" WhichToolTip]
                          , X, Y, this["SavedW" WhichToolTip], this["SavedH" WhichToolTip], O.Transparent)
          this["SavedX" WhichToolTip]           := X
        , this["SavedY" WhichToolTip]           := Y
        , this["SavedTargetHWND" WhichToolTip]  := O.TargetHWND
        , this["SavedCoordMode" WhichToolTip]   := O.CoordMode
        , this["SavedTransparent" WhichToolTip] := O.Transparent
      }
    }
    ret:={Hwnd : this["hBTT" WhichToolTip]
        , X    : X
        , Y    : Y
        , W    : this["SavedW" WhichToolTip]
        , H    : this["SavedH" WhichToolTip]}
    return, ret
  }
  _TextToGraphics(pGraphics, Text, Options, Measure:=0)
  {
    static Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
    Style := 0
    for eachStyle, valStyle in StrSplit(Styles, "|")
    {
      if InStr(Options.FontStyle, valStyle)
        Style |= (valStyle != "StrikeOut") ? (A_Index-1) : 8
    }
    if (FileExist(Options.Font))
    {
      hFontCollection := Gdip_NewPrivateFontCollection()
      hFontFamily := Gdip_CreateFontFamilyFromFile(Options.Font, hFontCollection)
    }
    if !hFontFamily
      hFontFamily := Gdip_FontFamilyCreate(Options.Font)
    if !hFontFamily
      hFontFamily := Gdip_FontFamilyCreateGeneric(1)
    hFont := Gdip_FontCreate(hFontFamily, Options.FontSize * Options.DPIScale, Style, Unit:=0)
      hStringFormat := Gdip_StringFormatGetGeneric(1)
    if (Options.TCLGA!="" and Options.TCLGM and Options.TCLGS and Options.TCLGE
        and Options.Width and Options.Height)
    {
      pBrush := this._CreateLinearGrBrush(Options.TCLGA, Options.TCLGM, Options.TCLGS, Options.TCLGE
                                        , this.NonNull_Ret(Options.X, 0), this.NonNull_Ret(Options.Y, 0)
                                        , Options.Width, Options.Height)
    }
    else
      pBrush := Gdip_BrushCreateSolid(Options.TextColor)
    if !(hFontFamily && hFont && hStringFormat && pBrush && pGraphics)
    {
      E := !pGraphics ? -2 : !hFontFamily ? -3 : !hFont ? -4 : !hStringFormat ? -5 : !pBrush ? -6 : 0
      if pBrush
        Gdip_DeleteBrush(pBrush)
      if hStringFormat
        Gdip_DeleteStringFormat(hStringFormat)
      if hFont
        Gdip_DeleteFont(hFont)
      if hFontFamily
        Gdip_DeleteFontFamily(hFontFamily)
      if hFontCollection
        Gdip_DeletePrivateFontCollection(hFontCollection)
      return E
    }
    TabStops := []
    for k, v in Options.TabStops
      TabStops.Push(v * Options.DPIScale)
    Gdip_SetStringFormatTabStops(hStringFormat, TabStops)
    Gdip_SetStringFormatAlign(hStringFormat, Align:=0)
    Gdip_SetTextRenderingHint(pGraphics, Options.FontRender)
    CreateRectF(RC
              , this.NonNull_Ret(Options.X, 0)
              , this.NonNull_Ret(Options.Y, 0)
              , Options.Width, Options.Height)
    returnRC := Gdip_MeasureString(pGraphics, Text, hFont, hStringFormat, RC)
    if !Measure
      _E := Gdip_DrawString(pGraphics, Text, hFont, hStringFormat, pBrush, RC)
    Gdip_DeleteBrush(pBrush)
    Gdip_DeleteFont(hFont)
    Gdip_DeleteStringFormat(hStringFormat)
    Gdip_DeleteFontFamily(hFontFamily)
    if hFontCollection
      Gdip_DeletePrivateFontCollection(hFontCollection)
    return _E ? _E : returnRC
  }
  _CreateLinearGrBrush(Angle, Mode, StartColor, EndColor, x, y, w, h)
  {
    switch, Mode
    {
      case, 1,3,5,7:pBrush:=Gdip_CreateLinearGrBrush(x, y, x+w, y, StartColor, EndColor)
      case, 2,4,6,8:pBrush:=Gdip_CreateLinearGrBrush(x, y+h//2, x+w, y+h//2, StartColor, EndColor)
    }
    switch, Mode
    {
      case, 1,2: Gdip_RotateLinearGrBrushTransform(pBrush, Angle, 0)
      case, 3,4: Gdip_RotateLinearGrBrushTransform(pBrush, Angle, 1)
      case, 5,6: Gdip_RotateLinearGrBrushAtCenter(pBrush, Angle, 0)
      case, 7,8: Gdip_RotateLinearGrBrushAtCenter(pBrush, Angle, 1)
    }
    return, pBrush
  }
  _CheckStylesAndOptions(Styles, Options)
  {
      O := {}
    , O.Border          := this.NonNull_Ret(Styles.Border         , 1                   , 0 , 20)
    , O.Rounded         := this.NonNull_Ret(Styles.Rounded        , 3                   , 0 , 30)
    , O.Margin          := this.NonNull_Ret(Styles.Margin         , 5                   , 0 , 30)
    , O.TabStops        := this.NonNull_Ret(Styles.TabStops       , [50]                , "", "")
    , O.TextColor       := this.NonNull_Ret(Styles.TextColor      , 0xff575757          , "", "")
    , O.BackgroundColor := this.NonNull_Ret(Styles.BackgroundColor, 0xffffffff          , "", "")
    , O.Font            := this.NonNull_Ret(Styles.Font           , this.ToolTipFontName, "", "")
    , O.FontSize        := this.NonNull_Ret(Styles.FontSize       , 12                  , "", "")
    , O.FontRender      := this.NonNull_Ret(Styles.FontRender     , 5                   , 0 , 5 )
    , O.FontStyle       := Styles.FontStyle
    , O.BCLGS  := Styles.BorderColorLinearGradientStart
    , O.BCLGE  := Styles.BorderColorLinearGradientEnd
    , O.BCLGA  := Styles.BorderColorLinearGradientAngle
    , O.BCLGM  := this.NonNull_Ret(Styles.BorderColorLinearGradientMode, "", 1, 8)
    , O.TCLGS  := Styles.TextColorLinearGradientStart
    , O.TCLGE  := Styles.TextColorLinearGradientEnd
    , O.TCLGA  := Styles.TextColorLinearGradientAngle
    , O.TCLGM  := this.NonNull_Ret(Styles.TextColorLinearGradientMode, "", 1, 8)
    , O.BGCLGS := Styles.BackgroundColorLinearGradientStart
    , O.BGCLGE := Styles.BackgroundColorLinearGradientEnd
    , O.BGCLGA := Styles.BackgroundColorLinearGradientAngle
    , O.BGCLGM := this.NonNull_Ret(Styles.BackgroundColorLinearGradientMode, "", 1, 8)
    , BlendedColor2 := (O.TCLGS and O.TCLGE and O.TCLGD) ? O.TCLGS : O.TextColor
    , BlendedColor  := ((O.BackgroundColor>>24)<<24) + (BlendedColor2&0xffffff)
    , O.BorderColor := this.NonNull_Ret(Styles.BorderColor , BlendedColor      , "", "")
    , O.TargetHWND  := this.NonNull_Ret(Options.TargetHWND , WinExist("A")     , "", "")
    , O.CoordMode   := this.NonNull_Ret(Options.CoordMode  , A_CoordModeToolTip, "", "")
    , O.Transparent := this.NonNull_Ret(Options.Transparent, 255               , 0 , 255)
    , O.MouseNeverCoverToolTip          := this.NonNull_Ret(Options.MouseNeverCoverToolTip         , 1 , 0 , 1 )
    , O.DistanceBetweenMouseXAndToolTip := this.NonNull_Ret(Options.DistanceBetweenMouseXAndToolTip, 16, "", "")
    , O.DistanceBetweenMouseYAndToolTip := this.NonNull_Ret(Options.DistanceBetweenMouseYAndToolTip, 16, "", "")
    , O.JustCalculateSize               := Options.JustCalculateSize
    for k, v in O.TabStops
      TabStops .= v ","
    O.Checksum := O.Border          "|" O.Rounded  "|" O.Margin     "|" TabStops    "|"
                . O.BorderColor     "|" O.BCLGS    "|" O.BCLGE      "|" O.BCLGA     "|" O.BCLGM  "|"
                . O.TextColor       "|" O.TCLGS    "|" O.TCLGE      "|" O.TCLGA     "|" O.TCLGM  "|"
                . O.BackgroundColor "|" O.BGCLGS   "|" O.BGCLGE     "|" O.BGCLGA    "|" O.BGCLGM "|"
                . O.Font            "|" O.FontSize "|" O.FontRender "|" O.FontStyle
    return, O
  }
  _CalculateDisplayPosition(ByRef X, ByRef Y, W, H, Options, GetTargetSize:=0)
  {
      VarSetCapacity(Point, 8, 0)
    , DllCall("GetCursorPos", "Ptr", &Point)
    , MouseX := NumGet(Point, 0, "Int"), MouseY := NumGet(Point, 4, "Int")
    if (X="" and Y="")
    { ; 没有给出 x,y 则使用鼠标坐标
        DisplayX     := MouseX
      , DisplayY     := MouseY
      , hMonitor     := MDMF_FromPoint(DisplayX, DisplayY, MONITOR_DEFAULTTONEAREST:=2)
      , TargetLeft   := this.Monitors[hMonitor].Left
      , TargetTop    := this.Monitors[hMonitor].Top
      , TargetRight  := this.Monitors[hMonitor].Right
      , TargetBottom := this.Monitors[hMonitor].Bottom
      , TargetWidth  := TargetRight-TargetLeft
      , TargetHeight := TargetBottom-TargetTop
      , Options.DPIScale := this.Monitors[hMonitor].DPIScale
    }
    else if (Options.CoordMode  = "Window" or Options.CoordMode  = "Relative")
    { 
        WinGetPos, WinX, WinY, WinW, WinH, % "ahk_id " Options.TargetHWND
        XInScreen    := WinX+X
      , YInScreen    := WinY+Y
      , TargetLeft   := WinX
      , TargetTop    := WinY
      , TargetWidth  := WinW
      , TargetHeight := WinH
      , TargetRight  := TargetLeft+TargetWidth
      , TargetBottom := TargetTop+TargetHeight
      , DisplayX     := (X="") ? MouseX : XInScreen
      , DisplayY     := (Y="") ? MouseY : YInScreen
      , hMonitor     := MDMF_FromPoint(DisplayX, DisplayY, MONITOR_DEFAULTTONEAREST:=2)
      , Options.DPIScale := this.Monitors[hMonitor].DPIScale
    }
    else if (Options.CoordMode  = "Client")
    { 
        VarSetCapacity(ClientArea, 16, 0)
      , DllCall("GetClientRect", "Ptr", Options.TargetHWND, "Ptr", &ClientArea)
      , DllCall("ClientToScreen", "Ptr", Options.TargetHWND, "Ptr", &ClientArea)
      , ClientX      := NumGet(ClientArea, 0, "Int")
      , ClientY      := NumGet(ClientArea, 4, "Int")
      , ClientW      := NumGet(ClientArea, 8, "Int")
      , ClientH      := NumGet(ClientArea, 12, "Int")
        XInScreen    := ClientX+X
      , YInScreen    := ClientY+Y
      , TargetLeft   := ClientX
      , TargetTop    := ClientY
      , TargetWidth  := ClientW
      , TargetHeight := ClientH
      , TargetRight  := TargetLeft+TargetWidth
      , TargetBottom := TargetTop+TargetHeight
      , DisplayX     := (X="") ? MouseX : XInScreen
      , DisplayY     := (Y="") ? MouseY : YInScreen
      , hMonitor     := MDMF_FromPoint(DisplayX, DisplayY, MONITOR_DEFAULTTONEAREST:=2)
      , Options.DPIScale := this.Monitors[hMonitor].DPIScale
    }
    else 
    { 
        DisplayX     := (X="") ? MouseX : X
      , DisplayY     := (Y="") ? MouseY : Y
      , hMonitor     := MDMF_FromPoint(DisplayX, DisplayY, MONITOR_DEFAULTTONEAREST:=2)
      , TargetLeft   := this.Monitors[hMonitor].Left
      , TargetTop    := this.Monitors[hMonitor].Top
      , TargetRight  := this.Monitors[hMonitor].Right
      , TargetBottom := this.Monitors[hMonitor].Bottom
      , TargetWidth  := TargetRight-TargetLeft
      , TargetHeight := TargetBottom-TargetTop
      , Options.DPIScale := this.Monitors[hMonitor].DPIScale
    }
    if (GetTargetSize=1)
    {
        TargetSize   := []
      , TargetSize.X := TargetLeft
      , TargetSize.Y := TargetTop
      , TargetSize.W := Min(TargetWidth, this.DIBWidth)
      , TargetSize.H := Min(TargetHeight, this.DIBHeight)
      return, TargetSize
    }
      DPIScale := Options.DPIScale
    , DisplayX := (X="") ? DisplayX+Options.DistanceBetweenMouseXAndToolTip*DPIScale : DisplayX
    , DisplayY := (Y="") ? DisplayY+Options.DistanceBetweenMouseYAndToolTip*DPIScale : DisplayY
    , DisplayX := (DisplayX+W>=TargetRight)  ? TargetRight-W  : DisplayX
    , DisplayY := (DisplayY+H>=TargetBottom) ? TargetBottom-H : DisplayY
    , DisplayX := (DisplayX<TargetLeft) ? TargetLeft : DisplayX
    , DisplayY := (DisplayY<TargetTop)  ? TargetTop  : DisplayY
    if  (Options.MouseNeverCoverToolTip=1
    and (X="" or Y="")
    and MouseX>=DisplayX and MouseY>=DisplayY and MouseX<=DisplayX+W and MouseY<=DisplayY+H)
    {
      DisplayY := MouseY-H-16>=TargetTop ? MouseY-H-16 : MouseY+H+16<=TargetBottom ? MouseY+16 : DisplayY
    }
    X := DisplayX , Y := DisplayY
  }
  Fnt_GetTooltipFontName()
  {
    static LF_FACESIZE:=32
    return StrGet(this.Fnt_GetNonClientMetrics()+(A_IsUnicode ? 316:220)+28,LF_FACESIZE)
  }
  Fnt_GetNonClientMetrics()
  {
    static Dummy15105062
      ,SPI_GETNONCLIENTMETRICS:=0x29
      ,NONCLIENTMETRICS
    cbSize:=A_IsUnicode ? 500:340
    if (((GV:=DllCall("GetVersion"))&0xFF . "." . GV>>8&0xFF)>=6.0)
      cbSize+=4
    VarSetCapacity(NONCLIENTMETRICS,cbSize,0)
    NumPut(cbSize,NONCLIENTMETRICS,0,"UInt")
    if !DllCall("SystemParametersInfo"
      ,"UInt",SPI_GETNONCLIENTMETRICS
      ,"UInt",cbSize
      ,"Ptr",&NONCLIENTMETRICS
      ,"UInt",0)
      return false
    return &NONCLIENTMETRICS
  }
}
UpdateLayeredWindow(hwnd, hdcSrc, x:="", y:="", w:="", h:="", Alpha:=255) {
   if (x!="" && y!="")
   {
      VarSetCapacity(pt, 8)
      NumPut(x, pt, 0, "UInt")
      NumPut(y, pt, 4, "UInt")
   }
   if (w="" || h="")
      GetWindowRect(hwnd, W, H)
   return DllCall("UpdateLayeredWindow"
               , "UPtr", hwnd
               , "UPtr", 0
               , "UPtr", ((x = "") && (y = "")) ? 0 : &pt
               , "int64*", w|h<<32
               , "UPtr", hdcSrc
               , "Int64*", 0
               , "UInt", 0
               , "UInt*", Alpha<<16|1<<24
               , "UInt", 2)
}
BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, raster:="") {
   return DllCall("gdi32\BitBlt"
               , "UPtr", dDC
               , "int", dX, "int", dY
               , "int", dW, "int", dH
               , "UPtr", sDC
               , "int", sX, "int", sY
               , "uint", Raster ? Raster : 0x00CC0020)
}
StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster:="") {
   return DllCall("gdi32\StretchBlt"
               , "UPtr", ddc
               , "int", dX, "int", dY
               , "int", dW, "int", dH
               , "UPtr", sdc
               , "int", sX, "int", sY
               , "int", sW, "int", sH
               , "uint", Raster ? Raster : 0x00CC0020)
}
SetStretchBltMode(hdc, iStretchMode:=4) {
   return DllCall("gdi32\SetStretchBltMode"
                 , "UPtr", hdc, "int", iStretchMode)
}
SetImage(hwnd, hBitmap) {
   If (!hBitmap || !hwnd)
      Return
   E := DllCall("SendMessage", "UPtr", hwnd, "UInt", 0x172, "UInt", 0x0, Ptr, hBitmap)
   DeleteObject(E)
   return E
}
SetSysColorToControl(hwnd, SysColor:=15) {
   GetWindowRect(hwnd, W, H)
   bc := DllCall("GetSysColor", "Int", SysColor, "UInt")
   pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
   pBitmap := Gdip_CreateBitmap(w, h)
   G := Gdip_GraphicsFromImage(pBitmap)
   Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
   hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
   SetImage(hwnd, hBitmap)
   Gdip_DeleteBrush(pBrushClear)
   Gdip_DeleteGraphics(G)
   Gdip_DisposeImage(pBitmap)
   DeleteObject(hBitmap)
   return 0
}
Gdip_BitmapFromScreen(Screen:=0, Raster:="") {
   hhdc := 0
   if (Screen = 0)
   {
      _x := DllCall("GetSystemMetrics", "Int", 76)
      _y := DllCall("GetSystemMetrics", "Int", 77)
      _w := DllCall("GetSystemMetrics", "Int", 78)
      _h := DllCall("GetSystemMetrics", "Int", 79)
   } else if (SubStr(Screen, 1, 5) = "hwnd:")
   {
      hwnd := SubStr(Screen, 6)
      if !WinExist("ahk_id " hwnd)
         return -2
      GetWindowRect(hwnd, _w, _h)
      _x := _y := 0
      hhdc := GetDCEx(hwnd, 3)
   } else if IsInteger(Screen)
   {
      M := GetMonitorInfo(Screen)
      _x := M.Left, _y := M.Top, _w := M.Right-M.Left, _h := M.Bottom-M.Top
   } else
   {
      S := StrSplit(Screen, "|")
      _x := S[1], _y := S[2], _w := S[3], _h := S[4]
   }
   if (_x = "") || (_y = "") || (_w = "") || (_h = "")
      return -1
   chdc := CreateCompatibleDC()
   hbm := CreateDIBSection(_w, _h, chdc)
   obm := SelectObject(chdc, hbm)
   hhdc := hhdc ? hhdc : GetDC()
   BitBlt(chdc, 0, 0, _w, _h, hhdc, _x, _y, Raster)
   ReleaseDC(hhdc)
   pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
   SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
   return pBitmap
}
Gdip_BitmapFromHWND(hwnd, clientOnly:=0) {
   if DllCall("IsIconic", "ptr", hwnd)
      DllCall("ShowWindow", "ptr", hwnd, "int", 4)
   thisFlag := 0
   If (clientOnly=1)
   {
      VarSetCapacity(rc, 16, 0)
      DllCall("GetClientRect", "ptr", hwnd, "ptr", &rc)
      Width := NumGet(rc, 8, "int")
      Height := NumGet(rc, 12, "int")
      thisFlag := 1
   } Else GetWindowRect(hwnd, Width, Height)
   hbm := CreateDIBSection(Width, Height)
   hdc := CreateCompatibleDC()
   obm := SelectObject(hdc, hbm)
   PrintWindow(hwnd, hdc, 2 + thisFlag)
   pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
   SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
   return pBitmap
}
CreateRectF(ByRef RectF, x, y, w, h) {
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float")
   NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}
CreateRect(ByRef Rect, x, y, x2, y2) {
   VarSetCapacity(Rect, 16)
   NumPut(x, Rect, 0, "uint"),  NumPut(y, Rect, 4, "uint")
   NumPut(x2, Rect, 8, "uint"), NumPut(y2, Rect, 12, "uint")
}
CreateSizeF(ByRef SizeF, w, h) {
   VarSetCapacity(SizeF, 8)
   NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")
}
CreatePointF(ByRef PointF, x, y) {
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "float")
   NumPut(y, PointF, 4, "float")
}
CreatePointsF(ByRef PointsF, inPoints) {
   Points := StrSplit(inPoints, "|")
   PointsCount := Points.Length()
   VarSetCapacity(PointsF, 8 * PointsCount, 0)
   for eachPoint, Point in Points
   {
       Coord := StrSplit(Point, ",")
       NumPut(Coord[1], &PointsF, 8*(A_Index-1), "float")
       NumPut(Coord[2], &PointsF, (8*(A_Index-1))+4, "float")
   }
   Return PointsCount
}
CreateDIBSection(w, h, hdc:="", bpp:=32, ByRef ppvBits:=0, Usage:=0, hSection:=0, Offset:=0) {
   hdc2 := hdc ? hdc : GetDC()
   VarSetCapacity(bi, 40, 0)
   NumPut(40, bi, 0, "uint")
   NumPut(w, bi, 4, "uint")
   NumPut(h, bi, 8, "uint")
   NumPut(1, bi, 12, "ushort")
   NumPut(bpp, bi, 14, "ushort")
   NumPut(0, bi, 16, "uInt")
   hbm := DllCall("CreateDIBSection"
               , "UPtr", hdc2
               , "UPtr", &bi
               , "UInt", Usage
               , "UPtr*", ppvBits
               , "UPtr", hSection
               , "UInt", OffSet, "UPtr")
   if !hdc
      ReleaseDC(hdc2)
   return hbm
}
PrintWindow(hwnd, hdc, Flags:=2) {
   If ((A_OSVersion="WIN_XP" || A_OSVersion="WIN_2000" || A_OSVersion="WIN_2003") && flags=2)
      flags := 0
   return DllCall("PrintWindow", "UPtr", hwnd, "UPtr", hdc, "uint", Flags)
}
DestroyIcon(hIcon) {
   return DllCall("DestroyIcon", "UPtr", hIcon)
}
GetIconDimensions(hIcon, ByRef Width, ByRef Height) {
   Width := Height := 0
   VarSetCapacity(ICONINFO, size := 16 + 2 * A_PtrSize, 0)
   if !DllCall("user32\GetIconInfo", "UPtr", hIcon, "UPtr", &ICONINFO)
      return -1
   hbmMask := NumGet(&ICONINFO, 16, "UPtr")
   hbmColor := NumGet(&ICONINFO, 16 + A_PtrSize, "UPtr")
   VarSetCapacity(BITMAP, size, 0)
   if DllCall("gdi32\GetObject", "UPtr", hbmColor, "Int", size, "UPtr", &BITMAP)
   {
      Width := NumGet(&BITMAP, 4, "Int")
      Height := NumGet(&BITMAP, 8, "Int")
   }
   if !DeleteObject(hbmMask)
      return -2
   if !DeleteObject(hbmColor)
      return -3
   return 0
}
PaintDesktop(hdc) {
   return DllCall("PaintDesktop", "UPtr", hdc)
}
CreateCompatibleDC(hdc:=0) {
   return DllCall("CreateCompatibleDC", "UPtr", hdc)
}
SelectObject(hdc, hgdiobj) {
   return DllCall("SelectObject", "UPtr", hdc, "UPtr", hgdiobj)
}
DeleteObject(hObject) {
   return DllCall("DeleteObject", "UPtr", hObject)
}
GetDC(hwnd:=0) {
   return DllCall("GetDC", "UPtr", hwnd)
}
GetDCEx(hwnd, flags:=0, hrgnClip:=0) {
   return DllCall("GetDCEx", "UPtr", hwnd, "UPtr", hrgnClip, "int", flags)
}
ReleaseDC(hdc, hwnd:=0) {
   return DllCall("ReleaseDC", "UPtr", hwnd, "UPtr", hdc)
}
DeleteDC(hdc) {
   return DllCall("DeleteDC", "UPtr", hdc)
}
Gdip_LibraryVersion() {
   return 1.45
}
Gdip_LibrarySubVersion() {
   return 1.87 ; 29/09/2021
}
Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate := 0) {
   pBitmap := 0
   pStream := 0
   If !(BRAFromMemIn)
      Return -1
   Headers := StrSplit(StrGet(&BRAFromMemIn, 256, "CP0"), "`n")
   Header := StrSplit(Headers.1, "|")
   If (Header.Length() != 4) || (Header.2 != "BRA!")
      Return -2
   _Info := StrSplit(Headers.2, "|")
   If (_Info.Length() != 3)
      Return -3
   OffsetTOC := StrPut(Headers.1, "CP0")
   OffsetData := _Info.2
   SearchIndex := Alternate ? 1 : 2
   TOC := StrGet(&BRAFromMemIn + OffsetTOC, OffsetData - OffsetTOC - 1, "CP0")
   RX1 := A_AhkVersion < "2" ? "mi`nO)^" : "mi`n)^"
   Offset := Size := 0
   If RegExMatch(TOC, RX1 . (Alternate ? File "\|.+?" : "\d+\|" . File) . "\|(\d+)\|(\d+)$", FileInfo) {
      Offset := OffsetData + FileInfo.1
      Size := FileInfo.2
   }
   If (Size=0)
      Return -4
   hData := DllCall("GlobalAlloc", "UInt", 2, "UInt", Size, "UPtr")
   pData := DllCall("GlobalLock", "Ptr", hData, "UPtr")
   DllCall("RtlMoveMemory", "Ptr", pData, "Ptr", &BRAFromMemIn + Offset, "Ptr", Size)
   DllCall("GlobalUnlock", "Ptr", hData)
   DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", 1, "PtrP", pStream)
   pBitmap := Gdip_CreateBitmapFromStream(pStream)
   ObjRelease(pStream)
   Return pBitmap
}
Gdip_BitmapToBase64(pBitmap, Format, Quality:=90) {
    Format := "none." Format
    Return Gdip_SaveBitmapToFile(pBitmap, Format, Quality, 1)
}
Gdip_BitmapFromBase64(ByRef Base64) {
   pBitmap := 0
   DecLen := 0
   if !(DllCall("crypt32\CryptStringToBinary", "UPtr", &Base64, "UInt", 0, "UInt", 0x01, "UPtr", 0, "UIntP", DecLen, "UPtr", 0, "UPtr", 0))
      return -1
   VarSetCapacity(Dec, DecLen, 0)
   if !(DllCall("crypt32\CryptStringToBinary", "UPtr", &Base64, "UInt", 0, "UInt", 0x01, "UPtr", &Dec, "UIntP", DecLen, "UPtr", 0, "UPtr", 0))
      return -2
   if !(pStream := DllCall("shlwapi\SHCreateMemStream", "UPtr", &Dec, "UInt", DecLen, "UPtr"))
      return -3
   pBitmap := Gdip_CreateBitmapFromStream(pStream, 1)
   ObjRelease(pStream)
   return pBitmap
}
Gdip_CreateBitmapFromStream(pStream, useICM:=0) {
   pBitmap := 0
   function2call := (useICM=1) ? "ICM" : ""
   gdipLastError := DllCall("gdiplus\GdipCreateBitmapFromStream" function2call, "UPtr", pStream, "PtrP", pBitmap)
   Return pBitmap
}
Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h) {
   If (!pGraphics || !pPen || !w || !h)
      Return 2
   Return DllCall("gdiplus\GdipDrawRectangle", "UPtr", pGraphics, "UPtr", pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r) {
   If (!pGraphics || !pPen || !w || !h)
      Return 2
   Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
   Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
   Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
   Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
   _E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
   Gdip_ResetClip(pGraphics)
   Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
   Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
   Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
   Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
   Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
   Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
   Gdip_ResetClip(pGraphics)
   return _E
}
Gdip_DrawRoundedRectangle2(pGraphics, pPen, x, y, w, h, r, Angle:=0) {
   If (!pGraphics || !pPen || !w || !h)
      Return 2
   penWidth := Gdip_GetPenWidth(pPen)
   pw := penWidth / 2
   if (w <= h && (r + pw > w / 2))
   {
      r := (w / 2 > pw) ? w / 2 - pw : 0
   } else if (h < w && r + pw > h / 2)
   {
      r := (h / 2 > pw) ? h / 2 - pw : 0
   } else if (r < pw / 2)
   {
      r := pw / 2
   }
   r2 := r * 2
   path1 := Gdip_CreatePath(0)
   Gdip_AddPathArc(path1, x + pw, y + pw, r2, r2, 180, 90)
   Gdip_AddPathLine(path1, x + pw + r, y + pw, x + w - r - pw, y + pw)
   Gdip_AddPathArc(path1, x + w - r2 - pw, y + pw, r2, r2, 270, 90)
   Gdip_AddPathLine(path1, x + w - pw, y + r + pw, x + w - pw, y + h - r - pw)
   Gdip_AddPathArc(path1, x + w - r2 - pw, y + h - r2 - pw, r2, r2, 0, 90)
   Gdip_AddPathLine(path1, x + w - r - pw, y + h - pw, x + r + pw, y + h - pw)
   Gdip_AddPathArc(path1, x + pw, y + h - r2 - pw, r2, r2, 90, 90)
   Gdip_AddPathLine(path1, x + pw, y + h - r - pw, x + pw, y + r + pw)
   Gdip_ClosePathFigure(path1)
   If (Angle>0)
      Gdip_RotatePathAtCenter(path1, Angle)
   _E := Gdip_DrawPath(pGraphics, pPen, path1)
   Gdip_DeletePath(path1)
   return _E
}
Gdip_DrawRoundedRectanglePath(pGraphics, pPen, X, Y, W, H, R) {
   DllCall("Gdiplus.dll\GdipCreatePath", "UInt", 0, "PtrP", pPath)
   D := (R * 2), W -= D, H -= D
   DllCall("Gdiplus.dll\GdipAddPathArc", "Ptr", pPath, "Float", X, "Float", Y, "Float", D, "Float", D, "Float", 180, "Float", 90)
   DllCall("Gdiplus.dll\GdipAddPathArc", "Ptr", pPath, "Float", X + W, "Float", Y, "Float", D, "Float", D, "Float", 270, "Float", 90)
   DllCall("Gdiplus.dll\GdipAddPathArc", "Ptr", pPath, "Float", X + W, "Float", Y + H, "Float", D, "Float", D, "Float", 0, "Float", 90)
   DllCall("Gdiplus.dll\GdipAddPathArc", "Ptr", pPath, "Float", X, "Float", Y + H, "Float", D, "Float", D, "Float", 90, "Float", 90)
   DllCall("Gdiplus.dll\GdipClosePathFigure", "Ptr", pPath)
   RS := DllCall("Gdiplus.dll\GdipDrawPath", "Ptr", pGraphics, "Ptr", pPen, "Ptr", pPath)
   DllCall("Gdiplus.dll\GdipDeletePath", "Ptr", pPath)
   Return RS
}
Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h) {
   If (!pGraphics || !pPen || !w || !h)
      Return 2
   Return DllCall("gdiplus\GdipDrawEllipse", "UPtr", pGraphics, "UPtr", pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4) {
   If (!pGraphics || !pPen)
      Return 2
   Return DllCall("gdiplus\GdipDrawBezier"
               , "UPtr", pGraphics, "UPtr", pPen
               , "float", x1, "float", y1
               , "float", x2, "float", y2
               , "float", x3, "float", y3
               , "float", x4, "float", y4)
}
Gdip_DrawBezierCurve(pGraphics, pPen, Points) {
   If (!pGraphics || !pPen || !Points)
      Return 2
   iCount := CreatePointsF(PointsF, Points)
   Return DllCall("gdiplus\GdipDrawBeziers", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount)
}
Gdip_DrawClosedCurve(pGraphics, pPen, Points, Tension:="") {
   If (!pGraphics || !pPen || !Points)
      Return 2
   iCount := CreatePointsF(PointsF, Points)
   If IsNumber(Tension)
      Return DllCall("gdiplus\GdipDrawClosedCurve2", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount, "float", Tension)
   Else
      Return DllCall("gdiplus\GdipDrawClosedCurve", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount)
}
Gdip_DrawCurve(pGraphics, pPen, Points, Tension:="") {
   If (!pGraphics || !pPen || !Points)
      Return 2
   iCount := CreatePointsF(PointsF, Points)
   If IsNumber(Tension)
      Return DllCall("gdiplus\GdipDrawCurve2", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount, "float", Tension)
   Else
      Return DllCall("gdiplus\GdipDrawCurve", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount)
}
Gdip_DrawPolygon(pGraphics, pPen, Points) {
   If (!pGraphics || !pPen || !Points)
      Return 2
   iCount := CreatePointsF(PointsF, Points)
   Return DllCall("gdiplus\GdipDrawPolygon", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount)
}
Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle) {
   If (!pGraphics || !pPen || !w || !h)
      Return 2
   Return DllCall("gdiplus\GdipDrawArc"
               , "UPtr", pGraphics
               , "UPtr", pPen
               , "float", x, "float", y
               , "float", w, "float", h
               , "float", StartAngle
               , "float", SweepAngle)
}
Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle) {
   If (!pGraphics || !pPen || !w || !h)
      Return 2
   Return DllCall("gdiplus\GdipDrawPie", "UPtr", pGraphics, "UPtr", pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2) {
   If (!pGraphics || !pPen)
      Return 2
   Return DllCall("gdiplus\GdipDrawLine"
               , "UPtr", pGraphics, "UPtr", pPen
               , "float", x1, "float", y1
               , "float", x2, "float", y2)
}
Gdip_DrawLines(pGraphics, pPen, Points) {
   If (!pGraphics || !pPen || !Points)
      Return 2
   iCount := CreatePointsF(PointsF, Points)
   Return DllCall("gdiplus\GdipDrawLines", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "int", iCount)
}
Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h) {
   If (!pGraphics || !pBrush || !w || !h)
      Return 2
   Return DllCall("gdiplus\GdipFillRectangle"
               , "UPtr", pGraphics
               , "UPtr", pBrush
               , "float", x, "float", y
               , "float", w, "float", h)
}
Gdip_FillRoundedRectangle2(pGraphics, pBrush, x, y, w, h, r) {
   r := (w <= h) ? (r < w // 2) ? r : w // 2 : (r < h // 2) ? r : h // 2
   path1 := Gdip_CreatePath(0)
   Gdip_AddPathRectangle(path1, x+r, y, w-(2*r), r)
   Gdip_AddPathRectangle(path1, x+r, y+h-r, w-(2*r), r)
   Gdip_AddPathRectangle(path1, x, y+r, r, h-(2*r))
   Gdip_AddPathRectangle(path1, x+w-r, y+r, r, h-(2*r))
   Gdip_AddPathRectangle(path1, x+r, y+r, w-(2*r), h-(2*r))
   Gdip_AddPathPie(path1, x, y, 2*r, 2*r, 180, 90)
   Gdip_AddPathPie(path1, x+w-(2*r), y, 2*r, 2*r, 270, 90)
   Gdip_AddPathPie(path1, x, y+h-(2*r), 2*r, 2*r, 90, 90)
   Gdip_AddPathPie(path1, x+w-(2*r), y+h-(2*r), 2*r, 2*r, 0, 90)
   E := Gdip_FillPath(pGraphics, pBrush, path1)
   Gdip_DeletePath(path1)
   return E
}
Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r) {
   Region := Gdip_GetClipRegion(pGraphics)
   Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
   Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
   Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
   Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
   _E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
   Gdip_SetClipRegion(pGraphics, Region, 0)
   Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
   Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
   Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
   Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
   Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
   Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
   Gdip_SetClipRegion(pGraphics, Region, 0)
   Gdip_DeleteRegion(Region)
   return _E
}
Gdip_FillRoundedRectanglePath(pGraphics, pBrush, X, Y, W, H, R) {
   DllCall("Gdiplus.dll\GdipCreatePath", "UInt", 0, "PtrP", pPath)
   D := (R * 2), W -= D, H -= D
   DllCall("Gdiplus.dll\GdipAddPathArc", "Ptr", pPath, "Float", X, "Float", Y, "Float", D, "Float", D, "Float", 180, "Float", 90)
   DllCall("Gdiplus.dll\GdipAddPathArc", "Ptr", pPath, "Float", X + W, "Float", Y, "Float", D, "Float", D, "Float", 270, "Float", 90)
   DllCall("Gdiplus.dll\GdipAddPathArc", "Ptr", pPath, "Float", X + W, "Float", Y + H, "Float", D, "Float", D, "Float", 0, "Float", 90)
   DllCall("Gdiplus.dll\GdipAddPathArc", "Ptr", pPath, "Float", X, "Float", Y + H, "Float", D, "Float", D, "Float", 90, "Float", 90)
   DllCall("Gdiplus.dll\GdipClosePathFigure", "Ptr", pPath)
   RS := DllCall("Gdiplus.dll\GdipFillPath", "Ptr", pGraphics, "Ptr", pBrush, "Ptr", pPath)
   DllCall("Gdiplus.dll\GdipDeletePath", "Ptr", pPath)
   Return RS
}
Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode:=0) {
   If (!pGraphics || !pBrush || !Points)
      Return 2
   iCount := CreatePointsF(PointsF, Points)
   Return DllCall("gdiplus\GdipFillPolygon", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", &PointsF, "int", iCount, "int", FillMode)
}
Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle) {
   If (!pGraphics || !pBrush || !w || !h)
      Return 2
   Return DllCall("gdiplus\GdipFillPie"
               , "UPtr", pGraphics
               , "UPtr", pBrush
               , "float", x, "float", y
               , "float", w, "float", h
               , "float", StartAngle
               , "float", SweepAngle)
}
Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h) {
   If (!pGraphics || !pBrush || !w || !h)
      Return 2
   Return DllCall("gdiplus\GdipFillEllipse", "UPtr", pGraphics, "UPtr", pBrush, "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRegion(pGraphics, pBrush, hRegion) {
   If (!pGraphics || !pBrush || !hRegion)
      Return 2
   Return DllCall("gdiplus\GdipFillRegion", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", hRegion)
}
Gdip_FillPath(pGraphics, pBrush, pPath) {
   If (!pGraphics || !pBrush || !pPath)
      Return 2
   Return DllCall("gdiplus\GdipFillPath", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", pPath)
}
Gdip_FillClosedCurve(pGraphics, pBrush, Points, Tension:="", FillMode:=0) {
   If (!pGraphics || !pBrush || !Points)
      Return 2
   iCount := CreatePointsF(PointsF, Points)
   If IsNumber(Tension)
      Return DllCall("gdiplus\GdipFillClosedCurve2", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", &PointsF, "int", iCount, "float", Tension, "int", FillMode)
   Else
      Return DllCall("gdiplus\GdipFillClosedCurve", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", &PointsF, "int", iCount)
}
Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx:="", sy:="", sw:="", sh:="", Matrix:=1, Unit:=2, ImageAttr:=0) {
   If !ImageAttr
   {
      if !IsNumber(Matrix)
         ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
      else if (Matrix != 1)
         ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
   } Else usrImageAttr := 1
   if (sx="" && sy="" && sw="" && sh="")
   {
      sx := sy := 0
      Gdip_GetImageDimensions(pBitmap, sw, sh)
   }
   iCount := CreatePointsF(PointsF, Points)
   E := DllCall("gdiplus\GdipDrawImagePointsRect"
            , "UPtr", pGraphics
            , "UPtr", pBitmap
            , "UPtr", &PointsF
            , "int", iCount
            , "float", sX, "float", sY
            , "float", sW, "float", sH
            , "int", Unit
            , "UPtr", ImageAttr ? ImageAttr : 0
            , "UPtr", 0, "UPtr", 0)
   If (E=1 && A_LastError=8)
      E := 3
   if (ImageAttr && usrImageAttr!=1)
      Gdip_DisposeImageAttributes(ImageAttr)
   return E
}
Gdip_DrawImage(pGraphics, pBitmap, dx:="", dy:="", dw:="", dh:="", sx:="", sy:="", sw:="", sh:="", Matrix:=1, Unit:=2, ImageAttr:=0) {
   If (!pGraphics || !pBitmap)
      Return 2
   If !ImageAttr
   {
      if !IsNumber(Matrix)
         ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
      else if (Matrix!=1)
         ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
   } Else usrImageAttr := 1
   If (dx!="" && dy!="" && dw="" && dh="" && sx="" && sy="" && sw="" && sh="")
   {
      sx := sy := 0
      sw := dw := Gdip_GetImageWidth(pBitmap)
      sh := dh := Gdip_GetImageHeight(pBitmap)
   } Else If (sx="" && sy="" && sw="" && sh="")
   {
      If (dx="" && dy="" && dw="" && dh="")
      {
         sx := dx := 0, sy := dy := 0
         sw := dw := Gdip_GetImageWidth(pBitmap)
         sh := dh := Gdip_GetImageHeight(pBitmap)
      } Else
      {
         sx := sy := 0
         Gdip_GetImageDimensions(pBitmap, sw, sh)
      }
   }
   E := DllCall("gdiplus\GdipDrawImageRectRect"
            , "UPtr", pGraphics
            , "UPtr", pBitmap
            , "float", dX, "float", dY
            , "float", dW, "float", dH
            , "float", sX, "float", sY
            , "float", sW, "float", sH
            , "int", Unit
            , "UPtr", ImageAttr ? ImageAttr : 0
            , "UPtr", 0, "UPtr", 0)
   If (E=1 && A_LastError=8)
      E := 3
   if (ImageAttr && usrImageAttr!=1)
      Gdip_DisposeImageAttributes(ImageAttr)
   return E
}
Gdip_DrawImageFast(pGraphics, pBitmap, X:=0, Y:=0) {
   return DllCall("gdiplus\GdipDrawImage"
            , "UPtr", pGraphics
            , "UPtr", pBitmap
            , "float", X
            , "float", Y)
}
Gdip_DrawImageRect(pGraphics, pBitmap, X, Y, W, H) {
   return DllCall("gdiplus\GdipDrawImageRect"
            , "UPtr", pGraphics
            , "UPtr", pBitmap
            , "float", X, "float", Y
            , "float", W, "float", H)
}
Gdip_SetImageAttributesColorMatrix(clrMatrix, ImageAttr:=0, grayMatrix:=0, ColorAdjustType:=1, fEnable:=1, ColorMatrixFlag:=0) {
   If (StrLen(clrMatrix)<5 && ImageAttr)
      Return -1
   If (StrLen(clrMatrix)<5) || (ColorMatrixFlag=2 && StrLen(grayMatrix)<5)
      Return
   CreateColourMatrix(clrMatrix, ColourMatrix)
   If (ColorMatrixFlag=2)
      CreateColourMatrix(grayMatrix, GrayscaleMatrix)
   If !ImageAttr
   {
      created := 1
      ImageAttr := Gdip_CreateImageAttributes()
   }
   E := DllCall("gdiplus\GdipSetImageAttributesColorMatrix"
         , "UPtr", ImageAttr
         , "int", ColorAdjustType
         , "int", fEnable
         , "UPtr", &ColourMatrix
         , "UPtr", &GrayscaleMatrix
         , "int", ColorMatrixFlag)
   gdipLastError := E
   E := created=1 ? ImageAttr : E
   return E
}
CreateColourMatrix(clrMatrix, ByRef ColourMatrix) {
   VarSetCapacity(ColourMatrix, 100, 0)
   Matrix := RegExReplace(RegExReplace(clrMatrix, "^[^\d-\.]+([\d\.])", "$1", , 1), "[^\d-\.]+", "|")
   Matrix := StrSplit(Matrix, "|")
   Loop 25
   {
      M := (Matrix[A_Index] != "") ? Matrix[A_Index] : Mod(A_Index - 1, 6) ? 0 : 1
      NumPut(M, ColourMatrix, (A_Index - 1)*4, "float")
   }
}
Gdip_CreateImageAttributes() {
   ImageAttr := 0
   gdipLastError := DllCall("gdiplus\GdipCreateImageAttributes", "UPtr*", ImageAttr)
   return ImageAttr
}
Gdip_CloneImageAttributes(ImageAttr) {
   newImageAttr := 0
   gdipLastError := DllCall("gdiplus\GdipCloneImageAttributes", "UPtr", ImageAttr, "UPtr*", newImageAttr)
   return newImageAttr
}
Gdip_SetImageAttributesThreshold(ImageAttr, Threshold, ColorAdjustType:=1, fEnable:=1) {
   return DllCall("gdiplus\GdipSetImageAttributesThreshold", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable, "float", Threshold)
}
Gdip_SetImageAttributesResetMatrix(ImageAttr, ColorAdjustType) {
   return DllCall("gdiplus\GdipSetImageAttributesToIdentity", "UPtr", ImageAttr, "int", ColorAdjustType)
}
Gdip_SetImageAttributesGamma(ImageAttr, Gamma, ColorAdjustType:=1, fEnable:=1) {
   return DllCall("gdiplus\GdipSetImageAttributesGamma", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable, "float", Gamma)
}
Gdip_SetImageAttributesToggle(ImageAttr, ColorAdjustType, fEnable) {
   return DllCall("gdiplus\GdipSetImageAttributesNoOp", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable)
}
Gdip_SetImageAttributesOutputChannel(ImageAttr, ColorChannelFlags, ColorAdjustType:=1, fEnable:=1) {
   return DllCall("gdiplus\GdipSetImageAttributesOutputChannel", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable, "int", ColorChannelFlags)
}
Gdip_SetImageAttributesColorKeys(ImageAttr, ARGBLow, ARGBHigh, ColorAdjustType:=1, fEnable:=1) {
   Return DllCall("gdiplus\GdipSetImageAttributesColorKeys", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable, "uint", ARGBLow, "uint", ARGBHigh)
}
Gdip_SetImageAttributesWrapMode(ImageAttr, WrapMode, ARGB:=0) {
   Return DllCall("gdiplus\GdipSetImageAttributesWrapMode", "UPtr", ImageAttr, "int", WrapMode, "uint", ARGB, "int", 0)
}
Gdip_ResetImageAttributes(ImageAttr, ColorAdjustType) {
   Return DllCall("gdiplus\GdipResetImageAttributes", "UPtr", ImageAttr, "int", ColorAdjustType)
}
Gdip_GraphicsFromImage(pBitmap, InterpolationMode:="", SmoothingMode:="", PageUnit:="", CompositingQuality:="") {
   pGraphics := 0
   gdipLastError := DllCall("gdiplus\GdipGetImageGraphicsContext", "UPtr", pBitmap, "UPtr*", pGraphics)
   If (gdipLastError=1 && A_LastError=8)
      gdipLastError := 3
   If (pGraphics && !gdipLastError)
   {
      If (InterpolationMode!="")
         Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
      If (SmoothingMode!="")
         Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
      If (PageUnit!="")
         Gdip_SetPageUnit(pGraphics, PageUnit)
      If (CompositingQuality!="")
         Gdip_SetCompositingQuality(pGraphics, CompositingQuality)
   }
   return pGraphics
}
Gdip_GraphicsFromHDC(hDC, hDevice:="", InterpolationMode:="", SmoothingMode:="", PageUnit:="", CompositingQuality:="") {
   pGraphics := 0
   If hDevice
      gdipLastError := DllCall("Gdiplus\GdipCreateFromHDC2", "UPtr", hDC, "UPtr", hDevice, "UPtr*", pGraphics)
   Else
      gdipLastError := DllCall("gdiplus\GdipCreateFromHDC", "UPtr", hdc, "UPtr*", pGraphics)
   If (gdipLastError=1 && A_LastError=8)
      gdipLastError := 3
   If (pGraphics && !gdipLastError)
   {
      If (InterpolationMode!="")
         Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
      If (SmoothingMode!="")
         Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
      If (PageUnit!="")
         Gdip_SetPageUnit(pGraphics, PageUnit)
      If (CompositingQuality!="")
         Gdip_SetCompositingQuality(pGraphics, CompositingQuality)
   }
   return pGraphics
}
Gdip_GraphicsFromHWND(HWND, useICM:=0, InterpolationMode:="", SmoothingMode:="", PageUnit:="", CompositingQuality:="") {
   pGraphics := 0
   function2call := (useICM=1) ? "ICM" : ""
   gdipLastError := DllCall("gdiplus\GdipCreateFromHWND" function2call, "UPtr", HWND, "UPtr*", pGraphics)
   If (gdipLastError=1 && A_LastError=8)
      gdipLastError := 3
   If (pGraphics && !gdipLastError)
   {
      If (InterpolationMode!="")
         Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
      If (SmoothingMode!="")
         Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
      If (PageUnit!="")
         Gdip_SetPageUnit(pGraphics, PageUnit)
      If (CompositingQuality!="")
         Gdip_SetCompositingQuality(pGraphics, CompositingQuality)
   }
   return pGraphics
}
Gdip_GetDC(pGraphics) {
   hDC := 0
   gdipLastError := DllCall("gdiplus\GdipGetDC", "UPtr", pGraphics, "UPtr*", hDC)
   return hDC
}
Gdip_ReleaseDC(pGraphics, hdc) {
   return DllCall("gdiplus\GdipReleaseDC", "UPtr", pGraphics, "UPtr", hdc)
}
Gdip_GraphicsClear(pGraphics, ARGB:=0x00ffffff) {
   If !pGraphics
      return 2
   return DllCall("gdiplus\GdipGraphicsClear", "UPtr", pGraphics, "int", ARGB)
}
Gdip_GraphicsFlush(pGraphics, intent) {
   If !pGraphics
      return 2
   return DllCall("gdiplus\GdipFlush", "UPtr", pGraphics, "int", intent)
}
Gdip_BlurBitmap(pBitmap, BlurAmount, usePARGB:=0, quality:=7, softEdges:=1) {
   If (!pBitmap || !IsNumber(BlurAmount))
      Return
   If (BlurAmount>100)
      BlurAmount := 100
   Else If (BlurAmount<1)
      BlurAmount := 1
   PixelFormat := (usePARGB=1) ? "0xE200B" : "0x26200A"
   Gdip_GetImageDimensions(pBitmap, sWidth, sHeight)
   dWidth := sWidth//BlurAmount
   dHeight := sHeight//BlurAmount
   pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight, PixelFormat)
   If !pBitmap1
      Return
   G1 := Gdip_GraphicsFromImage(pBitmap1, quality)
   If !G1
   {
      Gdip_DisposeImage(pBitmap1, 1)
      Return
   }
   E1 := Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)
   Gdip_DeleteGraphics(G1)
   If E1
   {
      Gdip_DisposeImage(pBitmap1, 1)
      Return
   }
   If (softEdges=1)
      pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight, PixelFormat)
   Else
      pBitmap2 := Gdip_CloneBitmapArea(pBitmap, 0, 0, sWidth, sHeight, PixelFormat, 0)
   If !pBitmap2
   {
      Gdip_DisposeImage(pBitmap1, 1)
      Return
   }
   G2 := Gdip_GraphicsFromImage(pBitmap2, quality)
   If !G2
   {
      Gdip_DisposeImage(pBitmap1, 1)
      Gdip_DisposeImage(pBitmap2, 1)
      Return
   }
   E2 := Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)
   Gdip_DeleteGraphics(G2)
   Gdip_DisposeImage(pBitmap1)
   If E2
   {
      Gdip_DisposeImage(pBitmap2, 1)
      Return
   }
   return pBitmap2
}
Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality:=75, toBase64orStream:=0) {
   Static Ptr := "UPtr"
   nCount := 0
   nSize := 0
   pStream := 0
   hData := 0
   _p := 0
   SplitPath sOutput,,, Extension
   If !RegExMatch(Extension, "^(?i:BMP|DIB|RLE|JPG|JPEG|JPE|JFIF|GIF|TIF|TIFF|PNG)$")
      Return -1
   Extension := "." Extension
   DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
   VarSetCapacity(ci, nSize)
   DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
   If !(nCount && nSize)
      Return -2
   If (A_IsUnicode)
   {
      StrGet_Name := "StrGet"
      N := (A_AhkVersion < 2) ? nCount : "nCount"
      Loop %N%
      {
         sString := %StrGet_Name%(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
         If !InStr(sString, "*" Extension)
            Continue
         pCodec := &ci+idx
         Break
      }
   } Else
   {
      N := (A_AhkVersion < 2) ? nCount : "nCount"
      Loop %N%
      {
         Location := NumGet(ci, 76*(A_Index-1)+44)
         nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
         VarSetCapacity(sString, nSize)
         DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
         If !InStr(sString, "*" Extension)
            Continue
         pCodec := &ci+76*(A_Index-1)
         Break
      }
   }
   If !pCodec
      Return -3
   If (Quality!=75)
   {
      Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
      If (quality>95 && toBase64=1)
         Quality := 95
      If RegExMatch(Extension, "^\.(?i:JPG|JPEG|JPE|JFIF)$")
      {
         DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
         VarSetCapacity(EncoderParameters, nSize, 0)
         DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
         nCount := NumGet(EncoderParameters, "UInt")
         N := (A_AhkVersion < 2) ? nCount : "nCount"
         Loop %N%
         {
            elem := (24+A_PtrSize)*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
            If (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
            {
               _p := elem+&EncoderParameters-pad-4
               NumPut(Quality, NumGet(NumPut(4, NumPut(1, _p+0)+20, "UInt")), "UInt")
               Break
            }
         }
      }
   }
   If (toBase64orStream=1 || toBase64orStream=2)
   {
      DllCall("ole32\CreateStreamOnHGlobal", "ptr",0, "int",true, "ptr*",pStream)
      gdipLastError := DllCall("gdiplus\GdipSaveImageToStream", "ptr",pBitmap, "ptr",pStream, "ptr",pCodec, "uint", _p ? _p : 0)
      If gdipLastError
         Return -6
      If (toBase64orStream=2)
         Return pStream
      DllCall("ole32\GetHGlobalFromStream", "ptr",pStream, "uint*",hData)
      pData := DllCall("GlobalLock", "ptr",hData, "ptr")
      nSize := DllCall("GlobalSize", "uint",pData)
      VarSetCapacity(bin, nSize, 0)
      DllCall("RtlMoveMemory", "ptr",&bin, "ptr",pData, "uptr",nSize)
      DllCall("GlobalUnlock", "ptr",hData)
      ObjRelease(pStream)
      DllCall("GlobalFree", "ptr",hData)
      DllCall("Crypt32.dll\CryptBinaryToStringA", "ptr",&bin, "uint",nSize, "uint",0x40000001, "ptr",0, "uint*",base64Length)
      VarSetCapacity(base64, base64Length, 0)
      _E := DllCall("Crypt32.dll\CryptBinaryToStringA", "ptr",&bin, "uint",nSize, "uint",0x40000001, "ptr",&base64, "uint*",base64Length)
      If !_E
         Return -7
      VarSetCapacity(bin, 0)
      Return StrGet(&base64, base64Length, "CP0")
   }
   _E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, "WStr", sOutput, Ptr, pCodec, "uint", _p ? _p : 0)
   gdipLastError := _E
   Return _E ? -5 : 0
}
Gdip_SaveBitmapToStream(pBitmap, Format, Quality:=90) {
    Format := "none." Format
    Return Gdip_SaveBitmapToFile(pBitmap, Format, Quality, 2)
}
Gdip_GetPixel(pBitmap, x, y) {
   ARGB := 0
   gdipLastError := DllCall("gdiplus\GdipBitmapGetPixel", "UPtr", pBitmap, "int", x, "int", y, "uint*", ARGB)
   Return ARGB
}
Gdip_GetPixelColor(pBitmap, x, y, Format) {
   ARGBdec := Gdip_GetPixel(pBitmap, x, y)
   If !ARGBdec
      Return
   If (format=1)
   {
      Return Format("{1:#x}", ARGBdec)
   } Else If (format=2)
   {
      Gdip_FromARGB(ARGBdec, A, R, G, B)
      Return R "," G "," B "," A
   } Else If (format=3)
   {
      clr := Format("{1:#x}", ARGBdec)
      Return "0x" SubStr(clr, -1) SubStr(clr, 7, 2) SubStr(clr, 5, 2)
   } Else If (format=4)
   {
      Return SubStr(Format("{1:#x}", ARGBdec), 5)
   } Else Return ARGBdec
}
Gdip_SetPixel(pBitmap, x, y, ARGB) {
   return DllCall("gdiplus\GdipBitmapSetPixel", "UPtr", pBitmap, "int", x, "int", y, "int", ARGB)
}
Gdip_GetImageWidth(pBitmap) {
   Width := 0
   gdipLastError := DllCall("gdiplus\GdipGetImageWidth", "UPtr", pBitmap, "uint*", Width)
   return Width
}
Gdip_GetImageHeight(pBitmap) {
   Height := 0
   gdipLastError := DllCall("gdiplus\GdipGetImageHeight", "UPtr", pBitmap, "uint*", Height)
   return Height
}
Gdip_GetImageDimensions(pBitmap, ByRef Width, ByRef Height) {
   Width := 0, Height := 0
   If StrLen(pBitmap)<3
      Return 2
   E := Gdip_GetImageDimension(pBitmap, Width, Height)
   Width := Round(Width)
   Height := Round(Height)
   return E
}
Gdip_GetImageDimension(pBitmap, ByRef w, ByRef h) {
   w := 0, h := 0
   If !pBitmap
      Return 2
   return DllCall("gdiplus\GdipGetImageDimension", "UPtr", pBitmap, "float*", w, "float*", h)
}
Gdip_GetImageBounds(pBitmap) {
   If !pBitmap
      Return 2
   VarSetCapacity(RectF, 16, 0)
   E := DllCall("gdiplus\GdipGetImageBounds", "UPtr", pBitmap, "UPtr", &RectF, "Int*", 0)
   If (!E) {
      rData := {}
      rData.x := NumGet(&RectF, 0, "float")
      rData.y := NumGet(&RectF, 4, "float")
      rData.w := NumGet(&RectF, 8, "float")
      rData.h := NumGet(&RectF, 12, "float")
      Return rData
   } Else {
      Return E
   }
}
Gdip_GetImageFlags(pBitmap) {
   Flags := 0
   gdipLastError := DllCall("gdiplus\GdipGetImageFlags", "UPtr", pBitmap, "UInt*", Flags)
   Return Flags
}
Gdip_GetImageRawFormat(pBitmap) {
  Static RawFormatsList := {"{B96B3CA9-0728-11D3-9D7B-0000F81EF32E}":"Undefined", "{B96B3CAA-0728-11D3-9D7B-0000F81EF32E}":"MemoryBMP", "{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}":"BMP", "{B96B3CAC-0728-11D3-9D7B-0000F81EF32E}":"EMF", "{B96B3CAD-0728-11D3-9D7B-0000F81EF32E}":"WMF", "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}":"JPEG", "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}":"PNG", "{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}":"GIF", "{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}":"TIFF", "{B96B3CB2-0728-11D3-9D7B-0000F81EF32E}":"EXIF", "{B96B3CB5-0728-11D3-9D7B-0000F81EF32E}":"Icon"}
  VarSetCapacity(pGuid, 16, 0)
  E1 := DllCall("gdiplus\GdipGetImageRawFormat", "UPtr", pBitmap, "Ptr", &pGuid)
  size := VarSetCapacity(sguid, (38 << !!A_IsUnicode) + 1, 0)
  E2 := DllCall("ole32.dll\StringFromGUID2", "ptr", &pguid, "ptr", &sguid, "int", size)
  R1 := E2 ? StrGet(&sguid) : E2
  R2 := RawFormatsList[R1]
  Return R2 ? R2 : R1
}
Gdip_GetImagePixelFormat(pBitmap, mode:=0) {
   Static PixelFormatsList := {0x30101:"1-INDEXED", 0x30402:"4-INDEXED", 0x30803:"8-INDEXED", 0x101004:"16-GRAYSCALE", 0x021005:"16-RGB555", 0x21006:"16-RGB565", 0x61007:"16-ARGB1555", 0x21808:"24-RGB", 0x22009:"32-RGB", 0x26200A:"32-ARGB", 0xE200B:"32-PARGB", 0x10300C:"48-RGB", 0x34400D:"64-ARGB", 0x1A400E:"64-PARGB", 0x200f:"32-CMYK"}
   PixelFormat := 0
   gdipLastError := DllCall("gdiplus\GdipGetImagePixelFormat", "UPtr", pBitmap, "UPtr*", PixelFormat)
   If gdipLastError
      Return -1
   If (mode=0)
      Return PixelFormat
   inHEX := Format("{1:#x}", PixelFormat)
   If (PixelFormatsList.Haskey(inHEX) && mode=2)
      result := PixelFormatsList[inHEX]
   Else
      result := inHEX
   return result
}
Gdip_GetImageType(pBitmap) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetImageType", Ptr, pBitmap, "int*", result)
   If gdipLastError
      Return -1
   Return result
}
Gdip_GetDPI(pGraphics, ByRef DpiX, ByRef DpiY) {
   DpiX := Gdip_GetDpiX(pGraphics)
   DpiY := Gdip_GetDpiY(pGraphics)
}
Gdip_GetDpiX(pGraphics) {
   dpix := 0
   gdipLastError := DllCall("gdiplus\GdipGetDpiX", "UPtr", pGraphics, "float*", dpix)
   return Round(dpix)
}
Gdip_GetDpiY(pGraphics) {
   dpiy := 0
   gdipLastError := DllCall("gdiplus\GdipGetDpiY", "UPtr", pGraphics, "float*", dpiy)
   return Round(dpiy)
}
Gdip_GetImageHorizontalResolution(pBitmap) {
   dpix := 0
   gdipLastError := DllCall("gdiplus\GdipGetImageHorizontalResolution", "UPtr", pBitmap, "float*", dpix)
   return Round(dpix)
}
Gdip_GetImageVerticalResolution(pBitmap) {
   dpiy := 0
   gdipLastError := DllCall("gdiplus\GdipGetImageVerticalResolution", "UPtr", pBitmap, "float*", dpiy)
   return Round(dpiy)
}
Gdip_BitmapSetResolution(pBitmap, dpix, dpiy) {
   return DllCall("gdiplus\GdipBitmapSetResolution", "UPtr", pBitmap, "float", dpix, "float", dpiy)
}
Gdip_BitmapGetDPIResolution(pBitmap, ByRef dpix, ByRef dpiy) {
   dpix := dpiy := 0
   If StrLen(pBitmap)<3
      Return 2
   dpix := Gdip_GetImageHorizontalResolution(pBitmap)
   dpiy := Gdip_GetImageVerticalResolution(pBitmap)
}
Gdip_CreateBitmapFromGraphics(pGraphics, Width, Height) {
  pBitmap := 0
  gdipLastError := DllCall("gdiplus\GdipCreateBitmapFromGraphics", "int", Width, "int", Height, "UPtr", pGraphics, "UPtr*", pBitmap)
  Return pBitmap
}
Gdip_CreateBitmapFromFile(sFile, IconNumber:=1, IconSize:="", useICM:=0) {
   Static Ptr := "UPtr"
   PtrA := "UPtr*"
   pBitmap := 0
   pBitmapOld := 0
   hIcon := 0
   SplitPath sFile,,, Extension
   if RegExMatch(Extension, "^(?i:exe|dll)$")
   {
      Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
      BufSize := 16 + (2*A_PtrSize)
      VarSetCapacity(buf, BufSize, 0)
      For eachSize, Size in StrSplit( Sizes, "|" )
      {
         DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", Size, "int", Size, PtrA, hIcon, PtrA, 0, "uint", 1, "uint", 0)
         if !hIcon
            continue
         if !DllCall("GetIconInfo", Ptr, hIcon, Ptr, &buf)
         {
            DestroyIcon(hIcon)
            continue
         }
         hbmMask  := NumGet(buf, 12 + (A_PtrSize - 4))
         hbmColor := NumGet(buf, 12 + (A_PtrSize - 4) + A_PtrSize)
         if !(hbmColor && DllCall("GetObject", Ptr, hbmColor, "int", BufSize, Ptr, &buf))
         {
            DestroyIcon(hIcon)
            continue
         }
         break
      }
      if !hIcon
         return -1
      Width := NumGet(buf, 4, "int"), Height := NumGet(buf, 8, "int")
      hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
      if !DllCall("DrawIconEx", Ptr, hdc, "int", 0, "int", 0, Ptr, hIcon, "uint", Width, "uint", Height, "uint", 0, Ptr, 0, "uint", 3)
      {
         DestroyIcon(hIcon)
         return -2
      }
      VarSetCapacity(dib, 104)
      DllCall("GetObject", Ptr, hbm, "int", A_PtrSize = 8 ? 104 : 84, Ptr, &dib)
      Stride := NumGet(dib, 12, "Int")
      Bits := NumGet(dib, 20 + (A_PtrSize = 8 ? 4 : 0))
      pBitmapOld := Gdip_CreateBitmap(Width, Height, 0, Stride, Bits)
      pBitmap := Gdip_CreateBitmap(Width, Height)
      _G := Gdip_GraphicsFromImage(pBitmap)
      Gdip_DrawImage(_G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
      SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
      Gdip_DeleteGraphics(_G), Gdip_DisposeImage(pBitmapOld)
      DestroyIcon(hIcon)
   } else
   {
      function2call := (useICM=1) ? "ICM" : ""
      gdipLastError := DllCall("gdiplus\GdipCreateBitmapFromFile" function2call, "WStr", sFile, "UPtr*", pBitmap)
   }
   return pBitmap
}
Gdip_CreateBitmapFromFileSimplified(sFile, useICM:=0) {
   function2call := (useICM=1) ? "ICM" : ""
   gdipLastError := DllCall("gdiplus\GdipCreateBitmapFromFile" function2call, "WStr", sFile, "UPtr*", pBitmap)
   return pBitmap
}
Gdip_CreateARGBBitmapFromHBITMAP(hImage) {
   If !hImage
      Return
   E := DllCall("GetObject"
            , "ptr", hImage
            , "int", VarSetCapacity(dib, 76+2*(A_PtrSize=8?4:0)+2*A_PtrSize)
            , "ptr", &dib)
   If !E
      Return
   width  := NumGet(dib, 4, "uint")
   height := NumGet(dib, 8, "uint")
   bpp    := NumGet(dib, 18, "ushort")
   if (bpp!=32)
      return Gdip_CreateBitmapFromHBITMAP(hImage)
   hdc := CreateCompatibleDC()
   If !hdc
      Return
   obm := SelectObject(hdc, hImage)
   cdc := CreateCompatibleDC(hdc)
   If !cdc
   {
      SelectObject(hdc, obm), DeleteDC(hdc)
      Return
   }
   hbm := CreateDIBSection(width, -height, hdc, 32, pBits)
   If !hbm
   {
      DeleteDC(cdc), SelectObject(hdc, obm), DeleteDC(hdc)
      Return
   }
   ob2 := SelectObject(cdc, hbm)
   pBitmap := Gdip_CreateBitmap(width, height)
   If !pBitmap
   {
      SelectObject(cdc, ob2)
      DeleteObject(hbm), DeleteDC(cdc)
      SelectObject(hdc, obm), DeleteDC(hdc)
      Return
   }
   CreateRect(Rect, 0, 0, width, height)
   VarSetCapacity(BitmapData, 16+2*A_PtrSize, 0)
      , NumPut(       width, BitmapData,  0,  "uint")
      , NumPut(      height, BitmapData,  4,  "uint")
      , NumPut(   4 * width, BitmapData,  8,   "int")
      , NumPut(     0xE200B, BitmapData, 12,   "int")
      , NumPut(       pBits, BitmapData, 16,   "ptr")
   E := DllCall("gdiplus\GdipBitmapLockBits"
            ,   "ptr", pBitmap
            ,   "ptr", &Rect
            ,  "uint", 6            ; ImageLockMode.UserInputBuffer | ImageLockMode.WriteOnly
            ,   "int", 0xE200B      ; Format32bppPArgb
            ,   "ptr", &BitmapData)
   BitBlt(cdc, 0, 0, width, height, hdc, 0, 0)
   If !E
      DllCall("gdiplus\GdipBitmapUnlockBits", "ptr",pBitmap, "ptr",&BitmapData)
   SelectObject(cdc, ob2)
   DeleteObject(hbm), DeleteDC(cdc)
   SelectObject(hdc, obm), DeleteDC(hdc)
   return pBitmap
}
Gdip_CreateBitmapFromHBITMAP(hBitmap, hPalette:=0) {
   pBitmap := 0
   If !hBitmap
   {
      gdipLastError := 2
      Return
   }
   gdipLastError := DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "UPtr", hBitmap, "UPtr", hPalette, "UPtr*", pBitmap)
   return pBitmap
}
Gdip_CreateHBITMAPFromBitmap(pBitmap, Background:=0xffffffff) {
   hBitmap := 0
   If !pBitmap
   {
      gdipLastError := 2
      Return
   }
   gdipLastError := DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "UPtr", pBitmap, "UPtr*", hBitmap, "int", Background)
   return hBitmap
}
Gdip_CreateARGBHBITMAPFromBitmap(ByRef pBitmap) {
  If !pBitmap
     Return
  hdc := CreateCompatibleDC()
  If !hdc
     Return
  Gdip_GetImageDimensions(pBitmap, Width, Height)
  hbm := CreateDIBSection(width, -height, hdc, 32, pBits)
  If !hbm
  {
     DeleteObject(hdc)
     Return
  }
  obm := SelectObject(hdc, hbm)
  CreateRect(Rect, 0, 0, width, height)
  VarSetCapacity(BitmapData, 16+2*A_PtrSize, 0)
    , NumPut(     width, BitmapData,  0,   "uint")
    , NumPut(    height, BitmapData,  4,   "uint")
    , NumPut( 4 * width, BitmapData,  8,    "int")
    , NumPut(   0xE200B, BitmapData, 12,    "int")
    , NumPut(     pBits, BitmapData, 16,    "ptr")
  E := DllCall("gdiplus\GdipBitmapLockBits"
        ,    "ptr", pBitmap
        ,    "ptr", &Rect
        ,   "uint", 5            ; ImageLockMode.UserInputBuffer | ImageLockMode.ReadOnly
        ,    "int", 0xE200B      ; Format32bppPArgb
        ,    "ptr", &BitmapData)
  If !E
     DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", &BitmapData)
  SelectObject(hdc, obm)
  DeleteObject(hdc)
  return hbm
}
Gdip_CreateBitmapFromHICON(hIcon) {
   pBitmap := 0
   gdipLastError := DllCall("gdiplus\GdipCreateBitmapFromHICON", "UPtr", hIcon, "UPtr*", pBitmap)
   return pBitmap
}
Gdip_CreateHICONFromBitmap(pBitmap) {
   hIcon := 0
   gdipLastError := DllCall("gdiplus\GdipCreateHICONFromBitmap", "UPtr", pBitmap, "UPtr*", hIcon)
   return hIcon
}
Gdip_CreateBitmap(Width, Height, PixelFormat:=0, Stride:=0, Scan0:=0) {
   If (!Width || !Height)
   {
      gdipLastError := 2
      Return
   }
   pBitmap := 0
   If !PixelFormat
      PixelFormat := 0x26200A  ; 32-ARGB
   gdipLastError := DllCall("gdiplus\GdipCreateBitmapFromScan0"
      , "int", Width  , "int", Height
      , "int", Stride , "int", PixelFormat
      , "UPtr", Scan0 , "UPtr*", pBitmap)
   Return pBitmap
}
Gdip_CreateBitmapFromClipboard() {
   Static Ptr := "UPtr"
   pid := DllCall("GetCurrentProcessId","uint")
   hwnd := WinExist("ahk_pid " . pid)
   if !DllCall("IsClipboardFormatAvailable", "uint", 8)
   {
      if DllCall("IsClipboardFormatAvailable", "uint", 2)
      {
         if !DllCall("OpenClipboard", Ptr, hwnd)
            return -1
         hData := DllCall("User32.dll\GetClipboardData", "UInt", 0x0002, "UPtr")
         hBitmap := DllCall("User32.dll\CopyImage", "UPtr", hData, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x2004, "Ptr")
         DllCall("CloseClipboard")
         pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
         DeleteObject(hBitmap)
         return pBitmap
      }
      return -2
   }
   if !DllCall("OpenClipboard", Ptr, hwnd)
      return -1
   hBitmap := DllCall("GetClipboardData", "uint", 2, Ptr)
   if !hBitmap
   {
      DllCall("CloseClipboard")
      return -3
   }
   DllCall("CloseClipboard")
   If hBitmap
   {
      pBitmap := Gdip_CreateARGBBitmapFromHBITMAP(hBitmap)
      If pBitmap
         isUniform := Gdip_TestBitmapUniformity(pBitmap, 7, maxLevelIndex)
      If (pBitmap && isUniform=1 && maxLevelIndex<=2)
      {
         Gdip_DisposeImage(pBitmap, 1)
         pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
      }
      DeleteObject(hBitmap)
   }
   if !pBitmap
      return -4
   return pBitmap
}
Gdip_SetBitmapToClipboard(pBitmap, hBitmap:=0) {
   Static Ptr := "UPtr"
   off1 := A_PtrSize = 8 ? 52 : 44
   off2 := A_PtrSize = 8 ? 32 : 24
   pid := DllCall("GetCurrentProcessId","uint")
   hwnd := WinExist("ahk_pid " . pid)
   r1 := DllCall("OpenClipboard", Ptr, hwnd)
   If !r1
      Return -1
   If !hBitmap
   {
      If pBitmap
         hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0)
   }
   If !hBitmap
   {
      DllCall("CloseClipboard")
      Return -3
   }
   r2 := DllCall("EmptyClipboard")
   If !r2
   {
      DeleteObject(hBitmap)
      DllCall("CloseClipboard")
      Return -2
   }
   DllCall("GetObject", Ptr, hBitmap, "int", VarSetCapacity(oi, A_PtrSize = 8 ? 104 : 84, 0), Ptr, &oi)
   hdib := DllCall("GlobalAlloc", "uint", 2, Ptr, 40+NumGet(oi, off1, "UInt"), Ptr)
   pdib := DllCall("GlobalLock", Ptr, hdib, Ptr)
   DllCall("RtlMoveMemory", Ptr, pdib, Ptr, &oi+off2, Ptr, 40)
   DllCall("RtlMoveMemory", Ptr, pdib+40, Ptr, NumGet(oi, off2 - A_PtrSize, Ptr), Ptr, NumGet(oi, off1, "UInt"))
   DllCall("GlobalUnlock", Ptr, hdib)
   DeleteObject(hBitmap)
   r3 := DllCall("SetClipboardData", "uint", 8, Ptr, hdib)
   DllCall("CloseClipboard")
   DllCall("GlobalFree", Ptr, hdib)
   E := r3 ? 0 : -4    ; 0 - success
   Return E
}
Gdip_CloneBitmapArea(pBitmap, x:="", y:="", w:=0, h:=0, PixelFormat:=0, KeepPixelFormat:=0) {
   If !pBitmap
   {
      gdipLastError := 2
      Return
   }
   pBitmapDest := 0
   If !PixelFormat
      PixelFormat := 0x26200A    ; 32-ARGB
   If (KeepPixelFormat=1)
      PixelFormat := Gdip_GetImagePixelFormat(pBitmap, 1)
   If (y="")
      y := 0
   If (x="")
      x := 0
   If (!w || !h)
      Gdip_GetImageDimensions(pBitmap, w, h)
   gdipLastError := DllCall("gdiplus\GdipCloneBitmapArea"
               , "float", x, "float", y
               , "float", w, "float", h
               , "int", PixelFormat
               , "UPtr", pBitmap
               , "UPtr*", pBitmapDest)
   return pBitmapDest
}
Gdip_CloneBitmap(pBitmap) {
   If !pBitmap
   {
      gdipLastError := 2
      Return
   }
   pBitmapDest := 0
   gdipLastError := DllCall("gdiplus\GdipCloneImage", "UPtr", pBitmap, "UPtr*", pBitmapDest)
   return pBitmapDest
}
Gdip_BitmapSelectActiveFrame(pBitmap, FrameIndex) {
    Countu := 0
    CountFrames := 0
    DllCall("gdiplus\GdipImageGetFrameDimensionsCount", "UPtr", pBitmap, "UInt*", Countu)
    VarSetCapacity(dIDs, 16, 0)
    DllCall("gdiplus\GdipImageGetFrameDimensionsList", "UPtr", pBitmap, "UPtr", &dIDs, "UInt", Countu)
    DllCall("gdiplus\GdipImageGetFrameCount", "UPtr", pBitmap, "UPtr", &dIDs, "UInt*", CountFrames)
    If (FrameIndex>CountFrames)
       FrameIndex := CountFrames
    Else If (FrameIndex<1)
       FrameIndex := 0
    E := DllCall("gdiplus\GdipImageSelectActiveFrame", "UPtr", pBitmap, "UPtr", &dIDs, "UInt", FrameIndex)
    If E
       Return -1
    Return CountFrames
}
Gdip_GetBitmapFramesCount(pBitmap) {
    Countu := 0
    CountFrames := 0
    DllCall("gdiplus\GdipImageGetFrameDimensionsCount", "UPtr", pBitmap, "UInt*", Countu)
    VarSetCapacity(dIDs, 16, 0)
    DllCall("gdiplus\GdipImageGetFrameDimensionsList", "UPtr", pBitmap, "UPtr", &dIDs, "UInt", Countu)
    DllCall("gdiplus\GdipImageGetFrameCount", "UPtr", pBitmap, "UPtr", &dIDs, "UInt*", CountFrames)
    Return CountFrames
}
Gdip_CreateCachedBitmap(pBitmap, pGraphics) {
   pCachedBitmap := 0
   gdipLastError := := DllCall("gdiplus\GdipCreateCachedBitmap", "UPtr", pBitmap, "UPtr", pGraphics, "Ptr*", pCachedBitmap)
   return pCachedBitmap
}
Gdip_DeleteCachedBitmap(pCachedBitmap) {
   return DllCall("gdiplus\GdipDeleteCachedBitmap", "UPtr", pCachedBitmap)
}
Gdip_DrawCachedBitmap(pGraphics, pCachedBitmap, X, Y) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipDrawCachedBitmap", Ptr, pGraphics, Ptr, pCachedBitmap, "int", X, "int", Y)
}
Gdip_ImageRotateFlip(pBitmap, RotateFlipType:=1) {
   return DllCall("gdiplus\GdipImageRotateFlip", "UPtr", pBitmap, "int", RotateFlipType)
}
Gdip_RotateBitmapAtCenter(pBitmap, Angle, pBrush:=0, InterpolationMode:=7, PixelFormat:=0) {
    If !pBitmap
       Return
    If !Angle
       Return Gdip_CloneBitmap(pBitmap)
    Gdip_GetImageDimensions(pBitmap, Width, Height)
    Gdip_GetRotatedDimensions(Width, Height, Angle, RWidth, RHeight)
    Gdip_GetRotatedTranslation(Width, Height, Angle, xTranslation, yTranslation)
    If (RWidth*RHeight>536848912) || (Rwidth>32100) || (RHeight>32100)
       Return
    PixelFormatReadable := Gdip_GetImagePixelFormat(pBitmap, 2)
    If InStr(PixelFormatReadable, "indexed")
    {
       hbm := CreateDIBSection(RWidth, RHeight,,24)
       If !hbm
          Return
       hDC := CreateCompatibleDC()
       If !hDC
       {
          DeleteDC(hDC)
          Return
       }
       obm := SelectObject(hDC, hbm)
       G := Gdip_GraphicsFromHDC(hDC, InterpolationMode, 4)
       indexedMode := 1
    } Else
    {
       If (PixelFormat=-1)
          PixelFormat := "0xE200B"
       newBitmap := Gdip_CreateBitmap(RWidth, RHeight, PixelFormat)
       If StrLen(newBitmap)>1
          G := Gdip_GraphicsFromImage(newBitmap, InterpolationMode, 4)
    }
    If (!newBitmap || !G)
    {
       Gdip_DisposeImage(newBitmap, 1)
       Gdip_DeleteGraphics(G)
       SelectObject(hDC, obm)
       DeleteObject(hbm)
       DeleteDC(hDC)
       Return
    }
    If (pBrush=0)
    {
       pBrush := Gdip_BrushCreateSolid("0xFF000000")
       defaultBrush := 1
    }
    If StrLen(pBrush)>1
       Gdip_FillRectangle(G, pBrush, 0, 0, RWidth, RHeight)
    Gdip_TranslateWorldTransform(G, xTranslation, yTranslation)
    Gdip_RotateWorldTransform(G, Angle)
    r := Gdip_DrawImage(G, pBitmap, 0, 0, Width, Height)
    If (indexedMode=1)
    {
       newBitmap := !r ? Gdip_CreateBitmapFromHBITMAP(hbm) : ""
       SelectObject(hDC, obm)
       DeleteObject(hbm)
       DeleteDC(hDC)
    } Else If r
    {
       Gdip_DisposeImage(newBitmap, 1)
       newBitmap := ""
    }
    Gdip_DeleteGraphics(G)
    If (defaultBrush=1)
       Gdip_DeleteBrush(pBrush)
    Return newBitmap
}
Gdip_ResizeBitmap(pBitmap, givenW, givenH, KeepRatio, InterpolationMode:="", KeepPixelFormat:=0, checkTooLarge:=0, bgrColor:=0) {
    If (!pBitmap || !givenW || !givenH)
       Return
    Gdip_GetImageDimensions(pBitmap, Width, Height)
    If (KeepRatio=1)
    {
       calcIMGdimensions(Width, Height, givenW, givenH, ResizedW, ResizedH)
    } Else
    {
       ResizedW := givenW
       ResizedH := givenH
    }
    If (((ResizedW*ResizedH>536848912) || (ResizedW>32100) || (ResizedH>32100)) && checkTooLarge=1)
       Return
    PixelFormatReadable := Gdip_GetImagePixelFormat(pBitmap, 2)
    If (KeepPixelFormat=1)
       PixelFormat := Gdip_GetImagePixelFormat(pBitmap, 1)
    Else If (KeepPixelFormat=-1)
       PixelFormat := "0xE200B"
    Else If Strlen(KeepPixelFormat)>3
       PixelFormat := KeepPixelFormat
    If (ResizedW=Width && ResizedH=Height)
       InterpolationMode := 5
    If bgrColor
       pBrush := Gdip_BrushCreateSolid(bgrColor)
    If InStr(PixelFormatReadable, "indexed")
    {
       hbm := CreateDIBSection(ResizedW, ResizedH,,24)
       If !hbm
          Return
       hDC := CreateCompatibleDC()
       If !hDC
       {
          DeleteDC(hdc)
          Return
       }
       obm := SelectObject(hDC, hbm)
       G := Gdip_GraphicsFromHDC(hDC, InterpolationMode, 4)
       Gdip_SetPixelOffsetMode(G, 2)
       If G
       {
          If pBrush
             Gdip_FillRectangle(G, pBrush, 0, 0, ResizedW, ResizedH)
          r := Gdip_DrawImage(G, pBitmap, 0, 0, ResizedW, ResizedH)
       }
       newBitmap := !r ? Gdip_CreateBitmapFromHBITMAP(hbm) : ""
       If (KeepPixelFormat=1 && newBitmap)
          Gdip_BitmapSetColorDepth(newBitmap, SubStr(PixelFormatReadable, 1, 1), 1)
       SelectObject(hdc, obm)
       DeleteObject(hbm)
       DeleteDC(hdc)
       Gdip_DeleteGraphics(G)
    } Else
    {
       newBitmap := Gdip_CreateBitmap(ResizedW, ResizedH, PixelFormat)
       If StrLen(newBitmap)>2
       {
          G := Gdip_GraphicsFromImage(newBitmap, InterpolationMode, 4)
          Gdip_SetPixelOffsetMode(G, 2)
          If G
          {
             If pBrush
                Gdip_FillRectangle(G, pBrush, 0, 0, ResizedW, ResizedH)
             r := Gdip_DrawImage(G, pBitmap, 0, 0, ResizedW, ResizedH)
          }
          Gdip_DeleteGraphics(G)
          If (r || !G)
          {
             Gdip_DisposeImage(newBitmap, 1)
             newBitmap := ""
          }
       }
    }
    Return newBitmap
}
Gdip_CreatePen(ARGB, w, Unit:=2) {
   pPen := 0
   gdipLastError := DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", Unit, "UPtr*", pPen)
   return pPen
}
Gdip_CreatePenFromBrush(pBrush, w, Unit:=2) {
   pPen := 0
   gdipLastError := DllCall("gdiplus\GdipCreatePen2", "UPtr", pBrush, "float", w, "int", 2, "UPtr*", pPen, "int", Unit)
   return pPen
}
Gdip_SetPenWidth(pPen, width) {
   return DllCall("gdiplus\GdipSetPenWidth", "UPtr", pPen, "float", width)
}
Gdip_GetPenWidth(pPen) {
   width := 0
   E := DllCall("gdiplus\GdipGetPenWidth", "UPtr", pPen, "float*", width)
   If E
      return -1
   return width
}
Gdip_GetPenDashStyle(pPen) {
   DashStyle := 0
   E := DllCall("gdiplus\GdipGetPenDashStyle", "UPtr", pPen, "float*", DashStyle)
   If E
      return -1
   return DashStyle
}
Gdip_SetPenColor(pPen, ARGB) {
   return DllCall("gdiplus\GdipSetPenColor", "UPtr", pPen, "UInt", ARGB)
}
Gdip_GetPenColor(pPen) {
   ARGB := 0
   E := DllCall("gdiplus\GdipGetPenColor", "UPtr", pPen, "UInt*", ARGB)
   If E
      return -1
   return Format("{1:#x}", ARGB)
}
Gdip_SetPenBrushFill(pPen, pBrush) {
   return DllCall("gdiplus\GdipSetPenBrushFill", "UPtr", pPen, "UPtr", pBrush)
}
Gdip_ResetPenTransform(pPen) {
   Return DllCall("gdiplus\GdipResetPenTransform", "UPtr", pPen)
}
Gdip_MultiplyPenTransform(pPen, hMatrix, matrixOrder:=0) {
   Return DllCall("gdiplus\GdipMultiplyPenTransform", "UPtr", pPen, "UPtr", hMatrix, "int", matrixOrder)
}
Gdip_RotatePenTransform(pPen, Angle, matrixOrder:=0) {
   Return DllCall("gdiplus\GdipRotatePenTransform", "UPtr", pPen, "float", Angle, "int", matrixOrder)
}
Gdip_ScalePenTransform(pPen, ScaleX, ScaleY, matrixOrder:=0) {
   Return DllCall("gdiplus\GdipScalePenTransform", "UPtr", pPen, "float", ScaleX, "float", ScaleY, "int", matrixOrder)
}
Gdip_TranslatePenTransform(pPen, X, Y, matrixOrder:=0) {
   Return DllCall("gdiplus\GdipTranslatePenTransform", "UPtr", pPen, "float", X, "float", Y, "int", matrixOrder)
}
Gdip_SetPenTransform(pPen, pMatrix) {
   return DllCall("gdiplus\GdipSetPenTransform", "UPtr", pPen, "UPtr", pMatrix)
}
Gdip_GetPenTransform(pPen) {
   pMatrix := 0
   gdipLastError := DllCall("gdiplus\GdipGetPenTransform", "UPtr", pPen, "UPtr*", pMatrix)
   Return pMatrix
}
Gdip_GetPenBrushFill(pPen) {
   pBrush := 0
   gdipLastError := DllCall("gdiplus\GdipGetPenBrushFill", "UPtr", pPen, "UPtr*", pBrush)
   Return pBrush
}
Gdip_GetPenFillType(pPen) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetPenFillType", "UPtr", pPen, "int*", result)
   If gdipLastError
      return -2
   Return result
}
Gdip_GetPenStartCap(pPen) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetPenStartCap", "UPtr", pPen, "int*", result)
   If gdipLastError
      return -1
   Return result
}
Gdip_GetPenEndCap(pPen) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetPenEndCap", "UPtr", pPen, "int*", result)
   If gdipLastError
      return -1
   Return result
}
Gdip_GetPenDashCaps(pPen) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetPenDashCap197819", "UPtr", pPen, "int*", result)
   If gdipLastError
      return -1
   Return result
}
Gdip_GetPenAlignment(pPen) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetPenMode", "UPtr", pPen, "int*", result)
   If gdipLastError
      return -1
   Return result
}
Gdip_SetPenLineCaps(pPen, StartCap, EndCap, DashCap) {
   Return DllCall("gdiplus\GdipSetPenLineCap197819", "UPtr", pPen, "int", StartCap, "int", EndCap, "int", DashCap)
}
Gdip_SetPenStartCap(pPen, LineCap) {
   Return DllCall("gdiplus\GdipSetPenStartCap", "UPtr", pPen, "int", LineCap)
}
Gdip_SetPenEndCap(pPen, LineCap) {
   Return DllCall("gdiplus\GdipSetPenEndCap", "UPtr", pPen, "int", LineCap)
}
Gdip_SetPenDashCaps(pPen, LineCap) {
   Return DllCall("gdiplus\GdipSetPenDashCap197819", "UPtr", pPen, "int", LineCap)
}
Gdip_SetPenAlignment(pPen, Alignment) {
   Static Ptr := "UPtr"
   Return DllCall("gdiplus\GdipSetPenMode", "UPtr", pPen, "int", Alignment)
}
Gdip_GetPenCompoundCount(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenCompoundCount", "UPtr", pPen, "int*", result)
    If E
       Return -1
    Return result
}
Gdip_SetPenCompoundArray(pPen, inCompounds) {
   arrCompounds := StrSplit(inCompounds, "|")
   totalCompounds := arrCompounds.Length()
   VarSetCapacity(pCompounds, 8 * totalCompounds, 0)
   Loop %totalCompounds%
      NumPut(arrCompounds[A_Index], &pCompounds, 4*(A_Index - 1), "float")
   Static Ptr := "UPtr"
   Return DllCall("gdiplus\GdipSetPenCompoundArray", Ptr, pPen, Ptr, &pCompounds, "int", totalCompounds)
}
Gdip_SetPenDashStyle(pPen, DashStyle) {
   Static Ptr := "UPtr"
   Return DllCall("gdiplus\GdipSetPenDashStyle", Ptr, pPen, "Int", DashStyle)
}
Gdip_SetPenDashArray(pPen, Dashes) {
   Static Ptr := "UPtr"
   Points := StrSplit(Dashes, ",")
   PointsCount := Points.Length()
   VarSetCapacity(PointsF, 8 * PointsCount, 0)
   Loop %PointsCount%
       NumPut(Points[A_Index], &PointsF, 4*(A_Index - 1), "float")
   Return DllCall("gdiplus\GdipSetPenDashArray", Ptr, pPen, Ptr, &PointsF, "int", PointsCount)
}
Gdip_SetPenDashOffset(pPen, Offset) {
    Static Ptr := "UPtr"
    Return DllCall("gdiplus\GdipSetPenDashOffset", Ptr, pPen, "float", Offset)
}
Gdip_GetPenDashArray(pPen) {
   iCount := Gdip_GetPenDashCount(pPen)
   If (iCount=-1)
      Return 0
   VarSetCapacity(PointsF, 8 * iCount, 0)
   Static Ptr := "UPtr"
   DllCall("gdiplus\GdipGetPenDashArray", Ptr, pPen, "uPtr", &PointsF, "int", iCount)
   Loop %iCount%
   {
       A := NumGet(&PointsF, 4*(A_Index-1), "float")
       printList .= A ","
   }
   Return Trim(printList, ",")
}
Gdip_GetPenCompoundArray(pPen) {
   iCount := Gdip_GetPenCompoundCount(pPen)
   VarSetCapacity(PointsF, 4 * iCount, 0)
   Static Ptr := "UPtr"
   DllCall("gdiplus\GdipGetPenCompoundArray", Ptr, pPen, "uPtr", &PointsF, "int", iCount)
   Loop %iCount%
   {
       A := NumGet(&PointsF, 4*(A_Index-1), "float")
       printList .= A "|"
   }
   Return Trim(printList, "|")
}
Gdip_SetPenLineJoin(pPen, LineJoin) {
    Static Ptr := "UPtr"
    Return DllCall("gdiplus\GdipSetPenLineJoin", Ptr, pPen, "int", LineJoin)
}
Gdip_SetPenMiterLimit(pPen, MiterLimit) {
    Static Ptr := "UPtr"
    Return DllCall("gdiplus\GdipSetPenMiterLimit", Ptr, pPen, "float", MiterLimit)
}
Gdip_SetPenUnit(pPen, Unit) {
    Static Ptr := "UPtr"
    Return DllCall("gdiplus\GdipSetPenUnit", Ptr, pPen, "int", Unit)
}
Gdip_GetPenDashCount(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenDashCount", Ptr, pPen, "int*", result)
    If E
       Return -1
    Return result
}
Gdip_GetPenDashOffset(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenDashOffset", Ptr, pPen, "float*", result)
    If E
       Return -1
    Return result
}
Gdip_GetPenLineJoin(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenLineJoin", Ptr, pPen, "int*", result)
    If E
       Return -1
    Return result
}
Gdip_GetPenMiterLimit(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenMiterLimit", Ptr, pPen, "float*", result)
    If E
       Return -1
    Return result
}
Gdip_GetPenUnit(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenUnit", Ptr, pPen, "int*", result)
    If E
       Return -1
    Return result
}
Gdip_ClonePen(pPen) {
   newPen := 0
   gdipLastError := DllCall("gdiplus\GdipClonePen", "UPtr", pPen, "UPtr*", newPen)
   Return newPen
}
Gdip_BrushCreateSolid(ARGB:=0xff000000) {
   pBrush := 0
   E := DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, "UPtr*", pBrush)
   return pBrush
}
Gdip_SetSolidFillColor(pBrush, ARGB) {
   return DllCall("gdiplus\GdipSetSolidFillColor", "UPtr", pBrush, "UInt", ARGB)
}
Gdip_GetSolidFillColor(pBrush) {
   ARGB := 0
   E := DllCall("gdiplus\GdipGetSolidFillColor", "UPtr", pBrush, "UInt*", ARGB)
   If E
      return -1
   return Format("{1:#x}", ARGB)
}
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle:=0) {
   pBrush := 0
   gdipLastError := DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "UInt", ARGBfront, "UInt", ARGBback, "UPtr*", pBrush)
   return pBrush
}
Gdip_GetHatchBackgroundColor(pHatchBrush) {
   ARGB := 0
   Static Ptr := "UPtr"
   E := DllCall("gdiplus\GdipGetHatchBackgroundColor", Ptr, pHatchBrush, "uint*", ARGB)
   If E
      Return -1
   return Format("{1:#x}", ARGB)
}
Gdip_GetHatchForegroundColor(pHatchBrush) {
   ARGB := 0
   Static Ptr := "UPtr"
   E := DllCall("gdiplus\GdipGetHatchForegroundColor", Ptr, pHatchBrush, "uint*", ARGB)
   If E
      Return -1
   return Format("{1:#x}", ARGB)
}
Gdip_GetHatchStyle(pHatchBrush) {
   result := 0
   Static Ptr := "UPtr"
   E := DllCall("gdiplus\GdipGetHatchStyle", Ptr, pHatchBrush, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_CreateTextureBrush(pBitmap, WrapMode:=1, x:=0, y:=0, w:="", h:="", matrix:="", ScaleX:="", ScaleY:="", Angle:=0, ImageAttr:=0) {
   pBrush := 0
   If !(w && h)
   {
      gdipLastError := DllCall("gdiplus\GdipCreateTexture", "UPtr", pBitmap, "int", WrapMode, "UPtr*", pBrush)
   } Else
   {
      If !ImageAttr
      {
         If !IsNumber(Matrix)
            ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
         Else If (Matrix != 1)
            ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
      } Else usrImageAttr := 1
      If ImageAttr
      {
         gdipLastError := DllCall("gdiplus\GdipCreateTextureIA", "UPtr", pBitmap, "UPtr", ImageAttr, "float", x, "float", y, "float", w, "float", h, "UPtr*", pBrush)
         If pBrush
            Gdip_SetTextureWrapMode(pBrush, WrapMode)
      } Else
         gdipLastError := DllCall("gdiplus\GdipCreateTexture2", "UPtr", pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, "UPtr*", pBrush)
   }
   if (ImageAttr && usrImageAttr!=1)
      Gdip_DisposeImageAttributes(ImageAttr)
   If (ScaleX && ScaleX && pBrush)
      Gdip_ScaleTextureTransform(pBrush, ScaleX, ScaleY)
   If (Angle && pBrush)
      Gdip_RotateTextureTransform(pBrush, Angle)
   return pBrush
}
Gdip_RotateTextureTransform(pTexBrush, Angle, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipRotateTextureTransform", "UPtr", pTexBrush, "float", Angle, "int", MatrixOrder)
}
Gdip_ScaleTextureTransform(pTexBrush, ScaleX, ScaleY, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipScaleTextureTransform", "UPtr", pTexBrush, "float", ScaleX, "float", ScaleY, "int", MatrixOrder)
}
Gdip_TranslateTextureTransform(pTexBrush, X, Y, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipTranslateTextureTransform", "UPtr", pTexBrush, "float", X, "float", Y, "int", MatrixOrder)
}
Gdip_MultiplyTextureTransform(pTexBrush, hMatrix, matrixOrder:=0) {
   Return DllCall("gdiplus\GdipMultiplyTextureTransform", "UPtr", pTexBrush, "UPtr", hMatrix, "int", matrixOrder)
}
Gdip_SetTextureTransform(pTexBrush, hMatrix) {
   return DllCall("gdiplus\GdipSetTextureTransform", "UPtr", pTexBrush, "UPtr", hMatrix)
}
Gdip_GetTextureTransform(pTexBrush) {
   hMatrix := 0
   gdipLastError := DllCall("gdiplus\GdipGetTextureTransform", "UPtr", pTexBrush, "UPtr*", hMatrix)
   Return hMatrix
}
Gdip_ResetTextureTransform(pTexBrush) {
   return DllCall("gdiplus\GdipResetTextureTransform", "UPtr", pTexBrush)
}
Gdip_SetTextureWrapMode(pTexBrush, WrapMode) {
   return DllCall("gdiplus\GdipSetTextureWrapMode", "UPtr", pTexBrush, "int", WrapMode)
}
Gdip_GetTextureWrapMode(pTexBrush) {
   result := 0
   E := DllCall("gdiplus\GdipGetTextureWrapMode", "UPtr", pTexBrush, "int*", result)
   If E
      return -1
   Return result
}
Gdip_GetTextureImage(pTexBrush) {
   Static Ptr := "UPtr"
   pBitmapDest := 0
   gdipLastError := DllCall("gdiplus\GdipGetTextureImage", "UPtr", pTexBrush, "UPtr*", pBitmapDest)
   Return pBitmapDest
}
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode:=1) {
   return Gdip_CreateLinearGrBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode)
}
Gdip_CreateLinearGrBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode:=1) {
   Static Ptr := "UPtr"
   CreatePointF(PointF1, x1, y1)
   CreatePointF(PointF2, x2, y2)
   pLinearGradientBrush := 0
   gdipLastError := DllCall("gdiplus\GdipCreateLineBrush", Ptr, &PointF1, Ptr, &PointF2, "Uint", ARGB1, "Uint", ARGB2, "int", WrapMode, "UPtr*", pLinearGradientBrush)
   return pLinearGradientBrush
}
Gdip_SetLinearGrBrushColors(pLinearGradientBrush, ARGB1, ARGB2) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipSetLineColors", Ptr, pLinearGradientBrush, "UInt", ARGB1, "UInt", ARGB2)
}
Gdip_GetLinearGrBrushColors(pLinearGradientBrush, ByRef ARGB1, ByRef ARGB2) {
   Static Ptr := "UPtr"
   VarSetCapacity(colors, 8, 0)
   E := DllCall("gdiplus\GdipGetLineColors", Ptr, pLinearGradientBrush, "Ptr", &colors)
   ARGB1 := NumGet(colors, 0, "UInt")
   ARGB2 := NumGet(colors, 4, "UInt")
   ARGB1 := Format("{1:#x}", ARGB1)
   ARGB2 := Format("{1:#x}", ARGB2)
   return E
}
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode:=1, WrapMode:=1) {
   return Gdip_CreateLinearGrBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode, WrapMode)
}
Gdip_CreateLinearGrBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode:=1, WrapMode:=1) {
   CreateRectF(RectF, x, y, w, h)
   pLinearGradientBrush := 0
   gdipLastError := DllCall("gdiplus\GdipCreateLineBrushFromRect", "UPtr", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, "UPtr*", pLinearGradientBrush)
   return pLinearGradientBrush
}
Gdip_GetLinearGrBrushGammaCorrection(pLinearGradientBrush) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetLineGammaCorrection", "UPtr", pLinearGradientBrush, "int*", result)
   If gdipLastError
      Return -1
   Return result
}
Gdip_SetLinearGrBrushGammaCorrection(pLinearGradientBrush, UseGammaCorrection) {
   Return DllCall("gdiplus\GdipSetLineGammaCorrection", "UPtr", pLinearGradientBrush, "int", UseGammaCorrection)
}
Gdip_GetLinearGrBrushRect(pLinearGradientBrush) {
  VarSetCapacity(RectF, 16, 0)
  E := DllCall("gdiplus\GdipGetLineRect", "UPtr", pLinearGradientBrush, "UPtr", &RectF)
  If (!E) {
      rData := {}
      rData.x := NumGet(&RectF, 0, "float")
      rData.y := NumGet(&RectF, 4, "float")
      rData.w := NumGet(&RectF, 8, "float")
      rData.h := NumGet(&RectF, 12, "float")
      Return rData
  } Else {
      Return E
  }
}
Gdip_ResetLinearGrBrushTransform(pLinearGradientBrush) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipResetLineTransform", Ptr, pLinearGradientBrush)
}
Gdip_ScaleLinearGrBrushTransform(pLinearGradientBrush, ScaleX, ScaleY, matrixOrder:=0) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipScaleLineTransform", Ptr, pLinearGradientBrush, "float", ScaleX, "float", ScaleY, "int", matrixOrder)
}
Gdip_MultiplyLinearGrBrushTransform(pLinearGradientBrush, hMatrix, matrixOrder:=0) {
   Static Ptr := "UPtr"
   Return DllCall("gdiplus\GdipMultiplyLineTransform", Ptr, pLinearGradientBrush, Ptr, hMatrix, "int", matrixOrder)
}
Gdip_TranslateLinearGrBrushTransform(pLinearGradientBrush, X, Y, matrixOrder:=0) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipTranslateLineTransform", Ptr, pLinearGradientBrush, "float", X, "float", Y, "int", matrixOrder)
}
Gdip_RotateLinearGrBrushTransform(pLinearGradientBrush, Angle, matrixOrder:=0) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipRotateLineTransform", Ptr, pLinearGradientBrush, "float", Angle, "int", matrixOrder)
}
Gdip_SetLinearGrBrushTransform(pLinearGradientBrush, pMatrix) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipSetLineTransform", Ptr, pLinearGradientBrush, Ptr, pMatrix)
}
Gdip_GetLinearGrBrushTransform(pLineGradientBrush) {
   Static Ptr := "UPtr"
   pMatrix := 0
   DllCall("gdiplus\GdipGetLineTransform", Ptr, pLineGradientBrush, "UPtr*", pMatrix)
   Return pMatrix
}
Gdip_RotateLinearGrBrushAtCenter(pLinearGradientBrush, Angle, MatrixOrder:=1) {
  Rect := Gdip_GetLinearGrBrushRect(pLinearGradientBrush)
  cX := Rect.x + (Rect.w / 2)
  cY := Rect.y + (Rect.h / 2)
  pMatrix := Gdip_CreateMatrix()
  Gdip_TranslateMatrix(pMatrix, -cX , -cY)
  Gdip_RotateMatrix(pMatrix, Angle, MatrixOrder)
  Gdip_TranslateMatrix(pMatrix, cX, cY, MatrixOrder)
  E := Gdip_SetLinearGrBrushTransform(pLinearGradientBrush, pMatrix)
  Gdip_DeleteMatrix(pMatrix)
  Return E
}
Gdip_GetLinearGrBrushWrapMode(pLinearGradientBrush) {
   result := 0
   E := DllCall("gdiplus\GdipGetLineWrapMode", "UPtr", pLinearGradientBrush, "int*", result)
   If E
      return -1
   Return result
}
Gdip_SetLinearGrBrushLinearBlend(pLinearGradientBrush, nFocus, nScale) {
   Return DllCall("gdiplus\GdipSetLineLinearBlend", "UPtr", pLinearGradientBrush, "float", nFocus, "float", nScale)
}
Gdip_SetLinearGrBrushSigmaBlend(pLinearGradientBrush, nFocus, nScale) {
   Return DllCall("gdiplus\GdipSetLineSigmaBlend", "UPtr", pLinearGradientBrush, "float", nFocus, "float", nScale)
}
Gdip_SetLinearGrBrushWrapMode(pLinearGradientBrush, WrapMode) {
   Return DllCall("gdiplus\GdipSetLineWrapMode", "UPtr", pLinearGradientBrush, "int", WrapMode)
}
Gdip_GetLinearGrBrushBlendCount(pLinearGradientBrush) {
   result := 0
   E := DllCall("gdiplus\GdipGetLineBlendCount", "UPtr", pLinearGradientBrush, "int*", result)
   If E
      return -1
   Return result
}
Gdip_SetLinearGrBrushPresetBlend(pBrush, _positions, _colors, pathBrush:=0) {
   elements := _colors.Length()
   If (elements>_positions.Length() || elements<2)
      Return 2 ; invalid parameters
   _positions.InsertAt(1, 0.0), _positions.Push(1.0)
   _colors.Push(_colors[elements])
   _colors.InsertAt(1, _colors[1])
   elements := _colors.Length()
   VarSetCapacity(COLORS, elements*4, 0)
   For i, _color in _colors
      NumPut(_color, COLORS, (i-1)*4, "UInt")
   VarSetCapacity(POSITIONS, elements*4, 0)
   For i, _pos in _positions
      NumPut(_pos, POSITIONS, (i-1)*4, "Float")
   func2exec := (pathBrush=1) ? "GdipSetPathGradientPresetBlend" : "GdipSetLinePresetBlend"
   Return DllCall("gdiplus\" func2exec, "UPtr", pBrush, "UPtr", &COLORS, "UPtr", &POSITIONS, "Int", elements)
}
Gdip_SetPathGradientPresetBlend(pBrush, _positions, _colors) {
   Return Gdip_SetLinearGrBrushPresetBlend(pBrush, _positions, _colors, 1)
}
Gdip_CloneBrush(pBrush) {
   pBrushClone := 0
   gdipLastError := DllCall("gdiplus\GdipCloneBrush", "UPtr", pBrush, "UPtr*", pBrushClone)
   return pBrushClone
}
Gdip_GetBrushType(pBrush) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetBrushType", Ptr, pBrush, "int*", result)
   If E
      return -1
   Return result
}
Gdip_DeleteRegion(hRegion) {
   If hRegion
      return DllCall("gdiplus\GdipDeleteRegion", "UPtr", hRegion)
}
Gdip_DeletePen(pPen) {
   If pPen
      return DllCall("gdiplus\GdipDeletePen", "UPtr", pPen)
}
Gdip_DeleteBrush(pBrush) {
   If pBrush
      return DllCall("gdiplus\GdipDeleteBrush", "UPtr", pBrush)
}
Gdip_DisposeImage(pBitmap, noErr:=0) {
   If (StrLen(pBitmap)<=2 && noErr=1)
      Return 0
   r := DllCall("gdiplus\GdipDisposeImage", "UPtr", pBitmap)
   If (r=2 || r=1) && (noErr=1)
      r := 0
   Return r
}
Gdip_DeleteGraphics(pGraphics) {
   If pGraphics
      return DllCall("gdiplus\GdipDeleteGraphics", "UPtr", pGraphics)
}
Gdip_DisposeImageAttributes(ImageAttr) {
   If ImageAttr
      return DllCall("gdiplus\GdipDisposeImageAttributes", "UPtr", ImageAttr)
}
Gdip_DeleteFont(hFont) {
   If hFont
      return DllCall("gdiplus\GdipDeleteFont", "UPtr", hFont)
}
Gdip_DeleteStringFormat(hStringFormat) {
   return DllCall("gdiplus\GdipDeleteStringFormat", "UPtr", hStringFormat)
}
Gdip_DeleteFontFamily(hFontFamily) {
   If hFontFamily
      return DllCall("gdiplus\GdipDeleteFontFamily", "UPtr", hFontFamily)
}
Gdip_DeletePrivateFontCollection(hFontCollection) {
   If hFontCollection
      return DllCall("gdiplus\GdipDeletePrivateFontCollection", "Ptr", hFontCollection)
}
Gdip_DeleteMatrix(hMatrix) {
   If hMatrix
      return DllCall("gdiplus\GdipDeleteMatrix", "UPtr", hMatrix)
}
Gdip_DrawOrientedString(pGraphics, String, FontName, Size, Style, X, Y, Width, Height, Angle:=0, pBrush:=0, pPen:=0, Align:=0, ScaleX:=1) {
   If (!pBrush && !pPen)
      Return -3
   If RegExMatch(FontName, "^(.\:\\.)")
   {
      hFontCollection := Gdip_NewPrivateFontCollection()
      hFontFamily := Gdip_CreateFontFamilyFromFile(FontName, hFontCollection)
   } Else hFontFamily := Gdip_FontFamilyCreate(FontName)
   If !hFontFamily
      hFontFamily := Gdip_FontFamilyCreateGeneric(1)
   If !hFontFamily
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -1
   }
   FormatStyle := 0x4000
   hStringFormat := Gdip_StringFormatCreate(FormatStyle)
   If !hStringFormat
      hStringFormat := Gdip_StringFormatGetGeneric(1)
   If !hStringFormat
   {
      Gdip_DeleteFontFamily(hFontFamily)
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -2
   }
   Gdip_SetStringFormatTrimming(hStringFormat, 3)
   Gdip_SetStringFormatAlign(hStringFormat, Align)
   pPath := Gdip_CreatePath()
   E := Gdip_AddPathString(pPath, String, hFontFamily, Style, Size, hStringFormat, X, Y, Width, Height)
   If (ScaleX>0 && ScaleX!=1)
   {
      hMatrix := Gdip_CreateMatrix()
      Gdip_ScaleMatrix(hMatrix, ScaleX, 1)
      Gdip_TransformPath(pPath, hMatrix)
      Gdip_DeleteMatrix(hMatrix)
   }
   Gdip_RotatePathAtCenter(pPath, Angle)
   If (!E && pBrush)
      E := Gdip_FillPath(pGraphics, pBrush, pPath)
   If (!E && pPen)
      E := Gdip_DrawPath(pGraphics, pPen, pPath)
   PathBounds := Gdip_GetPathWorldBounds(pPath)
   Gdip_DeleteStringFormat(hStringFormat)
   Gdip_DeleteFontFamily(hFontFamily)
   Gdip_DeletePath(pPath)
   If hFontCollection
      Gdip_DeletePrivateFontCollection(hFontCollection)
   Return E ? E : PathBounds
}
Gdip_TextToGraphics(pGraphics, Text, Options, Font:="Arial", Width:="", Height:="", Measure:=0, userBrush:=0, Unit:=0, acceptTabStops:=0) {
   Static Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
        , Alignments := "Near|Left|Centre|Center|Far|Right"
   OWidth := Width
   IWidth := Width, IHeight:= Height
   pattern_opts := (A_AhkVersion < "2") ? "iO)" : "i)"
   RegExMatch(Options, pattern_opts "X([\-\d\.]+)(p*)", xpos)
   RegExMatch(Options, pattern_opts "Y([\-\d\.]+)(p*)", ypos)
   RegExMatch(Options, pattern_opts "W([\-\d\.]+)(p*)", PWidth)
   RegExMatch(Options, pattern_opts "H([\-\d\.]+)(p*)", Height)
   RegExMatch(Options, pattern_opts "C(?!(entre|enter))([a-f\d]+)", Colour)
   RegExMatch(Options, pattern_opts "Top|Up|Bottom|Down|vCentre|vCenter", vPos)
   RegExMatch(Options, pattern_opts "NoWrap", NoWrap)
   RegExMatch(Options, pattern_opts "R(\d)", Rendering)
   RegExMatch(Options, pattern_opts "S(\d+)(p*)", Size)
   Width := PWidth
   if Colour && IsInteger(Colour[2]) && !Gdip_DeleteBrush(Gdip_CloneBrush(Colour[2]))
   {
      PassBrush := 1
      pBrush := Colour[2]
   }
   if !(IWidth && IHeight) && ((xpos && xpos[2]) || (ypos && ypos[2]) || (Width && Width[2]) || (Height && Height[2]) || (Size && Size[2]))
      return -1
   Style := 0
   For eachStyle, valStyle in StrSplit(Styles, "|")
   {
      if RegExMatch(Options, "\b" valStyle)
         Style |= (valStyle != "StrikeOut") ? (A_Index-1) : 8
   }
   Align := 0
   For eachAlignment, valAlignment in StrSplit(Alignments, "|")
   {
      if RegExMatch(Options, "\b" valAlignment)
         Align |= A_Index//2.1   ; 0|0|1|1|2|2
   }
   xpos := (xpos && (xpos[1] != "")) ? xpos[2] ? IWidth*(xpos[1]/100) : xpos[1] : 0
   ypos := (ypos && (ypos[1] != "")) ? ypos[2] ? IHeight*(ypos[1]/100) : ypos[1] : 0
   Width := (Width && Width[1]) ? Width[2] ? IWidth*(Width[1]/100) : Width[1] : IWidth
   Height := (Height && Height[1]) ? Height[2] ? IHeight*(Height[1]/100) : Height[1] : IHeight
   If !PassBrush
      Colour := "0x" (Colour && Colour[2] ? Colour[2] : "ff000000")
   Rendering := (Rendering && (Rendering[1] >= 0) && (Rendering[1] <= 5)) ? Rendering[1] : 4
   Size := (Size && (Size[1] > 0)) ? Size[2] ? IHeight*(Size[1]/100) : Size[1] : 12
   If RegExMatch(Font, "^(.\:\\.)")
   {
      hFontCollection := Gdip_NewPrivateFontCollection()
      hFontFamily := Gdip_CreateFontFamilyFromFile(Font, hFontCollection)
   } Else hFontFamily := Gdip_FontFamilyCreate(Font)
   If !hFontFamily
      hFontFamily := Gdip_FontFamilyCreateGeneric(1)
   hFont := Gdip_FontCreate(hFontFamily, Size, Style, Unit)
   FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
   hStringFormat := Gdip_StringFormatCreate(FormatStyle)
   If !hStringFormat
      hStringFormat := Gdip_StringFormatGetGeneric(1)
   pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
   if !(hFontFamily && hFont && hStringFormat && pBrush && pGraphics)
   {
      E := !pGraphics ? -2 : !hFontFamily ? -3 : !hFont ? -4 : !hStringFormat ? -5 : !pBrush ? -6 : 0
      If pBrush
         Gdip_DeleteBrush(pBrush)
      If hStringFormat
         Gdip_DeleteStringFormat(hStringFormat)
      If hFont
         Gdip_DeleteFont(hFont)
      If hFontFamily
         Gdip_DeleteFontFamily(hFontFamily)
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      return E
   }
   CreateRectF(RC, xpos, ypos, Width, Height)
   If (acceptTabStops=1)
      Gdip_SetStringFormatTabStops(hStringFormat, [50,100,200])
   Gdip_SetStringFormatAlign(hStringFormat, Align)
   If InStr(Options, "autotrim")
      Gdip_SetStringFormatTrimming(hStringFormat, 3)
   Gdip_SetTextRenderingHint(pGraphics, Rendering)
   ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hStringFormat, RC)
   ReturnRCtest := StrSplit(ReturnRC, "|")
   testX := Floor(ReturnRCtest[1]) - 2
   If (testX>xpos && NoWrap && (PWidth>2 || OWidth>2))
   {
      nxpos := Floor(xpos - (testX - xpos))
      CreateRectF(RC, nxpos, ypos, Width, Height)
      ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hStringFormat, RC)
   }
   If vPos
   {
      ReturnRC := StrSplit(ReturnRC, "|")
      if (vPos[0] = "vCentre") || (vPos[0] = "vCenter")
         ypos += (Height-ReturnRC[4])//2
      else if (vPos[0] = "Top") || (vPos[0] = "Up")
         ypos += 0
      else if (vPos[0] = "Bottom") || (vPos[0] = "Down")
         ypos += Height-ReturnRC[4]
      CreateRectF(RC, xpos, ypos, Width, ReturnRC[4])
      ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hStringFormat, RC)
   }
   thisBrush := userBrush ? userBrush : pBrush
   if !Measure
      _E := Gdip_DrawString(pGraphics, Text, hFont, hStringFormat, thisBrush, RC)
   if !PassBrush
      Gdip_DeleteBrush(pBrush)
   Gdip_DeleteStringFormat(hStringFormat)
   Gdip_DeleteFont(hFont)
   Gdip_DeleteFontFamily(hFontFamily)
   If hFontCollection
      Gdip_DeletePrivateFontCollection(hFontCollection)
   return _E ? _E : ReturnRC
}
Gdip_DrawString(pGraphics, sString, hFont, hStringFormat, pBrush, ByRef RectF) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipDrawString"
               , Ptr, pGraphics
               , "WStr", sString
               , "int", -1
               , Ptr, hFont
               , Ptr, &RectF
               , Ptr, hStringFormat
               , Ptr, pBrush)
}
Gdip_MeasureString(pGraphics, sString, hFont, hStringFormat, ByRef RectF) {
   Static Ptr := "UPtr"
   VarSetCapacity(RC, 16)
   Chars := 0
   Lines := 0
   DllCall("gdiplus\GdipMeasureString"
               , Ptr, pGraphics
               , "WStr", sString
               , "int", -1
               , Ptr, hFont
               , Ptr, &RectF
               , Ptr, hStringFormat
               , Ptr, &RC
               , "uint*", Chars
               , "uint*", Lines)
   return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}
Gdip_DrawStringAlongPolygon(pGraphics, String, FontName, FontSize, Style, pBrush, DriverPoints:=0, pPath:=0, minDist:=0, flatness:=4, hMatrix:=0, Unit:=0) {
   If (!minDist || minDist<1)
      minDist := FontSize//4 + 1
   If (pPath && !DriverPoints)
   {
      newPath := Gdip_ClonePath(pPath)
      Gdip_PathOutline(newPath, flatness)
      DriverPoints := Gdip_GetPathPoints(newPath)
      Gdip_DeletePath(newPath)
      If !DriverPoints
         Return -5
   }
   If (!pPath && !DriverPoints)
      Return -4
   If RegExMatch(FontName, "^(.\:\\.)")
   {
      hFontCollection := Gdip_NewPrivateFontCollection()
      hFontFamily := Gdip_CreateFontFamilyFromFile(FontName, hFontCollection)
   } Else hFontFamily := Gdip_FontFamilyCreate(FontName)
   If !hFontFamily
      hFontFamily := Gdip_FontFamilyCreateGeneric(1)
   If !hFontFamily
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -1
   }
   hFont := Gdip_FontCreate(hFontFamily, FontSize, Style, Unit)
   If !hFont
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Gdip_DeleteFontFamily(hFontFamily)
      Return -2
   }
   Points := StrSplit(DriverPoints, "|")
   PointsCount := Points.Length()
   If (PointsCount<2)
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Gdip_DeleteFont(hFont)
      Gdip_DeleteFontFamily(hFontFamily)
      Return -3
   }
   txtLen := StrLen(String)
   If (PointsCount<txtLen)
   {
      loopsMax := txtLen * 3
      newDriverPoints := DriverPoints
      Loop %loopsMax%
      {
         newDriverPoints := GenerateIntermediatePoints(newDriverPoints, minDist, totalResult)
         If (totalResult>=txtLen)
            Break
      }
      String := SubStr(String, 1, totalResult)
   } Else newDriverPoints := DriverPoints
   E := Gdip_DrawDrivenString(pGraphics, String, hFont, pBrush, newDriverPoints, 1, hMatrix)
   Gdip_DeleteFont(hFont)
   Gdip_DeleteFontFamily(hFontFamily)
   If hFontCollection
      Gdip_DeletePrivateFontCollection(hFontCollection)
   return E
}
GenerateIntermediatePoints(PointsList, minDist, ByRef resultPointsCount) {
   AllPoints := StrSplit(PointsList, "|")
   PointsCount := AllPoints.Length()
   thizIndex := 0.5
   resultPointsCount := 0
   loopsMax := PointsCount*2
   Loop %loopsMax%
   {
        thizIndex += 0.5
        thisIndex := InStr(thizIndex, ".5") ? thizIndex : Trim(Round(thizIndex))
        thisPoint := AllPoints[thisIndex]
        theseCoords := StrSplit(thisPoint, ",")
        If (theseCoords[1]!="" && theseCoords[2]!="")
        {
           resultPointsCount++
           newPointsList .= theseCoords[1] "," theseCoords[2] "|"
        } Else
        {
           aIndex := Trim(Round(thizIndex - 0.5))
           bIndex := Trim(Round(thizIndex + 0.5))
           theseAcoords := StrSplit(AllPoints[aIndex], ",")
           theseBcoords := StrSplit(AllPoints[bIndex], ",")
           If (theseAcoords[1]!="" && theseAcoords[2]!="")
           && (theseBcoords[1]!="" && theseBcoords[2]!="")
           {
               newPosX := (theseAcoords[1] + theseBcoords[1])//2
               newPosY := (theseAcoords[2] + theseBcoords[2])//2
               distPosX := newPosX - theseAcoords[1]
               distPosY := newPosY - theseAcoords[2]
               If (distPosX>minDist || distPosY>minDist)
               {
                  newPointsList .= newPosX "," newPosY "|"
                  resultPointsCount++
               }
           }
        }
   }
   If !newPointsList
      Return PointsList
   Return Trim(newPointsList, "|")
}
Gdip_DrawDrivenString(pGraphics, String, hFont, pBrush, DriverPoints, Flags:=1, hMatrix:=0) {
   txtLen := -1 ; StrLen(String)
   Static Ptr := "UPtr"
   iCount := CreatePointsF(PointsF, DriverPoints)
   return DllCall("gdiplus\GdipDrawDriverString", Ptr, pGraphics, "UPtr", &String, "int", txtLen, Ptr, hFont, Ptr, pBrush, Ptr, &PointsF, "int", Flags, Ptr, hMatrix)
}
Gdip_GetStringFormatFlags(hStringFormat) {
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatFlags", "UPtr", hStringFormat, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_StringFormatCreate(FormatFlags:=0, LangID:=0) {
   hStringFormat := 0
   gdipLastError := DllCall("gdiplus\GdipCreateStringFormat", "int", FormatFlags, "int", LangID, "UPtr*", hStringFormat)
   return hStringFormat
}
Gdip_CloneStringFormat(hStringFormat) {
   Static Ptr := "UPtr"
   newHStringFormat := 0
   gdipLastError := DllCall("gdiplus\GdipCloneStringFormat", Ptr, hStringFormat, "uint*", newHStringFormat)
   Return newHStringFormat
}
Gdip_StringFormatGetGeneric(whichFormat:=0) {
   hStringFormat := 0
   If (whichFormat=1)
      gdipLastError := DllCall("gdiplus\GdipStringFormatGetGenericTypographic", "UPtr*", hStringFormat)
   Else
      gdipLastError := DllCall("gdiplus\GdipStringFormatGetGenericDefault", "UPtr*", hStringFormat)
   Return hStringFormat
}
Gdip_SetStringFormatAlign(hStringFormat, Align) {
   return DllCall("gdiplus\GdipSetStringFormatAlign", "UPtr", hStringFormat, "int", Align)
}
Gdip_GetStringFormatAlign(hStringFormat) {
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatAlign", "UPtr", hStringFormat, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_GetStringFormatLineAlign(hStringFormat) {
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatLineAlign", "UPtr", hStringFormat, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_GetStringFormatDigitSubstitution(hStringFormat) {
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatDigitSubstitution", "UPtr", hStringFormat, "ushort*", 0, "uint*", result)
   If E
      Return -1
   Return result
}
Gdip_GetStringFormatHotkeyPrefix(hStringFormat) {
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatHotkeyPrefix", "UPtr", hStringFormat, "uint*", result)
   If E
      Return -1
   Return result
}
Gdip_GetStringFormatTrimming(hStringFormat) {
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatTrimming", "UPtr", hStringFormat, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_SetStringFormatLineAlign(hStringFormat, StringAlign) {
   Return DllCall("gdiplus\GdipSetStringFormatLineAlign", "UPtr", hStringFormat, "int", StringAlign)
}
Gdip_SetStringFormatDigitSubstitution(hStringFormat, DigitSubstitute, LangID:=0) {
   return DllCall("gdiplus\GdipSetStringFormatDigitSubstitution", "UPtr", hStringFormat, "ushort", LangID, "uint", DigitSubstitute)
}
Gdip_SetStringFormatFlags(hStringFormat, Flags) {
   return DllCall("gdiplus\GdipSetStringFormatFlags", "UPtr", hStringFormat, "int", Flags)
}
Gdip_SetStringFormatHotkeyPrefix(hStringFormat, PrefixProcessMode) {
   return DllCall("gdiplus\GdipSetStringFormatHotkeyPrefix", "UPtr", hStringFormat, "uint", PrefixProcessMode)
}
Gdip_SetStringFormatTrimming(hStringFormat, TrimMode) {
   return DllCall("gdiplus\GdipSetStringFormatTrimming", "UPtr", hStringFormat, "int", TrimMode)
}
Gdip_SetStringFormatTabStops(hStringFormat, aTabStops) {
   if (!aTabStops.Length())
      return
   firstTabOffset := 0
   count := aTabStops.MaxIndex()
   VarSetCapacity(tabStops, count * 4)
   for k, v in aTabStops
      NumPut(v, tabStops, (A_Index - 1) * 4, "float")
   return DllCall("gdiplus\GdipSetStringFormatTabStops", "UPtr", hStringFormat, "float", firstTabOffset, "int", count, "ptr", &tabStops)
}
Gdip_GetStringFormatTabStopCount(hStringFormat) {
   VarSetCapacity(count, 4)
   gdipLastError := DllCall("gdiplus\GdipGetStringFormatTabStopCount", "UPtr", hStringFormat, "ptr", &count)
   return NumGet(count, 0, "int")
}
Gdip_GetStringFormatTabStops(hStringFormat) {
   count := Gdip_GetStringFormatTabStopCount(hStringFormat)
   firstTabOffset := 0
   VarSetCapacity(tabStops, count * 4)
   gdipLastError := DllCall("gdiplus\GdipGetStringFormatTabStops", "UPtr", hStringFormat, "int", count, "ptr", &firstTabOffset, "ptr", &tabStops)
   ret := []
   loop, % count
      ret.Push(NumGet(tabStops, (A_Index - 1) * 4, "float"))
   return ret
}
Gdip_FontCreate(hFontFamily, Size, Style:=0, Unit:=0) {
   hFont := 0
   gdipLastError := DllCall("gdiplus\GdipCreateFont", "UPtr", hFontFamily, "float", Size, "int", Style, "int", Unit, "UPtr*", hFont)
   return hFont
}
Gdip_FontFamilyCreate(FontName) {
   hFontFamily := 0
   gdipLastError := DllCall("gdiplus\GdipCreateFontFamilyFromName"
               , "WStr", FontName, "uint", 0
               , "UPtr*", hFontFamily)
   return hFontFamily
}
Gdip_NewPrivateFontCollection() {
   hFontCollection := 0
   gdipLastError := DllCall("gdiplus\GdipNewPrivateFontCollection", "ptr*", hFontCollection)
   Return hFontCollection
}
Gdip_CreateFontFamilyFromFile(FontFile, hFontCollection, FontName:="") {
   If !hFontCollection
      Return
   hFontFamily := 0
   E := DllCall("gdiplus\GdipPrivateAddFontFile", "ptr", hFontCollection, "str", FontFile)
   if (FontName="" && !E)
   {
      VarSetCapacity(pFontFamily, 10, 0)
      DllCall("gdiplus\GdipGetFontCollectionFamilyList", "ptr", hFontCollection, "int", 1, "ptr", &pFontFamily, "int*", found)
      VarSetCapacity(FontName, 100)
      DllCall("gdiplus\GdipGetFamilyName", "ptr", NumGet(pFontFamily, 0, "ptr"), "str", FontName, "ushort", 1033)
   }
   If !E
      DllCall("gdiplus\GdipCreateFontFamilyFromName", "str", FontName, "ptr", hFontCollection, "uint*", hFontFamily)
   Return hFontFamily
}
Gdip_GetInstalledFontFamilies(nameRegex := "") {
   Static pFontCollection := 0
   If (pFontCollection == 0) {
      DllCall("GdiPlus\GdipNewInstalledFontCollection"
      , "Ptr*", pFontCollection := 0)
   }
   DllCall("GdiPlus\GdipGetFontCollectionFamilyCount"
   , "Ptr" , pFontCollection
   , "Int*", familyCount := 0)
   VarSetCapacity(familyList, 2*A_PtrSize*familyCount, 0)
   DllCall("GdiPlus\GdipGetFontCollectionFamilyList"
   , "Ptr" ,  pFontCollection
   , "Int" ,  familyCount
   , "Ptr" ,  &familyList
   , "Int*",  familyCount)
   langId := 0
   families := []
   Loop % familyCount {
      familyPtr := NumGet(familyList, (A_Index-1)*A_PtrSize, "Ptr")
      VarSetCapacity(familyName, 32*2, 0)
      DllCall("GdiPlus\GdipGetFamilyName"
      , "Ptr"   , familyPtr
      , "WStr"  , familyName
      , "UShort", langId)
      If (familyName ~= nameRegex) {
         families.Push(familyName)
      }
   }
   Return families
}
Gdip_FontFamilyCreateGeneric(whichStyle) {
   hFontFamily := 0
   If (whichStyle=0)
      DllCall("gdiplus\GdipGetGenericFontFamilyMonospace", "UPtr*", hFontFamily)
   Else If (whichStyle=1)
      DllCall("gdiplus\GdipGetGenericFontFamilySansSerif", "UPtr*", hFontFamily)
   Else If (whichStyle=2)
      DllCall("gdiplus\GdipGetGenericFontFamilySerif", "UPtr*", hFontFamily)
   Return hFontFamily
}
Gdip_CreateFontFromDC(hDC) {
   pFont := 0
   gdipLastError := DllCall("gdiplus\GdipCreateFontFromDC", "UPtr", hDC, "UPtr*", pFont)
   Return pFont
}
Gdip_CreateFontFromLogfontW(hDC, LogFont) {
     pFont := 0
     gdipLastError := DllCall("Gdiplus\GdipCreateFontFromLogfontW", "Ptr", hDC, "Ptr", LogFont, "UPtrP", pFont)
     return pFont
}
Gdip_GetFontHeight(hFont, pGraphics:=0) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetFontHeight", "UPtr", hFont, "UPtr", pGraphics, "float*", result)
   Return result
}
Gdip_GetFontHeightGivenDPI(hFont, DPI:=72) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetFontHeightGivenDPI", "UPtr", hFont, "float", DPI, "float*", result)
   Return result
}
Gdip_GetFontSize(hFont) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetFontSize", "UPtr", hFont, "float*", result)
   Return result
}
Gdip_GetFontStyle(hFont) {
   result := 0
   g := DllCall("gdiplus\GdipGetFontStyle", "UPtr", hFont, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_GetFontUnit(hFont) {
   result := 0
   E := DllCall("gdiplus\GdipGetFontUnit", "UPtr", hFont, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_GetFontFamily(hFont) {
   hFontFamily := 0
   gdipLastError := DllCall("gdiplus\GdipGetFamily", "UPtr", hFont, "UPtr*", hFontFamily)
   Return hFontFamily
}
Gdip_CloneFont(hfont) {
   newHFont := 0
   gdipLastError := DllCall("gdiplus\GdipCloneFont", "UPtr", hFont, "UPtr*", newHFont)
   Return newHFont
}
Gdip_CloneFontFamily(hFontFamily) {
   newHFontFamily := 0
   gdipLastError := DllCall("gdiplus\GdipCloneFontFamily", "UPtr", hFontFamily, "UPtr*", newHFontFamily)
   Return newHFontFamily
}
Gdip_IsFontStyleAvailable(hFontFamily, Style) {
   result := 0
   E := DllCall("gdiplus\GdipIsStyleAvailable", "UPtr", hFontFamily, "int", Style, "Int*", result)
   If E
      Return -1
   Return result
}
Gdip_GetFontFamilyCellScents(hFontFamily, ByRef Ascent, ByRef Descent, Style:=0) {
   Ascent := Descent := 0
   E := DllCall("gdiplus\GdipGetCellAscent", "UPtr", hFontFamily, "int", Style, "ushort*", Ascent)
   E := DllCall("gdiplus\GdipGetCellDescent", "UPtr", hFontFamily, "int", Style, "ushort*", Descent)
   Return E
}
Gdip_GetFontFamilyEmHeight(hFontFamily, Style:=0) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetEmHeight", "UPtr", hFontFamily, "int", Style, "ushort*", result)
   Return result
}
Gdip_GetFontFamilyLineSpacing(hFontFamily, Style:=0) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipGetLineSpacing", "UPtr", hFontFamily, "int", Style, "ushort*", result)
   Return result
}
Gdip_GetFontFamilyName(hFontFamily) {
   VarSetCapacity(FontName, 90)
   gdipLastError := DllCall("gdiplus\GdipGetFamilyName", "UPtr", hFontFamily, "Ptr", &FontName, "ushort", 0)
   Return FontName
}
Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y) {
   hMatrix := 0
   gdipLastError := DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, "UPtr*", hMatrix)
   return hMatrix
}
Gdip_CreateMatrix() {
   hMatrix := 0
   gdipLastError := DllCall("gdiplus\GdipCreateMatrix", "UPtr*", hMatrix)
   return hMatrix
}
Gdip_InvertMatrix(hMatrix) {
   Return DllCall("gdiplus\GdipInvertMatrix", "UPtr", hMatrix)
}
Gdip_IsMatrixEqual(hMatrixA, hMatrixB) {
   result := 0
   E := DllCall("gdiplus\GdipIsMatrixEqual", "UPtr", hMatrixA, "UPtr", hMatrixB, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_IsMatrixIdentity(hMatrix) {
   result := 0
   E := DllCall("gdiplus\GdipIsMatrixIdentity", "UPtr", hMatrix, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_IsMatrixInvertible(hMatrix) {
   result := 0
   E := DllCall("gdiplus\GdipIsMatrixInvertible", "UPtr", hMatrix, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_MultiplyMatrix(hMatrixA, hMatrixB, matrixOrder) {
   Return DllCall("gdiplus\GdipMultiplyMatrix", "UPtr", hMatrixA, "UPtr", hMatrixB, "int", matrixOrder)
}
Gdip_CloneMatrix(hMatrix) {
   newHMatrix := 0
   gdipLastError := DllCall("gdiplus\GdipCloneMatrix", "UPtr", hMatrix, "UPtr*", newHMatrix)
   return newHMatrix
}
Gdip_CreatePath(BrushMode:=0) {
   pPath := 0
   gdipLastError := DllCall("gdiplus\GdipCreatePath", "int", BrushMode, "UPtr*", pPath)
   return pPath
}
Gdip_AddPathEllipse(pPath, x, y, w, h) {
   return DllCall("gdiplus\GdipAddPathEllipse", "UPtr", pPath, "float", x, "float", y, "float", w, "float", h)
}
Gdip_AddPathRectangle(pPath, x, y, w, h) {
   return DllCall("gdiplus\GdipAddPathRectangle", "UPtr", pPath, "float", x, "float", y, "float", w, "float", h)
}
Gdip_AddPathRoundedRectangle(pPath, x, y, w, h, r) {
   E := 0
   r := (w <= h) ? (r < w / 2) ? r : w / 2 : (r < h / 2) ? r : h / 2
   If (E := Gdip_AddPathRectangle(pPath, x+r, y, w-(2*r), r))
      Return E
   If (E := Gdip_AddPathRectangle(pPath, x+r, y+h-r, w-(2*r), r))
      Return E
   If (E := Gdip_AddPathRectangle(pPath, x, y+r, r, h-(2*r)))
      Return E
   If (E := Gdip_AddPathRectangle(pPath, x+w-r, y+r, r, h-(2*r)))
      Return E
   If (E := Gdip_AddPathRectangle(pPath, x+r, y+r, w-(2*r), h-(2*r)))
      Return E
   If (E := Gdip_AddPathPie(pPath, x, y, 2*r, 2*r, 180, 90))
      Return E
   If (E := Gdip_AddPathPie(pPath, x+w-(2*r), y, 2*r, 2*r, 270, 90))
      Return E
   If (E := Gdip_AddPathPie(pPath, x, y+h-(2*r), 2*r, 2*r, 90, 90))
      Return E
   If (E := Gdip_AddPathPie(pPath, x+w-(2*r), y+h-(2*r), 2*r, 2*r, 0, 90))
      Return E
   Return E
}
Gdip_AddPathPolygon(pPath, Points) {
   Static Ptr := "UPtr"
   iCount := CreatePointsF(PointsF, Points)
   return DllCall("gdiplus\GdipAddPathPolygon", Ptr, pPath, Ptr, &PointsF, "int", iCount)
}
Gdip_AddPathClosedCurve(pPath, Points, Tension:=1) {
  iCount := CreatePointsF(PointsF, Points)
  If Tension
     return DllCall("gdiplus\GdipAddPathClosedCurve2", "UPtr", pPath, "UPtr", &PointsF, "int", iCount, "float", Tension)
  Else
     return DllCall("gdiplus\GdipAddPathClosedCurve", "UPtr", pPath, "UPtr", &PointsF, "int", iCount)
}
Gdip_AddPathCurve(pPath, Points, Tension:="") {
  iCount := CreatePointsF(PointsF, Points)
  If Tension
     return DllCall("gdiplus\GdipAddPathCurve2", "UPtr", pPath, "UPtr", &PointsF, "int", iCount, "float", Tension)
  Else
     return DllCall("gdiplus\GdipAddPathCurve", "UPtr", pPath, "UPtr", &PointsF, "int", iCount)
}
Gdip_AddPathToPath(pPathA, pPathB, fConnect) {
  return DllCall("gdiplus\GdipAddPathCurve2", "UPtr", pPathA, "UPtr", pPathB, "int", fConnect)
}
Gdip_AddPathStringSimplified(pPath, String, FontName, Size, Style, X, Y, Width, Height, Align:=0, NoWrap:=0) {
   FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
   If RegExMatch(FontName, "^(.\:\\.)")
   {
      hFontCollection := Gdip_NewPrivateFontCollection()
      hFontFamily := Gdip_CreateFontFamilyFromFile(FontName, hFontCollection)
   } Else hFontFamily := Gdip_FontFamilyCreate(FontName)
   If !hFontFamily
      hFontFamily := Gdip_FontFamilyCreateGeneric(1)
   If !hFontFamily
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -1
   }
   hStringFormat := Gdip_StringFormatCreate(FormatStyle)
   If !hStringFormat
      hStringFormat := Gdip_StringFormatGetGeneric(1)
   If !hStringFormat
   {
      Gdip_DeleteFontFamily(hFontFamily)
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -2
   }
   Gdip_SetStringFormatTrimming(hStringFormat, 3)
   Gdip_SetStringFormatAlign(hStringFormat, Align)
   E := Gdip_AddPathString(pPath, String, hFontFamily, Style, Size, hStringFormat, X, Y, Width, Height)
   Gdip_DeleteStringFormat(hStringFormat)
   Gdip_DeleteFontFamily(hFontFamily)
   If hFontCollection
      Gdip_DeletePrivateFontCollection(hFontCollection)
   Return E
}
Gdip_AddPathString(pPath, String, hFontFamily, Style, Size, hStringFormat, X, Y, W, H) {
   CreateRectF(RectF, X, Y, W, H)
   Return DllCall("gdiplus\GdipAddPathString", "UPtr", pPath, "WStr", String, "int", -1, "UPtr", hFontFamily, "int", Style, "float", Size, "UPtr", &RectF, "UPtr", hStringFormat)
}
Gdip_SetPathFillMode(pPath, FillMode) {
   return DllCall("gdiplus\GdipSetPathFillMode", "UPtr", pPath, "int", FillMode)
}
Gdip_GetPathFillMode(pPath) {
   result := 0
   E := DllCall("gdiplus\GdipGetPathFillMode", "UPtr", pPath, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_GetPathLastPoint(pPath, ByRef X, ByRef Y) {
   VarSetCapacity(PointF, 8, 0)
   E := DllCall("gdiplus\GdipGetPathLastPoint", "UPtr", pPath, "UPtr", &PointF)
   If !E
   {
      x := NumGet(PointF, 0, "float")
      y := NumGet(PointF, 4, "float")
   }
   Return E
}
Gdip_GetPathPointsCount(pPath) {
   result := 0
   E := DllCall("gdiplus\GdipGetPointCount", "UPtr", pPath, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_GetPathPoints(pPath) {
   PointsCount := Gdip_GetPathPointsCount(pPath)
   If (PointsCount=-1)
      Return
   VarSetCapacity(PointsF, 8 * PointsCount, 0)
   gdipLastError := DllCall("gdiplus\GdipGetPathPoints", "UPtr", pPath, "UPtr", &PointsF, "intP", PointsCount)
   Loop %PointsCount%
   {
       A := NumGet(&PointsF, 8*(A_Index-1), "float")
       B := NumGet(&PointsF, (8*(A_Index-1))+4, "float")
       printList .= A "," B "|"
   }
   Return Trim(printList, "|")
}
Gdip_FlattenPath(pPath, flatness, hMatrix:=0) {
   return DllCall("gdiplus\GdipFlattenPath", "UPtr", pPath, "UPtr", hMatrix, "float", flatness)
}
Gdip_WidenPath(pPath, pPen, hMatrix:=0, Flatness:=1) {
  return DllCall("gdiplus\GdipWidenPath", "UPtr", pPath, "UPtr", pPen, "UPtr", hMatrix, "float", Flatness)
}
Gdip_PathOutline(pPath, flatness:=1, hMatrix:=0) {
   return DllCall("gdiplus\GdipWindingModeOutline", "UPtr", pPath, "UPtr", hMatrix, "float", flatness)
}
Gdip_ResetPath(pPath) {
   Return DllCall("gdiplus\GdipResetPath", "UPtr", pPath)
}
Gdip_ReversePath(pPath) {
   Return DllCall("gdiplus\GdipReversePath", "UPtr", pPath)
}
Gdip_IsOutlineVisiblePathPoint(pGraphics, pPath, pPen, X, Y) {
   result := 0
   E := DllCall("gdiplus\GdipIsOutlineVisiblePathPoint", "UPtr", pPath, "float", X, "float", Y, "UPtr", pPen, "UPtr", pGraphics, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_IsVisiblePathPoint(pPath, x, y, pGraphics) {
  result := 0
  E := DllCall("gdiplus\GdipIsVisiblePathPoint", "UPtr", pPath, "float", x, "float", y, "UPtr", pGraphics, "UPtr*", result)
  If E
     return -1
  return result
}
Gdip_IsVisiblePathRectEntirely(pGraphics, pPath, X, Y, Width, Height) {
    a := Gdip_IsVisiblePathPoint(pPath, X, Y, pGraphics)
    b := Gdip_IsVisiblePathPoint(pPath, X + Width, Y, pGraphics)
    c := Gdip_IsVisiblePathPoint(pPath, X + Width, Y + Height, pGraphics)
    d := Gdip_IsVisiblePathPoint(pPath, X, Y + Height, pGraphics)
    If (a=1 && b=1 && c=1 && d=1)
       Return 1
    Else If (a=-1 || b=-1 || c=-1 || d=-1)
       Return -1
    Else If (a=0 && b=0 && c=0 && d=0)
       Return 0
    Else
       Return -2
}
Gdip_DeletePath(pPath) {
   If pPath
      return DllCall("gdiplus\GdipDeletePath", "UPtr", pPath)
}
Gdip_SetTextRenderingHint(pGraphics, RenderingHint) {
   If !pGraphics
      Return 2
   Return DllCall("gdiplus\GdipSetTextRenderingHint", "UPtr", pGraphics, "int", RenderingHint)
}
Gdip_SetInterpolationMode(pGraphics, InterpolationMode) {
   If !pGraphics
      Return 2
   Return DllCall("gdiplus\GdipSetInterpolationMode", "UPtr", pGraphics, "int", InterpolationMode)
}
Gdip_SetSmoothingMode(pGraphics, SmoothingMode) {
   If !pGraphics
      Return 2
   Return DllCall("gdiplus\GdipSetSmoothingMode", "UPtr", pGraphics, "int", SmoothingMode)
}
Gdip_SetCompositingMode(pGraphics, CompositingMode) {
   If !pGraphics
      Return 2
   return DllCall("gdiplus\GdipSetCompositingMode", "UPtr", pGraphics, "int", CompositingMode)
}
Gdip_SetCompositingQuality(pGraphics, CompositionQuality) {
   If !pGraphics
      Return 2
   Return DllCall("gdiplus\GdipSetCompositingQuality", "UPtr", pGraphics, "int", CompositionQuality)
}
Gdip_SetPageScale(pGraphics, Scale) {
   If !pGraphics
      Return 2
   Return DllCall("gdiplus\GdipSetPageScale", "UPtr", pGraphics, "float", Scale)
}
Gdip_SetPageUnit(pGraphics, Unit) {
   If !pGraphics
      Return 2
   Return DllCall("gdiplus\GdipSetPageUnit", "UPtr", pGraphics, "int", Unit)
}
Gdip_SetPixelOffsetMode(pGraphics, PixelOffsetMode) {
   If !pGraphics
      Return 2
   Return DllCall("gdiplus\GdipSetPixelOffsetMode", "UPtr", pGraphics, "int", PixelOffsetMode)
}
Gdip_SetRenderingOrigin(pGraphics, X, Y) {
   If !pGraphics
      Return 2
   Return DllCall("gdiplus\GdipSetRenderingOrigin", "UPtr", pGraphics, "int", X, "int", Y)
}
Gdip_SetTextContrast(pGraphics, Contrast) {
   If !pGraphics
      Return 2
   Return DllCall("gdiplus\GdipSetTextContrast", "UPtr", pGraphics, "uint", Contrast)
}
Gdip_RestoreGraphics(pGraphics, State) {
    return DllCall("Gdiplus\GdipRestoreGraphics", "UPtr", pGraphics, "UInt", State)
}
Gdip_SaveGraphics(pGraphics) {
     State := 0
     DllCall("Gdiplus\GdipSaveGraphics", "Ptr", pGraphics, "UIntP", State)
     return State
}
Gdip_GetTextContrast(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetTextContrast", Ptr, pGraphics, "uint*", result)
   If E
      return -1
   Return result
}
Gdip_GetCompositingMode(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetCompositingMode", Ptr, pGraphics, "int*", result)
   If E
      return -1
   Return result
}
Gdip_GetCompositingQuality(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetCompositingQuality", Ptr, pGraphics, "int*", result)
   If E
      return -1
   Return result
}
Gdip_GetInterpolationMode(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetInterpolationMode", Ptr, pGraphics, "int*", result)
   If E
      return -1
   Return result
}
Gdip_GetSmoothingMode(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetSmoothingMode", Ptr, pGraphics, "int*", result)
   If E
      return -1
   Return result
}
Gdip_GetPageScale(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetPageScale", Ptr, pGraphics, "float*", result)
   If E
      return -1
   Return result
}
Gdip_GetPageUnit(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetPageUnit", Ptr, pGraphics, "int*", result)
   If E
      return -1
   Return result
}
Gdip_GetPixelOffsetMode(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetPixelOffsetMode", Ptr, pGraphics, "int*", result)
   If E
      return -1
   Return result
}
Gdip_GetRenderingOrigin(pGraphics, ByRef X, ByRef Y) {
   Static Ptr := "UPtr"
   x := 0
   y := 0
   return DllCall("gdiplus\GdipGetRenderingOrigin", Ptr, pGraphics, "uint*", X, "uint*", Y)
}
Gdip_GetTextRenderingHint(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetTextRenderingHint", Ptr, pGraphics, "int*", result)
   If E
      return -1
   Return result
}
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipRotateWorldTransform", "UPtr", pGraphics, "float", Angle, "int", MatrixOrder)
}
Gdip_ScaleWorldTransform(pGraphics, ScaleX, ScaleY, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipScaleWorldTransform", "UPtr", pGraphics, "float", ScaleX, "float", ScaleY, "int", MatrixOrder)
}
Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipTranslateWorldTransform", "UPtr", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}
Gdip_MultiplyWorldTransform(pGraphics, hMatrix, matrixOrder:=0) {
   Static Ptr := "UPtr"
   Return DllCall("gdiplus\GdipMultiplyWorldTransform", Ptr, pGraphics, Ptr, hMatrix, "int", matrixOrder)
}
Gdip_ResetWorldTransform(pGraphics) {
   return DllCall("gdiplus\GdipResetWorldTransform", "UPtr", pGraphics)
}
Gdip_ResetPageTransform(pGraphics) {
   return DllCall("gdiplus\GdipResetPageTransform", "UPtr", pGraphics)
}
Gdip_SetWorldTransform(pGraphics, hMatrix) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipSetWorldTransform", Ptr, pGraphics, Ptr, hMatrix)
}
Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation) {
   pi := 3.14159, TAngle := Angle*(pi/180)
   Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
   if ((Bound >= 0) && (Bound <= 90))
      xTranslation := Height*Sin(TAngle), yTranslation := 0
   else if ((Bound > 90) && (Bound <= 180))
      xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
   else if ((Bound > 180) && (Bound <= 270))
      xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
   else if ((Bound > 270) && (Bound <= 360))
      xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}
Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight) {
   Static pi := 3.14159
   if !(Width && Height)
      return -1
   TAngle := Angle*(pi/180)
   RWidth := Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle))
   RHeight := Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle))
}
Gdip_GetRotatedEllipseDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight) {
   if !(Width && Height)
      return -1
   pPath := Gdip_CreatePath()
   Gdip_AddPathEllipse(pPath, 0, 0, Width, Height)
   pMatrix := Gdip_CreateMatrix()
   Gdip_RotateMatrix(pMatrix, Angle, MatrixOrder)
   E := Gdip_TransformPath(pPath, pMatrix)
   Gdip_DeleteMatrix(pMatrix)
   pathBounds := Gdip_GetPathWorldBounds(pPath)
   Gdip_DeletePath(pPath)
   RWidth := pathBounds.w
   RHeight := pathBounds.h
   Return E
}
Gdip_GetWorldTransform(pGraphics) {
   Static Ptr := "UPtr"
   hMatrix := 0
   gdipLastError := DllCall("gdiplus\GdipGetWorldTransform", Ptr, pGraphics, "UPtr*", hMatrix)
   Return hMatrix
}
Gdip_IsVisibleGraphPoint(pGraphics, X, Y) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipIsVisiblePoint", Ptr, pGraphics, "float", X, "float", Y, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_IsVisibleGraphRect(pGraphics, X, Y, Width, Height) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipIsVisibleRect", Ptr, pGraphics, "float", X, "float", Y, "float", Width, "float", Height, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_IsVisibleGraphRectEntirely(pGraphics, X, Y, Width, Height) {
    a := Gdip_IsVisibleGraphPoint(pGraphics, X, Y)
    b := Gdip_IsVisibleGraphPoint(pGraphics, X + Width, Y)
    c := Gdip_IsVisibleGraphPoint(pGraphics, X + Width, Y + Height)
    d := Gdip_IsVisibleGraphPoint(pGraphics, X, Y + Height)
    If (a=1 && b=1 && c=1 && d=1)
       Return 1
    Else If (a=-1 || b=-1 || c=-1 || d=-1)
       Return -1
    Else If (a=0 && b=0 && c=0 && d=0)
       Return 0
    Else
       Return -2
}
Gdip_IsClipEmpty(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipIsClipEmpty", Ptr, pGraphics, "int*", result)
   If E
      Return -1
   Return result
}
Gdip_IsVisibleClipEmpty(pGraphics) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipIsVisibleClipEmpty", Ptr, pGraphics, "uint*", result)
   If E
      Return -1
   Return result
}
Gdip_SetClipFromGraphics(pGraphics, pGraphicsSrc, CombineMode:=0) {
   return DllCall("gdiplus\GdipSetClipGraphics", "UPtr", pGraphics, "UPtr", pGraphicsSrc, "int", CombineMode)
}
Gdip_GetClipBounds(pGraphics) {
  VarSetCapacity(RectF, 16, 0)
  E := DllCall("gdiplus\GdipGetClipBounds", "UPtr", pGraphics, "UPtr", &RectF)
  If (!E) {
      rData := {}
      rData.x := NumGet(&RectF, 0, "float")
      rData.y := NumGet(&RectF, 4, "float")
      rData.w := NumGet(&RectF, 8, "float")
      rData.h := NumGet(&RectF, 12, "float")
      Return rData
  } Else {
      Return E
  }
}
Gdip_GetVisibleClipBounds(pGraphics) {
  VarSetCapacity(RectF, 16, 0)
  E := DllCall("gdiplus\GdipGetVisibleClipBounds", "UPtr", pGraphics, "UPtr", &RectF)
  If (!E) {
      rData := {}
      rData.x := NumGet(&RectF, 0, "float")
      rData.y := NumGet(&RectF, 4, "float")
      rData.w := NumGet(&RectF, 8, "float")
      rData.h := NumGet(&RectF, 12, "float")
      Return rData
  } Else {
      Return E
  }
}
Gdip_TranslateClip(pGraphics, dX, dY) {
   return DllCall("gdiplus\GdipTranslateClip", "UPtr", pGraphics, "float", dX, "float", dY)
}
Gdip_ResetClip(pGraphics) {
   return DllCall("gdiplus\GdipResetClip", "UPtr", pGraphics)
}
Gdip_GetClipRegion(pGraphics) {
   hRegion := Gdip_CreateRegion()
   gdipLastError := DllCall("gdiplus\GdipGetClip", "UPtr", pGraphics, "UPtr", hRegion)
   return hRegion
}
Gdip_SetClipRegion(pGraphics, hRegion, CombineMode:=0) {
   return DllCall("gdiplus\GdipSetClipRegion", "UPtr", pGraphics, "UPtr", hRegion, "int", CombineMode)
}
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode:=0) {
   return DllCall("gdiplus\GdipSetClipRect", "UPtr", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}
Gdip_SetClipPath(pGraphics, pPath, CombineMode:=0) {
   return DllCall("gdiplus\GdipSetClipPath", "UPtr", pGraphics, "UPtr", pPath, "int", CombineMode)
}
Gdip_CreateRegion() {
   hRegion := 0
   gdipLastError := DllCall("gdiplus\GdipCreateRegion", "UPtr*", hRegion)
   return hRegion
}
Gdip_CombineRegionRegion(hRegion1, hRegion2, CombineMode) {
   return DllCall("gdiplus\GdipCombineRegionRegion", "UPtr", hRegion1, "UPtr", hRegion2, "int", CombineMode)
}
Gdip_CombineRegionRect(hRegion, x, y, w, h, CombineMode) {
   CreateRectF(RectF, x, y, w, h)
   return DllCall("gdiplus\GdipCombineRegionRect", "UPtr", hRegion, "UPtr", &RectF, "int", CombineMode)
}
Gdip_CombineRegionPath(hRegion, pPath, CombineMode) {
   return DllCall("gdiplus\GdipCombineRegionPath", "UPtr", hRegion, "UPtr", pPath, "int", CombineMode)
}
Gdip_CreateRegionPath(pPath) {
   hRegion := 0
   gdipLastError := DllCall("gdiplus\GdipCreateRegionPath", "UPtr", pPath, "UPtr*", hRegion)
   return hRegion
}
Gdip_CreateRegionRect(x, y, w, h) {
   hRegion := 0
   CreateRectF(RectF, x, y, w, h)
   gdipLastError := DllCall("gdiplus\GdipCreateRegionRect", "UPtr", &RectF, "UPtr*", hRegion)
   return hRegion
}
Gdip_IsEmptyRegion(pGraphics, hRegion) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipIsEmptyRegion", "UPtr", hRegion, "UPtr", pGraphics, "uInt*", result)
   Return result
}
Gdip_IsEqualRegion(pGraphics, hRegion1, hRegion2) {
   result := 0
   gdipLastError := DllCall("gdiplus\GdipIsEqualRegion", "UPtr", hRegion1, "UPtr", hRegion2, "UPtr", pGraphics, "uInt*", result)
   Return result
}
Gdip_IsInfiniteRegion(pGraphics, hRegion) {
   result := 0
   E := DllCall("gdiplus\GdipIsInfiniteRegion", "UPtr", hRegion, "UPtr", pGraphics, "uInt*", result)
   If E
      return -1
   Return result
}
Gdip_IsVisibleRegionPoint(pGraphics, hRegion, x, y) {
   result := 0
   E := DllCall("gdiplus\GdipIsVisibleRegionPoint", "UPtr", hRegion, "float", X, "float", Y, "UPtr", pGraphics, "uInt*", result)
   If E
      return -1
   Return result
}
Gdip_IsVisibleRegionRect(pGraphics, hRegion, x, y, width, height) {
   result := 0
   E := DllCall("gdiplus\GdipIsVisibleRegionRect", "UPtr", hRegion, "float", X, "float", Y, "float", Width, "float", Height, Ptr, pGraphics, "uInt*", result)
   If E
      return -1
   Return result
}
Gdip_IsVisibleRegionRectEntirely(pGraphics, hRegion, X, Y, Width, Height) {
    a := Gdip_IsVisibleRegionPoint(pGraphics, hRegion, X, Y)
    b := Gdip_IsVisibleRegionPoint(pGraphics, hRegion, X + Width, Y)
    c := Gdip_IsVisibleRegionPoint(pGraphics, hRegion, X + Width, Y + Height)
    d := Gdip_IsVisibleRegionPoint(pGraphics, hRegion, X, Y + Height)
    If (a=1 && b=1 && c=1 && d=1)
       Return 1
    Else If (a=-1 || b=-1 || c=-1 || d=-1)
       Return -1
    Else If (a=0 && b=0 && c=0 && d=0)
       Return 0
    Else
       Return -2
}
Gdip_SetEmptyRegion(hRegion) {
   return DllCall("gdiplus\GdipSetEmpty", "UPtr", hRegion)
}
Gdip_SetInfiniteRegion(hRegion) {
   return DllCall("gdiplus\GdipSetInfinite", "UPtr", hRegion)
}
Gdip_GetRegionBounds(pGraphics, hRegion) {
  VarSetCapacity(RectF, 16, 0)
  E := DllCall("gdiplus\GdipGetRegionBounds", "UPtr", hRegion, "UPtr", pGraphics, "UPtr", &RectF)
  If (!E) {
      rData := {}
      rData.x := NumGet(&RectF, 0, "float")
      rData.y := NumGet(&RectF, 4, "float")
      rData.w := NumGet(&RectF, 8, "float")
      rData.h := NumGet(&RectF, 12, "float")
      Return rData
  } Else {
      Return E
  }
}
Gdip_TranslateRegion(hRegion, X, Y) {
   return DllCall("gdiplus\GdipTranslateRegion", "UPtr", hRegion, "float", X, "float", Y)
}
Gdip_RotateRegionAtCenter(pGraphics, Region, Angle, MatrixOrder:=1) {
  Rect := Gdip_GetRegionBounds(pGraphics, Region)
  cX := Rect.x + (Rect.w / 2)
  cY := Rect.y + (Rect.h / 2)
  pMatrix := Gdip_CreateMatrix()
  Gdip_TranslateMatrix(pMatrix, -cX , -cY)
  Gdip_RotateMatrix(pMatrix, Angle, MatrixOrder)
  Gdip_TranslateMatrix(pMatrix, cX, cY, MatrixOrder)
  E := Gdip_TransformRegion(Region, pMatrix)
  Gdip_DeleteMatrix(pMatrix)
  Return E
}
Gdip_TransformRegion(Region, pMatrix) {
  return DllCall("gdiplus\GdipTransformRegion", "UPtr", Region, "UPtr", pMatrix)
}
Gdip_CloneRegion(Region) {
   newRegion := 0
   gdipLastError := DllCall("gdiplus\GdipCloneRegion", "UPtr", Region, "UInt*", newRegion)
   return newRegion
}
Gdip_LockBits(pBitmap, x, y, w, h, ByRef Stride, ByRef Scan0, ByRef BitmapData, LockMode := 3, PixelFormat := 0x26200a) {
   CreateRect(Rect, x, y, w, h)
   VarSetCapacity(BitmapData, 16+2*A_PtrSize, 0)
   _E := DllCall("Gdiplus\GdipBitmapLockBits", "UPtr", pBitmap, "UPtr", &Rect, "uint", LockMode, "int", PixelFormat, "UPtr", &BitmapData)
   Stride := NumGet(BitmapData, 8, "Int")
   Scan0 := NumGet(BitmapData, 16, "UPtr")
   return _E
}
Gdip_UnlockBits(pBitmap, ByRef BitmapData) {
   return DllCall("Gdiplus\GdipBitmapUnlockBits", "UPtr", pBitmap, "UPtr", &BitmapData)
}
Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride) {
   NumPut(ARGB, Scan0+0, (x*4)+(y*Stride), "UInt")
}
Gdip_GetLockBitPixel(Scan0, x, y, Stride) {
   return NumGet(Scan0+0, (x*4)+(y*Stride), "UInt")
}
Gdip_PixelateBitmap(pBitmap, ByRef pBitmapOut, BlockSize) {
   static PixelateBitmap
   Static Ptr := "UPtr"
   if (!PixelateBitmap)
   {
      if (A_PtrSize!=8)
      MCode_PixelateBitmap := "
      (LTrim Join
      558BEC83EC3C8B4514538B5D1C99F7FB56578BC88955EC894DD885C90F8E830200008B451099F7FB8365DC008365E000894DC88955F08945E833FF897DD4
      397DE80F8E160100008BCB0FAFCB894DCC33C08945F88945FC89451C8945143BD87E608B45088D50028BC82BCA8BF02BF2418945F48B45E02955F4894DC4
      8D0CB80FAFCB03CA895DD08BD1895DE40FB64416030145140FB60201451C8B45C40FB604100145FC8B45F40FB604020145F883C204FF4DE475D6034D18FF
      4DD075C98B4DCC8B451499F7F98945148B451C99F7F989451C8B45FC99F7F98945FC8B45F899F7F98945F885DB7E648B450C8D50028BC82BCA83C103894D
      C48BC82BCA41894DF48B4DD48945E48B45E02955E48D0C880FAFCB03CA895DD08BD18BF38A45148B7DC48804178A451C8B7DF488028A45FC8804178A45F8
      8B7DE488043A83C2044E75DA034D18FF4DD075CE8B4DCC8B7DD447897DD43B7DE80F8CF2FEFFFF837DF0000F842C01000033C08945F88945FC89451C8945
      148945E43BD87E65837DF0007E578B4DDC034DE48B75E80FAF4D180FAFF38B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945CC0F
      B6440E030145140FB60101451C0FB6440F010145FC8B45F40FB604010145F883C104FF4DCC75D8FF45E4395DE47C9B8B4DF00FAFCB85C9740B8B451499F7
      F9894514EB048365140033F63BCE740B8B451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB
      038975F88975E43BDE7E5A837DF0007E4C8B4DDC034DE48B75E80FAF4D180FAFF38B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955CC8A55
      1488540E038A551C88118A55FC88540F018A55F888140183C104FF4DCC75DFFF45E4395DE47CA68B45180145E0015DDCFF4DC80F8594FDFFFF8B451099F7
      FB8955F08945E885C00F8E450100008B45EC0FAFC38365DC008945D48B45E88945CC33C08945F88945FC89451C8945148945103945EC7E6085DB7E518B4D
      D88B45080FAFCB034D108D50020FAF4D18034DDC8BF08BF88945F403CA2BF22BFA2955F4895DC80FB6440E030145140FB60101451C0FB6440F010145FC8B
      45F40FB604080145F883C104FF4DC875D8FF45108B45103B45EC7CA08B4DD485C9740B8B451499F7F9894514EB048365140033F63BCE740B8B451C99F7F9
      89451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975103975EC7E5585DB7E468B4DD88B450C
      0FAFCB034D108D50020FAF4D18034DDC8BF08BF803CA2BF22BFA2BC2895DC88A551488540E038A551C88118A55FC88540F018A55F888140183C104FF4DC8
      75DFFF45108B45103B45EC7CAB8BC3C1E0020145DCFF4DCC0F85CEFEFFFF8B4DEC33C08945F88945FC89451C8945148945103BC87E6C3945F07E5C8B4DD8
      8B75E80FAFCB034D100FAFF30FAF4D188B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945C80FB6440E030145140FB60101451C0F
      B6440F010145FC8B45F40FB604010145F883C104FF4DC875D833C0FF45108B4DEC394D107C940FAF4DF03BC874068B451499F7F933F68945143BCE740B8B
      451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975083975EC7E63EB0233F639
      75F07E4F8B4DD88B75E80FAFCB034D080FAFF30FAF4D188B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955108A551488540E038A551C8811
      8A55FC88540F018A55F888140883C104FF4D1075DFFF45088B45083B45EC7C9F5F5E33C05BC9C21800
      )"
      else
      MCode_PixelateBitmap := "
      (LTrim Join
      4489442418488954241048894C24085355565741544155415641574883EC28418BC1448B8C24980000004C8BDA99488BD941F7F9448BD0448BFA8954240C
      448994248800000085C00F8E9D020000418BC04533E4458BF299448924244C8954241041F7F933C9898C24980000008BEA89542404448BE889442408EB05
      4C8B5C24784585ED0F8E1A010000458BF1418BFD48897C2418450FAFF14533D233F633ED4533E44533ED4585C97E5B4C63BC2490000000418D040A410FAF
      C148984C8D441802498BD9498BD04D8BD90FB642010FB64AFF4403E80FB60203E90FB64AFE4883C2044403E003F149FFCB75DE4D03C748FFCB75D0488B7C
      24188B8C24980000004C8B5C2478418BC59941F7FE448BE8418BC49941F7FE448BE08BC59941F7FE8BE88BC69941F7FE8BF04585C97E4048639C24900000
      004103CA4D8BC1410FAFC94863C94A8D541902488BCA498BC144886901448821408869FF408871FE4883C10448FFC875E84803D349FFC875DA8B8C249800
      0000488B5C24704C8B5C24784183C20448FFCF48897C24180F850AFFFFFF8B6C2404448B2424448B6C24084C8B74241085ED0F840A01000033FF33DB4533
      DB4533D24533C04585C97E53488B74247085ED7E42438D0C04418BC50FAF8C2490000000410FAFC18D04814863C8488D5431028BCD0FB642014403D00FB6
      024883C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC17CB28BCD410FAFC985C9740A418BC299F7F98BF0EB0233F685C9740B418BC3
      99F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585C97E4D4C8B74247885ED7E3841
      8D0C14418BC50FAF8C2490000000410FAFC18D04814863C84A8D4431028BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2413BD17CBD
      4C8B7424108B8C2498000000038C2490000000488B5C24704503E149FFCE44892424898C24980000004C897424100F859EFDFFFF448B7C240C448B842480
      000000418BC09941F7F98BE8448BEA89942498000000896C240C85C00F8E3B010000448BAC2488000000418BCF448BF5410FAFC9898C248000000033FF33
      ED33F64533DB4533D24533C04585FF7E524585C97E40418BC5410FAFC14103C00FAF84249000000003C74898488D541802498BD90FB642014403D00FB602
      4883C2044403D80FB642FB03F00FB642FA03E848FFCB75DE488B5C247041FFC0453BC77CAE85C9740B418BC299F7F9448BE0EB034533E485C9740A418BC3
      99F7F98BD8EB0233DB85C9740A8BC699F7F9448BD8EB034533DB85C9740A8BC599F7F9448BD0EB034533D24533C04585FF7E4E488B4C24784585C97E3541
      8BC5410FAFC14103C00FAF84249000000003C74898488D540802498BC144886201881A44885AFF448852FE4883C20448FFC875E941FFC0453BC77CBE8B8C
      2480000000488B5C2470418BC1C1E00203F849FFCE0F85ECFEFFFF448BAC24980000008B6C240C448BA4248800000033FF33DB4533DB4533D24533C04585
      FF7E5A488B7424704585ED7E48418BCC8BC5410FAFC94103C80FAF8C2490000000410FAFC18D04814863C8488D543102418BCD0FB642014403D00FB60248
      83C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC77CAB418BCF410FAFCD85C9740A418BC299F7F98BF0EB0233F685C9740B418BC399
      F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585FF7E4E4585ED7E42418BCC8BC541
      0FAFC903CA0FAF8C2490000000410FAFC18D04814863C8488B442478488D440102418BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2
      413BD77CB233C04883C428415F415E415D415C5F5E5D5BC3
      )"
      VarSetCapacity(PixelateBitmap, StrLen(MCode_PixelateBitmap)//2)
      nCount := StrLen(MCode_PixelateBitmap)//2
      N := (A_AhkVersion < 2) ? nCount : "nCount"
      Loop %N%
         NumPut("0x" SubStr(MCode_PixelateBitmap, (2*A_Index)-1, 2), PixelateBitmap, A_Index-1, "UChar")
      DllCall("VirtualProtect", Ptr, &PixelateBitmap, Ptr, VarSetCapacity(PixelateBitmap), "uint", 0x40, "UPtr*", 0)
   }
   Gdip_GetImageDimensions(pBitmap, Width, Height)
   if (Width != Gdip_GetImageWidth(pBitmapOut) || Height != Gdip_GetImageHeight(pBitmapOut))
      return -1
   if (BlockSize > Width || BlockSize > Height)
      return -2
   E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, Stride1, Scan01, BitmapData1)
   E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, Stride2, Scan02, BitmapData2)
   if (!E1 && !E2)
      DllCall(&PixelateBitmap, Ptr, Scan01, Ptr, Scan02, "int", Width, "int", Height, "int", Stride1, "int", BlockSize)
   If !E1
      Gdip_UnlockBits(pBitmap, BitmapData1)
   If !E2
      Gdip_UnlockBits(pBitmapOut, BitmapData2)
   return 0
}
Gdip_ToARGB(A, R, G, B) {
   return (A << 24) | (R << 16) | (G << 8) | B
}
Gdip_FromARGB(ARGB, ByRef A, ByRef R, ByRef G, ByRef B) {
   A := (0xff000000 & ARGB) >> 24
   R := (0x00ff0000 & ARGB) >> 16
   G := (0x0000ff00 & ARGB) >> 8
   B := 0x000000ff & ARGB
}
Gdip_AFromARGB(ARGB) {
   return (0xff000000 & ARGB) >> 24
}
Gdip_RFromARGB(ARGB) {
   return (0x00ff0000 & ARGB) >> 16
}
Gdip_GFromARGB(ARGB) {
   return (0x0000ff00 & ARGB) >> 8
}
Gdip_BFromARGB(ARGB) {
   return 0x000000ff & ARGB
}
StrGetB(Address, Length:=-1, Encoding:=0) {
   if !IsInteger(Length)
      Encoding := Length,  Length := -1
   if (Address+0 < 1024)
      return
   if (Encoding = "UTF-16")
      Encoding := 1200
   else if (Encoding = "UTF-8")
      Encoding := 65001
   else if SubStr(Encoding,1,2)="CP"
      Encoding := SubStr(Encoding,3)
   if !Encoding ; "" or 0
   {
      if (Length == -1)
         Length := DllCall("lstrlen", "uint", Address)
      VarSetCapacity(String, Length)
      DllCall("lstrcpyn", "str", String, "uint", Address, "int", Length + 1)
   }
   else if (Encoding = 1200)
   {
      char_count := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "uint", 0, "uint", 0, "uint", 0, "uint", 0)
      VarSetCapacity(String, char_count)
      DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "str", String, "int", char_count, "uint", 0, "uint", 0)
   }
   else if IsInteger(Encoding)
   {
      char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", 0, "int", 0)
      VarSetCapacity(String, char_count * 2)
      char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", &String, "int", char_count * 2)
      String := StrGetB(&String, char_count, 1200)
   }
   return String
}
Gdip_Startup(multipleInstances:=0) {
   pToken := 0
   If (multipleInstances=0)
   {
      if !DllCall("GetModuleHandle", "str", "gdiplus", "UPtr")
         DllCall("LoadLibrary", "str", "gdiplus")
   } Else DllCall("LoadLibrary", "str", "gdiplus")
   VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
   DllCall("gdiplus\GdiplusStartup", "UPtr*", pToken, "UPtr", &si, "UPtr", 0)
   return pToken
}
Gdip_Shutdown(pToken) {
   DllCall("gdiplus\GdiplusShutdown", "UPtr", pToken)
   hModule := DllCall("GetModuleHandle", "Str", "gdiplus", "UPtr")
   if hModule
      DllCall("FreeLibrary", "UPtr", hModule)
   return 0
}
IsInteger(Var) {
   Static Integer := "Integer"
   If Var Is Integer
      Return True
   Return False
}
IsNumber(Var) {
   Static number := "number"
   If Var Is number
      Return True
   Return False
}
GetMonitorCount() {
   Monitors := MDMF_Enum()
   for k,v in Monitors
      count := A_Index
   return count
}
GetMonitorInfo(MonitorNum) {
   Monitors := MDMF_Enum()
   for k,v in Monitors
   {
      if (v.Num = MonitorNum)
         return v
   }
}
GetPrimaryMonitor() {
   Monitors := MDMF_Enum()
   for k,v in Monitors
   {
      If (v.Primary)
         return v.Num
   }
}
MDMF_Enum(HMON := "") {
   Static CallbackFunc := Func(A_AhkVersion < "2" ? "RegisterCallback" : "CallbackCreate")
   Static EnumProc := CallbackFunc.Call("MDMF_EnumProc")
   Static Obj := (A_AhkVersion < "2") ? "Object" : "Map"
   Static Monitors := {}
   If (HMON = "")
   {
      Monitors := %Obj%("TotalCount", 0)
      If !DllCall("User32.dll\EnumDisplayMonitors", "Ptr", 0, "Ptr", 0, "Ptr", EnumProc, "Ptr", &Monitors, "Int")
         Return False
   }
   Return (HMON = "") ? Monitors : Monitors.HasKey(HMON) ? Monitors[HMON] : False
}
MDMF_EnumProc(HMON, HDC, PRECT, ObjectAddr) {
   Monitors := Object(ObjectAddr)
   Monitors[HMON] := MDMF_GetInfo(HMON)
   Monitors["TotalCount"]++
   If (Monitors[HMON].Primary)
      Monitors["Primary"] := HMON
   Return True
}
MDMF_FromHWND(HWND, Flag := 0) {
   Return DllCall("User32.dll\MonitorFromWindow", "Ptr", HWND, "UInt", Flag, "Ptr")
}
MDMF_FromPoint(ByRef X := "", ByRef Y := "", Flag := 0) {
   If (X = "") || (Y = "") {
      VarSetCapacity(PT, 8, 0)
      DllCall("User32.dll\GetCursorPos", "Ptr", &PT, "Int")
      If (X = "")
         X := NumGet(PT, 0, "Int")
      If (Y = "")
         Y := NumGet(PT, 4, "Int")
   }
   Return DllCall("User32.dll\MonitorFromPoint", "Int64", (X & 0xFFFFFFFF) | (Y << 32), "UInt", Flag, "Ptr")
}
MDMF_FromRect(X, Y, W, H, Flag := 0) {
   VarSetCapacity(RC, 16, 0)
   NumPut(X, RC, 0, "Int"), NumPut(Y, RC, 4, "Int"), NumPut(X + W, RC, 8, "Int"), NumPut(Y + H, RC, 12, "Int")
   Return DllCall("User32.dll\MonitorFromRect", "Ptr", &RC, "UInt", Flag, "Ptr")
}
MDMF_GetInfo(HMON) {
   NumPut(VarSetCapacity(MIEX, 40 + (32 << !!A_IsUnicode)), MIEX, 0, "UInt")
   If DllCall("User32.dll\GetMonitorInfo", "Ptr", HMON, "Ptr", &MIEX, "Int")
      Return {Name:      (Name := StrGet(&MIEX + 40, 32))
            , Num:       RegExReplace(Name, ".*(\d+)$", "$1")
            , Left:      NumGet(MIEX, 4, "Int")
            , Top:       NumGet(MIEX, 8, "Int")
            , Right:     NumGet(MIEX, 12, "Int")
            , Bottom:    NumGet(MIEX, 16, "Int")
            , WALeft:    NumGet(MIEX, 20, "Int")
            , WATop:     NumGet(MIEX, 24, "Int")
            , WARight:   NumGet(MIEX, 28, "Int")
            , WABottom:  NumGet(MIEX, 32, "Int")
            , Primary:   NumGet(MIEX, 36, "UInt")} 
   Return False
}
Gdip_LoadImageFromFile(sFile, useICM:=0) {
   pImage := 0
   function2call := (useICM=1) ? "ICM" : ""
   gdipLastError := DllCall("gdiplus\GdipLoadImageFromFile" function2call, "WStr", sFile, "UPtrP", pImage)
   Return pImage
}
Gdip_GetPropertyCount(pImage) {
   PropCount := 0
   gdipLastError := DllCall("gdiplus\GdipGetPropertyCount", "UPtr", pImage, "UIntP", PropCount)
   Return PropCount
}
Gdip_GetPropertyIdList(pImage) {
   PropNum := Gdip_GetPropertyCount(pImage)
   If !PropNum
      Return False
   VarSetCapacity(PropIDList, 4 * PropNum, 0)
   R := DllCall("gdiplus\GdipGetPropertyIdList", "UPtr", pImage, "UInt", PropNum, "Ptr", &PropIDList)
   If (R) {
      ErrorLevel := R
      Return False
   }
   PropArray := {Count: PropNum}
   Loop %PropNum%
   {
      PropID := NumGet(PropIDList, (A_Index - 1) << 2, "UInt")
      PropArray[PropID] := Gdip_GetPropertyTagName(PropID)
   }
   Return PropArray
}
Gdip_GetPropertyItem(pImage, PropID) {
   PropItem := {Length: 0, Type: 0, Value: ""}
   ItemSize := 0
   R := DllCall("gdiplus\GdipGetPropertyItemSize", "Ptr", pImage, "UInt", PropID, "UIntP", ItemSize)
   If (R) {
      ErrorLevel := R
      Return False
   }
   Static Ptr := "UPtr"
   VarSetCapacity(Item, ItemSize, 0)
   R := DllCall("gdiplus\GdipGetPropertyItem", Ptr, pImage, "UInt", PropID, "UInt", ItemSize, "Ptr", &Item)
   If (R) {
      ErrorLevel := R
      Return False
   }
   PropLen := NumGet(Item, 4, "UInt")
   PropType := NumGet(Item, 8, "Short")
   PropAddr := NumGet(Item, 8 + A_PtrSize, "UPtr")
   PropItem.Length := PropLen
   PropItem.Type := PropType
   If (PropLen > 0)
   {
      PropVal := ""
      Gdip_GetPropertyItemValue(PropVal, PropLen, PropType, PropAddr)
      If (PropType = 1) || (PropType = 7) {
         PropItem.SetCapacity("Value", PropLen)
         ValAddr := PropItem.GetAddress("Value")
         DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", ValAddr, "Ptr", &PropVal, "Ptr", PropLen)
      } Else {
         PropItem.Value := PropVal
      }
   }
   ErrorLevel := 0
   Return PropItem
}
Gdip_GetAllPropertyItems(pImage) {
   BufSize := PropNum := ErrorLevel := 0
   R := DllCall("gdiplus\GdipGetPropertySize", "Ptr", pImage, "UIntP", BufSize, "UIntP", PropNum)
   If (R) || (PropNum = 0) {
      ErrorLevel := R ? R : 19
      Return False
   }
   VarSetCapacity(Buffer, BufSize, 0)
   Static Ptr := "UPtr"
   R := DllCall("gdiplus\GdipGetAllPropertyItems", Ptr, pImage, "UInt", BufSize, "UInt", PropNum, "Ptr", &Buffer)
   If (R) {
      ErrorLevel := R
      Return False
   }
   PropsObj := {Count: PropNum}
   PropSize := 8 + (2 * A_PtrSize)
   Loop %PropNum%
	   {
		  OffSet := PropSize * (A_Index - 1)
		  PropID := NumGet(Buffer, OffSet, "UInt")
		  PropLen := NumGet(Buffer, OffSet + 4, "UInt")
		  PropType := NumGet(Buffer, OffSet + 8, "Short")
		  PropAddr := NumGet(Buffer, OffSet + 8 + A_PtrSize, "UPtr")
		  PropVal := ""
		  PropsObj[PropID] := {}
		  PropsObj[PropID, "Length"] := PropLen
		  PropsObj[PropID, "Type"] := PropType
		  PropsObj[PropID, "Value"] := PropVal
		  If (PropLen > 0)
			  {
				 Gdip_GetPropertyItemValue(PropVal, PropLen, PropType, PropAddr)
				 If (PropType = 1) || (PropType = 7)
					 {
						PropsObj[PropID].SetCapacity("Value", PropLen)
						ValAddr := PropsObj[PropID].GetAddress("Value")
						DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", ValAddr, "Ptr", PropAddr, "Ptr", PropLen)
					 } Else {
						PropsObj[PropID].Value := PropVal
					 }
				}
	   }
   ErrorLevel := 0
   Return PropsObj
}
Gdip_GetPropertyTagName(PropID) {
   Static PropTagsA := {0x0001:"GPS LatitudeRef",0x0002:"GPS Latitude",0x0003:"GPS LongitudeRef",0x0004:"GPS Longitude",0x0005:"GPS AltitudeRef",0x0006:"GPS Altitude",0x0007:"GPS Time",0x0008:"GPS Satellites",0x0009:"GPS Status",0x000A:"GPS MeasureMode",0x001D:"GPS Date",0x001E:"GPS Differential",0x00FE:"NewSubfileType",0x00FF:"SubfileType",0x0102:"Bits Per Sample",0x0103:"Compression",0x0106:"Photometric Interpolation",0x0107:"ThreshHolding",0x010A:"Fill Order",0x010D:"Document Name",0x010E:"Image Description",0x010F:"Equipment Make",0x0110:"Equipment Model",0x0112:"Orientation",0x0115:"Samples Per Pixel",0x0118:"Min Sample Value",0x0119:"Max Sample Value",0x011D:"Page Name",0x0122:"GrayResponseUnit",0x0123:"GrayResponseCurve",0x0128:"Resolution Unit",0x012D:"Transfer Function",0x0131:"Software Used",0x0132:"Internal Date Time",0x013B:"Artist"
   ,0x013C:"Host Computer",0x013D:"Predictor",0x013E:"White Point",0x013F:"Primary Chromaticities",0x0140:"Color Map",0x014C:"Ink Set",0x014D:"Ink Names",0x014E:"Number Of Inks",0x0150:"Dot Range",0x0151:"Target Printer",0x0152:"Extra Samples",0x0153:"Sample Format",0x0156:"Transfer Range",0x0200:"JPEGProc",0x0205:"JPEGLosslessPredictors",0x0301:"Gamma",0x0302:"ICC Profile Descriptor",0x0303:"SRGB Rendering Intent",0x0320:"Image Title",0x5010:"JPEG Quality",0x5011:"Grid Size",0x501A:"Color Transfer Function",0x5100:"Frame Delay",0x5101:"Loop Count",0x5110:"Pixel Unit",0x5111:"Pixel Per Unit X",0x5112:"Pixel Per Unit Y",0x8298:"Copyright",0x829A:"EXIF Exposure Time",0x829D:"EXIF F Number",0x8773:"ICC Profile",0x8822:"EXIF ExposureProg",0x8824:"EXIF SpectralSense",0x8827:"EXIF ISO Speed",0x9003:"EXIF Date Original",0x9004:"EXIF Date Digitized"
   ,0x9102:"EXIF CompBPP",0x9201:"EXIF Shutter Speed",0x9202:"EXIF Aperture",0x9203:"EXIF Brightness",0x9204:"EXIF Exposure Bias",0x9205:"EXIF Max. Aperture",0x9206:"EXIF Subject Dist",0x9207:"EXIF Metering Mode",0x9208:"EXIF Light Source",0x9209:"EXIF Flash",0x920A:"EXIF Focal Length",0x9214:"EXIF Subject Area",0x927C:"EXIF Maker Note",0x9286:"EXIF Comments",0xA001:"EXIF Color Space",0xA002:"EXIF PixXDim",0xA003:"EXIF PixYDim",0xA004:"EXIF Related WAV",0xA005:"EXIF Interop",0xA20B:"EXIF Flash Energy",0xA20E:"EXIF Focal X Res",0xA20F:"EXIF Focal Y Res",0xA210:"EXIF FocalResUnit",0xA214:"EXIF Subject Loc",0xA215:"EXIF Exposure Index",0xA217:"EXIF Sensing Method",0xA300:"EXIF File Source",0xA301:"EXIF Scene Type",0xA401:"EXIF Custom Rendered",0xA402:"EXIF Exposure Mode",0xA403:"EXIF White Balance",0xA404:"EXIF Digital Zoom Ratio"
   ,0xA405:"EXIF Focal Length In 35mm Film",0xA406:"EXIF Scene Capture Type",0xA407:"EXIF Gain Control",0xA408:"EXIF Contrast",0xA409:"EXIF Saturation",0xA40A:"EXIF Sharpness",0xA40B:"EXIF Device Setting Description",0xA40C:"EXIF Subject Distance Range",0xA420:"EXIF Unique Image ID"}
   Static PropTagsB := {0x0000:"GpsVer",0x000B:"GpsGpsDop",0x000C:"GpsSpeedRef",0x000D:"GpsSpeed",0x000E:"GpsTrackRef",0x000F:"GpsTrack",0x0010:"GpsImgDirRef",0x0011:"GpsImgDir",0x0012:"GpsMapDatum",0x0013:"GpsDestLatRef",0x0014:"GpsDestLat",0x0015:"GpsDestLongRef",0x0016:"GpsDestLong",0x0017:"GpsDestBearRef",0x0018:"GpsDestBear",0x0019:"GpsDestDistRef",0x001A:"GpsDestDist",0x001B:"GpsProcessingMethod",0x001C:"GpsAreaInformation",0x0100:"Original Image Width",0x0101:"Original Image Height",0x0108:"CellWidth",0x0109:"CellHeight",0x0111:"Strip Offsets",0x0116:"RowsPerStrip",0x0117:"StripBytesCount",0x011A:"XResolution",0x011B:"YResolution",0x011C:"Planar Config",0x011E:"XPosition",0x011F:"YPosition",0x0120:"FreeOffset",0x0121:"FreeByteCounts",0x0124:"T4Option",0x0125:"T6Option",0x0129:"PageNumber",0x0141:"Halftone Hints",0x0142:"TileWidth",0x0143:"TileLength",0x0144:"TileOffset"
   ,0x0145:"TileByteCounts",0x0154:"SMin Sample Value",0x0155:"SMax Sample Value",0x0201:"JPEGInterFormat",0x0202:"JPEGInterLength",0x0203:"JPEGRestartInterval",0x0206:"JPEGPointTransforms",0x0207:"JPEGQTables",0x0208:"JPEGDCTables",0x0209:"JPEGACTables",0x0211:"YCbCrCoefficients",0x0212:"YCbCrSubsampling",0x0213:"YCbCrPositioning",0x0214:"REFBlackWhite",0x5001:"ResolutionXUnit",0x5002:"ResolutionYUnit",0x5003:"ResolutionXLengthUnit",0x5004:"ResolutionYLengthUnit",0x5005:"PrintFlags",0x5006:"PrintFlagsVersion",0x5007:"PrintFlagsCrop",0x5008:"PrintFlagsBleedWidth",0x5009:"PrintFlagsBleedWidthScale",0x500A:"HalftoneLPI",0x500B:"HalftoneLPIUnit",0x500C:"HalftoneDegree",0x500D:"HalftoneShape",0x500E:"HalftoneMisc",0x500F:"HalftoneScreen",0x5012:"ThumbnailFormat",0x5013:"ThumbnailWidth",0x5014:"ThumbnailHeight",0x5015:"ThumbnailColorDepth"
   ,0x5016:"ThumbnailPlanes",0x5017:"ThumbnailRawBytes",0x5018:"ThumbnailSize",0x5019:"ThumbnailCompressedSize",0x501B:"ThumbnailData",0x5020:"ThumbnailImageWidth",0x5021:"ThumbnailImageHeight",0x5022:"ThumbnailBitsPerSample",0x5023:"ThumbnailCompression",0x5024:"ThumbnailPhotometricInterp",0x5025:"ThumbnailImageDescription",0x5026:"ThumbnailEquipMake",0x5027:"ThumbnailEquipModel",0x5028:"ThumbnailStripOffsets",0x5029:"ThumbnailOrientation",0x502A:"ThumbnailSamplesPerPixel",0x502B:"ThumbnailRowsPerStrip",0x502C:"ThumbnailStripBytesCount",0x502D:"ThumbnailResolutionX",0x502E:"ThumbnailResolutionY",0x502F:"ThumbnailPlanarConfig",0x5030:"ThumbnailResolutionUnit",0x5031:"ThumbnailTransferFunction",0x5032:"ThumbnailSoftwareUsed",0x5033:"ThumbnailDateTime",0x5034:"ThumbnailArtist",0x5035:"ThumbnailWhitePoint"
   ,0x5036:"ThumbnailPrimaryChromaticities",0x5037:"ThumbnailYCbCrCoefficients",0x5038:"ThumbnailYCbCrSubsampling",0x5039:"ThumbnailYCbCrPositioning",0x503A:"ThumbnailRefBlackWhite",0x503B:"ThumbnailCopyRight",0x5090:"LuminanceTable",0x5091:"ChrominanceTable",0x5102:"Global Palette",0x5103:"Index Background",0x5104:"Index Transparent",0x5113:"Palette Histogram",0x8769:"ExifIFD",0x8825:"GpsIFD",0x8828:"ExifOECF",0x9000:"ExifVer",0x9101:"EXIF CompConfig",0x9290:"EXIF DTSubsec",0x9291:"EXIF DTOrigSS",0x9292:"EXIF DTDigSS",0xA000:"EXIF FPXVer",0xA20C:"EXIF Spatial FR",0xA302:"EXIF CfaPattern"}
   r := PropTagsA.HasKey(PropID) ? PropTagsA[PropID] : "Unknown"
   If (r="Unknown")
      r := PropTagsB.HasKey(PropID) ? PropTagsB[PropID] : "Unknown"
   Return r
}
Gdip_GetPropertyTagType(PropType) {
   Static PropTypes := {1: "Byte", 2: "ASCII", 3: "Short", 4: "Long", 5: "Rational", 7: "Undefined", 9: "SLong", 10: "SRational"}
   Return PropTypes.HasKey(PropType) ? PropTypes[PropType] : "Unknown"
}
Gdip_GetPropertyItemValue(ByRef PropVal, PropLen, PropType, PropAddr) {
   PropVal := ""
   If (PropType = 2)
	   {
		  PropVal := StrGet(PropAddr, PropLen, "CP0")
		  Return True
	   }
   If (PropType = 3)
   {
      PropyLen := PropLen // 2
      Loop %PropyLen%
         PropVal .= (A_Index > 1 ? " " : "") . NumGet(PropAddr + 0, (A_Index - 1) << 1, "Short")
      Return True
   }
   If (PropType = 4) || (PropType = 9)
	   {
		  NumType := PropType = 4 ? "UInt" : "Int"
		  PropyLen := PropLen // 4
		  Loop %PropyLen%
			 PropVal .= (A_Index > 1 ? " " : "") . NumGet(PropAddr + 0, (A_Index - 1) << 2, NumType)
		  Return True
	   }
   If (PropType = 5) || (PropType = 10)
	   {
		  NumType := PropType = 5 ? "UInt" : "Int"
		  PropyLen := PropLen // 8
		  Loop %PropyLen%
			 PropVal .= (A_Index > 1 ? " " : "") . NumGet(PropAddr + 0, (A_Index - 1) << 2, NumType)
					 .  "/" . NumGet(PropAddr + 4, (A_Index - 1) << 2, NumType)
		  Return True
	   }
   If (PropType = 1) || (PropType = 7)
	   {
		  VarSetCapacity(PropVal, PropLen, 0)
		  DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", &PropVal, "Ptr", PropAddr, "Ptr", PropLen)
		  Return True
	   }
   Return False
}
Gdip_RotatePathAtCenter(pPath, Angle, MatrixOrder:=1, withinBounds:=0, withinBkeepRatio:=1) {
  Rect := Gdip_GetPathWorldBounds(pPath)
  cX := Rect.x + (Rect.w / 2)
  cY := Rect.y + (Rect.h / 2)
  pMatrix := Gdip_CreateMatrix()
  Gdip_TranslateMatrix(pMatrix, -cX , -cY)
  Gdip_RotateMatrix(pMatrix, Angle, MatrixOrder)
  Gdip_TranslateMatrix(pMatrix, cX, cY, MatrixOrder)
  E := Gdip_TransformPath(pPath, pMatrix)
  Gdip_DeleteMatrix(pMatrix)
  If (withinBounds=1 && !E && Angle!=0)
	  {
		 nRect := Gdip_GetPathWorldBounds(pPath)
		 ncX := nRect.x + (nRect.w / 2)
		 ncY := nRect.y + (nRect.h / 2)
		 pMatrix := Gdip_CreateMatrix()
		 Gdip_TranslateMatrix(pMatrix, -ncX , -ncY)
		 sX := Rect.w / nRect.w
		 sY := Rect.h / nRect.h
		 If (withinBkeepRatio=1)
			 {
				sX := min(sX, sY)
				sY := min(sX, sY)
			 }
		 Gdip_ScaleMatrix(pMatrix, sX, sY, MatrixOrder)
		 Gdip_TranslateMatrix(pMatrix, ncX, ncY, MatrixOrder)
		 If (sX!=0 && sY!=0)
			E := Gdip_TransformPath(pPath, pMatrix)
		 Gdip_DeleteMatrix(pMatrix)
	  }
  Return E
}
Gdip_ResetMatrix(hMatrix) {
   return DllCall("gdiplus\GdipResetMatrix", "UPtr", hMatrix)
}
Gdip_RotateMatrix(hMatrix, Angle, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipRotateMatrix", "UPtr", hMatrix, "float", Angle, "Int", MatrixOrder)
}
Gdip_GetPathWorldBounds(pPath, hMatrix:=0, pPen:=0) {
  VarSetCapacity(RectF, 16, 0)
  E := DllCall("gdiplus\GdipGetPathWorldBounds", "UPtr", pPath, "UPtr", &RectF, "UPtr", hMatrix, "UPtr", pPen)
  If (!E) {
      rData := {}
      rData.x := NumGet(&RectF, 0, "float")
      rData.y := NumGet(&RectF, 4, "float")
      rData.w := NumGet(&RectF, 8, "float")
      rData.h := NumGet(&RectF, 12, "float")
      return rData
  } Else {
      Return E
  }
}
Gdip_ScaleMatrix(hMatrix, ScaleX, ScaleY, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipScaleMatrix", "UPtr", hMatrix, "float", ScaleX, "float", ScaleY, "Int", MatrixOrder)
}
Gdip_TranslateMatrix(hMatrix, offsetX, offsetY, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipTranslateMatrix", "UPtr", hMatrix, "float", offsetX, "float", offsetY, "Int", MatrixOrder)
}
Gdip_TransformPath(pPath, hMatrix) {
  return DllCall("gdiplus\GdipTransformPath", "UPtr", pPath, "UPtr", hMatrix)
}
Gdip_SetMatrixElements(hMatrix, m11, m12, m21, m22, x, y) {
  return DllCall("gdiplus\GdipSetMatrixElements", "UPtr", hMatrix, "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y)
}
Gdip_GetMatrixLastStatus(pMatrix) {
  return DllCall("gdiplus\GdipGetLastStatus", "UPtr", pMatrix)
}
Gdip_AddPathBeziers(pPath, Points) {
  iCount := CreatePointsF(PointsF, Points)
  return DllCall("gdiplus\GdipAddPathBeziers", "UPtr", pPath, "UPtr", &PointsF, "int", iCount)
}
Gdip_AddPathBezier(pPath, x1, y1, x2, y2, x3, y3, x4, y4) {
  return DllCall("gdiplus\GdipAddPathBezier", "UPtr", pPath
         , "float", x1, "float", y1, "float", x2, "float", y2
         , "float", x3, "float", y3, "float", x4, "float", y4)
}
Gdip_AddPathLines(pPath, Points) {
  iCount := CreatePointsF(PointsF, Points)
  return DllCall("gdiplus\GdipAddPathLine2", "UPtr", pPath, "UPtr", &PointsF, "int", iCount)
}
Gdip_AddPathLine(pPath, x1, y1, x2, y2) {
  return DllCall("gdiplus\GdipAddPathLine", "UPtr", pPath, "float", x1, "float", y1, "float", x2, "float", y2)
}
Gdip_AddPathArc(pPath, x, y, w, h, StartAngle, SweepAngle) {
  return DllCall("gdiplus\GdipAddPathArc", "UPtr", pPath, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_AddPathPie(pPath, x, y, w, h, StartAngle, SweepAngle) {
  return DllCall("gdiplus\GdipAddPathPie", "UPtr", pPath, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_StartPathFigure(pPath) {
  return DllCall("gdiplus\GdipStartPathFigure", "UPtr", pPath)
}
Gdip_ClosePathFigure(pPath) {
  return DllCall("gdiplus\GdipClosePathFigure", "UPtr", pPath)
}
Gdip_ClosePathFigures(pPath) {
  return DllCall("gdiplus\GdipClosePathFigures", "UPtr", pPath)
}
Gdip_DrawPath(pGraphics, pPen, pPath) {
  Return DllCall("gdiplus\GdipDrawPath", "UPtr", pGraphics, "UPtr", pPen, "UPtr", pPath)
}
Gdip_ClonePath(pPath) {
  pPathClone := 0
  gdipLastError := DllCall("gdiplus\GdipClonePath", "UPtr", pPath, "UPtr*", pPathClone)
  return pPathClone
}
Gdip_PathGradientCreateFromPath(pPath) {
   pBrush := 0
   gdipLastError := DllCall("gdiplus\GdipCreatePathGradientFromPath", "Ptr", pPath, "PtrP", pBrush)
   Return pBrush
}
Gdip_PathGradientSetCenterPoint(pBrush, X, Y) {
   VarSetCapacity(POINTF, 8)
   NumPut(X, POINTF, 0, "Float")
   NumPut(Y, POINTF, 4, "Float")
   Return DllCall("gdiplus\GdipSetPathGradientCenterPoint", "UPtr", pBrush, "Ptr", &POINTF)
}
Gdip_PathGradientSetCenterColor(pBrush, CenterColor) {
   Return DllCall("gdiplus\GdipSetPathGradientCenterColor", "UPtr", pBrush, "UInt", CenterColor)
}
Gdip_PathGradientSetSurroundColors(pBrush, SurroundColors) {
   Colors := StrSplit(SurroundColors, "|")
   tColors := Colors.Length()
   VarSetCapacity(ColorArray, 4 * tColors, 0)
   Loop %tColors% {
      NumPut(Colors[A_Index], ColorArray, 4 * (A_Index - 1), "UInt")
   }
   Return DllCall("gdiplus\GdipSetPathGradientSurroundColorsWithCount", "Ptr", pBrush, "Ptr", &ColorArray
                , "IntP", tColors)
}
Gdip_PathGradientSetSigmaBlend(pBrush, Focus, Scale:=1) {
   Return DllCall("gdiplus\GdipSetPathGradientSigmaBlend", "Ptr", pBrush, "Float", Focus, "Float", Scale)
}
Gdip_PathGradientSetLinearBlend(pBrush, Focus, Scale:=1) {
   Return DllCall("gdiplus\GdipSetPathGradientLinearBlend", "Ptr", pBrush, "Float", Focus, "Float", Scale)
}
Gdip_PathGradientSetFocusScales(pBrush, xScale, yScale) {
   Return DllCall("gdiplus\GdipSetPathGradientFocusScales", "Ptr", pBrush, "Float", xScale, "Float", yScale)
}
Gdip_AddPathGradient(pGraphics, x, y, w, h, cX, cY, cClr, sClr, BlendFocus, ScaleX, ScaleY, Shape, Angle:=0) {
   pPath := Gdip_CreatePath()
   If (Shape=1)
      Gdip_AddPathRectangle(pPath, x, y, W, H)
   Else
      Gdip_AddPathEllipse(pPath, x, y, W, H)
   zBrush := Gdip_PathGradientCreateFromPath(pPath)
   If (Angle!=0)
      Gdip_RotatePathGradientAtCenter(zBrush, Angle)
   Gdip_PathGradientSetCenterPoint(zBrush, cX, cY)
   Gdip_PathGradientSetCenterColor(zBrush, cClr)
   Gdip_PathGradientSetSurroundColors(zBrush, sClr)
   Gdip_PathGradientSetSigmaBlend(zBrush, BlendFocus)
   Gdip_PathGradientSetLinearBlend(zBrush, BlendFocus)
   Gdip_PathGradientSetFocusScales(zBrush, ScaleX, ScaleY)
   E := Gdip_FillPath(pGraphics, zBrush, pPath)
   Gdip_DeleteBrush(zBrush)
   Gdip_DeletePath(pPath)
   Return E
}
Gdip_CreatePathGradient(Points, WrapMode) {
    Static Ptr := "UPtr"
    iCount := CreatePointsF(PointsF, Points)
    pPathGradientBrush := 0
    gdipLastError := DllCall("gdiplus\GdipCreatePathGradient", Ptr, &PointsF, "int", iCount, "int", WrapMode, "int*", pPathGradientBrush)
    Return pPathGradientBrush
}
Gdip_PathGradientGetGammaCorrection(pPathGradientBrush) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetPathGradientGammaCorrection", Ptr, pPathGradientBrush, "int*", result)
   If E
      return -1
   Return result
}
Gdip_PathGradientGetPointCount(pPathGradientBrush) {
   Static Ptr := "UPtr"
   result := 0
   E := DllCall("gdiplus\GdipGetPathGradientPointCount", Ptr, pPathGradientBrush, "int*", result)
   If E
      return -1
   Return result
}
Gdip_PathGradientGetWrapMode(pPathGradientBrush) {
   result := 0
   E := DllCall("gdiplus\GdipGetPathGradientWrapMode", "UPtr", pPathGradientBrush, "int*", result)
   If E
      return -1
   Return result
}
Gdip_PathGradientGetRect(pPathGradientBrush) {
  VarSetCapacity(RectF, 16, 0)
  E := DllCall("gdiplus\GdipGetPathGradientRect", "UPtr", pPathGradientBrush, "UPtr", &RectF)
  If (!E) {
      rData := {}
      rData.x := NumGet(&RectF, 0, "float")
      rData.y := NumGet(&RectF, 4, "float")
      rData.w := NumGet(&RectF, 8, "float")
      rData.h := NumGet(&RectF, 12, "float")
      return rData
  } Else {
      Return E
  }
}
Gdip_PathGradientResetTransform(pPathGradientBrush) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipResetPathGradientTransform", Ptr, pPathGradientBrush)
}
Gdip_PathGradientRotateTransform(pPathGradientBrush, Angle, matrixOrder:=0) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipRotatePathGradientTransform", Ptr, pPathGradientBrush, "float", Angle, "int", matrixOrder)
}
Gdip_PathGradientScaleTransform(pPathGradientBrush, ScaleX, ScaleY, matrixOrder:=0) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipScalePathGradientTransform", Ptr, pPathGradientBrush, "float", ScaleX, "float", ScaleY, "int", matrixOrder)
}
Gdip_PathGradientTranslateTransform(pPathGradientBrush, X, Y, matrixOrder:=0) {
   Static Ptr := "UPtr"
   Return DllCall("gdiplus\GdipTranslatePathGradientTransform", Ptr, pPathGradientBrush, "float", X, "float", Y, "int", matrixOrder)
}
Gdip_PathGradientMultiplyTransform(pPathGradientBrush, hMatrix, matrixOrder:=0) {
   Static Ptr := "UPtr"
   Return DllCall("gdiplus\GdipMultiplyPathGradientTransform", Ptr, pPathGradientBrush, Ptr, hMatrix, "int", matrixOrder)
}
Gdip_PathGradientSetTransform(pPathGradientBrush, pMatrix) {
  return DllCall("gdiplus\GdipSetPathGradientTransform", "UPtr", pPathGradientBrush, "UPtr", pMatrix)
}
Gdip_PathGradientGetTransform(pPathGradientBrush) {
   pMatrix := 0
   gdipLastError := DllCall("gdiplus\GdipGetPathGradientTransform", "UPtr", pPathGradientBrush, "UPtr*", pMatrix)
   Return pMatrix
}
Gdip_RotatePathGradientAtCenter(pPathGradientBrush, Angle, MatrixOrder:=1) {
  Rect := Gdip_PathGradientGetRect(pPathGradientBrush)
  cX := Rect.x + (Rect.w / 2)
  cY := Rect.y + (Rect.h / 2)
  pMatrix := Gdip_CreateMatrix()
  Gdip_TranslateMatrix(pMatrix, -cX , -cY)
  Gdip_RotateMatrix(pMatrix, Angle, MatrixOrder)
  Gdip_TranslateMatrix(pMatrix, cX, cY, MatrixOrder)
  E := Gdip_PathGradientSetTransform(pPathGradientBrush, pMatrix)
  Gdip_DeleteMatrix(pMatrix)
  Return E
}
Gdip_PathGradientSetGammaCorrection(pPathGradientBrush, UseGammaCorrection) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipSetPathGradientGammaCorrection", Ptr, pPathGradientBrush, "int", UseGammaCorrection)
}
Gdip_PathGradientSetWrapMode(pPathGradientBrush, WrapMode) {
   Static Ptr := "UPtr"
   return DllCall("gdiplus\GdipSetPathGradientWrapMode", Ptr, pPathGradientBrush, "int", WrapMode)
}
Gdip_PathGradientGetCenterColor(pPathGradientBrush) {
   Static Ptr := "UPtr"
   ARGB := 0
   E := DllCall("gdiplus\GdipGetPathGradientCenterColor", Ptr, pPathGradientBrush, "uint*", ARGB)
   If E
      return -1
   Return Format("{1:#x}", ARGB)
}
Gdip_PathGradientGetCenterPoint(pPathGradientBrush, ByRef X, ByRef Y) {
   VarSetCapacity(PointF, 8, 0)
   E := DllCall("gdiplus\GdipGetPathGradientCenterPoint", "UPtr", pPathGradientBrush, "UPtr", &PointF)
   If !E
   {
      x := NumGet(PointF, 0, "float")
      y := NumGet(PointF, 4, "float")
   }
   Return E
}
Gdip_PathGradientGetFocusScales(pPathGradientBrush, ByRef X, ByRef Y) {
   x := y := 0
   Return DllCall("gdiplus\GdipGetPathGradientFocusScales", "UPtr", pPathGradientBrush, "float*", X, "float*", Y)
}
Gdip_PathGradientGetSurroundColorCount(pPathGradientBrush) {
   result := 0
   E := DllCall("gdiplus\GdipGetPathGradientSurroundColorCount", "UPtr", pPathGradientBrush, "int*", result)
   If E
      return -1
   Return result
}
Gdip_GetPathGradientSurroundColors(pPathGradientBrush) {
   iCount := Gdip_PathGradientGetSurroundColorCount(pPathGradientBrush)
   If (iCount=-1)
      Return 0
   VarSetCapacity(sColors, 8 * iCount, 0)
   gdipLastError := DllCall("gdiplus\GdipGetPathGradientSurroundColorsWithCount", "UPtr", pPathGradientBrush, "UPtr", &sColors, "intP", iCount)
   Loop %iCount%
   {
       A := NumGet(&sColors, 8*(A_Index-1), "uint")
       printList .= Format("{1:#x}", A) ","
   }
   Return Trim(printList, ",")
}
Gdip_GetHistogram(pBitmap, whichFormat, ByRef newArrayA, ByRef newArrayB, ByRef newArrayC, ByRef newArrayD:=0) {
   Static sizeofUInt := 4
   z := DllCall("gdiplus\GdipBitmapGetHistogramSize", "UInt", whichFormat, "UInt*", numEntries)
   newArrayA := []
   VarSetCapacity(ch0, numEntries * sizeofUInt, 0)
   If (whichFormat<=2)
   {
      newArrayB := [], newArrayC := [], newArrayD := []
      VarSetCapacity(ch1, numEntries * sizeofUInt, 0)
      VarSetCapacity(ch2, numEntries * sizeofUInt, 0)
      If (whichFormat<2)
         VarSetCapacity(ch3, numEntries * sizeofUInt, 0)
   }
   E := DllCall("gdiplus\GdipBitmapGetHistogram", "Ptr", pBitmap, "UInt", whichFormat, "UInt", numEntries, "Ptr", &ch0
      , "Ptr", (whichFormat<=2) ? &ch1 : 0
      , "Ptr", (whichFormat<=2) ? &ch2 : 0
      , "Ptr", (whichFormat<2)  ? &ch3 : 0)
   If (E=1 && A_LastError=8)
      E := 3
   Loop %numEntries%
   {
      i := A_Index - 1
      newArrayA[i] := NumGet(&ch0+0, i * sizeofUInt, "UInt")
      If (whichFormat<=2)
      {
         newArrayB[i] := NumGet(&ch1+0, i * sizeofUInt, "UInt")
         newArrayC[i] := NumGet(&ch2+0, i * sizeofUInt, "UInt")
         If (whichFormat<2)
            newArrayD[i] := NumGet(&ch3+0, i * sizeofUInt, "UInt")
      }
   }
   Return E
}
Gdip_DrawRoundedLine(G, x1, y1, x2, y2, LineWidth, LineColor) {
  pPen := Gdip_CreatePen(LineColor, LineWidth)
  Gdip_DrawLine(G, pPen, x1, y1, x2, y2)
  Gdip_DeletePen(pPen)
  pPen := Gdip_CreatePen(LineColor, LineWidth/2)
  Gdip_DrawEllipse(G, pPen, x1-LineWidth/4, y1-LineWidth/4, LineWidth/2, LineWidth/2)
  Gdip_DrawEllipse(G, pPen, x2-LineWidth/4, y2-LineWidth/4, LineWidth/2, LineWidth/2)
  Gdip_DeletePen(pPen)
}
Gdip_CreateBitmapFromGdiDib(BITMAPINFO, BitmapData) {
   pBitmap := 0
   gdipLastError := DllCall("gdiplus\GdipCreateBitmapFromGdiDib", "UPtr", BITMAPINFO, "UPtr", BitmapData, "UPtr*", pBitmap)
   Return pBitmap
}
Gdip_DrawImageFX(pGraphics, pBitmap, dX:="", dY:="", sX:="", sY:="", sW:="", sH:="", matrix:="", pEffect:="", ImageAttr:=0, hMatrix:=0, Unit:=2) {
    If !ImageAttr
		{
		   if !IsNumber(Matrix)
			  ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
		   else if (Matrix != 1)
			  ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
		} Else usrImageAttr := 1
    if (sX="" && sY="")
       sX := sY := 0
    if (sW="" && sH="")
       Gdip_GetImageDimensions(pBitmap, sW, sH)
    if (!hMatrix && dX!="" && dY!="")
		{
		   hMatrix := dhMatrix := Gdip_CreateMatrix()
		   Gdip_TranslateMatrix(dhMatrix, dX, dY, 1)
		}
    CreateRectF(sourceRect, sX, sY, sW, sH)
    gdipLastError := DllCall("gdiplus\GdipDrawImageFX"
      , "UPtr", pGraphics
      , "UPtr", pBitmap
      , "UPtr", &sourceRect
      , "UPtr", hMatrix ? hMatrix : 0        ; transformation matrix
      , "UPtr", pEffect ? pEffect : 0
      , "UPtr", ImageAttr ? ImageAttr : 0
      , "Uint", Unit)
   If dhMatrix
      Gdip_DeleteMatrix(dhMatrix)
   If (ImageAttr && usrImageAttr!=1)
      Gdip_DisposeImageAttributes(ImageAttr)
   Return E
}
Gdip_BitmapApplyEffect(pBitmap, pEffect, x:="", y:="", w:="", h:="") {
  If (InStr(pEffect, "err-") || !pEffect || !pBitmap)
     Return 2
  If (!x && !y && !w && !h)
     none := 1
  Else
     CreateRect(Rect, x, y, x + w, y + h)
  E := DllCall("gdiplus\GdipBitmapApplyEffect"
      , "UPtr", pBitmap
      , "UPtr", pEffect
      , "UPtr", (none=1) ? 0 : &Rect
      , "UPtr", 0     ; useAuxData
      , "UPtr", 0     ; auxData
      , "UPtr", 0)
  Return E
}
COM_CLSIDfromString(ByRef CLSID, String) {
    VarSetCapacity(CLSID, 16, 0)
    Return DllCall("ole32\CLSIDFromString", "WStr", String, "UPtr", &CLSID)
}
Gdip_CreateEffect(whichFX, paramA, paramB, paramC:=0) {
    Static gdipImgFX := {1:"633C80A4-1843-482b-9EF2-BE2834C5FDD4", 2:"63CBF3EE-C526-402c-8F71-62C540BF5142", 3:"718F2615-7933-40e3-A511-5F68FE14DD74", 4:"A7CE72A9-0F7F-40d7-B3CC-D0C02D5C3212", 5:"D3A1DBE1-8EC4-4c17-9F4C-EA97AD1C343D", 6:"8B2DD6C3-EB07-4d87-A5F0-7108E26A9C5F", 7:"99C354EC-2A31-4f3a-8C34-17A803B33A25", 8:"1077AF00-2848-4441-9489-44AD4C2D7A2C", 9:"537E597D-251E-48da-9664-29CA496B70F8", 10:"74D29D05-69A4-4266-9549-3CC52836B632", 11:"DD6A0022-58E4-4a67-9D9B-D48EB881A53D"}
    pEffect := 0
    r1 := COM_CLSIDfromString(eFXguid, "{" gdipImgFX[whichFX] "}" )
    If r1
       Return "err-" r1
    If (A_PtrSize=4)
    {
       r2 := DllCall("gdiplus\GdipCreateEffect"
          , "UInt", NumGet(eFXguid, 0, "UInt")
          , "UInt", NumGet(eFXguid, 4, "UInt")
          , "UInt", NumGet(eFXguid, 8, "UInt")
          , "UInt", NumGet(eFXguid, 12, "UInt")
          , "Ptr*", pEffect)
    } Else
    {
       r2 := DllCall("gdiplus\GdipCreateEffect"
          , "UPtr", &eFXguid
          , "Ptr*", pEffect)
    }
    If r2
       Return "err-" r2
    If (whichFX=3)
       CreateColourMatrix(paramA, FXparams)
    Else
       VarSetCapacity(FXparams, 12, 0)
    If (whichFX=1)
    {
       FXsize := 8
       NumPut(paramA, FXparams, 0, "Float")
       NumPut(paramB, FXparams, 4, "Uchar")
    } Else If (whichFX=3)
    {
       FXsize := 100
    } Else If (whichFX=2)
    {
       FXsize := 8
       NumPut(paramA, FXparams, 0, "Float")
       NumPut(paramB, FXparams, 4, "Float")
    } Else If (whichFX=5)
    {
       FXsize := 8
       NumPut(paramA, FXparams, 0, "Int")
       NumPut(paramB, FXparams, 4, "Int")
    } Else If (whichFX=6)
    {
       FXsize := 12
       NumPut(paramA, FXparams, 0, "Int")
       NumPut(paramB, FXparams, 4, "Int")
       NumPut(paramC, FXparams, 8, "Int")
    } Else If (whichFX=7)
    {
       FXsize := 12
       NumPut(paramA, FXparams, 0, "Int")
       NumPut(paramB, FXparams, 4, "Int")
       NumPut(paramC, FXparams, 8, "Int")
    } Else If (whichFX=8)
    {
       FXsize := 8
       NumPut(paramA, FXparams, 0, "Int")
       NumPut(paramB, FXparams, 4, "Int")
    } Else If (whichFX=9)
    {
       FXsize := 12
       NumPut(paramA, FXparams, 0, "Int")
       NumPut(paramB, FXparams, 4, "Int")
       NumPut(paramC, FXparams, 8, "Int")
    } Else If (whichFX=11)
    {
       FXsize := 12
       NumPut(paramA, FXparams, 0, "Int")
       NumPut(paramB, FXparams, 4, "Int")
       NumPut(paramC, FXparams, 8, "Int")
    }
    r3 := DllCall("gdiplus\GdipSetEffectParameters", "UPtr", pEffect, "UPtr", &FXparams, "UInt", FXsize)
    If r3
    {
       Gdip_DisposeEffect(pEffect)
       Return "err-" r3
    }
    Return pEffect
}
Gdip_ApplySpecialFixedBlur(zBitmap, radius, pEffect, previewMode:=0) {
    If (!pEffect || !zBitmap)
		{
		   Return
		}
    If (radius>19 || previewMode=1)
		{
		   Gdip_BitmapApplyEffect(zBitmap, pEffect)
		   Return
		}
    If (radius=19)
       radius += 18
    Else If (radius=18)
       radius += 15
    Else If (radius=17)
       radius += 12
    Else If (radius=16)
       radius += 10
    Else If (radius=15)
       radius += 8
    Else If (radius=14)
       radius += 6
    Else If (radius=13)
       radius += 4
    Else If (radius=12)
       radius += 2
    Else If (radius=11)
       radius += 1
    If (radius<=1)
       radius := 2
    zA := Gdip_CreateEffect(1, radius//2, 0, 0)
    zB := Gdip_CreateEffect(1, radius//2, 0, 0)
    Gdip_ImageRotateFlip(zBitmap, 1)
    Gdip_BitmapApplyEffect(zBitmap, zA)
    Gdip_ImageRotateFlip(zBitmap, 3)
    Gdip_BitmapApplyEffect(zBitmap, zB)
    Gdip_DisposeEffect(zA)
    Gdip_DisposeEffect(zB)
}
Gdip_DisposeEffect(pEffect) {
   If (pEffect && !InStr(pEffect, "err"))
      r := DllCall("gdiplus\GdipDeleteEffect", "UPtr", pEffect)
   Return r
}
GenerateColorMatrix(modus, bright:=1, contrast:=0, saturation:=1, alph:=1, chnRdec:=0, chnGdec:=0, chnBdec:=0) {
    Static NTSCr := 0.308, NTSCg := 0.650, NTSCb := 0.095   ; personalized values
    matrix := ""
    If (modus=2)
		{
		   LGA := (bright<=1) ? bright/1.5 - 0.6666 : bright - 1
		   Ra := NTSCr + LGA
		   If (Ra<0)
			  Ra := 0
		   Ga := NTSCg + LGA
		   If (Ga<0)
			  Ga := 0
		   Ba := NTSCb + LGA
		   If (Ba<0)
			  Ba := 0
		   matrix := Ra "|" Ra "|" Ra "|0|0|" Ga "|" Ga "|" Ga "|0|0|" Ba "|" Ba "|" Ba "|0|0|0|0|0|" alph "|0|" contrast "|" contrast "|" contrast "|0|1"
		} Else If (modus=3)
  {
       Ga := 0, Ba := 0, GGA := 0
       Ra := bright
       matrix := Ra "|" Ra "|" Ra "|0|0|" Ga "|" Ga "|" Ga "|0|0|" Ba "|" Ba "|" Ba "|0|0|0|0|0|" alph "|0|" GGA+0.01 "|" GGA "|" GGA "|0|1"
    } Else If (modus=4)  
    {
       Ra := 0, Ba := 0, GGA := 0
       Ga := bright
       matrix := Ra "|" Ra "|" Ra "|0|0|" Ga "|" Ga "|" Ga "|0|0|" Ba "|" Ba "|" Ba "|0|0|0|0|0|" alph "|0|" GGA "|" GGA+0.01 "|" GGA "|0|1"
    } Else If (modus=5)
    {
       Ra := 0, Ga := 0, GGA := 0
       Ba := bright
       matrix := Ra "|" Ra "|" Ra "|0|0|" Ga "|" Ga "|" Ga "|0|0|" Ba "|" Ba "|" Ba "|0|0|0|0|0|" alph "|0|" GGA "|" GGA "|" GGA+0.01 "|0|1"
    } Else If (modus=6)
    {
       matrix := "-1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|" alph "|0|1|1|1|0|1"
    } Else If (modus=1)
    {
       bL := bright, aL := alph
       G := contrast, sL := saturation
       sLi := 1 - saturation
       bLa := bright - 1
       If (sL>1)
       {
          z := (bL<1) ? bL : 1
          sL := sL*z
          If (sL<0.98)
             sL := 0.98
          y := z*(1 - sL)
          mA := z*(y*NTSCr + sL + bLa + chnRdec)
          mB := z*(y*NTSCr)
          mC := z*(y*NTSCr)
          mD := z*(y*NTSCg)
          mE := z*(y*NTSCg + sL + bLa + chnGdec)
          mF := z*(y*NTSCg)
          mG := z*(y*NTSCb)
          mH := z*(y*NTSCb)
          mI := z*(y*NTSCb + sL + bLa + chnBdec)
          mtrx:= mA "|" mB "|" mC "|  0   |0"
           . "|" mD "|" mE "|" mF "|  0   |0"
           . "|" mG "|" mH "|" mI "|  0   |0"
           . "|  0   |  0   |  0   |" aL "|0"
           . "|" G  "|" G  "|" G  "|  0   |1"
       } Else
       {
          z := (bL<1) ? bL : 1
          tR := NTSCr - 0.5 + bL/2
          tG := NTSCg - 0.5 + bL/2
          tB := NTSCb - 0.5 + bL/2
          rB := z*(tR*sLi+bL*(1 - sLi) + chnRdec)
          gB := z*(tG*sLi+bL*(1 - sLi) + chnGdec)
          gB := z*(tG*sLi+bL*(1 - sLi) + chnGdec)
          rF := z*(NTSCr*sLi + (bL/2 - 0.5)*sLi)
          gF := z*(NTSCg*sLi + (bL/2 - 0.5)*sLi)
          bF := z*(NTSCb*sLi + (bL/2 - 0.5)*sLi)
          rB := rB*z+rF*(1 - z)
          gB := gB*z+gF*(1 - z)
          bB := bB*z+bF*(1 - z)
          If (rB<0)
             rB := 0
          If (gB<0)
             gB := 0
          If (bB<0)
             bB := 0
          If (rF<0)
             rF := 0
          If (gF<0)
             gF := 0
          If (bF<0)
             bF := 0
          mtrx:= rB "|" rF "|" rF "|  0   |0"
           . "|" gF "|" gB "|" gF "|  0   |0"
           . "|" bF "|" bF "|" bB "|  0   |0"
           . "|  0   |  0   |  0   |" aL "|0"
           . "|" G  "|" G  "|" G  "|  0   |1"
       }
       matrix := StrReplace(mtrx, A_Space)
    } Else If (modus=0)
    {
       s1 := contrast
       s2 := saturation
       s3 := bright
       aL := alph
       s1 := s2*sin(s1)
       sc := 1-s2
       r := NTSCr*sc-s1
       g := NTSCg*sc-s1
       b := NTSCb*sc-s1
       rB := r+s2+3*s1
       gB := g+s2+3*s1
       bB := b+s2+3*s1
       mtrx :=   rB "|" r  "|" r  "|  0   |0"
           . "|" g  "|" gB "|" g  "|  0   |0"
           . "|" b  "|" b  "|" bB "|  0   |0"
           . "|  0   |  0   |  0   |" aL "|0"
           . "|" s3 "|" s3 "|" s3 "|  0   |1"
       matrix := StrReplace(mtrx, A_Space)
    } Else If (modus=7)
    {
       matrix := "0|0|0|0|0"
              . "|0|0|0|0|0"
              . "|0|0|0|0|0"
              . "|1|1|1|25|0"
              . "|0|0|0|0|1"
    } Else If (modus=8)
    {
       matrix := "0.39|0.34|0.27|0|0"
              . "|0.76|0.58|0.33|0|0"
              . "|0.19|0.16|0.13|0|0"
              . "|0|0|0|" alph "|0"
              . "|0|0|0|0|1"
    } Else If (modus=9)
    {
       matrix := "1|0|0|0|0"
              . "|0|1|0|0|0"
              . "|0|0|1|0|0"
              . "|0|0|0|" alph "|0"
              . "|0|0|0|0|1"
    }
    Return matrix
}
Gdip_CompareBitmaps(pBitmapA, pBitmapB, accuracy:=25) {
   If (!pBitmapA || !pBitmapB)
      Return -1
   If (accuracy>99)
      accuracy := 100
   Else If (accuracy<5)
      accuracy := 5
   Gdip_GetImageDimensions(pBitmapA, WidthA, HeightA)
   Gdip_GetImageDimensions(pBitmapB, WidthB, HeightB)
   If (accuracy!=100)
   {
      pBitmap1 := Gdip_ResizeBitmap(pBitmapA, Floor(WidthA*(accuracy/100)), Floor(HeightA*(accuracy/100)), 0, 5)
      pBitmap2 := Gdip_ResizeBitmap(pBitmapB, Floor(WidthB*(accuracy/100)), Floor(HeightB*(accuracy/100)), 0, 5)
      If (!pBitmap1 || !pBitmap2)
      {
         Gdip_DisposeImage(pbitmap1, 1)
         Gdip_DisposeImage(pbitmap2, 1)
         Return -1
      }
   } Else
   {
      pBitmap1 := pBitmapA
      pBitmap2 := pBitmapB
   }
   Gdip_GetImageDimensions(pBitmap1, Width1, Height1)
   Gdip_GetImageDimensions(pBitmap2, Width2, Height2)
   if (!Width1 || !Height1 || !Width2 || !Height2
   || Width1 != Width2 || Height1 != Height2)
   {
      If (accuracy!=100)
      {
         Gdip_DisposeImage(pBitmap1, 1)
         Gdip_DisposeImage(pBitmap2, 1)
      }
      Return -1
   }
   E1 := Gdip_LockBits(pBitmap1, 0, 0, Width1, Height1, Stride1, Scan01, BitmapData1)
   E2 := Gdip_LockBits(pBitmap2, 0, 0, Width2, Height2, Stride2, Scan02, BitmapData2)
   If (E1 || E2)
   {
      If !E1
         Gdip_UnlockBits(pBitmap1, BitmapData1)
      If !E2
         Gdip_UnlockBits(pBitmap2, BitmapData2)
      If (accuracy!=100)
      {
         Gdip_DisposeImage(pBitmap1, 1)
         Gdip_DisposeImage(pBitmap2, 1)
      }
      Return -1
   }
   z := 0
   Loop %Height1%
	   {
		  y++
		  Loop %Width1%
			  {
				 Gdip_FromARGB(Gdip_GetLockBitPixel(Scan01, A_Index-1, y-1, Stride1), A1, R1, G1, B1)
				 Gdip_FromARGB(Gdip_GetLockBitPixel(Scan02, A_Index-1, y-1, Stride2), A2, R2, G2, B2)
				 z += Abs(A2-A1) + Abs(R2-R1) + Abs(G2-G1) + Abs(B2-B1)
			  }
	   }
   Gdip_UnlockBits(pBitmap1, BitmapData1)
   Gdip_UnlockBits(pBitmap2, BitmapData2)
   If (accuracy!=100)
	   {
		  Gdip_DisposeImage(pBitmap1)
		  Gdip_DisposeImage(pBitmap2)
	   }
   Return z/(Width1*Width2*3*255/100)
}
Gdip_RetrieveBitmapChannel(pBitmap, channel, PixelFormat:=0) {
    If !pBitmap
       Return
    Gdip_GetImageDimensions(pBitmap, imgW, imgH)
    If (!imgW || !imgH)
       Return
    newBitmap := Gdip_CreateBitmap(imgW, imgH, PixelFormat)
    If !newBitmap
       Return
    G := Gdip_GraphicsFromImage(newBitmap, 7)
    If !G
    {
       Gdip_DisposeImage(newBitmap, 1)
       Return
    }
    If (channel=1)
       matrix := GenerateColorMatrix(3)
    Else If (channel=2)
       matrix := GenerateColorMatrix(4)
    Else If (channel=3)
       matrix := GenerateColorMatrix(5)
    Else If (channel=4)
       matrix := GenerateColorMatrix(7)
    Else Return
    Gdip_GraphicsClear(G, "0xff000000")
    E := Gdip_DrawImage(G, pBitmap, 0, 0, imgW, imgH, 0, 0, imgW, imgH, matrix)
    If E
    {
       Gdip_DisposeImage(newBitmap, 1)
       Return
    }
    Gdip_DeleteGraphics(G)
    Return newBitmap
}
Gdip_RenderPixelsOpaque(pBitmap, pBrush:=0, alphaLevel:=0, PixelFormat:=0) {
    Gdip_GetImageDimensions(pBitmap, imgW, imgH)
    newBitmap := Gdip_CreateBitmap(imgW, imgH, PixelFormat)
    If newBitmap
       G := Gdip_GraphicsFromImage(newBitmap, 7)
    If (!newBitmap || !G)
		{
		   Gdip_DisposeImage(newBitmap, 1)
		   Gdip_DeleteGraphics(G)
		   Return
		}
    If alphaLevel
       matrix := GenerateColorMatrix(0, 0, 0, 1, alphaLevel)
    Else
       matrix := GenerateColorMatrix(0, 0, 0, 1, 25)
    If pBrush
       Gdip_FillRectangle(G, pBrush, 0, 0, imgW, imgH)
    E := Gdip_DrawImage(G, pBitmap, 0, 0, imgW, imgH, 0, 0, imgW, imgH, matrix)
    Gdip_DeleteGraphics(G)
    If E
		{
		   Gdip_DisposeImage(newBitmap, 1)
		   Return
		}
    Return newBitmap
}
Gdip_TestBitmapUniformity(pBitmap, HistogramFormat:=3, ByRef maxLevelIndex:=0, ByRef maxLevelPixels:=0) {
   If !pBitmap
      Return -1
   LevelsArray := []
   maxLevelIndex := maxLevelPixels := nrPixels := 9
   Gdip_GetImageDimensions(pBitmap, Width, Height)
   E := Gdip_GetHistogram(pBitmap, HistogramFormat, LevelsArray, 0, 0)
   If E
      Return -2
   Loop 256
	   {
		   nrPixels := Round(LevelsArray[A_Index - 1])
		   If (nrPixels>0)
			  histoList .= nrPixels "." A_Index - 1 "|"
	   }
   Sort histoList, NURD|
   histoList := Trim(histoList, "|")
   histoListSortedArray := StrSplit(histoList, "|")
   maxLevel := StrSplit(histoListSortedArray[1], ".")
   maxLevelIndex := maxLevel[2]
   maxLevelPixels := maxLevel[1]
   pixelsThreshold := Round((Width * Height) * 0.0005) + 1
   If (Floor(histoListSortedArray[2])<pixelsThreshold)
      Return 1
   Else
      Return 0
}
Gdip_SetAlphaChannel(pBitmap, pBitmapMask, invertAlphaMask:=0, replaceSourceAlphaChannel:=0, whichChannel:=1) {
  static mCodeFunc := 0
  if (mCodeFunc=0)
	  {
		  if (A_PtrSize=8)
		  base64enc := "
		  (LTrim Join
		  2,x64:QVdBVkFVQVRVV1ZTRItsJGhJicuLTCR4SInWg/kBD4TZAQAAg/kCD4SyAAAAg/kDD4TRAQAAg/kEuBgAAAAPRMiDfCRwAQ+EowAAAEWFwA+OZgEAAEWNcP9NY8Ax7UG8/wAAAEqNHIUAAAAAMf9mkEWFyX5YQYP9AQ+E2QAAAEyNB
		  K0AAAAAMdIPH4AAAAAAR4sUA0KLBAZFidfT+EHB7xgPtsBCjYQ4Af///4XAD0jHQYHi////AIPCAcHgGEQJ0EOJBANJAdhBOdF1w0iNRQFMOfUPhOEAAABIicXrkYN8JHABuQgAAAAPhV3///9FhcAPjsMAAABBjXj/TWPAMdtOjRSFAAAA
		  AA8fgAAAAABFhcl+MUGD/QEPhLEAAABIjQSdAAAAAEUxwGYPH0QAAIsUBkGDwAHT+kGIVAMDTAHQRTnBdepIjUMBSDnfdGxIicPrvA8fQABIjRStAAAAAEUxwA8fRAAARYsUE4sEFkWJ19P4QcHvGA+2wEKNhDgB////RYnnhcAPSMdBgeL
		  ///8AQYPAAUEpx0SJ+MHgGEQJ0EGJBBNIAdpFOcF1ukiNRQFMOfUPhR////+4AQAAAFteX11BXEFdQV5BX8MPHwBIjRSdAAAAAEUxwA8fRAAAiwQWQYPAAdP499BBiEQTA0wB0kU5wXXo6Un///+5EAAAAOk6/v//McnpM/7//w==
		  )"
		  else
		  base64enc := "
		  (LTrim Join
		  2,x86:VVdWU4PsBIN8JDABD4T1AQAAg3wkMAIPhBwBAACDfCQwAw+E7AEAAIN8JDAEuBgAAAAPRUQkMIlEJDCDfCQsAQ+EBgEAAItUJCCF0g+OiQAAAItEJCDHBCQAAAAAjSyFAAAAAI10JgCLRCQkhcB+XosEJItcJBgx/400hQAAAAAB8wN0JByDfCQ
		  oAXRjjXYAixOLBg+2TCQw0/iJ0cHpGA+2wI2ECAH///+5AAAAAIXAD0jBgeL///8Ag8cBAe7B4BgJwokTAes5fCQkdcKDBCQBiwQkOUQkIHWNg8QEuAEAAABbXl9dw420JgAAAACQixOLBg+2TCQw0/iJ0cHpGA+2wI2ECAH///+5AAAAAIXAD0jBuf8A
		  AACB4v///wAB7oPHASnBicjB4BgJwokTAes5fCQkdbnrlYN8JCwBx0QkMAgAAAAPhfr+//+LTCQghcl+hzH/i0QkIItsJCSJPCSLTCQwjTSFAAAAAI10JgCF7X42g3wkKAGLBCR0Sot8JByNFIUAAAAAMdsB1wNUJBiNtCYAAAAAiweDwwEB99P4iEIDA
		  fI53XXugwQkAYsEJDlEJCB1uYPEBLgBAAAAW15fXcONdCYAi1wkHMHgAjHSAcMDRCQYiceNtCYAAAAAiwODwgEB89P499CIRwMB9znVdeyDBCQBiwQkOUQkIA+Fa////+uwx0QkMBAAAADpJ/7//8dEJDAAAAAA6Rr+//8=
		  )"
		  mCodeFunc := Gdip_RunMCode(base64enc)
	  }
  Gdip_GetImageDimensions(pBitmap, w, h)
  Gdip_GetImageDimensions(pBitmapMask, w2, h2)
  If (w2!=w || h2!=h || !pBitmap || !pBitmapMask)
     Return 0
  E1 := Gdip_LockBits(pBitmap, 0, 0, w, h, stride, iScan, iData)
  E2 := Gdip_LockBits(pBitmapMask, 0, 0, w, h, stride, mScan, mData)
  If (!E1 && !E2)
     r := DllCall(mCodeFunc, "UPtr", iScan, "UPtr", mScan, "Int", w, "Int", h, "Int", invertAlphaMask, "Int", replaceSourceAlphaChannel, "Int", whichChannel)
  If !E1
     Gdip_UnlockBits(pBitmap, iData)
  If !E2
     Gdip_UnlockBits(pBitmapMask, mData)
  return r
}
Gdip_BlendBitmaps(pBitmap, pBitmap2Blend, blendMode) {
  static mCodeFunc := 0
  if (mCodeFunc=0)
  {
      if (A_PtrSize=8)
      base64enc := "
      (LTrim Join
      2,x64:QVdBVkFVQVRVV1ZTSIHsiAAAAA8pdCQgDyl8JDBEDylEJEBEDylMJFBEDylUJGBEDylcJHBEi6wk8AAAAEiJlCTYAAAASInORYXAD46XBAAARYXJD46OBAAAQY1A/01jwGYP7+TzDxA9AAAAAEiJRCQQRA8o3EQPKNRFic5OjSSFAAAAAEQPKM9EDyjHSMdEJAgAAAAASItEJAhNiedmkGYP7/ZMjQSFAAAAAEUx0g8o7mYPH0QAAEKLDAaFyQ+E5QEAAEiLhCTYAAAAQYnJQcHpGEKLHACJ2MHoGE
      E4wUQPQ8hFhMkPhPQBAACJ2InaD7btRA+228HoCMHqEIlEJBgPtscPtvpBicSJyA+2ycHoEA+2wEGD/QEPhAEBAABBg/0CD4QHAgAAQYP9Aw+EnQIAAEGD/QQPhPMCAABBg/0FD4RhAwAAQYP9Bg+E1wMAAEGD/QcPhJQEAABBg/0ID4TPBAAAQYP9CQ+ETAUAAEGD/QoPhEUGAABBg/0LD4RnBwAAQYP9DA+E6gYAAEGD/Q0PhMkHAABBg/0OD4T5CAAAQYP9Dw+EXQgAAEGD/RAPhKgJAABBg/0RD4TYCQ
      AAQYP9Eg+FqQEAALr/AAAAOccPjkUKAAAp+mYP78kpwvMPKsq4/wAAAEE57A+OGQoAAEQp4GYP79Ip6PMPKtC4/wAAAEE5yw+O7AkAAEQp2GYP78ApyPMPKsDpVQEAAA8fADnHD42YAQAAZg/vyfMPKs9BOewPjXcBAABmD+/S80EPKtRBOcsPjU0BAABmD+/AZg/v2/NBDyrDDy/YdgTzD1jHDy/ZD4eWAAAA8w8swQ+2wMHgEA8v2onCD4ePAAAA8w8s2g+228HjCA8v2A+HigAAAPMPLMAPtsAJ0EHB4R
      hBCcFBCdlGiQwGQYPCAU0B+EU51g+F//3//0iLfCQISI1HAUg5fCQQD4QbAgAASIlEJAjpyf3//2YPH4QAAAAAAEGDwgFCxwQGAAAAAE0B+EU51g+FwP3//+u/Zg8fRAAAMdIPL9oPKMsPhnH///8x2w8v2A8o0w+Gdv///zHADyjD6XP///9mLg8fhAAAAAAAD6/4Zg/vyWYP79JBD6/sZg/vwEEPr8uJ+L+BgICASA+vx0gPr+9ID6/PSMHoJ0jB7SfzDyrISMHpJ/MPKtXzDyrBDy/hDyjcdgXzQQ9YyQ
      8v2g+G0P7///NBD1jQ6cb+//9mDx9EAABmD+/ADyjd8w8qwemw/v//Dx+EAAAAAABmD+/S8w8q1emF/v//Dx8AZg/vyfMPKsjpY/7//w8fAAHHZg/vyWYP79K6/wAAAIH//wAAAGYP78APTPpEAeWB7/8AAACB/f8AAAAPTOrzDyrPRAHZge3/AAAAgfn/AAAAD0zK8w8q1YHp/wAAAPMPKsHpS////2YPH4QAAAAAALv/AAAAZg/vyWYP79KDxwGJ2mYP78APKN4pwonQweAIKdCZ9/+J2jH/KcKJ0InaD0
      jHKepBjWwkAfMPKsiJ0MHgCCnQmff9idopwonQidoPSMcpykGDwwHzDyrQidDB4Agp0JlB9/spww9I3/MPKsPpxf3//w8fADnHD44yAQAAZg/vyfMPKs9BOewPjhQBAABmD+/S80EPKtRBOcsPjvEAAABmD+/AZg/v2/NBDyrD6Zr+//8PHwAPKHQkIA8ofCQwuAEAAABEDyhEJEBEDyhMJFBEDyhUJGBEDyhcJHBIgcSIAAAAW15fXUFcQV1BXkFfww8fRAAAuv8AAABmD+/JZg/v0onTKfuJ1ynHifgPr8
      NIY9hIaduBgICASMHrIAHDwfgfwfsHKdiJ0wX/AAAARCnj8w8qyInQKegPr8NIY9hIaduBgICASMHrIAHDwfgfwfsHKdgF/wAAAPMPKtCJ0CnKRCnYD6/CSGPQZg/vwEhp0oGAgIBIweogAcLB+B/B+gcp0AX/AAAA8w8qwOmu/f//Zg/vwEEPKNrzDyrB6ar9//9mD+/S8w8q1eno/v//Zg/vyfMPKsjpyf7//2YP78lmD+/SZg/vwAHHgf//AAAAuP8AAAAPT/hEAeWB/f8AAAAPT+jzDyrPRAHZgfn/AA
      AAD0/I8w8q1fMPKsHpPv3//4P/fg+PRgEAAA+vx7+BgICAZg/vyQHASA+vx0jB6CfzDyrIQYP8fg+P5gAAAEEPr+y/gYCAgGYP79KNRC0ASA+vx0jB6CfzDyrQQYP7fn8hQQ+vy7+BgICAZg/vwI0ECUgPr8dIwegn8w8qwOnN/P//uv8AAACJ0CnKRCnYD6/CAcDp3/7//4P4fg+OVQEAALr/AAAAZg/vyYnTKcIp+w+v040EEkhj0Ehp0oGAgIBIweogAcLB+B/B+gcp0AX/AAAA8w8qyIP9fg+POQEAAE
      SJ4L+BgICAZg/v0g+vxQHASA+vx0jB6CfzDyrQg/l+f4BEidi/gYCAgGYP78APr8EBwEgPr8dIwegn8w8qwOkr/P//uv8AAABmD+/SidAp6kQp4A+v0I0EEkhj0Ehp0oGAgIBIweogAcLB+B/B+gcp0AX/AAAA8w8q0On7/v//uv8AAABmD+/JidMpwin7D6/TjQQSSGPQSGnSgYCAgEjB6iABwsH4H8H6BynQBf8AAADzDyrI6Zn+//+6/wAAACnCOfoPjYgBAADzDxANAAAAALoAAP8AuP8AAAAp6EQ54A
      +NYAEAAPMPEBUAAAAAuwD/AAC4/wAAACnIRDnYD404AQAA8w8QBQAAAAC4/wAAAOmA+v//D6/Hv4GAgIBmD+/JAcBID6/HSMHoJ/MPKsiD/X4Pjsf+//+4/wAAAGYP79KJwinoRCniD6/CAcBIY9BIadKBgICASMHqIAHCwfgfwfoHKdAF/wAAAPMPKtDpqf7//4nCZg/vyWYP79K7AAEAAMHiCCn7Zg/vwL8AAQAAKcKJ0Jn3+7v/AAAAPf8AAAAPT8NEKedBvAABAADzDyrIiejB4Agp6Jn3/z3/AAAAD0
      /DRSnc8w8q0InIweAIKciZQff8Pf8AAAAPT8PzDyrA6Yj6//+NBHhmD+/JZg/v0rr+AQAAPf4BAABmD+/AD0/CLf8AAADzDyrIQo1EZQA9/gEAAA9Pwi3/AAAA8w8q0EKNBFk9/gEAAA9Pwi3/AAAA8w8qwOkz+v//McBmD+/A6U/5//8x22YP79Lpov7//zHSZg/vyel6/v//geKAAAAAiVQkHA+E+AAAAInCZg/vycHiCCnCuAABAAAp+I08AInQmff/uv8AAAA9/wAAAA9PwvMPKsiBZCQYgAAAAA+Fhg
      EAAL//AAAAZg/v0on6KeqJ1cHlCInoQ41sJAEp0Jn3/SnHD0h8JBjzDyrXgeOAAAAAD4UjAQAAv/8AAABmD+/AifopykONTBsBidDB4Agp0Jn3+SnHD0j78w8qx+lq+f//jRQHZg/vyWYP79IPr8e/gYCAgGYP78BID6/HSMHoJwHAKcJEieAPr8XzDyrKQY0ULEgPr8dIwegnAcApwkSJ2A+vwfMPKtJBjRQLSA+vx0jB6CcBwCnC8w8qwukK+f//uv8AAACNfD8BZg/vySnCidDB4ggpwonQmff/v/8AAA
      Apx4n4D0hEJBzzDyrI6QH///+JwoPHAWYP78m7/wAAAMHiCGYP79JmD+/AKcKJ0Jn3/0GNfCQBPf8AAAAPT8PzDyrIiejB4Agp6Jn3/z3/AAAAD0/DQYPDAfMPKtCJyMHgCCnImUH3+z3/AAAAD0/D8w8qwOlx+P//ichmD+/AweAIKci5AAEAAEQp2ZkByff5uv8AAAA9/wAAAA9PwvMPKsDpQ/j//4novwABAABmD+/SweAIRCnnKegB/5n3/7r/AAAAPf8AAAAPT8LzDyrQ6XX+//85xw+OgwAAACnHZg
      /vyfMPKs9BOex+Z0SJ4GYP79Ip6PMPKtBBOct+RUEpy2YP78DzQQ8qw+nb9///Zg/vyWYP79JmD+/AMdIp+EEPKNsPSMJEKeUPSOpEKdnzDyrID0jK8w8q1fMPKsHpn/b//0Qp2WYP78DzDyrB6Zf3//9EKeVmD+/S8w8q1euZKfhmD+/J8w8qyOl4////KchmD+/ARCnY8w8qwOlp9///KehmD+/SRCng8w8q0Oni9f//KcJmD+/JidAp+PMPKsjptPX//5CQAAB/Qw==
      )"
      else
      base64enc := "
      (LTrim Join
      2,x86:VVdWU4PsMItcJEyF2w+OdAIAAItUJFCF0g+OaAIAAItEJEzHRCQkAAAAAMHgAolEJAiNtgAAAACLRCQki3QkRIlMJAQx/4n9weACAcYDRCRIiQQkjXQmAIsOhckPhPgBAACLBCSJz8HvGIsYifqJ2MHoGDjCD0LHiEQkFITAD4QUAgAAidqJz4nYweoIwe8QiVQkLA+218HoEIN8JFQBiVQkGA+204lUJByJ+g+2+g+21YlEJCgPtsmJVCQgD7bAD4QSAQAAg3wkVAIPhM8BAACDfCRUAw+EBAIAAI
      N8JFQED4RRAgAAg3wkVAUPhM4CAACDfCRUBg+E8wIAAIN8JFQHD4R8AwAAg3wkVAgPhLoDAACDfCRUCQ+EfwQAAIN8JFQKD4RYBQAAg3wkVAsPhH4GAACDfCRUDA+EAAYAAIN8JFQND4TABgAAg3wkVA4PhPIHAACDfCRUDw+EWwcAAIN8JFQQD4R3CAAAg3wkVBEPhLAIAACDfCRUEg+FuAMAADn4D470CAAAu/8AAAApw4nYKfiJRCQMi1wkGIt8JCC4/wAAADn7D46/CAAAKdgp+IlEJBCLRCQcuv8AAA
      A5yA+OlwgAACnCKcqJVCQE6VYDAACNdCYAkItcJBg5+A9O+InQOdMPTsOJfCQMiUQkEItEJBw5yInCD0/RiVQkBItcJAy4AAAAAItMJAS/AAAAAIXbD0nDi1wkEIXbiUQkDA9J+7sAAAAAhcmJ2g9J0cHgEIl8JBCJw8HnCIlUJAQPtsqB4wAA/wAPt/+LRCQUCdnB4BgJwQn5iQ6LRCQIg8UBAQQkAcY5bCRQD4Xo/f//g0QkJAGLTCQEi0QkJDlEJEwPhbH9//+DxDC4AQAAAFteX13DjXQmAMcGAAAAAO
      u6D6/4u4GAgIAPr0wkHIn49+PB6geJVCQMi1QkGA+vVCQgidD344nIweoHiVQkEPfjweoHiVQkBOkj////jXQmAAHHuP8AAACLVCQYgf//AAAAD0z4A1QkIIH6/wAAAA9M0ANMJByNnwH///+B+f8AAACJXCQMD0zIjZoB////iVwkEI2BAf///4lEJATpzv7//420JgAAAAC6/wAAACn6idPB4wgp04najVgBidCZ9/u7/wAAALr/AAAAKcO4AAAAAA9JwytUJCCLXCQYiUQkDInQg8MBweAIKdCZ9/u7/w
      AAALr/AAAAKcO4AAAAAA9JwynKi0wkHIlEJBCJ0IPBAcHgCCnQmff5uv8AAAApwrgAAAAAD0nCiUQkBOk//v//OfiLXCQYD034i0QkIDnDiXwkDA9Nw4lEJBCLRCQcOciJwg9M0YlUJATpEf7//2aQuv8AAAC7gYCAgCnCuP8AAAAp+InXD6/4ifj364n4wfgfAfrB+gcp0Lr/AAAAK1QkGAX/AAAAideJRCQMuP8AAAArRCQgD6/4ifj364n4wfgfAfrB+gcp0Lr/AAAAK1QkHAX/AAAAiUQkELj/AAAAKc
      iJ0Q+vyInI9+uNHArB+R/B+wcp2Y2B/wAAAIlEJATpe/3//wH4u/8AAACLVCQcPf8AAAAPTtiLRCQYA0QkID3/AAAAiVwkDLv/AAAAD07YAcq4/wAAAIH6/wAAAA9OwolcJBCJRCQE6TL9//+D+H4Pj3QBAAAPr/i6gYCAgI0EP/fiweoHiVQkDItEJBiD+H4PjxgBAAAPr0QkILqBgICAAcD34sHqB4lUJBCLRCQcg/h+f08Pr8iNBAm6gYCAgPfiweoHiVQkBItEJAyFwHkIgUQkDP8AAACLRCQQhcB5CQ
      X/AAAAiUQkEItEJASFwA+Jqfz//wX/AAAAiUQkBOmb/P//uv8AAAC4/wAAACtUJBwpyInRuoGAgIAPr8gByYnI9+qNBArB+R/B+AeJyinCjYL/AAAAiUQkBOuMg/9+D44+AQAAuv8AAAApwrj/AAAAKfgPr8K6gYCAgI0cAInY9+qJ2MH4HwHai1wkIMH6BynQBf8AAACJRCQMg/t+D48fAQAAi0QkGLqBgICAD6/DAcD34sHqB4lUJBCD+X4Pj1////8Pr0wkHOkJ////uv8AAAC4/wAAACtUJBgrRCQgD6
      /CuoGAgICNHACJ2PfqidjB+B8B2sH6BynQBf8AAACJRCQQ6cL+//+6/wAAACnCuP8AAAAp+A+vwrqBgICAjRwAidj36onYwfgfAdrB+gcp0AX/AAAAiUQkDOlp/v//uv8AAAC7AAD/ACn6vwAAAAA5wrj/AAAAifoPTccPTd+/AP8AAIlEJAy4/wAAACtEJCA7RCQYuP8AAAAPTcIPTfqJRCQQuP8AAAApyDtEJBy4/wAAAA9NwolEJASJweln+///D6/HuoGAgICLXCQgAcD34sHqB4lUJAyD+34PjuH+//
      +6/wAAALj/AAAAK1QkGCtEJCAPr8K6gYCAgI0cAInY9+qJ2MH4HwHawfoHKdAF/wAAAIlEJBDpvf7//4n6uwABAADB4ggp+onfKceJ0Jn3/7//AAAAido9/wAAAA9Px4t8JCArVCQYiUQkDIn4weAIKfiJ15n3/7//AAAAPf8AAAAPT8eJRCQQicjB4AgpyInZK0wkHJn3+br/AAAAPf8AAAAPTtCJVCQE6U36//+NFEe4/gEAAIt8JBiB+v4BAAAPT9CNmgH///+JXCQMi1wkII0Ue4H6/gEAAA9P0I2aAf
      ///4lcJBCLXCQcjRRZgfr+AQAAD0/QjYIB////iUQkBOkf/f//i1QkKIHigAAAAIlUJAQPhPsAAACJ+sHiCCn6vwABAAApx4nQjTw/mff/v/8AAAA9/wAAAA9Px4lEJAyLfCQsgeeAAAAAD4VdAQAAuv8AAAArVCQgidDB4Agp0A+2141UEgGJVCQEmfd8JAS6/wAAACnCD0n6iXwkEIHjgAAAAA+FDAEAALr/AAAAKcqLTCQcidDB4AiNTAkBKdCZ9/m6/wAAACnCD0naiVwkBOlE+f//jRw4D6/HiVwkBL
      uBgICAi3wkBPfjidCLVCQgwegHAcApx4tEJBiJfCQMiccPr8IB1/fjidDB6AcBwCnHi0QkHIl8JBCNPAgPr8H344nQwegHAcApx4l8JATpEPz//7r/AAAAKfqJ18HiCCn6jXwAAYnQmff/v/8AAAApx4tEJAQPSceJRCQM6f7+//+J+o1YAcHiCCn6v/8AAACJ0Jn3+4tcJCA9/wAAAA9Px4lEJAyJ2MHgCCnYi1wkGJmDwwH3+z3/AAAAD0/HiUQkEInIweAIKciLTCQcg8EB6f79//+JyMHgCCnIuQABAA
      ArTCQcAcnp5/3//4t8JCC6AAEAACtUJBiJ+MHgCCn4jTwSmff/v/8AAAA9/wAAAA9Px4lEJBDpof7//4nCifspwyn6OfiLfCQgD07Ti1wkGIlUJAyJ2In6Kdop+Dn7i1wkHA9OwonKKdqJRCQQidgpyDnLD07CiUQkBOkD+///Kce4AAAAALsAAAAAD0nHiUQkDItEJCArRCQYD0nYK0wkHLgAAAAAD0nBiVwkEIlEJATpovf//ynKK1QkHIlUJATpvfr//ytEJCArRCQYiUQkEOk49///uv8AAAAp+inCiV
      QkDOkJ9///
      )"
      mCodeFunc := Gdip_RunMCode(base64enc)
  }
  Gdip_GetImageDimensions(pBitmap, w, h)
  Gdip_GetImageDimensions(pBitmap2Blend, w2, h2)
  If (w2!=w || h2!=h || !pBitmap || !pBitmap2Blend)
     Return 0
  E1 := Gdip_LockBits(pBitmap, 0, 0, w, h, stride, iScan, iData)
  E2 := Gdip_LockBits(pBitmap2Blend, 0, 0, w, h, stride, mScan, mData)
  If (!E1 && !E2)
     r := DllCall(mCodeFunc, "UPtr", iScan, "UPtr", mScan, "Int", w, "Int", h, "Int", blendMode)
  If !E1
     Gdip_UnlockBits(pBitmap, iData)
  If !E2
     Gdip_UnlockBits(pBitmap2Blend, mData)
  return r
}
Gdip_BoxBlurBitmap(pBitmap, passes) {
  static mCodeFunc := 0
  if (mCodeFunc=0)
  {
      if (A_PtrSize=8)
      base64enc := "
      (LTrim Join
      2,x64:QVdBVkFVQVRVV1ZTSIPsWESLnCTAAAAASImMJKAAAABEicCJlCSoAAAARImMJLgAAABFhdsPjtoDAABEiceD6AHHRCQ8AAAAAEG+q6qqqkEPr/lBD6/BiXwkBInXg+8BiUQkJIn4iXwkOEiNdIEESPfYSIl0JEBIjTSFAAAAAI0EvQAAAABJY/lImEiJdCRISI1EBvxIiXwkCEiJRCQwRInI99hImEiJRCQQDx9EAABIi0QkQMdEJCAAAAAASIlEJBhIi0QkSEiD6ARIiUQkKItEJASFwA+OegEAAA8fQABEi4wkqAAAAEWFyQ+OPwMAAEiLRCQoTIt8JBgx9jHbRTHbRTHSRTHJRTHATAH4Mckx0mYPH0QAAEWJ1UQPtlADRYn
      cRA+2WAJEAepEAeGJ3Q+2WAFEAdJBAeiJ9w+2MEkPr9ZBAflIg8AESMHqIYhQ/0KNFBlEieFJD6/WSMHqIYhQ/kGNFBhBiehJD6/WSMHqIYhQ/UGNFDFBiflJD6/WSMHqIYhQ/ESJ6kw5+HWJi3wkOEiLRCQwMfYx20gDRCQYRTHbRTHSRTHJRTHAMckx0g8fgAAAAABFiddED7ZQA0WJ3UQPtlgCRAH6RAHpQYncD7ZYAUQB0kUB4In1D7YwSQ+v1kEB6YPvAUiD6ARIweohiFAHQo0UGUSJ6UkPr9ZIweohiFAGQY0UGEWJ4EkPr9ZIweohiFAFQY0UMUGJ6UkPr9ZIweohiFAERIn6g///dYWLvCS4AAAASItcJAgBfCQgi0QkIEgB
      XCQYO0QkBA+Miv7//0SLhCSoAAAAx0QkGAMAAADHRCQgAAAAAEWFwA+OiAEAAGYPH4QAAAAAAItUJASF0g+OpAAAAEhjRCQYMf8x9jHbSAOEJKAAAABFMdtFMdIxyUUxyUUxwDHSkEWJ10QPthBFid1ED7ZY/0QB+kQB6UGJ3A+2WP5EAdJFAeCJ9Q+2cP1JD6/WQQHpA7wkuAAAAEjB6iGIEEKNFBlEielJD6/WSMHqIYhQ/0GNFBhFieBJD6/WSMHqIYhQ/kGNFDFBielJD6/WSMHqIYhQ/UgDRCQIRIn6O3wkBHyAi0wkJIXJD4ioAAAATGNUJCRIY0QkGDH/MfYx20Ux20UxyUUxwEwB0DHJSAOEJKAAAAAx0g8fQABFid9ED7YYQ
      YndD7ZY/0QB+kQB6UGJ9A+2cP5EAdpFAeCJ/Q+2eP1JD6/WQQHpSMHqIYgQjRQZSItMJBBJD6/WSQHKSMHqIYhQ/0GNFDBFieBJD6/WSMHqIYhQ/kGNFDlBielJD6/WSMHqIYhQ/UgByESJ+kSJ6UWF0nmEg0QkIAGLRCQgg0QkGAQ5hCSoAAAAD4WB/v//g0QkPAGLRCQ8OYQkwAAAAA+Fm/z//0iDxFhbXl9dQVxBXUFeQV/DZi4PH4QAAAAAAESLVCQ4RYXSD4j1/f//6Uz9//8=
      )"
      else
      base64enc := "
      (LTrim Join
      2,x86:VVdWU4PsPItsJGCLRCRYhe0PjncEAACLfCRcx0QkNAAAAAAPr/iD6AEPr0QkXIl8JCSLfCRUiUQkLItEJFCD7wGJfCQwi3wkVI0EuIlEJDiLRCQ4x0QkKAAAAACJRCQgi0QkJIXAD47pAQAAjXQmAIt0JFSF9g+OJAQAAMdEJAwAAAAAi0wkKDHtMf/HRCQYAAAAAANMJFAx9jHAx0QkFAAAAADHRCQQAAAAAI10JgCLVCQMD7ZZA4k0JIPBBA+2cf6JfCQEiVQkHAHCD7Z5/QHaiVwkDLurqqqqidCJbCQID7Zp/Pfji1wkEAMcJNHqiFH/idq7q6qqqgHyidD344tcJBQDXCQE0eqIUf6J2rurqqqqAfqJ0Pfj0eqIUf2LVCQ
      YA1QkCAHqidD344scJItEJByJXCQQi1wkBNHqiVwkFItcJAiIUfyJXCQYO0wkIA+FWf///4tEJDDHBCQAAAAAMe0x/8dEJBwAAAAAi0wkIDH2x0QkGAAAAADHRCQUAAAAAIlEJAQxwI22AAAAAIscJA+2Uf+JdCQIg+kED7ZxAol8JAyJFCSNFBgDFCSJ0LqrqqqqD7Z5AYlsJBD34g+2KYNsJAQB0eqIUQOLVCQUA1QkCAHyidC6q6qqqvfi0eqIUQKLVCQYA1QkDAH6idC6q6qqqvfi0eqIUQGLVCQcA1QkEAHqidC6q6qqqvfiidiLXCQIiVwkFItcJAzR6ogRi1QkBIlcJBiLXCQQiVwkHIP6/w+FVf///4t8JFwBfCQoAXwkIItE
      JCg7RCQkD4wb/v//i0QkUItcJFTHRCQoAAAAAPfYiUQkDIXbD44IAgAAjXQmAJCLVCQkhdIPjugAAAAx9otMJAzHRCQIAAAAADHtx0QkGAAAAAAx/zHAx0QkFAAAAAD32cdEJBAAAAAAiTQkjXYAi1QkCA+2cQOJfCQEixwkD7Z5AYlUJCABwgHyiXQkCL6rqqqqidCJXCQcD7ZZAvfmi3QkHItEJBCJHCSJ6w+2KQHwiXQkEIt0JAzR6ohRA4sUJAHCidC6q6qqqvfii0QkFANEJATR6ohRAonCAfqJ0Lqrqqqq9+KLRCQYiVwkGAHY0eqIUQGJwgHqidC6q6qqqvfii0QkINHqiBGLVCQEA0wkXIlUJBSNFDE5VCQkD49M////i0wkL
      IXJD4jrAAAAMfbHRCQQAAAAAItMJCwx7cdEJBwAAAAAK0wkDDH/McDHRCQYAAAAAMdEJBQAAAAAiTQkjXQmAJCLHCSLVCQQiXwkBA+2cQMPtnkBiWwkCIlcJCAPtlkCiXQkEA+2KYkcJInTAcIB8r6rqqqqidD35ot0JCCLRCQUAfCJdCQUi3QkDNHqiFEDixQkAcKJ0Lqrqqqq9+KLRCQYA0QkBNHqiFECicIB+onQuquqqqr34otEJBwDRCQI0eqIUQGJwgHqidC6q6qqqvfiidjR6ogRi1QkBCtMJFyJVCQYi1QkCAHOiVQkHA+JTf///4NEJCgBi0QkKINsJAwEOUQkVA+F/f3//4NEJDQBi0QkNDlEJGAPhcL7//+DxDxbXl9dw4
      20JgAAAACNdgCLfCQwhf8PiI/9///ppvz//w==
      )"
      mCodeFunc := Gdip_RunMCode(base64enc)
  }
  Gdip_GetImageDimensions(pBitmap,w,h)
  E1 := Gdip_LockBits(pBitmap,0,0,w,h,stride,iScan,iData)
  If E1
     Return
  r := DllCall(mCodeFunc, "UPtr",iScan, "Int",w, "Int",h, "Int",stride, "Int",passes)
  Gdip_UnlockBits(pBitmap,iData)
  return r
}
Gdip_RunMCode(mcode) {
  static e := {1:4, 2:1}
       , c := (A_PtrSize=8) ? "x64" : "x86"
  if (!regexmatch(mcode, "^([0-9]+),(" c ":|.*?," c ":)([^,]+)", m))
     return
  if (!DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", StrLen(m3), "uint", e[m1], "ptr", 0, "uintp", s, "ptr", 0, "ptr", 0))
     return
  p := DllCall("GlobalAlloc", "uint", 0, "ptr", s, "ptr")
     DllCall("VirtualProtect", "ptr", p, "ptr", s, "uint", 0x40, "uint*", op)
  if (DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", StrLen(m3), "uint", e[m1], "ptr", p, "uint*", s, "ptr", 0, "ptr", 0))
     return p
  DllCall("GlobalFree", "ptr", p)
}
calcIMGdimensions(imgW, imgH, givenW, givenH, ByRef ResizedW, ByRef ResizedH) {
   PicRatio := Round(imgW/imgH, 5)
   givenRatio := Round(givenW/givenH, 5)
   If (imgW<=givenW && imgH<=givenH)
   {
      ResizedW := givenW
      ResizedH := Round(ResizedW / PicRatio)
      If (ResizedH>givenH)
      {
         ResizedH := (imgH <= givenH) ? givenH : imgH
         ResizedW := Round(ResizedH * PicRatio)
      }
   } Else If (PicRatio>givenRatio)
   {
      ResizedW := givenW
      ResizedH := Round(ResizedW / PicRatio)
   } Else
   {
      ResizedH := (imgH >= givenH) ? givenH : imgH         ;set the maximum picture height to the original height
      ResizedW := Round(ResizedH * PicRatio)
   }
}
GetWindowRect(hwnd, ByRef W, ByRef H) {
   If !hwnd
      Return
   size := VarSetCapacity(rect, 16, 0)
   er := DllCall("dwmapi\DwmGetWindowAttribute"
      , "UPtr", hWnd  ; HWND  hwnd
      , "UInt", 9     ; DWORD dwAttribute (DWMWA_EXTENDED_FRAME_BOUNDS)
      , "UPtr", &rect ; PVOID pvAttribute
      , "UInt", size  ; DWORD cbAttribute
      , "UInt")
   If er
      DllCall("GetWindowRect", "UPtr", hwnd, "UPtr", &rect, "UInt")
   r := []
   r.x1 := NumGet(rect, 0, "Int"), r.y1 := NumGet(rect, 4, "Int")
   r.x2 := NumGet(rect, 8, "Int"), r.y2 := NumGet(rect, 12, "Int")
   r.w := Abs(max(r.x1, r.x2) - min(r.x1, r.x2))
   r.h := Abs(max(r.y1, r.y2) - min(r.y1, r.y2))
   W := r.w
   H := r.h
   Return r
}
Gdip_BitmapConvertGray(pBitmap, hue:=0, vibrance:=-40, brightness:=1, contrast:=0, KeepPixelFormat:=0) {
    Gdip_GetImageDimensions(pBitmap, Width, Height)
    If (KeepPixelFormat=1)
       PixelFormat := Gdip_GetImagePixelFormat(pBitmap, 1)
    If StrLen(KeepPixelFormat)>3
       PixelFormat := KeepPixelFormat
    newBitmap := Gdip_CreateBitmap(Width, Height, PixelFormat)
    G := Gdip_GraphicsFromImage(newBitmap, InterpolationMode)
    If (hue!=0 || vibrance!=0)
       pEffect := Gdip_CreateEffect(6, hue, vibrance, 0)
    matrix := GenerateColorMatrix(2, brightness, contrast)
    If pEffect
    {
       E := Gdip_DrawImageFX(G, pBitmap, 0, 0, 0, 0, Width, Height, matrix, pEffect)
       Gdip_DisposeEffect(pEffect)
    } Else
       E := Gdip_DrawImage(G, pBitmap, 0, 0, Width, Height, 0, 0, Width, Height, matrix)
    Gdip_DeleteGraphics(G)
    Return newBitmap
}
Gdip_BitmapSetColorDepth(pBitmap, bitsDepth, useDithering:=1) {
   ditheringMode := (useDithering=1) ? 9 : 1
   If (useDithering=1 && bitsDepth=16)
      ditheringMode := 2
   Colors := 2**bitsDepth
   If bitsDepth Between 2 and 4
      bitsDepth := "40s"
   If bitsDepth Between 5 and 8
      bitsDepth := "80s"
   If (bitsDepth="BW")
      E := Gdip_BitmapConvertFormat(pBitmap, 0x30101, ditheringMode, 2, 2, 2, 2, 0, 0)
   Else If (bitsDepth=1)
      E := Gdip_BitmapConvertFormat(pBitmap, 0x30101, ditheringMode, 1, 2, 1, 2, 0, 0)
   Else If (bitsDepth="40s")
      E := Gdip_BitmapConvertFormat(pBitmap, 0x30402, ditheringMode, 1, Colors, 1, Colors, 0, 0)
   Else If (bitsDepth="80s")
      E := Gdip_BitmapConvertFormat(pBitmap, 0x30803, ditheringMode, 1, Colors, 1, Colors, 0, 0)
   Else If (bitsDepth=16)
      E := Gdip_BitmapConvertFormat(pBitmap, 0x21005, ditheringMode, 1, Colors, 1, Colors, 0, 0)
   Else If (bitsDepth=24)
      E := Gdip_BitmapConvertFormat(pBitmap, 0x21808, 2, 1, 0, 0, 0, 0, 0)
   Else If (bitsDepth=32)
      E := Gdip_BitmapConvertFormat(pBitmap, 0x26200A, 2, 1, 0, 0, 0, 0, 0)
   Else If (bitsDepth=64)
      E := Gdip_BitmapConvertFormat(pBitmap, 0x34400D, 2, 1, 0, 0, 0, 0, 0)
   Else
      E := -1
   Return E
}
Gdip_BitmapConvertFormat(pBitmap, PixelFormat, DitherType, DitherPaletteType, PaletteEntries, PaletteType, OptimalColors, UseTransparentColor:=0, AlphaThresholdPercent:=0) {
   VarSetCapacity(hPalette, 4 * PaletteEntries + 8, 0)
   NumPut(PaletteType, &hPalette, 0, "uint")
   NumPut(PaletteEntries, &hPalette, 4, "uint")
   NumPut(0, &hPalette, 8, "uint")
   E1 := DllCall("gdiplus\GdipInitializePalette", "UPtr", &hPalette, "uint", PaletteType, "uint", OptimalColors, "Int", UseTransparentColor, "UPtr", pBitmap)
   E2 := DllCall("gdiplus\GdipBitmapConvertFormat", "UPtr", pBitmap, "uint", PixelFormat, "uint", DitherType,   "uint", DitherPaletteType,   "UPtr", &hPalette, "float", AlphaThresholdPercent)
   E := E1 ? E1 : E2
   Return E
}
Gdip_GetImageThumbnail(pBitmap, W, H) {
    DllCall("gdiplus\GdipGetImageThumbnail"
        ,"UPtr",pBitmap                         
        ,"UInt",W                               
        ,"UInt",H                              
        ,"UPtr*",pThumbnail                     
        ,"UPtr",0                              
        ,"UPtr",0)
   Return pThumbnail
}
ConvertRGBtoHSL(R, G, B) {
   SetFormat, float, 0.5
   R := (R / 255)
   G := (G / 255)
   B := (B / 255)
   Min     := min(R, G, B)
   Max     := max(R, G, B)
   del_Max := Max - Min
   L := (Max + Min) / 2
   if (del_Max = 0)
   {
      H := S := 0
   } else
   {
      if (L < 0.5)
         S := del_Max / (Max + Min)
      else
         S := del_Max / (2 - Max - Min)
      del_R := (((Max - R) / 6) + (del_Max / 2)) / del_Max
      del_G := (((Max - G) / 6) + (del_Max / 2)) / del_Max
      del_B := (((Max - B) / 6) + (del_Max / 2)) / del_Max
      if (R = Max)
      {
         H := del_B - del_G
      } else
      {
         if (G = Max)
            H := (1 / 3) + del_R - del_B
         else if (B = Max)
            H := (2 / 3) + del_G - del_R
      }
      if (H < 0)
         H += 1
      if (H > 1)
         H -= 1
   }
   return [abs(round(h*360, 3)), abs(s), abs(l)]
}
ConvertHSLtoRGB(H, S, L) {
   H := H/360
   if (S == 0)
   {
      R := L*255
      G := L*255
      B := L*255
   } else
	   {
		  if (L < 0.5)
			 var_2 := L * (1 + S)
		  else
			 var_2 := (L + S) - (S * L)
		  var_1 := 2 * L - var_2
		  R := 255 * ConvertHueToRGB(var_1, var_2, H + (1 / 3))
		  G := 255 * ConvertHueToRGB(var_1, var_2, H)
		  B := 255 * ConvertHueToRGB(var_1, var_2, H - (1 / 3))
	   }
   Return [round(R), round(G), round(B)]
}
ConvertHueToRGB(v1, v2, vH) {
   vH := ((vH<0) ? ++vH : vH)
   vH := ((vH>1) ? --vH : vH)
   return  ((6 * vH) < 1) ? (v1 + (v2 - v1) * 6 * vH)
         : ((2 * vH) < 1) ? (v2)
         : ((3 * vH) < 2) ? (v1 + (v2 - v1) * ((2 / 3) - vH) * 6)
         : v1
}
Gdip_ErrorHandler(errCode, throwErrorMsg, additionalInfo:="") {
   Static errList := {1:"Generic_Error", 2:"Invalid_Parameter"
         , 3:"Out_Of_Memory", 4:"Object_Busy"
         , 5:"Insufficient_Buffer", 6:"Not_Implemented"
         , 7:"Win32_Error", 8:"Wrong_State"
         , 9:"Aborted", 10:"File_Not_Found"
         , 11:"Value_Overflow", 12:"Access_Denied"
         , 13:"Unknown_Image_Format", 14:"Font_Family_Not_Found"
         , 15:"Font_Style_Not_Found", 16:"Not_TrueType_Font"
         , 17:"Unsupported_GdiPlus_Version", 18:"Not_Initialized"
         , 19:"Property_Not_Found", 20:"Property_Not_Supported"
         , 21:"Profile_Not_Found", 100:"Unknown_Wrapper_Error"}
   If !errCode
      Return
   aerrCode := (errCode<0) ? 100 : errCode
   If errList.HasKey(aerrCode)
      GdipErrMsg := "GDI+ ERROR: " errList[aerrCode]  " [CODE: " aerrCode "]" additionalInfo
   Else
      GdipErrMsg := "GDI+ UNKNOWN ERROR: " aerrCode additionalInfo
   If (throwErrorMsg=1)
      MsgBox, % GdipErrMsg
   Return GdipErrMsg
}
NonNull(ByRef var, DefaultValue, MinValue:="", MaxValue:="")		
{
	var:= var="" ? DefaultValue : MinValue="" ? (MaxValue="" ? var : Min(var, MaxValue)) : (MaxValue!="" ? Max(Min(var, MaxValue), MinValue) : Max(var, MinValue))
}
NonNull_Ret(var, DefaultValue, MinValue:="", MaxValue:="")			
{
	return, var="" ? DefaultValue : MinValue="" ? (MaxValue="" ? var : Min(var, MaxValue)) : (MaxValue!="" ? Max(Min(var, MaxValue), MinValue) : Max(var, MinValue))
}
symlink(ffpath,ByRef target="", ByRef type="")
	{
		SplitPath, ffpath , FfName, DfPath,
		objShell :=   ComObjCreate("Shell.Application")
		objFolder :=   objShell.NameSpace(DfPath)      ;set the directry path
		objFolderItem :=   objFolder.ParseName(FfName)   ;set the file name
		att := objFolder.GetDetailsOf(objFolderItem, 6)
		target := objFolder.GetDetailsOf(objFolderItem, 189)
		if (att="DL")
			return 1
		else
			return 0
	}
;}#################################  FUNCTIONS LOADED #################################
;########################################################################################