.686
.model flat
.stack 100h
option casemap: none
  extern _add2:proc
  extern _sub1:proc
  public a1, a2, b3
.data
  a1    DD  12
  a2    DD  17
  b3    DD  34
.code
 _add_sub proc
   clc           ; очищаем флаг переноса
   call _add2    ; вычисляем сумму a1 + a2
   push  EAX     ; промежуточный результат помещаем в стек,
                 ; поскольку он будет использоваться
                 ; процедурой _sub1
   call _sub1    ; вычисляем разность полученной суммы (a1 + a2)
                 ; и числа b3. Результат возвращается в основную
                 ; программу через регистр EAX
   ret
 _add_sub endp
 end

