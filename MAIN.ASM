;============================================================================
; BINC v2.4 * MOD2505                                     (c)1995 'marikaz'
; --------------------------------------------------------------------------
; Konwertuj plik binarny do pliku, ktory mozna dolaczyc do kodu zrodlowego
; w asemblerze w postaci: DB ...
;============================================================================

        IDEAL
        MODEL SMALL

        INCLUDE '..\..\_MAC\ifileio.mac'

        MACRO IFEMPTY
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

IBL = 240  ; /i = 1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 16

CODESEG
EXTRN GetParams:PROC,Bin2db:PROC
EXTRN ChoiceBpl:PROC  ;czeka na t/n i enter -> choicex.lib
EXTRN @B2HASC:NEAR
PUBLIC vProc
JUMPS

        PROC Main
        call GetParams
        mov ax,DGROUP
        mov ds,ax
        mov es,ax
        jc infMsg     ;CY, wyswietl info.
        FFIND ifSpec
        jc infMsg
        IFEMPTY
        je emErr

        FFIND ofSpec
        jc openFiles
        mov si,OFFSET ynMsg
        call @Puts
        call ChoiceBpl
        jc break ;CY=odp.nie

openFiles:
        FOPEN ifSpec,RE
        jc ioErr
        mov [hTmp],ax
        FCREATE ofSpec
        jc ioErr
        mov bx,ax
        mov si,OFFSET wMsg
        call @Puts
do:
        lea si,[inBuf]
        lea di,[outBuf]
        xchg bx,[hTmp]    ;bx=hInFile
        FREAD inBuf,IBL
        or ax,ax
        jz closeFiles
        mov cx,ax
        call Bin2db ;ret: cx=ilosc bajtow w buforze
        xchg bx,[hTmp] ;bx= hOutFlile
        FWRITE outBuf
        jmp do

closeFiles:
        FCLOSE
        xchg bx,[hTmp]
        FCLOSE
        mov si,OFFSET okMsg
        call @Puts
        mov si,OFFSET outFile
        call @Puts
        mov si,OFFSET okMsg2
        mov al,0

exit:
        call @Puts
        mov ah,4ch
        int 21h
break:
        mov si,OFFSET brkMsg
        mov al,3
        jmp exit
ioErr:
        mov si,OFFSET ioMsg
        mov al,1
        jmp exit
emErr:
        mov si,OFFSET empMsg
        mov al,2
        jmp exit
infMsg:
        mov si,OFFSET info
        mov al,-1
        jmp exit
        ENDP

        PROC @Puts
        LOCALS
        push ax bx
        mov bh,0
        mov ah,0eh
    @@pl:
        lodsb
        or al,al
        jz @@ex
        int 10h
        jmp @@pl
    @@ex:
        pop bx ax
        ret
        ENDP

vProc   DW @B2HASC ;domyslnie hex

DATASEG
PUBLIC aLabel,inFile,outFile,iNum,fl
hTmp    DW ?
iNum    DW 16
fl      DB 0,0
aLabel  DB 15 DUP(0),0
inFile  DB 12 DUP(0),0
outFile DB 12 DUP(0),0

ioMsg   DB 'Bledy podczas operacji na pliku.',13,10,0
empMsg  DB 'Plik zrodlowy jest pusty.',13,10,0
ynMsg   DB 'Plik docelowy istnieje juz w podanej lokalizacji. Nadpisac [t/n]? ',0
brkMsg  DB 'Zapis przerwano.',13,10,0
okMsg   DB "Plik '",0
okMsg2  DB "' zapisano w podanej lokalizacji.",13,10,0
wMsg    DB 'Czekaj... ',0

        INCLUDE 'imsg.inc'

UDATASEG
PUBLIC ifSpec,ofSpec,inBuf,outBuf
ifSpec  DB   64 DUP(?)
ofSpec  DB   64 DUP(?)
inBuf   DB  IBL DUP(?)
outBuf  DB 3400 DUP(?)

STACK 100h

        END Main
