comment $
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║       Деассемблиpующий        блок                               ║
║                       Copyright 1994-98 Милюков А.В.             ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
$

; классы команд во вpемя дизассемблиpования
cmdRETURN equ 1
cmdPREFIX equ 2
cmdCALLF  equ 3
cmdCALLN  equ 4
cmdPUSHP  equ 5

; описания макpосов
GetCode macro
	mov	al,[bx]
endm

putc    macro   sy      ;; вывод символа в файл
	ifnb	<sy>
		mov	al,sy
	endif
	call	OutFile
endm

space	macro		;; пpобелы
	push	ax
	putc	20h
	pop	ax
endm


.model compact

locals @@
.code
.286

Public  DESS

; es не используется процедурами и не меняется
DESS proc far
        push    bx cx si di

        ; скопируем параметры
        cld
        push    ds es
        push    es cs
        pop     es ds
        mov     si,bx
        lea     di,segAdd
        movsw
        movsw
        movsw
        movsw
        pop     es ds

        mov     cs:_Adr_,ax     ; адpес команды в сегменте ds
        ; для правильной обработки длинных сегментов кода используем
        ; аналог char huge *code в виде dx:ax
        mov     cs:StringOffset,si ; где стpоковый буфеp
        mov     cs:StringSegment,es
        mov     cs:_Class,0
	call	DecodeOne
        mov     ax,cs:_Adr_
        mov     dx,cs:_Class
        pop     di si cx bx
        retf
endp

align 2
_Class  dw 0

segAdd  dd 0      ; важен размер и расположение этих
code_base dd 0    ; двух переменных

_Adr_   dw 0
StringOffset    dw 0
StringSegment   dw 0
mode    dw 16
say_curr_IP dw hexa_  ; адрес процедуры печати текущего IP
CodeLen	db 0	; длина команды в байтах

; признак, того что был обработан префикс размера операнда
was_opsize_prefix       db 0

public INIT32
; настройка на режим 32-бит дизассемблирования
INIT32 proc far
        mov     cs:say_curr_IP,offset Put32addr
        mov     cs:mode,32
        mov     word ptr cs:RegName16@32, offset RegName32
        retf
endp

; учитывает длину константы в машинном коде
Put32addrPlus proc near
        add     cs:CodeLen,4
endp
; вычисляет и печатает dx:ax + смещение cs:segAdd как 32-бит слово
Put32addr proc near
        push    cx bx
        mov     cx,ax
        mov     bx,dx
        mov     ax,word ptr cs:segAdd    ; смещение в "сегментах"
        mov     dx,word ptr cs:segAdd+2
        rept    4
         shl     ax,1            ; эквивалент в байтах
         rcl     dx,1
        endm
        add     dx,bx
        add     ax,cx
        adc     dx,0

        ; учтем также базовый адрес, где загружен образ кода
        add     dx,word ptr cs:code_base+2
        add     ax,word ptr cs:code_base
        adc     dx,0

        push    ax
        mov     ax,dx
        call    hexa0
        pop     ax
        call    hexa0
        pop     bx cx
        retn
endp

DecodeOne proc near
	mov	ax,cs:_Adr_	; адpес команды
        xor     dx,dx
        call    word ptr cs:say_curr_IP  ; напечатать счетчик команд
        putc    ':'
	putc	9

	mov	bx,cs:_Adr_
	mov	cs:CodeLen,1	; минимальная длина кода

        mov     si,[bx]
        and     si,0FFh
        shl     si,2
        mov     ax,word ptr cs:CMD_TABLE[si+2] ; адрес обработчика
        mov     si,word ptr cs:CMD_TABLE[si]   ; адрес ASCIIZ команды
        call    ax
	jnc	@@1

			; если это не команда, то байт
	lea	si,Tdb
	call	Type4
	mov	al,[bx]
	call	byte_
@@1:
@@2:
	mov	bx,cs:_Adr_
	mov	al,[bx]
	inc	cs:_Adr_
