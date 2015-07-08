; latency.asm
; измеряет среднее время, проходящее между аппаратным прерыванием и запуском 
; соответствующего обработчика. Выводит среднее время в микросекундах после 
; нажатия любой клавиши (на самом деле в 1/1 193 180)
; Программа использует 16-битный сумматор для простоты, так что может давать 
; неверные результаты, если подождать больше нескольких минут
;
; Компиляция:
; TASM:
; tasm /m latency.asm
; tlink /t /x latency.obj
; MASM:
; ml /c latency.asm
; link latency.obj,,NUL,,,
; exe2bin latency.exe latency.com
; WASM:
; wasm latency.asm
; wlink file latency.obj form DOS COM
;

	.model tiny
	.code
	.386		; для команды shld
	org	100h	; COM-программа
start:
	mov	ax,3508h	; AH = 35h, AL = номер прерывания
	int	21h		; получить адрес обработчика
	mov	word ptr old_int08h,bx	; и записать его в old_int08h
	mov	word ptr old_int08h+2,es
	mov	ax,2508h	; AH = 25h, AL = номер прерывания
	mov	dx,offset int08h_handler ; DS:DX - адрес обработчика
	int	21h		; установить обработчик
; с этого момента в переменной latency накапливается сумма
	mov	ah,0
	int	16h		; пауза до нажатия любой клавиши

	mov	ax,word ptr latency	; сумма в AX
	cmp	word ptr counter,0 ; если клавишу нажали немедленно,
	jz	dont_divide		; избежать деления на ноль
	xor	dx,dx			; DX = 0
	div	word ptr counter	; разделить сумму на число накоплений
dont_divide:
	call	print_ax		; и вывести на экран

	mov	ax,2508h		; AH = 25h, AL = номер прерывания
	lds	dx,dword ptr old_int08h	; DS:DX = адрес обработчика
	int	21h			; восстановить старый обработчик
	ret				; конец программы

latency	dw	0		; сумма задержек
counter	dw	0		; число вызовов прерывания

; Обработчик прерывания 08h (IRQ0)
; определяет время, прошедшее с момента срабатывания IRQ0
int08h_handler	proc	far
	push	ax	; сохранить используемый регистр
	mov	al,0	; фиксация значения счетчика в канале 0
	out	43h,al	; порт 43h: управляющий регистр таймера
; так как этот канал инициализируется BIOS для 16-битного чтения/записи, другие 
; команды не требуются
	in	al,40h		; младший байт счетчика
	mov	ah,al		; в AH
	in	al,40h		; старший байт счетчика в AL
	xchg	ah,al		; поменять их местами
	neg	ax		; обратить его знак, так как счетчик уменьшается,
	add	word ptr cs:latency,ax	; добавить к сумме
	inc	word ptr cs:counter	; увеличить счетчик накоплений
	pop	ax
	db	0EAh		; команда jmp far
old_int08h	dd	0	; адрес старого обработчика
int08h_handler	endp

; процедура print_ax
; выводит AX на экран в шестнадцатеричном формате
print_ax proc near
	xchg	dx,ax		; DX = AX
	mov	cx,4		; число цифр для вывода
shift_ax:
	shld	ax,dx,4		; получить в AL очередную цифру
	rol	dx,4		; удалить ее из DX
	and	al,0Fh		; оставить в AL только эту цифру
	cmp	al,0Ah		; три команды, переводящие
	sbb	al,69h		; шестнадцатеричную цифру в AL
	das			; в соответствующий ASCII-код
	int	29h		; вывод на экран
	loop	shift_ax	; повторить для всех цифр
	ret
print_ax endp
	end start
