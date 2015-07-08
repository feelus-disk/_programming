.686
.model flat
.MMX
option casemap: none
.data
 a1  label   qword
     DW 104, 106,100, 102
 a2  label   qword
     DW 105, 107, 101, 103
 res DD 4 DUP (0)
.code
 _punpckwd_ex proc
   lea       ESI, a1
   lea       EDI, a2
   lea       EBX, res
   movq      MM0, qword ptr [ESI]
   punpckhwd MM0, qword ptr [EDI]
   movq      qword ptr [EBX], MM0
   add       EBX, 8
   movq      MM0, qword ptr [ESI]
   punpcklwd MM0, qword ptr [EDI]
   movq      qword ptr [EBX], MM0
   lea       EAX, res
   ret
 _punpckwd_ex endp
 end