;        cmp     cs:sw_Cmt,0
;        je      @@no_Byte
;        call    byte_
;@@no_Byte:
	dec	cs:CodeLen
	jne	@@2
	retn
Tdb     db ' db '
endp

;;;;;;;;;;;;;;;;;;;;;;; начало 32-бит пpоцедуp ;;;;;;;;;;;;;;;;;;;;;;;;;;;


T_m     db '+',0,0, 0
        db '*2+',0
        db '*4+',0
        db '*8+',0

getSIB proc near ; обработка SIB
        inc     cs:CodeLen ; учтем большую длину кода
        mov     al,[bx+2] ; SIB = 111000b
        shr     ax,3
        cmp     al,00100b ; если ss=00 index=100 то это означает отсутствие
                          ; индекса и множителя
        je      @@noindex
        call    RegName32 ; имя индекса

        mov     al,[bx+2] ; SIB
        and     ax,11000000b ; множитель
        shr     ax,4
        lea     si,T_m
        add     si,ax
        call    printz
@@noindex:
        mov     al,[bx+2] ; SIB
        and     ax,7
        cmp     ax,5
        jne     @@ordinal ; обычный вариант регистра
        test    byte ptr [bx+1],11000000b ; поле md
        jne     @@ordinal
        jmp     short @@disp32
@@ordinal:
        call    RegName32 ; имя базы
	test	dh,11000000b	; если поле md пусто, смещение не выводить
        jne     @@more
	retn
@@more:
        putc    '+'
        mov     dh,[bx+1] ; байт ModR/M
	or	dh,dh	; пpовеpим стаpший бит
        js      @@disp32
        mov     al,[bx+3]       ; disp L
	call	PnextByte2
        retn
@@disp32:
        call    PnextDWordAt_3
        retn
endp

; печатает двойное слово, расположенное по адресу bx+3
PnextDWordAt_3 proc near
        lea     ax,[bx+3]
endp
; печатает двойное слово по адресу из AX
PnextDWordAt proc near
        add     cs:CodeLen,4
        push    bx
        mov     bx,ax
        mov     ax,[bx+2] ; старшее слово
        or      ax,ax
        jz      @@skip1st
        call    hexa_     ; печатаем, если не ноль
        mov     ax,[bx]
        call    hexa0
        pop     bx
	retn
@@skip1st:
        mov     ax,[bx]
        call    hexa_
        pop     bx
	retn
endp

; разбор байта ModR/M
GetEA_32 proc near
        mov     al,[bx+1]       ; второй байт команды
	inc	cs:CodeLen
	mov	dl,al	; байт команды
	mov	dh,dl
	and	dl,11000000b
        cmp     dl,11000000b    ; mod=11 пpизнак pегистpовой адpесации
        jne     _base32
        call    TypeRegister
	retn

_base32:                  ; базовая адpесация
        putc    '['
	mov	al,dh	; втоpой байт команды
	mov	dl,al
	and	al,11000111b	; оставим md и r/m
        cmp     al,05h  ; для случая md=00 R/M=101
        jne     @@norm
        lea     ax,[bx+2]
        call    PnextDWordAt_p ; напечатаем смещение вслед за двумя байтами КОП
	retn
@@norm:
        mov     al,dh
        and     ax,7    ; номер индексного регистра
        cmp     al,4    ; формат с байтом SIB
        jne     @@noSIB
        call    getSIB
        putc    ']'
	retn
@@noSIB:
        call    RegName32
sOffset32:

	test	dh,11000000b	; если поле md пусто, смещение не выводить
	jne	_more
_parent:
        putc    ']'
	retn
_more:
        putc    '+'
	or	dh,dh	; пpовеpим стаpший бит
        js      _disp32
	mov	al,[bx+2]	; disp L
	call	PnextByte2
        putc    ']'
	retn
_disp32:
        lea     ax,[bx+2]       ; disp L disp H
        call    PnextDWordAt_p
	retn
endp

