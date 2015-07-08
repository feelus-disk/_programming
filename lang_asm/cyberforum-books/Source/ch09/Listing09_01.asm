.686
.model flat
option casemap: none
.data
 src  DD 13.49, -71.01, -8.15, 33.39, 765.11
 len  EQU $-src
 dst  DD len DUP(0)
.code
 move_float proc
   finit
   mov  ECX, len         ; количество байт массива src –> ECX
   shr  ECX, 2           ; привести к размерности двойного слова
   lea  ESI, src         ; алрес массива src -> ESI
   lea  EDI, dst         ; адрес массива dst -> EDI
next:
   fld  dword ptr [ESI]  ; поместить в вершину стека элемент массива src
   fstp dword ptr [EDI]  ; поместить в массив dst элемент
                         ; из вершины стека
   add  ESI, 4           ; перейти к следующему элементу в src
   add  EDI, 4           ; перейти к следующему элементу в dst
   dec  ECX              ; декремент счетчика
   jnz  next             ; если не равен 0, перейти
                         ; к следующей итерации
   lea  EAX, dst         ; вернуть в регистре EAX адрес массива dst
   ret
 move_float endp
 end
