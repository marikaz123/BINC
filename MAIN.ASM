;============================================================================
; BINC v2.3.1 * MOD2502                                    (c)1995 'marikaz'
; --------------------------------------------------------------------------
; Konwertuj plik binarny do pliku, ktory mozna dolaczyc do kodu zrodlowego
; w asemblerze w postaci DB ...
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

CODESEG
EXTRN GetParams:PROC,Bin2db:PROC
EXTRN ChoiceBpl:PROC  ;czeka na t/n i enter -> choicex.lib
JUMPS

        PROC Main
        call GetParams
        mov ax,DGROUP
        mov ds,ax
        mov es,ax
        jc infMsg     ;CY, wyswietl info. (ax=0
        FFIND ifSpec
        jc infMsg
        IFEMPTY
        je emErr

        FFIND ofSpec
        jc openFiles
        mov si,OFFSET ynMsg
        call @Puts
        call ChoiceBpl ;(t/n)?
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
        FREAD inBuf,256
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
        push ax
        mov ah,0eh
    @@pl:
        lodsb
        or al,al
        jz @@ex
        int 10h
        jmp @@pl
    @@ex:
        pop ax
        ret
        ENDP
;--------------------------
DATASEG
PUBLIC aLabel,inFile,outFile
hTmp    DW ?
aLabel  DB 15 DUP(0),0
inFile  DB 12 DUP(0),0
outFile DB 12 DUP(0),0

ioMsg   DB 'Bledy podczas operacji na pliku.',13,10,0
empMsg  DB 'Plik zrodlowy jest pusty.',13,10,0
ynMsg   DB 'Plik docelowy istnieje juz w podanej lokalizacji. Nadpisac (t/n)? ',0
brkMsg  DB 'Zapis przerwano.',13,10,0
okMsg   DB 'Plik ',0
okMsg2  DB ' zapisano w podanej lokalizacji.',13,10,0
wMsg    DB 'Czekaj... ',0

        INCLUDE 'imsg.inc'

UDATASEG
PUBLIC ifSpec,ofSpec,inBuf,outBuf
ifSpec  DB   64 DUP(?)
ofSpec  DB   64 DUP(?)
inBuf   DB  256 DUP(?)
outBuf  DB 1362 DUP(?)

STACK 100h

        END Main
