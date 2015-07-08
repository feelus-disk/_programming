;prg13_1.asm
;prg_3_1.asm с макроопределениями
init_ds	macro
;Макрос настройки ds на сегмент данных
	mov	ax,data
	mov	ds,ax
	endm
out_str	macro	str
;Макрос вывода строки на экран.
;На входе - выводимая строка.
;На выходе- сообщение на экране.
push	ax
mov	ah,09h
mov	dx,offset str
int	21h
pop	ax
	endm

clear_r	macro	rg
;очистка регистра rg
	xor	rg,rg
	endm

get_char	macro
;ввод символа
;введенный символ в al
	mov	ah,1h
	int	21h
	endm

conv_16_2	macro
;макрос преобразования символа шестнадцатеричной цифры
;в ее двоичный эквивалент в al
	sub	dl,30h
	cmp	dl,9h
	jle	$+5
	sub	dl,7h
	endm

exit	macro
;макрос конца программы
	mov	ax,4c00h
	int 21h
	endm

data	segment para public 'data'
message	db	'Введите две шестнадцатеричные цифры (буквы A,B,C,D,E,F - прописные): $'
data	ends

stk	segment stack
	db	256 dup('?')
stk	ends

code	segment para public 'code'
	assume	cs:code,ds:data,ss:stk
main	proc
	init_ds
	out_str	message
	clear_r	ax
	get_char
	mov	dl,al
	conv_16_2
	mov	cl,4h
	shl	dl,cl
	get_char
	conv_16_2
	add	dl,al
	xchg	dl,al	;результат в al
	exit
main	endp
code	ends
end	main

