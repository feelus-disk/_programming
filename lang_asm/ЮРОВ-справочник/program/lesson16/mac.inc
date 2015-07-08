;mac.inc
OutStr	macro	str
;Вывод строки на экран.
;На входе - идентификатор начала выводимой строки.
;Строка должна заканчиваться символом '$'.
;На выходе- сообщение на экране.
	push	ax
	mov	ah,09h
	lea	dx,str
	int	21h
	pop	ax
endm
GetChar	macro
;Ввод символа с клавиатуры.
;На выходе - в al введённый символ.
	push	ax
	mov	ah,01h
	int	21h
	pop	ax
endm
OutChar macro
;Вывод символа на экран.
;На входе - в dl выводимый символ.
	push	ax
	mov	ah,02h
	int	21h
	pop	ax
endm
clear_r	macro	rg
;очистка регистра rg
	xor	rg,rg
	endm
conv_16_2	macro
;макрос преобразования символа шестнадцатеричной цифры
;в ее двоичный эквивалент в al
	sub	dl,30h
	cmp	dl,9h
	jle	$+5
	sub	dl,7h
	endm
GetStr	macro	buf,max_len
;ввод строки произвольной длины (функция 0ah int 21h)
;на входе:
;buf - адрес строки куда будет помещен ввод
;max_len - максимальная длина вводимой строки
;на выходе - введенная строка по адресу buf
;al - длина введенной строки
	push	es
	push	dx
	push	cx
	xor	cx,cx
	mov	buf,max_len
	mov	ah,0ah
	lea	dx,buf
	int	21h
	mov	al,buf+1
	mov	cl,al	;длина введенной строки в al
;сдвиг al на два байта влево:
	push	ds
	push	es
	lea	si,buf+2
	lea	di,buf
rep	movsb
	pop	cx
	pop	dx
	pop	es
GetStr	endm
init_ds	macro
;макрос настройки ds на сегмент данных
	mov	ax,data
	mov	ds,ax
	xor	ax,ax
	endm
delay	macro	time
	local	ext,iter	
;макрос задержки. На входе - значение
;переменной задержки (в мкс).
	push	cx
	mov	cx,time
ext:	push	cx
	mov	cx,5000	;это значение можно поменять, исходя из
;производительности процессора.
iter:	loop	iter
	pop	cx
	loop	ext
	pop	cx
	ENDM
Exit	macro
;Выход из программы.
	mov	ax,4c00h
	int	21h
endm

