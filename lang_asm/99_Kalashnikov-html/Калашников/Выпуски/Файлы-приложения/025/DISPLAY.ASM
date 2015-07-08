;        ===== DISPLAY.ASM - процедуры работы с экраном ======

; === Рисуем рамку заданного размера в центре экрана ===
Draw_frame proc
     mov bp,sp
     add bp,2

     push es

     push 0B800h
     pop es

;________________________________________
;
; Производим вычисления для того, чтобы
; разместить ЛЮБУЮ рамку в цетре экрана.
;________________________________________

     mov ax,Height_X
     shr al,1
     mov dh,11
     sub dh,al

     mov ax,Width_Y
     shr al,1
     mov dl,39
     sub dl,al
;Теперь DH содержит центрированный ряд (строку),
;а DL - колонку относительно размеров рамки (окошка)...
;_________________________________________

  ;Сохраним полученный адрес, с которого начинается вывод рамки
  ;Нужно для того, чтобы выводить сообщения в рамке.
     mov Num_DX,dx

     mov ax,Other  ;Получим дополнительную информацию
     test al,1     ;Нулевой бит равен 0?
     jz No_copyscr ;Если так, то копировать экран не нужно.

     mov ax,Height_X ;Иначе копируем в область 2 видеостраницы
     add ax,2
     call Copy_scr

No_copyscr:
     call Get_linear
     push di

     mov ax,Attr
     mov al,'╔'
     stosw

     mov al,'═'
     mov cx,Width_Y
     rep stosw

     mov al,'╗'  ;завершаем верхний ряд
     stosw

     pop di      ;восстановим DI + 160 (следующий ряд)
     add di,160
     inc dh


;теперь у нас примерно такая ситуация на экране:
;╔═══════════════════════════╗
;_
;где _, там у нас DI и DH


     mov cx,Height_X ;CX - кол-во повторов (высота)

Next_lined:
     push cx
     push di

     mov al,'║'
     stosw

     mov al,32
     mov cx,Width_Y
     rep stosw

     mov al,'║'
     stosw

     pop di
     add di,160 ;переводим DI на следующий ряд
     inc dh     ;передвигаем DH на 1
     pop cx     ;восстановим счетчик
     loop Next_lined ;следующий ряд...

;теперь у нас примерно такая ситуация на экране:
;╔═══════════════════════════╗
;║                           ║
;║                           ║
;║                           ║
;_ - тут DI и DH


     mov al,'╚' ;низ рамки...
     stosw

     mov al,'═'
     mov cx,Width_Y
     rep stosw

     mov al,'╝'
     stosw

;теперь у нас примерно такая ситуация на экране:
;╔═══════════════════════════╗
;║                           ║
;║                           ║
;║                           ║
;╚═══════════════════════════╝


;Выводим сообщение внизу рамки
     mov si,Mess_dn   ;SI = адрес строки для вывода
     call Draw_messfr ;Выводим сообщение ВНИЗУ рамки

;теперь у нас примерно такая ситуация на экране:
;╔═══════════════════════════╗
;║                           ║
;║                           ║
;║                           ║
;╚════ Сообщение внизу ══════╝


;Выводим сообщение вверху рамки
     mov dx,Num_DX
     push dx
     mov si,Mess_up
     call Draw_messfr

;теперь у нас примерно такая ситуация на экране:
;╔════ Сообщение вверху ═════╗
;║                           ║
;║                           ║
;║                           ║
;╚════ Сообщение внизу ══════╝


     pop dx
     add dx,0101h
     mov si,Mess_ins ;Адрес сообщения, которое будет внутри рамки
     or si,si        ;Если там 0, то не выводим...
     jz No_draw
     mov ah,[si]
     inc si
     call Print_string

;теперь у нас примерно такая ситуация на экране:
;╔════ Сообщение вверху ═════╗
;║Сообщение внутри           ║
;║                           ║
;║                           ║
;╚════ Сообщение внизу ══════╝


No_draw:
     mov ax,Other ;Получим дополнительную информацию
     test ax,10b
     jz No_upline

     mov dx,Num_dx
     add dh,2
     call Get_linear

     mov ax,Attr
     mov al,'╟'
     mov cx,1
     stosw

     mov cx,Width_Y
     mov al,'─'
     rep stosw

     mov al,'╢'
     stosw

