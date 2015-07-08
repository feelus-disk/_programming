; pm3.asm
; Программа, демонстрирующая страничную адресацию.
; Переносит одну из страниц, составляющих видеопамять, и пытается закрасить
; экран
;
; Компиляция:
; TASM:
;  tasm /m pm3.asm
;  tlink /x /3 pm3.obj
; MASM:
;  ml /c pm3.asm
;  link pm3.obj,,NUL,,,
; WASM:
;  wasm pm3.asm
;  wlink file pm3.obj form DOS
;

	.386p
RM_seg segment para public 'CODE' use16
	assume cs:RM_seg,ds:PM_seg,ss:stack_seg
start:
; подготовить сегментные регистры
	push	PM_seg
	pop	ds
; проверить, не находимся ли мы уже в PM
	mov	eax,cr0
	test	al,1
	jz	no_V86
; сообщить и выйти
	mov	dx,offset v86_msg
err_exit:
	push	cs
	pop	ds
	mov	ah,9
	int	21h
	mov	ah,4Ch
	int	21h

; убедиться, что мы не под Windows
no_V86:
	mov	ax,1600h
	int	2Fh
	test	al,al
	jz	no_windows
; сообщить и выйти
	mov	dx,offset win_msg
	jmp short err_exit

; сообщения об ошибках при старте
v86_msg	db	"Running in V86 mode. Can't switch to PM$"
win_msg db	"Runnind under Windows. Can't switch to ring 0$"

; итак, мы точно находимся в реальном режиме
no_windows:
; очистить экран и переключиться в нужный видеорежим
	mov	ax,13h
	int	10h
; вычислить базы для всех дескрипторов
	xor	eax,eax
	mov	ax,RM_seg
	shl	eax,4
	mov	word ptr GDT_16bitCS+2,ax
	shr	eax,16
	mov	byte ptr GDT_16bitCS+4,al
	mov	ax,PM_seg
	shl	eax,4
	mov	word ptr GDT_32bitCS+2,ax
	shr	eax,16
	mov	byte ptr GDT_32bitCS+4,al
; вычислить линейный адрес GDT
	xor	eax,eax
	mov	ax,PM_seg
	shl	eax,4
	push	eax
	add	eax,offset GDT
	mov	dword ptr gdtr+2,eax
; загрузить GDT
	lgdt	fword ptr gdtr
; открыть A20 - в этом примере мы будем пользоваться памятью выше 1 Мб
	mov	al,2
	out	92h,al
; отключить прерывания
	cli
; и NMI
	in	al,70h
	or	al,80h
	out	70h,al
; перейти в защищенный режим (пока без страничной адресации)
	mov	eax,cr0
	or	al,1
	mov	cr0,eax
; загрузить CS
	db	66h
	db	0EAh
	dd	offset PM_entry
	dw	SEL_32bitCS


RM_return:
; переключиться в реальный режим с отключением страничной адресации
	mov	eax,cr0
	and	eax,7FFFFFFEh
	mov	cr0,eax
; сбросить очередь и загрузить CS
	db	0EAh
	dw	$+4
	dw	RM_seg
; загрузить остальные регистры
	mov	ax,PM_seg
	mov	ds,ax
	mov	es,ax
; разрешить NMI
	in	al,70h
	and	al,07FH
	out	70h,al
; разрешить другие прерывания
	sti
; подождать нажатия клавиши
	mov	ah,1
	int	21h
; переключиться в текстовый режим
	mov	ax,3
	int	10h
; и завершить программу
	mov	ah,4Ch
	int	21h
RM_seg ends

PM_seg segment para public 'CODE' use32
	assume	cs:PM_seg
; таблица глобальных дескрипторов
GDT	label	byte
		db	8 dup(0)
GDT_flatDS	db	0FFh,0FFh,0,0,0,10010010b,11001111b,0
GDT_16bitCS	db	0FFh,0FFh,0,0,0,10011010b,0,0
GDT_32bitCS	db	0FFh,0FFh,0,0,0,10011010b,11001111b,0
gdt_size = $-GDT
gdtr	dw	gdt_size-1	; ее лимит
	dd	?		; и адрес
SEL_flatDS equ	001000b ; селектор 4-гигабайтного сегмента данных
SEL_16bitCS equ	010000b ; селектор сегмента кода RM_seg
SEL_32bitCS equ	011000b ; селектор сегмента кода PM_seg

; точка входа в 32-битный защищенный режим
PM_entry:
; загрузить сегментные регистры, включая стек
	xor	eax,eax
	mov	ax,SEL_flatDS
	mov	ds,ax
	mov	es,ax
; создать каталог страниц
	mov	edi,00100000h	; его физический адрес - 1 Мб
	mov	eax,00101007h	; адрес таблицы 0 = 1 Мб + 4 Кб
	stosd			; записать первый элемент каталога
	mov	ecx,1023	; остальные элементы каталога -
	xor	eax,eax	;нули
	rep stosd
; заполнить таблицу страниц 0
	mov	eax,00000007h	; 0 - адрес страницы 0
	mov	ecx,1024	; число страниц в таблице
	page_table:
	stosd			; записать элемент таблицы
	add	eax,00001000h	; добавить к адресу 4096 байтов
	loop page_table		; и повторить для всех элементов
; поместить адрес каталога страниц в CR3
	mov	eax,00100000h	; базовый адрес = 1 Мб
	mov	cr3,eax
; включить страничную адресацию,
	mov	eax,cr0
	or	eax,80000000h
	mov	cr0,eax
; а теперь изменить физический адрес страницы A1000h на A2000h
	mov	eax,000A2007h
	mov	es:00101000h+0A1h*4,eax
; если закомментировать предыдущие две команды, следующие четыре команды 
; закрасят весь экран синим цветом, но из-за того, что мы переместили одну 
; страницу, остается черный участок
	mov	ecx,(320*200)/4	; размер экрана в двойных словах
	mov	edi,0A0000h		; линейный адрес начала видеопамяти
	mov	eax,01010101h	; код синего цвета в VGA - 1
	rep stosd
; вернуться в реальный режим
	db	0EAh
	dd	offset RM_return
	dw	SEL_16bitCS
PM_seg ends

; Сегмент стека - используется как 16-битный
stack_seg segment para stack 'STACK'
stack_start	db	100h dup(?)
stack_seg ends
	end start
