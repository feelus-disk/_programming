.586
.model flat
option casemap: none
.data
 iarray DD 45, -78, 34, 9, 231, 45, -12
 len    EQU $-iarray
 maxval DD 0
.code
 _max proc
  lea  ESI, iarray  ; адрес первого элемента -> ESI
  mov  ECX, len     ; размер массива -> ECX
  shr  ECX, 2       ; скорректировать размер
  mov  EAX, [ESI]   ; поместить первый элемент массива в EAX
                    ; и принять его в качестве максимума
next:
  cmp  EAX, [ESI+4] ; сравнить со следующим элементом массива
  jl   change       ; если EAX меньше, заменить его
go_loop:
  add  ESI, 4       ; перейти к следующему элементу
  loop next
  jmp  exit
change:
  mov  EAX, [ESI+4]
  jmp  go_loop
exit:
  mov  max, EAX
  lea  EAX, maxval
  ret
 _max  endp
  end
