.586
.model flat
option casemap:none
.data
 s1  DB "TEST STRING TO COPY"
 len EQU $-s1
 s2  DB len DUP(' ')
.code
 _cp_strings proc
   cld
   lea  ESI, s1
   lea  EDI, s2
   mov  ECX, len
   rep  movsb
   lea  EAX, s2
   ret
  _cp_strings endp
  end
