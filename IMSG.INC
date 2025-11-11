;BINC v2.5 -- Info --

info DB 'BINC '
IFDEF ALLZ AND DDEC
 DB 'v2.5ad' ;ALLZ i DDEC
 ELSE
  IFDEF ALLZ
   DB 'v2.5a' ;ALLZ
   ELSE
    IFDEF DDEC
     DB 'v2.5d' ;DDEC
     ELSE
      DB 'v2.5' ;wersja domyslna
    ENDIF
  ENDIF
ENDIF
DB ' (MOD2509) * BIN to INC Converter * (c)1995 by ''marikaz''',0Dh,0Ah
DB 'Konwertuj plik na tablice dla asemblerow. Opis w README.TXT',0Dh,0Ah
DB 0Dh,0Ah
DB '   BINC.EXE [{/B | /D}] [/I=nn] [/N[:][name]] <InFileSpec> [OutFileSpec]',0Dh,0Ah
DB 0Dh,0Ah
DB '/B           Generuj wartosci binarne.',0Dh,0Ah
DB '/D           Generuj wartosci dziesietne.',0Dh,0Ah
DB '/I=nn        Ilosc pozycji w linii. nn=1..16 (domyslnie 16).',0Dh,0Ah
DB '/N[:]name    name = nazwa dla wygenerowanej tablicy, max. 15 znakow.',0Dh,0Ah
DB '/N[:]        Tablica otrzyma nazwe pliku wejsciowego (bez rozszerzenia).',0Dh,0Ah
DB 'InFileSpec   Lokalizacja i/lub nazwa pliku zrodlowego.',0Dh,0Ah
DB 'OutFileSpec  Lokalizacja i/lub nazwa pliku docelowego.',0Dh,0Ah
DB 0Dh,0Ah
DB 'Jesli nie podano ''OutFileSpec'', plik docelowy otrzyma nazwe pliku zrodlowego',0Dh,0Ah
DB 'z rozszerzeniem inc.',0Dh,0Ah
DB '$'
