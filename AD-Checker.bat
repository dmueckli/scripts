:: Copyright Dennis Muecklich 2021 
:: Veröffenticht unter GNU GPL v3
:: Dieses Script prüft ob ein Benutzer einer Gruppe im Active Directory zugewiesen ist. (quick&dirty)
:: Version: 1.0
@echo off

echo ######################################################################
echo.
echo                      ActiveDirectory Checker
echo.
echo ######################################################################
echo.

:Start
set benutzername=""
set gruppe=""
set checker=""
set funktion==0

set /p funktion=Gruppenzuordnung(0, Enter), Gruppensuche(1), Benutzersuche(2), Kontostatus(3) ?

echo.
echo ######################################################################
echo.

if %funktion%==0 goto Benutzergruppenpruefer
if %funktion%==1 goto Gruppensuche
if %funktion%==2 goto Benutzersuche
if %funktion%==3 goto Kontostatus

:Benutzergruppenpruefer
VERIFY > nul
cmd /c "exit /b 0"
ver > nul

echo Gruppenzuordnung
echo.

:Benutzer

set /p benutzername="Bitte den Benutzernamen eingeben: "
echo.
if %benutzername%=="" echo Der Benutzername darf nicht leer sein! && echo. && echo ###################################################################### && echo. && goto Benutzer
net user %benutzername% /domain 2>NUL | findstr %benutzername% && echo. || echo Der Benutzer konnte nicht gefunden werden! && echo. && echo ###################################################################### && echo. && goto Start

:Gruppe
VERIFY > nul
cmd /c "exit /b 0"
ver > nul
set /p gruppe="Bitte die Gruppe eingeben: "
echo.
if %gruppe%=="" echo Die Eingabe darf nicht leer sein. && echo. && goto Gruppe
net group /domain 2>NUL | findstr /x *%gruppe% && echo. || echo Die Gruppe %gruppe% konnte nicht gefunden werden! && echo. && echo ###################################################################### && echo. && goto Start

net group %gruppe% /domain | findstr "Beschreibung 
echo.
echo ######################################################################
echo.

for /f %%i in ('net user %benutzername% /domain ^| findstr *%gruppe%') do set checker=%%i

if %checker%==*%gruppe% ( echo Der Benutzer %benutzername% ist der Gruppe %gruppe% zugewiesen. ) else ( echo Der Benutzer %benutzername% ist NICHT der Gruppe %gruppe% zugewiesen! )
echo.
echo ######################################################################
echo.

goto Start

:Gruppensuche
VERIFY > nul
cmd /c "exit /b 0"
ver > nul

echo Gruppensuche
echo.

set /p gruppe="Bitte den Suchbegriff eingeben: "
echo.
if %gruppe%=="" echo Die Eingabe darf nicht leer sein. && echo. && goto Gruppensuche
echo Suchergebnis:
net group /domain 2>NUL | findstr /I %gruppe% && echo. || echo Die Gruppe %gruppe% konnte nicht gefunden werden! && echo. && echo ###################################################################### && echo. && goto Start

echo ######################################################################
echo.

goto Start

:Benutzersuche
VERIFY > nul
cmd /c "exit /b 0"
ver > nul

echo Benutzersuche
echo.

set /p benutzername="Bitte den Suchbegriff eingeben: "
echo.
if %benutzername%=="" echo Der Suchbegriff darf nicht leer sein. && echo. && goto Benutzersuche
echo Suchergebnis:
net user /domain 2>NUL | findstr /I %benutzername% && echo. || echo Der Benutzer konnte nicht gefunden werden! && echo. && echo ###################################################################### && echo. && goto Start

echo ######################################################################
echo.

goto Start

:Kontostatus
VERIFY > nul
cmd /c "exit /b 0"
ver > nul

echo Kontostatus
echo.

set /p benutzername="Bitte den Benutzernamen eingeben: "
echo.
if %benutzername%=="" echo Der Benutzername darf nicht leer sein. && echo. && goto Kontostatus
echo Suchergebnis:
net user %benutzername% /domain 2>NUL | findstr /I "Benutzername aktiv letzte Vollst" && echo. || echo Der Benutzer konnte nicht gefunden werden! && echo. && echo ###################################################################### && echo. && goto Start

echo ######################################################################
echo.

goto Start

:Exit

:: Don't worry if it doesn't work right. If everything did, you'd be out of job.
:: - Mosher's law of software engineering
