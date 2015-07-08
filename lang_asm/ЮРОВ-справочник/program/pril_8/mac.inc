;mac.inc
GetStr	macro	Buf,MaxLen
	local	m,TmpBuf
;ввод строки произвольной длины (функция 0ah int 21h)
;на входе:
;Buf - адрес строки куда будет помещен ввод
;MaxLen - максимальная длина вводимой строки
;на выходе - введенная строка по адресу Buf
;al - длина введенной строки
	jmp	m
TmpBuf	label	byte	;временный буфер форматом для функции 0ah (int 21h)
	rept	MaxLen+3	;доп. три байта - служебная информация
	db	' '
	endm
m:
	SaveReg	<ds,es,dx,cx>
	xor	cx,cx
	mov	cs:TmpBuf,MaxLen+1
	mov	ah,0ah
	push	ds
	pop	es
	push	cs
	pop	ds
	lea	dx,cs:TmpBuf
	int	21h
	mov	al,cs:TmpBuf+1
;пересылка TmpBuf в Buf со сдвигом  на два байта влево (для удаления служебных символов):
	mov	cl,al	;длина введенной строки в al
	lea	si,cs:TmpBuf+2	;откуда - ds:si
	lea	di,buf	;куда - es:di
rep	movsb
	LoadReg	<cx,dx,es,ds>
	endm

mov_string	macro	dest,src,len
;Пересылка строк
;На входе идентификаторы: строки-источника - src, строки-приемника - dest
;сегментные регистры ds (для источника) и es (для приемника) должны быть загружены 
;правильными значениями до вызова макрокоманды
	mov	cx,len
	lea	si,src
	lea	di,dest
rep	movsb	
	endm

null_string	macro	dest,len
	local	m,Z_String
;очистка строки произвольной длины пробелами
;на входе:
;dest - адрес строки
;len - длина очищаемой строки
	jmp	m
Z_String	label	byte	;пустая строка
	rept	len
	db	' '
	endm
m:
	SaveReg	<ds,es,cx,si,di>
	mov	cx,len
	push	ds
	pop	es	;адрес dest (приемник) - es:di
	push	cs
	pop	ds	;адрес Z_String (источник) - ds:si
	lea	si,cs:Z_String
	lea	di,dest
rep	movsb	
	LoadReg	<di,si,cx,es,ds>
	endm
OutStr	macro	str
;Вывод строки на экран.
;На входе - идентификатор начала выводимой строки.
;Строка должна заканчиваться символом '$'.
;На выходе- сообщение на экране.
	SaveReg	<ax,dx>
	mov	ah,09h
	lea	dx,str
	int	21h
	LoadReg	<dx,ax>
	endm

GetChar	macro
;Ввод символа с клавиатуры.
;На выходе - в al введённый символ.
	mov	ah,01h
	int	21h
	endm

OutChar macro
;Вывод символа на экран.
;На входе - в dl выводимый символ.
	push	ax
	mov	ah,02h
	int	21h
	pop	ax
endm

SaveReg	macro	RegList
;Сохранение указанных в списке RegList регистров в стеке
;список регистров должен быть заключен в угловые скобки, 
;например - <ax,bx,cx>
	irp	reg,<RegList>
	push	reg
	endm
	endm

LoadReg	macro	RegList
;Восстановление указанных в списке RegList регистров из стека
;список регистров должен быть заключен в угловые скобки, 
;например - <ax,bx,cx>
	irp	reg,<RegList>
	pop	reg
	endm
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

init_ds	macro
;макрос настройки ds на сегмент данных
	mov	ax,data
	mov	ds,ax
	xor	ax,ax
	endm

delay	macro	time
	local	ext,iter	
;макрос задержки. На входе - значение переменной задержки (в мкс).
	push	cx
	mov	cx,time
ext:	push	cx
	mov	cx,5000	;это значение можно поменять, исходя из производительности процессора.
iter:	loop	iter
	pop	cx
	loop	ext
	pop	cx
	endm

_Exit	macro
;Выход из программы.
	mov	ax,4c00h
	int	21h
	endm

