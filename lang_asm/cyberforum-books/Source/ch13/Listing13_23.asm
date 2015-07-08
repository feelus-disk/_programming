.686
.model flat
.XMM
option casemap:none
.data
  res DD 4 DUP (0)
.code
 _shufps_ex proc
  push   EBP
  mov    EBP, ESP
  mov    ESI, dword ptr [EBP+8]
  mov    EDI, dword ptr [EBP+12]
  lea    EBX, res
  movups XMM0, [ESI]
  movups XMM1, [EDI]
  shufps XMM0, XMM1, 7Ah
  movups [EBX], XMM0
  lea    EAX, res
  pop    EBP
  ret
 _shufps_ex endp
 end
