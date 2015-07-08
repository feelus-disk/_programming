; liss.asm
; строит фигуры Лиссажу, используя арифметику с фиксированной запятой и 
; генерацию таблицы косинусов
; Фигуры Лиссажу - семейство кривых, задаваемых параметрическими выражениями
; x(t) = cos(SCALE_V * t)
; y(t) = sin(SCALE_H * t)
;
; чтобы выбрать новую фигуру, измените параметры SCALE_H и SCALE_V
; для построения незамкнутых фигур удалите строку add di,512 в процедуре
; move_point
;
; Компиляция:
; TASM:
; tasm /m liss.asm
; tlink /t /x liss.obj
; MASM:
; ml /c liss.asm
; link liss.obj,,NUL,,,
; exe2bin liss.exe liss.com
; WASM:
; wasm liss.asm
; wlink file liss.obj form DOS COM
;


	.model	tiny
	.code
	.386		; будут использоваться 32-битные регистры
	org	100h	; COM-программа

SCALE_H	equ	3	; число периодов в фигуре по горизонтали
SCALE_V	equ	5	; число периодов по вертикали

start	proc	near
	cld			; для команд строковой обработки

	mov	di,offset cos_table ; адрес начала таблицы косинусов
	mov	ebx,16777137 ; 224 * cos(360/2048) - заранее вычисленное
	mov	cx,2048	; число элементов для таблицы
	call	build_table	; построить таблицу косинусов

	mov	ax,0013h	; графический режим
	int	10h		; 320x200x256

	mov	ax,1012h	; установить набор регистров палитры VGA,
	mov	bx,70h	; начиная с регистра 70h
	mov	cx,4		; четыре регистра
	mov	dx,offset palette ; адрес таблицы цветов
	int	10h

	push	0A000h	; сегментный адрес видеопамяти
	pop	es		; в ES

main_loop:
	call	display_picture ; изобразить точку со следом

	mov	dx,5000
	xor	cx,cx
	mov	ah,86h
	int	15h		; пауза на CX:DX микросекунд

	mov	ah,11h	; проверить, была ли нажата клавиша,
	int	16h
	jz	main_loop	; если нет - продолжить основной цикл

	mov	ax,0003h	; текстовый режим
	int	10h		; 80x24

	ret			; конец программы
start	endp

; процедура build_table
; строит таблицу косинусов в формате с фиксированной запятой 8:24
; по рекуррентной формуле cos(xk) = 2 * cos(span/steps) * cos(xk-1) - cos(xk-2),
; где span - размер области, на которой вычисляются косинусы (например 360),
; а steps - число шагов, на которые разбивается область
; Ввод: DS:DI = адрес таблицы
;	DS:[DI] = 224
;	EBX = 224 * cos(span/steps)
;	CX = число элементов таблицы, которые надо вычислить
; Вывод: таблица размером CX * 4 байта заполнена
; Модифицируются: DI,CX,EAX,EDX

build_table	proc	near
	mov	dword ptr [di+4],ebx ; заполнить второй элемент таблицы
	sub	cx,2			; два элемента уже заполнены
	add	di,8
	mov	eax,ebx
build_table_loop:
	imul	ebx			; умножить cos(span/steps) на cos(xk-1)
	shrd	eax,edx,23		; поправка из-за действий с фиксированной
; запятой 8:24 и умножение на 2
	sub	eax,dword ptr [di-8] ; вычитание cos(xk-2)
	stosd				; запись результата в таблицу
	loop	build_table_loop
	ret
build_table	endp

; процедура display_picture
; изображает точку со следом

display_picture	proc	near

	call	move_point	; переместить точку

	mov	bp,73h	; темно-серый цвет в нашей палитре
	mov	bx,3		; точка, выведенная три шага назад
	call	draw_point	; изобразить ее
	dec	bp		; 72h - серый цвет в нашей палитре
	dec	bx		; точка, выведенная два шага назад
	call	draw_point	; изобразить ее
	dec	bp		; 71h - светло-серый цвет в нашей палитре
	dec	bx		; точка, выведенная один шаг назад
	call	draw_point	; изобразить ее
	dec	bp		; 70h - белый цвет в нашей палитре 
	dec	bx		; текущая точка
	call	draw_point	; изобразить ее
	ret
