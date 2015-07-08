.686
.model flat
.XMM
option casemap: none
.data
 res DD 2 DUP(0)
.code
 _cvtpd2pi_ex proc
   push     EBP
   mov      EBP, ESP
   mov      ESI, dword ptr [EBP+8]
   movups   XMM0, [ESI]
   cvtpd2pi MM0, XMM0
   movq     qword ptr res, MM0
   lea      EAX, res
   pop      EBP
   ret
  _cvtpd2pi_ex endp
  end
