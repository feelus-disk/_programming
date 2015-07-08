
;            RESID27_.ASM - дополнительный резидент к Главе № 27

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

;!!! Данная программа просто "вешается" на 21h-ое прерывание !!!

;        !!! Как ей пользоваться - читайте 27 главу !!!


;   === Начало программы: ===
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
    jmp Init ; на метку инициализации


; === Обработчик 21h-ого прерывания ===
Int_21h_proc proc
    cmp ax,9977h
    jne No_test
    xchg ah,al
    iret

No_test:
    cmp ah,2
    jne Go_21h

    cmp dl,'A'
    jne Go_21h

    mov dl,'X'

Go_21h:
    jmp dword ptr cs:[Int_21h_vect]

Int_21h_vect dd ?
Int_21h_proc endp


;   === Инициализация (подготовка и настройка резидента) ===
Init:
       mov ax,9977h ;Проверка на повторную загрузку.
       int 21h
       cmp ax,7799h
       jne Next_step2

       mov ah,9      ;Мы уже в памяти! Выведем соответствующую строку.
       mov dx,offset Mess_memory
       int 21h

       ret   ;Выйдем в DOS...

Next_step2:
; === 21h ===
       mov ax,3521h
       int 21h ;Получим и сохраним адрес (вектор) 09h прерывания
       mov word ptr cs:[Int_21h_vect],bx ;Смещение...
       mov word ptr cs:[Int_21h_vect+2],es ;Сегмент...

       mov ax,2521h
       mov dx,offset Int_21h_proc
       int 21h  ;"Повесим" нашу процедуру на 09h прерывание

       mov ah,9
       mov dx,offset Mess_hello
       int 21h  ;Все в порядке!!!

       mov dx,offset Init
       int 27h  ;Оставим часть программы в памяти.

;  === Сообщения ===
Mess_hello db 0Ah,0Dh,'Резидент к книге "Ассемблер? Это просто! Учимся программировать", Глава № 27.',0Ah,0Dh,0Ah
           db 'Автор: Калашников Олег Александрович (Assembler@Kalashnikoff.ru),',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru, Россия, Москва, 2001 год.',0Ah,0Dh,'$'

Mess_memory db 0Ah,0Dh,'!!! Программа уже загружена в память !!!',0Ah,0Dh,'$'

cseg ends
end Begin
