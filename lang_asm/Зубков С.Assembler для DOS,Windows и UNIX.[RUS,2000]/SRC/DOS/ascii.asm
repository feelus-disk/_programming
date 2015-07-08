; ascii.asm
; Резидентная программа для просмотра и ввода ASCII-символов
; HCI:
;	Alt-A - активация программы
;	Клавиши управления курсором - выбор символа
;	Enter - выход из программы с вводом символа
;	Esc - выход из программы без ввода символа
; API:
;	Программа занимает первую свободную функцию прерывания 2Dh
;	в соответствии со спецификацией AMIS 3.6
;	Поддерживаются функции AMIS 00h, 02h, 03h, 04h и 05h
;	Обработчики прерываний построены в соответствии с IMB ISP
;
; Компиляция:
; TASM:
; tasm /m ascii.asm
; tlink /t /x ascii.obj
; MASM:
; ml /c ascii.asm
; link ascii.obj,,NUL,,,
; exe2bin ascii.exe ascii.com
; WASM:
; wasm ascii.asm
; wlink file ascii.obj form DOS COM

; адрес верхнего левого угла окна (23-я позиция в третьей строке)
START_POSITION	equ (80*2+23)*2

		.model	tiny
		.code
		.186			; для сдвигов и команд pusha/popa
		org	2Ch
envseg		dw	?		; сегментный адрес окружения DOS
		org	100h		; начало COM-программы

start:
		jmp	initialize	; переход на инициализирующую часть

hw_reset9:	retf			; ISP: минимальный hw_reset
;
; Обработчик прерывания 09h (IRQ1)
;
int09h_handler	proc	far
		jmp short actual_int09h_handler; ISP: пропустить блок
old_int09h	dd	?			; ISP: старый обработчик
		dw	424Bh			; ISP: сигнатура
		db	00h			; ISP: вторичный обработчик
		jmp short hw_reset9		; ISP: ближний jmp на hw_reset
		db	7 dup (0)		; ISP: зарезервировано
actual_int09h_handler:	; начало обработчика INT 09h

; Сначала вызовем предыдущий обработчик, чтобы дать BIOS возможность 
; обработать прерывание и, если это бело нажатие клавиши, поместить код в 
; клавиатурный буфер, так как мы пока не умеем работать с портами клавиатуры и 
; контроллера прерываний
		pushf
		call	dword ptr cs:old_int09h

; По этому адресу обработчик INT 2Dh запишет код команды IRET для дезактивации 
; программы
disable_point	label byte

		pusha		; это аппаратное прерывание - надо
		push	ds	; сохранить все регистры
		push	es
		cld		; для команд строковой обработки

		push	0B800h
		pop	es	; ES = сегментный адрес видеопамяти
		push	0040h
		pop	ds	; DS = сегментный адрес области данных BIOS
		mov	di,word ptr ds:001Ah	; адрес головы буфера 
					; клавиатуры
		cmp	di,word ptr ds:001Ch ; если он равен адресу хвоста,
		je	exit_09h_handler	; буфер пуст, и нам делать нечего
		; (например, если прерывание пришло по отпусканию клавиши),

		mov	ax,word ptr [di]	; иначе: считать символ из головы 
						; буфера

		cmp	byte ptr cs:we_are_active,0 ; если программа 
						; уже активирована - 
		jne	already_active ; перейти к обработке стрелок и т. п.

		cmp	ah,1Eh		; если прочитанная клавиша не A
		jne	exit_09h_handler	; (скан код 1Eh) - выйти,

		mov	al,byte ptr ds:0017h ; иначе: считать байт 
						; состояния клавиатуры,
		test	al,08h		; если не нажата любая Alt,
		jz	exit_09h_handler	; выйти,

		mov	word ptr ds:001Ch,di ; иначе: установить адреса
					; головы и хвоста буфера одинаковыми,
					; пометив его тем самым как пустой

		call	save_screen	; сохранить область экрана, которую 
					; накроет всплывающее окно
		push	cs
		pop	ds		; DS = наш сегментный адрес
		call	display_all	; вывести на экран окно программы

		mov	byte ptr we_are_active,1 ; установить флаг
		jmp short exit_09h_handler ; и выйти из обработчика

