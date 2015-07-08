.686
.model flat
.MMX
option casemap:none
.data
 src  DB "PHILADELPHIA FLYERS"
 len  EQU $-src
 tmp  DB len DUP (20h)
 dst  DB len DUP(' '),0
.code
 _paddb_ex proc
   mov   EAX, len
   mov   EBX, 8
   xor   EDX, EDX
   div   EBX
   mov   ECX, EAX
   lea   ESI, src
   lea   EDI, dst
   lea   EBX, tmp
next:
   movq  MM0, qword ptr [ESI]
   paddb MM0, qword ptr [EBX]
   movq  qword ptr [EDI], MM0
   add   ESI, 8
   add   EDI, 8
   add   EBX, 8
   dec   ECX
   jnz   next
   cmp   EDX, 0
   jz    exit
   mov   ECX, EDX
next1:
   mov   AL, byte ptr [ESI]
   add   AL, 20h
   mov   byte ptr [EDI], AL
   inc   ESI
   inc   EDI
   dec   ECX
   jnz   next1
 exit:
   lea   EAX, dst
   ret
 _paddb_ex endp
 end
