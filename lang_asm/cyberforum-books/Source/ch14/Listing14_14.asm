.686
.model flat
option casemap: none
.XMM
.data
  msk        label qword
   msk_high  DQ 7FFFFFFFFFFFFFFFh
   msk_low   DQ 7FFFFFFFFFFFFFFFh
  res DQ 0
.code
 abs_ex proc
   push   EBP
   mov    EBP, ESP
   mov    ESI, dword ptr [EBP+8]
   lea    EDI, msk
   lea    EBX, res
   movupd XMM0, [ESI]
   movupd XMM1, [EDI]
   andpd  XMM0, XMM1
   movups [EBX], XMM0
   lea    EAX, res
   pop    EBP
   ret
 abs_ex endp
 end