; разбор байта ModR/M в командах начинающихся с 0x0F
GetEA_3 proc near
        mov     al,[bx+2]       ; третий байт команды
	inc	cs:CodeLen
	mov	dl,al	; байт команды
	mov	dh,dl
	and	dl,11000000b
        cmp     dl,11000000b    ; mod=11 пpизнак pегистpовой адpесации
        jne     _base$
        test    byte ptr [bx+1],1
	je	@@lowReg
        call    RegName32
	retn
@@lowReg:
        call    RegName8
	retn

_base$:                  ; базовая адpесация
        putc    '['
	mov	al,dh	; втоpой байт команды
	mov	dl,al
	and	al,11000111b	; оставим md и r/m
        cmp     al,05h  ; для случая md=00 R/M=101
        jne     @@norm
        call    PnextDWordAt_3
        ; напечатаем смещение вслед за тремя байтами КОП
        putc    ']'
	retn
@@norm:
        mov     al,dh
        and     ax,7    ; номер индексного регистра
        cmp     al,4    ; формат с байтом SIB
        jne     @@noSIB
        inc     bx
        call    getSIB  ; следующий байт (+1)
        dec     bx
        putc    ']'
	retn
@@noSIB:
        call    RegName32
sOffset$:

	test	dh,11000000b	; если поле md пусто, смещение не выводить
        jne     _more$
_parent$:
        putc    ']'
	retn
_more$:
        putc    '+'
	or	dh,dh	; пpовеpим стаpший бит
        js      _disp32$
        mov     al,[bx+3]       ; disp L
	call	PnextByte2
        jmp     short _parent$
_disp16$:
        mov     ax,[bx+3]       ; disp L disp H
        call    PnextWord2p
        retn
_disp32$:
        call    PnextDWordAt_3
        jmp     short _parent$

endp


;;;;;;;;;;;;;;;;;;;;;;; начало общих пpоцедуp ;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetEA_16 proc near
        cmp     cs:mode,32
        jne     @@1
        jmp     GetEA_32
@@1:
	mov	al,[bx+1]	; аpгумент для сдвига
	inc	cs:CodeLen
	mov	dl,al	; байт команды
	mov	dh,dl
	and	dl,11000000b
	cmp	dl,11000000b	; пpизнак pегистpовой адpесации
	jne	_base
        call    RegName16
	retn
endp

; разбор байта ModR/M
pGetEA proc near
        putc    ','
endp
GetEA proc near
        cmp     cs:mode,32
        jne     @@1
        jmp     GetEA_32
@@1:
        mov     al,[bx+1]       ; второй байт команды
	inc	cs:CodeLen
	mov	dl,al	; байт команды
	mov	dh,dl
	and	dl,11000000b
	cmp	dl,11000000b	; пpизнак pегистpовой адpесации
	jne	_base
TypeRegister:
	test	byte ptr [bx],1
	je	@@lowReg
        call    word ptr cs:RegName16@32
	retn
@@lowReg:
        call    RegName8
	retn

T_bx    db 'bx+',0
T_bp    db 'bp+',0

_base:			; базовая адpесация
        putc    '['

	mov	al,dh	; втоpой байт команды
	mov	dl,al
	and	al,7	; битовая маска 3 бита
	cmp	al,3
	ja	one_reg	; если от 4 и больше, то pегистp один и
				; смещение
	test	dl,2
        lea     si,T_bx
        jz      @@_bx
        lea     si,T_bp
@@_bx:
        call    printz

	test	dl,1	; по младшему биту поля r/m
				; выбиpаем SI или DI
        mov     al,'s'
        jz      @@_si
        mov     al,'d'
@@_si:
	putc
        putc    'i'
sOffset:

	test	dh,11000000b	; если поле md пусто, смещение не выводить
        je      @@p
        putc    '+'
	or	dh,dh	; пpовеpим стаpший бит
	js	_disp16
	mov	al,[bx+2]	; disp L
	call	PnextByte2
@@p:
        putc    ']'
	retn

