;-------------------------------------------------------------------
; Part of BINC v1.5 * getParam: rev. 1.2 * MOD0523 * 'marikaz'
;-------------------------------------------------------------------
; Procedura pobiera nazwe pliku zrodlowego z linii polecen,
; przepisuje ja jako nazwe pliku docelowego zastepujac
; rozszerzenie zrodlowe rozszerzeniem 'inc', ewentualnie
; dodaje to rozszerzenie gdy plik zrodlowy go nie posiadal.
;-------------------------------------------------------------------

code segment public 'code'
public getParam
assume cs:code,es:data

getParam proc
         mov ax,data
         mov es,ax
         cld
         mov si,80h
         cmp byte ptr [si],0
         je  setIF
         inc si
skipBK:
         lodsb
         cmp al,20h
         je skipBK
         cmp al,9
         je skipBK
         cmp al,0dh
         je setIF

         dec si        ;korekta na poczatek nazwy
         mov cx,si
         add cx,12     ;max dl. nazwy pliku
         lea di,fileIn

getFN:
         cmp si,cx
         je setIF
         movsb
         cmp byte ptr [si],20h
         je setIF                ;ENTER _musi_ sie znalezc
         cmp byte ptr [si],0dh   ;bezposrednio po nazwie
         jne getFN

         lea si,fileIn
         lea bx,fileOut

movFN:
         mov al,es:[si]
         cmp al,'.'
         je  addExt
         cmp al,0
         je  addExt
         mov es:[bx],al
         inc si
         inc bx
         jmp movFN

addExt:
         mov es:[SPaddr],bx
         mov es:[bx],'i.'    ;rozszerzenie
         mov es:[bx+2],'cn'
         mov es:[bx+5],'od'  ;i napis 'done.'
         mov es:[bx+7],'en'
         mov es:[bx+9],'$.'
         ret

setIF:
         mov bx,1            ;blad parametrow cmdl
         ret                 ;(ma byc BX)
getParam endp
code ends

data segment public 'data'
extrn fileIn,fileOut,SPaddr:word
data ends
     END