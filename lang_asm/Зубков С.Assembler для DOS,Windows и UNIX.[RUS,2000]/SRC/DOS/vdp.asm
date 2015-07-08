; vdp.asm
; решение уравнения Ван-дер-Поля
; x(t)'' = -x(t) + m(1-x(t)2)x(t)'
; с m = 0, 1, 2, 3, 4, 5, 6, 7, 8
;
; программа выводит на экран решение с m = 1, нажатие клавиш 0 - 8 изменяет m
; Esc - выход, любая другая клавиша - пауза до нажатия одной из Esc, 0 - 8
;
; Компиляция:
; TASM:
;  tasm /m vdp.asm
;  tlink /t /x vdp.obj
; MASM:
;  ml /c vdp.asm
;  link vdp.obj,,NUL,,,
;  exe2bin vdp.exe vdp.com
; WASM:
;  wasm vdp.asm
;  wlink file vdp.obj form DOS COM
;

	.model tiny
	.286		; для команд pusha и popa
	.287		; для команд FPU
	.code
	org 100h	; COM-программа

start	proc	near
	cld
	push	0A000h
	pop	es	; адрес видеопамяти в ES

	mov	ax,0012h
	int	10h	; графический режим 640x480x16

	finit		; инициализировать FPU

	xor	si, si	; SI будет содержать координату t и меняться
			; от 0 до 640
	fld1			; 1
	fild word ptr hinv ; 32, 1
	fdiv			; h		(h = 1/hinv)
; установка начальных значений для _display:
; m = 1, x = h = 1/32, y = x' = 0
again: fild word ptr m	; m, h
	fld	st(1)		; x, m, h	(x = h)
	fldz			; y, x, m, h	(y = 0)
	call	_display	; выводить на экран решение, пока
				; не будет нажата клавиша
g_key: mov	ah, 10h	; чтение клавиши с ожиданием
	int	16h		; код нажатой клавиши в AL,
	cmp	al, 1Bh	; если это Esc,
	jz	g_out		; выйти из программы,
	cmp	al,'0'	; если код меньше '0',
	jb	g_key		; пауза/ожидание следующей клавиши,
	cmp	al,'8'	; если код больше '8',
	ja	g_key		; пауза/ожидание следующей клавиши, 
	sub	al,'0'	; иначе: AL = введенная цифра,
	mov	byte ptr m,al ; m = введенная цифра 
	fstp	st(0)		; x, m, h
	fstp	st(0)		; m, h
	fstp	st(0)		; h
	jmp short again

g_out:	mov	ax,0003h	; текстовый режим
	int	10h
	ret			; конец программы
start	endp

; процедура display_
; пока не нажата клавиша, выводит решение на экран, делая паузу после каждой из
; 640 точек
;
_display	proc	near
dismore:
	mov	bx,0		; стереть предыдущую точку: цвет = 0
	mov	cx,si
	shr	cx,1		; CX - строка
	mov	dx,240
	sub	dx,word ptr ix[si] ; DX - столбец
	call	putpixel1b
	call	next_x	; вычислить x(t) для следующего t
	mov	bx,1		; вывести точку: цвет = 1
	mov	dx,240
	sub	dx,word ptr ix[si] ; DX - столбец
	call	putpixel1b
	inc	si
	inc	si		; SI = SI + 2 (массив слов),
	cmp	si,640*2	; если SI достигло конца массива IX
	jl	not_endscreen ; пропустить паузу
	sub	si,640*2	; переставить SI на начало массива IX
not_endscreen:
	mov	dx,5000
	xor	cx,cx
	mov	ah,86h
	int	15h		; пауза на CX:DX микросекунд

	mov	ah,11h
	int	16h		; проверить, была ли нажата клавиша,
	jz	dismore	; если нет - продолжить вывод на экран,
	ret			; иначе - закончить процедуру
_display	endp

; процедура next_x
; проводит вычисления по формулам:
; y = y + h(m(1-x^2)y-x)
; x = x + hy
; ввод: st = y, st(1) = x, st(2) = m, st(3) = h
; вывод: st = y, st(1) = x, st(2) = m, st(3) = h, x * 100 записывается в ix[si]
next_x	proc	near
	fld1			; 1, y, x, m, h
	fld	st(2)		; x, 1, y, x, m, h
	fmul	st,st(3)	; x2, 1, y, x, m, h
	fsub			; (1-x2), y, x, m, h
	fld	st(3)		; m, (1-x2), y, x, m, h
	fmul			; M, y, x, m, h		(M = m(1-x2))
	fld	st(1)		; y, M, y, x, m, h
	fmul			; My, y, x, m, h
	fld	st(2)		; x, My, y, x, m, h
	fsub			; My-x, y, x, m, h
	fld	st(4)		; h, My-x, y, x, m, h
	fmul			; h(My-x), y, x, m, h
	fld	st(1)		; y, h(My-x), y, x, m, h
	fadd			; Y, y, x, m, h		(Y = y + h(My-x))
	fxch			; y, Y, x, m, h
	fld	st(4)		; h, y, Y, x, m, h
	fmul			; yh, Y, x, m, h
	faddp	st(2),st	; Y, X, m, h		(X = x  +  hy)
	fld	st(1)		; X, Y, X, m, h
	fild	word ptr c_100	; 100, X, Y, X, m, h
	fmul		; 100X, Y, X, m, h
	fistp	word ptr ix[si]	; Y, X, m, h
	ret
next_x	endp

; Процедура вывода точки на экран в режиме, использующем 1 бит на пиксель
; DX = строка, CX = столбец, ES = A000h, BX = цвет (1 - белый, 0 - черный)
; все регистры сохраняются

putpixel1b	proc	near
	pusha			; сохранить регистры
	push	bx
	xor	bx,bx
	mov	ax,dx		; AX = номер строки
	imul	ax,ax,80	; AX = номер строки * число байтов в строке
	push	cx
	shr	cx,3		; CX = номер байта в строке
	add	ax,cx		; AX = номер байта в видеопамяти
	mov	di,ax		; поместить его в DI и SI
	mov	si,di 

	pop	cx		; CX снова содержит номер столбца
	mov	bx,0080h
	and	cx,07h	; последние три бита CX = 
; остаток от деления на 8 =
; номер бита в байте, считая справа налево
	shr	bx,cl		; теперь в BL установлен в 1 нужный бит
	lods	es:byte ptr ix	; AL = байт из видеопамяти
	pop	dx
	dec	dx		; проверить цвет:
	js	black		; если 1 -
	or	ax,bx		; установить выводимый бит в 1,
	jmp	short	white
black:	not	bx	; если 0 - 
	and	ax,bx		; установить выводимый цвет в 0,
white:
	stosb			; и вернуть байт на место
	popa			; восстановить регистры
	ret			; конец
putpixel1b	endp


m	dw	1		; начальное значение m
c_100	dw	100		; масштаб по вертикали
hinv	dw	32		; начальное значение 1/h 
ix:				; начало буфера для значений x(t)
				; (всего 1280 байтов за концом программы)
	end	start
