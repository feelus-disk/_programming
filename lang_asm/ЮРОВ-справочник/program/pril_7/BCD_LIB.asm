Init	macro	mem1,mem2,len
;макрос для инициализации адресных регистров
	mov	di,len-1+offset mem1
	mov	si,len-1+offset mem2
	mov	cx,len
	endm
AddBCD	macro	mem1,mem2,len
;сложение BCD-чисел
;результат помещается в первый операнд
	Init	mem1,mem2,len
	call	AddBCDp
	endm
SubBCD	MACRO	mem1,mem2,len
;вычитание BCD-чисел
;результат помещается в первый операнд
	Init	mem1,mem2,len
	call	SubBCDp
	endm
MulBCD	macro	mem1,mem2,len
;умножение BCD-чисел
;результат:
;младшая часть помещается в первый операнд,
;старшая часть - во второй операнд
	Init	mem1,mem2,len
	call	MulBCDp
	endm
DivBCD	macro	mem1,mem2,len
;деление BCD-чисел
;результат:
;частное помещается в первый операнд,
;остаток - во второй операнд
	mov	di,offset mem1
	mov	si,offset mem2
	mov	cx,len
	call	DivBCDp
	endm
OutBCD	macro	mem,len
;вывод BCD-чисел на экран в текущую позицию
	mov	si,offset mem
	mov	cx,len
	call	OutBCDp
	endm

data	segment
;для операций умножения и деления необходим буфер
;размер буфера не менее 3*SIZE,
;где SIZE-размер чисел
buffer	db	512 dup(?)
a	db	0,0,4,0,1,4,5,2,2,2
b	db	0,0,0,0,0,3,8,9,7,8
c	db	2,8,0,1,0,0,1,9,8,3
d	db	9,9,3,3,3,3,3,3,3,3
data	ends

code	segment
assume	cs:code,ds:data,es:data
AddBCDp	proc
;процедура сложения BCD-чисел
	push	ax	;сохраним изменяемые регистры
	push	di
	push	si
	push	cx
	std		;начинаем с младших разрядов
	clc		;обнулим значение переноса
_add_:
	lodsb		;возьмем очередную цифру
	adc	al,[di]	;сложение с учетом переноса
	aaa		;выровняем в формат BCD-чисел
	stosb		;сохраним результат
	loop	_add_
	pop	cx	;восстановим регистры
	pop	si
	pop	di
	pop	ax
	ret
	endp
SubBCDp	proc
;процедура вычитания BCD-чисел
	push	ax	;сохраним изменяемые регистры
	push	di
	push	si
	push	cx
	std		;начинаем с младших разрядов
	clc		;обнулим значение переноса
_sub_:
	lodsb		;возьмем очередную цифру
	sbb	[di],al	;вычитание с учетом переноса
	mov	al,[di]
	aas		;выровняем в формат BCD-чисел
	stosb		;сохраним результат
	loop	_sub_
	pop	cx	;восстановим регистры
	pop	si
	pop	di
	pop	ax
	ret
	endp
MulBCDp	proc
;процедура умножения BCD-чисел
	push	ax	;сохраним изменяемые регистры
	push	bx
	push	di
	push	si
	push	cx
	std		;начинаем с младших разрядов
	mov	bx,offset buffer
	mov	dh,cl	;запомним исходное
			;состояние счетчика
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
	aam		;коррекция результата
	add	al,dl	;учтем перенос
	aaa
	add	al,[bx]	;сложим с результатом
			;предыдущего умножения
	aaa
	mov	dl,ah	;запомним значение переноса
	xor	ah,ah
	mov	[bx],al	;сохраним результат
	inc	bx
	loop	_mul_i_
	mov	[bx],dl
	pop	si	;восстановим регистры
	pop	bx
	inc	bx
	dec	di	;перейдем к следующей
			;цифре второго операнда
	pop	cx
	loop	_mul_o_
	mov	cl,dh	;восстановим исходное
			;значение счетчика
	sub	bx,cx	;сместим bx на младшую
			;часть результата
	add	di,cx
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
SubInvBCDp	proc
;вспомогательная процедура для операции деления
;производит вызов процедуры вычитания
;без начальной инициализации
	push	si
	push	di
	add	si,cx
	dec	si
	add	di,cx
	dec	di
	call	SubBCDp
	pop	di
	pop	si
	ret
	ENDP
CmpBCDp	proc
;процедура сравнения BCD-чисел
;CF=0, если [si]>[di], иначе CF=1
	push	ax
	push	di
	push	si
	push	cx
	cld
_cmp_:
	lodsb
	cmp	al,[di]
	jl	_less_
	jg	_greater_
	inc	di
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
;процедура инициализации буфера
;для операции деления
	cld
;0,[di] -> buffer (первый операнд в буфер)
	push	di
	push	si
	push	di
	pop	si
	mov	di,offset buffer
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
	dec	si
	inc	cx
	mov	dx,cx
	rep movsb
	pop	cx
	push	cx
; 0,0..0 -> buffer (очистить место для результата в буфере)
	xor	al,al
	rep	stosb
;переназначение регистров
	mov	di,offset buffer
	pop	cx
	mov	si,di
	inc	cx
	add	si,cx
	pop	bx
	ret
	endp
DivBCDp	proc
;процедура деления BCD-чисел
	push	ax	;сохраним изменяемые регистры
	push	bx
	push	di
	push	si
	push	cx
	push	di
	call	PrepareForDiv	;подготовим буфер
	xor	ax,ax	;в al - очередная цифра результата
			;в ah - количество цифр в результате
	call	CmpBCDp
	jnc	_next_1_
_div_:
	call	CmpBCDp
	jnc	_next_
	inc	al
	call	SubInvBCDp
	jmp	_div_
_next_:
	mov	[bx],al	;сохраним очередную цифру
	inc	bx	;уменьшим порядок делимого
_next_1_:
	inc	di
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
	add	di,cx
	push	cx
	mov	cl,ah
	add	si,cx
	dec	si
	dec	di
	std
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
	mov	si,offset buffer
	inc	si
	cld
rep	movsb
	pop	cx	;восстановим регистры
	pop	si
	pop	di
	pop	bx
	pop	ax
	ret
	endp
OutBCDp	proc
;процедура вывода BCD-чисел на экран
	mov	ah,06h
	cld
_out_:
	lodsb
	or	al,30h
	mov	dl,al
	int	21h
	loop	_out_
	mov	dl,0dh
	int	21h
	mov	dl,0ah
	int	21h
	ret
	endp

main	proc
	mov	ax,data
	mov	ds,ax
	mov	es,ax
	OutBCD	a,10
	OutBCD	b,10
	AddBCD	a,b,10
	OutBCD	a,10
	OutBCD	b,10
	SubBCD	a,b,10
	OutBCD	a,10
	OutBCD	b,10
	MulBCD	a,b,10
	OutBCD	a,10
	OutBCD	b,10
	DivBCD	a,b,10
	OutBCD	a,10
	OutBCD	b,10
	mov	ax,4c00h
	int	21h
main	endp
code	ends
	end	main


