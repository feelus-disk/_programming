; ungetch.asm
; заносит в буфер клавиатуры команду DIR так, чтобы она выполнилась сразу после
; завершения программы
;
; Компиляция:
; TASM:
;  tasm /m ungetch.asm
;  tlink /t /x ungetch.obj
; MASM:
;  ml /c ungetch.asm
;  link ungetch.obj,,NUL,,,
;  exe2bin ungetch.exe ungetch.com
; WASM:
;  wasm ungetch.asm
;  wlink file ungetch.obj form DOS COM
;

	.model	tiny
	.code
	org	100h	; COM-файл
start:
	mov	cl,'d'	; CL = ASCII-код буквы "d"
	call	ungetch
	mov	cl,'i'	; ASCII-код буквы "i"
	call	ungetch
	mov	cl,'r'	; ASCII-код буквы "r"
	call	ungetch
	mov	cl,0Dh	; перевод строки
ungetch:
	mov	ah,5	; AH = номер функции
	mov	ch,0	; CH = 0 (скан-код неважен)
	int	16h	; поместить символ в буфер
	ret		; завершить программу

	end	start
