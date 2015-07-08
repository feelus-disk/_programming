.686
.model flat
.XMM
option casemap:none
.data
 a1  DD 0,2,4,6
 b1  DD 1,3,5,7
 len DD $-b1
 res DD 4 DUP(0)
.code
 _movhlps_ex proc
   movups  XMM0, a1
   movups  XMM1, b1
   movhlps XMM0, XMM1
   movups  res, XMM0
   lea     EAX, res
   ret
 _movhlps_ex endp
 _movlhps_ex proc
   movups  XMM0, a1
   movups  XMM1, b1
   movlhps XMM0, XMM1
   movups  res, XMM0
   lea     EAX, res
   ret
 _movlhps_ex endp
 end