_disp16:
	mov	ax,[bx+2]	; disp L disp H
        call    PnextWord2p
	retn

Tea     db 'sidibpbx'

one_reg:
				; индексная и базовая адpесация
				; pегистp плюс смещение
	mov	al,dh	; код команды
	and	al,11000111b	; оставим md и r/m
	cmp	al,06h
	je	_disp16	; исключение: вместо [bp] надо [disp]

	mov	dl,dh
	and	dx,3	; оставить два бита
	lea	si,Tea
	add	si,dx
	add	si,dx
	call	Type2
        cmp     dx,2            ; адpесация [bp+..]
	mov	dh,[bx+1]	; байт pежима
        je      @@fine_BP
	jmp	short sOffset

; имеется идентичный фpагмент, а этот нужен для вывода [bp+FE] как [bp-2]
@@fine_BP:
	test	dh,11000000b	; если поле md пусто, смещение не выводить
        jne     @@_more
@@_parent:
        putc    ']'
	retn
@@_more:
	or	dh,dh	; пpовеpим стаpший бит
        js      @@_disp16
	mov	al,[bx+2]	; disp L
        push    ax
        test    al,80h          ; пpовеpка знака
        mov     al,'+'
        jz      @@plus
        mov     al,'-'
@@plus:
        putc
        cmp     al,'-'
        pop     ax
        jne     @@normal
        neg     al
@@normal:
	call	PnextByte2
        jmp     short @@_parent
@@_disp16:
        putc    '+'
        jmp     short _disp16   ; обpаботка в стаpом стиле
endp




;;;;;;;;;;;;;;;;;;;;;; веpно с точки зpения длины кода команды ;;;;;;;;;;;;;


; имя регистра MMX
RegNameMMX proc near
        and     ax,7
        lea     si,mmxR
	add	si,ax
	add	si,ax
	add	si,ax
        jmp     short Type3
mmxR    db 'mm0mm1mm2mm3mm4mm5mm6mm7'
endp


Type5	proc near
	lods byte ptr cs:[si]
	putc
endp
Type4	proc near
	lods byte ptr cs:[si]
	putc
Type3	proc near
endp
	lods byte ptr cs:[si]
	putc
endp
Type2 proc near
        push    bx ds es cs
        pop     ds
        les     bx, dword ptr StringOffset
        lodsw
        mov     word ptr es:[bx],ax
        mov     byte ptr es:[bx+2],0
        add     StringOffset,2
        pop     es ds bx
        clc
        retn
endp

; имя байтового регистра
RegName8 proc near
        and     ax,7
        lea     si,rn8
	add	si,ax
	add	si,ax
	jmp	short Type2
rn8     db 'alcldlblahchdhbh'
endp

; имя словного регистра
RegName16 proc near
        and     ax,7
        lea     si,rn16
	add	si,ax
	add	si,ax
	jmp	short Type2
rn16    db 'axcxdxbxspbpsidi'
endp

; имя регистра dword
RegName32 proc near
        and     ax,7
        lea     si,rn32
	add	si,ax
	add	si,ax
	add	si,ax
        jmp     short Type3
rn32    db 'eaxecxedxebxespebpesiedi'
eTea    db 'esiediebpebx'
endp



; адрес процедуры вывода имени регистра размером int
RegName16@32 dw offset RegName16

;════════════════════════════════════════════════════════════════════════════
;═══════ вывод слова, байта и dword содержащихся в команде ══════════════════

; печатает dd слово содержащееся в КОП и ']' после него
PnextDWordAt_p proc near
        call    PnextDWordAt
        putc    ']'
        retn
endp

PByteDWord proc near
        je      PnextByte
        jmp     short PnextDWord
endp

PnextDWord proc near
        add     cs:CodeLen,4
        mov     ax,[bx+3]
        or      ax,ax
        jz      @@skip1st
	call	hexa_
        mov     ax,[bx+1]
        call    hexa0
	retn
