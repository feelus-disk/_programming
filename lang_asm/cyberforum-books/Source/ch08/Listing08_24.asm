.686
.model flat
option casemap: none
.data
  op_bin  dd 273
  op_asc  db  3 dup (' ')
.code
 _bin_asc_5 proc
   lea  ESI, op_asc+2
   mov  EAX, op_bin
   mov  EBX, 10
 next:
   xor  EDX, EDX
   div  EBX
   or   EDX, 30h
   mov  byte ptr [ESI], DL
   cmp  EAX, 10
   jl   complete
   dec  ESI
   jmp  next
 complete:
   or   EAX, 30h
   dec  SI
   mov  byte ptr [ESI], AL
   clc
   mov  AL, byte ptr op_asc+2
   adc  AL, '5'
   aaa
   or   AL, 30h
   mov  byte ptr op_asc+2, AL
   lea  EAX, op_asc
   ret
 _bin_asc_5 endp
  end
