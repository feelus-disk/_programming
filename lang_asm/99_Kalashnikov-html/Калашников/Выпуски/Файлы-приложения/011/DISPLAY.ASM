; Проверяем на текстовый режим монитора и на текущую видео страницу
Check_video proc
     mov ah,0Fh
     int 10h
     cmp al,3		;Текущий режим монитора текстовый?
     je Ok_video

     mov ax,3		;Если нет - делаем текстовый
     int 10h

Ok_video:
     cmp bh,0		;Нулевая страница?
     jz Ok_page

     mov ax,0500h 	;Если нет - делаем нулевую текущей
     int 10h

Ok_page:
     ret

Check_video endp
