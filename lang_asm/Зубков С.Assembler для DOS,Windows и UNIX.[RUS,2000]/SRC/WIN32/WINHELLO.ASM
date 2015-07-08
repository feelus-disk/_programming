; winhello.asm
; Графическое win32-приложениe
; Выводит окно типа mesagebox с текстом "Hello world!"
;
; Компиляция MASM
;  ml /c /coff /Cp winhello.asm
;  link winhello.obj /subsystem:windows
;
; Компиляция TASM
;  tasm /m  /ml /D_TASM_ winhello.asm
;  tlink32 /Tpe /aa /c /x winhello.obj
;
; Компиляция WASM
;  wasm winhello.asm
;  wlink file winhello.obj form windows nt
;
include def32.inc
include kernel32.inc
include user32.inc

	.386
	.model flat
	.const
; заголовок окна
hello_title	db 'First win32 GUI program',0
; сообщение
hello_message	db 'Hello world!',0
	.code
_start:
	push	MB_ICONINFORMATION	; стиль окна
	push	offset hello_title	; адрес строки с заголовком
	push	offset hello_message	; адрес строки с сообщением
	push	0			; идентификатор предка
	call	MessageBox

	push	0		; код выхода 
	call	ExitProcess	; завершение программы
end	_start
