.model small
.stack 100h
.data
  s1       DB 0dh, 0ah, "String s1$"  ; содержимое строки s1
  s2       DB 0dh, 0ah, "String s2$"  ; содержимое строки s2
  s3       DB 0dh, 0ah, "String s3$"  ; содержимое строки s3
  saddr   label dword                 ; адрес массива строк saddr
           DW  s1                     ; адрес строки s1
           DW  s2                     ; адрес строки s2
           DW  s3                     ; адрес строки s3
  num      DW  0                      ; начальное значение счетчика
.code
 start:
  mov   AX, @data
  mov   DS, AX
  mov   ES, AX
  mov   CX, 3
again:
  xor   SI, SI                        ; подготовить индексный регистр SI
  add   SI,  num                      ; num -> SI
  shl   SI, 1                         ; вычислить смещение
                                      ; в массиве saddr
  mov   DX, word ptr saddr[SI]        ; поместить в DX адрес строки
                                      ; и вывести ее на экран
  mov   AH, 9h
  int   21h
  inc   num                           ; инкремент счетчика для перехода к
                                      ; следующей строке
  loop  again                         ; следующая итерация
exit:
  mov   AX, 4c00h
  int   21h
  end start
  end
