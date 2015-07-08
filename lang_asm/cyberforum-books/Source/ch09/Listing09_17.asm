.686
.model flat
option casemap:none
.data
  one   DD 1.0
  coeff DD 57.32
  res   DD 0
.code
_arcsin_demo proc
   push  EBP
   mov   EBP, ESP
   finit
   fld   dword ptr [EBP+8]
   fld   dword ptr [EBP+8]
   fmul
   fchs
   fadd  dword ptr one
   fsqrt
   fld   dword ptr [EBP+8]
   fdiv  st, st(1)
   fld1
   fpatan
   fmul  dword ptr coeff
 exit:  
   fstp  dword ptr res
   ;
   lea   EAX, res
   pop   EBP
   ret
 _arcsin_demo endp
 end
