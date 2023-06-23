# BINC dla DOS (DOSBox)
<sup> MOD06/2023</sup>   

Program wykonuje konwersjê dowolnego (w domyœle binarnego) pliku do postaci, któr¹ mo¿na bezpoœrednio do³¹czyæ do tekstu Ÿród³owego w asemblerze jako 'definicje bajtów'. 
Ka¿dy bajt pliku ¿ród³owego jest zamieniany na jego reprezentacjê w postaci liczb szestnastkowych w ASCII z zachowaniem regu³ obowi¹zuj¹cych dla sk³adni asemblera (MASM, TASM i kompatybilnych).

## Uruchomienie i dzia³anie

```
binc <InFile.ext> [OutFile.ext]
```

Gdzie:   
`InFile.ext` - jest nazw¹ pliku do konwersji (Ÿród³owym).   
`OutFile.ext` - jest nazw¹ pliku ze skonwertowanym Ÿród³em (opcjonalnie).    

W wyniku dzia³ania programu zostanie utworzony plik o nazwie podanej jako drugi parametr linii poleceñ. Jeœli tej nazwy nie podano zostanie utworzony plik o nazwie identycznej z nazw¹ pliku Ÿród³owego ale z rozszerzeniem `.inc`. Czyli w tym przypadku: `InFile.inc`.   
Plik docelowy bêdzie zawiera³ dane z pliku Ÿród³owego skonwertowane do postaci:

```
DB 1,0,3Ch,0Ah,12h,0FFh ...
DB ...
```
Ka¿da linia zawiera seriê 16 pozycji po 1 bajcie rozdzielonych przecinkami. W celu maksymalnego zmniejszenia pliku docelowego, BINC pozbywa siê nadmiarowych znaków, zachowuj¹c jednoczeœnie poprawnoœæ sk³adni:   
Bajty 0 - 9 nie wymagaj¹ dodatkowych znaków, bajty rozpoczynaj¹ce siê od cyfry dziesiêtnej nie wymagaj¹ poprzedzaj¹cego 0.

### Ograniczenia
Plik docelowy nie mo¿e byæ wiêkszy ni¿ 65440 bajtów. BINC oczywiœcie kontroluje t¹ wielkoœæ i w razie koniecznoœci wyœwietli komunikat.   
Ze wzglêdu na fakt, ¿e rozmiar pliku docelowego jest œciœle zwi¹zany z rozmiarem pliku Ÿród³owego, nale¿y pamiêtaæ o jego "rozs¹dnym rozmiarze". Niestety nie da siê precyzyjnie okreœliæ "rozs¹dnego rozmiaru", bo on zale¿y od zawartoœci pliku binarnego. Podczas wielu testów na najró¿niejszych plikach uda³o siê ustaliæ, ¿e pliki binarne o wielkoœci 15kb - 17kb powinny siê zmieœciæ w pliku docelowym, natomiast wiêksze ju¿ niekoniecznie (chocia¿ nie jest to wykluczone).

## B³êdy i komunikaty

1. W przypadku b³êdów operacji na plikach program wyœwietli:   
```
    File operation error.
```
Wyj¹tek stanowi b³¹d otwarcia pliku, który polega na Ÿle wpisanej nazwie (literówce) lub braku samego pliku na dysku.

2. Gdy w linii poleceñ nic nie podano, podano z³¹ nazwê czy wpisano przypadkowy ci¹g znaków, program wyœwietli:
```
    Usage:
           binc.exe <FileIn.ext> [FileOut.ext]

    If no output filename is given, BINC defaults to the input
    filename and '.inc' extension.

    - The input filename must match the MS-DOS file system.
    - Access to the input file and writing to disk must be allowed.
```

3. Plik docelowy bêdzie wiêkszy ni¿ 65440 bajtów, program wyœwietli komunikat:

```
    Target file is too large.
```

4. Gdy plik Ÿródlowy ma 0 bajtów:
```
    The source file is empty.
```

5. Plik docelowy jest ju¿ na dysku.

```
    Destination file already exists. Continue? [y/N]
    >_
```
No/Nie przyjmowane jest dla klawiszy: `ENTER` (domyœlnie), `N, n` oraz `ESC`.   

Przerwanie operacji komunikowane jest napisem:
```
    >Discontinued at user's request.
```

Yes/Tak przyjmowane jest dla klawiszy `Y, y` i w takim przypadku plik docelowy zostanie nadpisany now¹ zawartoœci¹.   

6. Pe³ny, prawid³owy przebieg programu wraz z wygenerowaniem pliku docelowego zostanie zakomunikowane napisem:
```
    FileOut.ext done.

    lub

    FileIn.inc done (jeœli nazwy pliku docelowego nie podano)
```

## Kompatybilnoœæ
BINC zosta³ przetestowany i dzia³a przwid³owo z:    

DOSBox 0.74 - Na tym emulatorze skompilowano aktualn¹ wersjê.   
FreeDos 1.3  - Na VirtualBox.   
MS-DOS 5.0+   - Na VirtualBox.   
MS-DOS 5.0+   - wersja 1.3 by³a u¿ywana równie¿ na maszynie fizycznej.   

## Historia wersji

__ver. 2.0 (06/2023)__   
`+` Dodano mo¿liwoœæ podania (opcjonalnie) w³asnej nazwy dla pliku docelowego.   
`~` Poprawki.

__ver. 1.5 (05/2023)__   
`~` Przebudowa i poprawki v1.3 jeszcze jako 'BIN2DB' z 1995 r.

###### BINC <sub> ver. 2.0 </sub> 1995 'marikaz'
