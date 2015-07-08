; scrgrb.asm
; Резидентная программа, сохраняющая изображение с экрана в файл.
; Поддерживается только видеорежим 13h (320x200x256) и только один файл.
;
; HCI:
; Нажатие Alt-G создает файл scrgrb.bmp в текущей директории с изображением, 
; находившимся на экране в момент нажатия клавиши.
; Запуск с командной строкой /u выгружает программу из памяти
; 
; API:
; Программа занимает первую свободную функцию прерывания 2Dh (кроме нуля)
; в соответствии со спецификацией AMIS 3.6
; Поддерживаемые подфункции AMIS: 00h, 02h, 03h, 04h, 05h
; Все обработчики прерываний построены в соответствии с IMB ISP
;
; Резидентная часть занимает в памяти 1056 байтов, если присутствует EMS,
; и 66 160 байтов, если EMS не обнаружен
;
; Компиляция:
; TASM:
;  tasm /m scrgrb.asm
;  tlink /t /x scrgrb.obj
; MASM:
;  ml /c scrgrb.asm
;  link scrgrb.obj,,NUL,,,
;  exe2bin scrgrb.exe scrgrb.com
; WASM:
;  wasm scrgrb.asm
;  wlink file scrgrb.obj form DOS COM
;

	.model	tiny
	.code
	.186			; для сдвигов и команд pusha/popa
	org	2Ch
envseg	dw	?	; сегментный адрес окружения
	org	80h
cmd_len	db	?	; длина командной строки
cmd_line	db	?	; командная строка
	org	100h		; COM-программа
start:
	jmp	initialize	; переход на инициализирующую часть

; Обработчик прерывания 09h (IRQ1)

int09h_handler	proc	far
		jmp short actual_int09h_handler	; пропустить ISP
old_int09h	dd	?
		dw	424Bh
		db	00h
		jmp short hw_reset
		db	7 dup (0)
actual_int09h_handler:		; начало собственно обработчика INT 09h
		pushf
		call	dword ptr cs:old_int09h ; сначала вызвать старый 
; обработчик, чтобы он завершил аппаратное 
; прерывание и передал код в буфер

	pusha		; это аппаратное прерывание - надо
	push	ds	; сохранить все регистры
	push	es
	
	push	0040h
	pop	ds	; DS = сегментный адрес области данных BIOS
	mov	di,word ptr ds:001Ah	; адрес головы буфера 
					; клавиатуры,
	cmp	di,word ptr ds:001Ch	; если он равен адресу 
					; хвоста,
	je	exit_09h_handler	; буфер пуст, и нам делать нечего,

	mov	ax,word ptr [di]	; иначе: считать символ,
	cmp	ah,22h		; если это не G (скан-код 22h),
	jne	exit_09h_handler	; выйти

	mov	al,byte ptr ds:0017h ; байт состояния клавиатуры,
	test	al,08h		; если Alt не нажата,
	jz	exit_09h_handler	; выйти,

	mov	word ptr ds:001Ch,di ; иначе: установить адреса 
	; головы и хвоста буфера равными, то есть опустошить его

	call	do_grab	; подготовить BMP-файл с изображением
	mov	byte ptr cs:io_needed,1	; установить флаг 
					; требующейся записи на диск
	cli
	call	safe_check	; проверить, можно ли вызвать DOS,
	jc	exit_09h_handler
	sti
	call	do_io		; если да - записать файл на диск

exit_09h_handler: 
	pop	es
	pop	ds	; восстановить регистры 
	popa
	iret		; и вернуться в прерванную программу
int09h_handler	endp

hw_reset:	retf 


; Обработчик INT 08h (IRQ0)

int08h_handler	proc	far
		jmp short actual_int08h_handler ; пропустить ISP
old_int08h	dd	?
		dw	424Bh
		db	00h
		jmp short hw_reset 
		db	7 dup (0)
actual_int08h_handler:		; собственно обработчик
		pushf
		call	dword ptr cs:old_int08h	; сначала вызвать стандартный 
	; обработчик, чтобы он завершил аппаратное прерывание 
	; (пока оно не завершено, запись на диске невозможна)
	pusha
	push	ds
	cli		; между любой проверкой глобальной переменной 
			; и принятием решения по ее значению - 
			; не повторно входимая область, прерывания 
			; должны быть запрещены
	cmp	byte ptr cs:io_needed,0	; проверить,
	je	no_io_needed	; нужно ли писать на диск

	call	safe_check		; проверить,
	jc	no_io_needed	; можно ли писать на диск
	sti			; разрешить прерывания на время записи

	call	do_io		; запись на диск
