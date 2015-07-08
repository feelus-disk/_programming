
;             Prog06.asm - программа к Главе № 06

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE prog06.asm /AT

;При использовании TASM:
;TASM.EXE prog06.asm
;TLINK.EXE prog06.obj /t/x


CSEG segment
assume cs:CSEG, es:CSEG, ds:CSEG, ss:CSEG
org 100h

Begin:
	mov sp,offset Lab_1
	mov ax,9090h
	push ax
	int 20h

Lab_1:
	mov ah,9
	mov dx,offset Mess
	int 21h

	int 20h

Mess db 'А все-таки она выводится!$'

CSEG ends
end Begin
