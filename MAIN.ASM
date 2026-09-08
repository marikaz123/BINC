;===========================================================================;
; BINC v2.8 ** MOD2608                                    (c)1995 'marikaz' ;
; ------------------------------------------------------------------------- ;
; Konwertuj plik na tablice dla assemblera.                                 ;
;===========================================================================;

INCLUDE .\INC\binc_h.inc
BSIZEW = (LENGTH ofName+LENGTH aLabel+LENGTH ifSpec+LENGTH ofSpec)/2

        IDEAL
        MODEL SMALL

        CODESEG

EXTRN GetParams:PROC,Bin2db:PROC
EXTRN ChoiceBpl:PROC  ;choicex.lib
PUBLIC vProc

        JUMPS

PROC    Main
        mov ax,@DATA
        mov es,ax
        xor ax,ax
        lea di,[es:buffers]
        mov cx,BSIZEW
        rep stosw
        call GetParams
        push es
        pop ds
        jc infMsg
        mov si,OFFSET ifSpec
        mov di,OFFSET ofSpec
        mov cx,80 ;caly bufor
        repe cmpsb
        jcxz fnErr
        FFIND ifSpec
        jc infMsg
        IFEMPTY
        je emErr

        FFIND ofSpec
        jc openFiles
        mov si,OFFSET ynMsg
        call @Puts
        call ChoiceBpl
        jc break

openFiles:
        call @QCurPos
        FOPEN ifSpec,RE
        jc ioErr      ;
        mov [hFile],ax
        FCREATE ofSpec
        jc ioErr
        mov bx,ax
        mov si,OFFSET wMsg
        call @Puts
        FWRITE hdr,HDRLEN ;dodaj info do pliku docelowego

do:
        lea si,[inBuf]
        lea di,[outBuf]
        xchg bx,[hFile]    ;bx=hInFile
        FREAD inBuf,IBS
        or ax,ax
        jz done
        mov cx,ax
        call Bin2db ;ret: cx=ilosc bajtow w buforze
        xchg bx,[hFile] ;bx= hOutFlile
        FWRITE outBuf
        jmp do

done:
        FCLOSE
        xchg bx,[hFile]
        FCLOSE
        call @SCurPos
        mov si,OFFSET okMsg
        call @Puts
        mov si,OFFSET ofName
        call @Puts
        mov si,OFFSET okMsg2
        mov al,0

exit:
        call @Puts
        mov ah,4ch
        int 21h
break:
        mov si,OFFSET brkMsg
        mov al,1
        jmp exit
ioErr:
        mov si,OFFSET ioMsg
        mov al,1
        jmp exit
emErr:
        mov si,OFFSET empMsg
        mov al,1
        jmp exit
fnErr:
        mov si,OFFSET fnMsg
        mov al,1
        jmp exit
infMsg:
        test ax,2
        je inf
        mov si,OFFSET icMsg
        mov al,1
        jmp exit
inf:
        mov dx,OFFSET info
        mov ah,9h
        int 21h
        mov al,1
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

PROC    @SCurPos
        mov ah,2
        mov bh,0
        mov dx,[cPos]
        int 10h
        ret
        ENDP

PROC    @QCurPos
        push bx
        mov ah,3
        mov bh,0
        int 10h
        mov [cPos],dx
        pop bx
        ret
        ENDP

vProc   DW @B2HASC ;domyslnie hex

        DATASEG

PUBLIC aLabel,ofName,iNum,mode
PUBLIC ifSpec,ofSpec,inBuf,outBuf

iNum   DW 16
mode   FLAGS <0,0,0> ;allz,bdh,itm

ioMsg  DB 'Blad i/o podczas operacji na pliku.',13,10,0
icMsg  DB 'Nieprawidlowy znak w sciezce lub nazwie pliku.',13,10,0
empMsg DB 'Plik zrodlowy jest pusty.',13,10,0
fnMsg  DB 'Dla plikow w tej samej lokalizacji, nazwa pliku zrodlowego '
       DB 'nie moze byc nazwa',13,10
       DB 'dla pliku docelowego.',13,10,0
ynMsg  DB 'Plik docelowy juz istnieje w danej lokalizacji. Nadpisac [t/n]? ',0
brkMsg DB 'Zapis przerwano.',13,10,0
okMsg  DB 'Plik ',0
okMsg2 DB ' zostal zapisany w wybranej lokalizacji.',13,10,0
wMsg   DB 'Czekaj...',0

       INCLUDE '.\INC\imsg.inc'

IFDEF ADDVER
 DB 'Version 2.8.0.2608'
ENDIF

EVENDATA
hFile   DW ?
cPos    DW ?

LABEL   buffers
ofName  DB  14 DUP(?)
aLabel  DB  16 DUP(?)
ifSpec  DB 128 DUP(?)
ofSpec  DB 128 DUP(?)

inBuf   DB IBS DUP(?)
outBuf  DB OBS DUP(?)

        STACK 100h

        END Main