no_io_needed:
	pop	ds
	popa
	iret
int08h_handler	endp


; Обработчик INT 13h
; поддерживает флаг занятости INT 13h, который тоже надо проверять перед 
; записью на диск

int13h_handler	proc	far
	jmp short actual_int13h_handler	; пропустить ISP
old_int13h	dd	?
		dw	424Bh
		db	00h
		jmp short hw_reset
		db	7 dup (0)
actual_int13h_handler:		; собственно обработчик
		pushf
		inc	byte ptr cs:bios_busy	; увеличить счетчик 
						; занятости INT 13h
		cli
		call	dword ptr cs:old_int13h
		pushf
		dec	byte ptr cs:bios_busy	; уменьшить счетчик
		popf
		ret	2	; имитация команды IRET, не восстанавливающая 
		; флаги из стека, так как обработчик INT 13h возвращает некоторые 
		; результаты в регистре флагов, а не в его копии, хранящейся в 
		; стеке. Он тоже завершается командой ret 2
int13h_handler	endp


; Обработчик INT 28h
; вызывается DOS, когда она ожидает ввода с клавиатуры и функциями DOS можно 
; пользоваться

int28h_handler	proc	far
		jmp short actual_int28h_handler	; пропустить ISP
old_int28h	dd	?
		dw	424Bh
		db	00h
		jmp short hw_reset
		db	7 dup (0)
actual_int28h_handler:
		pushf
	push	di
	push	ds
	push	cs
	pop	ds
	cli
	cmp	byte ptr io_needed,0	; проверить,
	je	no_io_needed2	; нужно ли писать на диск
	lds	di,dword ptr in_dos_addr
	cmp	byte ptr [di+1],1	; проверить,
	ja	no_io_needed2 ; можно ли писать на диск (флаг 
			; занятости DOS не должен быть больше 1)
	sti
	call	do_io		; запись на диск
no_io_needed2:
	pop	ds
	pop	di
	popf
	jmp	dword ptr cs:old_int28h	; переход на старый 
				; обработчик INT 28h
int28h_handler	endp

; Процедура do_grab
; помещает в буфер палитру и содержимое видеопамяти, формируя BMP-файл.
; Считает, что текущий видеорежим - 13h
do_grab	proc	near
	push	cs
	pop	ds

	call	ems_init	; отобразить наш буфер в окно EMS

	mov	dx,word ptr cs:buffer_seg
	mov	es,dx		; поместить сегмент с буфером в ES и DS
	mov	ds,dx		; для следующих шагов процедуры

	mov	ax,1017h	; Функция 1017h - чтение палитры VGA
	mov	bx,0		; начиная с регистра палитры 0,
	mov	cx,256	; все 256 регистров
	mov	dx,BMP_header_length ; начало палитры в BMP
	int	10h		; видеосервис BIOS

; перевести палитру из формата, в котором ее показывает функция 1017h
; (три байта на цвет, в каждом байте 6 значимых битов)
; в формат, используемый в BMP-файлах
; (4 байта на цвет, в каждом байте 8 значимых битов)
	std		; движение от конца к началу
	mov	si,BMP_header_length+256*3-1	; SI - конец 3-байтной 
						; палитры
	mov	di,BMP_header_length+256*4-1	; DI - конец 4-байтной 
						; палитры
	mov	cx,256		; CX - число цветов
adj_pal: mov	al,0
	stosb			; записать четвертый байт (0)
	lodsb			; прочитать третий байт
	shl	al,2		; масштабировать до 8 битов
	push	ax
	lodsb			; прочитать второй байт
	shl	al,2		; масштабировать до 8 битов
	push	ax
	lodsb			; прочитать третий байт
	shl	al,2		; масштабировать до 8 битов
	stosb			; и записать эти три байта
	pop	ax		; в обратном порядке
	stosb
	pop	ax
	stosb
	loop	adj_pal

