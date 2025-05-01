;----------------------------------------------------------------------------
; * GetParams:PROC * REV. D *                                      BINC v2.3
;----------------------------------------------------------------------------
; BINC.EXE  [drive:][path]<InFile> [dirve:][path][OutFile] [/N[:][name]]
;

       IDEAL
       MODEL SMALL

CODESEG
PUBLIC GetParams

       PROC GetParams
       LOCALS
       push es
       mov ax,DGROUP
       mov es,ax
       mov si,80h
       cmp [BYTE si],0
       je @@exi0  ;exit 0 = info
       mov [es:ifSpec],0 ;jako znacznik
       mov [es:ofSpec],0 ; /
       inc si
gChar:
       lodsb
       cmp al,9
       je gChar
       cmp al,20h
       je gChar
       cmp al,0dh
       je @@exip  ;=ok  !jedyne mozliwe wyjscie bez bledu!
       cmp al,20h
       jb @@exi0  ;=info

       cmp al,'/'
       je switch
       lea di,[es:ifSpec]
       lea bx,[es:inFile]
       or [BYTE es:di],0 ;jest juz inFile
       jnz @@f2 ;jak jest to sprawdz outSpec
       dec si
       call @GFS
       jc @@exi0
       jmp gChar
@@f2:
       lea di,[es:ofSpec]
       lea bx,[es:outFile]
       or [BYTE es:di],0 ;juz jest outFile
       jnz @@exi0
       dec si ;wyrownaj
       call @GFS
       jc @@exi0
       jmp gChar

switch:
       lodsb
       or al,20h
       cmp al,'n'
       jne @@exi0
       lea di,[es:aLabel]
       cmp [BYTE es:di],0
       jne @@exi0
       mov [BYTE es:di],1 ;samo /n
       mov cx,15 +1 ;prawidlowy tylko wyskok z petli.
       cmp [BYTE si],':'
       jne gLab
       inc si
gLab:
       cmp [BYTE si],20h
       jbe gChar
       movsb
       loop gLab
       jmp @@exi0 ;blad

@@exi0:
       pop es
       stc
       ret

@@exip:
       cmp [es:inFile],0
       je @@exi0 ;inFile
       call @ALAB
       call @OUTF
       pop es
       clc
       ret
       ENDP
;----------------------------------------------------------------------------
       PROC @GFS ;ds:si src, es:di dest, es:bx dest.filename, cy error
       LOCALS
       push dx bp
       mov dx,di ;tymczas
       mov bp,bx ; /
       mov cx,63 +1
 @@l1:
       cmp [BYTE si],20h
       jbe rWrite
       movsb
       loop @@l1
       jmp @@er
rWrite:
       mov [BYTE es:di],0  ;*
       mov cx,12 +1
 @@l2:
       dec di ;ostatni znak w f.spec
       cmp [BYTE es:di],'\'
       je swByte
       cmp di,dx
       jb swByte
       mov al,[es:di]
       mov [es:bx],al
       inc bx
       loop @@l2
       jmp @@er
swByte:
       dec bx ;wsk na ostatnia lit.
       mov di,bp
 @@l3:
       cmp di,bx
       jae @@rt
       mov al,[es:bx]
       mov ah,[es:di]
       mov [es:di],al
       mov [es:bx],ah
       inc di
       dec bx
       jmp @@l3
@@er:
       pop bp dx
       stc
       ret
@@rt:
       pop bp dx
       clc
       ret
       ENDP
;----------------------------------------------------------------------------
       PROC @ALAB   ;0 nie bylo /n, 1 bylo /n, >1 bylo /n:nazwa
       LOCALS
       cmp [es:aLabel],1
       jne @@ex
       lea si,[es:inFile]
       lea di,[es:aLabel]
 @@l1:
       cmp [BYTE es:si],'.'
       je @@ex
       cmp [BYTE es:si],0
       je @@ex
       mov al,[es:si]
       mov [es:di],al
       inc si
       inc di
       jmp @@l1
 @@ex:
       ret
       ENDP
;----------------------------------------------------------------------------

       PROC @OUTF
       LOCALS
       lea si,[es:inFile]
       lea di,[es:ofSpec]
       lea bx,[es:outFile]
       cmp [BYTE es:di],0
       jne @@exip
       mov cx,8 +1
 @@rw:
       cmp [BYTE es:si],'.'
       je @@aext
       cmp [BYTE es:si],0
       je @@aext
       mov al,[es:si]
       mov [es:di],al
       mov [es:bx],al
       inc si
       inc di
       inc bx
       loop @@rw
       stc
       ret
@@aext:
       mov ax,'i.'
       mov [es:di],ax
       mov [es:bx],ax
       add di,2
       add bx,2
       mov ax,'cn'
       mov [es:di],ax
       mov [es:bx],ax
       add di,2
       add bx,2
       mov [BYTE es:di],0
       mov [BYTE es:bx],0
@@exip:
       clc
       ret
       ENDP

DATASEG
EXTRN aLabel:BYTE,inFile:BYTE,outFile:BYTE

UDATASEG
EXTRN ifSpec:BYTE,ofSpec:BYTE

       END
