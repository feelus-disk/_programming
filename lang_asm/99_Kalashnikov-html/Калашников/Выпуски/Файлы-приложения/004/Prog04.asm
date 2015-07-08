
;            Prog04.asm - программа к Главе № 04

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE prog04.asm /AT

;При использовании TASM:
;TASM.EXE prog04.asm
;TLINK.EXE prog04.obj /t/x


CSEG segment
org 100h

Begin:
	mov ax,0B800h
	mov es,ax
	mov di,0
	mov al,1
	mov ah,31
	mov cx,2000

Next_face:
	mov es:[di],ax
	add di,2
	loop Next_face

	mov ah,10h
	int 16h
	int 20h

CSEG ends
end Begin
