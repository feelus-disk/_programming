; pm2.asm
; Программа, демонстрирующая обработку аппаратных прерываний в защищенном 
; режиме, переключается в 32-битный защищенный режим и позволяет набирать 
; текст при помощи клавиш от 1 до +. Нажатие Backspace стирает предыдущий 
; символ, нажатие Esc - выход из программы.
;
; Компиляция TASM:
;	tasm /m /D_TASM_ pm2.asm
; (или, для версий 3.x, достаточно tasm /m pm2.asm)
;	tlink /x /3 pm2.obj
; Компиляция WASM:
;	wasm /D pm2.asm
;	wlink file pm2.obj form DOS

; Варианты того, как разные ассемблеры записывают смещение из 32-битного
; сегмента в 16-битную переменную
ifdef _TASM_
so	equ	small offset		; TASM 4.x
else
so	equ	offset			; WASM
endif
; для MASM, по-видимому, придется добавлять лишний код, который преобразует 
; смещения, используемые в IDT

	.386p
RM_seg segment para public 'CODE' use16
	assume cs:RM_seg,ds:PM_seg,ss:stack_seg
start:
; очистить экран
	mov	ax,3
	int	10h
; подготовить сегментные регистры
	push	PM_seg
	pop	ds
; проверить, не находимся ли мы уже в PM
	mov	eax,cr0
	test	al,1
	jz	no_V86
; сообщить и выйти
	mov	dx,so v86_msg
err_exit:
	mov	ah,9
	int	21h
	mov	ah,4Ch
	int	21h
; может быть, это Windows 95 делает вид, что PE = 0?
no_V86:
	mov	ax,1600h
	int	2Fh
	test	al,al
	jz	no_windows
; сообщить и выйти
	mov	dx,so win_msg
	jmp short err_exit

; итак, мы точно находимся в реальном режиме
no_windows:
; вычислить базы для всех используемых дескрипторов сегментов
	xor	eax,eax
	mov	ax,RM_seg
	shl	eax,4
	mov	word ptr GDT_16bitCS+2,ax ; базой 16bitCS будет RM_seg
	shr	eax,16
	mov	byte ptr GDT_16bitCS+4,al
	mov	ax,PM_seg
	shl	eax,4
	mov	word ptr GDT_32bitCS+2,ax ; базой всех 32bit* будет
	mov	word ptr GDT_32bitSS+2,ax	; PM_seg
	mov	word ptr GDT_32bitDS+2,ax
	shr	eax,16
	mov	byte ptr GDT_32bitCS+4,al
	mov	byte ptr GDT_32bitSS+4,al
	mov	byte ptr GDT_32bitDS+4,al
; вычислить линейный адрес GDT
	xor	eax,eax
	mov	ax,PM_seg
	shl	eax,4
	push	eax
	add	eax,offset GDT
	mov	dword ptr gdtr+2,eax
; загрузить GDT
	lgdt	fword ptr gdtr
; вычислить линейный адрес IDT
	pop	eax
	add	eax,offset IDT
	mov	dword ptr idtr+2,eax
; загрузить IDT
	lidt	fword ptr idtr
; если мы собираемся работать с 32-битной памятью, стоит открыть A20
	in	al,92h
	or	al,2
	out	92h,al
; отключить прерывания
	cli
; включая NMI,
	in	al,70h
	or	al,80h
	out	70h,al
; перейти в PM
	mov	eax,cr0
	or	al,1
	mov	cr0,eax
; загрузить SEL_32bitCS в CS
	db	66h
	db	0EAh
	dd	offset PM_entry
	dw	SEL_32bitCS


RM_return:
; перейти в RM
	mov	eax,cr0
	and	al,0FEh
	mov	cr0,eax
; сбросить очередь и загрузить CS реальным числом
	db	0EAh
	dw	$+4
	dw	RM_seg
; установить регистры для работы в реальном режиме
	mov	ax,PM_seg
	mov	ds,ax
	mov	es,ax
	mov	ax,stack_seg
	mov	bx,stack_l
	mov	ss,ax
	mov	sp,bx
; загрузить IDTR для реального режима
	mov	ax,PM_seg
	mov	ds,ax
	lidt	fword ptr idtr_real
; разрешить NMI
	in	al,70h
	and	al,07FH
	out	70h,al
; разрешить прерывания
	sti
; и выйти
	mov	ah,4Ch
	int	21h
RM_seg ends

; 32-битный сегмент
PM_seg segment para public 'CODE' use32
	assume	cs:PM_seg

; таблицы GDT и IDT должны быть выровнены, так что будем их размещать в 
; начале сегмента
GDT	label	byte
		db	8 dup(0)
; 32-битный 4-гигабайтный сегмент с базой = 0
GDT_flatDS	db	0FFh,0FFh,0,0,0,10010010b,11001111b,0
; 16-битный 64-килобайтный сегмент кода с базой RM_seg
GDT_16bitCS	db	0FFh,0FFh,0,0,0,10011010b,0,0
; 32-битный 4-гигабайтный сегмент сода с базой PM_seg
GDT_32bitCS	db	0FFh,0FFh,0,0,0,10011010b,11001111b,0
; 32-битный 4-гигабайтный сегмент данных с базой PM_seg
GDT_32bitDS	db	0FFh,0FFh,0,0,0,10010010b,11001111b,0
; 32-битный 4-гигабайтный сегмент данных с базой stack_seg
GDT_32bitSS	db	0FFh,0FFh,0,0,0,10010010b,11001111b,0
gdt_size = $-GDT
gdtr	dw	gdt_size-1	; лимит GDT
	dd	?		; линейный адрес GDT
