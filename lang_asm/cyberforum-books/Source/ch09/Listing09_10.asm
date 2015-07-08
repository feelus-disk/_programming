.686
.model flat
option casemap: none
.data
  op1  DD 0
  res  DD 0
.code
_int_ops proc
  push   EBP
  mov    EBP, ESP
  finit
  fild   dword ptr [EBP+8]
  ficom  dword ptr [EBP+12]
  fstsw  AX
  sahf
  jz     eq_0
  fisub  dword ptr [EBP+12]
  fistp  dword ptr op1
  fild   dword ptr [EBP+8]
  fiadd  dword ptr [EBP+12]
  fidiv  dword ptr op1
  fistp  dword ptr res
eq_0:
  lea    EAX, res
exit:
  pop    EBP
  ret
_int_ops endp
end
