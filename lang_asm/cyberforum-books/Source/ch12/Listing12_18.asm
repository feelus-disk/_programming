.686
.model flat
.MMX
option casemap:none
.data
  a1  DW 34, -56, 29, 91, -5, 27, 139, 44, -791, -30, -802
  a2  DW -12, 3, -52, 23, -67, 322, -501, 122, -7, -15, 199
  len EQU $-a2
  res DD len DUP(0)
.code
 _multiply_ex proc
   mov   EAX, len
   shr   EAX, 1
   mov   EBX, 4
   xor   EDX, EDX
   div   EBX
   mov   ECX, EAX
   lea  ESI, a1
   lea  EDI, a2
   lea  EBX, res
next:
   movq   MM1, qword ptr [ESI]
   movq   MM0, qword ptr [EDI]
   pmulhw MM0, MM1
   movq   MM2, qword ptr [EDI]
   pmullw MM1, MM2
   movq   MM2, MM0
   movq   MM3, MM1
   punpckhwd MM3, MM2
   punpcklwd MM1, MM0
   movq   qword ptr [EBX], MM1
   movq   qword ptr [EBX+8], MM3
   add    ESI, 8
   add    EDI, 8
   add    EBX, 16
   dec    ECX
   jnz    next
   cmp    EDX, 0
   jz     exit
   mov    ECX, EDX
next1:
   mov    AX, word ptr [ESI]
   imul   word ptr [EDI]
   mov    word ptr [EBX], AX
   mov    word ptr [EBX+2], DX
   add    ESI, 2
   add    EDI, 2
   add    EBX, 4
   dec    ECX
   jnz    next1
exit:
   lea    EAX, res
   ret
 _multiply_ex endp
 end