; имена для селекторов
SEL_flatDS equ	001000b
SEL_16bitCS equ	010000b
SEL_32bitCS equ	011000b
SEL_32bitDS equ 100000b
SEL_32bitSS equ 101000b

; таблица дескрипторов прерываний IDT
IDT	label	byte
; все эти дескрипторы имеют тип 0Eh - 32-битный шлюз прерывания
; INT 00 - 07
	dw	8 dup(so int_handler,SEL_32bitCS,8E00h,0)
; INT 08 (irq0)
	dw	so irq0_7_handler,SEL_32bitCS,8E00h,0
; INT 09 (irq1)
	dw	so irq1_handler,SEL_32bitCS,8E00h,0
; INT 0Ah - 0Fh (IRQ2 - IRQ8)
	dw	6 dup(so irq0_7_handler,SEL_32bitCS,8E00h,0)
; INT 10h - 6Fh
	dw	97 dup(so int_handler,SEL_32bitCS,8E00h,0)
; INT 70h - 78h (IRQ8 - IRQ15)
	dw	8 dup(so irq8_15_handler,SEL_32bitCS,8E00h,0)
; INT 79h - FFh
	dw	135 dup(so int_handler,SEL_32bitCS,8E00h,0)
idt_size = $-IDT			; размер IDT
idtr	dw	idt_size-1		; лимит IDT
	dd	?			; линейный адрес начала IDT
; содержимое регистра IDTR в реальном режиме
idtr_real dw	3FFh,0,0

; сообщения об ошибках при старте
v86_msg	db	"Running in V86 mode. Can't switch to PM$"
win_msg db	"Runnind under Windows. Can't switch to ring 0$"

; таблица для перевода 0E скан-кодов в ASCII
scan2ascii	db	0,1Bh,'1','2','3','4','5','6','7','8','9','0','-','=',8
screen_addr	dd	0	; текущая позиция на экране

; точка входа в 32-битный защищенный режим
PM_entry:
; установить 32-битный стек и другие регистры
	mov	ax,SEL_flatDS
	mov	ds,ax
	mov	es,ax
	mov	ax,SEL_32bitSS
	mov	ebx,stack_l
	mov	ss,ax
	mov	esp,ebx
; разрешить прерывания
	sti
; и войти в вечный цикл
	jmp short $

; обработчик обычного прерывания
int_handler:
	iretd
; обработчик аппаратного прерывания IRQ0 - IRQ7
irq0_7_handler:
	push	eax
	mov	al,20h
	out	20h,al
	pop	eax
	iretd
; обработчик аппаратного прерывания IRQ8 - IRQ15
irq8_15_handler:
	push	eax
	mov	al,20h
	out	0A1h,al
	pop	eax
	iretd
; обработчик IRQ1 - прерывания от клавиатуры
irq1_handler:
	push	eax	; это аппаратное прерывание - сохранить регистры
	push	ebx
	push	es
	push	ds
	in	al,60h		; прочитать скан-код нажатой клавиши,
	cmp	al,0Eh		; если он больше, чем максимальный 
	ja	skip_translate	; обслуживаемый нами, - не обрабатывать,
	cmp	al,1			; если это Esc,
	je	esc_pressed		; выйти в реальный режим,
	mov	bx,SEL_32bitDS	; иначе:
	mov	ds,bx		; DS:EBX - таблица для перевода скан-кода
	mov	ebx,offset scan2ascii	; в ASCII
	xlatb			; преобразовать
	mov	bx,SEL_flatDS
	mov	es,bx				; ES:EBX - адрес текущей 
	mov	ebx,screen_addr		; позиции на экране, 
	cmp	al,8		; если не была нажата Backspace,
	je	bs_pressed
	mov	es:[ebx+0B8000h],al	; послать символ на экран,
	add	dword ptr screen_addr,2	; увеличить адрес позиции на 2,
	jmp short skip_translate
bs_pressed:			; иначе:
	mov	al,' '	; нарисовать пробел
	sub	ebx,2		; в позиции предыдущего символа
	mov	es:[ebx+0B8000h],al
	mov	screen_addr,ebx	; и сохранить адрес предыдущего символа 
skip_translate:			; как текущий 
; разрешить работу клавиатуры
	in	al,61h
	or	al,80h
	out	61h,al
; послать EOI контроллеру прерываний
	mov	al,20h
	out	20h,al
; восстановить регистры и выйти
	pop	ds
	pop	es
	pop	ebx
	pop	eax
	iretd

; сюда передается управление из обработчика IRQ1, если нажата Esc
esc_pressed:
; разрешить работу клавиатуры, послать EOI и восстановить регистры
	in	al,61h
	or	al,80h
	out	61h,al
	mov	al,20h
	out	20h,al
	pop	ds
	pop	es
	pop	ebx
	pop	eax
; вернуться в реальный режим
	cli
	db	0EAh
	dd	offset RM_return
	dw	SEL_16bitCS
PM_seg ends

; Сегмент стека. Используется как 16-битный в 16-битной части программы и как 
; 32-битный (через селектор SEL_32bitSS) в 32-битной части.
stack_seg segment para stack 'STACK'
stack_start	db	100h dup(?)
stack_l = $-stack_start	; длина стека для инициализации ESP
stack_seg ends
	end start