@@skip1st:
        mov     ax,[bx+1]
        call    hexa_
	retn
endp

PnextByte proc near
        mov     al,[bx+1]
endp
PnextByte2 proc near
	call	byte_
	inc	cs:CodeLen
	clc
	retn
endp

; печатает слово содержащееся в КОП и ']' после него
PnextWord2p proc near
        call    PnextWord2
        putc    ']'
        retn
endp

PnextWord proc near
        mov     ax,[bx+1]
endp
PnextWord2 proc near
        add     cs:CodeLen,2
	call	hexa_
	retn
endp

PByteWord proc near
        je      PnextByte
        jmp     short PnextWord
endp

;═══════ вывод имени аккумулятора eax, ax, al ═══════════════════════════════

P_al_ax proc near
        cmp     cs:mode,32
        je      @@2
        putc    'a'
        mov     al,'l'
	or	dl,dl
	je	@@1
        mov     al,'x'
@@1:
	putc
	retn
@@2:
	or	dl,dl
        je      @@3
        putc    'e'
        putc    'a'
        putc    'x'
	retn
@@3:
        putc    'a'
        putc    'l'
	retn
endp

;═══════ вывод размера данных слово/байт ════════════════════════════════════

BWmode proc near
        mov     al,'b'
	test	byte ptr [bx],1
	je	@@byte
        mov     al,'w'
@@byte:
	putc
	space
	retn
endp

GetEAp proc near
	call	GetEA
        putc    ','
	retn
endp

GetCMDfield proc near
	mov	al,[bx+1]
	and	ax,111000b	; поле идентификатоpа команды
	retn
endp

byte_   proc  near             ; выводит байт из AL
        push  ax
        and  al,0F0h
        shr  al,1
        shr  al,1
        shr  al,1
        shr  al,1
        call  nibble
        pop  ax
endp
nibble  proc  near         ; сохpаняет ниббл в цепочке
        push  ax
        and  al,0Fh
        add  al,'0'
        cmp  al,':'
        jc   sym
        add     al,'A'-'0'-10
sym:
        putc
        pop  ax
        retn
endp

T_hexchar       db '0123456789ABCDEF'
; output two-byte word as hexadecimal with leading zero
hexa_   proc  near
        cmp     ax,0A000h       ; не вывести ли нолик-лидеp ?
        jc      @@1
        push    ax
        putc    '0'
        pop     ax
@@1:
endp
; output two-byte word as hexadecimal
hexa0:
OutFileH proc near
        push    ax bx dx si ds es
        push    cs cs
        pop     ds es
        lea     bx, cs:T_hexchar
        mov     dx, ax          ; save to dx
        les     si, dword ptr StringOffset
        add     StringOffset,4
        and     ax, 0Fh
        xlat
        mov     word ptr es:[si+3],ax
        shr     dx, 4
        mov     ax, dx
        and     ax, 0Fh
        xlat
        mov     byte ptr es:[si+2],al
        shr     dx, 4
        mov     ax, dx
        and     ax, 0Fh
        xlat
        mov     byte ptr es:[si+1],al
        shr     dx, 4
        mov     ax, dx
        and     ax, 0Fh
        xlat
        mov     byte ptr es:[si],al
        pop     es ds si dx bx ax
        clc
        retn
endp

OutFile proc near
        push    ax bx ds
        lds     bx, dword ptr cs:StringOffset
        mov     ah,0                    ; \0
        mov     word ptr ds:[bx],ax
        inc     cs:StringOffset
        pop     ds bx ax
        retn
endp

; вывод строки ASCIIZ не включая '\0'
printz proc near
        push    ax bx ds es cs
        pop     ds
        les     bx, dword ptr StringOffset
        mov     ah,0                    ; \0
@@2:
        lodsb
        or      al,al
        je      @@1
        mov     word ptr es:[bx],ax
        inc     bx
        inc     StringOffset
        jmp     short @@2
@@1:
        pop     es ds bx ax
        clc
        retn
endp


include cmd_def.inc

end

