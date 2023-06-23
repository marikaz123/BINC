;-----------------------------------------------------------------
; Part of BINC v2.0 * bin2db: rev. 1.2 * MOD0523 * 'marikaz'
;-----------------------------------------------------------------
; Procedura dokonuje konwersji kazdego bajtu pliku zrodlowego
; do jego reprezentacji jako liczba szestnastkowa w ASCII i
; zapisuje do bufora w pamieci.
; Po zakonczeniu dzialania procedury, w buforze jest juz obraz
; kompletnego pliku docelowego.
;-----------------------------------------------------------------

code SEGMENT PUBLIC 'code'
     PUBLIC bin2db
     ASSUME cs:code,ds:data,es:file

bin2db    PROC
          mov ax,file
          mov es,ax
          lea si,ssf
          lea di,sdf
nline:
          xor dx,dx       ;licznik pomocniczy dla linii
          mov ax,'BD'
          stosw
          mov al,' '
          stosb
do:
          inc dx
          lodsb
          cmp al,9
          ja  from0A
          add al,30h
          stosb
          cmp dx,16
          je  eline
          mov al,','
          stosb
          loop do
          dec di
          jmp SHORT efile
from0A:
          cmp al,0fh
          ja  from10
          mov BYTE PTR es:[di],'0'
          inc di
          add al,37h
          stosb
          jmp finalSeq
eline:                   ; BEZ jumps
          cmp cx,1
          je  efile
          cmp di,0ffa0h
          ja  efile
          mov ax,0a0dh
          stosw
          loop nline
from10:
          cmp al,9fh
          ja  fromA0
          mov ah,al        ;kopia do ah jako tmp
          and al,0f0h
          shr al,4
          add al,30h
          stosb
hex_dec:
          mov al,ah
          and al,0fh
          cmp al,9
          ja  hexDigit
          add al,30h
          stosb
          jmp finalSeq
hexDigit:
          add al,37h
          stosb
finalSeq:
          mov BYTE PTR es:[di],'h'
          inc di
          cmp dx,16
          je  eline
          mov al,','
          stosb
          loop do
          dec di
          jmp SHORT efile
fromA0:
          mov BYTE PTR es:[di],'0'
          inc di
          mov ah,al
          and al,0f0h
          shr al,4
          add al,37h
          stosb
          jmp hex_dec
efile:
          mov cx,di
          ret
bin2db    ENDP

code ENDS

data SEGMENT PUBLIC 'data'
     EXTRN ssf
data ENDS

file SEGMENT PUBLIC 'file'
     EXTRN sdf
file ENDS
     END













