; Сюда передается управление, если программа уже активирована.
; При этом ES = B800h, DS = 0040h, DI = адрес головы буфера клавиатуры,
; AX = символ из головы буфера
already_active:
		mov	word ptr ds:001Ch,di ; установить адреса
					; головы и хвоста буфера одинаковыми,
					; пометив его тем самым как пустой
		push	cs
		pop	ds		; DS = наш сегментный адрес

		mov	al,ah	; команды cmp al, ? короче команд cmp ah, ?
		mov	bh,byte ptr current_char ; номер выделенного в 
				; данный момент ASCII-символа,
		cmp	al,48h	; если нажата стрелка вверх (скан-код 48h),
		jne	not_up
		sub	bh,16		; уменьшить номер символа на 16,
not_up:		cmp	al,50h		; если нажата стрелка вниз (скан-код 50h),
		jne	not_down
		add	bh,16		; увеличить номер символа на 16,
not_down:	cmp	al,4Bh		; если нажата стрелка влево,
		jne	not_left
		dec	bh		; уменьшить номер символа на 1,
not_left:	cmp	al,4Dh		; если нажата стрелка вправо,
		jne 	not_right
		inc	bh		; увеличить номер символа на 1,
not_right:	cmp	al,1Ch		; если нажата Enter (скан-код 1Ch),
		je	enter_pressed	; перейти к его обработчику
		dec	al		; Если не нажата клавиша Esc (скан-код 1),
		jnz	exit_with_display ; выйти из обработчика, оставив 
					; окно нашей программы на экране,
exit_after_enter:			; иначе:
		call	restore_screen	; убрать наше окно с экрана,
		mov	byte ptr we_are_active,0 ; обнулить флаг 
						; активности,
		jmp	short exit_09h_handler	; выйти из обработчика
 
exit_with_display:			; выход с сохранением окна (после 
					; нажатия стрелок)
		mov	byte ptr current_char,bh ; записать новое 
					; значение текущего символа
		call	display_all	; перерисовать окно

exit_09h_handler:		; выход из обработчика INT 09h
		pop	es
		pop	ds	; восстановить регистры
		popa
		iret		; и вернуться в прерванную программу

we_are_active	db	0	; флаг активности: равен 1, если
				; программа активна
current_char	db	37h	; номер ASCII-символа, выделенного в 
				; данный момент

; сюда передается управление, если в активном состоянии была нажата Enter
enter_pressed:
		mov	ah,05h		; Функция 05h
		mov	ch,0		; CH = 0
		mov	cl,byte ptr current_char ; CL = ASCII-код
		int	16h		; поместить символ в буфер клавиатуры
		jmp short exit_after_enter ; выйти из обработчика, 
					; стерев окно

; процедура save_screen
; сохраняет в буфере screen_buffer содержимое области экрана, которую закроет 
; наше окно

save_screen	proc	near
		mov	si,START_POSITION
		push	0B800h		; DS:SI - начало этой области в 
		pop	ds		; видеопамяти
		push	es
		push	cs
		pop	es
		mov	di,offset screen_buffer	; ES:DI - начало буфера в 
						; программе
		mov	dx,18		; DX = счетчик строк
save_screen_loop:
		mov	cx,33		; CX = счетчик символов в строке
		rep movsw		; скопировать строку с экрана в буфер
		add	si,(80-33)*2 ; увеличить SI до начала следующей 
					; строки
		dec	dx		; уменьшить счетчик строк,
		jnz	save_screen_loop ; если он не ноль - продолжить 
		pop	es		; цикл
		ret
save_screen	endp

; процедура restore_screen
; восстанавливает содержимое области экрана, которую закрывало наше 
; всплывающее окно данными из буфера screen_buffer

restore_screen	proc	near
						; ES:DI - начало области
		mov	di,START_POSITION	; в видеопамяти
		mov	si,offset screen_buffer	; DS:SI - начало буфера
		mov	dx,18			; счетчик строк
restore_screen_loop:
		mov	cx,33		; счетчик символов в строке
		rep movsw		; скопировать строку
		add	di,(80-33)*2 ; увеличить DI до начала следующей 
					; строки
		dec	dx		; уменьшить счетчик строк,
		jnz	restore_screen_loop ; если он не ноль - продолжить
		ret
