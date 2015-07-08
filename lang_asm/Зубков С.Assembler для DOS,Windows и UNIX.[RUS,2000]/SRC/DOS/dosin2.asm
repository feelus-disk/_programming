; dosin2.asm
; Изображает пентамино F, которое можно перемещать по экрану клавишами 
; управления курсором и вращать клавишами X и Z. Выход из программы - Esc.
;
; Компиляция:
; TASM:
; tasm /m dosin2.asm
; tlink /t /x dosin2.obj
; MASM:
; ml /c dosin2.asm
; link dosin2.obj,,NUL,,,
; exe2bin dosin2.exe dosin2.com
; WASM
; wasm dosin2.asm
; wlink file dosin2.obj form DOS COM
;


line_length = 7		; число символов в строке изображения
number_of_lines = 4	; число строк

	.model	tiny
	.code
	org	100h	; начало COM-файла
start:
	cld		; будут использоваться команды строковой обработки
	mov	ax,0B800h	; адрес начала текстовой видеопамяти
	mov	es,ax		; в ES
	mov	ax,0003h
	int	10h		; текстовый режим 03 (80x25)
	mov	ah,02h		; установить курсор
	mov	bh,0
	mov	dh,26		; на строку 26, то есть за пределы экрана
	mov	dl,1
	int	10h		; теперь курсора на экране нет

	call	update_screen	; вывести изображение

; основной цикл опроса клавиатуры
main_loop:
	mov	ah,08h	; считать символ с клавиатуры
	int	21h		; без эха, с ожиданием, с проверкой на Ctrl-Break
	test	al,al		; если AL = 0
	jz	eASCII_entered	; введен символ расширенного ASCII
	cmp	al,1Bh		; иначе: если введен символ 1Bh (Esc),
	je	key_ESC		; выйти из программы,
	cmp	al,'Z'		; если введен символ Z,
	je	key_Z			; перейти на его обработчик
	cmp	al,'z'		; то же для z
	je	key_Z
	cmp	al,'X'		; если введен символ X,
	je	key_X		; перейти на его обработчик
	cmp	al,'x'		; то же для x
	je	key_X
	jmp short main_loop	; считать следующую клавишу

eASCII_entered:		; был введен расширенный ASCII-символ
	int	21h		; получить его код (повторный вызов функции)
	cmp	al,48h	; стрелка вверх
	je	key_UP
	cmp	al,50h	; стрелка вниз
	je	key_DOWN
	cmp	al,4Bh	; стрелка влево
	je	key_LEFT
	cmp	al,4Dh	; стрелка вправо
	je	key_RIGHT
	jmp short main_loop	; считать следующую клавишу
;
; обработчики нажатий клавиш
;
key_ESC:			; Esc
	ret				; завершить COM-программу
key_UP:			; стрелка вверх
	cmp	byte ptr start_row,0	; если изображение на верхнем
					; краю экрана,
	jna	main_loop		; считать следующую клавишу,
	dec	byte ptr start_row ; иначе - уменьшить номер строки,
	call	update_screen	; вывести новое изображение
	jmp short main_loop	; и считать следующую клавишу

key_DOWN:			; стрелка вниз
	cmp	byte ptr start_row,25-number_of_lines ; если 
					; изображение на нижнем краю экрана,
	jnb	main_loop		; считать следующую клавишу,
	inc	byte ptr start_row ; иначе - увеличить номер строки,
	call	update_screen	; вывести новое изображение
	jmp short main_loop	; и считать следующую клавишу

key_LEFT:		; стрелка влево
	cmp	byte ptr start_col,0	; если изображение на левом краю 
					; экрана,
	jna	main_loop	; считать следующую клавишу,
	dec	byte ptr start_col	; иначе - уменьшить номер, столбца
	call	update_screen	; вывести новое изображение
	jmp short main_loop	; и считать следующую клавишу

