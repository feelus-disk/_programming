. . .
.data
op1           db ?      ; первый операнд
op2           db ?      ; второй операнд
carry         db 0      ; здесь запоминается флаг переноса
substract     db 0      ; здесь хранится результат вычитания
.code
sub_bytes proc
  clc             ; очистка флага переноса перед сложением
  mov AL, op1
  sub AL, op2
  jnc exit        ; проверка на переполнение
  add carry,0     ; сохраняем флаг переноса
exit:
  mov  substract, AL
  ret
sub_bytes endp
