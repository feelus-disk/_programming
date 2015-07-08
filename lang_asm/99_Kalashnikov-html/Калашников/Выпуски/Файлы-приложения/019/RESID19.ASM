
;            RESID19.ASM - программа к Главе № 19

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE resid19.asm /AT

;При использовании TASM:
;TASM.EXE resid19.asm
;TLINK.EXE resid19.obj /t/x


;   === Начало программы: ===
.286
CSEG segment
assume cs:CSEG, ds:CSEG, ss:CSEG, es:CSEG
org 100h

Begin:
       jmp Init		;На метку инициализации 

; === Обработчик 21h-ого прерывания ===
Int_21h_proc proc
     cmp ax,9889h
     jne Next_step

     xchg ah,al
     iret

Next_step:
     pusha		;Сохраним регистры...
     push ds
     push es

     mov bx,ds		;BX=DS

     push cs		;Настроим сегментные регистры
     push cs
     pop es
     pop ds

     cmp ax,4B00h	;Это запуск файла на выполнение?
     je Start_f

     cmp ah,39h		;Это создание каталога?
     je Create_dir

     cmp ah,3Ah		;Это удаление каталога?
     je Delete_dir

     cmp ah,3Bh		;Это смена каталога?
     je Change_dir

     cmp ah,3Ch		;Это создание файла?
     je Create_file

     cmp ax,3D02h	;Это открытие файла для чтения/записи?
     je Open_fl

     cmp ah,41h		;Это удаление файла?
     je Delete_file

     jmp short Go_21h	;Если другое, то передадим управление 21h-ому... 

Start_f:
     mov si,offset Start_filemess ;Строка для записи в наш log-файл.
     call Move_string	;Готовим строку и записываем ее в файл...
     jmp short Go_21h	;Передадим управление 21h-ому прерыванию...

Create_dir:
     mov si,offset Create_dirmess
     call Move_string
     jmp short Go_21h

Delete_dir:
     mov si,offset Delete_dirmess
     call Move_string
     jmp short Go_21h

Change_dir:
     mov si,offset Change_dirmess
     call Move_string
     jmp short Go_21h

Create_file:
     mov si,offset Create_filemess
     call Move_string
     jmp short Go_21h

Open_fl:
     mov si,offset Open_filemess
     call Move_string
     jmp short Go_21h

Delete_file:
     mov si,offset Delete_filemess
     call Move_string


Go_21h:
     pop es		;Восстановим регистры...
     pop ds
     popa

  jmp dword ptr cs:[0FCh] ;Передаем управление прежнему 21h-ому
Int_21h_proc endp

;=== Переносим строку и пишем информацию в файл ===
Move_string proc
    mov di,2	;DS:SI указывают на строку
		;ES:DI - на место в памяти, где будет формироваться строка...
    lodsw	;Получим длину строки (первый байт строки)
    mov cx,ax	;Длину строки в CX
    rep movsb	;Переместили строку по адресу ES:DI (Текущий сегмент:0002h)

    push ds
    mov ds,bx	;DS указывает на сегмент, где находится имя файла
    mov si,dx	;SI - на смещение

Next_char:
    lodsb	;Получаем очередной символ
    or al,al	;Это конец строки с именем файла? Проверка на 0...
    jz Zero_found
    stosb	;Если еще не конец - заносим его в нашу формирующуюся строку
    jmp short Next_char ;Следующий символ...

Zero_found:
    pop ds	;Имя файла перенесли! Восстановим DS.

    mov ax,0A0Dh ;Добавим возврат каретки/перевод строки.
    stosw

    dec di
    dec di
    mov word ptr cs:[0],di ;Занесем по 0-ому смещению длину готовой строки

    call Save_file	;Запишем готовую строку в наш log-файл...

    ret
Move_string endp


;=== Пишем в файл ===
Save_file proc
     call Check_file	;Проверим, существует ли наш log-файл или нет...

     mov al,02h		;Открываем файл для чтения/записи
     call Open_file

     mov ax,4202h	;Устанавливаем указатель на конец файла
     xor cx,cx
     xor dx,dx
     int 3

     mov ah,40h		;Функция записи в файл
     mov cx,cs:[0]	;Количество записываемых байт
     mov dx,2		;Откуда будем писать (DS:DX)
     int 3

     call Close_file	;Закрываем файл...

     ret
