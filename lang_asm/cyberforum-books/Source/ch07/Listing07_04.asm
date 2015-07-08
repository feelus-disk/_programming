.586
.model flat
option casemap:none
.data
 src        DB "ADDED CHARACHTERS"
 len_src    EQU $-src
 dst        DB "ORIGINAL CHARACHTERS"
 len_dst    EQU $-dst
 suppl      DB len_src DUP(' ')
.code
 _concat_strings proc
   cld
   lea  ESI, src
   lea  EDI, dst+len_dst
   mov  ECX, len_src
   rep  movsb
   lea  EAX, dst
   ret
 _concat_strings endp
  end
