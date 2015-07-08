. . .
.data
op1     db ?      ; первый операнд
op2     db ?      ; второй операнд
carry   db 0      ; здесь запоминается флаг переноса
sum     db 0      ; здесь хранится результат сложения
.code
addb_unsigned proc
  clc             ; очистка флага переноса перед сложением
  mov AL, op1
  add AL, op2
  jnc exit        ; проверка на переполнение
  add carry,1     ; сохраняем флаг переноса
exit:
  mov  sum, AL
  ret
addb_unsigned endp
