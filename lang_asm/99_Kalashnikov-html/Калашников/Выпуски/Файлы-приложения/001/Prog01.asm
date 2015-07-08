
;          После точки с запятой в Ассемблере идет комментарий,
;               который игнорируется программой-ассемблером.


;             Prog01.asm - программа к Главе № 01

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE prog01.asm /AT

;При использовании TASM:
;TASM.EXE prog01.asm
;TLINK.EXE prog01.obj /t/x


CSEG segment
org 100h

Begin:

	mov ah,9
	mov dx,offset Message
	int 21h

	int 20h

Message db 'Hello, world!$'

CSEG ends
end Begin
