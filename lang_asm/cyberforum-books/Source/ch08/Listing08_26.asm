.586
.model flat
option casemap: none
.data
  a1  DQ 123980127, -1296432345, -971743249, 9740391
  a2  DQ -48094715, 81199054, -81283467, 340917622
  len EQU $-a2
  sum DQ  4 DUP (0)
.code
 _sum_ints_64 proc
   mov ECX, len
   shr ECX, 3
   lea ESI, a1
   lea EDI, a2
   lea EBX, sum
 next:
   clc
   xor EAX, EAX
   mov EAX, dword ptr [ESI]
   add EAX, dword ptr [EDI]
   mov dword ptr [EBX], EAX
   mov EAX, dword ptr [ESI+4]
   adc EAX, dword ptr [EDI+4]
   mov dword ptr [EBX+4], EAX
   add ESI, 8
   add EDI, 8
   add EBX, 8
   loop next
   lea  EAX, sum
   ret
 _sum_ints_64 endp
  end
