; mousedr.asm
; Рисует на экране прямые линии с концами в позициях, указываемых мышью
;
; Компиляция:
; TASM:
; tasm /m mousedr.asm
; tlink /t /x mousedr.obj
; MASM:
; ml /c mousedr.asm
; link mousedr.obj,,NUL,,,
; exe2bin mousedr.exe mousedr.com
; WASM:
; wasm mousedr.asm
; wlink file mousedr.obj form DOS COM
;

	.model	tiny
	.code
	org	100h		; COM-файл
	.186			; для команды shr cx,3
start:
	mov	ax,12h
	int	10h		; видеорежим 640x480
	mov	ax,0		; инициализировать мышь
	int	33h
	mov	ax,1		; показать курсор мыши
	int	33h

	mov	ax,000Ch	; установить обработчик событий мыши
	mov	cx,0002h	; событие - нажатие левой кнопки
	mov	dx,offset handler ; ES:DX - адрес обработчика
	int	33h

	mov	ah,0		; ожидание нажатия любой клавиши
	int	16h
	mov	ax,000Ch
	mov	cx,0000h	; удалить обработчик событий мыши
	int	33h
	mov	ax,3		; текстовый режим
	int	10h
	ret			; конец программы

; Обработчик событий мыши: при первом нажатии выводит точку на экран,
; при каждом дальнейшем вызове проводит прямую линию от предыдущей точки к 
; текущей

handler:
	push	0A000h
	pop	es		; ES - начало видеопамяти 
	push	cs
	pop	ds		; DS - сегмент кода и данных этой программы
	push	cx		; CX (X-координата) и 
	push	dx		; DX (Y-координата) потребуются в конце

	mov	ax,2		; спрятать курсор мыши перед выводом на экран
	int	33h

	cmp	word ptr previous_X,-1	; если это первый вызов,
	je	first_point		; только вывести точку,

	call	line_bresenham		; иначе - провести прямую
exit_handler:
	pop	dx			; восстановить CX и DX
	pop	cx
	mov	previous_X,cx		; и запомнить их как предыдущие
	mov	previous_Y,dx		; координаты

	mov	ax,1		; показать курсор мыши
	int	33h

	retf			; выход из обработчика - команда RETF

first_point:
	call	putpixel1b	; вывод одной точки (при первом вызове)
	jmp short exit_handler


; Процедура рисования прямой линии с использованием алгоритма Брезенхама
; Ввод: CX,DX - X, Y конечной точки
; previous_X,previous_Y - X, Y начальной точки
 
line_bresenham:
	mov	ax,cx
	sub	ax,previous_X	; AX = длина проекции прямой на ось X
	jns	dx_pos			; если AX отрицательный - 
	neg	ax				; сменить его знак, причем
	mov	word ptr X_increment,1	; координата X при выводе
	jmp short dx_neg			; прямой будет расти,
dx_pos:	mov	word ptr X_increment,-1 ; а иначе - уменьшаться

dx_neg:	mov	bx,dx
	sub	bx,previous_Y	; BX = длина проекции прямой на ось Y
	jns	dy_pos			; если BX отрицательный - 
	neg	bx				; сменить его знак, причем
	mov	word ptr Y_increment,1	; координата Y при выводе
	jmp short dy_neg			; прямой будет расти,
dy_pos:	mov	word ptr Y_increment,-1	; а иначе - уменьшаться
dy_neg:
	shl	ax,1		; удвоить значения проекций,
	shl	bx,1		; чтобы избежать работы с полуцелыми числами

	call	putpixel1b	; вывести первую точку (прямая рисуется от
; CX,DX к previous_X,previous_Y
	cmp	ax,bx		; если проекция на ось X больше, чем на Y:
	jna	dx_le_dy
	mov	di,ax		; DI будет указывать, в какую сторону мы
	shr	di,1		; отклонились от идеальной прямой
	neg	di		; оптимальное начальное значение DI:
	add	di,bx		; DI = 2 * dy - dx.
cycle:
	cmp	cx,word ptr previous_X	; основной цикл выполняется,
	je	exit_bres		; пока X не станет равно previous_X
	cmp	di,0				; если DI > 0,
	jl	fractlt0
	add	dx,word ptr Y_increment	; перейти к следующему Y
	sub	di,ax				; и уменьшить DI на 2 * dx
fractlt0:
	add	cx,word ptr X_increment	; следующий X (на каждом шаге)
	add	di,bx			; увеличить DI на 2 * dy
	call	putpixel1b		; вывести точку
	jmp short cycle		; продолжить цикл

dx_le_dy:			; если проекция на ось Y больше, чем на X
	mov	di,bx
	shr	di,1
	neg	di		; оптимальное начальное значение DI:
	add	di,ax		; DI = 2 * dx - dy
cycle2:
	cmp	dx,word ptr previous_Y	; основной цикл выполняется,
	je	exit_bres		; пока Y не станет равным previous_Y,
	cmp	di,0				; если DI > 0
	jl	fractlt02
	add	cx,word ptr X_increment	; перейти к следующему X
	sub	di,bx				; и уменьшить DI на 2 * dy
fractlt02:
	add	dx,word ptr Y_increment	; следующий Y (на каждом шаге)
	add	di,ax			; увеличить DI на 2 * dy
	call	putpixel1b		; вывести точку
	jmp short cycle2		; продолжить цикл
exit_bres:
	ret				; конец процедуры

; Процедура вывода точки на экран в режиме, использующем один бит для
; хранения одного пикселя. 
; DX = строка, CX = столбец
; Все регистры сохраняются

putpixel1b:
	pusha			; сохранить регистры
	xor	bx,bx
	mov	ax,dx		; AX = номер строки
	imul	ax,ax,80	; AX = номер строки * число байтов в строке
	push	cx
	shr	cx,3		; CX = номер байта в строке
	add	ax,cx		; AX = номер байта в видеопамяти
	mov	di,ax		; поместить его в SI и DI для команд
	mov	si,di		; строковой обработки

	pop	cx		; CX снова содержит номер столбца
	mov	bx,0080h
	and	cx,07h	; последние три бита CX = 
; остаток от деления на 8 = 
; номер бита в байте, считая справа налево
	shr	bx,cl		; теперь в BL установлен в 1 нужный бит
	lods	es:byte ptr some_label	; AL = байт из видеопамяти
	or	ax,bx		; установить выводимый бит в 1
; чтобы стереть пиксель с экрана, эту команду OR можно заменить на 
; not bx
; and ax,bx
; или лучше инициализировать BX не числом 0080h, а числом FF7Fh и использовать 
; только and
	stosb			; и вернем байт на место
	popa			; восстановим регистры
	ret			; конец

previous_X	dw	-1	; предыдущая X-координата
previous_Y	dw	-1	; предыдущая Y-координата 
Y_increment	dw	-1	; направление изменения Y
X_increment	dw	-1	; направление изменения X
some_label:			; метка, используемая для переопределения 
; сегмента-источника для lods с DS на ES
	end	start

