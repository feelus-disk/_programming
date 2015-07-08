.model small
.data
  s1  DB " TEST STRING$"
  len EQU $-s1
.code
  start:
   mov   AX, @data
   mov   DS, AX
   mov   ES, AX
   cld            ; установить флаг переноса дл€ инкремента адреса
   mov  AL, 'X'   ; символ-заполнитель -> AL
   lea  DI, s1    ; адрес строки-приемника
   mov  CX, len-1 ; размер строки без учета последнего символа -> CX
   rep  stosb     ; заполнить область пам€ти символом СXТ
   lea  DX, s1    ; вывод обновленной строки на экран
   mov  AH, 9h
   int  21h
   mov  AX, 4c00h
   int  21h
   end  start
   end
