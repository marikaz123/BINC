;===========================================================================;
; BINC v2.7 ** MOD2602                                    (c)1995 'marikaz' ;
; ------------------------------------------------------------------------- ;
; Konwertuj plik binarny do pliku, ktory mozna dolaczyc do kodu zrodlowego  ;
; w asemblerze.                                                             ;
;                                                                           ;
; Skladnia:                                                                 ;
;                                                                           ;
; BINC.EXE  <InFileSpec> [OutFileSpec] \      -pliki we/wy                  ;
;           [{/B[B] | /D | /H}]        \      -reprezentacja wartosci       ;
;           [/N[:][name]]              \      -nazwa tabl.                  ;
;           [/I=nn]                    \      -ilosc pozycji                ;
;                                                                           ;
;===========================================================================;

INCLUDE INC\header.inc

        IDEAL
        MODEL SMALL

        CODESEG

EXTRN GetParams:PROC,Bin2db:PROC
EXTRN ChoiceBpl:PROC  ;choicex.lib
EXTRN @B2HASC:NEAR
PUBLIC vProc

        JUMPS

PROC    Main
        call GetParams
        mov ax,DGROUP
        mov ds,ax
        mov es,ax
        jc infMsg     ;CY, wyswietl info.
        mov si,OFFSET inFile
        mov di,OFFSET outFile
        mov cx,12
        repe cmpsb
        or cx,cx
        jz fnErr ;nazwy plikow nie moga byc idenyczne
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
        FWRITE hdr,HDRLEN ;dodaj info do pliku docelowego
do:
        lea si,[inBuf]
        lea di,[outBuf]
        xchg bx,[hTmp]    ;bx=hInFile
        FREAD inBuf,IBS
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
fnErr:
        mov si,OFFSET fnMsg
        mov al,4
        jmp exit
infMsg:
        mov dx,OFFSET info
        mov ah,9h
        int 21h
        mov al,-1
        jmp exit+3 ;pomin call
        ENDP

PROC    @Puts
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

PUBLIC aLabel,inFile,outFile,iNum,mode
mode    FLAGS <0,0,0> ;allz,bdh,itm
hTmp    DW ?
iNum    DW 16
aLabel  DB 15 DUP(0),0
inFile  DB 12 DUP(0),0
outFile DB 12 DUP(0),0

ioMsg   DB 'Blad podczas operacji na pliku.',13,10,0
empMsg  DB 'Plik zrodlowy jest pusty.',13,10,0
fnMsg   DB 'Nazwa pliku zrodlowego nie moze byc nazwa dla pliku docelowego.',13,10,0
ynMsg   DB 'Plik docelowy juz istnieje w podanej lokalizacji. Nadpisac [t/n]? ',0
brkMsg  DB 'Zapis przerwano.',13,10,0
okMsg   DB "plik ",0
okMsg2  DB " zostal zapisany w wybranej lokalizacji.",13,10,0
wMsg    DB 'Czekaj... ',0

INCLUDE '.\INC\imsg.inc'

        UDATASEG

PUBLIC ifSpec,ofSpec,inBuf,outBuf
ifSpec  DB  64 DUP(?)
ofSpec  DB  64 DUP(?)
inBuf   DB IBS DUP(?)
outBuf  DB OBS DUP(?)

        STACK 100h

        END Main
