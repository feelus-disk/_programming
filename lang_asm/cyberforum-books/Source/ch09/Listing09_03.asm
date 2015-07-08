.686
.model flat
option casemap: none
.data
memo  label qword 
 memo1  DD 9.18      ; первое число
 memo2  DD 1.05      ; второе число
.code
 fxch_demo proc
   finit
   fld  memo1        ; поместить значение переменной
                     ; memo1 в стек   
   fld  memo2        ; поместить memo2 в стек
   fxch st(1)        ; обменять значения в st(0) и st(1)
   fstp memo2        ; сохранить содержимое вершины стека в memo2
   fstp memo1        ; сохранить содержимое вершины стека в memo1
   lea  EAX, memo    ; вернуть адрес области памяти в регистре EAX
   ret
 fxch_demo endp
 end
