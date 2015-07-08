.686
.model flat
.MMX
option casemap:none
.data
  a1  DW 45, -41, 67, -134, -61, 10, -88, 12, -62, 161,-99
  len EQU $-a1
  res DB len DUP(0)
.code
 _packsswb_ex proc
   mov  EAX, len
   shr  EAX, 1
   xor  EDX, EDX
   mov  EBX, 2
   div  EBX
   mov  ECX, EAX
   lea  ESI, a1
   lea  EDI, res
 next:
   movq     MM0, qword ptr [ESI]
   packsswb MM0, qword ptr [ESI+8]
   movq     qword ptr [EDI], MM0
   add      ESI, 16
   add      EDI, 8
   dec      ECX
   jnz      next
   cmp      EDX, 0
   je       exit
   mov      AL, byte ptr [ESI]
   mov      byte ptr [EDI], AL
 exit:
   lea      EAX, res
   ret
 _packsswb_ex endp
 end
