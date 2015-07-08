; picinit.asm
; Выполняет полную инициализацию обоих контроллеров прерываний
; с отображением прерываний IRQ0 - IRQ7 на векторы INT 50h - 57h
; Программа остается резидентной и издает короткий звук после каждого IRQ1
;
; Восстановление старых обработчиков прерываний и переинициализация 
; контроллера в прежнее состояние опущены
;
; Компиляция:
; TASM:
;  tasm /m picinit.asm
;  tlink /t /x picinit.obj
; MASM:
;  ml /c picinit.asm
;  link picinit.obj,,NUL,,,
;  exe2bin picinit.exe picinit.com
; WASM:
;  wasm picinit.asm
;  wlink file picinit.obj form DOS COM
;

	.model	tiny
	.code
org	100h		; COM-программа

PIC1_BASE	equ	50h	; на этот адрес процедура pic_init перенесет
				; IRQ0 - IRQ7
PIC2_BASE	equ	70h	; на этот адрес процедура pic_init перенесет
				; IRQ8 - IRQ15

start:
	jmp end_of_resident	; переход на начало инсталляционной 
				; части

irq0_handler: ; обработчик IRQ0 (прерывания от системного таймера)
	push	ax
	in	al,61h
	and	al,11111100b	; выключение динамика
	out	61h,al
	pop	ax
	int	08h		; старый обработчик IRQ0
	iret		; он послал EOI, так что завершить простым iret
irq1_handler:		; обработчик IRQ1 (прерывание от клавиатуры)
	push	ax
	in	al,61h
	or	al,00000011b	; включение динамика
	out	61h,al
	pop	ax
	int	09h			; старый обработчик IRQ1
	iret
irq2_handler:			; и так далее
	int	0Ah
	iret
irq3_handler:
	int	0Bh
	iret
irq4_handler:
	int	0Ch
	iret
irq5_handler:
	int	0Dh
	iret
irq6_handler:
	int	0Eh
	iret
irq7_handler:
	int	0Fh
	iret

end_of_resident:		; конец резидентной части
	call	hook_pic1_ints	; установка наших обработчиков
				; INT 50h - 57h
	call	init_pic	; переинициализация контроллера прерываний
	mov	dx,offset end_of_resident
	int	27h		; оставить наши новые обработчики резидентными

; процедура init_pic
; выполняет инициализацию обоих контроллеров прерываний,
; отображая IRQ0 - IRQ7 на PIC1_BASE - PIC1_BASE+7,
; а IRQ8 - IRQ15 на PIC2_BASE - PIC2_BASE+7
; для возврата в стандартное состояние вызвать с 
; PIC1_BASE = 08h
; PIC2_BASE = 70h
init_pic	proc	near
	cli
	mov	al,00010101b	; ICW1
	out	20h,al
	out	0A0h,al
	mov	al,PIC1_BASE	; ICW2 для первого контроллера
	out	21h,al
	mov	al,PIC2_BASE	; ICW2 для второго контроллера
	out	0A1h,al
	mov	al,04h		; ICW3 для первого контроллера
	out	21h,al
	mov	al,02h		; ICW3 для второго контроллера 
	out	0A1h,al
	mov	al,00001101b	; ICW4 для первого контроллера 
	out	21h,al
	mov	al,00001001b	; ICW4 для второго контроллера 
	out	0A1h,al
	sti
	ret
init_pic	endp

; перехват прерываний от PIC1_BASE до PIC1_BASE+7
hook_pic1_ints	proc near
	mov	ax,2500h+PIC1_BASE
	mov	dx,offset irq0_handler
	int	21h
	mov	ax,2501h+PIC1_BASE
	mov	dx,offset irq1_handler
	int	21h
	mov	ax,2502h+PIC1_BASE
	mov	dx,offset irq2_handler
	int	21h
	mov	ax,2503h+PIC1_BASE
	mov	dx,offset irq3_handler
	int	21h
	mov	ax,2504h+PIC1_BASE
	mov	dx,offset irq4_handler
	int	21h
	mov	ax,2505h+PIC1_BASE
	mov	dx,offset irq5_handler
	int	21h
	mov	ax,2506h+PIC1_BASE
	mov	dx,offset irq6_handler
	int	21h
	mov	ax,2507h+PIC1_BASE
	mov	dx,offset irq7_handler
	int	21h
	ret
hook_pic1_ints	endp

	end start