restore_screen	endp


; процедура display_all
; выводит на экран текущее состояние всплывающего окна нашей программы

display_all	proc	near

; шаг 1: вписать значение текущего выделенного байта в нижнюю строку окна
		mov	al,byte ptr current_char ; AL = выбранный байт
		push	ax
		shr	al,4			; старшие четыре байта
		cmp	al,10			; три команды,
		sbb	al,69h			; преобразующие цифру в AL
		das				; в ее ASCII-код (0 - 9, A - F)
		mov	byte ptr hex_byte1,al ; записать символ на его 
						; место в нижней строке
		pop	ax
		and	al,0Fh			; младшие четыре бита
		cmp	al,10			; то же преобразование
		sbb	al,69h
		das
		mov	byte ptr hex_byte2,al	; записать младшую цифру

; шаг 2: вывод на экран окна. Было бы проще хранить его как массив и выводить 
; командой movsw, как и буфер в процедуре restore_screen, но такой массив займет 
; еще 1190 байтов в резидентной части. Код этой части процедуры display_all - всего 
; 69 байтов.
; шаг 2.1: вывод первой строки
		mov	ah,1Fh			; атрибут белый на синем
		mov	di,START_POSITION	; ES:DI - адрес в видеопамяти
		mov	si,offset display_line1 ; DS:SI - адрес строки
		mov	cx,33			; счетчик символов в строке
display_loop1:	mov	al,byte ptr [si]	; прочитать символ в AL
		stosw			; и вывести его с атрибутом из AH
		inc	si		; увеличить адрес символа в строке
		loop	display_loop1

; шаг 2.2: вывод собственно таблицы
		mov	dx,16		; счетчик строк
		mov	al,-1		; выводимый символ
display_loop4:			; цикл по строкам
		add	di,(80-33)*2	; увеличить DI до начала 
		push	ax		; следующей строки
		mov	al,0B3h
		stosw			; вывести первый символ (0B3h)
		pop	ax
		mov	cx,16		; счетчик символов в строке
display_loop3:		; цикл по символам в строке
		inc	al		; следующий ASCII-символ
		stosw			; вывести его на экран
		push	ax
		mov	al,20h		; вывести пробел
		stosw
		pop	ax
		loop	display_loop3	; и так 16 раз
		push	ax
		sub	di,2		; вернуться назад на 1 символ
		mov	al,0B3h		; и вывести 0B3h на месте последнего
		stosw			; пробела
		pop	ax
		dec	dx		; уменьшить счетчик строк
		jnz	display_loop4

; шаг 2.3: вывод последней строки
		add	di,(80-33)*2	; увеличить DI до начала следующей 
					; строки
		mov	cx,33		; счетчик символов в строке
		mov	si,offset display_line2 ; DS:SI - адрес строки
display_loop2:	mov	al,byte ptr [si] ; прочитать символ в AL
		stosw			; вывести его с атрибутом на экран
		inc	si		; увеличить адрес символа в строке
		loop	display_loop2

; шаг 3: подсветка (изменение атрибута) у текущего выделенного символа
		mov	al,byte ptr current_char ; AL = текущий символ
		mov	ah,0
		mov	di,ax
		and	di,0Fh ; DI = остаток от деления на 16 (номер в строке)
		shl	di,2	; умножить его на 2, так как на экране 
				; используется слово на символ, и еще раз на 2,
				; так как между символами - пробелы
		shr	ax,4	; AX = частное от деления на 16 (номер строки)
		imul	ax,ax,80*2 ; умножить его на длину строки на экране,
		add	di,ax	; сложить их,
		add	di,START_POSITION+2+80*2+1 ; добавить адрес 
			; начала окна + 2, чтобы пропустить первый столбик,
			; + 80 * 2, чтобы пропустить первую строку, + 1, чтобы 
			; получить адрес атрибута, а не символа
		mov	al,071h		; атрибут - синий на сером
		stosb			; вывод на экран

		ret
display_all	endp

int09h_handler	endp		; конец обработчика INT 09h


