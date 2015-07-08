
;                  === MAIN.ASM - Головная процедура ===

Main_proc proc
      call Hide_cursor	;Прячем курсор

      call Save_mainscr ;Сохраним содержимое экрана...

      mov Height_X,23	;Высота рамки без '╔═╗' и '╚═╝'
      mov Width_Y,78	;Ширина рамки (т.е. на весь экран) без '║' и '║'
      mov Num_attr,31	;Цвет - светло-белый на синем фоне
      call Draw_frame	;В данном случае рисуем рамку на весь экран
;Поэксперементируйте с высотой и шириной, если будет желание...

      call Pause	   ;Ждем нажатия клавиши

      call Restore_mainscr ;Восстановим содержимое экрана!

      call Restore_cursor  ;Восстановим курсор

      ret		   ;Выход!
Main_proc endp