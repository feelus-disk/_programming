.686
.model flat
option casemap: none
.data
 src   DB "This string contains five words"
 len   EQU $-src
 cnt   DD 0
.code
 _count_b proc
   lea   ESI, src
   mov   ECX, len
   cld
   xor   EBX, EBX
 next:
   lodsb
   cmp   AL, 's'
   sete  BL
   add   cnt, EBX
   loop  next
   lea   EAX, cnt
   ret
 _count_b endp
 end