; копирование видеопамяти в BMP.
; В формате BMP строки изображения записываются от последней к первой, так что 
; первый байт соответствует нижнему левому пикселю
	cld			; движение от начала к концу (по строке)
	push	0A000h
	pop	ds
	mov	si,320*200	; DS:SI - начало последней строки на экране
	mov	di,bfoffbits	; ES:DI - начало данных в BMP
	mov	dx,200		; счетчик строк
bmp_write_loop:
	mov	cx,320/2 	; счетчик символов в строке
	rep movsw		; копировать целыми словами, так быстрее
	sub	si,320*2 	; перевести SI на начало предыдущей строки
	dec	dx		; уменьшить счетчик строк,
	jnz	bmp_write_loop	; если 0 - выйти из цикла

	call	ems_reset	; восстановить состояние EMS до вызова do_grab
	ret
do_grab	endp


; Процедура do_io
; создает файл и записывает в него содержимое буфера

do_io		proc	near
	push cs
	pop ds

	mov	byte ptr io_needed,0 ; сбросить флаг требующейся 
				; записи на диск

	call	ems_init	; отобразить в окно EMS наш буфер
	
	mov	ah,6Ch	; Функция DOS 6Ch
	mov	bx,2		; доступ - на чтение/запись
	mov	cx,0		; атрибуты - обычный файл
	mov	dx,12h	; заменять файл, если он существует,
				; создавать, если нет
	mov	si,offset filespec	; DS:SI - имя файла
	int	21h		; создать/открыть файл
	mov	bx,ax		; идентификатор файла - в BX

	mov	ah,40h	; Функция DOS 40h
	mov	cx,bfsize	; размер BMP-файла
	mov	ds,word ptr buffer_seg
	mov	dx,0		; DS:DX - буфер для файла
	int	21h		; запись в файл или устройство

	mov	ah,68h	; сбросить буфера на диск
	int	21h

	mov	ah,3Eh	; закрыть файл
	int	21h

	call	ems_reset

	ret
do_io		endp


; Процедура ems_init
; если буфер расположен в EMS - подготавливает его для чтения/записи

ems_init proc near

	cmp	dx,word ptr ems_handle	; если не используется EMS
	cmp	dx,0 		; (EMS-идентификаторы начинаются с 1),
	je	ems_init_exit		; ничего не делать

	mov	ax,4700h	; Функция EMS 47h
	int	67h		; сохранить EMS-контекст

	mov	ax,4100h	; Функция EMS 41h
	int	67h		; определить адрес окна EMS
	mov	word ptr buffer_seg,bx	; сохранить его

	mov	ax,4400h	; Функция EMS 44h
	mov	bx,0		; начиная со страницы 0,
	int	67h		; отобразить страницы EMS в окно
	mov	ax,4401h
	inc	bx
	int	67h		; страница 1
	mov	ax,4402h
	inc	bx
	int	67h		; страница 2
	mov	ax,4403h
	inc	bx
	int	67h		; страница 3
ems_init_exit:
	ret
ems_init endp


; Процедура ems_reset
; восстанавливает состояние EMS
ems_reset proc near
	mov	dx,word ptr cs:ems_handle
	cmp	dx,0
	je	ems_reset_exit

	mov	ax,4800h	; Функция EMS 48h
	int	67h		; восстановить EMS-контекст
ems_reset_exit:
	ret
ems_reset endp


; Процедура safe_check
; возвращает CF = 0, если в данный момент можно пользоваться функциями DOS,
; и CF = 1, если нельзя
safe_check	proc	near
	push	es
	push	cs
	pop	ds

	les	di,dword ptr in_dos_addr ; адрес флагов занятости DOS,
	cmp	word ptr es:[di],0	; если один из них не 0,
	pop	es
	jne	safe_check_failed	; пользоваться DOS нельзя,

	cmp	byte ptr bios_busy,0 ; если выполняется прерывание 13h,
	jne	safe_check_failed	; тоже нельзя

	clc		; CF = 0
	ret
safe_check_failed:
	stc		; CF = 1
	ret
safe_check	endp

in_dos_addr	dd	?	; адрес флагов занятости DOS
io_needed	db	0	; 1, если надо записать файл на диск
bios_busy	db	0	; 1, если выполняется прерывание INT 13h
buffer_seg	dw	0	; сегментный адрес буфера для файла
ems_handle	dw	0	; идентификатор EMS
filespec	db	'scrgrb.bmp',0	; имя файла


; Обработчик INT 2Dh

