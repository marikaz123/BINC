;-----------------------------------------------------------------
;    BINC  ver. 1.5
;    Convert binary file to assembly include file.
;
;                                              MAIN.ASM: rev. 1.6
; (c) 1995 'marikaz'                                MOD: 05/2023
;-----------------------------------------------------------------
; Glowna czesc programu. Czyta i zapisuje pliki, obsluguje bledy,
; podaje komunikaty, wola procedury itd.
;-----------------------------------------------------------------

code segment public 'code'
assume cs:code,ds:data
extrn bin2db:proc,getParam:proc

start:
          call getParam   ;GP.ASM
          mov ax,data
          mov ds,ax
          cmp bx,1
          jne @@1
          jmp  prnInfo
     @@1:
          mov ah,4eh      ;plik docelowy jest na dysku?
          mov cx,1
          lea dx,fileOut
          int 21h
          jc continue
          lea dx,existTxt
          mov ah,9
          int 21h
getKey:
          mov ah,7
          int 21h
          cmp al,1bh     ;escape (zawsze No)
          je abort
          cmp al,0dh     ;enter (domyslnie No)
          je abort
          mov ah,al      ;w ah kopia do sprawdzen
          or al,100000b  ;na mala
          cmp al,'n'
          je abort
          or ah,100000b
          cmp ah,'y'
          jne getKey
continue:
          mov ax,3d00h
          lea dx,fileIn
          int 21h
          jc  prnInfo
          mov bx,ax

          mov ah,3fh
          lea dx,ssf
          mov cx,0fe00h            ;max. bufor
          int 21h
          jc  fileErr
          cmp ax,0                 ;plik 0b?
          je  err0b
          mov cx,ax                ;ilosc odczytanych bajtow dla bin2db

          mov ah,3eh
          int 21h
          jc  fileErr

          call bin2db              ;B2D.ASM
                                   ;w cx zwraca ilosc bajtow pliku docelowego
          cmp cx,0ffa0h
          ja  ovInfo

          push cx                  ;zachowaj cx dla zapisu do pliku
          mov ah,3ch
          mov dx,OFFSET fileOut
          mov cx,0
          int 21h
          jc  fileErr
          mov bx,ax

          pop cx
          mov ax,file
          mov ds,ax
          mov ah,40h
          lea dx,sdf
          int 21h
          mov ax,data
          mov ds,ax
          jc  fileErr

          mov ah,3eh
          int 21h
          jc  fileErr

          mov bx,SPaddr
          mov byte ptr [bx+4],20h ;wstaw spacje (dla CP852)
          mov dx,OFFSET fileOut
          mov ah,9
          int 21h
          mov al,0
exit:
          mov ah,4ch
          int 21h

abort:
          mov ah,9
          mov dx,OFFSET intProc
          int 21h
          mov al,0
          jmp exit
prnInfo:
          mov dx,OFFSET info
          mov ah,9
          int 21h
          jmp exit
fileErr:
          mov dx,OFFSET errtxt
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
code      ends

data segment public 'data'
public ssf,fileIn,fileOut,SPaddr

info      DB " BINC ver. 1.5 * (c)1995 'marikaz'",13,10
          DB ' Convert binary file to assembly include file.',13,10,13,10
          DB ' Usage: binc.exe <filename.ext>',13,10,13,10
          DB ' - The source file must exist on the disk.',13,10
          DB ' - The source file name must match the MS-DOS file system.',13,10
          DB ' - Access to the source file can not be denied.',13,10,'$'
errTxt    DB 'File operation error.$'
ovTxt     DB 'The destination file is too large.$'
txt0b     DB 'The source file is empty.$'
existTxt  DB 'Destination file already exists. Continue? [y/N]',13,10,'>$'
intProc   DB "Discontinued at user's request.$"
SPaddr    DW ?
fileIn    DB 12 DUP (0),0
fileOut   DB 12 DUP (0),0,6 DUP (20h)
ssf       DB 0FE00h DUP (?)
data ends

sstk segment stack 'stack'
          DW 32 DUP (?)
sstk ends

file segment public 'file'
public sdf
sdf label word
file ends
     END start