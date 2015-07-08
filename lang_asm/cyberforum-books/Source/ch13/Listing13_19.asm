.686
.model flat
.XMM
option casemap:none
.data
  res DD 32 DUP (0)
.code
_cvtps2pi_ex proc
  push     EBP
  mov      EBP, ESP
  mov      EAX, dword ptr [EBP+12]
  shr      EAX, 2
  mov      EBX, 2
  xor      EDX, EDX
  div      EBX
  mov      ECX, EAX
  mov      ESI, dword ptr [EBP+8]
  lea      EDI, res
next:
  movlps   XMM0, [ESI]
  cvtps2pi MM0, XMM0
  movq     [EDI], MM0
  add      ESI, 8
  add      EDI, 8
  dec      ECX
  jnz      next
  cmp      EDX, 0
  je       exit
  mov      ECX, EDX
next1:
  movss    XMM0, [ESI]
  cvtss2si EAX, XMM0
  mov      [EDI], EAX
  add      ESI, 4
  add      EDI, 4
  dec      ECX
  jnz      next1
exit:
  lea      EAX, res
  pop      EBP
  ret
_cvtps2pi_ex endp
end
