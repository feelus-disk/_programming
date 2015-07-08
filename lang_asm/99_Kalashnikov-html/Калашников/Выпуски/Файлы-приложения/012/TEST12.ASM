
;		TEST12.ASM - программа к Главе № 12

CSEG segment
assume cs:CSEG, ds:CSEG, ss:CSEG, es:CSEG
org 100h

Begin:
      mov ax,8899h	;Проверим, загружен ли резидент?
      int 10h

      cmp ax,9988h
      je Ok_resident	;Если загружен, то выводим строку 

      mov ah,9		;Если нет, то выводим соответствующее сообщение
      mov dx,offset No_resident
      int 21h

      ret		;И выходим из программы

Ok_resident:
      mov ah,3		;Получим текущую позицию курсора...
      mov bh,0
      int 10h
      push dx		;...И запомним ее

      mov ah,2		;Спрячем курсор
      mov dx,1900h	;Просто установим его за границу экрана
      int 10h

      mov ah,88h  ;Функция 88h прерывания 10h - вывод строки (наш резидент!)
      mov si,offset String ;DS:SI - указывают на строку
      int 10h	  ;Выводим, используя наш резидент

      xor ah,ah
      int 16h	  ;Ждем клавишу...

      pop dx	  ;Восстановим сохраненное состояние курсора
      mov bh,0	  ;и покажем его снова...
      mov ah,2
      int 10h

      ret	  ;Можно еще выйти так: int 20h, но это на 1 байт длинее...


String db 'Моя строка для вывода !!!!!',0
No_resident db 'Резидент в памяти не обнаружен! Зпустить надо redid12.com сперва!$'

CSEG ends
end Begin
