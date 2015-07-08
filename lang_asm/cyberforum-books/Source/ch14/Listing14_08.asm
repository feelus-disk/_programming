.686
.model flat
.XMM
option casemap:none
.data
  res DQ 2 DUP(0)
.code
shufpd_ex proc
  push   EBP
  mov    EBP, ESP
  mov    ESI, dword ptr [EBP+8]
  lea    EDI, res
  movupd XMM0, [ESI]
  shufpd XMM0, XMM0, 3h
  movupd [EDI], XMM0
  lea    EAX, res
  pop    EBP
  ret
shufpd_ex endp
end
