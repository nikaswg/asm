@echo off

rem Скрипт должен выполняться из Program Files\SchoolPak

rem call cmd\settings.cmd

@rem start dosbox\dosbox -noconsole -conf dosbox\scpak.cfg -c "mount x '%CD%\pak' %SCP_READONLY% -label SCPAK" %SCP_NETHOME% -c "mount y '%HOMEDRIVE%%HOMEPATH%\Documents'" -c "mount y '%HOMEDRIVE%%HOMEPATH%\My Documents'" -c "mount y '%HOMEDRIVE%%HOMEPATH%\?Rр эRтЈї?-ў«'" -c "mount y '%HOMEDRIVE%%HOMEPATH%'" %* -c "X:\LAUNCH.BAT"

start dosbox\dosbox -noconsole -conf dosbox\scpak.cfg -c "mount x '%CD%\pak' %SCP_READONLY% -label SCPAK" -c "mount y 'D:\Turbo'" %* -c "X:\LAUNCH.BAT"

