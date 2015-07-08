.model small
.data
  num1    DB '8'
  num2    DB '3'
.code
start:
  mov  AX, @data
  mov  DS, AX
  clc             ; очистка флага переноса
  mov  AL, num1   ; первое число в AL
  sbb  AL, num2   ; вычесть второе с учетом возможного заема
  aas             ; коррекция результата
  or   AL, 30h    ; преобразовать результат в символьное представление
; вывод на экран
  mov  DL, AL
  mov AH, 6h
  int 21h
  mov ax, 4c00h
  int 21h
end start
end
