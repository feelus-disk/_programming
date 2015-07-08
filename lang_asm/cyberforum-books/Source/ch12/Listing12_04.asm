.686
.model flat
.MMX
option casemap:none
.data
 a1  DW 12094, 31890, 4107, 41499, 32054, 35901, 45033, 50501, 33801
 a2  DW 43701, 39109, 43771, 29507, 47199, 2894, 34722, 23017, 7456
 len EQU $-a2
 dst DW len DUP(0)
.code
 _paddw_ex proc
   mov   EAX, len
   shr   EAX, 1
   mov   EBX, 4
   xor   EDX, EDX
   div   EBX
   mov   ECX, EAX
   lea   ESI, a1
   lea   EDI, a2
   lea   EBX, dst
next:
   movq  MM0, qword ptr [ESI]
   paddw MM0, qword ptr [EDI]
   movq  qword ptr [EBX], MM0
   add   ESI, 8
   add   EDI, 8
   add   EBX, 8
   dec   ECX
   jnz   next
   cmp   EDX, 0
   jz    exit
   mov   ECX, EDX
next1:
   mov   AX, word ptr [ESI]
   add   AX, word ptr [EDI]
   mov   word ptr [EBX], AX
   add   ESI, 2
   add   EDI, 2
   add   EBX, 2
   dec   ECX
   jnz   next1
 exit:
   lea   EAX, dst
   ret
 _paddw_ex endp
 end
