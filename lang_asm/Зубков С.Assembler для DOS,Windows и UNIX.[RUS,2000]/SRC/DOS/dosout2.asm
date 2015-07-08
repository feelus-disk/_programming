; dosout2.asm
; Выводит на экран строку "This function can print $",
; используя вывод в STDERR, так что ее нельзя перенаправить в файл.
;
; Компиляция:
; TASM:
; tasm /m dosout2.asm
; tlink /t /x dosout2.obj
; MASM:
; ml /c dosout2.asm
; link dosout2.obj,,NUL,,,
; exe2bin dosout2.exe dosout2.com
; WASM
; wasm dosout2.asm
; wlink file dosout2.obj form DOS COM
;

	.model	tiny
	.code
	org	100h			; начало COM-файла
start:
	mov	ah,40h		; номер функции DOS
	mov	bx,2			; устройство STDERR
	mov	dx,offset message	; DS:DX - адрес строки
	mov	cx,message_length	; CX - длина строки
	int	21h
	ret			; завершение COM-файла

message	db	'This function can print $'
message_length = $-message	; длина строки = текущий адрес минус
				; адрес начала строки
	end	start
