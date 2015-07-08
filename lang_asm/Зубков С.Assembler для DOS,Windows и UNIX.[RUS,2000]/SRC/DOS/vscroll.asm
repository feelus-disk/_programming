; vscroll.asm
; Плавная прокрутка экрана по вертикали. Выход - клавиша Esc
;
; Компиляция:
; TASM:
;  tasm /m vscroll.asm
;  tlink /t /x vscroll.obj
; MASM:
;  ml /c vscroll.asm
;  link vscroll.obj,,NUL,,,
;  exe2bin vscroll.exe vscroll.com
; WASM:
;  wasm vscroll.asm
;  wlink file vscroll.obj form DOS COM
;

	.model	tiny
	.code
	.186		; для push 0B400h
	org 100h	; COM-программа
start: 
	push	0B800h
	pop	es 
	xor	si,si		; ES:SI - начало видеопамяти
	mov	di,80*25*2	; ES:DI - начало второй страницы видеопамяти
	mov	cx,di 
	rep movs es:any_label,es:any_label	; скопировать первую 
						; страницу во вторую
	mov	dx,03D4h 	; порт 03D4h: индекс CRT
screen_loop:	; цикл по экранам
	mov	cx,80*12*2	; CX = начальный адрес - адрес середины экрана
line_loop:		; цикл по строкам
	mov	al,0Ch	; регистр 0Ch - старший байт начального адреса
	mov	ah,ch		; байт данных - CH
	out	dx,ax		; вывод в порты 03D4, 03D5
	inc	ax		; регистр 0Dh - младший байт начального адреса
	mov	ah,cl 	; байт данных - CL
	out	dx,ax		; вывод в порты 03D4, 03D5

	mov	bx,15		; счетчик линий в строке
	sub	cx,80		; переместить начальный адрес на начало 
				; предыдущей строки (так как это движение вниз)
pel_loop:	; цикл по линиям в строке
	call	wait_retrace	; подождать обратного хода луча

	mov	al,8		; регистр 08h - выбор номера линии в первой 
				; строке, с которой начинается вывод изображения 
	mov	ah,bl		; (номер линии из BL)
	out	dx,ax

	dec	bx		; уменьшить число линий,
	jge	pel_loop	; если больше или = нулю - строка еще не 
				; прокрутилась до конца и цикл по линиям продолжается

	in	al,60h	; прочитать скан-код последнего символа,
	cmp	al,81h 	; если это 81h (отпускание клавиши Esc),
	jz	done		; выйти из программы,

	cmp	cx,0		; если еще не прокрутился целый экран,
	jge	line_loop	; продолжить цикл по строкам,
	jmp short screen_loop	; иначе: продолжить цикл по экранам

done:				; выход из программы
	mov	ax,8		; записать в регистр CRT 08h
	out	dx,ax		; байт 00 (никакого сдвига по вертикали),
	add	ax,4		; а также 00 в регистр 0Ch
	out	dx,ax
	inc	ax		; и 0Dh (начальный адрес совпадает с
	out	dx,ax		; началом видеопамяти)
	ret

wait_retrace	proc	near
	push	dx
	mov	dx,03DAh 
VRTL1:	in	al,dx		; порт 03DAh - регистр ISR1
	test	al,8
	jnz	VRTL1		; подождать конца текущего обратного хода луча,
VRTL2:	in	al,dx
	test	al,8
	jz	VRTL2		; а теперь начала следующего
	pop	dx
	ret
wait_retrace endp
any_label label byte	; метка для переопределения сегмента в movs
	end	start
