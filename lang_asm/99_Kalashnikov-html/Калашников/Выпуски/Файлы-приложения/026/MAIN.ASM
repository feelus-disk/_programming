;                  === MAIN.ASM - Головная процедура ===

Main_proc proc

      call Hide_cursor ;прячем курсор

      call Prepare_all

      call Save_mainscr ;сохраним содержимое экрана...

Re_Read_dir:
      call Draw_main_frame ;Рисуем головную рамку

      call Get_curdir ;Получаем текущий каталог

      call Change_dir ;Делаем его текущим

      call Get_files  ;Читаем каталог в память

Out_filesl:
      call Out_files ;Выводим файлы на экран

Next_key:
      call Pause
      or al,al
      jz Ext_code  ;Это расширенный ASCII-код клавиши? Да - проверяем его. 

      cmp al,27    ;Нажали ESC?
      je Quit_prg  ;Да! На метку 

      cmp al,13
      je Enter_prsd

      jmp short Next_key

Quit_prg:
      call Quit_prog ;Подтвердим намерения пользователя выйти из программы.
      jnc Next_key   ;Пользователь подтвердил выход? НЕТ? Тогда на Next_key 

;Да, подтвердил (а жаль!). Тогда выходим.
      call Restore_mainscr ;восстановим содержимое экрана
      call Restore_cursor  ;восстановим позицию курсор

      ret ;Выходим из процедуры MAIN.ASM, а затем сразу в DOS!

Enter_prsd:
      call Enter_pressed
      jmp short Next_key

Ext_code:
      cmp ah,60h         ;Нажали Ctrl+F3?
      je Re_read_dir     ;Да - перечитываем каталог .

      cmp ah,62h         ;Нажали Ctrl+F5?
      je User_screenl    ;Да - показываем экран пользователю .

      cmp ah,50h         ;Стрелка вниз?
      je Key_down

      cmp ah,48h
      je Key_up

      jmp short Next_key ;Нет - ждем другую клавишу 

Key_down:
      call Down_pressed
      jmp Out_filesl

Key_up:
      call Up_pressed
      jmp Out_filesl

User_screenl:
      mov ax,0501h ;Показываем пользователю 1 видеостраницу.
      int 10h
      call Pause   ;Ждем до тех пор, пока пользователь не налюбуется...

      mov ax,0500h ;Опять на нулевую устанавливаем.
      int 10h
      jmp short Next_key ;Ждем дальше... 
Main_proc endp

; === Готовим все необходимое для работы ===
Prepare_all proc
      call Prepare_memory ;Отводим память

      ret
Prepare_all endp

;--- Ужимаем память ---
Prepare_memory proc
      mov bx,offset Finish
      shr bx,4
      inc bx
      mov ah,4Ah
      int 21h

      mov ah,48h
      mov bx,1000h
      int 21h

      mov Seg_files,ax

      ret
Prepare_memory endp

; === Получаем текущий диск+каталог ===
Get_curdir proc
      mov dword ptr [Current_dir],005C3A43h ;Заносим ASCIZ C:\

      mov ah,19h
      int 21h   ;Получаем текущий диск
      add al,'A'
      mov byte ptr [Current_dir],al

      ret
Get_curdir endp

; === Change_dir ===
Change_dir proc
      mov ax,713Bh
      mov dx,offset Current_dir
      int 21h

      push 0B800h
      pop es
      mov ah,1Fh
      mov dx,0102h
      mov si,offset Current_dir
      call Print_string

      ret
Change_dir endp


; === Выходим из программы? ===
Quit_prog proc
      push 1     ;высота рамки
      push offset Mess_quitl ;ширина рамки
      push 4F00h ;цвет - светло-белый на синем фоне
      push offset Mess_qup   ;надпись вверху рамки (если 0, то не выводить)
      push 0     ;надпись внизу рамки (если 0, то не выводить)
      push offset Mess_quit  ;сообщение внутри рамки
      push 01b   ;Копировать экран, но не выводить верхнюю линию
      call Draw_frame ;Рисуем рамку

      call Pause
      call Restore_scr ;Восстановим сохранунную часть экрана.

      cmp al,'Y'       ;Нажали 'Y' / 'y' / Enter (13)?
      je Yes_quit      ;Да! 
      cmp al,'y'
      je Yes_quit
      cmp al,13
      je Yes_quit

      clc  ;Ставим меточку, что нажали другую клавишу (сбросим флаг переноса).
      ret

Yes_quit:
      stc  ;Установим флаг переноса (нажали 'Y', значит выходим)...
      ret
Quit_prog endp

; === Рисуем головную рамку ===
Draw_main_frame proc
      push 23     ;высота рамки
      push 78     ;ширина рамки (т.е. на весь экран)
      push Main_color ;цвет - светло-белый на синем фоне
      push offset Mess_head ;надпись вверху рамки (если 0, то не выводить)
      push offset Mess_down ;надпись внизу рамки (если 0, то не выводить)
      push 0      ;сообщение внутри рамки (если 0, то не выводить)
      push 10b    ;Экран не копировать, но вывести верхнюю линию.
      call Draw_frame ;Рисуем рамку на весь экран
      ret
Draw_main_frame endp
