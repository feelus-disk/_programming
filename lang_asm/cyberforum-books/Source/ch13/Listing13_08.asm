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
 _mulps_ex proc
  lea    ESI, a1
  lea    EDI, b1
  movups XMM0, [ESI]
  mulps  XMM0, [EDI]
  movups res, XMM0
  lea    EAX, res
  ret
_mulps_ex endp
 end
