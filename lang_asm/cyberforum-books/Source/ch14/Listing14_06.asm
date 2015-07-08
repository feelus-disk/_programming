.686
.model flat
option casemap: none
.XMM
.data
  res DQ 0
.code
 _minpd_ex proc
   push   EBP
   mov    EBP, ESP
   mov    ESI, dword ptr [EBP+8]
   mov    EDI, dword ptr [EBP+12]
   lea    EBX, res
   movupd XMM0, [ESI]
   minpd  XMM0, [EDI]
   movupd [EBX], XMM0
   lea    EAX, res
   pop    EBP
   ret
 _minpd_ex endp
 end
