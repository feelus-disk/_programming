;prg14_5.asm
include	mac.inc	;подключение файла с макросами
stk	segment	stack
	db	256 dup (0)
stk	ends

pdata	segment	para public 'data'
mes	db	'Общий сегмент',0ah,0dh,'$'
temp1	db	?
temp2	dd	?
temp3	dq	?
pdata	ends

	public	PutChar,PutCharEnd

common_data segment para common 'data'	;начало общей
			;области памяти
buffer	db	15 DUP (' ')	;буфер для формирования строки
tmpSI	dw	0
common_data	ends

code	segment	;начало сегмента кода
	assume	cs:code,es:common_data,ds:pdata
PutChar	proc	far	;обьявление процедуры
	cld
	mov	si,0
	mov	buffer[si],'Р'
	inc	si
	mov	buffer[si],'а'
	inc	si
	mov	buffer[si],'б'
	inc	si
	mov	buffer[si],'о'
	inc	si
	mov	buffer[si],'т'
	inc	si
	mov	buffer[si],'а'
	inc	si
	mov	buffer[si],'е'
	inc	si
	mov	buffer[si],'т'
	inc	si
	mov	buffer[si],'!'
	inc	si
	mov	tmpSI,si
	ret	;возврат из процедуры
PutChar	endp	;конец процедуры
PutCharEnd	proc	far
	mov	si,tmpSI
	mov	buffer[si],'$'
	ret
PutCharEnd	endp
code	ends
end

