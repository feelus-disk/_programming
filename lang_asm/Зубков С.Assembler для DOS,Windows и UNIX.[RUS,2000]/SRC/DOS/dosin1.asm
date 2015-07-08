; dosin1.asm
; Переводит десятичное число в шестнадцатеричное
;
; Компиляция:
; TASM:
; tasm /m dosin1.asm
; tlink /t /x dosin1.obj
; MASM:
; ml /c dosin1.asm
; link dosin1.obj,,NUL,,,
; exe2bin dosin1.exe dosin1.com
; WASM
; wasm dosin1.asm
; wlink file dosin1.obj form DOS COM
;

	.model	tiny
	.code
	.286		; для команды shr al,4
	org	100h	; начало COM-файла
start:
	mov	dx,offset message1
	mov	ah,9
	int	21h		; вывести приглашение к вводу message1
	mov	dx,offset buffer
	mov	ah,0Ah
	int	21h		; считать строку символов в буфер
	mov	dx,offset crlf
	mov	ah,9
	int	21h		; перевод строки

; перевод числа в ASCII-формате из буфера в бинарное число в AX
	xor	di,di		; DI = 0 - номер байта в буфере
	xor	ax,ax		; AX = 0 - текущее значение результата
	mov	cl,blength
	xor	ch,ch
	xor	bx,bx
	mov	si,cx		; SI - длина буфера
	mov	cl,10		; CL = 10, множитель для MUL
asc2hex:
	mov	bl,byte ptr bcontents[di]
	sub	bl,'0'	; цифра = код цифры - код символа "0"
	jb	asc_error	; если код символа был меньше, чем код "0",
	cmp	bl,9		; или больше, чем "9",
	ja	asc_error	; выйти из программы с сообщением об ошибке,
	mul	cx		; иначе: умножить текущий результат на 10,
	add	ax,bx		; добавить к нему новую цифру,
	inc	di		; увеличить счетчик
	cmp	di,si		; если счетчик+1 меньше числа символов -
	jb	asc2hex	; продолжить
; (счетчик считается от 0)

; вывод на экран строки message2
	push	ax		; сохранить результат преобразования
	mov	ah,9
	mov	dx,offset message2
	int	21h
	pop	ax

; вывод на экран числа из регистра AX
	push	ax
	xchg	ah,al		; поместить в AL старший байт
	call	print_al	; вывести его на экран
	pop	ax		; восстановить в AL младший байт
	call	print_al	; вывести его на экран

	ret		; завершение COM-файла

asc_error:
	mov	dx,offset err_msg
	mov	ah,9
	int	21h		; вывести сообщение об ошибке
	ret			; и завершить программу


; Процедура print_al.
; выводит на экран число в регистре AL в шестнадцатеричном формате
; модифицирует значения регистров AX и DX


print_al:
	mov	dh,al
	and	dh,0Fh		; DH - младшие 4 бита
	shr	al,4		; AL - старшие
	call	print_nibble	; вывести старшую цифру
	mov	al,dh		; теперь AL содержит младшие 4 бита
print_nibble:		; процедура вывода 4 бит (шестнадцатеричной цифры)
	cmp	al,10		; три команды, переводящие цифру в AL
	sbb	al,69h		; в соответствующий ASCII-код
	das			; (см. описание команды DAS)

	mov	dl,al		; код символа в DL
	mov	ah,2		; номер функции DOS в AH
	int	21h		; вывод символа
	ret		; этот RET работает два раза - один раз для возврата из
; процедуры print_nibble, вызванной для старшей цифры,
; и второй раз - для возврата из print_al

message1 db	'Enter decimal number: $'
message2 db	'Hex number is: $'
err_msg	db	'Bad number entered'
crlf	db	0Dh,0Ah,'$'
buffer	db	6		; максимальный размер буфера ввода
blength	db	?		; размер буфера после считывания
bcontents:			; содержимое буфера располагается за
				; концом COM-файла
end	start
