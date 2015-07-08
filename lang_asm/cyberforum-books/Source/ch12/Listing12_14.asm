.686
.model flat
.MMX
option casemap: none
.data
 s1  DB '+++ ++++'
 s2  DB '32107654'
 res DB 16 DUP (' '),0
.code
 _punpckbw_ex proc
   lea       ESI, s1
   lea       EDI, s2
   lea       EBX, res
   movq      MM0, qword ptr [EDI]
   punpckhbw MM0, qword ptr [ESI]
   movq      qword ptr [EBX], MM0
   add       EBX, 8
   movq      MM0, qword ptr [EDI]
   punpcklbw MM0, qword ptr [ESI]
   movq      qword ptr [EBX], MM0
   lea       EAX, res
   ret
 _punpckbw_ex endp
 end
