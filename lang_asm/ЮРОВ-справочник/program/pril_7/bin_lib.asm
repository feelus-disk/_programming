Init	macro	mem1,mem2,len
;макрос для инициализации адресных регистров
	mov	di,offset mem1
	mov	si,offset mem2
	mov	cx,len
	endm
AddBIN	macro	mem1,mem2,len
;сложение BIN-чисел
;результат помещается в первый операнд
	Init	mem1,mem2,len
	call	AddBINp
	endm
SubBIN	macro	mem1,mem2,len
;вычитание BIN-чисел
;результат помещается в первый операнд
	Init	mem1,mem2,len
	call	SubBINp
	endm
MulBIN	macro	mem1,mem2,len
;умножение BIN-чисел
;результат:
;младшая часть помещается в первый операнд,
;старшая часть - во второй операнд
	Init	mem1,mem2,len
	call	MulBINp
	endm
DivBIN	macro	mem1,mem2,len
;деление BIN-чисел
;результат:
;частное помещается в первый операнд,
;остаток - во второй операнд
	mov	di,len-1+offset mem1
	mov	si,len-1+offset mem2
	mov	cx,len
	call	DivBINp
	endm
OutBIN	macro	mem,len
;вывод BIN-чисел на экран в текущую позицию
	mov	si,len-1+offset mem
	mov	cx,len
	call	OutBINp
	endm

data	segment
;для операций умножения и деления необходим буфер
;размер буфера не менее 3*SIZE,
;где SIZE - размер чисел
buffer	db	512 dup(?)
bufsize = $-buffer-1
a	dd	315
b	dd	12
c	dd	24
data	ends
stk	segment	stack 'stack'
	db	100h dup ('?')
stk	ends
code	segment
assume	cs:CODE,ds:DATA,es:DATA
AddBINp proc
;процедура сложения bin-чисел
	push	ax	;сохраним изменяемые регистры
	push	di
	push	si
	push	cx
	cld		;начинаем с младших разрядов
	clc	;обнулим значение флага переноса
_add_:
	lodsb		;возьмем очередную цифру
	adc	al,[di]	;сложение с учетом переноса
	stosb		;сохраним результат
	loop	_add_
	pop	cx	;восстановим регистры
	pop	si
	pop	di
	pop	ax
	ret
	endp
SubBINp proc
;процедура вычитания BIN-чисел
	push	ax	;сохраним изменяемые регистры
	push	di
	push	si
	push	cx
	cld		;начинаем с младших разрядов
	clc		;обнулим значение переноса
_sub_:
	lodsb		;возьмем очередную цифру
	sbb	[di],al	;вычитание с учетом переноса
	mov	al,[di]
	stosb		;сохраним результат
	loop	_sub_
	pop	cx	;восстановим регистры
	pop	si
	pop	di
	pop	ax
	ret
	endp
MulBINp	proc
;Процедура умножения BIN-чисел
	push	ax	;сохраним изменяемые регистры
	push	bx
	push	di
	push	si
	push	cx
	cld		;начинаем с младших разрядов
	mov	bx,offset buffer
	mov	dh,cl	;запомним исходное состояние счетчика
	push	bx
;заполним буфер результата нулями
	shl	cx,1	;необходим размер 2*SIZE
	xor	al,al	;символ-заполнитель = 0
_null_:
	mov	[bx],al
	inc	bx
	loop	_null_
	mov	cl,dh
	pop	bx
;умножение будем проводить "столбиком"
;цикл по всем цифрам первого операнда
_mul_o_:
	xor	dl,dl	;обнулим значение переноса
	push	cx
	push	bx	;сохраним некоторые регистры
	push	si
	mov	cl,dh	;восстановим исходное
			;значение счетчика
;цикл по всем цифрам второго операнда
_mul_i_:
	lodsb		;возьмем очередную цифру
	mul	byte ptr [di]	;умножим
	add	al,dl	;учтем перенос
	adc	ah,0
	add	al,[bx]	;сложим с результатом
			;предыдущего умножения
	adc	ah,0
	mov	dl,ah	;запомним значение переноса
	xor	ah,ah
	mov	[bx],al	;сохраним результат
	inc	bx
	loop	_mul_i_
	mov	[bx],dl
	pop	si	;восстановим регистры
	pop	bx
	inc	bx
	inc	di	;перейдем к следующей цифре
			;второго операнда
	pop	cx
	loop	_mul_o_
	mov	cl,dh	;восстановим исходное
			;значение счетчика
	sub	bx,cx	;сместим bx на младшую
			;часть результата
	sub	di,cx
;занесем результат (мл. часть) в первый операнд
_move_l_:
	mov	al,[bx]
	inc	bx
	stosb
	loop	_move_l_
	mov	cl,dh
	mov	di,si
