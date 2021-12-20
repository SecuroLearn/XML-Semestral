@echo off
setlocal EnableDelayedExpansion

:: =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
:: =-=                  HOW TO USE                   =-=
:: =-=                                               =-=
:: =-= switch modes using first argument:            =-=
:: =-=  leave empty for all functions below          =-=
:: =-=  "xml" for generating internal XMLs from ori- =-=
:: =-=        ginal HTML                             =-=
:: =-=  "dtd" for checking internal XMLs using DTD   =-=
:: =-=  "rng" for checking int. XMLs using RelaxNG   =-=
:: =-=  "html" for generating HTML output from inte- =-=
:: =-=        rnal XMLs                              =-=
:: =-=  "pdf" for generating HTML output from inter- =-=
:: =-=        nal XMLs                               =-=
:: =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


:: =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
:: =-=-=-=-=-=-=- PERSONALIZE SCRIPT HERE -=-=-=-=-=-=-=
:: =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
:: Set Saxon.jar location
set SAXON=..\Saxon\saxon-he-10.5.jar

:: Set XmlLint.exe location
set XMLLINT=..\xmllint\xmllint.exe

:: Set Fop location
set FOP=..\fop-2.6\fop\fop

:: Set name of file containing XML used for generating combined XML output
set SHORT-AREAS=AreasMin.xml

:: Set name of file containing generated combined XML output
set AREAS=Areas.xml

:: Set name of file containing XSLT used for expanding generated combined XML output
set SHORT-AREAS-SCRIPT=expandAreas.xslt

:: Set name of file containing XSLT used for generating internal XML from original HTML
set HTML-TO-XML-SCRIPT=html2xml.xslt

:: Set name of file containing XSLT used for generating HTML output from internal XML
set XML-TO-HTML-SCRIPT=xml2html.xslt

:: Set name of file containing XSLT used for generating PDF output from internal XML
set XML-TO-PDF-SCRIPT=xml2pdf.xslt
:: =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

:: Generating useful vars
set SHORT-AREAS-PATH=areas-xml\%SHORT-AREAS%
set AREAS-PATH=areas-xml\%AREAS%
set SHORT-AREAS-SCRIPT-PATH=scripts\%SHORT-AREAS-SCRIPT%
set HTML-TO-XML-SCRIPT-PATH=scripts\%HTML-TO-XML-SCRIPT%
set XML-TO-HTML-SCRIPT-PATH=scripts\%XML-TO-HTML-SCRIPT%
set XML-TO-PDF-SCRIPT-PATH=scripts\%XML-TO-PDF-SCRIPT%

:: Initizaling vars
set XML=0
set DTD=0
set RNG=0
set MULTI=0
set HTML=0
set PDF=0

:: Deciding, what should the script do
if [%1]==[] set XML=1 && set DTD=1 && set RNG=1 && set MULTI=1 && set HTML=1 && set PDF=1
if [%1]==[xml] set XML=1 && set MULTI=1
if [%1]==[dtd] set DTD=1
if [%1]==[rng] set RNG=1
if [%1]==[html] set HTML=1
if [%1]==[pdf] set PDF=1

:: Generating internal XMLs (only separate areas) from original HTML
if %XML%==1 (echo Making xml... & ^
for /f %%f in ('dir /b .\areas-html') ^
do ((if !ERRORLEVEL! GEQ 1 (GOTO error) ^
else echo. & ^
echo "BUILDING XML %%~nf.xml" & ^
java -jar %SAXON% areas-html/%%f %HTML-TO-XML-SCRIPT-PATH% -o:areas-xml/%%~nf.xml))) & ^
echo ------------- && echo XML Generation complete. && echo ------------- && echo.

:: Generating internal combined XML from separate XMLs
if %MULTI%==1 (echo Making combined xml... && echo. && echo "BUILDING XML %AREAS%" & ^
java -jar %SAXON% %SHORT-AREAS-PATH% %SHORT-AREAS-SCRIPT-PATH% -o:%AREAS-PATH% ) & ^
echo ------------- && echo Combined XML Generation complete. && echo ------------- && echo.

:: Checking generated XMLs using DTD
if %DTD%==1 (echo Checking generated XML using DTD... & ^
for /f %%f in ('dir /b .\areas-xml') ^
do (if !ERRORLEVEL! GEQ 1 (GOTO error) else (if NOT [%%f]==[%SHORT-AREAS%] ^
if NOT [%%f]==[%AREAS%] ^
echo. && echo "VALIDATING XML %%f" & ^
%XMLLINT% --noout --dtdvalid validation/area.dtd areas-xml/%%f))) & ^
echo ------------- && echo DTD Validation complete. && echo ------------- && echo.

:: Checking generated combined XML using DTD
if %MULTI%==1 (echo. && echo "VALIDATING COMBINED XML %SHORT-AREAS%" & ^
%XMLLINT% --noout --dtdvalid validation/areas.dtd %SHORT-AREAS-PATH%) & ^
echo ------------- && echo DTD Combined validation complete. && echo ------------- && echo.

:: Checking generated expanded combined XML using DTD
if %MULTI%==1 (echo. && echo "VALIDATING COMBINED XML %AREAS%" & ^
%XMLLINT% --noout --dtdvalid validation/areas.dtd %AREAS-PATH%) & ^
echo ------------- && echo DTD Combined validation complete. && echo ------------- && echo.

:: Checking generated XMLs using RelaxNG
if %RNG%==1 (echo Checking generated XML using RNG... & ^
for /f %%f in ('dir /b .\areas-xml') ^
do (if !ERRORLEVEL! GEQ 1 (GOTO error) else (if NOT [%%f]==[%SHORT-AREAS%] ^
if NOT [%%f]==[%AREAS%] ^
echo. && echo "VALIDATING XML %%f" & ^
%XMLLINT% --noout --relaxng validation/area.rng areas-xml/%%f))) & ^
echo ------------- && echo RNG Validation complete. && echo ------------- && echo.

:: Checking generated combined XML using RelaxNG
if %MULTI%==1 (echo. && echo "VALIDATING COMBINED XML %SHORT-AREAS%" & ^
%XMLLINT% --noout --relaxng validation/areas.rng %SHORT-AREAS-PATH%) & ^
echo ------------- && echo RNG Combined validation complete. && echo ------------- && echo.

:: Checking generated expanded combined XML using RelaxNG
if %MULTI%==1 (echo. && echo "VALIDATING COMBINED XML %AREAS%" & ^
%XMLLINT% --noout --relaxng validation/areas.rng %AREAS-PATH%) & ^
echo ------------- && echo RNG Combined validation complete. && echo ------------- && echo.

:: Generating HTML output from internal XMLs
if %HTML%==1 ^
echo. && echo Generating html... & ^
java -jar %SAXON% %AREAS-PATH% %XML-TO-HTML-SCRIPT-PATH% & ^
echo ------------- && echo HTML Areas generation complete. && echo ------------- && echo.

:: Generating PDF output from internal XMLs
if %PDF%==1 ^
echo. && echo Generating pdf... & ^
%FOP% -xml %AREAS-PATH% -xsl %XML-TO-PDF-SCRIPT-PATH% -pdf output/areas.pdf & ^
echo ------------- && echo PDF generation complete. && echo ------------- && echo.

:: If everything went good, this message appears:
if !ERRORLEVEL! EQU 0 echo. && echo Done succesfully! (finally...)

EXIT /B

:: If error code is found, this snippet of code executes itself
:error
echo[
echo[
echo ENCOUNTERED ERROR, STOPPING!
echo[
EXIT /B
