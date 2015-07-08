
;             Prog02.asm - программа к Главе № 02

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE prog02.asm /AT

;При использовании TASM:
;TASM.EXE prog02.asm
;TLINK.EXE prog02.obj /t/x


CSEG segment
org 100h

Start:

	mov ah,9
	mov dx,offset String
	int 21h

	mov ah,10h
	int 16h

	int 20h

String db 'Нажмите любую клавишу:$'

CSEG ends
end Start
