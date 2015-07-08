.686
.model flat
.XMM
option casemap:none
.data
  res  DW 8 DUP (0)
.code
_pshuf_lh_ex proc
  push    EBP
  mov     EBP, ESP
  mov     ESI, dword ptr [EBP+8]
  lea     EDI, res
  movdqu  XMM0, [ESI]
  pslldq  XMM0, 8
  movdqu  XMM1, [ESI]
  psrldq  XMM1, 8
  paddw   XMM1, XMM0
  pshuflw XMM1, XMM1, 1Bh
  pshufhw XMM1, XMM1, 1Bh
  movdqu  [EDI], XMM1
  pop     EBP
  lea     EAX, res
  ret
_pshuf_lh_ex endp
end
