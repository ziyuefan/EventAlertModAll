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
rem set wowfolder=D:\World of Warcraft
set wowfolder=..\..\..\..\..
set servertype=retail
set addon1=EventAlertMod
set addon2=!Lib_ZYF
set srcpath1=D:\WOW\UI\%addon1%\Lastest
set srcpath2=D:\WOW\UI\%addon2%\Lastest

xcopy /D /S /E /Y %srcpath1% "%wowfolder%\_ptr_\Interface\Addons\%addon1%\" 
xcopy /D /S /E /Y %srcpath1% "%wowfolder%\_retail_\Interface\Addons\%addon1%\" 
xcopy /D /S /E /Y %srcpath1% "%wowfolder%\_classic_ptr_\Interface\Addons\%addon1%\" 
xcopy /D /S /E /Y %srcpath1% "%wowfolder%\_classic_\Interface\Addons\%addon1%\" 

xcopy /D /S /E /Y %srcpath2% "%wowfolder%\_ptr_\Interface\Addons\%addon2%\" 
xcopy /D /S /E /Y %srcpath2% "%wowfolder%\_retail_\Interface\Addons\%addon2%\" 
xcopy /D /S /E /Y %srcpath2% "%wowfolder%\_classic_ptr_\Interface\Addons\%addon2%\" 
xcopy /D /S /E /Y %srcpath2% "%wowfolder%\_classic_\Interface\Addons\%addon2%\" 

explorer "%srcpath1%"
pause