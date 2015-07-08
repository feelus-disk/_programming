; ==== KEYBOARD.ASM - процедуры работы с клавиатурой ====

;  === Ждем нажатия клавиши ===
Pause proc
      xor ah,ah
      int 16h
      ret
Pause endp

; === Клавиша Insert ASCII 52h ===
Insert proc
      push es
      mov es,Seg_files    ;База файлов
      mov fs,Seg_offset   ;База смещений

      mov di,Current_file
      mov di,fs:[di]
      xor byte ptr es:[di],2  ;Инвертируем байт (отмечено / неотмечено)

      call Down_pressed ;Имитируем нажатие клавиши "стрелка вниз".

      mov Out_fstat,0   ;Выводить без чистки строк
      call Out_files

No_insert:
      pop es
      ret
Insert endp


; === Клавиша PgDown ASCII 51h ===
PgDown proc
;Имитировать будем нажатие клавиши "стрелка вниз" столько раз, сколько выводим
;файлов на экран.
      xor cx,cx
      mov cl,Number_files

Next_PgDn:
      push cx
      call Down_pressed ;Имитируем нажатие "клавиши вниз"
      pop cx
      dec cx
      or cx,cx
      jnz Next_PgDn

      ret
PgDown endp

; === Клавиша PgUp ASCII 49h ===
PgUp proc
      xor cx,cx
      mov cl,Number_files

Next_PgUp:
      push cx
      call Up_pressed
      pop cx
      loop Next_PgUp

      ret
PgUp endp

; === Клавиша Home ASCII 49h ===
K_Home proc
;Выводить будем до тех пор, пока процедура Up_pressed не вернет утановленный
;флаг переноса (Carry Flag)
Next_khome:
      call Up_pressed
      jnc Next_khome

      ret
K_Home endp

; === Клавиша End ASCII 49h ===
K_end proc
Next_kend:
      call Down_pressed
      jnc Next_kend

      ret
K_End endp


; === Клавиша вниз ===
;Пользователь нажал клавишу вниз! Переводим курсор на следующий файл...
Down_pressed proc
      push es
      mov es,Seg_files    ;База файлов
      mov fs,Seg_offset   ;База смещений

      mov di,Current_file
      add di,2
      mov di,fs:[di]
      cmp di,0FFFFh       ;Это последний файл?
      je No_down

;Нет. Тогда устанавливаем метку "текущий файл" для следующего файла
      or byte ptr es:[di],1 ;Нет. Тогда устанавливаем метку "текущий файл"

      mov Out_fstat,0
      mov di,Current_file
      mov di,fs:[di]    ;Текущий файл - сбрасываем метку текущего файла
      and byte ptr es:[di],11111110b

      add Current_file,2

;Вычисляем, нужно ли прокручивать файлы?
      mov ax,Current_file
      mov bx,Start_file
      sub ax,bx
      shr al,1
      cmp al,Number_files
      jb No_moved

;Нужно! Т.е. пользователь дошел до самого нижнего файла внизу экрана.
      add Start_file,2
      mov Out_fstat,1 ;Установим метку того, что нужно чистить строки.

No_moved:
      call Out_files ;Выводим файлы на экран
      clc
      pop es
      ret

No_down:
      pop es
      stc
      ret
Down_pressed endp

; === Клавиша вверх ===
;Пользователь нажал клавишу вверх! Переводим курсор на предыдущий файл...
Up_pressed proc
      push es
      mov es,Seg_files    ;База файлов
      mov fs,Seg_offset   ;База смещений

      mov Out_fstat,0
      mov di,Current_file
      mov di,fs:[di]
      or di,di       ;Это самый верхний файл?
      jz No_up

;Нет. Тогда сбрасываем метку "текущий файл" для текущего файла
      and byte ptr es:[di],11111110b

      sub Current_file,2
      mov di,Current_file
      mov di,fs:[di]

;Устанавливаем метку "текущий файл" для предыдущего файла
      or byte ptr es:[di],1

;Проверка на прокрутку экрана
      mov ax,Current_file
      add ax,2
      cmp ax,Start_file
      jne No_moveu

;Будем прокручивать, т.к. пользователь добрался курсором до верхней части
;экрана.
      mov Out_fstat,1
      sub Start_file,2

No_moveu:
      call Out_files ;Выводим файлы на экран
      clc
      pop es
      ret

No_up:
      pop es
      stc
      ret
Up_pressed endp

; === Клавиша Enter ===
Enter_pressed proc
;Пользователь нажал клавишу Enter! Меняем текущий каталог...
;!!! Обратите внимание, что мы пока не проверяем, нажал ли пользователь Enter
;на каталоге или файле !!!
      push es
      push ds

      mov di,Current_dir
      mov cx,0FFFFh
      xor al,al
      repne scasb
      dec di

      mov si,Current_file
      mov fs,Seg_offset
      mov si,fs:[si]
      mov ds,Seg_files
      add si,9

;Переходим в каталог верхнего уровня?
      cmp word ptr ds:[si],'..'
      jne Next_cdir

;Если так, то ищем в строке с текущим каталогом первый СЛЕВА символ "\"
;Пример: Допустим, текущий каталог такой:
;C:\ASSM\FILES\'ASCII 0'
;Будем искать символ '\' после M
      std
      dec di
      dec di
      mov al,'\'
      mov cx,0FFFFh
      repne scasb
      cld

;Добавляем нуль после первого левого найденного символа в текущем пути.
      add di,2
      xor al,al
      stosb
;Получили:
;C:\ASSM\'ASCII 0'
      jmp short Got_dp

;Если переходим в подкаталог, то добавляем к текущему пути имя каталога,
;на котором пользователь нажал "Enter".
;Например:
;C:\ASSM\FILES\'ASCII 0'
;После добавления будет так:
;C:\ASSM\FILES\MYFILES\'ASCII 0'
Next_cdir:
      lodsb
      or al,al
      jz Got_dir
      stosb
      jmp short Next_cdir

Got_dir:
      mov ax,005Ch  ;'\'
      stosw

Got_dp:
      pop es
      pop ds

;Инициализируем переменные...
      mov Current_file,0
      mov Start_file,0
      mov Out_fstat,1

;Перечитываем диск.
      call Draw_main_frame ;Рисуем головную рамку
      call Change_dir
      call Get_files  ;Читаем каталог в память
      call Out_files ;Выводим файлы на экран

      ret
Enter_pressed endp
