
;              DBG16_03.ASM - программа к Главе № 16

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE dbg16_03.asm /AT

;При использовании TASM:
;TASM.EXE dbg16_03.asm
;TLINK.EXE dbg16_03.obj /t/x


;                   === Защита от отладчиков ===

; Способ третий:
;Перенести стек в тело нашей программы. Отладчик, использующий стек
;нашей программы затрет ее код.

.286
CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       mov sp,offset Label_1	;Установим стек в тело нашей программы
				;прямо на инструкцию int 21h

       mov ah,9
       mov dx,offset Message
       int 21h

Label_1:
       int 20h

Message db 'DBG16_03.COM - порядок!$'

CSEG ends
end Begin