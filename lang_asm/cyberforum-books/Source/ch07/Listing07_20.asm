.model small
.stack 100h
.data
 src DB " TEST STRING !$"
 len EQU $-src
.code
 start:
   mov    AX, @data
   mov    ES, AX
   mov    DS, AX
   lea    DI, src
   mov    CX, len-1
   cld
   mov    AL, ' '
next:
   scasb
   je     change
   loop   next
   lea    DX, src
   mov    AH, 9h
   int    21h
   jmp    exit
change:
  mov     byte ptr [DI-1], '+'
  dec     CX
  jmp     next
exit:
  mov     AX, 4c00h
  int     21h
  end     start
  end
