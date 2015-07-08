
;              XMSBLOCK.ASM - программа к Главе № 30
;                Первый опыт работы с XMS-памятью
	
; (С) Авторские права на файлы-приложения принадлежат автору книги
; "Ассемблер? Это просто! Учимся программировать под MS-DOS"
; Автор: Калашников Олег Александрович (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- Ассемблирование (получение *.com файла) ---
;При использовании MASM 6.11 - 6.13:
;ML.EXE xmsblock.asm /AT

;При использовании TASM:
;TASM.EXE xmsblock.asm
;TLINK.EXE xmsblock.obj /t/x


.386
CSEG segment use16
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
     mov ah,9
     mov dx,offset Mess_about
     int 21h

;Перенесем стек в PSP, т.к. будем ужимать сегмент...
     mov sp,0FEh

;Проверим на наличие Himem.sys в памяти...
     mov ax,4300h
     int 2Fh

     cmp al,80h
     je Himem_loaded

;Иначе выводим сообщение о том, что Himem в памяти не обнаружен...
     mov ah,9
     mov dx,offset Mess_nohimem
     int 21h
     ret


Himem_loaded:
;Готовим основную память (ужимаем и отводим два блока по 64Кб)
     call Prepare_memory

;Готовим XMS-память (отводим блок в XMS-памяти)
     call Prepare_XMS

;Читаем файл в ОСНОВНУЮ память
     call Open_file
     call Read_file
     call Close_file

;Выводим:
;"Прочитали файл в основную память...
;Выводим то, что находится в ОСНОВНОЙ памяти:"
     mov ah,9
     mov dx,offset Mess_first
     int 21h
     xor ah,ah
     int 16h

;Выводим то, что прочитали в ОСНОВНУЮ память (в Buffer1)
     mov ax,Buffer1
     call Out_file

;Выводим:
;"---------------------------"
     mov ah,9
     mov dx,offset Mess_second
     int 21h
     xor ah,ah
     int 16h

;Переносим прочитанные байты из основной памяти в расширенную, а
;а затем обратно в основную.
     call Move_toXMS

;Выводим то, что пересылалось (основная --> XMS --> основная, но в другой
;сегмент (Buffer2))
      mov ax,Buffer2
      call Out_file


;Выводим:
;"Оба сообщения должны совпадать!!! Иначе и быть не может!!!"
     mov ah,9
     mov dx,offset Mess_third
     int 21h

;Возврат из программы
     ret



;=== Готовим XMS-память ===
Prepare_XMS proc
     mov ax,4310h
     int 2Fh

     mov word ptr XMS_Addr,bx
     mov word ptr XMS_Addr+2,es  ;Сохраним обработчик XMS-функций

     mov ah,88h   ;Получить кол-во Кб XMS-памяти (всего)
     call dword ptr XMS_Addr
     mov dword ptr Number_dec,edx ;Сохраним кол-во Кб XMS-памяти

     mov ah,9
     mov dx,1024   ;Отводим 1024Кб XMS-памяти
     call dword ptr XMS_Addr
     or ax,ax
     jnz XMS_OK

;Произошла ошибка (вероятно, запрашиваемый блок больше свободной памяти на
;момент вызова процедуры. Тогда BL = 0A0h). Сообщаем пользователю об ошибке.
     mov ah,9
     mov dx,offset XMS_Error
     int 21h

     int 20h

XMS_OK:
     mov XMS_id,dx  ;Сохраним ID отведенного блока

     ret
Prepare_XMS endp



; --- Открываем файл ---
Open_file proc
     mov ax,3D00h
     mov dx,offset File_name
     int 21h
     jnc Next_stp

     mov ah,9
     mov dx,offset Mess_errfile
     int 21h
     int 20h

Next_stp:
     mov Handle,ax
     mov bx,ax
     ret
Open_file endp

; --- Читаем файл в основную память ---
Read_file proc
     mov ah,3Fh
     mov cx,0FFFFh
     xor dx,dx
     mov ds,Buffer1
     int 21h
     push cs
     pop ds
     mov Bytes,ax         ;Сохраним кол-во прочитанных байт
     ret
Read_file endp

; --- Закрываем файл ---
Close_file proc
     mov bx,Handle
     mov ah,3Eh
     int 21h
     ret
Close_file endp

; --- Выводим прочитанный файл ---
Out_file proc
     mov cx,Bytes   ;Кол-во прочитанных байт в CX
     mov ds,ax      ;Сегмент, в который читали блок, - в DS
     xor bx,bx
     mov ah,2

Next_byte:
     mov dl,[bx]
     int 21h
     inc bx
     loop Next_byte

     push cs
     pop ds

     ret
Out_file endp

; === Готовим основную память ===
Prepare_memory proc
      mov bx,offset Finish
      shr bx,4
      inc bx
      mov ah,4Ah
      int 21h     ;Ужимаем размер отведенной памяти до метки Finish

; -- Отводим основную память --
      mov ah,48h
      mov bx,4096     ;4096 * 16 = 65536 байт
      int 21h
      jc Error_main
      mov Buffer1,ax  ;Сохраним сегмент первого отведенного блока

      mov ah,48h
      mov bx,4096     ;4096 * 16 = 65536 байт
      int 21h
      jc Error_main
      mov Buffer2,ax  ;Сохраним сегмент второго отведенного блока

  ret

Error_main:
;Ошибка?
      mov ah,9
      mov dx,offset Error_alloc
      int 21h

      int 20h

Buffer1 dw ?
Buffer2 dw ?
Prepare_memory endp

; === Пересылаем прочитанные данные в XMS память и обратно в основную ===
Move_toXMS proc

;<<< Сперва из основной в РАСШИРЕННУЮ >>>

      mov ax,Bytes
      mov word ptr XMS_str,ax   ;Кол-во пересылаемых байт

      mov word ptr XMS_offsrc,0 ;Смещение в основной памяти
      mov ax,Buffer1
      mov word ptr XMS_offsrc+2,ax  ;Сегмент в основной памяти

      mov ax,XMS_id             ;Идентификатор приемника (т.е. XMS-памяти)
      mov XMS_rec,ax

      mov ah,0Bh
      mov si,offset XMS_str
      call dword ptr XMS_Addr


;<<< Теперь из расширенной в ОСНОВНУЮ >>>

      mov ax,Bytes
      mov word ptr XMS_str,ax   ;Кол-во пересылаемых байт

      mov ax,XMS_id
      mov XMS_src,ax

      mov dword ptr XMS_offsrc,0

      mov XMS_rec,0

      mov ax,Buffer2
      mov word ptr XMS_offrec,0
      mov word ptr XMS_offrec+2,ax

      mov ah,0Bh
      mov si,offset XMS_str
      call dword ptr XMS_Addr

 ret

XMS_str    dd 0 ;Кол-во байт для пересылки
XMS_src    dw 0 ;Источник
XMS_offsrc dd 0 ;Смещение в блоке-источнике или адрес в основной памяти
XMS_rec    dw 0 ;Идентификатор приемника
XMS_offrec dd 0 ;Смещение в блоке-приемнике или адрес в основной памяти

Move_toXMS endp

Mess_about db 0Ah, 0Dh, 'XMSBLOCK - читаем файл в XMS-память.',0Ah, 0Dh
           db 'Книга "Ассемблер? Это просто! Учимся программировать", Глава № 30',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru. E-mail: Assembler@Kalashnikoff.ru',0Ah,0Dh,0Ah
           db '(C) Авторские права на файлы-приложения принадлежат читателям книги.',0Ah, 0Dh, 0Ah
           db 9,9,'=== Россия, Москва, 2001 год ===',0Ah,0Dh,'$'

Mess_errfile db 'Ошибка: указанный в переменной File_name файл не удалось открыть!',0Ah,0Ah,0Dh,'$'

Mess_nohimem db 'Драйвер Himem.sys не загружен! Невозможно использовать XMS-память!!!'
Mess_cursor db 0Ah, 0Dh,'$'

XMS_error db 'Ошибка распределения XMS-памяти!',0Ah, 0Dh,'$'

Error_alloc db 'Ошибка распределения основной памяти!',0Ah, 0Dh,'$'
XMS_Addr dd ?
XMS_id dw ?

Mess_first db 0Ah,0Ah,0Dh,'Прочитали файл в основную память...',0Ah,0Dh,'Выводим то, что находится в ОСНОВНОЙ памяти:',0Ah,0Ah,0Dh,'$'

Mess_second db 0Ah,0Ah,0Dh,'-------------------------------------------',0Ah,0Ah,0Dh,'Теперь выводим то, что переслано из ОСНОВНОЙ в РАСШИРЕННУЮ (XMS),',0Ah,0Dh,'а затем обратно в ОСНОВНУЮ память:',0Ah,0Ah,0Dh,'$'

Mess_third db 0Ah,0Ah,0Dh,'Оба сообщения должны совпадать!!! Иначе и быть не может!!!',0Ah,0Dh,0Dh,'$'

Handle dw ?
File_name db 'c:\autoexec.bat',0
Bytes dw 0
Number_dec dw 0

Finish equ $

CSEG ends
end Start