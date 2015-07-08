; rtctime.asm
; Вывод на экран текущей даты и времени из RTC
;
; Компиляция:
; TASM:
;  tasm /m rtctime.asm
;  tlink /t /x rtctime.obj
; MASM:
;  ml /c rtctime.asm
;  link rtctime.obj,,NUL,,,
;  exe2bin rtctime.exe rtctime.com
; WASM:
;  wasm rtctime.asm
;  wlink file rtctime.obj form DOS COM
;


	.model	tiny
	.code
	.186		; для shr al,4
	org	100h	; COM-программа
start:
	mov	al,0Bh	; CMOS 0Bh - управляющий регистр B
	out	70h,al	; порт 70h - индекс CMOS
	in	al,71h	; порт 71h - данные CMOS
	and	al,11111011b	; обнулить бит 2 (форма чисел - BCD)
	out	71h,al		; и записать обратно

	mov	al,32h		; CMOS 32h - две старшие цифры года
	call	print_cmos		; вывод на экран
	mov	al,9			; CMOS 09h - две младшие цифры года
	call	print_cmos
	mov	al,'-'		; минус
	int	29h			; вывод на экран
	mov	al,8			; CMOS 08h - текущий месяц
	call	print_cmos
	mov	al,'-'		; еще один минус
	int	29h
	mov	al,7			; CMOS 07h - день
	call	print_cmos
	mov	al,' '		; пробел
	int	29h
	mov	al,4			; CMOS 04h - час
	call	print_cmos
	mov	al,'h'		; буква "h"
	int	29h
	mov	al,' '		; пробел
	int	29h
	mov	al,2		; CMOS 02h - минута
	call	print_cmos
	mov	al,':'		; двоеточие
	int	29h
	mov	al,0h		; CMOS 00h - секунда
	call	print_cmos
	ret

; процедура print_cmos
; выводит на экран содержимое ячейки CMOS с номером в AL
; считает, что число, читаемое из CMOS, находится в формате BCD
print_cmos proc near
	out	70h,al	; послать AL в индексный порт CMOS
	in	al,71h	; прочитать данные
	push	ax
	shr	al,4		; выделить старшие четыре бита
	add	al,'0'	; добавить ASCII-код цифры 0
	int	29h		; вывести на экран
	pop	ax
	and	al,0Fh	; выделить младшие четыре бита
	add	al,30h	; добавить ASCII-код цифры 0
	int	29h		; вывести на экран
	ret
print_cmos endp
	end	start
