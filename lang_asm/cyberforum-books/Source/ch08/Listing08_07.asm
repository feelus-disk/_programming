. . .
.data
  op1        DW  1901
  len        EQU $-op1
  op2        DW  5598
  substract  DW  0
.code
sub_multibytes proc
  clc
  xor  AX, AX
  mov  CX, len
  lea  SI, byte ptr op1
  lea  DI, byte ptr op2
  lea  BX, byte ptr substract
next_byte:
  mov  AL, [SI]
  sbb  AL, [DI]
  mov  byte ptr [BX], AL
  inc  SI
  inc  DI
  inc  BX
  loop next_byte
  ret
sub_multibytes endp
