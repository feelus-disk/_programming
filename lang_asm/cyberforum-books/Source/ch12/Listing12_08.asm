.686
.model flat
.MMX
option casemap:none
.data
 a1  DW  1609, -13104, -30011, -9081,   -21209,  12056,  21305
 a2  DW  27791, -25959,  7290,   25544,  -9407,  -3099, -7901
 len EQU $-a2
 res DW len dup (0)
.code
 _psubsw_ex proc
   mov    EAX, len
   shr    EAX, 1
   mov    EBX, 4
   xor    EDX, EDX
   div    EBX
   mov    ECX, EAX
   lea    ESI, a1
   lea    EDI, a2
   lea    EBX, res
next:
   movq   MM0, qword ptr [ESI]
   movq   MM1, qword ptr [EDI]
   psubsw MM0, MM1
   movq   qword ptr [EBX], MM0
   emms
   add    ESI, 8
   add    EDI, 8
   add    EBX, 8
   dec    ECX
   jnz    next 
   cmp    EDX, 0
   je     exit
   mov    ECX, EDX
next1:
   mov    AX, word ptr [ESI]
   sub    AX, word ptr [EDI]
   mov    word ptr [EBX], AX
   add    ESI, 2
   add    EDI, 2
   add    EBX, 2
   dec    ECX
   jnz    next1
exit:
   lea    EAX, word ptr res
   ret
 _psubsw_ex endp
 end
