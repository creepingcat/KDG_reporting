@echo off
setlocal ENABLEDELAYEDEXPANSION

:PARAMS
SET KDG_FOLDER=\\epbyminsd0133\KDG_REPORTING
SET RESULT_FILE=KDG_Reporting_all.csv
SET CONNECTION_STRING="(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=epbyminsd0133.minsk.epam.com)(PORT=1522))(CONNECT_DATA=(SID=VPSDB)))"
SET LOGIN_NAME=KDG_REPORTING
SET PASSWORD=Er3ZuzzwAA
SET FILEMASK=*.csv

goto :P_02

:P_01
ECHO Set working directory
pushd %KDG_FOLDER%\data
ECHO Deleting existing resulting file
IF exist %RESULT_FILE% del %RESULT_FILE%
set cnt=1
for %%i in (%FILEMASK%) do (
  if !cnt!==1 (
    for /f "delims=" %%j in ('type "%%i"') do echo %%j >> %RESULT_FILE%
  ) else if %%i NEQ %RESULT_FILE% (
    for /f "skip=1 delims=" %%j in ('type "%%i"') do echo %%j >> %RESULT_FILE%
  )
  set /a cnt+=1
)

:P_02
bin\sqlplus %LOGIN_NAME%/%PASSWORD%@%CONNECTION_STRING% @external_table.sql nolog



:END
popd

goto :EOF