.686
.model flat
option casemap: none
.XMM
.data
  res DQ 0
.code
 _combo_ex proc
   push   EBP
   mov    EBP, ESP
   lea    EBX, res
   movsd  XMM0, [EBP+8]  ; a1 –> XMM0
   movsd  XMM1, XMM0     ; a1 -> XMM1
   subsd  XMM0, [EBP+16] ; a1-b1 -> XMM0
   addsd  XMM1, [EBP+16] ; a1+b1 -> XMM1
   divsd  XMM0, XMM1     ; (a1-b1)/(a1+b1) -> XMM0
   movsd  [EBX], XMM0
   lea    EAX, res
   pop    EBP
   ret
 _combo_ex endp
 end
