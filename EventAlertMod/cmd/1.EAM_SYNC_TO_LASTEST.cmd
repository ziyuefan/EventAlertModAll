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
rem set srcpath1=%wowfolder%\_%servertype%_\Interface\Addons\%addon1%\
set srcpath1=..\..\%addon1\
set srcpath2=..\..\%addon2\
set destpath1=D:\WOW\UI\%addon1%\Lastest
set destpath2=D:\WOW\UI\%addon2%\Lastest

xcopy /D /S /E /Y /F "%wowfolder%\_classic_ptr_\Interface\Addons\%addon1%\" %destpath1% 
xcopy /D /S /E /Y /F "%wowfolder%\_classic_\Interface\Addons\%addon1%\" %destpath1% 
xcopy /D /S /E /Y /F "%wowfolder%\_ptr_\Interface\Addons\%addon1%\" %destpath1% 
xcopy /D /S /E /Y /F "%wowfolder%\_retail_\Interface\Addons\%addon1%\" %destpath1% 

xcopy /D /S /E /Y /F "%wowfolder%\_ptr_\Interface\Addons\%addon2%\" %destpath2% 
xcopy /D /S /E /Y /F "%wowfolder%\_retail_\Interface\Addons\%addon2%\" %destpath2% 
xcopy /D /S /E /Y /F "%wowfolder%\_classic_ptr_\Interface\Addons\%addon2%\" %destpath2% 
xcopy /D /S /E /Y /F "%wowfolder%\_classic_\Interface\Addons\%addon2%\" %destpath2% 

explorer "%destpath1%"
pause

REM 複製檔案和樹狀目錄。

REM XCOPY source [destination] [/A | /M] [/D[:date]] [/P] [/S [/E]] [/V] [/W]
		   REM [/C] [/I] [/-I] [/Q] [/F] [/L] [/G] [/H] [/R] [/T]
		   REM [/U] [/K] [/N] [/O] [/X] [/Y] [/-Y] [/Z] [/B] [/J]
		   REM [/EXCLUDE:file1[+file2][+file3]...] [/COMPRESS]

REM source       指定要複製的檔案。
REM destination  指定新檔案的位置和/或名稱。
REM /A          只複製已設定保存屬性的檔案，
REM				而且不變更該屬性。
REM /M          只複製已設定保存屬性的檔案，
REM 			並關閉保存屬性。
REM /D:m-d-y    複製在指定日期當天或之後發生變更的檔案。
REM 			如果沒有指定日期，只複製來源檔案時間比目的地時間新的檔案。
REM /EXCLUDE:file1[+file2][+file3]...
REM 			指定包含字串的檔案清單。每個字串
REM 			應該在檔案中的不同行。如果要複製
REM				之檔案的絕對路徑的任何部分符合指
REM 			定的字串，複製時將排除該檔案。例如，
REM 			若指定字串 \obj\ 或 .obj，將會排除
REM 			obj 目錄下的所有檔案，或副檔名是.obj
REM 			的所有檔案。
REM /P           在建立每個目的地檔案前顯示提示。
REM /S           複製每個目錄及子目錄，但空目錄除外。
REM /E           複製每個目錄及子目錄，包含空目錄。
REM 			與 /S /E 相同。可用來修改 /T。
REM /V           檢查每個新檔案的大小。
REM /W           在複製之前提示您按下按鍵。
REM /C           即使發生錯誤，仍繼續複製。
REM /I           如果目的地不存在且複製一個以上的檔案，
REM 			即假設該目的地必然是目錄。
REM /-I 		如果目的地不存在且複製單一指定檔案，
REM 			假設目的地須為檔案。
REM /Q           複製時不顯示檔名。
REM /F           複製時顯示來源及目的地檔案的完整檔名。
REM /L           顯示要複製的檔案。
REM /G           允許將加密檔案複製到
REM 			不支援加密的目的地。
REM /H           一併複製隱藏檔案和系統檔案。
REM /R           覆寫唯讀檔案。
REM /T           建立目錄結構，但不複製檔案。
REM 			不包含空目錄或子目錄。 /T /E 則包含
REM 			空目錄及子目錄。
REM /U           只複製已存在於目的地的檔案。
REM /K           複製屬性。一般 Xcopy 將會重設唯讀屬性。
REM /N           使用產生的簡短檔名進行複製。
REM /O           複製檔案所有權及 ACL 資訊。
REM /X           複製檔案稽核設定 (隱含 /O)。
REM /Y           不要提示您確認是否要覆寫已存在的目的地檔案。
REM /-Y          提示您確認是否要覆寫已存在的目的地檔案。
REM /Z           在可重新啟動的模式中複製網路檔案。
REM /B           複製符號連結本身而非連結的目標。
REM /J           使用無緩衝的 I/O 複製，建議使用於非常大的檔案。
REM /COMPRESS    在檔案轉送過程中，要求網路壓縮，其中可套用。
REM /SPARSE      當複製稀疏檔案時，保存稀疏狀態。    
REM 切換參數 /Y 可以在 COPYCMD 環境變數中預先設定。
REM 這可以在命令列中使用 /-Y 加以覆寫。