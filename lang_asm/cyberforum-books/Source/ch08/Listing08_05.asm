.data
  op1  DW 3501
  op2  DW 781
  sum  DW 0
.code
add_multibytes proc
  clc
  xor AX, AX
  mov AL, byte ptr op1
  add AL, byte ptr op2
  mov byte ptr sum, AL
  mov AL, byte ptr op1+1
  adc AL, byte ptr op2+1
  mov byte ptr sum+1, AL
  ret
add_multibytes endp
