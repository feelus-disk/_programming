. . .
.data
  op1   DB 140
  op2   DB 119
  sum   DW 0
.code
addb_unsigned proc
  xor AX, AX
  clc
  mov AL, op1
  adc AL, op2
  jnc exit
  adc  AH, 0
exit:
  mov  sum, AX
addb_unsigned endp
