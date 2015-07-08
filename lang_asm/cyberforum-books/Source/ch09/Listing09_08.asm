.686
.model flat
option casemap:none
.data
  res DD 0
.code
fcomi_demo proc
  push  EBP
  mov   EBP, ESP
  finit
  fld   dword ptr [EBP+12]
  fld   dword ptr [EBP+8]
  fcomi st, st(1)
  ja    save_op1
  fxch  st(1)
save_op1:
  fstp  dword ptr res
  lea   EAX, res
  pop   EBP
  ret
fcomi_demo endp
end
