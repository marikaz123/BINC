;-----------------------------------------------------------------
; Part of BINC v1.5 * bin2db: rev. 1.2 * MOD0523 * 'marikaz'
;-----------------------------------------------------------------
; Procedura wykonuje konwersj© kazdego bajtu pliku zrodlowego
; do jego reprezentacji jako liczba szestnastkowa w ASCII i
; zapisuje do bufora w pamieci.
; Po zakonczeniu dzialania procedury, w buforze jest juz obraz
; kompletnego pliku docelowego.
;-----------------------------------------------------------------

code segment public 'code'
public bin2db
assume cs:code,ds:data,es:file

bin2db  proc
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
        jmp short efile

from0A:
        cmp al,0fh
        ja  from10
        mov byte ptr es:[di],'0'
        inc di
        add al,37h
        stosb
        jmp finalSeq

eline:                 ; 'jumps'
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
        mov byte ptr es:[di],'h'
        inc di
        cmp dx,16
        je  eline
        mov al,','
        stosb
        loop do
        dec di
        jmp short efile

fromA0:
        mov byte ptr es:[di],'0'
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
bin2db  endp
code    ends

data segment public 'data'
extrn ssf
data ends

file segment public 'file'
extrn sdf
file ends
     END













































