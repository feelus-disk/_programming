.686
.model flat
option casemap: none
.XMM
.data
  res DQ 2 DUP (0)
.code
 addpd_ex proc
   push   EBP
   mov    EBP, ESP
   mov    ESI, dword ptr [EBP+8]
   mov    EDI, dword ptr [EBP+12]
   lea    EBX, res
   movupd XMM0, [ESI]
   addpd  XMM0, [EDI]
   movupd [EBX], XMM0
   lea    EAX, res
   pop    EBP
   ret
 addpd_ex endp
 end
