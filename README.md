# BINC dla DOS (DOSBox)
<sup> MOD06/2023</sup>   

Program wykonuje konwersj� dowolnego (w domy�le binarnego) pliku do postaci, kt�r� mo�na bezpo�rednio do��czy� do tekstu �r�d�owego w asemblerze jako 'definicje bajt�w'. 
Ka�dy bajt pliku �r�d�owego jest zamieniany na jego reprezentacj� w postaci liczb szestnastkowych w ASCII z zachowaniem regu� obowi�zuj�cych dla sk�adni asemblera (MASM, TASM i kompatybilnych).

## Uruchomienie i dzia�anie

```
binc <InFile.ext> [OutFile.ext]
```

Gdzie:   
`InFile.ext` - jest nazw� pliku do konwersji (�r�d�owym).   
`OutFile.ext` - jest nazw� pliku ze skonwertowanym �r�d�em (opcjonalnie).    

W wyniku dzia�ania programu zostanie utworzony plik o nazwie podanej jako drugi parametr linii polece�. Je�li tej nazwy nie podano zostanie utworzony plik o nazwie identycznej z nazw� pliku �r�d�owego ale z rozszerzeniem `.inc`. Czyli w tym przypadku: `InFile.inc`.   
Plik docelowy b�dzie zawiera� dane z pliku �r�d�owego skonwertowane do postaci:

```
DB 1,0,3Ch,0Ah,12h,0FFh ...
DB ...
```
Ka�da linia zawiera seri� 16 pozycji po 1 bajcie rozdzielonych przecinkami. W celu maksymalnego zmniejszenia pliku docelowego, BINC pozbywa si� nadmiarowych znak�w, zachowuj�c jednocze�nie poprawno�� sk�adni:   
Bajty 0 - 9 nie wymagaj� dodatkowych znak�w, bajty rozpoczynaj�ce si� od cyfry dziesi�tnej nie wymagaj� poprzedzaj�cego 0.

### Ograniczenia
Plik docelowy nie mo�e by� wi�kszy ni� 65440 bajt�w. BINC oczywi�cie kontroluje t� wielko�� i w razie konieczno�ci wy�wietli komunikat.   
Ze wzgl�du na fakt, �e rozmiar pliku docelowego jest �ci�le zwi�zany z rozmiarem pliku �r�d�owego, nale�y pami�ta� o jego "rozs�dnym rozmiarze". Niestety nie da si� precyzyjnie okre�li� "rozs�dnego rozmiaru", bo on zale�y od zawarto�ci pliku binarnego. Podczas wielu test�w na najr�niejszych plikach uda�o si� ustali�, �e pliki binarne o wielko�ci 15kb - 17kb powinny si� zmie�ci� w pliku docelowym, natomiast wi�ksze ju� niekoniecznie (chocia� nie jest to wykluczone).

## B��dy i komunikaty

1. W przypadku b��d�w operacji na plikach program wy�wietli:   
```
    File operation error.
```
Wyj�tek stanowi b��d otwarcia pliku, kt�ry polega na �le wpisanej nazwie (liter�wce) lub braku samego pliku na dysku.

2. Gdy w linii polece� nic nie podano, podano z�� nazw� czy wpisano przypadkowy ci�g znak�w, program wy�wietli:
```
    Usage:
           binc.exe <FileIn.ext> [FileOut.ext]

    If no output filename is given, BINC defaults to the input
    filename and '.inc' extension.

    - The input filename must match the MS-DOS file system.
    - Access to the input file and writing to disk must be allowed.
```

3. Plik docelowy b�dzie wi�kszy ni� 65440 bajt�w, program wy�wietli komunikat:

```
    Target file is too large.
```

4. Gdy plik �r�dlowy ma 0 bajt�w:
```
    The source file is empty.
```

5. Plik docelowy jest ju� na dysku.

```
    Destination file already exists. Continue? [y/N]
    >_
```
No/Nie przyjmowane jest dla klawiszy: `ENTER` (domy�lnie), `N, n` oraz `ESC`.   

Przerwanie operacji komunikowane jest napisem:
```
    >Discontinued at user's request.
```

Yes/Tak przyjmowane jest dla klawiszy `Y, y` i w takim przypadku plik docelowy zostanie nadpisany now� zawarto�ci�.   

6. Pe�ny, prawid�owy przebieg programu wraz z wygenerowaniem pliku docelowego zostanie zakomunikowane napisem:
```
    FileOut.ext done.

    lub

    FileIn.inc done (je�li nazwy pliku docelowego nie podano)
```

## Kompatybilno��
BINC zosta� przetestowany i dzia�a przwid�owo z:    

DOSBox 0.74 - Na tym emulatorze skompilowano aktualn� wersj�.   
FreeDos 1.3  - Na VirtualBox.   
MS-DOS 5.0+   - Na VirtualBox.   
MS-DOS 5.0+   - wersja 1.3 by�a u�ywana r�wnie� na maszynie fizycznej.   

## Historia wersji

__ver. 2.0 (06/2023)__   
`+` Dodano mo�liwo�� podania (opcjonalnie) w�asnej nazwy dla pliku docelowego.   
`~` Poprawki.

__ver. 1.5 (05/2023)__   
`~` Przebudowa i poprawki v1.3 jeszcze jako 'BIN2DB' z 1995 r.

###### BINC <sub> ver. 2.0 </sub> 1995 'marikaz'
