-----------------------------------------------------------------------------
   ***  BINC ver. 2.4 ***

                                                           (c)1995 'marikaz'
-----------------------------------------------------------------------------

1. DZIALANIE

   Program wykonuje konwersje dowolnego pliku do postaci, ktora mozna
   bezposrednio dolaczyc do zrodla asemblerowego jako definicje bajtow (DB).
   Kazdy bajt pliku zrodlowego zamieniany jest na jego reprezentacje w
   postaci liczb szestnastkowych, dziesietnych lub binarnych w ASCII
   z zachowaniem regul obowiazujacych dla skladni Intel (TASM/MASM).

   1.1 Skladnia:

   BINC.EXE <InFileSpec> [OutFileSpec] [{/B | /D | /H}] [/I=nn] [/N[:][name]]

       /B          Generuj wartosci dwojkowe.
       /D          Generuj wartosci dziesietne.
       /H          Generuj wartosci szestnastkowe (domyslnie).
       /I=nn       Ilosc pozycji w linii, nn=1..16 (domyslnie 16).
       /N[:]name   name = nazwa dla wygenerowanej tablicy (max. 15 znakow).
       /N[:]       Nazwa tablicy otrzyma nazwe pliku <InFile>
                   bez rozszerzenia.
       InFileSpec  Lokalizacja i/lub nazwa pliku zrodlowego (wymagana).
       OutFileSpec Lokoalizacja i/lub nazwa pliku docelowego

   Jesli nie podano nazwy dla pliku docelowego (OutFileSpec) to zostanie
   wygenerowany plik o nazwie identycznej z nazwa pliku wejsciowego
   a rozszerzenie zostanie zastapione rozszerzeniem inc.
   Jesli plik wejsciowy rozszerzenia nie posiadal to program je doda.

   Przelacznik /N[:]nazwa (opcjonalny) sluzy do wstawienia w pliku docelowym
   nazwy dla utworzonej tablicy. Nazwa nie moze byc dluzsza niz 15 znakow.
   Zastosowanie przelacznika /N bez podania nazwy wstawi jako nazwe dla
   tablicy nazwe pliku wejsciowego bez rozszerzenia. Nalezy przy tym
   pamietac, ze znaki prawidlowe w nazwach plikow MS-DOS nie zawsze beda
   prawidlowe w nazwach zmiennych, a sama nazwa pliku moze byc slowem
   zastrzezonym kompilatora lub jezyka.

   1.2 Uzycie

       Zgodnie ze skladnia:

       BINC.EXE [dive:][path]<Infile>
                [drive:][path][OutFile]
                [{/B | /D | /H}]
                [I=nn]
                [/N[:][nazwa]]

       Np.:
       BINC.EXE c:\test\plik.bin d:\inc\plikinc.db /n:tablica0 /i=10 /d

       - BINC rozpoznaje przeznaczenie plikow po kolejnosci ich wystepowania
         w linii polecen. Pierwsza napotkana nazwa pliku bedzie traktowana
         jako nazwa pliku zrodlowego.
       - Opcja /H (hex) jest domyslna i nie jest wymagane jej wpisywanie.
       - Opcja /I=nn zapisuje nn pozycji w wierszu. Niestety, ze wzgledu
         na pewne uproszczenia, tylko dla wartosci nn, ktore dziela 240
         bez reszty.

2. PLIK WYJSCIOWY
   Ponizszy opis dotyczy pliku wygenerowanego bez zmian dokonywanych
   dostepnymi opcjami.

   Kazda linia sklada sie z 16 pozycji i zaczyna sie od dyrektywy DB.
   Kazda pozycja zawiera jeden bajt szestnastkowo w ASCII, z tym, ze:
   W przeciwienstwie do innych tego typu programow, BINC nie zapisuje do
   generowanej tablicy nadmiarowych znakow:
   - Cyfry szestnastkowe 0..9 nie wymagaja zadnych dodatkowych znakow.
   - Liczby szestnastkowe zaczynajace sie od cyfry dziesietnej nie wymagaja
     poprzedzajacego zera.

   Dla pozostalych opcji:
   - Liczby dziesietne nie maja zadnych dodatkowych znakow,
   - a binarne 0 i 1 bez konczacego 'b'

3. BLEDY I KOMUNIKATY

   - W przypadku bledow podczas operacji na plikach, program wyswietli
     komunikat:

      > Blad operacji na pliku.

   - W przypadku gdy w linii polecen nie podano nazwy pliku do konwersji,
     podano bledna nazwe lub niezgodna z MS-DOS, wprowadzono polecenia
     niezgodne ze skladnia lub podano: /?
     program wyswietla info z poprawnym uzyciem.

   - Gdy plik zrodlowy ma 0 bajtow:

      > Plik zrodlowy jest pusty.

   - Plik docelowy wystepuje juz w danej lokalizacji:

      > Plik docelowy istnieje juz w podanej lokalizacji. Nadpisac (t/n)?

     Wybor nalezy zatwierdzic klawiszem ENTER.

     Przerwanie procesu przez uzytkownika komunikowane jest napisem:

      > Zapis przerwano.

   - Prawidlowy przebieg programu wraz z wygenerowaniem pliku docelowego
     zostanie zakomunikowane napisem:

      > Plik <filename[.ext]> zapisano w podanej lokalizacji.

4. UWAGI DOTYCZACE KOMPILACJI ZE ZRODEL

   - W kodzie zrodlowym wystepuja linie odwolujace sie do makr zawartych
     w pliku 'ifileio.mac', ktorego nie ma w repozytorium. Makra wykonuja
     standardowe operacje na plikach. Nazwy sa jednoznaczne i nie powinno
     byc problemu z napisaniem wlasnych lub zastapienie bezposrednio kodem.

   - W 'main.asm' wystepuje wywolanie procedury ChoiceBpl, ktora znajduje
     sie w zewnetrznej bibliotece i nie ma jej w repozytorium. Funkcja
     zwraca NC dla znakow 't','T' lub CY dla 'n','N', natomiast inne
     klawisze ignoruje. Procedure mozna zastapic doslownie kilkoma liniami
     kodu.

   - Plik 'b2d.asm' zawierajacy mechanizm konwertujacy, mozna skomilowac
     z flagami:

     /dDDEC - liczby dziesietne (ale nie _cyfry_) otrzymaja 'd' na koncu.
              (Domyslnie liczby dziesietne nie zawieraja zadnych dodatkowych
               znakow).
     /dALLZ - rozwiniwcie binarne otrzyma komplet 8 cyfr nawet gdy tego
              nie wymaga. Wszystkie wartosci otrzymaja 'b' na koncu.
              Np.: bajt 0 zostanie rozwiniety do ciagu: 00000000b,
                   1 do 00000001b, 2 do 00000010b itd.


5. KOMPATYBILNOSC

   Program poprawniw funkcjonuje z:

   MS-DOS 5.0+   - na VM. (Wersje 1.1, 2.1 i 2.2 na maszynie fizycznej)
   FreeDOS 1.3+  - na VM.
   DOSBox 0.74-3 - Kompilacja i testy.
