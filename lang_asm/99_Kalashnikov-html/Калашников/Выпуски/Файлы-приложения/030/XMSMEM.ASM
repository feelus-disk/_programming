
;              XMSMEM.ASM - программа к Главе № 30
;                 Определяем объем памяти XMS

; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE xmsmem.asm /AT

;При использовании TASM:
;TASM.EXE xmsmem.asm
;TLINK.EXE xmsmem.obj /t/x


.386   ;Команды 80386 процессора нужны для работы с 32-х разрядными регистрами
.8087  ;8087 Сопроцессор нужен для процедуры вывода десятичных чисел
CSEG segment use16
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
     mov ah,9
     mov dx,offset Mess_about
     int 21h

;Проверим на наличие Himem.sys в памяти...
     mov ax,4300h
     int 2Fh

     cmp al,80h
     je Himem_loaded  ;Если AL = 80h, то Himem.sys загружен. 

;Иначе выводим сообщение о том, что Himem в памяти не обнаружен...
     mov ah,9
     mov dx,offset Mess_nohimem
     int 21h
     ret


Himem_loaded:
;Готовим XMS-память (отводим блок в XMS-памяти)
     call Prepare_XMS

     ret



;=== Готовим XMS-память ===
Prepare_XMS proc
     mov ax,4310h
     int 2Fh

     mov word ptr XMS_Addr,bx
     mov word ptr XMS_Addr+2,es   ;Сохраним обработчик XMS-функций

;Получаем количество килобайт XMS-памяти (всего)
     mov ah,88h
     call dword ptr XMS_Addr
     mov dword ptr Number_dec,edx ;Сохраним полученное число

     mov dx,offset Mess_TotalMemory
     mov ah,9
     int 21h

     mov ah,3
     xor bh,bh ;Видеостраница
     int 10h   ;Читаем текущую позицию курсора

     add dx,8
     mov ah,2
     int 10h ;Установим курсор на 8 позиций правее, после выведенного сообщения

     call Out_dec ;Выводим кол-во килобайт XMS в текущую позицию курсора

     mov dx,offset Mess_cursor
     mov ah,9
     int 21h
     ret
Prepare_XMS endp


;=== Вывод десятичного числа на экран с использованием сопроцессора ===
;Здесь без комментариев... См. предыдущие выпуски...
Out_dec proc
    finit

    fstcw Dat
    or Dat,0C00h
    fldcw Dat
    fldz
    fild Divider
    fild Number_dec
    fst st(7)

Next_sym:
    fprem
    fistp Dat
    call Out_sym
    fld st(6)
    fdiv st,st(1)
    frndint
    fst st(7)
    fcom st(2)
    fstsw ax
    and ax,4500h
    cmp ax,4000h
    jnz Next_sym
Finish_dec:
    ret

Number_dec dq 0

Divider dw 10
Dat dw ?
Out_dec endp

;=== Вывод одного символа на экран в текущую позицию курсора ===
Out_sym proc
    push dx

    mov ah,2
    mov dl,byte ptr Dat
    add dl,'0'
    int 21h
    pop dx

    dec dx
    mov ah,2
    xor bh,bh
    int 10h

    ret
Out_sym endp


Mess_about db 0Ah, 0Dh, 'XMSMEM - определяем объем XMS-памяти.',0Ah, 0Dh
           db 'Книга "Ассемблер? Это просто! Учимся программировать", Глава № 30',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru. E-mail: Assembler@Kalashnikoff.ru',0Ah,0Dh,0Ah
           db '(C) Авторские права на файлы-приложения принадлежат читателям книги.',0Ah, 0Dh, 0Ah
           db 9,9,'=== Россия, Москва, 2001 год ===',0Ah,0Dh,'$'

Mess_nohimem db 'Драйвер Himem.sys не загружен! Невозможно использовать XMS-память!!!'
Mess_cursor db 0Ah, 0Dh,'$'

Mess_TotalMemory db 0Ah,0Ah,0Dh,'Всего XMS-памяти (Килобайт):$'

XMS_Addr dw ?
CSEG ends
end Start