.686
.model flat
option casemap: none
.data
  res  DD 0
.code
fscale_ex proc
  push  EBP
  mov   EBP, ESP
  fld   dword ptr [EBP+12] ; масштабирующий множитель -> st(1)
  fld   dword ptr [EBP+8]  ; число -> st(0)
  fscale
  fstp  dword ptr res
  lea   EAX, res
  pop   EBP
  ret
fscale_ex endp
end
