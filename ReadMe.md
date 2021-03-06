## Use Case

Creates a specialized launcher and profile-folder (jacket) for each game which houses the game's shortcut/s and isolates settings such as keyboad-mapping and monitor layout.

Games not installed through steam/gog/epic/origin/etc are detected and given a proper name:

Release/build versions, group-names and other extranious title-info is culled to facilitate importing into a frontend.

Antimicro/X, Xpadder, JoyXoff, Joy2Key keymappers are supported.


## Installation
This Version:0.99.68.499

This Build: 2022-05-22 8:50 PM

Run the installer or extract the binary to a location of your choice, **or** download and build and run the source files and executables.
```sh
v0rt3X
+-- bin
?   +-- aria2c.exe
?   +-- 7za.exe
?   +-- lrDeploy.exe
?   +-- NewOSK.exe
?   +-- jkvtx.exe
?   +-- Setup.exe
?   +-- Source_Builder.exe
?   +-- Update.exe
?
+-- site
?   +-- img
?       +-- Install.png
?       +-- key.png
?       +-- runas.png
?       +-- Setup.png
?       +-- Tip.png
?       +-- Update.png
|
?   +-- index.html
?   +-- Hermit-Regular.otf
?   +-- key.ico
?   +-- ReadMe.md
?   +-- TruenoLt.otf
?   +-- version.txt
?
+-- src
?   +-- absol.set
?   +-- am_GameTemplate.set
?   +-- am_DesktopTemplate.set
?   +-- am_Trigger.set
?   +-- ax_GameTemplate.set
?   +-- ax_DesktopTemplate.set
?   +-- ax_Trigger.set
?   +-- build.ahk
?   +-- Buildtools.set
?   +-- cmdtemplate.set
?   +-- Deploy.ico
?   +-- exclfnms.set
?   +-- exez.set
?   +-- Install.ico
?   +-- jk_GameTemplate.set
?   +-- jk_DestktopTemplate.set
?   +-- jk_Trigger.set
?   +-- Joystick.ico
?   +-- jkvtx.ahk
?   +-- lrDeploy.ahk
?   +-- lrDeploy.set
?   +-- newosk.ahk
?   +-- NewOSK.ico
?   +-- ox_DesktopTemplate.set
?   +-- ox_GameTemplate.set
?   +-- ox_Trigger.set
?   +-- rabsol.set
?   +-- readme.set
?   +-- repos.set
?   +-- RJDB.set
?   +-- rlsgrps.set
?   +-- Run.ico
?   +-- Setup.ico
?   +-- Setup.ahk
?   +-- Source_Builder.ico
?   +-- Steamlkp.set
?   +-- unlike.set
?   +-- unsel.set
?   +-- Update.ahk
?   +-- xp_GameTemplate.set
?   +-- xp_DesktopTemplate.set
?   +-- xp_Trigger.set
?
+-- README.md
```
# Documentation

[Detailed Docs can be found here](https://oldtools.github.io/v0rt3X)

# Setup

Setup (bin\Setup.exe) configures v0rt3X. Initializing the tool will index your drives for common game folders used by many delivery providers.

Steam and other digital-delivery providers' games detected will be added as entities indipendently in the source list regardless of where they may appear in your global libraries.

Use the "SRC" button to add a folder/s where games have been installed. EG: C:\Games, or C:\Program Files

Use the "OUT" button to set the location for the shortcuts.

The "GPD" button will set the location where profile folders for each game will be kept.

Right-Click on the buttons in the setup tool to download supported executables.

![AsAdmin](https://oldtools.github.io/v0rt3X/img/Setup.png)

## Launching Games

It is not necessary, but recommended to enable the RunAsAdmin option.
Ideally, v0rt3X can run entirely in userspace, however many games require administrator access and manipulating hardware at the user-level is often unreliable.

![AsAdmin](https://oldtools.github.io/v0rt3X/runas.png)

During gameplay you may modify and/or create additional joystick profiles and any found within the game's jacket will be saved and reloaded for player 2/3/4, prioritizing the default profile-name eg: game-name/_#.gamecontroller.amgp, and other "player#" monikers.)

# Building or compiling from source

The lrdeploy.exe file will compile and deploy v0rt3X project source files and website to github.

Included with the binary installer or portable version are 7za.exe and aria2c.exe, both of which are required for v0rt3X to operate properly.
