.686
.model flat
option casemap: none
.data
  _quotient  DD 0
  _remainder DD 0
  dividend   DQ 1398
  divisor    DB -93
.code
 _idiv_dd_byte proc
  movsx BX, divisor
  movsx EBX, BX
  mov   EAX, dword ptr dividend
  mov   EDX, dword ptr dividend+4
  idiv  EBX
  mov   _quotient, EAX
  mov   _remainder, EDX
  ret
 _idiv_dd_byte endp
 end
