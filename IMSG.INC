;BINC v2.4: INFO

info DB 0Ah,0Dh,'BINC v2.4 * BIN to INC Converter * (c)1995 by ''marikaz''',0Dh,0Ah
DB 'Konwertuj plik na tablice czytelna dla asemblera. Opis w README.TXT',0Dh,0Ah
DB 0Dh,0Ah
DB '   BINC.EXE [{/B | /D | /H}] [/I=nn] [/N[:][name]] <InFileSpec> [OutFileSpec]',0Dh,0Ah
DB 0Dh,0Ah
DB '/B           Generuj tablice w liczbach dwojkowych.',0Dh,0Ah
DB '/D           Generuj tablice w liczbach dziesietnych.',0Dh,0Ah
DB '/H           Generuj tablice w liczbach szestnastkowych (domyslnie).',0Dh,0Ah
DB '/I=nn        Ilosc pozycji w linii. nn=1..16 (domyslnie 16).',0Dh,0Ah
DB '/N[:]name    name = nazwa dla wygenerowanej tablicy, max. 15 znakow.',0Dh,0Ah
DB '/N[:]        Tablica otrzyma nazwe pliku wejsciowego (bez rozszerzenia).',0Dh,0Ah
DB 'InFileSpec   Lokalizacja i/lub nazwa pliku zrodlowego.',0Dh,0Ah
DB 'OutFileSpec  Lokalizacja i/lub nazwa pliku docelowego.',0Dh,0Ah
DB 0Dh,0Ah
DB 'W przypadku braku ''OutFileSpec'' zostanie wygenerowany plik z nazwa pliku',0Dh,0Ah
DB 'zrodlowego i rozszerzeniem inc.',0Dh,0Ah
DB 0
