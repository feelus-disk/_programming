; ==== FILES.ASM - процедуры работы с файлами ====

; === Читаем файлы в текущем каталоге ===
Get_files proc
      push cs       ;Инициализируем ES
      pop es

      mov fs,Seg_offset  ;FS - сегмент смещений файлов
      xor di,di
      mov Current_offset,di
      mov fs:[di],di     ;Получаем смещение файла в банке данных смещений
      mov bp,2           ;Следующий файл будет помещаться по адресу 2

      call Get_first  ;Получаем первый файл
      jc No_morefiles ;Если нет файлов вообще - на выход

      cmp word ptr es:[Temp_files+2Ch],002Eh ;Первый файл - '.'?
      je Next_file_   ;Если так, то ищем следующий файл...

      call Move_file  ;Если нет, то переносим файл в память.

Next_file_:
      call Get_other  ;Получаем следующий файл...
      jc No_morefiles ;Файлы закончились - на выход.

      call Move_file  ;Если нет, то переносим файл в память.
      jmp short Next_file_ ;Ищем следующий файл...

No_morefiles:
      mov word ptr fs:[bp-2],0FFFFh ;Признак конца списка файлов
      mov es,Seg_files     ;Первый файл сразу помеченный.
      mov byte ptr es:[0],1

      push cs
      pop es

      mov Current_file,0  ;Текущий файл - 0 (т.е. первый)
      ret

All_files db '*.*',0
Get_files endp

; --- Перенос имени найденного файла в сегмент файлов нашей программы ---
Move_file proc
      push es
      mov es,Seg_files
      mov si,offset Temp_files  ;Имя найденного файла
      mov di,Current_offset

      xor al,al          ;Заносим статус файла
      stosb
;Заносим размер файла
      mov eax,[si+1Ch]
      stosd
      mov eax,[si+20h]
      stosd

      add si,2Ch  ;SI - указывает на смещение найденного файла (DS:SI)
;Заносим имя найденного файла в буфер нашей программы
Next_byte:
      lodsb
      stosb
      or al,al
      jnz Next_byte

Quit_move:
;Заносим смещение файла в банк данных смещений
      mov Current_offset,di
      mov fs:[bp],di   ;FS:[BP] - указывает на следующий файл
      inc bp
      inc bp
      pop es
      ret
Move_file endp

; === Вывод ОДНОГО найденного файла на экран ===
Out_files proc
      mov bl,Number_files  ;BL указывает на количество выводимых файлов
      push ds
      push es
      push 0B800h
      pop es

      mov di,Start_file ;SI = начальную позицию при выводе на экран
      mov ah,1Bh
      mov dx,0302h      ;Начало для вывода файлов

      mov fs,Seg_offset ;FS - банк данных смещений
      mov ds,Seg_files  ;DS - банк данных файлов

Next_fileout:
      mov si,fs:[di] ;DS:SI - смещение следующего файла
      cmp si,0FFFFh  ;Последний файл?
      je Exit_files

      push si
      push di

      cmp cs:Out_fstat,0  ;Чистить ли строку перед выводом файла
      jz No_clear

;Чистим строку перед выводом файла
      mov al,32
      mov cx,77
      call Get_linear
      mov cx,77
      rep stosw

No_clear:
      add si,9
      call Print_string     ;Выводим очередной файл...
      pop di

;Выводим размер файла
      pop si
      call Print_fsize

;С какими атрибутами выводить (отмеченный, текущий...).
      mov bh,[si]
      call Get_status

      add dx,0100h ;Иначе увеличиваем DH на 1 для вывода следующего имени...
      inc di
      inc di
      dec bl       ;Уменьшаем количество выводимых файлов на 1
      jnz short Next_fileout ;Уже 0? Тогда больше выводить не нужно...

Exit_files:
      pop es
      pop ds
      ret

Number_files db 21 ;Количество выводимых файлов на экран.
Start_file dw 0
Out_fstat db 0
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

      mov eax,ds:[si+1] ;Получим первую часть размера файла
      mov ebx,ds:[si+5] ;Получим вторую часть

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

; === Поиск первого файла в текущем каталоге ===
Get_first proc
      mov ax,714Eh ;Функция поиска первого файла
      mov di,offset Temp_files ;DI должен указывать на буфер, куда будут
      xor si,si ;записываться данные о найденном файле (типа DTA).
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
      mov di,offset Temp_files ;DI должен указывать на буфер, куда будут
      int 21h       ;записываться данные о найденном файле (типа DTA).
      ret
Get_other endp
