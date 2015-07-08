.686
.model flat
.XMM
option casemap: none
.data
  res DD 4 DUP(0)
.code
_mod_ex proc
  push   EBP
  mov    EBP, ESP
  mov    ESI, dword ptr [EBP+8]
  lea    EDI, res
  movups XMM0, [ESI]
  xorps  XMM1, XMM1
  subps  XMM1, XMM0
  maxps  XMM1, XMM0
  movups [EDI], XMM1
  lea    EAX, res
  pop    EBP
  ret
_mod_ex endp
end
