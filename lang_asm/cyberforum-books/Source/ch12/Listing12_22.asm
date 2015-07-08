.686
.model flat
.MMX
option casemap: none
.data
 res  DD 10 DUP (0)
.code
 _pcmpeqd_ex proc
   push    EBP
   mov     EBP, ESP
   mov     ECX, dword ptr [EBP+16]
   shr     ECX, 3
   mov     ESI, dword ptr [EBP+8]
   mov     EDI, dword ptr [EBP+12]
   lea     EBX, res
next:
   movq    MM0, qword ptr [ESI]
   pcmpeqd MM0, qword ptr [EDI]
   movq    qword ptr [EBX], MM0
   add     ESI, 8
   add     EDI, 8
   add     EBX, 8
   dec     ECX
   jnz     next
   lea     EAX, res
   pop     EBP
   ret
  _pcmpeqd_ex endp
  end
