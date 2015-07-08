.model small
option casemap:none
.data
  s1  DB  " TEST: first word     second word    third     word OK    !  "
  len EQU $-s1
  msg DB  "Number of words = "
  cnt DB  0
      DB  '$'
.code
start:
  mov   AX, @data
  mov   DS, AX
  mov   ES, AX
  mov   CX, len    ; размер строки -> CX
  lea   DI, s1     ; адрес первого элемента строки -> DI
  mov   AL, ' '    ; символ-разделитель -> AX
  cld              ; инкремент адреса для последующих операций
next:
  repe  scasb      ; пропускаем пробелы
  je    exit       ; кроме пробелов ничего нет — закончить работу
                   ; программы
  inc   cnt        ; обнаружено слово — увеличить счетчик слов
  repne scasb      ; ищем конец слова, дальше должны быть пробелы
  jne   exit       ; строка закончилась — выйти из программы
  jmp   next       ; поиск следующего слова
exit:
 or     cnt, 30h   ; преобразовать однобайтовое число
                   ; в символьный ASCII-формат
 lea    DX, msg    ; отобразить результат
 mov    AH, 9h
 int    21h
 mov    AX, 4C00h  ; завершить программу
 int    21h
end     start
end
