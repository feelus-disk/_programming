; ==== FILES.ASM - процедуры работы с файлами ====

; !!! Здесь придется повозиться не меньше, чем с Keyboard.asm !!!

; === Читаем файлы в текущем каталоге ===
Get_files proc
      push es
      mov es,Seg_files

      mov Current_offset,500
      mov Prev_file,0

      mov di,Current_offset
      xor eax,eax
      stosd

      call Get_first  ;Получаем первый файл
      jc No_morefiles ;Если нет файлов вообще - на выход

      cmp word ptr es:[2Ch],002Eh ;Первый файл - '.'?
      je Next_file_   ;Если так, то ищем следующий файл...

      call Move_file  ;Если нет, то переносим файл в память.

Next_file_:
      call Get_other  ;Получаем следующий файл...
      jc No_morefiles ;Файлы закончились - на выход.

      call Move_file  ;Если нет, то переносим файл в память.
      jmp short Next_file_ ;Ищем следующий файл...

No_morefiles:
      mov di,Next_file
      xor ax,ax
      stosw

      mov di,500
      mov Current_file,di
;Будет указывать на то, что первый файл - текущий
      mov di,Current_file
      or byte ptr es:[di+4],1

      pop es
      ret

All_files db '*.*',0
Seg_files dw ? ;Сегментный адрес буфера файлов
Current_offset dw 500
Next_file dw ?
Prev_file dw 0
Get_files endp

; === Поиск первого файла в текущем каталоге ===
Get_first proc
;Здесь можно поставить инструкцию int 3 и в процессе отладки позволить
;отладчику выполнить программу до конца (Run). Дойдя до int 3 отладчик
;обязательно остановится, что позволит вам проанализировать работу
;приведенных ниже строк. Попробуйте!

;     int 3        ;<=== Как точка останова для отладчика (BreakPoint)

      mov ax,714Eh ;Функция поиска первого файла
      xor di,di ;DI должен указывать на буфер, куда будут записываться
      xor si,si ;данные о найденном файле (типа DTA). SI пока остается тайной!
      mov cx,0FFh ;Ищем все возможные файлы. Это что-то вроде атрибутов файла
      mov dx,offset All_files ;Маска поиска
      int 21h
      mov Handle,ax ;Сохраним номер процесса поиска файлов для 714Fh
      ret
Get_first endp

; === Поиск следующих файлов ===
Get_other proc
      mov bx,Handle ;Указываем номер процесса.
      mov ax,714Fh  ;Функция поиска следующих файлов
      xor si,si
      xor di,di     ;DI должен указывать на буфер, куда будут записываться
      int 21h       ;данные о найденном файле (типа DTA).
      ret
Get_other endp

; --- Перенос имени найденного файла в сегмент файлов нашей программы ---
Move_file proc
;Рекомендую здесь также установить точку останова, как показано выше 
;      int 3
      push ds
      mov di,Current_offset ;Текущее свободное смещение
      push di

;Пропустим 4 байта, в которые будут занесены адреса предыдущего и следующего
;файлов в цепочке. 0000h будет свидетельствовать о первом или последнем файле.
      add di,4

      xor al,al      ;Занесем 0, что будет свидетельствовать...
      stosb          ;...о статусе файла (текущий и/или отмеченный)
      mov ds,Seg_files
      mov si,2Ch     ;SI=имя найденного файла

Next_fbyte:
      lodsb          ;Получаем первый символ имени файла
      stosb          ;Сохраним символ в памяти
      or al,al       ;Это нуль (конец имени)?
      jnz Next_fbyte ;Следующий символ...

;Заносим размер файла
      mov si,1Ch     ;По этому смещению будет размер файла (4 слова)
      lodsd
      stosd
      lodsd
      stosd

      pop si
      pop ds
      mov es:[si],di   ;Адрес следующего файла
      mov Next_file,si

      mov ax,Prev_file ;Адрес предыдущего файла
      mov es:[si+2],ax
      mov Prev_file,si

      mov Current_offset,di ;Сохраним текущее смещение
      ret
Move_file endp

; === Вывод наденных файлов на экран ===
Out_files proc
      ;int 3  ;--- !!! ОБЯЗАТЕЛЬНО установите здесь точку останова !!!

      mov bl,Number_files  ;BL указывает на количество выводимых файлов
      push ds
      push es
      push 0B800h
      pop es

      mov si,Start_file ;SI = начальную позицию при выводе на экран
      mov ah,1Bh
      mov dx,0302h      ;Начало для вывода файлов
      mov ds,Seg_files  ;DS=сегмент найденных файлов в памяти

Next_fileout:
      mov di,[si]

      mov bh,[si+4]
      push di
      add si,5

      call Print_string     ;Выводим очередной файл...

      call Print_fsize      ;Выводим размер файла...

      call Get_status       ;Проверим статус файла...

      pop si
      or si,si          ;Последний файл?
      jz Exit_files     ;Тогда выходим.

      add dx,0100h ;Иначе увеличиваем DH на 1 для вывода следующего имени...
      dec bl       ;Уменьшаем количество выводимых файлов на 1
      jnz short Next_fileout ;Уже 0? Тогда больше выводить не нужно...

Exit_files:
      pop es
      pop ds
      ret

Number_files db 21 ;Количество выводимых файлов на экран.
Start_file dw 500  ;Адрес (смещение) стартового файла для вывода на экран
                   ;Первые 500 байт отводятся для функций 714Eh и 714Fh, куда
                   ;они будут помещать информацию о найденном файле.
                   ;Что-то вроде DTA, только "посовременней"...
Out_files endp

; === Проверяем статус файла ===
Get_status proc
      pusha
      mov ah,1Bh   ;Обычный файл...

      or bh,bh     ;Есть какие-нибудь метки?
      jz Quit_sts  ;Нет - на выход 

      mov ah,30h
      cmp bh,1     ;Это текущий файл?
      jz Quit_sts  ;Да - на выход 

      mov ah,1Eh
      cmp bh,2     ;Это отмеченный файл?
      jz Quit_sts  ;Да - на выход 

      mov ah,3Eh   ;Получается, что текущий + отмеченный...

Quit_sts:
      mov dl,1     ;Разрисовываем его...
      mov cx,78
      call Color_line
      popa
      ret
Get_status endp

; === Выводим размер файла ===
Print_fsize proc
      pusha
      push ds

      mov eax,ds:[si]   ;Получим первую часть размера файла
      mov ebx,ds:[si+4] ;Получим вторую часть

      push cs
      pop ds

      mov si,offset Number_dec ;Занесем размер файла в переменную Number_dec
      mov dword ptr [si],ebx   ;Процедура Out_dec будет выводить число,
      mov dword ptr [si+4],eax ;которое находится именно в этой переменной.

      mov dl,50        ;DL указывает на колонку
      mov ah,1Bh       ;AH содержит атрибуты для выводимого числа
      call Out_dec     ;Выводим число

      pop ds
      popa
      ret
Print_fsize endp