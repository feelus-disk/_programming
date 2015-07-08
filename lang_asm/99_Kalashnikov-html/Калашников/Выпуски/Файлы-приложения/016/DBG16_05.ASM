
;              DBG16_05.ASM - программа к Главе № 016

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE dbg16_05.asm /AT

;При использовании TASM:
;TASM.EXE dbg16_05.asm
;TLINK.EXE dbg16_05.obj /t/x


;                   === Защита от отладчиков ===

; Способ пятый:
;Читаем сами себя в память

CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       mov ax,3D00h		;Открываем файл для чтения
       mov dx,offset File	;DX указывает на имя файла
       int 21h
       mov bx,ax
       push ax			;Сохраним номер файла

       mov dx,offset Begin	;Куда будем читать (начало нашей программы)
       mov ah,3Fh		;Функция чтения файла
       mov cx,offset Finish-100h ;Сколько байт читаем (Конец программы - 100h)
       int 21h			;<=== Здесь отладчик "ломается"

       pop bx
       mov ah,3Eh		;Закрываем файл
       int 21h


       mov ah,9
       mov dx,offset File
       int 21h

       int 20h


File db 'DBG16_05.COM',0,'- порядок!$'

Finish equ $

CSEG ends
end Begin