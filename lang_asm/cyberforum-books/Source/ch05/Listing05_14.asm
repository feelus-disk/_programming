.686
.model flat
option casemap: none
.data
  iarray DD 10 dup (7)
  len  EQU $-iarray
.code
_unr_1 proc
  lea  ESI, iarray
  mov  EBX, len
  shr  EBX, 2
  dec  EBX
  xor  EDX, EDX
next:
  mov  DWORD PTR [ESI], 0
  mov  DWORD PTR [ESI+4], 1
  add  EDX, 2
  cmp  EDX, EBX
  jae  exit
  add  ESI, 8
  jmp  next
exit:
  lea  EAX, iarray
  ret
 _unr_1 endp
 end
