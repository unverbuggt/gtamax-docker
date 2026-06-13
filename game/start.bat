@ECHO OFF
rem overwrite DOS4GW.EXE, otherwise London won't start
copy /Y DOS32A.EXE GTA1-MAX\GTADOS\DOS4GW.EXE
cd GTA1-MAX

########
# PANELS
########

:mainmenu
cls
type GTADOS\GTASPLSH.ANS
@choice /c1234 /n [29C Make a choice [1-4]:

if errorlevel 4 goto readme
if errorlevel 3 goto london61
if errorlevel 2 goto london69
if errorlevel 1 goto gta1

:gta1
@echo off
cls
type GTADOS\GTASPLS3.ANS
@echo.
@choice /c12 /n [29C Make a choice [1-2]:

if errorlevel 2 goto mainmenu
if errorlevel 1 goto rungta1

:london69
@echo off
cls
type GTADOS\GTASPLS1.ANS
@choice /c12 /n [1;30m[56C Make a choice [1-2]:

if errorlevel 2 goto mainmenu
if errorlevel 1 goto runlondon69

:london61
@echo off
cls
type GTADOS\GTASPLS2.ANS
@choice /c12 /n [1;30m[56C Make a choice [1-2]:

if errorlevel 2 goto mainmenu
if errorlevel 1 goto runlondon61

:readme
GTADOS\LIST README.TXT
goto mainmenu


#################
# RUN EXECUTABLES
#################

:rungta1
@echo off
cls
imgmount d ".\MUSIC\GTA\CDAUDIO.DAT" -t cdrom -fs iso
CD GTADOS
GTA24.EXE
imgmount -u d
cd ..
goto mainmenu

:runlondon69
@echo off
cls
imgmount d ".\MUSIC\LONDON\CDAUDIO.DAT" -t cdrom -fs iso
CD GTADOS
del DUMP*.TGA
GTA24_UK.EXE
del DUMP*.TGA
imgmount -u d
cd ..
goto mainmenu

:runlondon61
@echo off
cls
imgmount d ".\MUSIC\LONDON\CDAUDIO.DAT" -t cdrom -fs iso
CD GTADOS
GTA24_61.EXE
imgmount -u d
cd ..
goto mainmenu
