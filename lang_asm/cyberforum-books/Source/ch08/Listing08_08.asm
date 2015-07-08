.686
.model flat
option casemap:none
.data
  op1    DQ  15751
  len    EQU $-op1
  op2    DQ  91839
  sum    DQ  0
.code
 _add_8bytes proc
  push EBX
  clc
  xor  EAX, EAX
  mov  ECX, len
  lea  ESI, byte ptr op1
  lea  EDI, byte ptr op2
  lea  EBX, byte ptr sum
next_byte:
  mov  AL, [ESI]
  adc  AL, [EDI]
  mov  byte ptr [EBX], AL
  inc  ESI
  inc  EDI
  inc  EBX
  loop next_byte
  lea  EAX, sum
  pop  EBX
  ret
 _add_8bytes endp
 end
