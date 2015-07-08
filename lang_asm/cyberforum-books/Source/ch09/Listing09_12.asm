.686
.model flat
option casemap:none
.data
  coeff      DD  0.0174
  sincos_val label qword
     sin_val DD 0
     cos_val DD 0
.code
 _sincos_demo proc
   push  EBP
   mov   EBP, ESP
   finit
   fld   dword ptr [EBP+8]
   fmul  dword ptr coeff
   fsincos
   fstp  dword ptr cos_val
   fstp  dword ptr sin_val
   lea   EAX, sincos_val
   pop   EBP
   ret
 _sincos_demo endp
 end