;занесем результат (ст. часть) во второй операнд
_move_h_:
	mov	al,[bx]
	inc	bx
	stosb
	loop	_move_h_
	pop	cx	;восстановим регистры
	pop	si
	pop	di
	pop	bx
	pop	ax
	ret
endp
SubInvBINp	proc
;вспомогательная процедура для операции деления
;производит вызов процедуры вычитания
;без начальной инициализации
	push	si
	push	di
	sub	si,cx
	inc	si
	sub	di,cx
	inc	di
	call	SubBINp
	pop	di
	pop	si
	ret
	endp
CmpBINp	proc
;процедура сравнения BIN-чисел
;CF=0, если [si]>[di], иначе CF=1
	push	ax
	push	di
	push	si
	push	cx
	std
_cmp_:
	lodsb
	cmp	al,[di]
	jb	_less_
	ja	_greater_
	dec	di
	loop	_cmp_
_less_:
	stc
	jc	_cmp_q_
_greater_:
	clc
_cmp_q_:
	pop	cx
	pop	si
	pop	di
	pop	ax
	ret
	endp
PrepareForDiv	proc
;процедура инициализации буфера для операции деления
	std
;0,[di] -> buffer (первый операнд в буфер)
	push	di
	push	si
	push	di
	pop	si
	mov	di,bufsize+offset buffer
	xor	al,al
	push	cx
	stosb
	rep	movsb
;0,[si] -> buffer (второй операнд в буфер)
	pop	cx
	stosb
	pop	si
	push	cx
;для начала найдем первую значащую цифру
_find_:
	lodsb
	dec	cx
	cmp	al,0
	je	_find_
	inc	si
	inc	cx
	mov	dx,cx
	rep movsb
	pop	cx
	push	cx
;0,0..0 -> buffer - очистим место для результата
	xor	al,al
	rep	stosb
;переназначение регистров
	mov	di,bufsize+offset buffer
	pop	cx
	mov	si,di
	inc	cx
	sub	si,cx
	pop	bx
	ret
	endp
DivBINp	proc
;процедура деления BIN-чисел
	push	ax	;сохраним изменяемые регистры
	push	bx
	push	di
	push	si
	push	cx
	push	di
	call	PrepareForDiv	;подготовим буфер
	xor	ax,ax	;в al - очередная цифра результата
;в ah - количество цифр в результате
	call	CmpBINp
	jnc	_next_1_
_div_:
	call	CmpBINp
	jnc	_next_
	inc	al
	call	SubInvBINp
	jmp	_div_
_next_:
	mov	[bx],al	;сохраним очередную цифру
	dec	bx	;уменьшим порядок делимого
_next_1_:
	dec	di
	dec	cx
	xor	al,al
	inc	ah
	cmp	cx,dx	;сравним порядки делимого и делителя
	jne	_div_
	dec	ah
	pop	di
	pop	cx
	push	cx
;пересылаем результат из буфера в операнды
	mov	si,di
	sub	di,cx
	push	cx
	mov	cl,ah
	sub	si,cx
	inc	si
	inc	di
	cld
	rep	movsb
	pop	cx
	sub	cl,ah
	xor	al,al
	rep	stosb
	pop	cx
	pop	si
	push	si
	push	cx
	mov	di,si
	mov	si,bufsize+offset buffer
	dec	si
	std
	rep	movsb
	pop	cx	;восстановим регистры
	pop	si
	pop	di
	pop	bx
	pop	ax
	ret
	endp
OutBINp	proc
;процедура вывода BIN-чисел на экран
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	mov	ah,06h
	std
_out_:
	lodsb
	mov	bl,al
	mov	dl,bl
	shr	dl,4
	or	dl,30h
	cmp	dl,39h
	jle	_digit_1_
	add	dl,7
_digit_1_:
	int	21h
	mov	dl,bl
	and	dl,0fh
	or	dl,30h
	cmp	dl,39h
	jle	_digit_2_
	add	dl,7
_digit_2_:
	int	21h
	loop	_out_
	mov	dl,0dh
	int	21h
	mov	dl,0ah
	int	21h
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
	endp
main	proc
;проверим как работает пакет
	mov	ax,DATA
	mov	ds,ax
	mov	es,ax
	OutBIN	a,4
	OutBIN	b,4
	AddBIN	a,b,4
	OutBIN	a,4
	OutBIN	b,4
	SubBIN	a,b,4
	OutBIN	a,4
	OutBIN	b,4
	MulBIN	a,b,4
	OutBIN	a,4
	OutBIN	b,4
	OutBIN	c,4
	DivBIN	a,c,4
	OutBIN	a,4
	OutBIN	c,4
	mov	ax,4c00h
	int	21h
main	endp
code	ends
	end	main

