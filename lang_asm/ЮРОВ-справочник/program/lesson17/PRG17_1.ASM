;prg17_1.asm
.386P	;разрешение инструкций i386
.MODEL large
;макрос визуализации регистров al, ah, ax или eax
include	show.inc
include	mac.inc
;структура для описания дескрипторов сегментов
descr	STRUC
limit	dw	0
base_1	dw	0
base_2	db	0
attr	db	0
lim_atr	db	0
base_3	db	0
	ENDS
;макрос инициализации дескрипторов
load_descr	MACRO	des,seg_addr,seg_size
	mov	des.limit,seg_size
	xor	eax,eax
	mov	ax,seg_addr
	shl	eax,4
	mov	des.base_1,ax
	rol	eax,16
	mov	des.base_2,al
	ENDM
atr	MACRO	descr,bit1,bit2,bit3
	atr_&descr=constp or bit1 or bit2 or bit3
	ENDM
;структура для описания псевдодескриптора gdtr и idtr
point	STRUC
lim	dw	0
adr	dd	0
	ENDS
;структура для описания дескрипторов таблицы idt
descr_idt	STRUC
offs_1	dw	0
sel	dw	30h	;селектор сегмента команд в таблице GDT
no_use	db	0
type_attr	db	8eh	;шлюз прерывания
offs_2	dw	0
	ENDS

;атрибуты для описания дескрипторов сегментов
constp	equ	10010000b
code_r_n	equ	00010000b
code_r_y	equ	00000010b
data_wm_n	equ	00000000b
data_wm_y	equ	00000010b
code_n	equ	00000000b
code_p	equ	00000100b
data_	equ	00000000b
stack_	equ	00000000b
code_	equ	00001000b
data_stk	equ	00000000b

stk	segment	stack 'stack' 
	db	256 dup (0)
stk	ends

;сегмент с таблицей глобальных дескрипторов
gdt_seg	segment	para public 'data' use16
gdt_0	descr	<0,0,0,0,0,0>
atr	gdt_gdt_8,data_wm_y,data_,data_stk
;описывает саму GDT
gdt_gdt_8	descr	<0,0,0,atr_gdt_gdt_8,0,0>
gdt_ldt_10	descr	<0,0,0,0,0,0>	;не используем
atr	gdt_ds_18,data_wm_y,data_,data_stk
;дескриптор сегмента данных
gdt_ds_18	descr	<0,0,0,atr_gdt_ds_18,0,0>
atr	gdt_vbf_20,data_wm_y,data_,data_stk
gdt_es_vbf_20	descr	<0,0,0,atr_gdt_vbf_20,0,0>	;видеобуфер
atr	gdt_ss_28,data_wm_y,stack_,data_stk
gdt_ss_28	descr	<0,0,0, atr_gdt_ss_28,0,0>	;сегмент стека
atr	gdt_cs_30,code_r_y,code_n,code_
gdt_cs_30	descr	<0,0,0,atr_gdt_cs_30,0,0>	;сегмент кода
atr	gdt_sirena_38,code_r_y,code_n,code_
gdt_sirena_38	descr	<0,0,0,atr_gdt_sirena_38,0,0>
gdt_size=$-gdt_0-1	;размер GDT минус 1
gdt_seg	ends

idt_seg	segment	para public 'data' use16
int00h	descr_idt	<dummy,,,,>
	REPT		2
	descr_idt	<dummy,,,,>
	ENDM
int03h	descr_idt	<int_03h,,,,>
	descr_idt	<dummy,,,,>
int05h	descr_idt	<int_05h,,,,>
	REPT	7
	descr_idt	<dummy_err,,,,>
	ENDM
int0dh	descr_idt	<int_0dh,,,,>
	REPT	3
	descr_idt	<dummy,,,,>
	ENDM
int11h	descr_idt	<dummy_err,,,,>
	REPT	14
	descr_idt	<dummy,,,,>
	ENDM
int20h	descr_idt	<new_08h,,,,>
int21h	descr_idt	<sirena,38h,,,>
	REPT	222
	descr_idt	<dummy,,,,>
	ENDM
idt_size=$-int00h-1
idt_seg	ends

