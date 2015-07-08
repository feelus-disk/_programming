.data
  op1  DW 11901
  len  EQU $-op1
  op2  DW 5598
  sum  DW 0
.code
add_multibytes proc
  clc
  xor  AX, AX
  mov  CX, len
  lea  SI, byte ptr op1
  lea  DI, byte ptr op2
  lea  BX, byte ptr sum
next_byte:
  mov  AL, [SI]
  adc  AL, [DI]
  mov  byte ptr [BX], AL
  inc  SI
  inc  DI
  inc  BX
  loop next_byte
  ret
add_multibytes endp
