.686
.model flat
.XMM
option casemap:none
.data
 pos_number DB "Number is positive!", 0
 neg_number DB "Number is negative!", 0
.code
 _movmskps_ex proc   ; check sign of elements
   push      EBP
   mov       EBP, ESP
   mov       ESI, dword ptr [EBP+8]
   mov       EDX, dword ptr [EBP+12]
   shl       EDX, 2
   add       ESI, EDX
   mov       ECX, dword ptr [EBP+16]
   movups    XMM0, [ESI]
   movmskps  EBX, XMM0
   bt        EBX, ECX
   jc        neg_res
   lea       EAX, pos_number
   jmp       exit
 neg_res:
   lea       EAX, neg_number
 exit:
   pop       EBP
   ret
 _movmskps_ex endp
 end
