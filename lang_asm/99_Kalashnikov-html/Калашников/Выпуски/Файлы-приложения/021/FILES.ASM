; ==== FILES.ASM - процедуры работы с файлами ====

; === Читаем файлы в текущем каталоге ===
Get_files proc
      call Get_first    ;Получаем первый файл
      jc No_morefiles   ;Если нет файлов вообще - на выход

      cmp word ptr cs:[DTA+1Eh],002Eh ;Первый файл - '.'?
      je Next_file    ;Если так, то ищем следующий файл...

      call Move_file  ;Если нет, то переносим файл в память.

Next_file:
      call Get_other  ;Получаем следующий файл...
      jc No_morefiles ;Файлы закончились - на выход.

      call Move_file  ;Если нет, то переносим файл в память.
      jmp short Next_file ;Ищем следующий файл...

No_morefiles:
      ret
Get_files endp

; === Поиск первого файла в текущем каталоге ===
Get_first proc
;Атрибуты файла (в CX):
;000001 - только чтение
;000010 - спрятанный
;000100 - системный
;001000 - метка тома
;010000 - подкаталог
;100000 - архивный

      mov ah,4Eh       ;Функция поиска первого файла
      mov cx,110111b   ;С атрибутами:
                       ;архивный (archive), подкаталог (directory),
                       ;системный (system), спрятанный (hidden)
                       ;только чтение (read-only)
      mov dx,offset All_files ;Маска поиска
      int 21h
      ret
Get_first endp

; === Поиск следующих файлов ===
Get_other proc
      mov ah,4Fh ;Функция поиска следующих файлов
      mov dx,9Eh ;DX указывает на DTA
      int 21h

      ret
Get_other endp

; --- Перенос файла из DTA в сегмент файлов ---
Move_file proc
      push es
      mov si,DTA+1Eh  ;SI=DTA+1Eh=имя найденного файла
      mov di,Current_offset ;Текущее свободное смещение
      mov es,Seg_files  ;ES=сегмент для найденных файлов

Next_fbyte:
      lodsb         ;Получаем первый символ имени файла
      or al,al      ;Это нуль (конец имени)?
      jz End_offile ;Да - на выход
      stosb         ;Нет - сохраним символ в памяти
      jmp short Next_fbyte ;Следующий символ...

End_offile:
      stosb         ;Запишем нуль в память после имени файла
      mov Current_offset,di ;Сохраним текущее смещение
      stosb         ;Запишем еще один нуль...
      pop es
      ret
Move_file endp

; === Вывод наденных файлов на экран ===
Out_files proc
      mov bl,Number_files  ;BL указывает на количество выводимых файлов
      push ds
      push es
      mov ds,Seg_files ;DS=сегмент найденных файлов в памяти
      push 0B800h
      pop es

      xor si,si
      mov ah,1Bh   ;Атрибуты
      mov dx,0302h ;Начало для вывода файлов

Next_fileout:
      call Print_string ;Выводим очередной файл

      cmp byte ptr [si],0 ;Следующий байт=0? Значит, это был последный файл...
      jz Exit_files  ;Тогда выходим.

      add dx,0100h ;Иначе увеличиваем DH на 1 для вывода следующего имени...
      dec bl       ;Уменьшаем количество выводимых файлов на 1
      jnz short Next_fileout ;Уже 0? Тогда больше выводить не нужно...

Exit_files:
      pop es
      pop ds
      ret

Number_files db 20 ;Количество выводимых файлов на экран.
Out_files endp
