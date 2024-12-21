;----------------------------------------------------------------------------
; BINC v2.2.2 * MOD1124 * (c)1995 'marikaz'
;  ++++
; Konwertuj plik binarny do pliku, ktory mozna dolaczyc do kodu zrodlowego
; programu w asemblerze.
;----------------------------------------------------------------------------
; Glowna czesc programu. Czyta i zapisuje pliki, obsluguje bledy, podaje
; komunikaty, wola procedury itd.
;----------------------------------------------------------------------------

_TEXT SEGMENT WORD PUBLIC 'CODE'
      ASSUME cs:_TEXT,ds:_DATA
      EXTRN bin2db:PROC,getParam:PROC

JUMPS
start:
          call GetParam   ;GP.ASM
          mov ax,_DATA
          mov ds,ax
          cmp bx,1
        je  prnInfo
          mov ah,4eh ;czy na dysku?
          mov cx,1
          lea dx,fileOut
          int 21h
          jc nsfn
        lea dx,existTxt
          mov ah,9
          int 21h
getKey:
          mov ah,7
          int 21h
          cmp al,1bh
          je brk
          cmp al,0dh
          je brk
          mov ah,al      ;w ah kopia do sprawdzen
          or al,100000b
          cmp al,'n'
          je brk
          or ah,100000b
          cmp ah,'y'
          jne getKey
nsfn:
          mov ax,3d00h
          lea dx,fileIn
          int 21h
          jc prnInfo
          mov bx,ax

          mov ah,3fh
          lea dx,ssf
          mov cx,0f000h            ;max. bufor
          int 21h
          jc  fileErr
          cmp ax,0                 ;plik 0b?
          je  err0b
          mov cx,ax

          mov ah,3eh
          int 21h

          call Bin2db              ;B2D.ASM w cx=wielkosc pliku.
          cmp cx,0ffa0h
          ja  ovInfo

          push cx
          mov ah,3ch
          mov dx,OFFSET fileOut
          mov cx,0
          int 21h
          jc  fileErr
          mov bx,ax

          pop cx
          mov ax,_BSS
          mov ds,ax
          mov ah,40h
          lea dx,sdf
          int 21h
          mov ax,_DATA
          mov ds,ax
          jc  fileErr

          mov ah,3eh
          int 21h

          mov bx,SPaddr
          mov BYTE PTR [bx],20h
          mov dx,OFFSET fileOut
          mov ah,9
          int 21h
          mov al,0
exit:
          mov ah,4ch
          int 21h

brk:
          mov ah,9
          mov dx,OFFSET brkTxt
          int 21h
          mov al,0
          jmp exit

prnInfo:
          mov dx,OFFSET info
          mov ah,9
          int 21h
          mov al,0
          jmp exit
fileErr:
          mov dx,OFFSET foTxt
          mov ah,9
          int 21h
          jmp exit
err0b:
          mov dx,OFFSET txt0b
          mov ah,9
          int 21h
          mov al,0
          jmp exit
ovInfo:
          mov dx,OFFSET ovTxt
          mov ah,9
          int 21h
          mov al,-1
          jmp exit

_TEXT ENDS

_DATA SEGMENT WORD PUBLIC 'DATA'
PUBLIC ssf,fileIn,fileOut,SPaddr,aName

info      DB "BINC v2.2 * (c)1995 'marikaz'",13,10
          DB 'Convert binary file to assembly include file.',13,10,13,10
          DB '    BINC.EXE <InFile.ext> [OutFile.ext] [/N[:][name]]',13,10,13,10
          DB '/N[:]name  Array name, max. 15 characters.',13,10
          DB '/N[:]      Set the input filename without extension as the array name.',13,10,13,10
          DB 'If no destination filename is provided, BINC will default to the input filename',13,10
          DB 'with the INC extension.',13,10,'$'
foTxt     DB 'File operation error.',13,10,'$'
ovTxt     DB 'The target file is too large.',13,10,'$'
txt0b     DB 'The source file is empty.',13,10,'$'
existTxt  DB 'A file already exists. Continue? [y/N]',13,10,'> $'
brkTxt    DB 'Discontinued at user request.',13,10,'$'
aName     DB 0,15 DUP (20h)
fileIn    DB 12 DUP (0),0
fileOut   DB 12 DUP (0),0,6 DUP (20h)
SPaddr    DW ?

ssf       DB 0f000h DUP (?)

_DATA ENDS

STACK SEGMENT PARA STACK 'STACK'
      DW 32 DUP (?)
STACK ENDS

_BSS SEGMENT WORD PUBLIC 'BSS'
     PUBLIC sdf
sdf  LABEL BYTE
_BSS ENDS
     END start