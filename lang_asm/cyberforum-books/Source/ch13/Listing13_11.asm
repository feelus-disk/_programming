.686
.model flat
.XMM
option casemap:none
.data
  res DD 32 DUP (0)
.code
_sqrt_ex proc
  push   EBP
  mov    EBP, ESP
  mov    EAX, dword ptr [EBP+12]
  shr    EAX, 2
  mov    EBX, 4
  xor    EDX, EDX
  div    EBX
  mov    ECX, EAX
  mov    ESI, dword ptr [EBP+8]
  lea    EDI, res
next:
  sqrtps XMM0, [ESI]
  movups [EDI], XMM0
  add    ESI, 16
  add    EDI, 16
  dec    ECX
  jnz    next
  cmp    EDX, 0
  je     exit
  mov    ECX, EDX
next1:
  sqrtss XMM0, [ESI]
  movss  [EDI], XMM0
  add    ESI, 4
  add    EDI, 4
  dec    ECX
  jnz    next1
exit:
  lea    EAX, res
  pop    EBP
  ret
_sqrt_ex endp
end
