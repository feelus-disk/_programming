; pm1.asm
; Программа, демонстрирующая работу с сегментами в защищенном режиме,
; переключается в модель flat, выполняет вывод на экран и возвращается в DOS
;
; Компиляция:
; TASM:
;  tasm /m pm1.asm
;  tlink /x /3 pm1.obj
; MASM:
;  ml /c pm1.asm
;  link pm1.obj,,NUL,,,
; WASM:
;  wasm pm1.asm
;  wlink file pm1.obj form DOS

	.386p		; 32-битный защищенный режим появился в 80386

; 16-битный сегмент, в котором находится код для входа и выхода из защищенного 
; режима
RM_seg segment para public 'code' use16
	assume CS:RM_seg,SS:RM_stack
start:
; подготовить сегментные регистры
	push	cs
	pop	ds
; проверить, не находимся ли мы уже в PM
	mov	eax,cr0
	test	al,1
	jz	no_V86
; сообщить и выйти
	mov	dx,offset v86_msg
err_exit:
	mov	ah,9
	int	21h
	mov	ah,4Ch
	int	21h
v86_msg db	"Running in V86 mode. Can't switch to PM$"
win_msg db	"Runnind under Windows. Can't switch to ring 0$"

; может быть, это Windows 95 делает вид, что PE = 0?
no_V86:
	mov	ax,1600h		; Функция 1600h
	int	2Fh			; прерывания мультиплексора,
	test	al,al			; если AL = 0,
	jz	no_windows		; Windows не запущена
; сообщить и выйти, если мы под Windows
	mov	dx,offset win_msg
	jmp short err_exit

; итак, мы точно находимся в реальном режиме
no_windows:
; если мы собираемся работать с 32-битной памятью, стоит открыть A20
	in	al,92h
	or	al,2
	out	92h,al
; вычислить линейный адрес метки PM_entry
	xor	eax,eax
	mov	ax,PM_seg		; AX - сегментный адрес PM_seg
	shl	eax,4			; EAX - линейный адрес PM_seg
	add	eax,offset PM_entry ; EAX - линейный адрес PM_entry
	mov	dword ptr pm_entry_off,eax ; сохранить его
; вычислить базу для GDT_16bitCS и GDT_16bitDS
	xor	eax,eax
	mov	ax,cs			; AX - сегментный адрес RM_seg
	shl	eax,4			; EAX - линейный адрес RM_seg
	push	eax
	mov	word ptr GDT_16bitCS+2,ax	; биты 15 - 0
	mov	word ptr GDT_16bitDS+2,ax
	shr	eax,16
	mov	byte ptr GDT_16bitCS+4,al	; и биты 23 - 16
	mov	byte ptr GDT_16bitDS+4,al 
; вычислить абсолютный адрес метки GDT
	pop	eax			; EAX - линейный адрес RM_seg
	add	ax,offset GDT	; EAX - линейный адрес GDT
	mov	dword ptr gdtr+2,eax	; записать его для GDTR
; загрузить таблицу глобальных дескрипторов
	lgdt	fword ptr gdtr
; запретить прерывания
	cli
; запретить немаскируемое прерывание
	in	al,70h
	or	al,80h
	out	70h,al
; переключиться в защищенный режим
	mov	eax,cr0
	or	al,1
	mov	cr0,eax
; загрузить новый селектор в регистр CS
	db	66h		; префикс изменения разрядности операнда
	db	0EAh		; код команды дальнего jmp
pm_entry_off dd	?	; 32-битное смещение
	dw	SEL_flatCS	; селектор


RM_return:	; сюда передается управление при выходе из защищенного режима
; переключиться в реальный режим
	mov	eax,cr0
	and	al,0FEh
	mov	cr0,eax
; сбросить очередь предвыборки и загрузить CS реальным сегментным адресом
	db	0EAh	; код дальнего jmp
	dw	$+4	; адрес следующей команды
	dw	RM_seg	; сегментный адрес RM_seg
; разрешить NMI
	in	al,70h
	and	al,07FH
	out	70h,al
; разрешить другие прерывания
	sti
; подождать нажатия любой клавиши
	mov	ah,0
	int	16h
; выйти из программы
	mov	ah,4Ch
	int	21h

; текст сообщения с атрибутами, который мы будем выводить на экран
message	db	'H',7,'e',7,'l',7,'l',7,'o',7,' ',7,'f',7
	db	'r',7,'o',7,'m',7,' ',7,'3',7,'2',7,'b',7
	db	'i',7,'t',7,' ',7,'P',7,'M',7
message_l = $-message			; длина в байтах
rest_scr = (80*25*2-message_l)/4	; длина оставшейся части экрана в 
; двойных словах
; таблица глобальных дескрипторов
GDT	label	byte
; нулевой дескриптор (обязательно должен быть на первом месте)
		db	8 dup(0)
; 4 Гб код, DPL = 00:
GDT_flatCS	db	0FFh,0FFh,0,0,0,10011010b,11001111b,0
; 4 Гб данные, DPL = 00:
GDT_flatDS	db	0FFh,0FFh,0,0,0,10010010b,11001111b,0
; 64-килобайтный код, DPL = 00:
GDT_16bitCS	db 0FFh,0FFh,0,0,0,10011010b,0,0
; 64-килобайтные данные, DPL = 00:
GDT_16bitDS	db 0FFh,0FFh,0,0,0,10010010b,0,0
GDT_l = $-GDT		; размер GDT

gdtr	dw	GDT_l-1	; 16-битный лимит GDT
	dd	?	; здесь будет 32-битный линейный адрес GDT

; названия для селекторов (все селекторы для GDT, с RPL = 00)
SEL_flatCS equ	00001000b
SEL_flatDS equ	00010000b
SEL_16bitCS equ	00011000b
SEL_16bitDS equ	00100000b

RM_seg ends

; 32-битный сегмент, содержащий код, который будет исполняться в защищенном 
; режиме
PM_seg segment para public 'CODE' use32
	assume	cs:PM_seg
PM_entry:
; загрузить сегментные регистры (кроме SS для простоты)
	mov	ax,SEL_16bitDS
	mov	ds,ax
	mov	ax,SEL_flatDS
	mov	es,ax
; вывод на экран
	mov	esi,offset message	; DS:ESI - сообщение
	mov	edi,0B8000h			; ES:EDI - видеопамять
	mov	ecx,message_l		; ECX - длина
	rep movsb			; вывод на экран
	mov	eax,07200720h	; два символа 20h с атрибутами 07
	mov	ecx,rest_scr	; остаток экрана / 2
	rep stosd			; очистить остаток экрана
; загрузить в CS селектор 16-битного сегмента RM_seg
	db	0EAh			; код дальнего jmp
	dd	offset RM_return	; 32-битное смещение
	dw	SEL_16bitCS		; селектор
PM_seg	ends

; сегмент стека - используется как в 16-битном, так и в 32-битном режимах;
; так как мы не трогали SS, он все время оставался 16-битным
RM_stack segment para stack 'STACK' use16
	db	100h dup(?)
RM_stack ends
	end	start
