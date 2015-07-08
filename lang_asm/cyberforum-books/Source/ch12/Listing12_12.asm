.686
.model flat
.MMX
option casemap:none
.data
  a1      DW 45, -41, 67, -134, -61, 10, -88, 12, -62, 61,-99
  b1      DW 37, -19, 122, 54,  88,   19, 133, 49, 13, 11,-29
  len     EQU $-b1
  a1_copy DB len DUP(0)
  b1_copy DB len DUP(0)
  res     DB len DUP(0)
.code
 _add_pack_bytes proc
   mov  EAX, len
   shr  EAX, 1
   xor  EDX, EDX
   mov  EBX, 2
   div  EBX
   mov  ECX, EAX
   push ECX
   push EDX
   lea  ESI, a1
   lea  EDI, a1_copy
   call convert_to_bytes
   lea  ESI, b1
   lea  EDI, b1_copy
   pop  EDX
   pop  ECX
   call convert_to_bytes
   mov  EAX, len
   mov  EBX, 8
   xor  EDX, EDX
   div  EBX
   mov  ECX, EAX
   lea  ESI, a1_copy
   lea  EDI, b1_copy
   lea  EBX, res
 again:
   movq MM0, qword ptr [ESI]
   paddsb MM0, qword ptr [EDI]
   movq   qword ptr [EBX], MM0
   add    ESI, 8
   add    EDI, 8
   add    EBX, 8
   dec    ECX
   jnz    again
   cmp    EDX, 0
   je     exit
   mov    ECX, EDX
next_byte:
   mov    AX, word ptr [ESI]
   add    AX, word ptr [EDI]
   mov    word ptr [EBX], AX
   add    ESI, 2
   add    EDI, 2
   add    EBX, 2
   dec    ECX
   jnz    next_byte
 exit:
   lea      EAX, res
   ret
   convert_to_bytes proc
 next:  
   movq     MM0, qword ptr [ESI]
   packsswb MM0, qword ptr [ESI+8]
   movq     qword ptr [EDI], MM0
   add      ESI, 16
   add      EDI, 8
   dec      ECX
   jnz      next
   cmp      EDX, 0
   je       quit
   mov      ECX, EDX
 next1:
   mov      AL, byte ptr [ESI]
   mov      byte ptr [EDI], AL
   inc      ESI
   inc      EDI
   dec      ECX
   jnz      next1
 quit:
   ret
 convert_to_bytes endp
 _add_pack_bytes endp
 end
