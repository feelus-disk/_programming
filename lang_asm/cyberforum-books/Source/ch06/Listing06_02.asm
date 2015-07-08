. . .
.data
  op1 DW 1149h
  op2 DW 0E37h
.code
. . .
mov   AX, @data
mov   DS, AX
push  DS:op1
push  DS:op2
mov   BP, SP
mov   AX, word ptr [BP+2]
mov   BX, word ptr [BP]
. . .