Save_file endp

;=== Проверяем: существует ли нужный файл ===
Check_file proc
     xor al,al		;Пробуем открыть наш log-файл
     call Open_file
     jnc File_exists	;Если файл существует, то на метку File_exists

; === Атрибуты файла ===
;00001 - только чтение
;00010 - спрятанный
;00100 - системный
;01000 - метка тома
;010000 - подкаталог
;100000 - архивный
     mov ah,3Ch		;Если файл не существует, то создадим его.
     mov cx,100010b	;Атрибут: архивный, спрятанный
     mov dx,offset File_name ;DS:DX указывают на имя файла
     int 3
     jc Error_create	;Ошибка?.. 
     mov Handle,ax	;Если успешно создали, то запомним номер файла

File_exists:
     call Close_file	;Закрываем файл...

Error_create:
     ret

File_name db 'C:\report.txt',0	;Наш log-файл
Check_file endp

;=== Открытие файла ===
Open_file proc
     mov dx,offset File_name
     mov ah,3Dh
     int 3
     jc Error_open

     mov bx,ax
     mov Handle,ax

Error_open:
     ret
Handle dw 0FFFFh
Open_file endp

;=== Закрытие файла ===
Close_file proc
     pusha
     pushf
     cmp Handle,0FFFFh	;Нечего закрывать?.. 
     je No_close

     mov ah,3Eh
     mov bx,Handle
     int 3
     mov Handle,0FFFFh	;Закрываем и отмечаем, что нет открытых файлов...

No_close:
     popa
     popf
     ret
Close_file endp

;--- Сообщения резидента ---
Start_filemess dw Start_filemessl
               db 'Запуск файла      ---> '
Start_filemessl equ $-Start_filemess-2

Create_dirmess dw Create_dirmessl
               db 'Создание каталога ---> '
Create_dirmessl equ $-Create_dirmess-2

Delete_dirmess dw Delete_dirmessl
               db 'Удаление каталога ---> '
Delete_dirmessl equ $-Delete_dirmess-2

Change_dirmess dw Change_dirmessl
               db 'Смена каталога на ---> '
Change_dirmessl equ $-Change_dirmess-2

Create_filemess dw Create_filemessl
                db 'Создание файла    ---> '
Create_filemessl equ $-Create_filemess-2

Open_filemess dw Open_filemessl
              db 'Открытие файла для чтения/записи ---> '
Open_filemessl equ $-Open_filemess-2

Delete_filemess dw Delete_filemessl
                db 'Удаление файла    ---> '
Delete_filemessl equ $-Delete_filemess-2




;   === Инициализация (подготовка и настройка резидента) ===
Init:
       mov ax,9889h	;Проверим, в памяти ли мы уже или еще нет
       int 21h
       cmp ax,8998h
       jne Set_resident

       mov ah,9		;Если в памяти, то выведем соответствующее сообщение
       mov dx,offset In_memory
       int 21h

       ret		;...И вернемся в DOS

Set_resident:		;Если нас в памяти нет, то установим резидент
; 21h-ое...
       mov ax,3521h
       int 21h		;Получим и сохраним адрес (вектор) 21h прерывания
       mov word ptr cs:[0FCh],bx
       mov word ptr cs:[0FEh],es

       mov ax,es	;Установим старый вектор 21h-прерывания на 3...
       push 0		;(вырубим отладчик)
       pop es
       mov es:[3*4],bx
       mov es:[3*4+2],ax

       mov ax,2521h
       mov dx,offset Int_21h_proc
       int 3		;"Повесим" нашу процедуру на 21h прерывание

       call Check_file	;А есть ли наш log-файл?

       mov ah,9
       mov dx,offset Mess_hello
       int 21h

       mov dx,offset Init
       int 27h		;Оставим программу резидентной в памяти.

In_memory db 'Программа уже загружена в память!!!',0Ah,0Dh,0Ah

Mess_hello db 'Резидент к книге "Ассемблер? Это просто! Учимся программировать", Глава № 19.',0Ah,0Dh,0Ah
           db 'Автор: Калашников Олег Александрович (Assembler@Kalashnikoff.ru),',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru, Россия, Москва, 2000 год.',0Ah,0Dh,'$'

CSEG ends
end Begin