; dosout1.asm
; Выводит на экран все ASCII-символы
;
; Компиляция:
; TASM:
; tasm /m dosout1.asm
; tlink /t /x dosout1.obj
; MASM:
; ml /c dosout1.asm
; link dosout1.obj,,NUL,,,
; exe2bin dosout1.exe dosout1.com
; WASM
; wasm dosout1.asm
; wlink file dosout1.obj form DOS COM
;

	.model	tiny
	.code
	org	100h		; начало COM-файла
start:
	mov	cx,256 	; вывести 256 символов
	mov	dl,0		; первый символ - с кодом 00
	mov	ah,2		; номер функции DOS "вывод символа"
cloop: int	21h		; вызов DOS
	inc	dl		; увеличение DL на 1 - следующий символ,
	test	dl,0Fh	; если DL не кратен 16
	jnz	continue_loop	; продолжить цикл,
	push	dx		; иначе: сохранить текущий символ
	mov	dl,0Dh	; вывести CR
	int	21h
	mov	dl,0Ah	; вывести LF
	int	21h
	pop	dx		; восстановить текущий символ
continue_loop:
	loop	cloop	; продолжить цикл

	ret		; завершение COM-файла
	end	start
