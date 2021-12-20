@echo off
setlocal EnableDelayedExpansion
if [%1]==[xml] (echo Making xml... && for /f %%f in ('dir /b .\areas-html') do (if !ERRORLEVEL! GEQ 1 (GOTO error) else  java -jar ..\Saxon\saxon-he-10.5.jar areas-html/%%f htmlXmlTransformation.xslt -o:areas-xml/%%~nf.xml)) else (echo "wrong parameter")
if !ERRORLEVEL! EQU 0 echo. && echo Done succesfully! (finally...)

EXIT /B
:error
echo[
echo[
echo ENCOUNTERED ERROR, STOPPING!
echo[
EXIT /B
