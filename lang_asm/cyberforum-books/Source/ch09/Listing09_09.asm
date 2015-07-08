.686
.model flat
option casemap: none
.data
  a1  DD  56.78, -43.2, 0.0, 78.23, -12.2
  len EQU $-a1
  b1  DD  134.78, 67.45, -8.5, 32.18, -17.04
  res DD  len DUP (0)
.code
 fcmov_ex proc
   mov  ECX, len
   shr  ECX, 2
   lea  ESI, a1
   lea  EDI, b1
   lea  EDX, res
   finit
 next:
   fld  dword ptr [ESI]
   fld  dword ptr [EDI]
   fcomi st, st(1)
   fcmovb st,st(1)
   fstp dword ptr [EDX]
   add  ESI, 4
   add  EDI, 4
   add  EDX, 4
   dec  ECX
   jnz  next
   lea  EAX, res
   ret
  fcmov_ex endp
  end
