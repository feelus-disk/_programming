.686
.model flat
option casemap:none
.data
  op1  DD 32267  ; |младшее слово = b |старшее слово = a |
  op2  DD 17904  ; |младшее слово = d |старшее слово = c |
  res  DQ 0
.code
 _mul_multibytes proc
   lea  ESI, op1     ; помещаем адрес op1 в ESI
   lea  EDI, op2     ; помещаем адрес op2 в EDI
;   вычисляем частичное произведение b * d
   clc
   mov   AX, word ptr [ESI] ; помещаем b в AX
   push  EAX                ; сохраняем EAX
   mov   BX, word ptr [EDI] ; помещаем d в BX
   mul   BX                 ; умножение AX * BX
   mov   word ptr res, AX   ; сохраняем младшую часть результата
   mov   word ptr res+2, DX ; сохранаем старшую часть результата
   pop   EAX         ; извлекаем EAX для вычисления второго произведения
;   вычисляем частичное произведение b * c
   mov   BX, word ptr [EDI]+2 ; помещаем c в BX
   mul   BX                   ; умножение AX * BX
   add   word ptr res+2, AX   ;сложение частичных произведений b * d и b * c
   adc   word ptr res+4, DX   ; учесть перенос
   jnc   next                 ; возник перенос?
   inc   word ptr res+6       ; да, нужно его учесть в старшем слове
 next:
;   вычисляем частичное произведение a * d
   mov   AX, word ptr [ESI]+2 ; помещаем a в AX
   push  EAX                  ; сохраняем EAX
   mov   BX, word ptr [EDI]   ; помещаем d  в BX
   mul   BX                   ; умножение AX * BX
   add   word ptr res+2, AX   ; прибавляем a * d к полному произведению
   adc   word ptr res+4, DX   ; учесть перенос
   pop   EAX      ; извлекаем EAX для вычисления четвертого произведения
   jnc   hi                   ; возник перенос
   inc   word ptr res+6       ; да, нужно его учесть в старшем слове
hi:
;   вычисляем частичное произведение a * c 
   mov   BX, word ptr [EDI]+2 ; помещаем c в BX
   mul   BX                   ; умножение AX * BX
   add   word ptr res+4, AX   ; прибавляем a * c к полному произведению
   adc   word ptr res+6, DX   ; учесть перенос
   lea   EAX, res             ; поместить в EAX адрес произведения
   ret
 _mul_multibytes endp
 end
