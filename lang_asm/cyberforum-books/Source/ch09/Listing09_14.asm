.686
.model flat
option casemap:none
.data
   coeff   DD 0.0174
   tan_val DD 0
_fptan_demo proc
   push  EBP
   mov   EBP, ESP
   finit
   fld   dword ptr [EBP+8]
   fmul  dword ptr coeff
   fptan
   fdivr st, st(1)
   fstp  dword ptr tan_val
   lea   EAX, tan_val
   pop   EBP
   ret
 _fptan_demo endp
 end
