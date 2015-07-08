.model small
.data
  num1 DB '9'
  num2 DB '5'
  sum  DB 2 DUP (' ')
.code
start:
  mov  AX, @data
  mov  DS, AX
  clc                   ; очистка флага переноса и регистра AX
  xor  AX, AX
  mov  AL, num1         ; заносим первое число в AL
  adc  AL, num2         ; сложение с num2 с учетом переноса
  aaa                   ; коррекция результата
  or   AX, 3030h        ; преобразование в символьное представление
  xchg AH, AL           ; обмен байтами для подготовки вывода на экран
  mov  word ptr sum, AX ; сохранение результата в переменной sum
; вывод результата на экран
  mov CX, 2             ; помещаем число выводимых байт в регистр CX
  mov AH, 6h
  lea SI, sum           ; помещаем адрес переменной sum в SI
 next:
  mov DL, byte ptr [SI] ; помещаем выводимый байт в регистр DL
  int 21h               ; вывод на экран
  inc SI                ; заносим адрес следующего символа в SI
  loop next             ; повтор цикла
  mov ax, 4c00h
  int 21h
end start
end
