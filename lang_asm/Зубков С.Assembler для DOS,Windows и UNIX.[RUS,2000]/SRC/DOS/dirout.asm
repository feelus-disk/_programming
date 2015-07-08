; dirout.asm
; Выводит на экран все ASCII-символы без исключения,
; используя прямой вывод на экран
;
; Компиляция:
; TASM:
; tasm /m dirout.asm
; tlink /t /x dirout.obj
; MASM:
; ml /c dirout.asm
; link dirout.obj,,NUL,,,
; exe2bin dirout.exe dirout.com
; WASM
; wasm dirout.asm
; wlink file dirout.obj form DOS COM
;

		.model	tiny
		.code
		.386		; будет использоваться регистр EAX и команда STOSD
		org	100h	; начало COM-файла
start:
		mov	ax,0003h
		int	10h		; видеорежим 3 (очистка экрана)
		cld			; обработка строк в прямом направлении
					; подготовка данных для вывода на экран
		mov	eax,1F201F00h	; первый символ 00 с атрибутом 1Fh,
					; затем пробел (20h) с атрибутом 1Fh
		mov	bx,0F20h	; пробел с атрибутом 0Fh
		mov	cx,255		; число символов минус 1
		mov	di,offset ctable	; ES:DI - начало таблицы
cloop:
		stosd			; записать символ и пробел в таблицу ctable
		inc	al		; AL содержит следующий символ

		test	cx,0Fh		; если CX не кратен 16,
		jnz	continue_loop	; продолжить цикл,
		push	cx		; иначе: сохранить значение счетчика
		mov	cx,80-32	; число оставшихся до конца строки символов
		xchg	ax,bx
		rep	stosw		; заполнить остаток строки пробелами
					; с атрибутом 0F
		xchg	bx,ax		; восстановить значение EAX
		pop	cx		; восстановить значение счетчика
continue_loop:
		loop	cloop

		stosd			; записать последний (256-й) символ и пробел

; собственно вывод на экран
		mov	ax,0B800h	; сегментный адрес видеопамяти
		mov	es,ax
		xor	di,di		; DI = 0, адрес начала видеопамяти в ES:DI
		mov	si,offset ctable ; адрес таблицы в DS:SI
		mov	cx,15*80+32	; 15 строк по 80 символов, последняя строка - 32
		rep	movsw		; скопировать таблицу ctable в видеопамять
		ret			; завершение COM-файла

ctable:				; Данные для вывода на экран начинаются сразу
				; за концом файла. В EXE-файле такие данные
				; определяют в сегменте .data?
	end	start
