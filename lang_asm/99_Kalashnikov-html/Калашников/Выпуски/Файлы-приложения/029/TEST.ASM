
;           TEST.ASM - дополнительная программа к Главе № 29

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

;   === Начало программы: ===
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
       mov ah,9
       mov dx,offset Mess_start
       int 21h

       mov ah,2       ;Функция вывода одного символа на экран

       mov si,80h     ;Адрес командной строки
       lodsb
       or al,al
       lodsb
       jnz Next_char

       mov ah,9
       mov dx,offset Error_String
       int 21h
       ret

Next_char:
       lodsb          ;Получаем первый символ
       cmp al,0Dh     ;Это 0Dh?
       jz End_param   ;Да - тогда первый параметр закончился 

Next_param:
       mov dl,al      ;Нет, не нуль. Тогда выводим полученный символ...
       int 21h        ;...на экран в текущую позицию курсора
       jmp short Next_char ; Приступаем к следующему символу... 

End_param:
       int 20h

Mess_start db 'Сообщение от Test.com: Командная строка: $'
Error_String db 'НЕ ВВЕДЕНА!',0Ah,0Dh,0Ah,0Ah,'$'

cseg ends
end Begin
