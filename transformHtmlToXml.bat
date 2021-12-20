@echo off
setlocal EnableDelayedExpansion

set SAXON=..\Saxon\saxon-he-10.5.jar
set XMLLINT=..\xmllint\xmllint.exe

set XML=0
set DTD=0

if [%1]==[] set XML=1 && set DTD=1
if [%1]==[xml] set XML=1
if [%1]==[dtd] set DTD=1

if %XML%==1 ((echo Making xml... && for /f %%f in ('dir /b .\areas-html') do (if !ERRORLEVEL! GEQ 1 (GOTO error) else echo. && echo "BUILDING XML %%f" && java -jar %SAXON% areas-html/%%f htmlXmlTransformation.xslt -o:areas-xml/%%~nf.xml))) && echo ------------- && echo Generation complete. && echo ------------- && echo.
if %DTD%==1 ((echo checking generated XML using DTD... && for /f %%f in ('dir /b .\areas-xml') do (if !ERRORLEVEL! GEQ 1 (GOTO error) else (echo. && echo "VALIDATING XML %%f" && %XMLLINT% --noout --dtdvalid area.dtd areas-xml/%%f)))) && echo ------------- && echo Validation complete. && echo ------------- && echo.

if !ERRORLEVEL! EQU 0 echo. && echo Done succesfully! (finally...)

EXIT /B
:error
echo[
echo[
echo ENCOUNTERED ERROR, STOPPING!
echo[
EXIT /B
