.686
.model flat
option casemap: none
.XMM
.data
  res DQ 0
.code
 subsd_ex proc
   push   EBP
   mov    EBP, ESP
   lea    EBX, res
   movsd  XMM0, [EBP+8]
   subsd  XMM0, [EBP+16]
   movsd  [EBX], XMM0
   lea    EAX, res
   pop    EBP
   ret
 subsd_ex endp
 end
