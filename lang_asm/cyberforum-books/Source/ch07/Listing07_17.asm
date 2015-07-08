.model small
.stack
.data
  src    DB    "FIRST STRING 1"
  lsrc   EQU $-src
  dst    DB    "FIRST STRING 2"
  equal  DB   "EQUAL", '$'
  non_eq DB   "NOT equal", '$'
.code
start:
   mov  AX, @data
   mov  DS, AX
   mov  ES, AX
   lea  SI, src
   lea  DI, dst
   mov  CX, lsrc
again:
   mov  AL, [SI]
   cmp  AL, [DI]
   je   next_cmp
   lea  DX, non_eq
   jmp  output
next_cmp:
   inc  SI
   inc  DI
   loop again
   lea  DX, equal
output:
   mov  AH, 9h
   int  21h
   mov  AX, 4c00h
   int  21h
   end  start
   end
