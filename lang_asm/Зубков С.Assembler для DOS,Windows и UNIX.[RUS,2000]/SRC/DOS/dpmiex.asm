; dpmiex.asm
; Выполняет переключение в защищенный режим средствами DPMI
;
; Компиляция:
; TASM:
; tasm /m dpmiex.asm
; tlink /x /3 dpmiex.obj
; MASM:
; ml /c dpmiex.asm
; link dpmiex.obj,,NUL,,,
; WASM:
; wasm /D_WASM_ dpmiex.asm
; wlink file dpmiex.obj form DOS


	.386		; 32-битный защищенный режим появился в 80386

; 16-битный сегмент - в нем выполняется подготовка и переход в защищенный 
; режим
RM_seg	segment	byte	public	use16
	assume	cs:RM_seg, ds:PM_seg, ss:RM_stack

; точка входа программы
RM_entry:
; проверить наличие DPMI
	mov	ax,1687h	; номер 1678h
	int	2Fh		; прерывание мультиплексора,
	test	ax,ax		; если AX не ноль,
	jnz	DPMI_error	; произошла ошибка (DPMI отсутствует),
	test	bl,1		; если не поддерживается 32-битный режим 
	jz	DPMI_error	; нам тоже нечего делать

; подготовить базовые адреса для будущих дескрипторов
	mov	eax,PM_seg
	mov	ds,ax		; DS - сегментный адрес PM_seg
	shl	eax,4		; EAX - линейный адрес начала сегмента PM_seg
	mov	dword ptr PM_seg_addr,eax
	or	dword ptr GDT_flatCS+2,eax ; дескриптор для CS
	or	dword ptr GDT_flatDS+2,eax ; дескриптор для DS

; сохранить адрес процедуры переключения DPMI
	mov	word ptr DPMI_ModeSwitch,di
	mov	word ptr DPMI_ModeSwitch+2,es

; ES должен указывать на область данных для переключения режимов
; у нас она будет совпадать с началом будущего 32-битного стека
	add	eax,offset DPMI_data	; добавить к EAX смещение
	shr	eax,4			; и превратить в сегментный адрес
	inc	ax
	mov	es,ax

; перейти в защищенный режим
	mov	ax,1	; AX = 1 - мы будем 32-приложением
ifdef _WASM_
	db	67h	; поправка для wasm
endif
	call	dword ptr DPMI_ModeSwitch
	jc	DPMI_error	; если переключения не произошло - выйти

; теперь мы находимся в защищенном режиме, но лимиты всех сегментов 
; установлены на 64 Кб, а разрядности сегментов на 16 битов. Нам надо подготовить два 
; 32-битных селектора с лимитом 4 Гб - один для кода и один для данных

	push	ds
	pop	es	; ES вообще был сегментом PSP с лимитом 100h байтов
	mov	edi,offset GDT		; EDI - адрес таблицы GDT
; цикл по всем дескрипторам в нашей GDT,
	mov	edx,1	; которых всего два (0, 1)
sel_loop:
	xor	ax,ax	; функция DPMI 00
	mov	cx,1
	int	31h	; создать локальный дескриптор
	mov	word ptr selectors[edx*2],ax	; сохранить селектор в 
	mov	bx,ax					; таблицу selectors 
	mov	ax,000Ch	; функция DPMI 0Ch
	int	31h		; установить селектор
	add	di,8		; EDI - следующий дескриптор
	dec	dx
	jns	sel_loop

; загрузить селектор сегмента кода в CS при помощи команды RETF
	push	dword ptr Sel_flatCS	; селектор для CS
ifdef _WASM_
	db	066h
endif
	push	offset PM_entry	; EIP
	db	066h		; префикс размера операнда
	retf			; выполнить переход в 32-битный сегмент

; сюда передается управление, если произошла ошибка при инициализации DPMI
; (обычно, если DPMI просто нет)
DPMI_error:
	push	cs
	pop	ds
	mov	dx,offset nodpmi_msg
	mov	ah,9h			; вывод строки на экран
	int	21h
	mov	ah,4Ch		; конец EXE-программы
	int	21h
nodpmi_msg	db	'DPMI Error$'
RM_seg	ends

; сегмент PM_seg содержит код, данные и стек для защищенного режима
PM_seg	segment	byte	public	use32
	assume	cs:PM_seg,ds:PM_seg,ss:PM_seg

; таблица дескрипторов
GDT	label	byte
; дескриптор для CS
GDT_flatCS	db	0FFh,0FFh,0h,0h,0h,0FAh,0CFh,0h
; дескриптор для DS
GDT_flatDS	db	0FFh,0FFh,0h,0h,0h,0F2h,0CFh,0h

; точка входа в 32-битный режим - загружен только CS
PM_entry:
	mov	ax,word ptr Sel_flatDS	; селектор для данных
	mov	ds,ax	; в DS
	mov	es,ax	; в ES
	mov	ss,ax	; и в SS
	mov	esp,offset PM_stack_bottom ; и установим стек

;============================================================
; отсюда начинается текст собственно программы
; программа работает в модели памяти flat с ненулевой базой
; база CS, DS, ES и SS совпадает и равна линейному адресу начала PM_seg 
; все лимиты - 4 Гб

	mov	ax,0300h			; функция DPMI 0300h
	mov	bx,0021h			; прерывание DOS 21h
	xor	ecx,ecx			; стек не копировать
	mov	edi,offset v86_regs	; ES:EDI - адрес v86_regs
	int	31h				; вызвать прерывание

	mov	ah,4Ch	; Это единственный способ
	int	21h		; правильно завершить DPMI-программу

hello_msg	db	"Hello from 32-bit protected mode!$"

v86_regs:	; значения регистров для функции DPMI 0300h
		dd	0,0,0,0,0	; EDI, ESI, EBP, 0, EBX
v_86_edx	dd	offset hello_msg	; EDX
		dd	0		; ECX
v86_eax		dd	0900h		; EAX (AH = 09h, вывод строки на экран)
		dw	0,0		; FLAGS, ES
v86_ds		dw	PM_seg	; DS
		dw	0,0,0,0,0,0	; FS, GS, 0, 0, SP, SS

; различные временные переменные, нужные для переключения режимов
DPMI_ModeSwitch	dd	?	; точка входа DPMI
PM_seg_addr		dd	?	; линейный адрес сегмента PM_seg 

; значения селекторов
selectors:
Sel_flatDS	dw	?
Sel_flatCS	dw	?

; стек для нашей 32-битной программы
DPMI_data:	; и временная область данных DPMI одновременно
	db 16384 dup (?)
PM_stack_bottom:
PM_seg	ends

; стек 16-битной программы, который использует DPMI-сервер при переключении 
; режимов
; Windows 95 требует 16 байтов
; CWSDPMI требует 32 байта
; QDPMI требует 96 байтов
; мы выберем по максимуму
RM_stack	segment byte stack 'stack' use16
	db	96 dup (?)
RM_stack	ends
	end	RM_entry	; точка входа для DOS - RM_entry