hw_reset2D:	retf
int2Dh_handler	proc	far
		jmp short actual_int2Dh_handler	; пропустить ISP
old_int2Dh	dd	?
		dw	424Bh
		db	00h
		jmp short hw_reset2D
		db	7 dup (0)
actual_int2Dh_handler:		; собственно обработчик
		db	80h,0FCh	; начало команды CMP AH, число
mux_id	db	?		; идентификатор программы,
		je	its_us	; если вызывают с чужим AH - это не нас
		jmp	dword ptr cs:old_int2Dh
its_us:
	cmp	al,06		; функции AMIS 06h и выше
	jae	int2D_no	; не поддерживаются
	cbw			; AX = номер функции
	mov	di,ax		; DI = номер функции
	shl	di,1		;  * 2, так как jumptable - таблица слов
	jmp	word ptr cs:jumptable[di]	; переход на 
					; обработчик функции
jumptable	dw	offset int2D_00,offset int2D_no
		dw	offset int2D_02,offset int2D_no
		dw	offset int2D_04,offset int2D_05

int2D_00: ; проверка наличия
	mov	al,0FFh	; этот номер занят
	mov	cx,0100h	; номер версии программы 1.0
	push	cs
	pop	dx		; DX:DI - адрес AMIS-сигнатуры
	mov	di,offset amis_sign
	iret
int2D_no: ; неподдерживаемая функция
	mov	al,00h	; функция не поддерживается
	iret

unload_failed:	; сюда передается управление, если хоть один из векторов 
		; прерываний был перехвачен кем-то после нас,
	mov	al,01h	; выгрузка программы не удалась
	iret
int2D_02: ; выгрузка программы из памяти
	cli		; критический участок
	push	0
	pop	ds	; DS - сегментный адрес таблицы векторов 
				; прерываний
	mov	ax,cs	; наш сегментный адрес
; проверить, все ли перехваченные прерывания по-прежнему указывают на нас
; обычно достаточно проверить только сегментные адреса (DOS не загрузит другую 
; программу с нашим сегментным адресом)
	cmp	ax,word ptr ds:[09h*4+2]
	jne	unload_failed
	cmp	ax,word ptr ds:[13h*4+2]
	jne	unload_failed
	cmp	ax,word ptr ds:[08h*4+2]
	jne	unload_failed
	cmp	ax,word ptr ds:[28h*4+2]
	jne	unload_failed
	cmp	ax,word ptr ds:[2Dh*4+2]
	jne	unload_failed

	push	bx		; адрес возврата - в стек
	push	dx

; восстановить старые обработчики прерываний
	mov	ax,2509h
	lds	dx,dword ptr cs:old_int09h
	int	21h
	mov	ax,2513h
	lds	dx,dword ptr cs:old_int13h
	int	21h
	mov	ax,2508h
	lds	dx,dword ptr cs:old_int08h
	int	21h
	mov	ax,2528h
	lds	dx,dword ptr cs:old_int28h
	int	21h
	mov	ax,252Dh
	lds	dx,dword ptr cs:old_int2Dh
	int	21h

	mov	dx,word ptr cs:ems_handle ; если используется 
	cmp	dx,0				; EMS
	je	no_ems_to_unhook
	mov	ax,4500h	; Функция EMS 45h
	int	67h		; освободить выделенную память
	jmp short ems_unhooked
no_ems_to_unhook:
ems_unhooked:

; собственно выгрузка резидента
	mov	ah,51h	; Функция DOS 51h
	int	21h		; получить сегментный адрес PSP 
				; прерванного процесса (в данном случае
				; PSP копии нашей программы, запущенной с ключом /u)
	mov	word ptr cs:[16h],bx	; поместить его в поле
				; "сегментный адрес предка" в нашем PSP
	pop	dx	; восстановить адрес возврата из стека
	pop	bx
	mov	word ptr cs:[0Ch],dx ; и поместить его в поле
	mov	word ptr cs:[0Ah],bx ; "адрес перехода при 
					; завершении программы" в нашем PSP
	push	cs
	pop	bx		; BX = наш сегментный адрес PSP
	mov	ah,50h	; Функция DOS 50h
	int	21h		; установить текущий PSP
; теперь DOS считает наш резидент текущей программой, а scrgrb.com /u - 
; вызвавшем его процессом, которому и передаст управление после вызова 
; следующей функции
	mov	ax,4CFFh	; Функция DOS 4Ch
	int	21h		; завершить программу

