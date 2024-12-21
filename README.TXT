-----------------------------------------------------------------------------
   ***  BINC ver. 2.2.1 ***

                                                           (c)1995 'marikaz'
-----------------------------------------------------------------------------

1. DZIALANIE

   Program wykonuje konwersje dowolnego pliku do postaci, ktora mozna
   bezposrednio dolaczyc do zrodla asemblerowego jako definicje bajtow (DB).
   Kazdy bajt pliku zrodlowego zamieniany jest na jego reprezentacje w
   postaci liczb szestnastkowych w ASCII z zachowaniem regul obowiazujacych
   dla skladni asemblera TASM/MASM itp.

   1.1 Skladnia:

       BINC.EXE <InFile.ext> [OutFile.ext] [/N[:][name]]

       /N[:]name   Nazwa dla wygenerowanej tablicy (max. 15 znakow).
       /N[:]       Nazwa dla tablicy jest nazwa pliku <InFile>
                   bez rozszerzenia.
       InFile.ext  Nazwa pliku do konwersji (wymagana).
       OutFile.ext Nazwa dla pliku docelowego.

   Jesli nie podano nazwy dla pliku docelowego (OutFile.ext) to zostanie
   wygenerowany plik o nazwie identycznej z nazwa pliku wejsciowego
   a rozszerzenie zostanie zastapione rozszerzeniem inc. Jesli plik wejsciowy
   rozszerzenia nie posiadal to program je doda.

   Przelacznik /N[:]nazwa (opcjonalny) sluzy do wstawienia w pliku docelowym
   nazwy dla utworzonej tablicy. Nazwa nie moze byc dluzsza niz 15 znakow.
   Zastosowanie samego przelacznika: /N wstawi jako nazwe dla tablicy nazwe
   pliku wejsciowego bez rozszerzenia.

    UWAGA!
    Stosujac opcje '/N' trzeba pamietac, ze znaki prawidlowe w nazwach
    plikow MS-DOS nie zawsze beda prawidlowe w nazwach zmiennych.
    Nazwa pliku moze byc rowniez jednym ze slow kluczowych w asm itp.
    i proba kompilacji moze zakonczyc ostrzezeniem lub bledem.

   BINC rozpoznaje przeznaczenie plikow po kolejnosci ich wystepowania
   w linii polecen. Pierwsza napotkana nazwa pliku bedzie traktowana jako
   nazwa pliku wejsciowego <InFile>, natomiast polozenie przelacznika /N
   jest dowolne.

   1.2 Uzycie

       Najkrotrza poprawna linia polecen:

       BIBC a

       a     = nazwa pliku wejsciowego
       a.inc = wygenerowany plik wyjsciowy
               w pliku wyjsciowum nie bedzie nazwy dla tablicy

       i najdluzsza:

       BINC /n:MojaNazwaDlaTbl plik0000.bin plik1111.inc

2. PLIK WEJSCIOWY

   Plik zrodlowy moze byc dowolnym plikiem i nie ma znaczenia jaka ma
   strukrure lub do czego sluzy. Trzeba jednak pamietac, ze wielkosc pliku
   zrodlowego ma bezposredni wplyw na wielkosc pliku docelowego, a ten
   ma ograniczona wielkosc.
   Podczas pracy skonwertowano wiele plikow o roznej zawartosci i ma tej
   podstawie mozna przyjac, ze plik o rozmiarze 15kB powinien dac sie
   skonwertowac, natomiast wiekszy juz niekoniecznie, chociaz nie jest
   to wykluczone.

3. PLIK WYJSCIOWY

   Kazda linia sklada sie z 16 pozycji i zaczyna sie od dyrektywy 'DB'.
   Kazda pozycja zawiera jeden bajt szestnastkowo w ASCII, z tym, ze:
   W przeciwienstwie do innych tego typu programow, BINC nie zapisuje do
   generowanej tablicy nadmiarowych znakow:
   - Cyfry 0..9 nie wymagaja zadnych dodatkowych znakow.
   - Liczby szestnastkowe zaczynajace sie od cyfry dziesietnej nie wymagaja
     poprzedzajacego zera.
   Ma to na celu maksymalne zmniejszenie ilosci danych zapisywanych do pliku
   docelowego, poniewaz ten nie moze byc wiekszy niz 65440 bajtow.
   W przypadku gdy plik docelowy bedzie wiekszy niz dopuszczalny, program
   przerwie dzialanie i wyswietli stosowny komunikat.

4. BLEDY I KOMUNIKATY

   4.1 W przypadku bledow podczas operacji na plikach, program wyswietli
       komunikat:

         File operation error.

       Wyjatek stanowi tu blad otwarcia pliku zrodlowego, ktory w 99%
       przypadkow polega na literowce w nazwie pliku lub braku samego pliku.

   4.2 W przypadku gdy w linii polecen nie podano nazwy pliku do konwersji,
       podano nazwe niezgodna z MS-DOS, podano nazwe nieistniejacego pliku
       czy wpisano przypadkowy ciag znakow, to program wyswietli komunikat
       przedstawiajacy poprawna skladnie.

   4.3 W przypadku, gdy plik docelowy bedzie wiekszy niz 65440 bajtow
       program wyswietli komunikat:

        Target file is too large.

   4.4 Gdy plik zrodlowy ma 0 bajtow:

        The source file is empty.

   4.5 Plik docelowy wystepuje juz w danej lokalizacji:

        Destination file already exists. Continue [y/N]?
        >_

       Domyslnie (dla klawisza ENTER) przyjmowane jest 'No'.
       'No' przyjmowana jest rowniez dla klawiszy: 'Esc', 'N', 'n'.

       Przerwanie procesu przez uzytkownika komunikowane jest napisem:

        >Discontinued at user request.

       Dla klawiszy 'Y', 'y' program przeprowadzi konwersje pliku jak kazdego
       innego, nadpisujac wczesniejsze dane.

   4.6 Pelny, prawidlowy przebieg programu wraz z wygenerowaniem pliku
       docelowego zostanie zakomunikowane napisem:

         OutFile.inc done.

5. KOMPATYBILNOSC

   BINC ver. 2.1 zostal przetestowany z:

   MS-DOS 5.0+   - VM. Wersja 1.1 pracowala na maszynie fizycznej.
   FreeDOS 1.3   - na VM.
   DOSBox 0.74-3 - Kompilacja i testy aktualnej wersji.
