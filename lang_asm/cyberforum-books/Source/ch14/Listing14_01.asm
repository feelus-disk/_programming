.686
.model flat
.XMM
option casemap: none
.data
 res DB 16 DUP ('+'),0
.code
 _maskmovdqu_ex proc
  push       EBP
  mov        EBP, ESP
  mov        ESI, dword ptr [EBP+8]
  mov        EBX, dword ptr [EBP+12]
  lea        EDI, res
  movdqu     XMM0, [ESI]
  movdqu     XMM1, [EBX]
  maskmovdqu XMM0, XMM1
  lea        EAX, res
  pop        EBP
  ret
 _maskmovdqu_ex endp
 end
