
;             Prog09.asm - программа к Главе № 09

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE prog09.asm /AT

;При использовании TASM:
;TASM.EXE prog09.asm
;TLINK.EXE prog09.obj /t/x


CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
	mov dx,offset File_name
	call Open_file          ;Открываем файл
	jc Error_file           ;Ошибка? 
; ------------- Открыли файл ----------------

	mov bx,ax
	mov ah,3Fh              ;Функция чтения файла
	mov cx,offset Finish-100h
	mov dx,offset Begin     ;! Адрес, куда будут читаться данные
	int 21h
; ------------- Прочитали файл ----------------

	call Close_file

; ------------ Выводим сообщение --------------
	mov ah,9
	mov dx,offset Mess_ok
	int 21h
	ret

; ---------- Не смогли найти / открыть файл -----------------
Error_file:
	mov ah,2
	mov dl,7
	int 21h
	ret



; === Процедуры (подпрограммы) ===

; --- Открытие файла ---
Open_file proc
	cmp Handle,0FFFFh
	jne Quit_open
	mov ax,3D00h
	int 21h
	mov Handle,ax
	ret
Quit_open:
	stc
	ret
Handle dw 0FFFFh
Open_file endp

; --- Закрытие файла ---
Close_file proc
	mov ah,3Eh
	mov bx,Handle
	int 21h
	ret
Close_file endp



; === Данные ===

File_name db 'prog09.com',0
Mess_ok db 'Все нормально!', 0Ah, 0Dh, '$'

Finish equ $       ;Метка конца программы

CSEG ends
end Begin