int2D_04: ; получить список перехваченных прерываний
	mov	dx,cs		; список в DX:BX
	mov	bx,offset amis_hooklist
	iret
int2D_05: ; получить список горячих клавиш
	mov	al,0FFh	; функция поддерживается
	mov	dx,cs		; список в DX:BX
	mov	bx,offset amis_hotkeys
	iret
int2Dh_handler	endp

; AMIS: сигнатура для резидентной программы
amis_sign	db	"Cubbi   "	; 8 байтов
		db	"ScrnGrab"	; 8 байтов
		db	"Simple screen grabber using EMS",0

; AMIS: список перехваченных прерываний
amis_hooklist	db	09h
		dw	offset int09h_handler
		db	08h
		dw	offset int08h_handler
		db	28h
		dw	offset int28h_handler
		db	2Dh
		dw	offset int2Dh_handler
; AMIS: список горячих клавиш
amis_hotkeys	db	1
		db	1
		db	22h	; скан-код клавиши (G)
		dw	08h	; требуемые флаги клавиатуры
		dw	0
		db	1

; конец резидентной части
; начало процедуры инициализации

initialize	proc near
		jmp short initialize_entry_point ; пропустим различные 
; варианты выхода без установки резидента, помещенные здесь 
; потому, что на них передают управление команды условного 
; перехода, имеющие короткий радиус действия

exit_with_message:
		mov	ah,9	; функция вывода строки на экран
		int	21h
		ret		; выход из программы

already_loaded:	; если программа уже загружена в память
	cmp	byte ptr unloading,1	; если мы не были вызваны с /u
	je	do_unload
	mov	dx,offset already_msg
	jmp short exit_with_message

no_more_mux:	; если свободный идентификатор INT 2Dh не найден
	mov	dx,offset no_more_mux_msg
	jmp short exit_with_message

cant_unload1:	; если нельзя выгрузить программу
	mov	dx,offset cant_unload1_msg
	jmp short exit_with_message

do_unload:	; выгрузка резидента: при передаче управления сюда AH содержит 
		; идентификатор программы - 1
	inc	ah
	mov	al,02h		; AMIS-функция выгрузки резидента
	mov	dx,cs			; адрес возврата
	mov	bx,offset exit_point	; в DX:BX
	int	2Dh	; вызов нашего резидента через мультиплексор

	push	cs	; если управление пришло сюда - выгрузка не произошла
	pop	ds
	mov	dx,offset cant_unload2_msg
	jmp short exit_with_message

exit_point:	; если управление пришло сюда - выгрузка произошла
	push	cs
	pop	ds
	mov	dx,offset unloaded_msg
	push	0		; чтобы сработала команда RET для выхода
	jmp short exit_with_message

initialize_entry_point:	; сюда передается управление в самом начале
	cld

	cmp	byte ptr cmd_line[1],'/'
	jne	not_unload
	cmp	byte ptr cmd_line[2],'u' ; если нас вызвали с /u,
	jne	not_unload
	mov	byte ptr unloading,1	; выгрузить резидент
not_unload:

	mov	ah,9
	mov	dx,offset usage ; вывод строки с информацией о программе
	int	21h

	mov	ah,-1		; сканирование от FFh до 01h
more_mux:
	mov	al,00h	; функция AMIS 00h - проверка наличия резидента
	int	2Dh		; мультиплексорное прерывание
	cmp	al,00h	; если идентификатор свободен,
	jne	not_free
	mov	byte ptr mux_id,ah ; вписать его сразу в код обработчика,
	jmp short next_mux
not_free:
	mov	es,dx		; иначе - ES:DI = адрес AMIS-сигнатуры 
				; вызвавшей программы
	mov	si,offset amis_sign ; DS:SI = адрес нашей сигнатуры
	mov	cx,16		; сравним первые 16 байтов,
	repe	cmpsb
	jcxz	already_loaded	; если они не совпадают,
next_mux:
	dec	ah		; перейти к следующему идентификатору,
	jnz	more_mux	; если это 0

free_mux_found:
	cmp	byte ptr unloading,1 ; и если нас вызвали для выгрузки,
	je	cant_unload1	; а мы пришли сюда - программы нет в 
				; памяти,
	cmp	byte ptr mux_id,0	; если при этом mux_id все еще 0,
	je	no_more_mux		; идентификаторы кончились

