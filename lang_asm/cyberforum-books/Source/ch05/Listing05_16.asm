.model small
.data
  s1    DB "String 1+String 2$"
  len   EQU   $-s1
  msg DB "Char + not found!$"
.code
  start:
   mov   AX, @data
   mov   DS, AX
   lea   SI, s1
   dec   SI
   mov   CL, len
   mov   AL, '+'
next:
   inc   SI
   cmp   byte ptr  [SI], AL
   je    $+8
   dec   CL
   jnz   next
   jmp   fail
   mov   DX, SI
   inc   DX
show:
   mov   AH, 9h
   int   21h
   mov   AH, 1h
   int   21h
   mov   AX, 4C00h
   int   21h
fail:
   lea   DX, msg
   jmp   show 
   end   start
   end
