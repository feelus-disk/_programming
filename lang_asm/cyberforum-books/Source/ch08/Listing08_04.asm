. . .
.data
op1     dw 1407      ; первый операнд
op2     dw 9119      ; второй операнд
carry   db 0      ; здесь запоминается флаг переноса
sum     dw 0      ; здесь хранится результат сложения
.code
addw_unsigned proc
  clc             ; очистка флага переноса перед сложением
  mov AX, op1
  add AX, op2
  jnc exit        ; проверка на переполнение
  add carry,1     ; сохраняем флаг переноса
exit:
  mov  sum, AX
  ret
addw_unsigned endp
