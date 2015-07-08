.686
.model flat
.XMM
option casemap:none
.data
  res DD 4 DUP (0)
.code
 _reverse_ex proc
  push   EBP
  mov    EBP, ESP
  mov    ESI, dword ptr [EBP+8]
  lea    EBX, res
  movups XMM0, [ESI]
  shufps XMM0, XMM0, 1Bh
  movups [EBX], XMM0
  lea    EAX, res
  pop    EBP
  ret
 _reverse_ex endp
 end
