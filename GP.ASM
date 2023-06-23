;-------------------------------------------------------------------
; Part of BINC v2.0 * getParam: rev. 1.2 * MOD0523 * 'marikaz'
;-------------------------------------------------------------------
; Procedura pobliera nazwe pliku zrodlowego oraz nazwe pliku
; docelowego z linii polecen i kopiuje do buforow.
;  LUB, gdy podano tylko nazwe pliku zrodlowego:
; Pobiera nazwe pliku zrodlowego z linii polecen, przepisuje
; jako nazwe pliku docelowego zastepujac rozszerzenie zrodlowe
; rozszerzeniem '.inc', ewentualnie dodaje to rozszerzenie gdy
; plik zrodlowy go nie posiadal.
;-------------------------------------------------------------------

code SEGMENT PUBLIC 'code'
     PUBLIC getParam
     ASSUME cs:code,es:data

getParam        PROC
                mov ax,data
                mov es,ax
                cld
                mov si,80h
                cmp BYTE PTR [si],0
                je  setIF
                inc si

readCMDL:
                lodsb
                cmp al,0dh
                je endCMDL
                cmp al,9
                je readCMDL
                cmp al,20h
                je readCMDL
                cmp al,'/'
                je setIF
                cmp al,126
                je setIF

                dec si          ;korekta
                mov cx,12       ;max dl. nazwy

                ;wybierz
                cmp es:[fileIn],0
                je getFileNameIn
                cmp es:[fileOut],0
                je getFileNameOut
setIF:          ;ustaw flage dla bledow w linii parametrow
                mov bx,1        ;ma byc w BX
                ret

                ;zaladuj index w zaleznosci od pliku
getFileNameIn:
                lea di,es:[fileIn]
                jmp getFileName
getFileNameOut:
                lea di,es:[fileOut]

getFileName:
                cmp BYTE PTR [si],0dh       ;tu tylko plik
                je readCMDL                 ;reszta w readCMDL
                cmp BYTE PTR [si],9
                je readCMDL
                cmp BYTE PTR [si],20h
                je readCMDL
                cmp BYTE PTR [si],'/'
                je readCMDL
                cmp BYTE PTR [si],126
                je readCMDL
                movsb
                loop getFileName

                cmp BYTE PTR [si],9      ;po nazwie musi byc odstep
                je readCMDL              ;i trzeba to sprawdzic TU
                cmp BYTE PTR [si],20h
                je readCMDL
                cmp BYTE PTR [si],0dh
                je readCMDL              ;reszte obsluzy readCMDL
                jmp setIF

endCMDL:
                lea di,es:[fileIn]
                lea bx,es:[fileOut]
                cmp BYTE PTR es:[di],0   ;pusta CMDL
                je setIF
                cmp BYTE PTR es:[bx],0
                jne bothFiles

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
                mov es:[SPaddr],bx
                mov es:[bx],'i.'    ;rozszerzenie
                mov es:[bx+2],'cn'
done:                               ;[bx+4] = 0 z buf.
                mov es:[bx+5],'od'  ;Napis 'done.'
                mov es:[bx+7],'en'
                mov es:[bx+9],'$.'
                ret

bothFiles:      ;sa podane oba pliki
                add bx,12
                sub bx,cx      ;cx=12-(dlugosc_nazwy_pliku)
                inc bx         ;korekta bo TU po nazwie musi zostac 0 z buf.
                sub bx,5       ; ,,
                jmp done       ;zeby sie nie powtarzac

getParam        ENDP
code ENDS

data SEGMENT PUBLIC 'data'
     EXTRN fileIn,fileOut,SPaddr:word
data ENDS
     END