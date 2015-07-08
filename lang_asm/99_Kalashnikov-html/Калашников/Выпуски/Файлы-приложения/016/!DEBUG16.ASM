
;              !DEBUG16.ASM - программа к Главе № 16

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE !debug16.asm /AT

;При использовании TASM:
;TASM.EXE !debug16.asm
;TLINK.EXE !debug16.obj /t/x


CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       call Create_file	;Создадим файл с именем "!Debug16.com"
			;Иначе говоря, перезапишем сами себя...

       nop		;<=== Это для теста. Все внимание на эту строку!

       ret		;Выходим в DOS


; === Процедура создания файла с именем "!DEBUG16.COM" ===
Create_file proc
       mov ah,3Ch		;Функция создания файла
       xor cx,cx		;Атрибуты обычные
       mov dx,offset File	;Имя создаваемого файла
       int 21h
       push ax			;Сохраним номер файла

       mov bx,ax
       mov ah,40h ;Функция записи в файл
       mov cx,offset Finish-100h ;Кол-во записываемых байт:
				 ;Конец нашей программы (Finish)-100h (PSP)
       mov dx,offset Begin	 ;Адрес, с которого начинаем писать
				 ;(самое начало нашей программы)
       int 21h

       pop ax
       mov ah,3Eh		;Закрываем файл
       int 21h

       ret

File db '!Debug16.com',0	;Имя файла, которое создается
Create_file endp


Finish equ $	;Метка конца программы

CSEG ends
end Begin