;теперь у нас примерно такая ситуация на экране:
;╔════ Сообщение вверху ═════╗
;║Сообщение внутри           ║
;╟───────── линия ───────────╢
;║                           ║
;║                           ║
;╚════ Сообщение внизу ══════╝


No_upline:
     pop es
     ret 14
Draw_frame endp


; --- Вывод сообщениий вверху и внизу рамки ---
;Вспомогательна процедура.
Draw_messfr proc
     or si,si ;SI = 0?..
     jz No_drawup ;тогда ничего выводить не надо, выходим

     mov ah,[si]
     inc si
     call Count_strmid ;Вычисляем середину строки

     call Print_string ;Выводим строку на экран

No_drawup:
     ret
Draw_messfr endp

; === Вычисляем середину строки ===
;Вход: CS:SI - адрес строки
;Выход: DL - середина адреса для вывода строки
Count_strmid proc
     push es ;Сохраним регистры...
     push di
     push ax

     push cs ;ES=CS
     pop es
     mov di,si ;DI=SI
     xor al,al ;AL=0
     mov cx,0FFFFh ;сколько символов перебирать (возьмем максимум)...
     repne scasb ;Ищем 0 в строке

;SI=начало строки
;DI=конец строки+1
     sub di,si ;DI=DI-SI-1 = длина строки
     dec di

     shr di,1  ;Делим длину на 2
     mov ax,40 ;Делим кол-во символов в строке на 2 = 40
     sub ax,di ;AX=40-половина длины строки = нужная колонка
     mov dl,al ;DL=колонка, с которой следует выводить строку!

     pop ax    ;Восстановим регистры
     pop di
     pop es
     ret
Count_strmid endp

; === Вывод стоки на экран ===
;Вход: DS:SI - адрес строки для вывода
;      DX - координаты для вывода
;      AH - атрибуты строки
;Выход: ничего
Print_string proc
     call Get_linear

Next_symstr:
     lodsb          ;Получаем очередной символ строки
     or al,al       ;Это 0 (конец строки?)
     jz Stop_outstr
     stosw
     jmp short Next_Symstr ;Следующий символ

Stop_outstr:
     ret
Print_string endp

; === Вывод символа на экран ===
;Вход: AL - символ для вывода
;      AH - атрибуты символа
;      DX - координаты для вывода
;Выход: ничего
Print_sym proc
     call Get_linear ;Получаем линейный адрес строки
     stosw           ;Заносим в видеобуфер атрибут (AH) и символ (AL)
     ret
Print_sym endp

; === Преобразование DH:DL в линейный массив ===
Get_linear proc
    push ax    ;сохраним все используемые регистры
    push bx
    push dx

    shl dl,1   ;умножаем DL на 2 (DL=DL*2)...

    mov al,dh  ;в AL - ряд,
    mov bl,160 ;который нужно умножить на 160
    mul bl     ;умножаем: AL(ряд)*160; результат --- в AX

    mov di,ax  ;результат умножения - в DI
    xor dh,dh  ;аннулируем DH
    add di,dx  ;теперь в DI линейный адрес в видеобуфере.

    pop dx     ;восстанавливаем регистры...
    pop bx
    pop ax
    ret
Get_linear endp

; === Проверяем видеорежим монитора и текущую видеостраницу ===
Check_video proc
     mov ah,0Fh
     int 10h
     cmp al,3  ;Текстовый режим?
     je Ok_video

     mov ax,3
     int 10h

Ok_video:
     or bh,bh  ;Нулевая страница?
     jz Ok_page

     mov ax,0500h
     int 10h

Ok_page:
     ret
Check_video endp

; === Сохраним экран ===
Save_mainscr proc
    pusha       ;Сохраним регистры...
    push es
    push ds

    push 0B800h ;с нулевой страницы
    pop ds
    xor si,si

    push 0B900h ;в первую страницу...
    pop es
    xor di,di

    mov cx,2000 ;4000 байт
    rep movsw

    pop ds      ;восстановим регистры.
    pop es
    popa
    ret
