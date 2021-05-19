:: Copyright Dennis Muecklich 2021 
:: Veröffenticht unter GNU GPL v3
:: Dieses Script prüft ob ein Benutzer einer Gruppe im Active Directory zugewiesen ist. (quick&dirty)
@echo off

:Start
set benutzername=""
set gruppe=""
set checker=""
set funktion== 0

set /p funktion=Prüfen ob Benutzer einer Gruppe zugeordnet ist(0, Enter), Gruppensuche(1), Benutzersuche(2) ?
if %funktion%==0 goto Benutzergruppenpruefer
if %funktion%==1 goto Gruppensuche
if %funktion%==2 goto Benutzersuche

:Benutzergruppenpruefer
set /p benutzername="Bitte den Benutzernamen eingeben: "
echo.
if %benutzername%=="" echo Der Benutzername darf nicht leer sein. && echo. && goto Benutzergruppenpruefer
net user %benutzername% /domain 2>NUL | findstr %benutzername% && echo. || echo Der Benutzer konnte nicht gefunden werden! && echo. && echo ################################################################## && echo. && goto Start

:Gruppe
VERIFY > nul
cmd /c "exit /b 0"
ver > nul
set /p gruppe="Bitte die Gruppe eingeben: "
echo.
if %gruppe%=="" echo Die Eingabe darf nicht leer sein. && echo. && goto Gruppe
net group /domain 2>NUL | findstr /x *%gruppe% && echo. || echo Die Gruppe %gruppe% konnte nicht gefunden werden! && echo. && echo ################################################################## && echo. && goto Start

echo ##################################################################
echo.

for /f %%i in ('net user %benutzername% /domain ^| findstr *%gruppe%') do set checker=%%i

if %checker%==*%gruppe% ( echo Der Benutzer %benutzername% ist der Gruppe %gruppe% zugewiesen. ) else ( echo Der Benutzer %benutzername% ist NICHT der Gruppe %gruppe% zugewiesen! )
echo.
echo ##################################################################
echo.

goto Start

:Gruppensuche
VERIFY > nul
cmd /c "exit /b 0"
ver > nul

set /p gruppe="Bitte die Gruppe eingeben: "
echo.
if %gruppe%=="" echo Die Eingabe darf nicht leer sein. && echo. && goto Gruppensuche
net group /domain 2>NUL | findstr *%gruppe% && echo. || echo Die Gruppe %gruppe% konnte nicht gefunden werden! && echo. && echo ################################################################## && echo. && goto Start

echo ##################################################################
echo.

:Benutzersuche
VERIFY > nul
cmd /c "exit /b 0"
ver > nul

set /p benutzername="Bitte den Suchbegriff eingeben: "
echo.
if %benutzername%=="" echo Der Suchbegriff darf nicht leer sein. && echo. && goto Benutzersuche
net user /domain 2>NUL | findstr %benutzername% && echo. || echo Der Benutzer konnte nicht gefunden werden! && echo. && echo ################################################################## && echo. && goto Start

goto Start

:Exit
