.686
.model flat
option casemap: none
.data
 a1  DD -17.03, 0, 9.21, 0, -67.3
 len EQU $-a1
 a2  DD  5 DUP (0)
.code
sort_zero proc
  lea   ESI, a1
  lea   EDI, a2
  mov   ECX, len
  shr   ECX, 2
  finit
next:
  fld   dword ptr [ESI]
  ftst
  fstsw AX
  sahf
  je    skip
  fstp  dword ptr [EDI]
  add   EDI, 4
skip:
  add   ESI, 4
  dec   ECX
  jnz   next
  fwait
  lea   EAX, a2
  ret
sort_zero endp
end
