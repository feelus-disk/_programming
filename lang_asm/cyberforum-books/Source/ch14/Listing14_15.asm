.686
.model flat
option casemap: none
.XMM
.data
  msk        label qword
   msk_high  DQ 8000000000000000h
   msk_low   DQ 8000000000000000h
  res DQ 0
.code
 sign_ex proc
   push   EBP
   mov    EBP, ESP
   mov    ESI, dword ptr [EBP+8]
   lea    EDI, msk
   lea    EBX, res
   movupd XMM0, [ESI]
   movupd XMM1, [EDI]
   xorpd  XMM0, XMM1
   movups [EBX], XMM0
   lea    EAX, res
   pop    EBP
   ret
 sign_ex endp
 end
