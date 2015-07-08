; scrsvr.asm
; Пример простой задачи, реализующей нитевую многозадачность в DOS.
; Изображает на экране две змейки, двигающиеся случайным образом, каждой из 
; которых управляет своя нить.
;
; Передача управления между нитями не работает в окне DOS Windows 95
;
; Компиляция:
; TASM:
;  tasm /m scrsvr.asm
;  tlink /t /x scrsvr.obj
; MASM:
;  ml /c scrsvr.asm
;  link scrsvr.obj,,NUL,,,
;  exe2bin scrsvr.exe scrsvr.com
; WASM:
;  wasm scrsvr.asm
;  wlink file scrsvr.obj form DOS COM
;

	.model	tiny
	.code
	.386			; ГСЧ использует 32-битные регистры
	org	100h		; COM-программа
start:
	mov	ax,13h	; видеорежим 13h
	int	10h		; 320x200x256

	call	init_threads	; инициализировать наш диспетчер
; с этого места и до вызова shutdown_threads исполняются две нити с одним и тем 
; же кодом и данными, но с разными регистрами и стеками
; (в реальной системе здесь был бы вызов fork или аналогичной функции)

	mov	bx,1		; цвет (синий)

	push	bp
	mov	bp,sp		; поместить все локальные переменные в стек,
				; чтобы обеспечить повторную входимость
	push	1		; добавка к X на каждом шаге
x_inc		equ word ptr [bp-2]
	push	0		; добавка к Y на каждом шаге
y_inc		equ word ptr [bp-4]
	push	128-4		; относительный адрес головы буфера line_coords
coords_head	equ word ptr [bp-6]
	push	0		; относительный адрес хвоста буфера line_coords
coords_tail	equ word ptr [bp-8]
	sub	sp,64*2	; line_coords - кольцевой буфер координат точек
	mov	di,sp
	mov	cx,64
	mov	ax,10		; заполнить его координатами (10, 10)
	push	ds
	pop	es
	rep stosw
line_coords	equ word ptr [bp-(64*2)-8]

	push	0A000h
	pop	es		; ES - адрес видеопамяти

main_loop:		; основной цикл
	call display_line	; изобразить текущее состояние змейки

; изменить направление движения случайным образом
	push	bx
	mov	ebx,50	; вероятность смены направления 2/50
	call	z_random	; получить случайное число от 0 до 49
	mov	ax,word ptr x_inc
	mov	bx,word ptr y_inc
	test	dx,dx		; если это число - 0,
	jz	rot_right	; повернем направо,
	dec	dx		; а если 1 -
	jnz	exit_rot	; налево
; повороты
	neg	ax		; налево на 90 градусов
	xchg	ax,bx		; dY = -dX, dX = dY
	jmp short exit_rot
rot_right:
	neg	bx		; направо на 90 градусов
	xchg	ax,bx		; dY = dX, dX = dY
exit_rot:
	mov	word ptr x_inc,ax	; записать новые значения инкрементов
	mov	word ptr y_inc,bx
	pop	bx		; восстановить цвет в BX

; перемещение змейки на одну позицию вперед
	mov	di,word ptr coords_head	; DI - адрес головы
	mov	cx,word ptr line_coords[di]	; CX-строка
	mov	dx,word ptr line_coords[di+2]	; DX-столбец
	add	cx,word ptr y_inc		; добавить инкременты
	add	dx,word ptr x_inc
	add	di,4			; DI - следующая точка в буфере,
	and	di,127		; если DI > 128, DI = DI-128
	mov	word ptr coords_head,di	; теперь голова здесь
	mov	word ptr line_coords[di],cx	; записать ее координаты
	mov	word ptr line_coords[di+2],dx
	mov	di,word ptr coords_tail	; прочитать адрес хвоста
	add	di,4				; переместить его на одну
	and	di,127			; позицию вперед
	mov	word ptr coords_tail,di		; и записать на место

; пауза
; из-за особенностей нашего диспетчера (см. ниже) мы не можем пользоваться 
; прерыванием BIOS для паузы, поэтому сделаем просто пустой цикл. Длину цикла 
; придется изменить в зависимости от скорости процессора
	mov	cx,-1
	loop	$		; 65 535 команд loop
	mov	cx,-1
	loop	$
	mov	cx,-1
	loop	$

	mov	ah,1
	int	16h		; если не было нажато никакой клавиши, 
	jz	main_loop	; продолжить основной цикл,
	mov	ah,0		; иначе - прочитать клавишу
	int	16h
	leave			; освободить стек от локальных переменных
	call	shutdown_threads	; выключить многозадачность
