:: Copyright Dennis Muecklich 2021 
:: Veröffenticht unter GNU GPL v3
:: Dieses Script prüft ob ein Benutzer einer Gruppe im Active Directory zugewiesen ist. (quick&dirty)
@echo off
echo ##################################################################
echo.
echo ___  ____   _      _        
echo |  \/  (_) (_)    | |       
echo | .  . |_   _  ___| | _____ 
echo | |\/| | | | |/ __| |/ / _ \
echo | |  | | |_| | (__|   <  __/
echo \_|  |_/\__,_|\___|_|\_\___|
echo                             
echo                             
echo.
echo ##################################################################
echo.
echo                      Benutzergruppenpruefer
echo.
echo ##################################################################
echo.

:Start
set benutzername=""
set gruppe=""
set checker=""
set funktion = 0

VERIFY > nul
cmd /c "exit /b 0"
ver > nul

set /p funktion=Prüfen ob Benutzer einer Gruppe zugeordnet ist(0) oder Gruppen durchsuchen(1)?
if %funktion%==0 goto Funktion1
if %funktion%==1 goto Funktion2

:Funktion1
set /p benutzername="Bitte den Benutzernamen eingeben: "
echo.
if %benutzername%=="" echo Der Benutzername darf nicht leer sein. && echo. && goto Start
net user %benutzername% /domain 2>NUL | findstr %benutzername% && echo. || echo Der Benutzer konnte nicht gefunden werden! && echo. && echo ################################################################## && echo. && goto Start

:Gruppe
VERIFY > nul
cmd /c "exit /b 0"
ver > nul
set /p gruppe="Bitte die Gruppe eingeben: "
echo.
if %gruppe%=="" echo Die Eingabe darf nicht leer sein. && echo. && goto Gruppe
echo Bezeichnung:
net group /domain 2>NUL | findstr /x *%gruppe% && echo. || echo Die Gruppe %gruppe% konnte nicht gefunden werden! && echo. && echo ################################################################## && echo. && goto Gruppe

echo ##################################################################
echo.

for /f %%i in ('net user %benutzername% /domain ^| findstr *%gruppe%') do set checker=%%i

if %checker%==*%gruppe% ( echo Der Benutzer %benutzername% ist der Gruppe %gruppe% zugewiesen. ) else ( echo Der Benutzer %benutzername% ist NICHT der Gruppe %gruppe% zugewiesen! )
echo.
echo ##################################################################
echo.

goto Start

:Funktion2
VERIFY > nul
cmd /c "exit /b 0"
ver > nul
set /p gruppe="Bitte die Gruppe eingeben: "
echo.
if %gruppe%=="" echo Die Eingabe darf nicht leer sein. && echo. && goto Funktion2
echo Bezeichnung:
net group /domain 2>NUL | findstr *%gruppe% && echo. || echo Die Gruppe %gruppe% konnte nicht gefunden werden! && echo. && echo ################################################################## && echo. && goto Gruppe

:Exit
