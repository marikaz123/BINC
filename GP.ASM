;----------------------------------------------------------------------------
; * GetParam:PROC * REV. C *                                       BINC v2.2
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
                je  setIF
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
                ja setIF

                dec si          ;korekta
                mov cx,12       ;max dl. nazwy
                ;wybierz
                cmp es:[fileIn],0
                je getFNI
                cmp es:[fileOut],0
                je getFNO
setIF:
                mov bx,1        ;flaga, ma byc w BX
                ret
chkSw:
                mov cx,15
                lea di,es:[aName]
                lodsb
                or al,100000b
                cmp al,'n'
                jne setIF
                cmp BYTE PTR es:[di],0 ;[di]
                jne setIF
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
                cmp BYTE PTR [si],20h
                jbe rCMDL
                jmp setIF
                ;zaladuj index w zaleznosci od pliku
getFNI:
                lea di,es:[fileIn]
                jmp getFN
getFNO:
                lea di,es:[fileOut]
getFN:          ;wszystko <= 20h i >= 7eh do rCMDL
                cmp BYTE PTR [si],20h
                jbe rCMDL
                cmp BYTE PTR [si],7eh    ;??
                ja rCMDL
                movsb
                loop getFN
                cmp BYTE PTR [si],20h
                jbe rCMDL
                jmp setIF
eCMDL:
                lea di,es:[fileIn]
                lea bx,es:[fileOut]
                cmp BYTE PTR es:[bx],0
                jne bothFiles
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

bothFiles:
                cmp BYTE PTR es:[bx],0
                je eofn
                inc bx
                jmp bothFiles
          eofn:
                mov es:[SPaddr],bx
                inc bx         ;korekta bo TU po nazwie musi zostac 0 z buf.
                sub bx,5       ;
done:                               ;[bx+4] = 0 z buf.
                mov es:[bx+5],'od'  ;
                mov es:[bx+7],'en'
                mov es:[bx+9],'$.'
                ret
GetParam        ENDP

_TEXT ENDS

_DATA SEGMENT WORD PUBLIC 'DATA'
      EXTRN fileIn,fileOut,aName,SPaddr:WORD
_DATA ENDS
      END
