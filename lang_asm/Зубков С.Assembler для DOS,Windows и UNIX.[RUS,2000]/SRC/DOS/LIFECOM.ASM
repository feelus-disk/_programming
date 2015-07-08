; lifecom.asm
; игра "жизнь" на поле 320x200, версия, компилирующаяся в COM-файл
; 
; Компиляция:
; TASM:
; tasm /m lifecom.asm
; tlink /t /x lifecom.obj
; MASM:
; ml /c lifecom.asm
; link lifecom.obj,,NUL,,,
; exe2bin lifecom.exe lifecom.com
; WASM:
; wasm lifecom.asm
; wlink file lifecom.obj form DOS COM
;
	.model tiny
	.code
	.186			; для команд shl al,4 и shr al,4
	org	100h
start:
	std			; строки будут обрабатываться от конца к началу
	int	1Ah		; функция AH=0 INT 1Ah - получить текущее время.
	mov	di,320*200+1	; число точек экрана
fill_buffer:
	imul	dx,4E35h	; простой генератор случайных чисел
	inc	dx
	mov	ax,dx		; текущее число копируется в AX
	shr	ax,15		; от него оставляется только один бит
	mov	byte ptr [di+buffer],al	; который копируется в массив
	dec	di		; следующая ячейка
	jnz	fill_buffer	; если di не стал равен нулю - продолжить цикл

	mov	ax,0013h	; графический режим 320x200 (256 цветов)
	int	10h

;
; основной цикл
;

new_cycle:
;
; шаг 1: для каждой ячейки вычисляется число соседей и записывается в 
; старшие четыре бита этой ячейки
;
	mov	di,320*200+1		; цикл от 320*200+1 до 1
step_1:
	mov	al,byte ptr [di+1+buffer]	; сумма значений восьми соседних
	add	al,byte ptr [di-1+buffer]	; ячеек вычисляется в AL:
	add	al,byte ptr [di+319+buffer]	; младшие четыре бита ячейки равны
	add	al,byte ptr [di-319+buffer]	; 00 если ячейка пуста и 01 если
	add	al,byte ptr [di+320+buffer]	; она не пуста. Старшие четыре бита
	add	al,byte ptr [di-320+buffer]	; предыдущих ячеек содержат числа 
	add	al,byte ptr [di+321+buffer]	; соседей, полученные в предыдущих
	add	al,byte ptr [di-321+buffer]	; проходах этого цикла, но они не влияют
					; на сумму соседей, накапливающуюся в
					; младших четырёх битах AL
	shl	al,4			; теперь старшие четыре бита AL - 
					; число соседей текущей ячейки
	or	byte ptr [di+buffer],al	; поместить их в старшие четыре бита
					; ячейки в массиве
	dec	di			; следующая ячейка
	jnz	step_1			; если di не стал равен нулю - продолжить цикл

;
; шаг 2: изменение состояния ячеек в соответствии с полученными в шаге 1
; числами соседей
;

	mov	di,320*200+1		; цикл от 320x200+1 до 1
flip_cycle:
	mov	al,byte ptr [di+buffer]	; считать ячейку из массива
	shr	al,4			; AL = число соседей
	cmp	al,3			; если число соседей = 3
	je	birth			; появляется новая точка
	cmp	al,2			; если число соседей = 2
	je	f_c_continue		; ячейка не изменяется
	mov	byte ptr [di+buffer],0		; иначе ячейка погибает
	jmp	short f_c_continue
birth:	mov	byte ptr [di+buffer],1
f_c_continue:
	and	byte ptr [di+buffer],0Fh	; обнулить сумму соседей в старших
					; битах ячейки
	dec	di			; следующая ячейка
	jnz	flip_cycle		

;
; Вывод массива на экран прямым копированием в видеопамять

	push	0A000h			; адрес видеопамяти
	pop	es			; в ES
	mov	cx,320*200		; число ячеек
	mov	di,cx			; стартовый адрес в видеопамяти 320*200
	mov	si,cx			; стартовый адрес в массиве -
	inc	si			; 320*200+1
	add	si,offset buffer	; + начало буфера
	rep movsb			; выполнить копирование

	mov	ah,1			; если не нажата клавиша
	int	16h
	jz	new_cycle		; следующий шаг жизни

	mov	ax,0003h		; иначе: восстановить текстовый режим
	int	10h
	ret				; и завершить программу

buffer:					; начало буфера
	end start
