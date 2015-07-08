.686
.model flat
option casemap: none
.data
  quotient  DD 0
  remainder DD 0
  dividend  DQ 1398
  divisor   DB 67
.code
_div_dd_byte proc
  movzx BX, divisor
  movzx EBX, BX
  mov   EAX, dword ptr dividend
  mov   EDX, dword ptr dividend+4
  div   EBX
  mov   quotient, EAX
  mov   remainder, EDX
  ret
 _div_dd_byte endp
 end
