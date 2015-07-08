.686
.model flat
option casemap: none
.data
  res DD 0
.code
 _lnx_demo proc
   push  EBP
   mov   EBP, ESP
   fldln2
   fld1
   fdiv
   fld   dword ptr [EBP+8]
   fyl2x
   fstp  dword ptr res
   lea   EAX, res
   pop   EBP
   ret
 _lnx_demo endp
 end
