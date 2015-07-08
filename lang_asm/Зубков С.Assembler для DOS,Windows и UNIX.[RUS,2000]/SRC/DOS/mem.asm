; mem.asm
; сообщает размер памяти, доступной через EMS и XMS
;
; Компиляция:
; TASM:
; tasm /m mem.asm
; tlink /t /x mem.obj
; MASM:
; ml /c mem.asm
; link mem.obj,,NUL,,,
; exe2bin mem.exe mem.com
; WASM:
; wasm mem.asm
; wlink file mem.obj form DOS COM
;


	.model	tiny
	.code
	.186		; для команд сдвига на 4
	org	100h	; COM-программа
start:
	cld		; команды строковой обработки будут выполняться вперед

; проверка наличия EMS

	mov	dx,offset ems_driver ; адрес ASCIZ-строки "EMMXXXX0"
	mov	ax,3D00h
	int	21h		; открыть файл или устройство
	jc	no_emmx	; если не удалось открыть - EMS нет
	mov	bx,ax		; идентификатор в BX
	mov	ax,4400h
	int	21h		; IOCTL: проверить состояние файла/устройства
	jc	no_ems	; если не произошла ошибка,
	test	dx,80h	; проверить старший бит DX,
	jz	no_ems	; если он - 0, EMMXXXX0 - файл в текущей 
			; директории

; определение версии EMS

	mov	ah,46h
	int	67h		; получить версию EMS
	test	ah,ah
	jnz	no_ems	; если EMS выдал ошибку - не стоит продолжать с 
			; ним работать
	mov	ah,al
	and	al,0Fh	; AL = старшая цифра
	shr	ah,4		; AH = младшая цифра
	call	output_version	; выдать строку о номере версии EMS

; определение доступной EMS-памяти
	mov	ah,42h
	int	67h		; получить размер памяти в 16-килобайтных страницах
	shl	dx,4		; DX = размер памяти в килобайтах
	shl	bx,4		; BX = размер свободной памяти в килобайтах
	mov	ax,bx
	mov	si,offset ems_freemem	; адрес строки для output_info
	call	output_info	; выдать строки о размерах памяти

no_ems:
	mov	ah,3Eh
	int	21h		; закроем файл/устройство EMMXXXX0
no_emmx:

; проверка наличия XMS

	mov	ax,4300h
	int	2Fh		; проверка XMS,
	cmp	al,80h	; если AL не равен 80h,
	jne	no_xms	; XMS отсутствует,
	mov	ax,4310h	; иначе:
	int	2Fh		; получить точку входа XMS
	mov	word ptr entry_pt,bx	; и сохранить ее в entry_pt
	mov	word ptr entry_pt+2,es	; (старшее слово - по старшему
					; адресу!)
	push	ds
	pop	es			; восстановить ES

; определение версии XMS
	mov	ah,00
	call	dword ptr entry_pt ; Функция XMS 00h - номер версии
	mov	byte ptr mem_version,'X' ; изменить первую букву строки
				; "EMS detected" на 'X'
	call	output_version	; выдать строку о номере версии XMS

; определение доступной XMS-памяти
	mov	ah,08h
	xor	bx,bx
	call	dword ptr entry_pt	; Функция XMS 08h

	mov	byte ptr totalmem,'X' ; изменить первую букву строки
					; "EMS total" на 'X'
	mov	si,offset xms_freemem ; строка для output_info

; вывод сообщений на экран:
; DX - объем всей памяти
; AX - объем свободной памяти
; SI - адрес строки с сообщением о свободной памяти (разный для EMS и XMS)

output_info:
	push	ax
	mov	ax,dx		 ; объем всей памяти в AX
	mov	bp,offset totalmem ; адрес строки - в BP
	call	output_info1 ; вывод
	pop	ax		; объем свободной памяти - в AX
	mov	bp,si		; адрес строки в BP

output_info1:			; вывод
	mov	di,offset hex2dec_word

; hex2dec
; преобразует целое двоичное число в AX
; в строку десятичных ASCII-цифр в ES:DI, заканчивающуюся символом '$'

	mov	bx,10	; делитель в BX
	xor	cx,cx	; счетчик цифр в 0
divlp:	xor	dx,dx
	div	bx	; разделить преобразуемое число на 10
	add	dl,'0' ; добавить к остатку ASCII-код нуля
	push	dx	; записать полученную цифру в стек
	inc	cx	; увеличить счетчик цифр
	test	ax,ax	; и, если еще есть, что делить,
	jnz	divlp	; продолжить деление на 10
store:
	pop	ax	; считать цифру из стека
	stosb		; дописать ее в конец строки в ES:DI
	loop	store	; продолжить для всех CX-цифр
	mov	byte ptr es:[di],'$' ; дописать "$" в конец строки

	mov	dx,bp	; DX - адрес первой части строки
	mov	ah,9
	int	21h	; Функция DOS 09h - вывод строки
	mov	dx,offset hex2dec_word ; DX - адрес строки с десятичным 
				; числом
	int	21h	; вывод строки
	mov	dx,offset eol	; DX - адрес последней части строки
	int	21h	; вывод строки

no_xms:	ret		; конец программы и процедур output_info
			; и output_info1


; вывод версии EMS/XMS
; AX - номер в неупакованном BCD-формате

output_version:
	or	ax,3030h	; преобразование неупакованного BCD в ASCII
	mov	byte ptr major,ah ; старшая цифра в major
	mov	byte ptr minor,al	; младшая цифра в minor
	mov	dx,offset mem_version ; адрес начала строки - в DX
	mov	ah,9
	int	21h			; вывод строки
	ret

ems_driver	db	'EMMXXXX0',0	; имя драйвера для проверки EMS
mem_version	db	'EMS version '	; сообщение о номере версии
major		db	'0.'		; первые байты этой
minor		db	'0 detected ',0Dh,0Ah,'$'; и этой строк будут
					; заменены реальными номерами версий
totalmem	db	'EMS total memory: $'
ems_freemem	db	'EMS free memory: $'
eol		db	'K',0Dh,0Ah,'$'	; конец строки
xms_freemem	db	'XMS largest free block: $'

entry_pt:				; сюда записывается точка входа XMS
hex2dec_word equ entry_pt+4	; буфер для десятичной строки
	end	start