;данные программы
data	segment	para public 'data' use16	;сегмент данных
point_gdt	point	<gdt_size,0>
point_idt	point	<idt_size,0>
char	db	'0'
maskf	db	07h
position	dw	2000
tonelow	dw	2651	;нижняя граница звучания 450 Гц
cnt	db	0	;счётчик для выхода из программы
temp	dw	?	;верхняя граница звучания
min_index	dw	0
max_index	dw	99
data_size=$-point_gdt-1
data	ends

SOUND	SEGMENT	byte private use16
	assume	cs:SOUND,ds:DATA,ss:STK
sirena	PROC		;пользовательское прерывание
	push	ds
	push	ax
	push	cx
	push	dx
go:
;заносим слово состояния 10110110b(0В6h) в командный регистр (порт 43h)
	mov	al,0B6h
	out	43h,al
	in	al,61h	;получим значение порта 61h в al
	or	al,3	;инициализируем динамик и подаем ток в порт 61h
	out	61h,al
	mov	cx,2083	;количество шагов ступенчатого изменения тона
musicup:
;в ax значение нижней границы частоты 
	mov	ax,tonelow
	out	42h,al	;в порт 42h младшее слово ax :al
	xchg	al,ah	;обмен между al и ah
	out	42h,al	;в порт 42h старшее слово ax:ah
	add	tonelow,1	;повышаем тон
	delay 1	;задержка на 1 мкс
	mov	dx,tonelow	;в dx текущее значение высоты
	mov	temp,dx	;temp - верхнее значение высоты 
	loop	musicup	;повторить цикл повышения
	mov	cx,2083	; восстановить счетчик цикла
musicdown:
	mov	ax,temp	;в ax верхнее значение высоты
	out	42h,al	;в порт 42h младшее слово ax :al
	mov	al,ah	;обмен между al и ah
	out	42h,al;в порт 42h старшее слово ax :ah
	sub	temp,1	;понижаем высоту
	delay 1	;задержка на 1 мкс
	loop musicdown	;повторить цикл понижения
nosound:
	in	al,61h	;получим значение порта 61h в AL
	and	al,0FCh	;выключить динамик
	out	61h,al	;в порт 61h
	mov	dx,2651	;для последующих циклов
	mov	tonelow,dx
	inc	cnt	;увеличиваем счётчик проходов, то есть 
;количество звучаний сирены
	cmp	cnt,5	;5 раз ? 

	jne	go	;если нет - идти на метку go
	pop	dx
	pop	cx
	pop	ax
	pop	ds
	mov	bp,sp
	mov	eax,[bp]
	show	eax,0
	mov	eax,[bp+4]
	show	eax,160
	mov	eax,[bp+8]
	show	eax,320
	db	66h
	iret
	endp
sound_size=$-sirena-1
sound	ends

code	segment	byte public 'code' use16
;сегмент кода с 16-разрядным режимом адресации
	assume	cs:code,ss:stk
dummy	proc	;исключения без кода ошибки
	mov	ax,0ffffh
	db	66h
	iret
	endp
dummy_err	proc	;исключения с кодом ошибки
	pop	eax	;снимаем со стека код ошибки и на экран
	db	66h
	iret
	endp
int_03h	proc
;для этого исключения не формируется кода ошибки,
;поэтому анализируем содержимое eip в стеке и возвращаемся в программу
	pop	eax
	show	eax,0
	push	eax
	db	66h
	iret
	endp
int_05h	proc	;обработчик для 5-го исключения - команда bound
	mov	al,5
	mov	ah,al
	mov	si,2
	db	66h
	iret
	endp
int_0dh	proc
	pop	eax	;снимаем со стека код ошибки
	sub	bx,4	;исправляем причину возникновения исключения
	db	66h	;возвращаемся обратно и рестарт виноватой команды
	iret
	endp
new_08h	proc	;новое прерывание от таймера
	assume	ds:data
	push	ds
	push	es
	push	ax
	push	bx
	mov	ax,20h
	mov	es,ax
scr:
	mov	al,char
	mov	ah,maskf
	mov	bx,position
	mov	es:[bx],ax
	add	bx,2
	mov	position,bx
	inc	char
	pop	bx
	pop	ax
	pop	es
	pop	ds
	mov	al,20h
	out	20h,al
	db	66h
	iret
	endp
