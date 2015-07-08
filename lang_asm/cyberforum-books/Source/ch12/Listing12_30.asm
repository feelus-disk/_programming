.686
.model flat
.MMX
option casemap:none
.data
  a1  DW 45, -67, 23, 11
  b1  DW -671, 223, 3, 155
  res DQ 0 
.code
 pmaxsw_ex proc
   movq   MM0, qword ptr a1
   pmaxsw MM0, qword ptr b1
   movq   qword ptr res, MM0
   lea    EAX, res
   ret
 pmaxsw_ex endp
 end
