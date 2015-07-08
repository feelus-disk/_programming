.686
.model flat
option casemap:none
.MMX
.data
  res DQ 0
.code
 _pand_ex proc
   push EBP
   mov  EBP, ESP
   movq MM0, qword ptr [EBP+8]
   pand MM0, qword ptr [EBP+16]
   movq qword ptr res, MM0
   lea  EAX, res
   pop  EBP
   ret
 _pand_ex endp
 _pandn_ex proc
   push  EBP
   mov   EBP, ESP
   movq  MM0, qword ptr [EBP+8]
   pandn MM0, qword ptr [EBP+16]
   movq  qword ptr res, MM0
   lea   EAX, res
   pop   EBP
   ret
 _pandn_ex endp
  _por_ex proc
   push EBP
   mov  EBP, ESP
   movq MM0, qword ptr [EBP+8]
   por  MM0, qword ptr [EBP+16]
   movq qword ptr res, MM0
   lea  EAX, res
   pop  EBP
   ret
 _por_ex endp
 _pxor_ex proc
   push EBP
   mov  EBP, ESP
   movq MM0, qword ptr [EBP+8]
   pxor MM0, qword ptr [EBP+16]
   movq qword ptr res, MM0
   lea  EAX, res
   pop  EBP
   ret
 _pxor_ex endp
 end
