.686
.model flat
option casemap:none
.data
  iarray  DD 273, 417, -31, -92, 5, -67, 360
  len     EQU $-iarray
.code
 _set0 proc
   push  EBX
   lea   ESI, iarray
   mov   EDX, len
   shr   EDX, 2
next:
   xor   EBX, EBX
   cmp   dword ptr [ESI], 0
   setge BL
   imul  EBX, dword ptr [ESI]
   mov   dword ptr [ESI], EBX
   add   ESI, 4
   dec   EDX
   jnz   next
   lea   EAX, iarray
   pop   EBX
   ret
  _set0 endp
  end
