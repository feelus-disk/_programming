.model small
.data
  s1    DB "     String with leading blanks !$"
  len   EQU   $-s1
  msg DB "Blank string!$"
.code
  start:
   mov   AX, @data
   mov   DS, AX
   lea   SI, s1
   dec   SI
   mov   CX, len
   mov   AL, ' '
next:
   inc   SI
   cmp   byte ptr  [SI], AL
   jne   $+7
   dec   CX
   jnz   next
   jmp   fail
   mov   DX, SI
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