Save_mainscr endp

; === Восстановим экран ===
Restore_mainscr proc
    pusha
    push es
    push ds

    push 0B900h ;с первой видеостраницы
    pop ds
    xor si,si

    push 0B800h ;в нулевую...
    pop es
    xor di,di

    mov cx,2000
    rep movsw

    pop ds
    pop es
    popa
    ret
Restore_mainscr endp

; === Копируем часть экрана ===
;Вход: DH - ряд, с которого необходимо начать копирование
;      AL - количество рядов для копирования
;Выход: ничего
Copy_scr proc
    pusha   ;Как обычно сохраним регистры
    push es
    push ds

    xor dl,dl
    call Get_linear

    mov bl,160  ;Получим количество байт, котрые нужно копировать
    mul bl
    mov cx,ax   ;Их - в CX (будем использовать CX как счетчик)

    mov si,di   ;DS:SI - откуда копируем
    xor di,di   ;ES:SI - куда копируем
    mov Num_copySI,si ;Сохраним полученные значения для восстановления
    mov Num_copyDI,di
    mov Num_copyCX,cx
    push 0B800h
    pop ds
    push 0BA00h
    pop es
    rep movsb

    pop ds
    pop es
    popa
    ret

Num_copySI dw ?
Num_copyDI dw ?
Num_copyCX dw ?
Copy_scr endp

; === Восстанавливаем часть экрана ===
;Вход: ничего (все уже сохранено в переменных )
;Выход: ничего
Restore_scr proc
    pusha
    push es
    push ds

    mov di,Num_copySI ;Получим сохраненные процедурой Copy_scr значения
    mov si,Num_copyDI
    mov cx,Num_copyCX
    push 0BA00h
    pop ds
    push 0B800h
    pop es
    rep movsb  ;Копируем со 2-ой страницы в 0-ую...

    pop ds
    pop es
    popa
    ret
Restore_scr endp

; === Прячем курсор, сохранив предварительно его текущую позицию ===
Hide_cursor proc
    mov ah,3          ;получаем текущую позицию курсора
    mov bh,Video_page
    int 10h
    mov Pos_cursor,dx ;теперь она в DX (отсчет с нуля!)

    mov ah,2  ;Установим курсор на первую страницу как на нулевой
    mov bh,1
    int 10h

    mov bh,Video_page ;прячем курсор на 0-ой видеостранице
    mov dx,1900h
    int 10h

    ret
Hide_cursor endp

; === Восстановим курсор ===
Restore_cursor proc
    mov ah,2
    mov bh,Video_page ;видеостраница
    mov dx,Pos_cursor ;сохраненная позиция
    int 10h           ;установим (позиционируем) курсор
    ret
Restore_cursor endp

; === Вывод десятичных чисел на экран (сопроцессор) ===
;Вход: Number_dec - 64-х битное число для вывода
;      DX - адрес для вывода
;      AH - атрибуты для вывода
;Выход: ничего
Out_dec proc
    pusha       ;Сохраним все регистры
    push es
    push 0B800h ;ES установим на сегмент дисплея (для вывода чисел)
    pop es

    xor cx,cx   ;CX - счетчик для точек (см. ниже )

    finit       ;Инициализация сопроцессора
;Состояние регистров сопроцессора после выполнения приведенной выше команды
;(Empty - пусто, Zero - нуль, Valid - некоторое число):

;Empty ST(0)
;Empty ST(1)
;Empty ST(2)
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Empty ST(7)

;Проведем необходимую настройку сопроцессора для округления чисел...
    fstcw Dat    ;Получим регистр управления процессором и установим RC
    or Dat,0C00h ;= or Dat,0000110000000000b
    fldcw Dat    ;Загрузим измененный регистр в сопроцессор

    fldz         ;Загрузим нуль (для проверки) (LoaD Zero)
; Zero ST(0) 0
;Empty ST(1)
;Empty ST(2)
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Empty ST(7)

    fild Divider ;Загрузим делитель (т.е. число 10)
;Valid ST(0) 10
; Zero ST(1) 0
;Empty ST(2)
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Empty ST(7)

    fild Number_dec ;Загрузим делимое (выводимое число)
