;----------------------------------------------------------------------------
; * Bin2db:PROC * REV. D *                                         BINC v2.3
;----------------------------------------------------------------------------
;  in: dgroup:si=ptr to src.buf.
;      dgroup:di=ptr to dst.buf.
;      cx=num. of bytes in src.buf.
; ret: cx=num. of bytes in dst.buf.
;-----------------------------------

        IDEAL
        MODEL SMALL

CODESEG
PUBLIC Bin2db

        PROC Bin2db
        LOCALS

        push ax bx di
        cmp [aLabel],0
        je newLine
        push si
        lea si,[aLabel]
  @@cp:
        cmp [BYTE si],0
        je @@ex
        movsb
        jmp @@cp
  @@ex:
        mov al,20h
        stosb
        mov [aLabel],0 ;tylko za 1 razem
        pop si

newLine:
        mov ax,'BD'
        stosw
        mov al,20h
        stosb
        mov dx,16 ;licznik pomocniczy

nxByte:
        lodsb
        call @B2DB
        mov [BYTE di],','
        inc di
        dec cx
        or cx,cx
        jz @@eos
        dec dx
        or dx,dx
        jnz nxByte
@@eos:
        dec di
        mov ax,0A0Dh
        stosw
        cmp cx,0
        jne newLine

@@exip:
        mov cx,di
        pop ax   ;poczatkowa wartosc di
        sub cx,ax  ;cx=ilossc b.w buf. celu
        pop bx ax
        ret
        ENDP

        PROC @B2DB
        LOCALS
        cmp al,0fh   ;dla 1 cyfry hex
        ja twodg
        cmp al,9
        ja @@a91
        add al,30h  ;do ascii
        stosb
        ret
   @@a91:
        mov ah,'0'
        add al,37h ;do ascii (duze litery)
        xchg ah,al
        stosw
        mov al,'h'
        stosb
        ret
twodg:
        cmp al,9fh   ;dla 2 cyfr,pierwsza < A, nie potrzebuje 0
        jbe @@sl0
        mov [BYTE di],'0'
        inc di
@@sl0:
        push cx   ;\
        mov cx,2  ;  moze w petli?
        mov ah,al
        and ax,0f00fh
        shr ah,4
        xchg al,ah
@@sd:
        cmp al,9
        ja @@a92
        add al,30h
        stosb
        xchg al,ah ;1 cyfra w al
        loop @@sd
        jmp @@exip
@@a92:
        add al,37h
        stosb
        xchg al,ah
        loop @@sd
@@exip:
        mov [BYTE di],'h'
        inc di
        pop cx
        ret
        ENDP

DATASEG
EXTRN aLabel:BYTE

        END
