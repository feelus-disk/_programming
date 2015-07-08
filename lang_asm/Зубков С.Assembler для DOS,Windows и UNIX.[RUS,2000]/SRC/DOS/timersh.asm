; timer.asm
; демонстрация перехвата прерывания системного таймера: вывод времени
; в верхнем левом углу экрана с одновременной работой шелла
; 
; Компиляция:
; TASM:
;  tasm /m timer.asm
;  tlink /t /x timer.obj
; MASM:
;  ml /c timer.asm
;  link timer.obj,,NUL,,,
;  exe2bin timer.exe timer.com
; WASM:
;  wasm timer.asm
;  wlink file timer.obj form DOS COM
;
	.model	tiny
	.code
	.186		; для pusha/popa и сдвигов
	org	100h	; COM-программа
start	proc	near

; сохранение адреса предыдущего обработчика прерывания 1Ch
	push es
	mov	ax,351Ch	; AH=35h, AL=номер прерывания
	int	21h
	mov	word ptr old_int1Ch,bx
	mov	word ptr old_int1Ch+2,es
	pop es
; установка нашего обработчика
	mov	ax,251Ch	; AH=25h, AL=номер прерывания
	mov	dx,offset int1Ch_handler ; DS:DX - адрес обработчика
	int	21h		; установить обработчик прерывания 1Ch

; собственно программа
	mov	sp,length_of_program+100h+200h ; переместим стек на 200h после
			; конца программы (дополнтельные 100h - для PSP)
	mov	ah,4Ah
	mov	bx,((length_of_program+100h+200h) shr 4)+1
	int	21h	; освободим всю память после конца программы и стека
; заполним поля EPB, содержащие сегментные адреса
	mov	ax,cs
	mov	word ptr EPB+4,ax	; сегментный адрес командной строки
	mov	word ptr EPB+8,ax	; сегментный адрес первого FCB
	mov	word ptr EPB+0Ch,ax	; сегментный адрес второго FCB

	mov	ax,4B00h		; функция DOS 4Bh
	mov	dx,offset command_com	; адрес ASCIZ-строки с именем command.com
	mov	bx,offset EPB
	int	21h			; исполнить программу
call print_al
; конец программы

; восстановление предыдущего обработчика прерывания 1Ch
	mov	ax,251Ch
	mov	dx,word ptr cs:old_int1Ch+2
	mov	ds,dx
	mov	dx,word ptr cs:old_int1Ch
	int	21h

	int	20h

old_int1Ch dd	?	; здесь хранится адрес предыдущего обработчика
command_com	db	'C:\COMMAND.COM',0	; имя файла
EPB		dw	0000	; использовать текущее окружение
		dw	offset commandline,0	; адрес командной строки
		dw	005Ch,0,006Ch,0	; адреса FCB, переданных нашей программе
commandline	db	01,20h,0Dh

start_position	dw 0	; позиция на экране, в которую выводится время

start	endp

; обработчик для прерывания 1Ch
; выводит текущее время в позиции start_position
;
int1Ch_handler	proc	far
		pusha		; обработчик аппаратного прерывания
		push	es	; должен сохранять ВСЕ регистры
		push	ds

		push	cs	; на входе в обработчик определён только CS
		pop	ds
		mov	ah,02h		; функция 02h прерывания 1Ah:
		int	1Ah		; чтение времени из RTC
		jc	exit_handler	; если часы заняты - в другой раз

					; AL = число часов в BCD формате
		call	bcd2asc		; преобразовать в ASCII символы
		mov	byte ptr output_line[2],ah ; поместить их в строку
		mov	byte ptr output_line[4],al ; output_line

		mov	al,cl		; CL = число минут в BCD формате
		call	bcd2asc
		mov	byte ptr output_line[10],ah
		mov	byte ptr output_line[12],al

		mov	al,dh		; DH = число секунд в BCD формате
		call	bcd2asc
		mov	byte ptr output_line[16],ah
		mov	byte ptr output_line[18],al
	
		mov	cx,output_line_l	; число байт в строке в CX
		push	0B800h
		pop	es			; адрес в видеопамяти
		mov	di,word ptr start_position ; в ES:SI
		mov	si,offset output_line	; адрес строки в DS:DI
		cld
		rep movsb			; скопировать строку
exit_handler:
		pop	ds		; восстановить все регистры
		pop	es
		popa
		jmp	cs:old_int1Ch	; передать управление предыдущему
					; обработчику

; процедура bcd2asc
; преобразует старшую цифру упакованного BCD-числа в AL в ASCII символ в AH,
; а младшую цифру в ASCII символ в AL
bcd2asc		proc	near
		mov	ah,al
		and	al,0Fh		; оставить младшие 4 бита в AL
		shr	ah,4		; сдвинуть старшие 4 бита в AH 
		or	ax,3030h	; преобразовать в ASCII-символы
		ret
bcd2asc		endp


output_line	db	' ',1Fh,'0',1Fh,'0',1Fh,'h',1Fh ; строка " 00h 00:00 "
		db	' ',1Fh,'0',1Fh,'0',1Fh,':',1Fh	; с атрибутом 1Fh
		db	'0',1Fh,'0',1Fh,' ',1Fh		; после каждого символа
output_line_l	equ $-output_line

int1Ch_handler	endp

print_al:
	mov	dh,al
	and	dh,0Fh		; DH - младшие 4 бита
	shr	al,4		; AL - старшие
	call	print_nibble	; вывести старшую цифру
	mov	al,dh		; теперь AL содержит младшие 4 бита
print_nibble:		; процедура вывода 4 бит (шестнадцатеричной цифры)
	cmp	al,10		; три команды, переводящие цифру в AL
	sbb	al,69h		; в соотвествующий ASCII код
	das			; (см. описание команды das)

	mov	dl,al		; код символа в DL
	mov	ah,2		; номер функции DOS в AH 
	int	21h		; вывод символа
	ret		; этот ret работает два раза

length_of_program equ $-start
	end	start
