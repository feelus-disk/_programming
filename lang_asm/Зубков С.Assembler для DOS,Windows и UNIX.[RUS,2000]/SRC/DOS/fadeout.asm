; fadeout.asm
; выполняет плавное гашение экрана
;
; Компиляция:
; TASM:
; tasm /m fadeout.asm
; tlink /t /x fadeout.obj
; MASM:
; ml /c fadeout.asm
; link fadeout.obj,,NUL,,,
; exe2bin fadeout.exe fadeout.com
; WASM:
; wasm fadeout.asm
; wlink file fadeout.obj form DOS COM
;


	.model tiny
	.code
	.186			; для команд insb/outsb
	org	100h		; COM-программа
start:
	cld			; для команд строковой обработки
	mov	di,offset palettes
	call	read_palette	; сохранить текущую палитру, чтобы 
				; восстановить в самом конце программы,
	mov	di,offset palettes+256*3
	call	read_palette	; а также записать еще одну копию 
				; текущей палитры, которую будем 
				; модифицировать

	mov	cx,64	; счетчик цикла изменения палитры
main_loop:
	push	cx
	call	wait_retrace	; подождать начала обратного хода луча
	mov	di,offset palettes+256*3
	mov	si,di
	call	dec_palette	; уменьшить яркость всех цветов
	call	wait_retrace	; подождать начала следующего 
	mov	si,offset palettes+256*3	; обратного хода луча
	call	write_palette	; записать новую палитру
	pop	cx
	loop	main_loop	; цикл выполняется 64 раза - достаточно для 
; обнуления самого яркого цвета (максимальное 
; значение 6-битной компоненты - 63)
	mov	si,offset palettes
	call	write_palette	; восстановить первоначальную палитру
	ret			; конец программы

; процедура read_palette
; помещает палитру VGA в строку по адресу ES:DI
read_palette	proc	near
	mov	dx,03C7h	; порт 03C7h - индекс DAC/режим чтения
	mov	al,0		; начинать с нулевого цвета
	out	dx,al
	mov	dl,0C9h		; порт 03C9h - данные DAC
	mov	cx,256*3	; прочитать 256 * 3 байта
	rep insb		; в строку по адресу ES:DI
	ret
read_palette	endp

; процедура write_palette
; загружает в DAC VGA палитру из строки по адресу DS:SI
write_palette	proc	near
	mov	dx,03C8h	; порт 03C8h - индекс DAC/режим записи
	mov	al,0		; начинать с нулевого цвета
	out	dx,al
	mov	dl,0C9h		; порт 03C9h - данные DAC
	mov	cx,256*3	; запишем 256 * 3 байта
	rep outsb		; из строки в DS:SI
	ret
write_palette	endp

; процедура dec_palette
; уменьшает значение каждого байта на 1 с насыщением (то есть, после того как 
; байт становится равен нулю, он больше не уменьшается) из строки в DS:SI и 
; записывает результат в строку в DS:SI

dec_palette	proc	near
	mov	cx,256*3	; длина строки 256 * 3 байта
dec_loop:
	lodsb			; прочитать байт,
	test	al,al		; если он ноль,
	jz	already_zero	; пропустить следующую команду
	dec	ax		; уменьшить байт на 1
already_zero:
	stosb			; записать его обратно
	loop	dec_loop	; повторить 256 * 3 раза
	ret
dec_palette	endp

; процедура wait_retrace
; ожидание начала следующего обратного хода луча
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

palettes:			; за концом программы мы храним две копии 
				; палитры - всего 1,5 Kб
end start
