.686
.model flat
option casemap: none
.data
  num1  DD 4562, 1094, -502, 902
  len   EQU $-num1
  num2  DD 2341, 1094, -502, 87
  dst   DD 4 DUP(0)
.code
 _eq_dwords proc
   push   EBX
   lea    ESI, num1
   lea    EDI, num2
   lea    EDX, dst
   mov    ECX, len
 next:
   mov    EBX, 0
   mov    EAX, [ESI]
   cmp    EAX, [EDI]
   cmove  EBX, EAX
   mov    [EDX], EBX
   add    ESI, 4
   add    EDI, 4
   add    EDX, 4
   loop   next
   lea    EAX, dst
   pop    EBX
   ret
 _eq_dwords endp
 end
