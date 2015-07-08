.686
.model flat
option casemap: none
.data
 a1  DD -117.03, 8.04, -9.21, 5.16
 a2  DD -117.03, 8.04, -9.21, 5.16
 len EQU $-a2
 equals DB "Arrays are equal!", 0
 non_eq DB "Arrays are not equal!",0
.code
arrays_eq proc
  lea   ESI, a1
  lea   EDI, a2
  mov   ECX, len
  shr   ECX, 2
  finit
next:
  fld   dword ptr [ESI]
  fld   dword ptr [EDI]
  fcom
  fstsw AX
  sahf
  jne   n_eq
  add   ESI, 4
  add   EDI, 4
  dec   ECX
  jnz   next
  lea   EAX, equals
  jmp   exit
n_eq:
  lea   EAX, non_eq
exit:
  fwait
  ret
arrays_eq endp
end
