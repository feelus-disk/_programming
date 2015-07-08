; scrolls.asm
; Изображает в разрешении 1024x768x64Кб окрашенный конус, который можно 
; плавно перемещать по экрану стрелками вверх и вниз.
;
; Компиляция:
; TASM:
;  tasm /m scrolls.asm
;  tlink /t /x scrolls.obj
; MASM:
;  ml /c scrolls.asm
;  link scrolls.obj,,NUL,,,
;  exe2bin scrolls.exe scrolls.com
; WASM:
;  wasm scrolls.asm
;  wlink file scrolls.obj form DOS COM
;
 
	.model	tiny
	.code
	.386		; используется команда shrd
	org	100h	; COM-файл
start:
	mov	ax,4F01h	; получить информацию о видеорежиме
	mov	cx,116h	; 1024x768 64Кб
	mov	di,offset vbe_mode_buffer
	int	10h
; здесь для простоты опущена проверка наличия режима
	mov	ax,4F02h	; установить режим
	mov	bx,116h
	int	10h
	push	word ptr [vbe_mode_buffer+8]
	pop	es		; поместить в ES адрес начала видеопамяти 
				; (обычно A000h)
	cld

; вывод конуса на экран

	mov	cx,-1		; начальное значение цвета (белый)
	mov	si,100	; начальный радиус
	mov	bx,300	; номер столбца
	mov	ax,200	; номер строки
main_loop:
	inc	si			; увеличить радиус круга на 1
	inc	ax			; увеличить номер строки
	inc	bx			; увеличить номер столбца
	call	fast_circle		; нарисовать круг
	sub	cx,0000100000100001b	; изменить цвет
	cmp	si,350		; если еще не нарисовано 250 кругов
	jb	main_loop		; продолжить
	xor	cx,cx		; иначе: выбрать черный цвет
	call	fast_circle	; нарисовать последний круг

; плавное перемещение изображения по экрану с помощью функции 4F07

	xor	bx,bx		; BX = 0 - установить начало экрана
	xor	dx,dx		; номер строки = 0
				; номер столбца в CX уже ноль
main_loop_2:
	mov	ax,4F07h
	int	10h		; переместить начало экрана
	mov	ah,7		; считать нажатую клавишу с ожиданием, без эха и 
	int	21h		; без проверки на Ctrl-Break,
	test	al,al		; если это обычная клавиша -
	jnz	exit_loop_2	; завершить программу,
	int	21h		; иначе: получить расширенный ASCII-код,
	cmp	al,50h	; если это стрелка вниз
	je	key_down
	cmp	al,48h	; или вверх - вызвать обработчик,
	je	key_up
exit_loop_2:			; иначе - завершить программу
	mov	ax,3		; текстовый режим
	int	10h
	ret			; завершить COM-программу

key_down:			; обработчик нажатия стрелки вниз
	dec	dx		; уменьшить номер строки начала экрана,
	jns	main_loop_2	; если знак не изменился - продолжить цикл,
; иначе (если номер был 0, а стал -1) - увеличить
; номер строки
key_up:		; обработчик нажатия стрелки вверх
	inc	dx		; увеличить номер строки начала экрана
	jmp short main_loop_2

; Процедура вывода точки на экран в 16-битном видеорежиме
; Ввод: DX = номер строки, BX = номер столбца, ES = A000, CX = цвет
; модифицирует AX
putpixel16b:
	push	dx
	push	di
	xor	di,di
	shrd	di,dx,6	; DI = номер строки * 1024 mod 65 536
	shr	dx,5		; DX = номер строки / 1024 * 2
	inc	dx
	cmp	dx,current_bank	; если номер банка для выводимой точки
	jne	bank_switch	; отличается то текущего - переключить банки
switched:
	add	di,bx		; добавить к DI номер столбца
	mov	ax,cx		; цвет в AX
	shl	di,1		; DI = DI * 2, так как адресация идет в словах
	stosw			; вывести точку на экран
	pop	di		; восстановить регистры
	pop	dx
	ret
bank_switch:		; переключение банка
	push	bx
	xor	bx,bx		; BX = 0 -> Установить начало экрана
	mov	current_bank,dx	; сохранить новый номер текущего банка
	call	dword ptr [vbe_mode_buffer+0Ch]	; переключить 
; банк
	pop	bx
	jmp	short switched

; Алгоритм рисования круга, используя только сложение, вычитание и сдвиги.
; (упрощенный алгоритм промежуточной точки)
; Ввод: SI = радиус, CX = цвет, AX = номер столбца центра круга, BX = номер строки
; центра круга
; модифицирует DI, DX
fast_circle:
	push	si
	push	ax
	push	bx
	xor	di,di		; DI - относительная X-координата текущей точки
	dec	di		; (SI - относительная Y-координата, начальное 
	mov	ax,1		; значение - радиус)
	sub	ax,si		; AX - наклон (начальное значение 1-Радиус)
circle_loop:
	inc	di		; следующий X (начальное значение - 0)
	cmp	di,si		; цикл продолжается, пока X < Y
	ja	exit_main_loop

	pop	bx		; BX = номер строки центра круга
	pop	dx		; DX = номер столбца центра круга
	push	dx
	push	bx

	push	ax		; сохранить AX (putpixel16b его изменяет)
	add	bx,di		; вывод восьми точек на окружности:
	add	dx,si
	call	putpixel16b	; центр_X + X, центр_Y + Y
	sub	dx,si
	sub	dx,si
	call	putpixel16b	; центр_X + X, центр_Y - Y
	sub	bx,di
	sub	bx,di
	call	putpixel16b	; центр_X - X, центр_Y - Y
	add	dx,si
	add	dx,si
	call	putpixel16b	; центр_X - X, центр_Y + Y
	sub	dx,si
	add	dx,di
	add	bx,di
	add	bx,si
	call	putpixel16b	; центр_X + Y, центр_Y + X
	sub	dx,di
	sub	dx,di
	call	putpixel16b	; центр_X + X, центр_Y - X
	sub	bx,si
	sub	bx,si
	call	putpixel16b	; центр_X - Y, центр_Y - X
	add	dx,di
	add	dx,di
	call	putpixel16b	; центр_X - Y, центр_Y + X
	pop	ax

	test	ax,ax		; если наклон положительный
	js	slop_negative
	mov	dx,di
	sub	dx,si
	shl	dx,1
	inc	dx
	add	ax,dx		; наклон  = наклон + 2(X - Y) + 1
	dec	si		; Y = Y - 1
	jmp	circle_loop
slop_negative:		; если наклон отрицательный
	mov	dx,di
	shl	dx,1
	inc	dx
	add	ax,dx		; наклон = наклон + 2X + 1
	jmp	circle_loop	; и Y не изменяется
exit_main_loop:
	pop	bx
	pop	ax
	pop	si
	ret

current_bank	dw	0	; номер текущего банка
vbe_mode_buffer:		; начало буфера данных о видеорежиме
	end	start

