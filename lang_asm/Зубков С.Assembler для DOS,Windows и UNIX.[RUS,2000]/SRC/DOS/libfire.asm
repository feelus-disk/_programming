; lfbfire.asm
; Программа, работающая с SVGA при помощи линейного кадрового буфера (LFB),
; демонстрирует стандартный алгоритм генерации пламени.
; Требуется поддержка LFB видеоплатой (или загруженный эмулятор univbe)
; для компиляции необходим DOS-расширитель
;
; Компиляция:
; WASM:
; wasm lfbfire.asm
; DOS4G/W:
;   wlink file lfbfire.obj form os2 le op stub=wstub.exe
; PMODE/W:
;   wlink file lfbfire.obj form os2 le op stub=pmodew.exe
; ZRDX:
;   wlink file lfbfire.obj form os2 ls op stub=zrdx.exe
; WDOSX:
;   wlink file lfbfire.obj form os2 le op stub=wdosxle.exe
;
; TASM:
; tasm /m lfbfire.asm
; WDOSX:
;   tlink32 -Tpe lfbfire.obj
;   stubit lfbfire.exe
; DOS32:
;   dlink lfbfire.obj
;
; MASM:
;  ml /c lfbfire.asm
; WDOSX:
;  link ...
;  stubit lfbfire.exe
; DOS32:
;  dlink lfbfire.obj
;
; PMODE/tran, 386power, System64, Raw32 и другие тpебуют изменения кода и
; поэтому не pассматpиваются
;


	.486p			; для команды xadd
	.model flat		; основная модель памяти в защищенном режиме
	.code
	assume fs:nothing	; нужно только для MASM
_start:
	jmp	short	_main
	db	'WATCOM'		; нужно только для DOS/4GW

; начало программы
; на входе обычно CS, DS и SS указывают на один и тот же сегмент с лимитом 4 Гб
; ES указывает на сегмент с PSP на 100h байтов
; остальные регистры не определены

_main:
	sti			; даже флаг прерываний не определен,
	cld			; не говоря уже о флаге направления

	mov	ax,0100h	; функция DPMI 0100h
	mov	bx,100h	; размер в 16-байтных параграфах
	int	31h		; выделить блок памяти ниже 1 Мб
	jc	DPMI_error
	mov	fs,dx		; FS - селектор для выделенного блока

; получить блок общей информации о VBE 2.0 (см. главу Error! Reference source not found.)
	mov	dword ptr fs:[0],'2EBV'	; сигнатура VBE2 в начало блока
	mov	word ptr v86_eax,4F00h	; функция VBE 00h
	mov	word ptr v86_es,ax	; сегмент, выделенный DPMI
	mov	ax,0300h	; функция DPMI 300h
	mov	bx,0010h	; эмуляция прерывания 10h
	xor	ecx,ecx
	mov	edi,offset v86_regs
	push	ds
	pop	es		; ES:EDI - структура v86_regs
	int	31h		; получить общую информацию VBE2
	jc	DPMI_error
	cmp	byte ptr v86_eax,4Fh	; проверка поддержки VBE
	jne	VBE_error

	movzx	ebp,word ptr fs:[18]	; объем SVGA-памяти в EBP
	shl	ebp,6				; в килобайтах

; получить информацию о видеорежиме 101h
	mov	word ptr v86_eax,4F01h	; номер функции INT 10h
	mov	word ptr v86_ecx,101h	; режим 101h - 640x480x256
					; ES:EDI те же самые
	mov	ax,0300h	; функция DPMI 300h - эмуляция прерывания
	mov	bx,0010h	; INT 10h
	xor	ecx,ecx
	int	31h		; получить данные о режиме
	jc	DPMI_error
	cmp	byte ptr v86_eax,4Fh
	jne	VBE_error
	test	byte ptr fs:[0],80h ; бит 7 байта атрибутов = 1 - LFB есть
	jz	LFB_error

; построение дескриптора сегмента, описывающего LFB
; лимит
	mov	eax,ebp		; видеопамять в килобайтах
	shl	eax,10		; теперь в байтах
	dec	eax			; лимит = размер - 1
	shr	eax,12		; лимит в 4-килобайтных единицах
	mov	word ptr videodsc+0,ax	; записать биты 15 - 0 лимита
	shr	eax,8
	and	ah,0Fh
	or	byte ptr videodsc+6,ah	; и биты 19 - 16 лимита
