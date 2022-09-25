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
set wowfolder=D:\World of Warcraft
set servertype=retail
set addon1=EventAlertMod
set addon2=!Lib_ZYF
set srcpath1=%wowfolder%\_%servertype%_\Interface\Addons\%addon1%\
set srcpath2=%wowfolder%\_%servertype%_\Interface\Addons\%addon2%\
set destpath1=D:\WOW\UI\%addon1%\Lastest
set destpath2=D:\WOW\UI\%addon2%\Lastest

xcopy /D /S /E /Y "%wowfolder%\_ptr_\Interface\Addons\%addon1%\" %destpath1% 
xcopy /D /S /E /Y "%wowfolder%\_retail_\Interface\Addons\%addon1%\" %destpath1% 
xcopy /D /S /E /Y "%wowfolder%\_classic_ptr_\Interface\Addons\%addon1%\" %destpath1% 
xcopy /D /S /E /Y "%wowfolder%\_classic_\Interface\Addons\%addon1%\" %destpath1% 

xcopy /D /S /E /Y "%wowfolder%\_ptr_\Interface\Addons\%addon2%\" %destpath2% 
xcopy /D /S /E /Y "%wowfolder%\_retail_\Interface\Addons\%addon2%\" %destpath2% 
xcopy /D /S /E /Y "%wowfolder%\_classic_ptr_\Interface\Addons\%addon2%\" %destpath2% 
xcopy /D /S /E /Y "%wowfolder%\_classic_\Interface\Addons\%addon2%\" %destpath2% 

explorer "%destpath1%"
pause