display_picture	endp

; процедура draw_point
; Ввод: BP - цвет
; 	BX - сколько шагов назад выводилась точка
;
draw_point proc near
	movzx	cx,byte ptr point_x[bx] ; X-координата
	movzx	dx,byte ptr point_y[bx]	; Y-координата
	call	putpixel_13h	; вывод точки на экран
	ret
draw_point endp

; процедура move_point
; вычисляет координаты для следующей точки, изменяет координаты точек, 
; выведенных раньше

move_point proc near
	inc	word ptr time
	and	word ptr time,2047	; эти две команды организуют
; счетчик в переменной time, который 
; изменяется от 0 до 2047 (7FFh)

	mov	eax,dword ptr point_x	; считать координаты точек 
	mov	ebx,dword ptr point_y	; (по байту на точку)
	mov	dword ptr point_x[1],eax ; и записать их со сдвигом
	mov	dword ptr point_y[1],ebx ; 1 байт

	mov	di,word ptr time	; угол (или время) в DI
	imul	di,di,SCALE_H	; умножить его на SCALE_H
	and	di,2047		; остаток от деления на 2048
	shl	di,2			; так как в таблице 4 байта на косинус
	mov	ax,50			; масштаб по горизонтали
	mul	word ptr cos_table[di+2] ; Умножение на косинус. 
; Берется старшее слово (смещение + 2) от 
; косинуса, записанного в формате 8:24, 
; фактически происходит умножение на косинус в 
; формате 8:8
	mov	dx,0A000h	; 320/2 (X центра экрана) в формате 8:8
	sub	dx,ax		; расположить центр фигуры в центре экрана
	mov	byte ptr point_x,dh ; и записать новую текущую точку

	mov	di,word ptr time	; угол (или время) в DI 
	imul	di,di,SCALE_V	; умножить его на SCALE_V
	add	di,512		; добавить 90 градусов, чтобы заменить 
; косинус на синус. Так как у нас 2048
; шагов на 360 градусов, 90 градусов - это 
; 512 шагов
	and	di,2047		; остаток от деления на 2048,
	shl	di,2			; так как в таблице 4 байта на косинус
	mov	ax,50			; масштаб по вертикали
	mul	word ptr cos_table[di+2] ; умножение на косинус
	mov	dx,06400h	; 200/2 (Y центра экрана) в формате 8:8
	sub	dx,ax		; расположить центр фигуры в центре экрана
	mov	byte ptr point_y,dh ; и записать новую текущую точку
	ret
move_point endp

; putpixel_13h
; Процедура вывода точки на экран в режиме 13h
; DX = строка, CX = столбец, BP = цвет, ES = A000h
putpixel_13h	proc	near
	push	di
	mov	ax,dx	; номер строки
	shl	ax,8	; умножить на 256
	mov	di,dx
	shl	di,6	; умножить на 64
	add	di,ax	; и сложить - то же, что и умножение на 320
	add	di,cx	; добавить номер столбца
	mov	ax,bp
	stosb		; записать в видеопамять
	pop	di
	ret
putpixel_13h	endp

point_x	db	0FFh,0FFh,0FFh,0FFh ; X-координаты точки и хвоста
point_y	db	0FFh,0FFh,0FFh,0FFh ; Y-координаты точки и хвоста
	db	?	; пустой байт - нужен для команд сдвига координат 
			; на один байт
time	dw	0		; параметр в уравнениях Лиссажу - время или угол

palette	db	3Fh,3Fh,3Fh	; белый
	db	30h,30h,30h	; светло-серый
	db	20h,20h,20h	; серый
	db	10h,10h,10h	; темно-серый

cos_table	dd	1000000h ; здесь начинается таблица косинусов
	end	start