; база
	mov	eax,ebp		; видеопамять в килобайтах
	shl	eax,10		; в байтах
	mov	edx,dword ptr fs:[40]	; физический адрес LFB
	mov	cx,dx
	shld	ebx,edx,16		; поместить его в CX:DX,
	mov	di,ax
	shld	esi,eax,16		; а размер - в SI:DI
	mov	ax,800h		; и вызвать функцию DPMI 0800h
	int	31h			; отобразить физический адрес в линейный
	jc	DPMI_error
	shrd	edx,ebx,16		; перенести полученный линейный адрес
	mov	dx,cx			; из BS:CX в EDX
	mov	word ptr videodsc+2,dx	; и записать биты 15 - 0 базы
	shr	edx,16
	mov	byte ptr videodsc+4,dl	; биты 23 - 16
	mov	byte ptr videodsc+7,dh	; и биты 31 - 24
; права
	mov	bx,cs
	lar	cx,bx			; прочитать права нашего сегмента
	and	cx,6000h		; и перенести биты DPL
	or	byte ptr videodsc+5,ch	; в строящийся дескриптор

; поместить наш дескриптор в LDT и получить селектор
	mov	cx,1		; получить один новый дескриптор
	mov	ax,0		; у DPMI
	int	31h
	jc	DPMI_error
	mov	word ptr videosel,ax	; записать его селектор

	push	ds
	pop	es
	mov	edi,offset videodsc ; ES:EDI - адрес нашего дескриптора
	mov	bx,ax			; BX - выданный нам селектор
	mov	ax,0Ch		; функция DPMI 0Ch
	int	31h		; загрузить дескриптор в LDT
	jc	DPMI_error	; теперь в videosel лежит селектор на LFB

; переключение в режим 4101h (101h + LFB)
	mov word ptr v86_eax,4F02h	; 4F02h - установить SVGA-режим
	mov word ptr v86_ebx,4101h	; режим 4101h = 101h + LFB
	mov	edi,offset v86_regs	; ES:EDI - структура v86_regs
	mov	ax,0300h	; функция DPMI 300h
	mov	bx,0010h	; эмуляция прерывания 10h
	xor	ecx,ecx
	int	31h

	mov	ax,word ptr videosel	; AX - наш селектор
enter_flame:	; сюда придет управление с селектором в ax на A000h:0000, 
		; если произошла ошибка в любой VBE-функции
mov	es,ax	; ES - селектор видеопамяти или LFB

; отсюда начинается процедура генерации пламени

; генерация палитры для пламени
	xor	edi,edi	; начать писать палитру с адреса ES:0000
	xor	ecx,ecx
palette_gen:
	xor	eax,eax	; цвета начинаются с 0, 0, 0
	mov	cl,63		; число значений для одной компоненты
palette_l1:
	stosb		; записать байт
	inc	eax	; увеличить компоненту
	cmpsw		; пропустить два байта
	loop	palette_l1 ; и так 64 раза

	push	edi
	mov	cl,192
palette_l2:
	stosw		; записать два байта
	inc	di	; и пропустить один
	loop	palette_l2 ; и так 192 раза (до конца палитры)
	pop	edi	; восстановить EDI
	inc	di
	jns	palette_gen

; палитра сгенерирована, записать ее в регистры VGA DAC (см. главу Error! Reference source not found.)
	mov	al,0		; начать с регистра 0
	mov	dx,03C8h	; индексный регистр на запись
	out	dx,al
	push	es
	push	ds	; поменять местами ES и DS
	pop	es
	pop	ds
	xor	esi,esi
	mov	ecx,256*3	; писать все 256 регистров
	mov	edx,03C9h	; в порт данных VGA DAC
	rep outsb
	push	es
	push	ds	; поменять местами ES и DS
	pop	es
	pop	ds

; основной цикл - анимация пламени, пока не будет нажата любая клавиша,
	xor	edx,edx		; должен быть равен нулю
	mov	ebp,7777h		; любое число
	mov	ecx,dword ptr scr_width	; ширина экрана
main_loop:
	push	es		; сохранить ES
	push	ds
	pop	es		; ES = DS - мы работаем только с буфером
; анимация пламени (классический алгоритм)
	inc	ecx
	mov	edi,offset buffer
	mov	ebx,dword ptr scr_height
	shr	ebx,1
	dec	ebx
	mov	esi,scr_width
