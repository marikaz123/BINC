;-----------------------------------------------------------------
; BINC  ver. 1.5 ** MOD0623 ** (c)1995 'marikaz'
; Convert binary file to assembly include file.
;   +++
; Konwertuj plik binarny do pliku, ktory mozna dolaczyc do zrodla
; w asemblerze.
;
; -- NOTES: ------------------------------------------------------
; Glowna czesc programu. Czyta i zapisuje pliki, obsluguje bledy,
; podaje komunikaty, wola procedury itd.
;-----------------------------------------------------------------

code SEGMENT PUBLIC 'code'
ASSUME cs:code,ds:data
EXTRN bin2db:PROC,getParam:PROC

start:
          call getParam   ;GP.ASM
          mov ax,data
          mov ds,ax
          cmp bx,1        ;nazwa pliku nielegalna lub nie podano
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
          or al,100000b  ;zamien na mala
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
          mov cx,0f000h            ;max. bufor
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
          mov BYTE PTR [bx+4],20h ;wstaw spacje (dla CP852: DOS 6.22)
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
          mov al,0
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
code      ENDS

data SEGMENT PUBLIC 'data'
PUBLIC ssf,fileIn,fileOut,SPaddr

info      DB 13,10," BINC ver. 2.0 :: (c)1995 'marikaz'",13,10
          DB ' Convert binary file to assembly include file.',13,10,13,10
          DB ' Usage:',13,10,'        binc.exe <FileIN.ext> [FileOUT.ext]',13,10,13,10
          DB " If no output filename is given, BINC defaults to the input",13,10
          DB " filename and '.INC' extension.",13,10,13,10
          DB ' - The input filename must match the MS-DOS file system.',13,10
          DB ' - Access to the input file and writting to disk must be allowed.',13,10,'$'
errTxt    DB 'File operation error.$'
ovTxt     DB 'The destination file is too large.$'
txt0b     DB 'The source file is empty.$'
existTxt  DB 'Destination file already exists. Continue? [y/N]',13,10,'>$'
intProc   DB "Discontinued at user's request.$"
SPaddr    DW ?
fileIn    DB 12 DUP (0),0
fileOut   DB 12 DUP (0),0,6 DUP (20h)
ssf       DB 0f000h DUP (?)
data ENDS

sstk SEGMENT STACK 'stack'
     DW 32 DUP (?)
sstk ENDS

file SEGMENT PUBLIC 'file'
PUBLIC sdf
sdf LABEL WORD
file ENDS
     END start