@echo off
set logDir=%~dp0log

if not exist "%logDir%" (
    mkdir "%logDir%"
)

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value ^| find "="') do set datetime=%%I
set datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr "IPv4"') do set ipBase=%%A
set ipBase=%ipBase:~1%
for /f "delims=. tokens=1,2,3" %%A in ("%ipBase%") do set range=%%A.%%B.%%C.1-254

set logFile=%logDir%\devices_%datetime%.txt

echo scanning in: (%range%), this may take a few minutes...

nmap -sS -sV -p 80,443,22,53,21,23,110 -T4 %range% > "%logFile%"

echo scanned. data saved in: "%logFile%"
pause