animate_flame:
	mov	ax,[edi+esi*2-1]	; вычислить среднее значение цвета
	add	al,ah			; в данной точке (EDI) из значений 
	setc	ah			; цвета в точке слева и на две строки 
	mov	dl,[edi+esi*2+1]	; вниз, справа и на две строки вниз
	add	ax,dx
	mov	dl,[edi+esi*4]	; и на четыре строки вниз,
	add	ax,dx			; причем первое значение
	shr	ax,2			; модифицировать
	jz	already_zero	; уменьшить яркость цвета 
	dec	ax
already_zero:
	stosb			; записать новый цвет в буфер
	add	eax,edx
	shr	eax,1
	mov	byte ptr [edi+esi-1],al
	loop	animate_flame
	mov	ecx,esi
	add	edi,ecx
	dec	ebx
	jnz	animate_flame

; псевдослучайная полоска внизу экрана, которая служит генератором пламени
generator_bar:
	xadd	bp,ax
	stosw
	stosw
	loop	generator_bar

	pop	es	; восстановить ES для вывода на экран
; вывод пламени на экран
	xor	edi,edi		; ES:EDI - LFB
	push	esi
	add	esi,offset buffer	; DS:ESI - буфер
	mov	ecx,dword ptr scr_size ; размер буфера в двойных словах
	rep	movsd			; скопировать буфер на экран
	pop	esi

	mov	ah,1		; если не была нажата
	int	16h		; никакая клавиша,
	jz	main_loop	; продолжить основной цикл,
	mov	ah,0		; иначе -
	int	16h		; считать эту клавишу

exit_all:
	mov	ax,03h	; восстановить текстовый режим
	int	10h
	mov	ax,4C00h	; AH = 4Ch
	int	21h		; выход из программы под расширителем DOS

; различные обработчики ошибок
DPMI_error:	; ошибка при выполнении одной из функций DPMI
	mov	edx,offset DPMI_error_msg
	mov	ah,9
	int	21h			; вывести сообщение об ошибке
	jmp short exit_all	; и выйти
VBE_error:	; не поддерживается VBE
	mov	edx,offset VBE_error_msg
	mov	ah,9
	int	21h		; вывести сообщение об ошибке
	jmp short start_with_vga	; и использовать VGA
LFB_error:	; не поддерживается LFB
	mov	edx,offset LFB_error_msg
	mov	ah,9		; вывести сообщение об ошибке
	int	21h
start_with_vga:
	mov	ah,0		; подождать нажатия любой клавиши
	int	16h
	mov	ax,13h	; переключиться в видеорежим 13h
	int	10h		; 320x200x256
	mov	ax,2		; функция DPMI 0002h
	mov	bx,0A000h	; построить дескриптор для реального
	int	31h		; сегмента
	mov	dword ptr scr_width,320	; установить параметры
	mov	dword ptr scr_height,200		; режима
	mov	dword ptr scr_size,320*200/4
	jmp enter_flame		; и перейти к пламени

	.data
; различные сообщения об ошибках
VBE_error_msg	db	'VBE 2.0 error',0Dh,0Ah
		db	'Will use VGA 320x200 mode'
		db	0Dh,0Ah,'$'
DPMI_error_msg	db	'DPMI error$'
LFB_error_msg	db	'Linear Framebuffer not '
		db	'availiable',0Dh,0Ah
		db	'Will use VGA 320x200 mode'
		db	0Dh,0Ah,'$'
; параметры видеорежима
scr_width	dd	640
scr_height	dd	480
scr_size	dd	640*480/4
; структура, используемая функцией DPMI 0300h
v86_regs label byte
v86_edi	dd	0
v86_esi	dd	0
v86_ebp	dd	0
v86_res	dd	0
v86_ebx	dd	0
v86_edx	dd	0
v86_ecx	dd	0
v86_eax	dd	0
v86_flags	dw	0
v86_es	dw	0
v86_ds	dw	0
v86_fs	dw	0
v86_gs	dw	0
v86_ip	dw	0
v86_cs	dw	0
v86_sp	dw	0
v86_ss	dw	0
; дескриптор сегмента, соответствующего LFB
videodsc	dw	0	; биты 15 - 0 лимита
		dw	0	; биты 15 - 0 базы
		db	0	; биты 16 - 23 базы
		db	10010010b	; доступ
		db	10000000b	; биты 16 - 19 лимита и другие биты
		db	0	; биты 24 - 31 базы
; селектор сегмента, описывающего LFB
videosel	dw	0
	.data?
; буфер для экрана
buffer	db	640*483 dup(?)
; стек
	.stack	1000h
	end	_start

