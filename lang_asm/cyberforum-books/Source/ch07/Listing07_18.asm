.686
.model flat
option casemap: none
.data
  s1  DB "Test STRING"  ; перва€ строка
  len EQU $-s1          ; размер строки
  s2  DB "TEST STRING"  ; втора€ строка
  dst DB 11 DUP(' '),0  ; результирующа€ строка
.code
 _eq_bytes proc
   push   EBX
   lea    ESI, s1            ; адрес первой строки -> ESI
   lea    EDI, s2            ; адрес второй строки -> EDI
   lea    EDX, dst           ; адрес результирующей строки -> EDX
   mov    ECX, len           ; размер строки -> ECX
 next:
   mov    BL, '-'            ; исходное значение -> BL (вместо
                             ; символа С-С можно вз€ть другой)
   mov    AL, [ESI]          ; символ из строки-источника -> AL
   cmp    AL, [EDI]          ; сравнить с символом в той же позиции
                             ; строки-приемника
   cmove  EBX, EAX           ; если символы равны, поместить в регистр BL
                             ; символ из AL
   mov    byte ptr [EDX], BL ; сохранить символ на соответствующей
                             ; позиции в результирующей строке
   inc    ESI                ; адрес следующего символа источника -> ESI
   inc    EDI                ; адрес следующего символа приемника -> EDI
   inc    EDX                ; адрес следующего символа
                             ; строки результата -> EDX
   loop   next               ; переход к следующей итерации
   lea    EAX, dst           ; адрес результирующей строки -> EAX
   pop    EBX
   ret
  _eq_bytes endp
  end