; проверка наличия устройства EMMXXXX0
	mov	dx,offset ems_driver
	mov	ax,3D00h
	int	21h		; открыть файл/устройство
	jc	no_emmx
	mov	bx,ax
	mov	ax,4400h
	int	21h		; IOCTL: получить состояние файла/устройства
	jc	no_ems
	test	dx,80h	; если старший бит DX = 0, EMMXXXX0 - файл
	jz	no_ems
; выделить память под буфер в EMS
	mov	ax,4100h	; Функция EMS 41h
	int	67h		; получить адрес окна EMS
	mov	bp,bx		; сохранить его пока в BP
	mov	ax,4300h	; Функция EMS 43h
	mov	bx,4		; нам надо 4 * 16 Kб
	int	67h		; выделить EMS-память (идентификатор в DX),
	cmp	ah,0		; если произошла ошибка (нехватка памяти?),
	jnz	ems_failed	; не будем пользоваться EMS,
	mov	word ptr ems_handle,dx ; иначе: сохранить идентификатор 
				; для резидента
	mov	ax,4400h	; Функция 44h - отобразить EMS-страницы в окно
	mov	bx,0
	int	67h		; страница 0
	mov	ax,4401h
	inc	bx
	int	67h		; страница 1
	mov	ax,4402h
	inc	bx
	int	67h		; страница 2
	mov	ax,4403h
	inc	bx
	int	67h		; страница 3

	mov	ah,9
	mov	dx,offset ems_msg ; вывести сообщение об установке в EMS
	int	21h

	mov	ax,bp
	jmp short ems_used

ems_failed:
no_ems:			; если EMS нет или он не работает,
	mov	ah,3Eh
	int	21h		; закрыть файл/устройство EMMXXXX0,
no_emmx:
; занять общую память
	mov	ah,9
	mov	dx,offset conv_msg ; вывод сообщения об этом
	int	21h

	mov	sp,length_of_program+100h+200h ; перенести стек
	
	mov	ah,4Ah		; Функция DOS 4Ah
next_segment = length_of_program+100h+200h+0Fh
next_segment = next_segment/16	; такая запись нужна только для 
; WASM, остальным ассемблерам это 
; можно было записать в одну строчку
	mov	bx,next_segment	; уменьшить занятую память, оставив 
		; текущую длину нашей программы +100h 
		; на PSP +200h на стек
	int	21h

	mov	ah,48h		; Функция 48h - выделить память
bfsize_p = bfsize+0Fh
bfsize_p = bfsize_p/16
	mov	bx,bfsize_p	; размер BMP-файла 320x200x256 в 16-байтных
	int	21h		; параграфах

ems_used:
	mov	word ptr buffer_seg,ax	; сохранить адрес буфера для 
					; резидента

; скопировать заголовок BMP-файла в начало буфера
	mov	cx,BMP_header_length
	mov	si,offset BMP_header
	mov	di,0
	mov	es,ax
	rep movsb

; получить адреса флага занятости DOS и флага критической ошибки (считая, что 
; версия DOS старше 3.0)
	mov	ah,34h		; Функция 34h - получить флаг занятости
	int	21h
	dec	bx			; уменьшить адрес на 1, чтобы он указывал 
					; на флаг критической ошибки,
	mov	word ptr in_dos_addr,bx
	mov	word ptr in_dos_addr+2,es ; и сохранить его для резидента

