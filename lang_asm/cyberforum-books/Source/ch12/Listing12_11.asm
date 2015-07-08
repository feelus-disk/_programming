.686
.model flat
.MMX
option casemap:none
.data
  a1  DD 7345,-4123,671,-34802,-611,75056,-8893,12,-6227,41161,-9991
  len EQU $-a1
  res DW len DUP(0)
.code
 _packssdw_ex proc
   mov  EAX, len
   shr  EAX, 2
   xor  EDX, EDX
   mov  EBX, 2
   div  EBX
   mov  ECX, EAX
   lea  ESI, a1
   lea  EDI, res
 next:
   movq     MM0, qword ptr [ESI]
   packssdw MM0, qword ptr [ESI+8]
   movq     qword ptr [EDI], MM0
   add      ESI, 16
   add      EDI, 8
   dec      ECX
   jnz      next
   cmp      EDX, 0
   je       exit
   mov      AX, word ptr [ESI]
   mov      word ptr [EDI], AX
 exit:
   lea      EAX, res
   ret
 _packssdw_ex endp
 end
