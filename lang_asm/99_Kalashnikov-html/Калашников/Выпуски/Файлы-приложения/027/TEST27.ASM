
;          TEST27.ASM - дополнительная программа к Главе № 27

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

;!!! Как пользоваться данной программой - читайте 27 главу !!!

;   === Начало программы ===
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

; --- Все просто! ---

Begin:
       mov ah,2
       mov cx,80

Next_char:
       mov dl,'A'
       int 21h
       loop Next_char

       ret

cseg ends
end Begin