;Valid ST(0) 256   - допустим, размер файла = 256 байт
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Empty ST(7)

    fst st(7)       ;Дублируем делимое ( ST(7)=ST(0) )
;Valid ST(0) 256
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

Next_sym:
    fprem            ;Делим и получаем остаток от деления в ST(0)
;Valid ST(0) 6       - первый раз 256/10=25 и 6 в остатке (видим это в ST(0))
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

    fistp Dat        ;Остаток - в переменную Dat ( Dat=ST(0) )
;Valid ST(0) 10       - Dat=6. Стек "подтянулся" вверх, т.к. fistP, т.е.
; Zero ST(1) 0          загрузить в переменную число из ST(0) с
;Empty ST(2)            выталкиванием его из регистра сопроцессора
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Valid ST(6) 256     ;Обращаем также внимание, что 256 "подтянулось" вверх
;Empty ST(7)


;Выводим остаток от деления, который загружен в Dat.
    mov al,byte ptr Dat
    add al,'0'      ;Выводим "нормальную" цифру (остаток от деления на 10)
    call Print_sym
    dec dx          ;Вывели. DX=DX-1 - следующий символ

;Подготовимся к выводу следующего символа...
    fld st(6)       ;ST(0)=ST(6)
;Valid ST(0) 256     - Стек "протолкнулся" вниз
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

    fdiv st,st(1)   ;Теперь делим ST(0) на ST(1)
;Valid ST(0) 25.6    - разделили 256 на 10. Результат - в ST(0)
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

    frndint         ;Округлим полученное число
;Valid ST(0) 25      - !!!обратите внимание на округление!!!
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

    fst st(7)       ;ST(7)=ST(0). Предыдущее число в ST(7) затирается.
;Valid ST(0) 25
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 25

;Теперь проверим, равно ли делимое нулю.
;Проверку будем осуществлять путем сравнения ST(0) с ST(2). Для этого мы,
;собственно, и заносили в самом начале нуль.
    push ax
    fcom st(2)      ;ST(0)=ST(2)?
    fstsw ax        ;AX=состояние сопроцессора
    and ax,100010100000000b ;Аннулируем ненужные нам биты
    cmp ax,100000000000000b ;ST(0)=ST(2)?
    pop ax
    je Finish_dec           ;Если равно, то на выход 
;Если не равно, то в ST(0) будет вместо 256 число 25, затем 2, затем 0...
;Более подробно смотрите прилагаемый файл !Coproc!.asm в TurboDebugger'e

;Точкой будем отделять три цифры для удобства. Пример: 1.568
;Для этого мы и заводим счетчик (CX), который и будет считать количество
;выведенных цифр. Если три уже вывели, и делимое не равно 0, то ставим точку.
    inc cx          ;Увеличим счетчик точек
    cmp cx,3        ;Три цифры выведено?
    jne Next_sym    ;Пока нет. Следующая цифра 

    mov al,'.'      ;Выводим разделитель разрядов (точку)
    call Print_sym
    dec dx          ;DX на один меньше.
    xor cx,cx       ;Обнулим счетчик
    jmp short Next_sym ;Следующая цифра 

Finish_dec:
    pop es
    popa
    ret

 Number_dec dq ?  ;64-х разрядная переменная для выводимого числа
 Divider dw 10    ;Делитель всегда 10
 Dat dw ?         ;Временная переменная для хранения остатка от деления на 10

;Данная процедура выводит всего лишь одно число на экран. Представляете,
;сколько работы проделывает процессор за считанные доли миллисекунд, выводя
;на экран несколько файлов?
;А ведь кроме вывода чисел мы еще проверяем текущий режим монитора и текущую
;видеостраницу, копируем пользовательский экран, читаем и сохраняем
;текущую позицию курсора, рисуем рамку, производя необходимые расчеты,
;читаем каталог в память и выводим первые файлы на экран по одному символу...
;Имейте также в виду, что наши алгоритмы пока не совсем оптимальны.
;Уверяю вас, что даже на PC/XT вывод будет осуществлен мгновенно. Т.е.
;на глаз совсем не заметно... Впечатляет скорость работы процессора?
;Надеюсь, что так...
Out_dec endp
