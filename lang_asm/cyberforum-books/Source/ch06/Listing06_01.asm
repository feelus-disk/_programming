.model small
.data
  num1 DW '91'
  s1   DB  "STRING 1 $"
  s2   DB  "STRING 2 $"
.code
start:
   mov  AX, @data
   mov  DS, AX
   push DS:num1
   lea  SI, s2
   push SI
   lea  DX, s1
   mov  AH, 9h
   int  21h
   pop  DX
   int  21h
   pop  DX
   xchg DH, DL
   mov  AH, 2h
   int  21h
   xchg DH, DL
   int  21h
   mov  AX, 4c00h
   int  21h
   end  start
   end
