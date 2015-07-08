; winurl.asm
; Пример програмы для win32.
; запускает установленный по умолчанию броузер на адрес, указанный в строке URL
; аналогично можно запускать любую программу, документ, и любой другой файл,
; для которого определена операция open
;
; Компиляция MASM
;  ml /c /coff /Cp winurl.asm
;  link winurl.obj /subsystem:windows
;
; Компиляция TASM
;  tasm /m /ml /D_TASM_ winurl.asm
;  tlink32 /Tpe /aa /c /x winurl.obj
;
; Компиляция WASM
;  wasm winurl.asm
;  wlink file winurl.obj form windows nt
;

include	shell32.inc
include	kernel32.inc

	.386
	.model flat
	.const
URL db	'http://www.lionking.org/~cubbi/',0
	.code
_start:			; метка точки входа должна начинаться с подчёркивания
	xor	ebx,ebx
	push	ebx		; для исполнимых файлов - способ показа
	push	ebx		; рабочая директория
	push	ebx		; командная строка
	push	offset URL	; имя файла с путём
	push	ebx		; операция open или print (если NULL - open)
	push	ebx		; идентификатор окна, которое получит сообщения
	call	ShellExecute	; ShellExecute(NULL,NULL,url,NULL,NULL,NULL)
	push	ebx		; код выхода 
	call	ExitProcess	; ExitProcess(0)
end	_start
