.586
.model flat
option casemap: none
.data
  a1        DD 123, -96, -17, 403
  len       EQU $-a1
  res       label dword
  sum_plus  DD 0
  sum_minus DD 0
.code
 _sum_plus_minus proc
   mov ECX, len   ; помещаем размер массива a1 в регистр ECX
   shr ECX, 2     ; корректируем счетчик для двойных слов
   lea EBX, a1    ; адрес массива a1 –> EBX
next:
   xor EAX, EAX
   mov EAX, dword ptr [EBX] ; очередной операнд -> EAX
   cmp EAX, 0               ; сравнить с нулем
   jl  plus                 ; если число больше 0, прибавить его
                            ; к sum_plus
   add sum_plus, EAX
   jmp continue
 plus:
   adc sum_minus, EAX       ; число меньше 0, прибавить его
                            ; к sum_minus
 continue:
   add EBX, 4               ; переход к следующему элементу массива
   loop next                ; следующая итерация
   lea  EAX, res            ; адрес результата -> EAX
   ret
 _sum_plus_minus endp
  end
