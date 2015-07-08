.686
.model flat
option casemap: none
.XMM
.data
 equal      DB "a1 = a2", 0
 not_equal  DB "a1 not equal a2", 0
.code
 _comiss_ex proc
  push   EBP
  mov    EBP, ESP
  mov    ESI, dword ptr [EBP+8]
  mov    EDI, dword ptr [EBP+12]
  movss  XMM0, [ESI] 
  comiss XMM0, [EDI]
  lahf
  and    AH, 45h
  cmp    AH, 40h
  je     ops_equal
  lea    EAX, not_equal
  jmp    exit
ops_equal:
  lea    EAX, equal
exit:
  pop    EBP
  ret
 _comiss_ex endp
 end