; перехват прерываний
	mov	ax,352Dh		; AH = 35h, AL = номер прерывания
	int	21h			; получить адрес обработчика INT 2Dh
	mov	word ptr old_int2Dh,bx	; и поместить его в old_int2Dh
	mov	word ptr old_int2Dh+2,es
	mov	ax,3528h		; AH = 35h, AL = номер прерывания
	int	21h			; получить адрес обработчика INT 28h
	mov	word ptr old_int28h,bx	; и поместить его в old_int28h
	mov	word ptr old_int28h+2,es
	mov	ax,3508h		; AH = 35h, AL = номер прерывания
	int	21h			; получить адрес обработчика INT 08h
	mov	word ptr old_int08h,bx	; и поместить его в old_int08h
	mov	word ptr old_int08h+2,es
	mov	ax,3513h		; AH = 35h, AL = номер прерывания
	int	21h			; получить адрес обработчика INT 13h
	mov	word ptr old_int13h,bx	; и поместить его в old_int13h
	mov	word ptr old_int13h+2,es
	mov	ax,3509h		; AH = 35h, AL = номер прерывания
	int	21h			; получить адрес обработчика INT 09h
	mov	word ptr old_int09h,bx	; и поместить его в old_int09h
	mov	word ptr old_int09h+2,es

	mov	ax,252Dh		; AH = 25h, AL = номер прерывания
	mov	dx,offset int2Dh_handler ; DS:DX - адрес обработчика
	int	21h			; установить новый обработчик INT 2Dh
	mov	ax,2528h		; AH = 25h, AL = номер прерывания
	mov	dx,offset int28h_handler ; DS:DX - адрес обработчика
	int	21h			; установить новый обработчик INT 28h
	mov	ax,2508h		; AH = 25h, AL = номер прерывания
	mov	dx,offset int08h_handler ; DS:DX - адрес обработчика
	int	21h			; установить новый обработчик INT 08h
	mov	ax,2513h		; AH = 25h, AL = номер прерывания
	mov	dx,offset int13h_handler ; DS:DX - адрес обработчика
	int	21h			; установить новый обработчик INT 13h
	mov	ax,2509h		; AH = 25h, AL = номер прерывания
	mov	dx,offset int09h_handler ; DS:DX - адрес обработчика
	int	21h			; установить новый обработчик INT 09h

; освободить память из-под окружения DOS
	mov	ah,49h		; Функция DOS 49h
	mov	es,word ptr envseg ; ES = сегментный адрес окружения DOS
	int	21h			; освободить память

; оставить программу резидентной
	mov	dx,offset initialize ; DX - адрес первого байта за концом 
					; резидентной части
	int	27h			; завершить выполнение, оставшись 
					; резидентом
initialize	endp

ems_driver	db	'EMMXXXX0',0	; имя EMS-драйвера для проверки

; текст, который выдает программа при запуске:
usage		db	'Screen Grab sample program for video mode'
		db	' 13h only ',0Dh,0Ah
		db	' Alt-G    - capture screen'
		db	' image',0Dh,0Ah
		db	' scrgrb.com /u - unload from'
		db	' memory',0Dh,0Ah
		db	'$'
; тексты, которые выдает программа при успешном выполнении:
ems_msg	db	'Loaded into EMS',0Dh,0Ah,'$'
conv_msg	db	'Loaded into conventional'
		db	' memory',0Dh,0Ah,'$'
unloaded_msg	db	'Unloaded successfully',0Dh,0Ah,'$'
; тексты, которые выдает программа при ошибках:
already_msg		db	'ERROR: Already loaded',0Dh,0Ah,'$'
no_more_mux_msg	db	'ERROR: Too many TSR programs'
		db	'loaded',0Dh,0Ah,'$'
cant_unload1_msg	db	"ERROR: Can't unload: program not found in memory",0Dh,0Ah,'$'
cant_unload2_msg	db	"ERROR: Can't unload: another TSR hooked interrupts",0Dh,0Ah,'$'
unloading	db	0	; 1, если нас запустили с ключом /u

; BMP-файл (для изображения 320x200x256)
BMP_header	label	byte
; файловый заголовок
BMP_file_header	db	"BM"		; сигнатура
		dd	bfsize	; размер файла
		dw	0,0		; 0
		dd	bfoffbits ; адрес начала BMP_data
				; информационный заголовок
BMP_info_header	dd	bi_size	; размер BMP_info_header
		dd	320		; ширина
		dd	200		; высота
		dw	1		; число цветовых плоскостей
		dw	8		; число битов на пиксель
		dd	0		; метод сжатия данных
		dd	320*200	; размер данных
		dd	0B13h	; разрешение по X (пиксель на метр)
		dd	0B13h	; разрешение по Y (пиксель на метр)
		dd	0	; число используемых цветов (0 - все)
		dd	0	; число важных цветов (0 - все)
bi_size = $-BMP_info_header	; размер BMP_info_header
BMP_header_length = $-BMP_header	; размер обоих заголовков
bfoffbits = $-BMP_file_header+256*4 ; размер заголовков + размер 
					; палитры
bfsize = $-BMP_file_header+256*4+320*200 ; размер заголовков + 
					; размер палитры + размер данных
length_of_program = $-start
		end	start
