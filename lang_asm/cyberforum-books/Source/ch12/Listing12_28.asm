.686
.model flat
option casemap:none
.MMX
.data
  res DQ 0
.code
 _psllq_ex proc
   push  EBP
   mov   EBP, ESP
   movq  MM0, qword ptr [EBP+8]
   psllq MM0, qword ptr [EBP+16]
   movq  qword ptr res, MM0
   lea   EAX, res
   pop   EBP
   ret
 _psllq_ex endp
 _psrlq_ex proc
   push  EBP
   mov   EBP, ESP
   movq  MM0, qword ptr [EBP+8]
   psrlq MM0, qword ptr [EBP+16]
   movq  qword ptr res, MM0
   lea   EAX, res
   pop   EBP
   ret
 _psrlq_ex endp
 _psrad_ex proc
   push  EBP
   mov   EBP, ESP
   movq  MM0, qword ptr [EBP+8]
   psrad MM0, qword ptr [EBP+16]
   movq  qword ptr res, MM0
   lea   EAX, res
   pop   EBP
   ret
 _psrad_ex endp
 end
