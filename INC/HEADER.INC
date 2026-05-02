; -- BINC v2.x --
INCLUDE ..\..\_MAC\fileio.mac
FLAGS RECORD allz:1,bdh:1,itm:1

IBS = 1680          ;dla i=9, 11, 13 nierowno
OBS = IBS/16*224+16 ;244b max. rozmiar tablicy dla 16 bajtow zrodla przy
                    ;parametrach /b8 /i=1
                    ;plus (16b) dlugosc nazwy tablicy + spacja

IFEMPTY MACRO
        LOCAL @ex
        push es
        mov ah,2fh
        int 21h
        cmp [WORD es:bx+1ah],0
        jne @ex
        cmp [WORD es:bx+1ch],0
   @ex:
        pop es
        ENDM
