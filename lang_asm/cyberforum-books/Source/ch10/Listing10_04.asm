.686
.model flat
option casemap:none
.data
  res DD 0
.code
 example2 proc
  push EBP
  mov  EBP, ESP
  finit
  fld  dword ptr [EBP+8]
  fsub dword ptr [EBP+12]
  fstp dword ptr res
  lea  EAX, res
  pop  EBP
  ret  8
 example2 endp
 end
