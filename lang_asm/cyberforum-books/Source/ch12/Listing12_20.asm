.686
.model flat
.MMX
option casemap: none
.data
 a1  DD 5893,-4592
 a2  DD 5275,5565
 res DQ 0
.code
 _pmaddwd_ex proc
   lea       ESI, a1
   lea       EDI, a2
   lea       EBX, res
   movq      MM0, qword ptr [ESI]
   pmaddwd   MM0, qword ptr [EDI]
   movq      qword ptr [EBX], MM0
   lea       EAX, res
   ret
 _pmaddwd_ex endp
 end
