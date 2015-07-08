.model small
.data
  s1    DB "     String with leading blanks !$"
  len   EQU   $-s1
  msg   DB "Blank string!$"
.code
  start:
   mov    AX, @data
   mov    DS, AX
   lea    SI, s1             ; адрес строки -> SI
   dec    SI                 ; декремент адреса для организации цикла
   mov    CX, len            ; размер строки -> CX
   mov    AL, ' '            ; шаблон для сравнения -> AL
next:
   inc    SI                 ; переход к адресу следующего элемента
   cmp    byte ptr  [SI], AL ; сравнить элемент строки с пробелом
   loope  next               ; повторять, пока не будет обнаружен символ,
                             ; отличный от пробела
                             ; либо не будет достигнут
                             ; конец строки
   cmp    CX, 0              ; был достигнут конец строки?
   je     fail               ; да, строка состоит из пробелов,
                             ; вывести соответствующее сообщение
   mov    DX, SI             ; нет, в строке есть другие символы,
                             ; поместить адрес первого символа,
                             ; отличного от пробела, в регистр DX
show:
   mov    AH, 9h             ; отобразить сообщения
   int    21h
   mov    AH, 1h
   int    21h
   mov    AX, 4C00h
   int    21h
fail:
   lea    DX, msg
   jmp    show 
   end    start
   end
