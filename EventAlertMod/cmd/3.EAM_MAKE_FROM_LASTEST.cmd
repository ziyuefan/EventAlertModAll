@echo off
set YEAR=%DATE:~0,4%
set MONTH=%DATE:~5,2%
set DAY=%DATE:~8,2%

set YEAR=%YEAR: =0%
set MONTH=%MONTH: =0%
set DAY=%DAY: =0%

SET MYDATE=%YEAR%.%MONTH%.%DAY%
rem *** Get Hour,Minute,Second by Another method

set HH=%TIME:~0,2%
set MM=%TIME:~3,2%
set SS=%TIME:~6,2%

set HH=%HH: =0%
set MM=%MM: =0%
set SS=%SS: =0%

set MYTIME=%HH%%MM%
REM set wowfolder=D:\World of Warcraft
set wowfolder=..\..\..\..\..
set servertype=retail
set addon1=EventAlertMod
set addon2=!Lib_ZYF
set srcpath1=D:\WOW\UI\%addon1%\Lastest
set srcpath2=D:\WOW\UI\%addon2%\Lastest

rd /Q /S D:\WOW\UI\Temp

xcopy /D /S /E /Y /F /EXCLUDE:exclude.txt %srcpath1%\*.* D:\WOW\UI\Temp\%addon1%
xcopy /D /S /E /Y /F %srcpath2%\*.* D:\WOW\UI\Temp\%addon2%

set srcpath1=D:\WOW\UI\Temp\%addon1%
set srcpath2=D:\WOW\UI\Temp\%addon2%

set destpath=D:\WOW\UI\%addon1%
set ver_DF=10.0.7
set ver_WOTLKC=3.4.1
set wowversion=DF%ver_DF%_WOTLKC%ver_WOTLKC%

REM "C:\Program Files\7-Zip\7z.exe" a "%destpath%\%addon1%_%wowversion%_%MYDATE%_%MYTIME%.zip" "%srcpath1%" -xr!.* -xr!Unuse  -xr!ChatGPT  -xr!cmd
REM "C:\Program Files\7-Zip\7z.exe" a "%destpath%\%addon1%_%wowversion%_%MYDATE%_%MYTIME%.zip" "%srcpath2%" -xr!.* -xr!Unuse  -xr!ChatGPT  -xr!cmd
"C:\Program Files\7-Zip\7z.exe" a "%destpath%\%addon1%_%wowversion%_%MYDATE%_%MYTIME%.zip" "%srcpath1%" 
"C:\Program Files\7-Zip\7z.exe" a "%destpath%\%addon1%_%wowversion%_%MYDATE%_%MYTIME%.zip" "%srcpath2%" 
explorer "%destpath%"
pause