; prtscr.asm
; распечатать содержимое экрана на принтере
;
; Компиляция:
; TASM:
;  tasm /m prtscr.asm
;  tlink /t /x prtscr.obj
; MASM:
;  ml /c prtscr.asm
;  link prtscr.obj,,NUL,,,
;  exe2bin prtscr.exe prtscr.com
; WASM:
;  wasm prtscr.asm
;  wlink file prtscr.obj form DOS COM
;

	.model	tiny
	.code
	.186		; для команды push 0B800h
	org	100h	; начало COM-фала
start:
	mov	ah,1
	mov	dx,0		; порт LPT1
	int	17h		; инициализировать принтер,
	cmp	ah,90h		; если принтер не готов,
	jne	printer_error	; выдать сообщение об ошибке,
	push	0B800h		; иначе:
	pop	ds		; DS = сегмент видеопамяти в текстовом режиме
	xor	si,si		; SI = 0
	mov	cx,80*40	; CX = число символов на экране
	cld			; строковые операции вперед
main_loop:
	lodsw			; AL - символ, AH - атрибут, SI = SI + 2
	mov	ah,0		; AH - номер функции
	int	17h		; вывод символа из AL на принтер
	loop	main_loop
	ret			; закончить программу

printer_error:
	mov	dx,offset msg	; адрес сообщения об ошибке в DS:DX
	mov	ah,9
	int	21h		; вывод строки на экран
	ret

msg	db	'printer on LPT1 busy or offline$'
	end	start

