COMMENT #--------------------------------------------------------------------
BINC.GetParams:PROC * REV. G *
-----------------------------------------------------------------------------
linia polecen:
    [{/B[B] | /D | /H}] [/i=nn] [/N[:][name]]
    [drv:][path]<InFile> [drv:][path][OutFile]
----------------------------------------------------------------------------#

INCLUDE .\INC\binc_h.inc

        IDEAL
        MODEL SMALL

        CODESEG

EXTRN vProc:WORD
PUBLIC GetParams
JUMPS

PROC    GetParams
        LOCALS
        mov si,80h
        cmp [BYTE si],2 ;?
        jb @@exi1 ;info
        cld
        inc si
gChar:
        lodsb
        cmp al,9
        je gChar
        cmp al,20h
        je gChar
        cmp al,0dh
        je endParam
        cmp al,'/'
        je switch
        cmp al,'-'
        je switch
        cmp al,20h
        jb @@exi1

        test [es:ifSpec],0fh
        jnz @@f2
        lea di,[es:ifSpec]
        dec si ;cofnij si po lodsb
        call Loc_gfs
        jc @@exi2
        jmp gChar
@@f2:
        test [es:ofSpec],0fh
        jnz @@exi1
        lea di,[es:ofSpec]
        dec si
        call Loc_gfs
        jc @@exi2
        jmp gChar

switch:
        lodsb
        or al,20h
        cmp al,'b'
        je caseB
        cmp al,'d'
        je caseD
        cmp al,'h'
        je caseH
        cmp al,'i'
        je caseI
        cmp al,'n'
        je caseN
        jmp @@exi1

caseB:
        test [es:mode],MASK bdh
        jnz @@exi1
        or [es:mode],MASK bdh
        cmp [BYTE si],20h
        jbe @@b
        lodsb
        or al,20h
        cmp al,'b'
        jne @@exi1
        or [es:mode],MASK allz
  @@b:
        lea ax,[NEAR @B2BASC]
        mov [vProc],ax
        cmp [BYTE si],20h
        ja @@exi1
        jmp gChar

caseD:
        test [es:mode],MASK bdh
        jnz @@exi1
        or [es:mode],MASK bdh
        lea ax,[NEAR @B2DASC]
        mov [vProc],ax
        cmp [BYTE si],20h
        ja @@exi1
        jmp gChar

caseH:
        test [es:mode],MASK bdh
        jnz @@exi1
        or [es:mode],MASK bdh
        cmp [BYTE si],20h
        ja @@exi1
        jmp gChar

caseI:
        test [es:mode],MASK itm
        jnz @@exi1
        or [es:mode],MASK itm
        lodsb
        cmp al,'=' ;obowiazkowy
        jne @@exi1

        lodsb
        cmp al,'0'
        jb @@exi1
        cmp al,'9'
        ja @@exi1
        sub al,'0'
        mov ah,al
        cmp [BYTE si],20h
        jbe @@i
        lodsb
        cmp al,'0'
        jb @@exi1
        cmp al,'9'
        ja @@exi1
        sub al,'0'
        push bx
        shl ah,1
        mov bl,ah
        shl ah,2
        add ah,bl
        pop bx
        add al,ah
        cmp [BYTE si],20h
        ja @@exi1
   @@i:
        cbw
        cmp ax,1
        jb @@exi1
        cmp ax,16
        ja @@exi1
        mov [es:iNum],ax
        jmp gChar

caseN:
        lea di,[es:aLabel]
        cmp [BYTE es:di],0
        jne @@exi1
        mov [BYTE es:di],1 ;samo /n
        mov cx,15 +1
        cmp [BYTE si],':'
        jne @@n
        inc si
   @@n:
        cmp [BYTE si],20h
        jbe gChar
        movsb
        loop @@n
        jmp @@exi1 ;blad

endParam:   ;es=ds=dataseg
        push es
        pop ds  ;
        cmp [ifSpec],0
        je @@exi1
        cmp [ofSpec],0
        jne @@1
        lea si,[ifSpec]
        lea di,[ofSpec]
        call Loc_cfs
   @@1:
        mov ah,60h
        lea si,[ifSpec]
        mov di,si
        int 21h
        jc @@exi2
        mov ah,60h
        lea si,[ofSpec]
        mov di,si
        int 21h
        jc @@exi2
        lea di,[ofName] ;si na miejscu?
        call Loc_cfn
        jc @@exi2
        cmp [aLabel],1
        jne @@2

        lea si,[ofName]
        lea di,[aLabel]
        call Loc_lfn
   @@2:
        xor ax,ax
        ret  ;wyjscie bez bledow

@@exi1:
        mov ax,1 ;blad linii polecen
        stc
        ret

@@exi2:
        mov ax,2 ;blad w nazawch sciezek i/lub plikow
        stc
        ret
        ENDP
;----------------------------------------------------------------------------
PROC    Loc_gfs ;cs:si -> string, es:di -> filespec
        LOCALS
        cmp [BYTE si],20h
        jbe @@ex
        cmp [BYTE si],7eh
        ja @@er
        movsb
        jmp Loc_gfs
  @@er:
        stc
        ret
  @@ex:
        clc
        ret
        ENDP

PROC    Loc_cfs
        LOCALS
        cmp [BYTE si],0
        je @@ae
        cmp [BYTE si],'.'
        je @@ae
        movsb
        jmp Loc_cfs
  @@ae:
        mov ax,'I.'
        stosw
        mov ax,'CN'
        stosw
        mov [BYTE di],0
        ret
        ENDP

PROC    Loc_cfn
        LOCALS
        push di
        mov di,si
        xor al,al
        mov cx,80
        repne scasb
        jcxz @@er
        neg cx
        add cx,80
        mov al,'\'
        std
        repne scasb
        add cx,2 ;proteza po scasb
        add si,cx
        pop di
        cld
  @@cp:
        cmp [BYTE si],0
        je @@ex
        movsb
        jmp @@cp
@@er:
        stc
        ret
@@ex:
        clc
        ret
        ENDP

PROC    Loc_lfn ;si -> ofName, di -> aLabel
        LOCALS
        cmp [BYTE si],0
        je @@ex
        cmp [BYTE si],'.'
        je @@ex
        lodsb
        cmp al,'A'
        jb @@s
        cmp al,'Z'
        ja @@s
        or al,20h
   @@s:
        stosb
        jmp Loc_lfn
@@ex:
        ret
        ENDP

        DATASEG

EXTRN mode:FLAGS
EXTRN iNum:WORD
EXTRN ifSpec:BYTE,ofSpec:BYTE,ofName:BYTE,aLabel:BYTE

        END
