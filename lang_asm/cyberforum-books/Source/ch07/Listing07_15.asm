.686
.model flat
option casemap: none
.data
  s_eq       DB "Strings are equal",0
  s_ne       DB "Strings are not equal",0
  size_diff  DB "Strings have different size !",0
.code
_cmpsb32 proc
  push  EBP
  mov   EBP, ESP
  mov   ESI, dword ptr [EBP+12] ; адрес строки-источника
  mov   EDX, ESI
  mov   EAX, 0
src_again:
  cmp   EAX, [ESI]
  je    check_dst
  inc   ESI
  jmp   src_again
check_dst:
  mov   EDI, dword ptr [EBP+8]  ; адрес строки-приемника
  mov   EBX, EDI
dst_again:
  cmp   EAX, [EDI]
  je    check_size
  inc   EDI
  jmp   dst_again
check_size:
  mov   ECX, ESI
  sub   ECX, EDX
  mov   EAX, EDI
  sub   EAX, EBX
  cmp   EAX, ECX
  je    compare
  lea   EAX, size_diff
  jmp   exit
compare:
  cld
  mov  ESI, EDX
  mov  EDI, EBX
  repe cmpsb
  je   equal
  lea  EAX, s_ne
  jmp  exit
equal:
  lea  EAX, s_eq
exit:
  pop  EBP
  ret
 _cmpsb32 endp
  end
