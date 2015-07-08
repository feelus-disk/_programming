;                  === MAIN.ASM - Головная процедура ===

Main_proc proc

      call Hide_cursor ;прячем курсор

      call Prepare_all

      call Save_mainscr ;сохраним содержимое экрана...

      push 23     ;высота рамки без '╔═╗' и '╚═╝'
      push 78     ;ширина рамки (т.е. на весь экран) без '║' и '║'
      push 1F00h  ;цвет - светло-белый на синем фоне
      push offset Mess_head ;надпись вверху рамки (если 0, то не выводить)
      push offset Mess_down ;надпись внизу рамки (если 0, то не выводить)
      push 0      ;сообщение внутри рамки (если 0, то не выводить)
      push 10b    ;Экран не копировать, но вывести верхнюю линию.
      call Draw_frame ;Рисуем рамку на весь экран
;ИТОГО: в стек заносим 14 байт вместо 20!

      call Get_files

      call Out_files

Next_key:
      call Pause ;давим кнопку!!!
      or al,al
      jz Ext_code  ;Это расширенный ASCII-код клавиши? Да - проверяем его. 

      cmp al,27    ;Нажали ESC?
      jne Next_key ;Нет - ждем дальше... 

      call Quit_prog ;Удостоверимся у пользователя о выходе из программы. 
      jnc Next_key   ;Пользователь подтвердил выход? НЕТ? Тогда на Next_key 

;Да, подтвердил (а жаль!). Тогда выходим.
      call Restore_mainscr ;восстановим содержимое экрана
      call Restore_cursor  ;восстановим позицию курсор

      ret ;выход!

Ext_code:
      cmp ah,62h         ;Нажали Ctrl+F5?
      je User_screenl    ;Да - показываем экран пользователю .
      jmp short Next_key ;Нет - ждем другую клавишу 

User_screenl:
      mov ax,0501h ;Показываем пользователю 1 видеостраницу.
      int 10h
      call Pause   ;Может быть, подождем?.. Клавишу, а не мою маму!

      mov ax,0500h ;Опять на нулевую устанавливаем.
      int 10h
      jmp short Next_key ;Ждем дальше... 
Main_proc endp

; === Готовим все необходимое для работы ===
Prepare_all proc
      call Set_DTA
      call Prepare_memory

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

; --- Установим DTA ---
Set_DTA proc
    mov ah,1Ah
    mov dx,80h
    int 21h
    ret
Set_DTA endp

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