.686
.model flat
.XMM
option casemap: none
.data
 a1  DD -7,8,-6,5,-3,-8,-3,33,21,-13,61,-1,11,-44,-970,-22,77,-901
 len EQU $-a1
 a2  DD len DUP(0)
.code
_movups_copy proc
  push EBX
  lea  ESI, a1
  lea  EDI, a2
  mov  ECX, len
  shr  ECX, 2
  mov  EBX, 4
  mov  EAX, ECX
  xor  EDX, EDX
  div  EBX
  mov  ECX, EAX
next_16:
  movups  XMM0, [ESI]
  movups  [EDI], XMM0
  add  ESI, 16
  add  EDI, 16
  dec  ECX
  jnz  next_16
  cmp  EDX, 0
  je   exit
  mov  ECX, EDX
  cld
  rep  movsd
exit:
  lea  EAX, a2
  pop  EBX
  ret
_movups_copy endp
end
