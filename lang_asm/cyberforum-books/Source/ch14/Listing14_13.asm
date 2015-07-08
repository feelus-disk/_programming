.686
.model flat
.XMM
option casemap: none
.data
  state_MXCSR DD 0
  res DD 2 DUP(0)
.code
 _cvtpd2pi_exgt proc
   push     EBP
   mov      EBP, ESP
   mov      ESI, dword ptr [EBP+8]
   stmxcsr  state_MXCSR
   or       word ptr state_MXCSR, 4000h
   ldmxcsr  state_MXCSR
   movups   XMM0, [ESI]
   cvtpd2pi MM0, XMM0
   movq     qword ptr res, MM0
   lea      EAX, res
   pop      EBP
   ret
  _cvtpd2pi_exgt endp
  end