; с этого момента у нас снова только один процесс
	mov	ax,3		; видеорежим 3
	int	10h		; 80x24
	int	20h		; конец программы

; процедура вывода точки на экран в режиме 13h
; CX = строка, DX = столбец, BL = цвет, ES = A000h
putpixel proc	near
	push	di
	lea	ecx,[ecx*4+ecx]	; CX = строка * 5
	shl	cx,6		; CX = строка * 5 * 64 = строка * 320
	add	dx,cx		; DX = строка * 320 + столбец = адрес
	mov	di,dx
	mov	al,bl
	stosb			; записать байт в видеопамять
	pop	di
	ret
putpixel endp

; процедура display_line
; выводит на экран нашу змейку по координатам из кольцевого буфера line_coords
display_line	proc near
	mov	di,word ptr coords_tail	; начать вывод с хвоста,
continue_line_display:
	cmp	di,word ptr coords_head	; если DI равен адресу головы,
	je	line_displayed		; вывод закончился,
	call	display_point		; иначе - вывести точку на экран
	add	di,4			; установить DI на следующую точку
	and	di,127
	jmp short continue_line_display ; и так далее
line_displayed:
	call	display_point
	mov	di,word ptr coords_tail	; вывести точку в хвосте
	push	bx
	mov	bx,0			; нулевым цветом,
	call	display_point	; то есть стереть
	pop	bx
	ret
display_line endp

; процедура display_point
; выводит точку из буфера line_coords с индексом DI
display_point	proc	near
	mov	cx,word ptr line_coords[di]	; строка
	mov	dx,word ptr line_coords[di+2]	; столбец
	call	putpixel			; вывод точки
	ret
display_point	endp

; процедура z_random
; стандартный конгруэнтный генератор случайных чисел (неоптимизированный)
; ввод: EBX - максимальное число
; вывод: EDX - число от 0 до EBX-1
z_random:
	push	ebx
	cmp	byte ptr zr_init_flag,0	; если еще не вызывали,
	je	zr_init			; инициализироваться,
	mov	eax,zr_prev_rand	; иначе - умножить предыдущее
zr_cont:
	mul	rnd_number		; на множитель
	div	rnd_number2		; и разделить на делитель,
	mov	zr_prev_rand,edx	; остаток от деления - новое число
	pop	ebx
	mov	eax,edx
	xor	edx,edx
	div	ebx			; разделить его на максимальное
	ret				; и вернуть остаток в EDX
zr_init:
	push	0040h			; инициализация генератора
	pop	fs			; 0040h:006Ch - 
	mov	eax,fs:[006Ch]	; счетчик прерываний таймера BIOS,
	mov	zr_prev_rand,eax	; он и будет первым случайным числом
	mov	byte ptr zr_init_flag,1
	jmp	zr_cont
rnd_number	dd	16807		; множитель
rnd_number2	dd	2147483647	; делитель
zr_init_flag	db	0	; флаг инициализации генератора
zr_prev_rand	dd	0	; предыдущее случайное число

; здесь начинается код диспетчера, обеспечивающего многозадачность

; структура данных, в которой мы храним регистры для каждой нити
thread_struc struc
_ax	dw	?
_bx	dw	?
_cx	dw	?
_dx	dw	?
_si	dw	?
_di	dw	?
_bp	dw	?
_sp	dw	?
_ip	dw	?
_flags	dw	?
thread_struc ends	

; процедура init_threads
; инициализирует обработчик прерывания 08h и заполняет структуры, описывающие
; обе нити
init_threads	proc	near
	pushf
	pusha
	push	es
	mov	ax,3508h		; AH = 35h, AL = номер прерывания
	int	21h			; определить адрес обработчика
	mov	word ptr old_int08h,bx	; сохранить его
	mov	word ptr old_int08h+2,es
	mov	ax,2508h		; AH = 25h, AL = номер прерывания
	mov	dx,offset int08h_handler	; установить наш
	int	21h
	pop	es
	popa		; теперь регистры те же, что и при вызове процедуры
	popf

	mov	thread1._ax,ax	; заполнить структуры
	mov	thread2._ax,ax	; thread1 и thread2,
	mov	thread1._bx,bx	; в которых хранится содержимое
	mov	thread2._bx,bx	; всех регистров (кроме сегментных -
	mov	thread1._cx,cx	; они в этом примере не изменяются)
	mov	thread2._cx,cx
	mov	thread1._dx,dx
	mov	thread2._dx,dx
	mov	thread1._si,si
	mov	thread2._si,si
	mov	thread1._di,di
	mov	thread2._di,di
	mov	thread1._bp,bp
	mov	thread2._bp,bp
	mov	thread1._sp,offset thread1_stack+512
	mov	thread2._sp,offset thread2_stack+512
	pop	ax		; адрес возврата (теперь стек пуст)
	mov	thread1._ip,ax
	mov	thread2._ip,ax
	pushf
	pop	ax		; флаги
	mov	thread1._flags,ax
	mov	thread2._flags,ax
	mov	sp,thread1._sp	; установить стек нити 1
	jmp	word ptr thread1._ip	; и передать ей управление
