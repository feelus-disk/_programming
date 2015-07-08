.686
.model flat
option casemap: none
.data
 src  DD 37 DUP (?)
 len  EQU $-src
 val  DD 1.45
.code
 set_value proc
   finit
   mov  ECX, len
   shr  ECX, 2
   lea  ESI, src
   fld  dword ptr val
next:
   fst  dword ptr [ESI]
   add  ESI, 4
   dec  ECX
   jnz  next
   fincstp
   lea  EAX, src
   ret
 set_value endp
 end