; буфер для хранения содержимого части экрана, которая накрывается нашим окном
screen_buffer	db	1190 dup(?)

; первая строка окна
display_line1	db	0DAh,11 dup (0C4h),'* ASCII *',11 dup (0C4h),0BFh

; последняя строка окна
display_line2	db	0C0h,11 dup (0C4h),'* Hex '
hex_byte1	db	?		; старшая цифра текущего байта
hex_byte2	db	?		; младшая цифра текущего байта
		db	' *',10 dup (0C4h),0D9h

hw_reset2D:	retf			; ISP: минимальный hw_reset
;
; обработчик прерывания INT 2Dh
; поддерживает функции AMIS 3.6 00h, 02h, 03h, 04h и 05h
int2Dh_handler	proc	far
		jmp short actual_int2Dh_handler ; ISP: пропустить блок
old_int2Dh	dd	?			; ISP: старый обработчик
		dw	424Bh			; ISP: сигнатура
		db	00h			; ISP: программное прерывание
		jmp short hw_reset2D		; ISP: ближний jmp на hw_reset
		db	7 dup (0)		; ISP: зарезервировано
actual_int2Dh_handler:		; начало собственно обработчика INT 2Dh
		db	80h,0FCh	; начало команды CMP AH, число
mux_id		db	?		; идентификатор программы
		je	its_us		; если вызывают с чужим AH - это не нас
		jmp	dword ptr cs:old_int2Dh
its_us:
		cmp	al,06		; функции 06h и выше
		jae	int2D_no	; не поддерживаются
		cbw			; AX = номер функции
		mov	di,ax		; DI = номер функции
		shl	di,1		; умножить его на 2, так как jumptable - 
					; таблица слов
		jmp	word ptr cs:jumptable[di] ; косвенный переход 
						; на обработчики функций
jumptable	dw	offset int2D_00,offset int2D_no
		dw	offset int2D_02,offset int2D_03
		dw	offset int2D_04,offset int2D_05

int2D_00:			; проверка наличия
		mov	al,0FFh		; этот номер занят
		mov	cx,0100h	; номер версии 1.0
		push	cs
		pop	dx		; DX:DI - адрес AMIS-сигнатуры
		mov	di,offset amis_sign
		iret
int2D_no:			; неподдерживаемая функция
		mov	al,00h	; функция не поддерживается
		iret
int2D_02:			; выгрузка программы
		mov	byte ptr cs:disable_point,0CFh ; записать код 
				; команды IRET по адресу disable_point в обработчик INT 09h
		mov	al,04h	; программа дезактивирована, но сама 
				; выгрузиться не может
		mov	bx,cs	; BX - сегментный адрес программы
		iret
int2D_03: 		; запрос на активизацию для "всплывающих" программ
		cmp	byte ptr we_are_active,0 ; если окно уже на
		je	already_popup		; экране,
		call	save_screen		; сохранить область экрана,
		push	cs
		pop	ds
		call	display_all		; вывести окно
		mov	byte ptr we_are_active,1 ; и поднять флаг
already_popup:
		mov	al,03h	; код 03: программа активизирована
		iret

int2D_04: 		; получить список перехваченных прерываний
		mov	dx,cs		; список в DX:BX
		mov	bx,offset amis_hooklist
		iret
int2D_05:		 ; получить список "горячих" клавиш
		mov	al,0FFh	; функция поддерживается
		mov	dx,cs		; список в DX:BX
		mov	bx,offset amis_hotkeys
		iret
int2Dh_handler	endp

; AMIS: сигнатура для резидентных программ
amis_sign	db	"Cubbi   "	; 8 байтов - имя автора
		db	"ASCII   "	; 8 байтов - имя программы
		db	"ASCII display and input utility",0 ; ASCIZ-
					; комментарий не более 64 байтов
; AMIS: список перехваченных прерываний
amis_hooklist	db	09h
		dw	offset int09h_handler
		db	2Dh
		dw	offset int2Dh_handler

; AMIS: список горячих клавиш
amis_hotkeys	db	01h 	; клавиши проверяются после стандартного 
				; обработчика INT 09h
		db	1	; число клавиш
		db	1Eh	; скан-код клавиши (A)
		dw	08h	; требуемые флаги (любая Alt)
		dw	0	; запрещенные флаги
		db	1	; клавиша глотается