init_threads	endp

current_thread db 1		; номер текущей нити

; Обработчик прерывания INT08h (IRQ0)
; переключает нити
int08h_handler proc far
	pushf			; сначала вызвать старый обработчик
	db 9Ah		; код команды call far
old_int08h dd	0	; адрес старого обработчика
; Определить, произошло ли прерывание в момент исполнения нашей нити или 
; какого-то обработчика другого прерывания. Это важно, так как мы не собираемся 
; возвращать управление тому, кого прервал таймер, по крайней мере сейчас. 
; Именно поэтому нельзя пользоваться прерываниями для задержек в наших нитях и 
; поэтому программа не работает в окне DOS (Windows 95)
	mov	save_di,bp	; сохранить BP
	mov	bp,sp
	push	ax
	push	bx
	pushf
	mov	ax,word ptr [bp+2] ; прочитать сегментную часть 
	mov	bx,cs			; обратного адреса
	cmp	ax,bx		; сравнить ее с CS,
	jne	called_far	; если они не совпадают - выйти,
	popf
	pop	bx		; иначе - восстановить регистры
	pop	ax
	mov	bp,save_di

	mov	save_di,di	; сохранить DI, SI
	mov	save_si,si
	pushf			; и флаги
; определить, с какой нити на какую надо передать управление,
	cmp byte ptr current_thread,1 ; если с первой,
	je thread1_to_thread2		; перейти на thread1_to_thread2,
	mov byte ptr current_thread,1	; если с 2 на 1, записать в номер 1
	mov	si,offset thread1	; и установить SI и DI
	mov	di,offset thread2	; на соответствующие структуры,
	jmp short order_selected
thread1_to_thread2:			; если с 1 на 2,
	mov	byte ptr current_thread,2 ; записать в номер нити 2
	mov	si,offset thread2	; и установить SI и DI
	mov	di,offset thread1
order_selected:

; записать все текущие регистры в структуру по адресу [DI]
; и загрузить все регистры из структуры по адресу [SI]
; начать с SI и DI:
	mov	ax,[si]._si	; для MASM все выражения [reg]._reg надо
	push	save_si	; заменить на (thread_struc ptr [reg])._reg
	pop	[di]._si
	mov	save_si,ax
	mov	ax,[si]._di
	push	save_di
	pop	[di]._di
	mov	save_di,ax
; теперь все основные регистры
	mov	[di._ax],ax
	mov	ax,[si._ax]
	mov	[di._bx],bx
	mov	bx,[si._bx]
	mov	[di._cx],cx
	mov	cx,[si._cx]
	mov	[di._dx],dx
	mov	dx,[si._dx]
	mov	[di._bp],bp
	mov	bp,[si._bp]
; флаги
	pop	[di._flags]
	push	[si._flags]
	popf
; адрес возврата
	pop	[di._ip]	; адрес возврата из стека
	add	sp,4		; CS и флаги из стека - теперь он пуст
; переключить стеки
	mov	[di._sp],sp
	mov	sp,[si._sp]
	push	[si._ip]	; адрес возврата в стек (уже новый)
	mov	di,save_di	; загрузить DI и SI
	mov	si,save_si
	retn		; и перейти по адресу в стеке
; управление переходит сюда, если прерывание произошло в чужом коде
called_far:
	popf		; восстановить регистры
	pop	bx
	pop	ax
	mov	bp,save_di
	iret		; и завершить обработчик
int08h_handler endp

save_di	dw	?	; переменные для временного хранения
save_si	dw	?	; регистров

; процедура shutdown_threads
; выключает диспетчер
shutdown_threads proc near
	mov	ax,2508h	; достаточно просто восстановить прерывание
	lds	dx,dword ptr old_int08h
	int	21h
	ret
shutdown_threads endp

; структура, описывающая первую нить
thread1 thread_struc <>
; и вторую,
thread2 thread_struc <>
; стек первой нити
thread1_stack db 512 dup(?)
; и второй
thread2_stack db 512 dup(?)
end start
