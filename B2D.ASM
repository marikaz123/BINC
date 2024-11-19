;----------------------------------------------------------------------------
; * Bin2db:PROC * REV. C *                                         BINC v2.2
;----------------------------------------------------------------------------

_TEXT SEGMENT WORD PUBLIC 'CODE'
      PUBLIC Bin2db
      ASSUME cs:_TEXT,ds:_DATA,es:_BSS


Bin2db    PROC
          mov ax,_BSS
          mov es,ax

          mov di,OFFSET sdf
          mov si,OFFSET aName

          cmp BYTE PTR [si],0
          je skpName
          cmp BYTE PTR [si],1  ;nazwa = nazwa pliku
          je mFName
mvName:
          movsb
          cmp BYTE PTR [si],20h
          jne mvName
          movsb
          jmp skpName
mFName:
           mov si,OFFSET fileIn
      mFN:
           movsb
           cmp BYTE PTR [si],'.'
           je eFN
           cmp BYTE PTR [si],0
           jne mFN
      eFN:
           mov BYTE PTR es:[di],20h
           inc di
skpName:
           mov si,OFFSET ssf

nLine:
           xor dx,dx       ;licznik pomocniczy dla linii
           mov ax,'BD'
           stosw
           mov al,' '
           stosb
do:
           inc dx
           lodsb
           cmp al,0fh
           ja hNum
           call @1HexDig
           jmp nxt
     hNum:
           call @2HexDig
      nxt:
           cmp cx,1
           je eFile
           cmp dx,16
           je  eLine
           mov al,','
           stosb
           loop do
    eLine:
           cmp di,0ffa0h
           ja  eFile
           mov ax,0a0dh
           stosw
           loop nLine
eFile:
           mov ax,0a0dh
           stosw
           mov cx,di    ;CX= ilosc zapisanych do bufora bajtow
           ret
Bin2db     ENDP

@1HexDig  PROC
          LOCALS
          cmp al,9
          ja @@9
          add al,30h
          stosb
          ret
     @@9:
          mov BYTE PTR es:[di],'0'
          inc di
          add al,37h
          stosb
          mov BYTE PTR es:[di],'h'
          inc di
          ret
@1HexDig  ENDP

@2HexDig  PROC
          LOCALS
          mov ah,al
          and ax,0f00fh
          xchg ah,al
          shr al,4
          cmp al,9
          ja @@91
          add al,30h
          stosb
          jmp @@21
    @@91:
          mov BYTE PTR es:[di],'0'
          inc di
          add al,37h
          stosb
    @@21:
          xchg ah,al
          cmp al,9
          ja @@92
          add al,30h
          stosb
          jmp @@22
    @@92:
          add al,37h
          stosb
    @@22:
          mov BYTE PTR es:[di],'h'
          inc di
          ret
@2HexDig  ENDP

_TEXT ENDS

_DATA SEGMENT WORD PUBLIC 'DATA'
      EXTRN ssf,aName,fileIn
_DATA ENDS

_BSS  SEGMENT WORD PUBLIC 'BSS'
      EXTRN sdf
_BSS  ENDS
      END
