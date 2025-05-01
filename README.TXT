-----------------------------------------------------------------------------
   ***  BINC ver. 2.3 ***

                                                           (c)1995 'marikaz'
-----------------------------------------------------------------------------

1. DZIALANIE

   Program wykonuje konwersje dowolnego pliku do postaci, ktora mozna
   bezposrednio dolaczyc do zrodla asemblerowego jako definicje bajtow (DB).
   Kazdy bajt pliku zrodlowego zamieniany jest na jego reprezentacje w
   postaci liczb szestnastkowych w ASCII z zachowaniem regul obowiazujacych
   dla skladni Intel - TASM/MASM itp.

   1.1 Skladnia:

       BINC.EXE <InFileSpec> [OutFileSpec] [/N[:][name]]

       /N[:]name   Nazwa dla wygenerowanej tablicy (max. 15 znakow).
       /N[:]       Nazwa dla tablicy jest nazwa pliku <InFile>
                   bez rozszerzenia.
       InFileSpec  Lokalizacja i/lub nazwa pliku zrodlowego (wymagana).
       OutFileSpec Lokoalizacja i/lub nazwa pliku docelowego

   Jesli nie podano nazwy dla pliku docelowego (OutFileSpec) to zostanie
   wygenerowany plik o nazwie identycznej z nazwa pliku wejsciowego
   a rozszerzenie zostanie zastapione rozszerzeniem inc. Jesli plik wejsciowy
   rozszerzenia nie posiadal to program je doda.

   Przelacznik /N[:]nazwa (opcjonalny) sluzy do wstawienia w pliku docelowym
   nazwy dla utworzonej tablicy. Nazwa nie moze byc dluzsza niz 15 znakow.
   Zastosowanie samego przelacznika: /N wstawi jako nazwe dla tablicy nazwe
   pliku wejsciowego bez rozszerzenia. Nalezy przy tym pamietac, ze znaki
   prawidlowe w nazwach plikow MS-DOS nie zawsze beda prawidlowe w nazwach
   zmiennych, nazwa pliku nie moze byc slowem kluczowym asemblera itp.

   1.2 Uzycie

       Zgodnie ze skladnia:

       BINC.EXE [dive:][path]<Infile> [drive:][path][OutFile] [/N[:][nazwa]]

       BINC rozpoznaje przeznaczenie plikow po kolejnosci ich wystepowania
       w linii polecen. Pierwsza napotkana nazwa pliku bedzie traktowana jako
       nazwa pliku zrodlowego.
       Polozenie przelacznika /N jest dowolne.

2. PLIK WYJSCIOWY

   Kazda linia sklada sie z 16 pozycji i zaczyna sie od dyrektywy 'DB'.
   Kazda pozycja zawiera jeden bajt szestnastkowo w ASCII, z tym, ze:
   W przeciwienstwie do innych tego typu programow, BINC nie zapisuje do
   generowanej tablicy nadmiarowych znakow:
   - Cyfry szestnastkowe 0..9 nie wymagaja zadnych dodatkowych znakow.
   - Liczby szestnastkowe zaczynajace sie od cyfry dziesietnej nie wymagaja
     poprzedzajacego zera.

3. BLEDY I KOMUNIKATY

   3.1 W przypadku bledow podczas operacji na plikach, program wyswietli
       komunikat:

       > Blad operacji na pliku.

   3.2 W przypadku gdy w linii polecen nie podano nazwy pliku do konwersji,
       podano nazwe niezgodna z MS-DOS, podano nazwe nieistniejacego pliku
       czy wpisano przypadkowy ciag znakow, to program wyswietli komunikat
       przedstawiajacy poprawna skladnie.

   3.3 Gdy plik zrodlowy ma 0 bajtow:

       > Plik zrodlowy jest pusty.

   3.4 Plik docelowy wystepuje juz w danej lokalizacji:

       > Plik docelowy istnieje juz w podanej lokalizacji. Nadpisac (t/n)?

       Nalezy wpisac litere i zatwierdzic wybor entrem.

       Przerwanie procesu przez uzytkownika komunikowane jest napisem:

       > Zapis przerwano.

   3.5 Prawidlowy przebieg programu wraz z wygenerowaniem pliku docelowego
       zostanie zakomunikowane napisem:

       > Plik OutFile.inc zapisano w podanej lokalizacji.


4. KOMPATYBILNOSC

   Program zostal przetestowany z:

   MS-DOS 5.0+   - VM. Wersja 1.1 pracowala na maszynie fizycznej.
   FreeDOS 1.3   - na VM.
   DOSBox 0.74-3 - Kompilacja i testy wersji 3.2