; конец резидентной части
; начало процедуры инициализации

initialize	proc near
		mov	ah,9
		mov	dx,offset usage	; вывести информацию о программе
		int	21h

; проверить, не установлена ли уже наша программа
		mov	ah,-1		; сканирование номеров от FFh до 00h
more_mux:
		mov	al,00h		; Функция 00h - проверка наличия
		int	2Dh		; мультиплексорное прерывание AMIS,
		cmp	al,00h		; если идентификатор свободен,
		jne	not_free
		mov	byte ptr mux_id,ah ; записать его номер прямо в код 
					; обработчика int 2Dh,
		jmp short next_mux
not_free:
		mov	es,dx		; иначе - ES:DI = адрес их AMIS-сигнатуры
		mov	si,offset amis_sign ; DS:SI = адрес нашей сигнатуры
		mov	cx,16		; сравнить первые 16 байтов,
		repe	cmpsb
		jcxz	already_loaded ; если они не совпадают,
next_mux:
		dec	ah		; перейти к следующему идентификатору,
		jnz	more_mux	; пока это не 0 (на самом деле в этом примере 
			; сканирование происходит от FFh до 01h, так как 0 
			; мы используем как признак отсутствия 
			; свободного номера в следующей строке)
free_mux_found:
		cmp	byte ptr mux_id,0	; если мы ничего не записали,
		je	no_more_mux		; идентификаторы кончились

		mov	ax,352Dh		; AH = 35h, AL = номер прерывания
		int	21h			; получить адрес обработчика INT 2Dh
		mov	word ptr old_int2Dh,bx	; и поместить его в old_int2Dh
		mov	word ptr old_int2Dh+2,es
		mov	ax,3509h		; AH = 35h, AL = номер прерывания
		int	21h			; получить адрес обработчика INT 09h
		mov	word ptr old_int09h,bx	; и поместить его в old_int09h
		mov	word ptr old_int09h+2,es

		mov	ax,252Dh		; AH = 25h, AL = номер прерывания
		mov	dx,offset int2Dh_handler ; DS:DX - адрес нашего
		int	21h			; обработчика
		mov	ax,2509h		; AH = 25h, AL = номер прерывания
		mov	dx,offset int09h_handler ; DS:DX - адрес нашего
		int	21h			; обработчика

		mov	ah,49h			; AH = 49h
		mov	es,word ptr envseg ; ES = сегментный адрес среды DOS
		int	21h			; освободить память

		mov	ah,9
		mov	dx,offset installed_msg	; вывод строки об успешной 
		int	21h			; инсталляции

		mov	dx,offset initialize	; DX - адрес первого байта за 
						; концом резидентной части
		int	27h			; завершить выполнение, оставшись 
						; резидентом

; сюда передается управление, если наша программа обнаружена в памяти
already_loaded:
		mov	ah,9			; AH = 09h
		mov	dx,offset already_msg	; вывести сообщение об ошибке
		int	21h
		ret				; и завершиться нормально

; сюда передается управление, если все 255 функций мультиплексора заняты 
; резидентными программами
no_more_mux:
		mov	ah,9
		mov	dx,offset no_more_mux_msg
		int	21h
		ret

; текст, который выдает программа при запуске:
usage		db	'ASCII display and input program'
		db	' v1.0',0Dh,0Ah
		db	'Alt-A   - activation',0Dh,0Ah
		db	'Arrow keys - choose character',0Dh,0Ah
		db	'Enter   - enter character',0Dh,0Ah
		db	'Escape  - exit',0Dh,0Ah
		db	'$'
; текст, который выдает программа, если она уже загружена:
already_msg	db	'ERROR: Already loaded',0Dh,0Ah,'$'
; текст, который выдает программа, если все функции мультиплексора заняты:
no_more_mux_msg	db	'ERROR: Too many TSR programs'
		db	' loaded',0Dh,0Ah,'$'
; текст, который выдает программа при успешной установке:
installed_msg	db	'Installed successfully',0Dh,0Ah,'$'

initialize	endp
		end	start
