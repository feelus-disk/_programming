
;             Prog03.asm - программа к Главе № 03

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE prog03.asm /AT

;При использовании TASM:
;TASM.EXE prog03.asm
;TLINK.EXE prog03.obj /t/x


CSEG segment
org 100h

_beg:
	mov ax,0B800h
	mov es,ax
	mov di,0

	mov ah,31
	mov al,1
	mov es:[di],ax

	mov ah,10h
	int 16h

	int 20h

CSEG ends
end _beg
