.686
.model flat
option casemap: none
.data
  supMMX DB 1
.code
 _test_mmx proc
   mov   EAX, 1
   cpuid
   test  EDX, 800000h
   jnz   exit
   mov   supMMX, 0
 exit:
   xor   EAX, EAX
   mov   AL, supMMX
   ret
 _test_mmx endp
 end
