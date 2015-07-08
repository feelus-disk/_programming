.686
.model flat
option casemap:none
.data
  iarray  DD -73, 931, -89, 92, -5, 67, 30
  len     EQU $-iarray
.code
 _set0 proc
   lea   ESI, iarray        ; адрес массива -> ESI
   mov   EDX, len           ; размер массива (в байтах) -> EDX
   shr   EDX, 2             ; преобразовать в количество двойных слов
next:
   cmp   dword ptr [ESI], 0 ; сравнить элемент массива с нулем
   jge   no_change          ; если больше нуля, оставить без изменения
   mov   dword ptr [ESI], 0 ; если меньше нуля, заменить на 0
no_change:
   add   ESI, 4             ; перейти к следующему элементу 
   dec   EDX                ; уменьшить счетчик цикла на 1
   jnz   next               ; переход к следующей итерации
   lea   EAX, iarray        ; адрес массива -> EAX
   ret
  _set0 endp
  end
