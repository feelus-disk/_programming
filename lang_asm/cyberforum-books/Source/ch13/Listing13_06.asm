.686
.model flat
.XMM
option casemap:none
.data
 a1  DD 34.78, -56.07, -129.31, 94.2
 b1  DD -59.16, 44.93, -73.12, 19.61
 len EQU $-b1
 res DD  len DUP(0)
.code
 _addss_ex proc
  lea    ESI, a1
  lea    EDI, b1
  lea    EBX, res
  mov    ECX, len
  shr    ECX, 2
next:
  movd   XMM0, dword ptr [ESI]
  addss  XMM0, dword ptr [EDI]
  movd   dword ptr [EBX], XMM0
  add    ESI, 4
  add    EDI, 4
  add    EBX, 4
  dec    ECX
  jnz    next
  lea    EAX, res
  ret
_addss_ex endp
 end
