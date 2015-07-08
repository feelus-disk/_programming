; hello-1.asm
; Выводит на экран сообщение "Hello World!" и завершается
;
; Компиляция:
; TASM:
; tasm /m hello-1.asm
; tlink /t /x hello-1.obj
; MASM:
; ml /c hello-1.asm
; link hello-1.obj,,NUL,,,
; exe2bin hello-1.exe hello-1.com
; WASM
; wasm hello-1.asm
; wlink file hello-1.obj form DOS COM
;

	.model tiny		; модель памяти, используемая для COM
	.code			; начало сегмента кода
	org	100h		; начальное значение счетчика - 100h
start:	mov	ah,9		; номер функции DOS - в AH
	mov	dx,offset message	; адрес строки - в DX
	int	21h		; вызов системной функции DOS
	ret			; завершение COM-программы
message	db	'Hello World!',0Dh,0Ah,'$'	; строка
	end	start		; конец программы
