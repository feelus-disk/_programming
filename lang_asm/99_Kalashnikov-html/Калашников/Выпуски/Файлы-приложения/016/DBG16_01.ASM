
;              DBG16_01.ASM - программа к Главе № 16

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE dbg16_01.asm /AT

;При использовании TASM:
;TASM.EXE dbg16_01.asm
;TLINK.EXE dbg16_01.obj /t/x


;                   === Защита от отладчиков ===

; Способ первый:
; Занести по адресу обработчика 03h прерывания команду IRET

CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       xor ax,ax
       mov es,ax		;Обнуляем ES

       mov bx,es:[03h*4]	;BX - смещение адреса 03 прерывания
       mov es,es:[03h*4+2]	;ES - сегмент адреса 03 прерывания

       mov byte ptr es:[bx],0CFh ;<===Отладчик "глючит" здесь
				 ;Заносим по адресу ES:BX инструкцию IRET (0CFh)

       mov ah,9
       mov dx,offset Message
       int 21h

       ret

Message db 'DBG16_01.COM - порядок!$'

CSEG ends
end Begin