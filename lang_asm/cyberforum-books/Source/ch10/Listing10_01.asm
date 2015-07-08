.686
.model flat
option casemap:none
.data
  res DD 0
.code
 example1 proc
  push EBP
  mov  EBP, ESP
  finit
  fild  dword ptr [EBP+8]
  fisub dword ptr [EBP+12]
  fistp dword ptr res
  mov   EAX, res
  pop   EBP
  ret   8
 example1 endp
 end
