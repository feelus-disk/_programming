.686
.model flat
.XMM
option casemap: none
.data
 res DQ 3 DUP(0)
.code
 int128_demo proc
   push     EBP
   mov      EBP, ESP
   mov      ESI, dword ptr [EBP+8]
   mov      EDI, dword ptr [EBP+12]
   lea      EBX, res
   mov      ECX, dword ptr [EBP+16]
   shr      ECX, 2
next:
   movd     MM0, dword ptr [ESI]   ; a1 -> MM0 (low 32 bit)
   movq2dq  XMM0, MM0              ; a1 -> XMM0 (low 32 bit)
   movdqu   XMM2, XMM0             ; save XMM0 in XMM2
   movd     MM0, dword ptr [EDI]   ; b1 -> MM0
   movq2dq  XMM1, MM0              ; b1 -> XMM0 (low 32 bit)
   psubd    XMM0, XMM1             ; a1-b1 -> XMM0
   paddd    XMM2, XMM1             ; a1+b1 -> XMM2
   pmuludq  XMM0, XMM2             ; (a1-b1)*(a1+b1) -> XMM0
   movdq2q  MM0, XMM0
   movq     [EBX], MM0
   add      ESI, 4
   add      EDI, 4
   add      EBX, 8
   dec      ECX
   jnz      next
   pop      EBP
   lea      EAX, res
   ret
 int128_demo endp
 end
