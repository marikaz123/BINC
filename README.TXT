-----------------------------------------------------------------------------
    ***  BINC ver. 2.8.1 ***
                                                           (c)1995 'marikaz'
-----------------------------------------------------------------------------


1. DZIALANIE

   Program wykonuje konwersje dowolnego pliku do postaci, ktora mozna
   bezposrednio dolaczyc do zrodla asemblerowego jako definicje bajtow.
   Kazdy bajt pliku zrodlowego zamieniany jest na jego reprezentacje w
   postaci liczb szestnastkowych, dziesietnych lub binarnych.

       Skladnia
       --------

       BINC.EXE  [/B[B] | /D | /H] [/I=nn] [/N[:][name]]
                 <InFileSpec> [OutFileSpec]

     /B          Generuj wartosci dwojkowe.
     /BB         Wartosci binarne otrzymuja komplet 8 cyfr i b na koncu.
     /D          Generuj wartosci dziesietne.
     /H          Generuj wartosci szestnastkowe (domyslnie).
     /I=nn       Ilosc pozycji w linii, nn=1..16 (domyslnie 16).
     /N[:]name   name = nazwa dla wygenerowanej tablicy (max. 15 znakow).
     /N[:]       Nazwa tablicy otrzyma nazwe pliku <InFile> bez rozszerzenia.
     InFileSpec  Lokalizacja i nazwa pliku zrodlowego (wymagana).
     OutFileSpec Lokoalizacja i nazwa pliku docelowego

   Jesli nie podano sciezki i nazwy dla pliku docelowego to w lokalizacji
   pliku wejsciowego zostanie wygenerowany plik o tej samej nazwie a
   rozszerzenie zostanie zastapione (lub dodane) rozszerzeniem inc.

       Uzycie
       ------

     BINC.EXE c:\test\plik.bin d:\plik.inc /n:tabl0 /i=8 /bb

   - Pierwsza napotkana nazwa pliku wraz ze sciezka bedzie traktowana jako
     specyfikacja pliku zrodlowego.
   - Jezeli plik docelowy ma sie znalezc w innej lokalizacji niz plik
     zrodlowy, to oprocz sciezki nalezy obowiazkowo podac nazwe dla tego
     pliku.
   - Opcja /H (hex) jest domyslna i nie jest wymagana, wystepuje tylko
     dla porzadku.
   - Opcja /BB powoduje, ze rozwiniecie binarne otrzymuje komplet
     8 cyfr oraz b na koncu. Np. 0 = 00000000b itd.
   - Opcja /I=nn zapisuje nn pozycji w wierszu.
     Uwaga! Ze wzgledu na pewne uproszczenia dla I=9, 11 i 13, niektore
     linie "z rzadka" beda mialy mniejsza liczbe pozycji.
   - Opcja /N[:] doda, jako nazwe tablicy, nazwe pliku zrodlowego.
     Uwaga, niektore znaki prawidlowe w nazwach plikow moga byc niepoprawne
     w nazwach zmiennych.


2. PLIK WYJSCIOWY
   Uwaga! Autor zalozyl 'RADIX 10' jako domyslny i zawsze obowiazujacy
   w plikach zrodlowych.

   Kazda linia sklada sie z nn pozycji i zaczyna sie od dyrektywy DB.
   Kazda pozycja jest rozdzielona przecinkiem i zawiera jeden bajt dwojkowo,
   dziesietnie lub szestnastkowo w ASCII.
   Z tym, ze w przeciwienstwie do innych tego typu programow, BINC nie
   zapisuje do generowanej tablicy nadmiarowych znakow:
   - Cyfry szestnastkowe 0..9 nie wymagaja zadnych dodatkowych znakow.
   - Liczby szestnastkowe zaczynajace sie od cyfry dziesietnej nie wymagaja
     poprzedzajacego zera,
   - cyfry i liczby dziesietne nie maja zadnych dodatkowych znakow,
   - a binarne 0 i 1 bez b na koncu.
   

3. BLEDY I KOMUNIKATY

      Bledy
      -----
   Program zostal tak skonstruowany, ze jedyny mozliwy destrukcyjny
   mechanizm zawarty w programie, czyli zapis na dysk, odbywa sie
   dopiero w momencie, gdy wszystkie parametry podane przez uzytkownika
   w linii polecen programu przejda wewnetrzna walidacje.
   W razie napotkania nieprawidlowosci wykonywanie programu zostanie
   przerwane stosownym komunikatem.

   OBSLUGA BLEDOW MOGACYCH SIE POJAWIC PODCZAS WYKONYWANIA PROGRAMU ZOSTALA
   ZAIMPLEMENTOWANA I PRZETESTOWANA. NALEZY JEDNAK PAMIETAC, ZE PROGRAM
   INTENSYWNIE OPERUJE NA PLIKACH I ZAPISIE NA DYSK.
   NALEZY MIEC SWIADOMOSC, ZE PRZY TAKIEJ OKAZJI MOZE DOJSC DO UTRATY
   (NADPISANIA) ISTNIEJACYCH DANYCH.

     Komunikaty
     ----------
   - Bledy napotkane podczas pracy programu natychniast przerywaja jego
     dzialanie stosownym komunikatem.
     Najczestrze bledy polegaja na literowkach lub niespojnosci linii
     polecen ze skladnia sa kominikowane sa wyswietleniem info.
     Info mozna rowniez uzyskac wpisujac:

       BINC.EXE /?

     a przy bledach w nazwach sciezek lub plikow:

       Blad i/o operacji na pliku.

   - Przy probie nadpisania (zapisu do) istniejacego juz na dysku pliku,
     pojawi sie komunikat wymagajacy potwierdzenia od uzytkownika takiego
     dzialania.


4. UWAGI DOTYCZACE KOMPILACJI ZE ZRODEL

   - W kodzie zrodlowym wystepuja linie odwolujace sie do makr zawartych
     w pliku 'ifileio.mac', ktorego nie ma w repozytorium. Makra wykonuja
     standardowe operacje na plikach.
     Nazwy sa jednoznaczne i mozna zastapic bezposrednio kodem.

   - W 'main.asm' wystepuje wywolanie procedury ChoiceBpl, ktora znajduje
     sie w zewnetrznej bibliotece i nie ma jej w repozytorium. Funkcja
     zwraca NC dla znakow 't','T' lub CY dla 'n','N', natomiast inne
     klawisze ignoruje. Mozna zastapic kilkoma liniami kodu.


5. KOMPATYBILNOSC

   MS-DOS 5.0+   - na VM. (Wersje do 2.2 rowniez na maszynie fizycznej)
   FreeDOS 1.3+  - na VM.
   DOSBox 0.74-3 - Kompilacja i testy.
   
   ---