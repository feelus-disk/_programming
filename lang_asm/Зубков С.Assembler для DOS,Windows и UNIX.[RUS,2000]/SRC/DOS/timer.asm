; timer.asm
; демонстрация перехвата прерывания системного таймера: вывод текущего времени 
; в левом углу экрана
;
; Компиляция:
; TASM:
;  tasm /m timer.asm
;  tlink /t /x timer.obj
; MASM:
;  ml /c timer.asm
;  link timer.obj,,NUL,,,
;  exe2bin timer.exe timer.com
; WASM:
;  wasm timer.asm
;  wlink file timer.obj form DOS COM
;


	.model	tiny
	.code
	.186			; для pusha/popa и сдвигов
	org	100h
start	proc	near
; сохранить адрес предыдущего обработчика прерывания 1Ch
	mov	ax,351Ch	; AH = 35h, AL = номер прерывания
	int	21h		; функция DOS: определить адрес обработчика 
	mov	word ptr old_int1Ch,bx		; прерывания 
	mov	word ptr old_int1Ch+2,es	; (возвращается в ES:BX)
; установить наш обработчик
	mov	ax,251Ch	; AH = 25h, AL = номер прерывания
	mov	dx,offset int1Ch_handler ; DS:DX - адрес обработчика
	int	21h		; установить обработчик прерывания 1Ch

; здесь размещается собственно программа, например вызов command.com
	mov	ah,1
	int	21h		; ожидание нажатия на любую клавишу
; конец программы

; восстановить предыдущий обработчик прерывания 1Сh
	mov	ax,251Ch		; AH = 25h, AL = номер прерывания
	mov	dx,word ptr old_int1Ch+2
	mov	ds,dx
	mov	dx,word ptr cs:old_int1Ch ; DS:DX - адрес обработчика
	int	21h

	ret

old_int1Ch dd	? ; здесь хранится адрес предыдущего обработчика
start_position	dw 0	; позиция на экране, в которую выводится текущее 
			; время
start	endp

; обработчик для прерывания 1Ch
; выводит текущее время в позицию start_position на экране (только в текстовом 
; режиме)

int1Ch_handler	proc	far
	pusha		; обработчик аппаратного прерывания
	push	es	; должен сохранять ВСЕ регистры
	push	ds

	push	cs	; на входе в обработчик известно только значение
	pop	ds	; регистра CS
	mov	ah,02h	; Функция 02h прерывания 1Ah:
	int	1Ah		; чтение времени из RTC
	jc	exit_handler ; если часы заняты - в другой раз

; AL = час в BCD-формате
	call	bcd2asc	; преобразовать в ASCII
	mov	byte ptr output_line[2],ah ; поместить их в
	mov	byte ptr output_line[4],al ; строку output_line

	mov	al,cl		; CL = минута в BCD-формате
	call	bcd2asc
	mov	byte ptr output_line[10],ah
	mov	byte ptr output_line[12],al

	mov	al,dh		; DH = секунда в BCD-формате
	call	bcd2asc
	mov	byte ptr output_line[16],ah
	mov	byte ptr output_line[18],al

	mov	cx,output_line_l	; число байтов в строке - в CX
	push	0B800h
	pop	es			; адрес в видеопамяти
	mov	di,word ptr start_position ; в ES:DI
	mov	si,offset output_line ; адрес строки в DS:SI
	cld
	rep movsb			; скопировать строку
exit_handler:
	pop	ds		; восстановить все регистры
	pop	es
	popa
	jmp	cs:old_int1Ch ; передать управление предыдущему 
				; обработчику

; процедура bcd2asc
; преобразует старшую цифру упакованного BCD-числа в AL в ASCII-символ в AH,
; а младшую цифру - в ASCII-символ в AL
bcd2asc		proc	near
	mov	ah,al
	and	al,0Fh	; оставить младшие 4 бита в AL
	shr	ah,4		; сдвинуть старшие 4 бита в AH
	or	ax,3030h	; преобразовать в ASCII-символы
	ret
bcd2asc		endp

; строка " 00h 00:00" с атрибутом 1Fh (белый на синем) после каждого символа
output_line	db	' ',1Fh,'0',1Fh,'0',1Fh,'h',1Fh
		db	' ',1Fh,'0',1Fh,'0',1Fh,':',1Fh
		db	'0',1Fh,'0',1Fh,' ',1Fh
output_line_l	equ $-output_line

int1Ch_handler	endp

end	start