new_8259a	proc
;в al - значение нового базового
;вектора для ведущего контроллера
	push	ax
	mov	al,00010001b
	out	20h,al	;ICW1 в порт 20h
	jmp	$+2
	jmp	$+2	;эадержка, чтобы успела отработать аппаратура
	pop	ax
	out	21h,al	;ICW2 в порт 20h - новый базовый номер
	jmp	$+2
	jmp	$+2	;эадержка, чтобы успела
			;отработать аппаратура
	mov	al,00000100b
	out	21h,al	;ICW3 - ведомый подключается
			;к уровню 2 (см. рис. 15.1)
	jmp	$+2
	jmp	$+2	;эадержка, чтобы успела
			;отработать аппаратура
	mov	al,00000001b
	out	21h,al	;ICW4 - EOI выдает программа пользователя
	ret
	endp
main	proc
	mov	ax,stk
	mov	ss,ax
;заполняем таблицу глобальных дескрипторов
assume	ds:GDT_SEG
	mov	ax,GDT_SEG
	mov	ds,ax
	load_descr	gdt_gdt_8,GDT_SEG,gdt_size
	load_descr	gdt_ds_18,DATA,data_size
	load_descr	gdt_es_vbf_20,0b800h,3999
	load_descr	gdt_ss_28,STK,255
	load_descr	gdt_cs_30,CODE,code_size
	load_descr	gdt_sirena_38,SOUND,sound_size
	assume	ds:data
	mov	ax,data
	mov	ds,ax
;загружаем gdtr
	xor	eax,eax
	mov	ax,GDT_SEG
	shl	eax,4
	mov	point_gdt.adr,eax
	lgdt	point_gdt
;запрещаем прерывания
	cli
	mov	al,80h
	out	70h,al
	mov	al,20h	;новое значение базового вектора
	call	new_8259A
;загружаем idtr
	xor	eax,eax
	mov	ax,IDT_SEG
	shl	eax,4
	mov	point_idt.adr,eax
	lidt	point_idt
;переключаемся в защищенный режим
	mov	eax,cr0
	or	al,1
	mov	cr0,eax
;настраиваем регистры
	db	0eah	;машинный код команды jmp
	dw	offset protect	;смещение метки перехода
			;в сегменте команд
	dw	30h	;селектор сегмента кода в GDT
protect:
;загрузить селекторы для остальных дескрипторов
	mov	ax,18h
	mov	ds,ax
	mov	ax,20h
	mov	es,ax
	mov	ax,28h
	mov	ss,ax
;работаем в защищенном режиме:
;разрешаем прерывания от таймера, наблюдаем
	sti
	delay	3500
	cli
;далее имитируем возникновение двух
;исключительных ситуаций (типа ошибки): 5 и 13
	mov	si,130
	bound	si,dword ptr min_index
	mov	bx,data_size
	mov	ax,[bx]
;а теперь имитируем возникновение исключительной ситуации типа ловушки - 3:
	int	3
;обрабатываем их и в знак успеха запускаем
;из другого сегмента команд сирену
	int	21h
;готовимся к переходу в реальный режим
;прерывания запрещены
;перепрограммируем контроллер
	mov	al,08h
	call	new_8259A
;формирование дескрипторов для реального режима
	assume	ds:GDT_SEG
	mov	ax,8h
	mov	ds,ax
	mov	gdt_ds_18.limit,0ffffh
	mov	gdt_es_vbf_20.limit,0ffffh
	mov	gdt_ss_28.limit,0ffffh
	mov	gdt_cs_30.limit,0ffffh
	assume	ds:DATA
;загрузка теневых дескрипторов
	mov	ax,18h
	mov	ds,ax
	mov	ax,20h
	mov	es,ax
	mov	ax,28h
	mov	ss,ax
	db	0eah
	dw	offset jump
	dw	30h
jump:	mov	eax,cr0
	and	al,0feh
	mov	cr0,eax
	db	0eah
	dw	offset r_mode
	dw	CODE
r_mode:
	mov	ax,DATA
	mov	ds,ax
	mov	ax,STK
	mov	ss,ax
	mov	ax,3ffh
	mov	point_idt.lim,ax
	xor	eax,eax
	mov	point_idt.adr,eax
	lidt	point_idt
;разрешаем прерывания
	sti
	xor	al,al
	out	70h,al
;окончание работы программы (стандартно)
	mov	ax,4C00h
	int	21h
main	ENDP
code_size=$-dummy
code	ends
end	main
