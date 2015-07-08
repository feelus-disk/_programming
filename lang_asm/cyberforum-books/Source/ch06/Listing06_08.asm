. . .
.data
  i1      DD 34
  i2      DD 17
  min_val DD ?
  abs_val DD ?
. . .
.code
. . .
 mov    EAX, i1
 mov    EВХ, i2
 call   minint
; минимум двух чисел i1 и i2 находится в регистре EAX. Сохраним это
; значение в переменной min_val и найдем абсолютное значение
 mov    min_val, EAX
 call   minabs
; сохраним модуль числа в переменной abs_val
 mov    abs_val, EAX
  . . .
; здесь объявляются процедуры minint и minabs
minint  proc
 cmp    EАХ,EВХ
 jl     exit
 mov    EАХ,EВХ
exit:
 ret
minint  endp
minabs  proc
 mov    EAX, min_val
 cmp    EAX, 0
 jge    quit
 neg    EAX
quit:
 ret
minabs  endp
. . .
