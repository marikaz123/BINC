;----------------------------------------------------------------------------
; * GetParam:PROC * REV. C1 *                                       BINC v2.2
;----------------------------------------------------------------------------

_TEXT SEGMENT WORD PUBLIC 'CODE'
      ASSUME cs:_TEXT,es:_DATA
      PUBLIC getParam

JUMPS

GetParam        PROC
                mov ax,_DATA
                mov es,ax
                cld
                mov si,80h
                cmp BYTE PTR [si],0
                je  errFl
                inc si
rCMDL:
                lodsb
                cmp al,0dh
                je eCMDL
                cmp al,9
                je rCMDL
                cmp al,20h
                je rCMDL
                cmp al,'/'
                je chkSw
                cmp al,7eh
                ja errFl
                dec si  ;korekta po lodsb

                cmp es:[fileIn],0   ;inFile
                jne cOut
                lea di,es:[fileIn]
                jmp getFN
         cOut:
                cmp es:[fileOut],0  ;outFile
                jne errFl
                lea di,es:[fileOut]
getFN:
                mov cx,8 +1  ;prawidlowa nazwa konczy sie wyskokiem z loop
          nme:
                cmp BYTE PTR [si],20h
                jbe rCMDL
                cmp BYTE PTR [si],'.'
                je dot
                cmp BYTE PTR [si],7eh
                ja errFl
                movsb
                loop getFN
                jmp errFl
          dot:
                movsb
                mov cx,3 +1  ;jak przy nazwie
          ext:
                cmp BYTE PTR [si],20h
                jbe rCMDL
                cmp BYTE PTR [si],7eh
                ja errFl
                movsb
                loop ext
                jmp errFl

errFl:
                mov bx,1 ;ma byc w BX
                ret

chkSw:
                mov cx,15 +1        ;tylko przez skok
                lea di,es:[aName]
                lodsb
                or al,100000b
                cmp al,'n'
                jne errFl
                cmp BYTE PTR es:[di],0
                jne errFl
                mov BYTE PTR es:[di],1 ;[di] podano '/n'
                cmp BYTE PTR [si],':'
                jne getAN
                inc si
         getAN:
                cmp BYTE PTR [si],20h
                jbe rCMDL
                cmp BYTE PTR [si],7eh
                ja rCMDL
                movsb
                loop getAN
                jmp errFl

eCMDL:
                lea di,es:[fileIn]
                lea bx,es:[fileOut]
                cmp BYTE PTR es:[bx],0
                jne twoFiles
                ;jeden plik:
movFN:
                mov al,es:[di]
                cmp al,'.'
                je  addExt
                cmp al,0
                je  addExt
                mov es:[bx],al
                inc di
                inc bx
                jmp movFN
addExt:
                mov es:[bx],'i.'    ;rozszerzenie
                mov es:[bx+2],'cn'
                mov es:[SPaddr],bx
                add SPaddr,4        ;korekta
                jmp done

twoFiles:       ;sa podane oba pliki
                cmp BYTE PTR es:[bx],0
                je eofn
                inc bx
                jmp twoFiles
          eofn:
                mov es:[SPaddr],bx
                inc bx         ;po nazwie musi zostac 0 z buf.
                sub bx,5       ;korekta jak 2 pliki!
done:
                mov es:[bx+5],'od'
                mov es:[bx+7],'en'
                mov es:[bx+9],'$.'
                ret
GetParam        ENDP

_TEXT ENDS

_DATA SEGMENT WORD PUBLIC 'DATA'
      EXTRN fileIn,fileOut,aName,SPaddr:WORD
_DATA ENDS
      END
