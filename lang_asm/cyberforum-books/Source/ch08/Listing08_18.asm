.686
.model flat
option casemap:none
.data
  num1  DB '0037'
  len1  EQU $-num1
  num2  DB '0986'
  sum   DB 4 DUP (' ')    ; резервируем память для результата
.code
 _add_asc proc
   mov  ECX, len1         ; помещаем размер операндов (в байтах) в ECX
   clc                    ; очистка флага переноса
; побайтовое сложение в цикле
 again:
   mov  AL, byte ptr num1[ECX-1] ; помещаем младший байт num1 в AL
   adc  AL, byte ptr num2[ECX-1] ; сложение с таким же байтом в num2
   aaa                           ; коррекция результата
   mov  byte ptr sum[ECX-1], AL  ; сохранение результата в
                                 ; соответствующем байте переменной
                                 ; sum
   loop again
   adc  byte ptr sum[ECX-1], 0   ; коррекция результата
   or   dword ptr sum, 30303030h ; преобразование в символьный вид
   lea  EAX, sum                 ; сохраним адрес результата в регистре
                                 ; EAX
   ret
 _add_asc endp
 end
