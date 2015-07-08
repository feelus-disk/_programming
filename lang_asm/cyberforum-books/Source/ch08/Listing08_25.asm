.586
.model flat
option casemap: none
.data
  a1  DD 12, -345, -49, 91
  a2  DD -48, 199, -812, 32
  len EQU $-a2
  sum DD 4 DUP (0)
.code
 _sum_ints proc
   mov ECX, len     ; размер массивов (в байтах) -> ECX
   shr ECX, 2       ; коррекция ECX для операций с двойными словами
                    ;(деление на 4)
   lea ESI, a1      ; адрес первого элемента массива a1 -> ESI
   lea EDI, a2      ; адрес первого элемента массива a2 -> EDI
   lea EBX, sum     ; адрес первого элемента массива sum -> EBX
 next:
   clc
   xor EAX, EAX     ; перед выполнением операций очищаем регистр EAX
   mov EAX, [ESI]   ; элемент массива a1 -> EAX
   adc EAX, [EDI]   ; сложить с соответствующим элементом массива a2
   mov [EBX], EAX   ; помещаем сумму элементов на соответствующую позицию
                    ; в массиве sum
   add ESI, 4       ; переход к адресу следующего элемента в массиве a1
   add EDI, 4       ; переход к адресу следующего элемента в массиве a2
   add EBX, 4       ; переход к адресу следующего элемента в массиве sum
   loop next        ; следующая итерация
   lea  EAX, sum    ; адрес массива sum -> EAX
   ret
 _sum_ints endp
  end
