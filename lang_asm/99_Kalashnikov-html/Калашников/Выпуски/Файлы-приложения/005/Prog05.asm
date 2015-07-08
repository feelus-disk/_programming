
;             Prog05.asm - программа к Главе № 05

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE prog05.asm /AT

;При использовании TASM:
;TASM.EXE prog05.asm
;TLINK.EXE prog05.obj /t/x


CSEG segment
assume CS:CSEG, DS:CSEG, ES:CSEG, SS:CSEG
org 100h

Start:
	mov ax,0B800h
	mov es,ax
	mov al,1
	mov ah,31
	mov cx,254

Next_screen:
	mov di,0
	call Out_chars
	inc al
	loop Next_screen

	mov ah,10h
	int 16h

	int 20h


; === Подпрограммы ===

Out_chars proc
	mov dx,cx
	mov cx,2000

Next_face:
	mov es:[di],ax
	add di,2
	loop Next_face

	mov cx,dx
	ret
Out_chars endp

CSEG ends
end Start
