@echo off
setlocal EnableDelayedExpansion

set SAXON=..\Saxon\saxon-he-10.5.jar
set XMLLINT=..\xmllint\xmllint.exe
set SHORT-AREAS=AreasMin.xml
set AREAS=Areas.xml

set SHORT-AREAS-PATH=areas-xml\%SHORT-AREAS%
set AREAS-PATH=areas-xml\%AREAS%

set XML=0
set DTD=0
set RNG=0
set MULTI=0

if [%1]==[] set XML=1 && set DTD=1 && set RNG=1 && set MULTI=1
if [%1]==[xml] set XML=1 && set MULTI=1
if [%1]==[dtd] set DTD=1
if [%1]==[rng] set RNG=1

if %XML%==1 ((echo Making xml... && for /f %%f in ('dir /b .\areas-html') do (if !ERRORLEVEL! GEQ 1 (GOTO error) else echo. && echo "BUILDING XML %%f" && java -jar %SAXON% areas-html/%%f htmlXmlTransformation.xslt -o:areas-xml/%%~nf.xml))) && echo ------------- && echo XML Generation complete. && echo ------------- && echo.
if %MULTI%==1 (echo Making combined xml... && echo. && echo "BUILDING XML %AREAS%" && java -jar %SAXON% %SHORT-AREAS-PATH% expandAreas.xslt -o:%AREAS%) && echo ------------- && echo Combined XML Generation complete. && echo ------------- && echo.
if %DTD%==1 ((echo Checking generated XML using DTD... && for /f %%f in ('dir /b .\areas-xml') do (if !ERRORLEVEL! GEQ 1 (GOTO error) else (if NOT [%%f]==[%SHORT-AREAS%] if NOT [%%f]==[%AREAS%] echo. && echo "VALIDATING XML %%f" && %XMLLINT% --noout --dtdvalid validation/area.dtd areas-xml/%%f)))) && echo ------------- && echo DTD Validation complete. && echo ------------- && echo.
if %MULTI%==1 (echo. && echo "VALIDATING COMBINED XML %SHORT-AREAS%" && %XMLLINT% --noout --dtdvalid validation/areas.dtd %SHORT-AREAS-PATH%) && echo ------------- && echo DTD Combined validation complete. && echo ------------- && echo.
if %MULTI%==1 (echo. && echo "VALIDATING COMBINED XML %AREAS%" && %XMLLINT% --noout --dtdvalid validation/areas.dtd %AREAS-PATH%) && echo ------------- && echo DTD Combined validation complete. && echo ------------- && echo.
if %RNG%==1 ((echo Checking generated XML using RNG... && for /f %%f in ('dir /b .\areas-xml') do (if !ERRORLEVEL! GEQ 1 (GOTO error) else (if NOT [%%f]==[%SHORT-AREAS%] if NOT [%%f]==[%AREAS%] echo. && echo "VALIDATING XML %%f" && %XMLLINT% --noout --relaxng validation/area.rng areas-xml/%%f)))) && echo ------------- && echo RNG Validation complete. && echo ------------- && echo.
if %MULTI%==1 (echo. && echo "VALIDATING COMBINED XML %SHORT-AREAS%" && %XMLLINT% --noout --relaxng validation/areas.rng %SHORT-AREAS-PATH%) && echo ------------- && echo RNG Combined validation complete. && echo ------------- && echo.
if %MULTI%==1 (echo. && echo "VALIDATING COMBINED XML %AREAS%" && %XMLLINT% --noout --relaxng validation/areas.rng %AREAS-PATH%) && echo ------------- && echo RNG Combined validation complete. && echo ------------- && echo.
if !ERRORLEVEL! EQU 0 echo. && echo Done succesfully! (finally...)

EXIT /B
:error
echo[
echo[
echo ENCOUNTERED ERROR, STOPPING!
echo[
EXIT /B
