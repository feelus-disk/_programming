
;             Prog08.asm - программа к Главе № 08

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE prog08.asm /AT

;При использовании TASM:
;TASM.EXE prog08.asm
;TLINK.EXE prog08.obj /t/x


CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

; === Начало программы ===
Begin: 	mov ax,3D00h             ;Открываем файл для чтения
	mov dx,offset File_name  ;Имя открываемого файла в DX
	int 21h
	jc Error_file            ;Ошибка открытия файла? 

	mov Handle,ax            ;Сохраним номер открытого файла
	mov bx,ax
	mov ah,3Fh               ;Функция чтения файла
	mov cx,0FDE8h            ;Будем читать в память 0FDE8h = 65000 байт
	mov dx,offset Buffer     ;DX указывает на буфер для считывания
	int 21h

	mov ah,3Eh               ;Закрываем файл
	mov bx,Handle
	int 21h

	mov dx,offset Mess_ok
Out_prog:
	mov ah,9
	int 21h

	int 20h

Error_file:
	mov dx,offset Mess_error
	jmp Out_prog

Handle dw 0
Mess_ok db 'Файл загружен в память! Смотрите в отладчике!$'
Mess_error db 'Не удалось открыть (найти) файл '
File_name db 'c:\msdos.sys',0,'!$'
Buffer equ $

; === Конец программы ===

CSEG ends
end Begin
