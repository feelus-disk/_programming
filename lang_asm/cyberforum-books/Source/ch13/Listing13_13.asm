.686
.model flat
.XMM
option casemap:none
.data
  res DD 32 DUP (0)
.code
_max_ex proc
  push   EBP
  mov    EBP, ESP
  mov    EAX, dword ptr [EBP+16]
  shr    EAX, 2
  mov    EBX, 4
  xor    EDX, EDX
  div    EBX
  mov    ECX, EAX
  mov    ESI, dword ptr [EBP+8]
  mov    EDI, dword ptr [EBP+12]
  lea    EBX, res
next:
  movups XMM0, [ESI]
  movups XMM1, [EDI]
  maxps  XMM0, XMM1
  movups [EBX], XMM0
  add    ESI, 16
  add    EDI, 16
  add    EBX, 16
  dec    ECX
  jnz    next
  cmp    EDX, 0
  je     exit
  mov    ECX, EDX
next1:
  movss  XMM0, [ESI]
  movss  XMM1, [EDI]
  maxss  XMM0, XMM1
  movss  [EBX], XMM0
  add    ESI, 4
  add    EDI, 4
  add    EBX, 4
  dec    ECX
  jnz    next1
exit:
  lea    EAX, res
  pop    EBP
  ret
_max_ex endp
end
