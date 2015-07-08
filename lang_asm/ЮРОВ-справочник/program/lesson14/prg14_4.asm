;prg14_4.asm
include	mac.inc	;подключение файла с макросами
stk	segment	stack
	db	256 dup (0)
stk	ends
common_data	segment	para common 'data'	;начало общей
			;области памяти
buf	db	15 DUP (' ')	;буфер для хранения строки
temp	dw	0
common_data	ends
	extrn	PutChar:far,PutCharEnd:far
code	segment	;начало сегмента кода
	assume	cs:code,es:common_data
main	proc
	mov	ax,common_data
	mov	es,ax
;вызов внешних процедур
	call	PutChar
	call	PutCharEnd
	push	es
	pop	ds
	_OutStr	buf
exit:
	_Exit	;стандартный выход
main	endp	;конец главной процедуры
code	ends
	end	main

