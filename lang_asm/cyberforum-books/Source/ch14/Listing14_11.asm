.686
.model flat
option casemap: none
.XMM
.data
  res DD 32 DUP(0)
.code
 _cvttsd2si_ex proc
  push      EBP
  mov       EBP, ESP
  mov       ESI, dword ptr [EBP+8]
  lea       EDI, res
  mov       ECX, dword ptr [EBP+12]
  shr       ECX, 3
next:
  movsd     XMM0, [ESI]
  cvttsd2si EAX, XMM0
  mov       [EDI], EAX
  add       ESI, 8
  add       EDI, 4
  dec       ECX
  jnz       next
  lea       EAX, res
  pop       EBP
  ret
_cvttsd2si_ex endp
 end