key_RIGHT:		; стрелка вправо
	cmp	byte ptr start_col,80-line_length ; если
				; изображение на правом краю экрана,
	jnb	main_loop	; считать следующую клавишу,
	inc	byte ptr start_col	; иначе - увеличить номер столбца
	call	update_screen	; вывести новое изображение
	jmp short main_loop	; и считать следующую клавишу

key_Z:			; клавиша Z (вращение влево)
	mov	ax,current_screen ; считать номер текущего изображения
				; (значения 0, 1, 2, 3),
	dec	ax		; уменьшить его на 1,
	jns	key_Z_ok	; если получился -1 (поменялся знак),
	mov	ax,3		; AX = 3
key_Z_ok:
	mov	current_screen,ax ; записать номер обратно,
	call	update_screen	; вывести новое изображение
	jmp	main_loop		; и считать следующую клавишу
key_X:			; клавиша X (вращение вправо)
	mov	ax,current_screen ; считать номер текущего изображения
				; (значения 0, 1, 2, 3),
	inc	ax		; увеличить его на 1,
	cmp	ax,4		; если номер стал равен 4,
	jne	key_X_ok
	xor	ax,ax		; AX = 0
key_X_ok:
	mov	current_screen,ax ; записать номер обратно,
	call	update_screen	; вывести новое изображение
	jmp	main_loop		; и считать следующую клавишу


; процедура update_screen
; очищает экран и выводит текущее изображение
; модифицирует значения регистров AX, BX, CX, DX, SI, DI
update_screen:
	mov	cx,25*80	; число символов на экране
	mov	ax,0F20h	; символ 20h (пробел) с атрибутом 0Fh
				; (белый на черном)
	xor	di,di		; ES:DI = начало видеопамяти
	rep stosw		; очистить экран

	mov	bx,current_screen	; номер текущего изображения в BX
	shl	bx,1		; умножить на 2, так как screens - массив слов
	mov	si,screens[bx]	; поместить в BX смещение начала
				; текущего изображения из массива 
				; screens,
	mov	ax,start_row	; вычислить адрес начала
	mul	row_length		; изображения в видеопамяти
	add	ax,start_col	; (строка * 80 + столбец) * 2
	shl	ax,1
	mov	di,ax		; ES:DI - начало изображения в 
				; видеопамяти
	mov	ah,0Fh		; используемый атрибут - белый на черном
	mov	dx,number_of_lines ; число строк в изображении
copy_lines:
	mov	cx,line_length	; число символов в строке
copy_1: lodsb			; считать ASCII-код в AL,
	stosw			; записать его в видеопамять
				; (AL - ASCII, AH - атрибут),
	loop	copy_1		; вывести так все символы в строке,
	add	di,(80-line_length)*2 ; перевести DI на начало
				; следующей строки экрана,
	dec	dx			; если строки не закончились -
	jnz	copy_lines		; вывести следующую

	ret				; конец процедуры update_screen

; изображение пентамино F
screen1	db	'  ╔═══╗'	; выводимое изображение
	db	'╔═╝ ╔═╝'
	db	'╚═╗ ║  '
	db	'  ╚═╝  '
screen2	db	'  ╔═╗  '	; поворот на 90 градусов вправо
	db	'╔═╝ ╚═╗'
	db	'╚═══╗ ║'
	db	'    ╚═╝'
screen3	db	'  ╔═╗  '	; поворот на 180 градусов
	db	'  ║ ╚═╗'
	db	'╔═╝ ╔═╝'
	db	'╚═══╝  '
screen4	db	'╔═╗    '	; поворот на 90 градусов влево
	db	'║ ╚═══╗'
	db	'╚═╗ ╔═╝'
	db	'  ╚═╝  '
; массив, содержащий адреса всех вариантов изображения
screens	dw	screen1,screen2,screen3,screen4
current_screen	dw	0	; текущий вариант изображения
start_row	dw	10	; текущая верхняя строка изображения
start_col	dw	37	; текущий левый столбец
row_length	db	80	; длина строки экрана для команды MUL

	end	start
