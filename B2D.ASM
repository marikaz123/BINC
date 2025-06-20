;----------------------------------------------------------------------------
; * Bin2db:PROC * REV. E1 *                                        BINC v2.4
;----------------------------------------------------------------------------

        IDEAL
        MODEL SMALL

CODESEG
EXTRN vProc:WORD
PUBLIC Bin2db
PUBLIC @B2HASC,@B2DASC,@B2BASC

        PROC Bin2db
        LOCALS
        ;-----------------------------------
        ;  we: dgroup:si=wsk do buf. zr.
        ;      dgroup:di=wsk do buf. cel
        ;      cx= bajtow w buf. zr.
        ;  wy: cx= bajtow w buf. cel
        ;-----------------------------------
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
        mov dx,[iNum] ;ilosc poz. w linii
nxByte:
        lodsb
        call [vProc]
        mov [BYTE di],','
        inc di
        dec cx
        jz @@eos
        dec dx
        jnz nxByte
@@eos:
        dec di ;nadpisz ostatni przecinek w linii
        mov ax,0A0Dh
        stosw
        or cx,cx
        jnz newLine

@@exip:
        mov cx,di  ;ilosc zapisanych bajtow
        pop ax     ;poczatkowa wartosc di
        sub cx,ax  ;cx=ilossc b.w buf.
        pop bx ax
        ret
        ENDP
;----------------------------------------------------------------------------
        PROC @B2HASC
        LOCALS
        cmp al,0fh  ;dla 1 cyfry hex
        ja @@2dg
        cmp al,9
        ja @@a91
        add al,30h
        stosb
        ret
 @@a91:
        mov ah,'0'
        add al,37h ;duze litery
        xchg ah,al
        stosw
        mov al,'h'
        stosb
        ret
@@2dg:
        cmp al,9fh   ;dla 2 cyfr, pierwsza < 0Ah, nie potrzebuje 0
        jbe @@sl0
        mov [BYTE di],'0'
        inc di
 @@sl0:
        push cx
        mov cx,2  ;2 obiegi
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
;-------------------
        PROC @B2DASC
        LOCALS
        push bx dx
        xor dx,dx
        xor ah,ah
        cmp al,9
        ja @@a9
        add al,30h
        stosb
        jmp @@rt
  @@a9:
        cmp al,99
        ja @@a99
        mov bx,10
        div bl
        add ax,3030h
        stosw
        jmp @@exip
 @@a99:
        mov bx,100
        div bx
        add al,30h
        stosb
        xchg ax,dx
        mov bx,10
        div bl
        add ax,3030h
        stosw
@@exip:
        IFDEF DDEC      ;liczby dziedietne z 'd'
         mov al,'d'
         stosb
        ENDIF
  @@rt:
        pop dx bx
        ret
        ENDP
;-------------------
        PROC @B2BASC
        LOCALS
        IFNDEF ALLZ
         cmp al,0
         jne @@1
         add al,30h
         stosb
         ret
    @@1:
         cmp al,1
         jne @@a1
         add al,30h
         stosb
         ret
   @@a1:
        ENDIF
        push cx
        mov ah,al
        mov cx,8

        IFNDEF ALLZ
   @@h0:
         shl ah,1
         jc @@b1
         loop @@h0 ;pomin nieznaczace zera
         mov al,'0'
         stosb
         jmp @@ex
        ENDIF
  @@nx:
        shl ah,1
        jnc @@b0
  @@b1:
        mov al,'1'
        stosb
        loop @@nx
        jmp @@ex
  @@b0:
        mov al,'0'
        stosb
        loop @@nx
  @@ex:
        mov al,'b'
        stosb
        pop cx
        ret
        ENDP

DATASEG
EXTRN aLabel:BYTE,iNum:WORD

        END
